# Extra-Questions:
# ----------------------------------------------------
#
#Q3. Please rate the magnitude to which the placement and/or efect of either electrode was disturbing during the task 
#    (e.g., feeling that the electrodes were dislocated, wet or cold feeling in the skin under the electrodes,
#    tingling or itching in the skin under the electrodes, etc.)!
#Q6. Please tell us if you think you were receiving real or fake (placebo) stimulation today!
#
library(tidyverse)
library(tidybayes)
source("analysis/cache_var.R")
library(brms)
library(bayesplot)
library(tidybayes)

theme_set(theme_bw())
options(mc.cores=parallel::detectCores())
bname<-tools::file_path_sans_ext(basename(this.file.name()))


# enabls --force 
options <- commandArgs(trailingOnly = TRUE)
if( "--force" %in% options)
  uncache.all(base = bname)

#stop()
qd <- readxl::read_xlsx("analysis/questionnaire_data.xlsx") %>%
  unite(subj, lab_code, subj_code,remove=F)

#========================
## function applied to every model for fitting and plotting
#========================

fit_and_plot <- function(mod.name,frm){
  #mod.name = formula.name.fname(frm)
  if(!is.cached.var(mod.name, base=bname)){
    mod <- brm(frm, data = qd, family =cumulative("probit"))
    assign(mod.name, mod, envir=.GlobalEnv)
    cache.var(mod.name, bname)
  } else {
    mod <- load.cache.var(mod.name,bname)
  }
  pdf(sprintf("analysis/pics/diag_%s.pdf", mod.name), width=5,height=5)
  mcmc_rhat(rhat(mod)) %>% print
  mcmc_neff(neff_ratio(mod)) %>% print
  dev.off()
  
  fit=mod
  nrep=100
  pred=predict(fit)
  
  qd %>%
    cbind(
      replicate(n=nrep, apply(pred, 1, function(x){sample(1:7,1, prob=x)})) 
    )   %>%
    gather(sim.n,sim.response, 26:(26+nrep-1)) %>%
    group_by(stim_setting,lab_code, sim.n) %>%
    do({
      tibble(response=1:7,n=tabulate(.$sim.response, nbins=7))
    }) -> qd.pred
  
  qd.tab <- qd %>% mutate(stim_setting=fct_recode(stim_setting, anodal="C", sham="B")) %>% 
    group_by(stim_setting, lab_code) %>%
    do({
      v=as.numeric(data.frame(.)[,fit$formula$resp])
      tibble(response=1:7,n=tabulate(v, nbins=7))
    })
  
  
  qd.pred %>% ungroup %>% mutate(stim_setting=fct_recode(stim_setting, anodal="C", sham="B")) %>%
    ggplot(aes(x=factor(response),y=n,color=stim_setting))+
    geom_bar(data=qd.tab, mapping=aes(fill=stim_setting), stat="identity",position = position_dodge(width=1), alpha=0.2)+
    #geom_violin(aes(group=interaction(stim_setting,response),color=NULL),fill="grey",color=0, alpha=1, position=position_dodge(width=1))+
    stat_summary(fun.data = mean_qi,  position=position_dodge(width=1), geom="pointrange")+
    #facet_wrap(~question,ncol=1) +
    facet_grid(lab_code~.) +
    labs(x="Response",y="Number of subjects",
         title=sprintf("%s: Posterior predictive", fit$formula$resp), 
         subtitle=toString(capture.output(fit$formula)))
  
  ggsave(sprintf("analysis/pics/ppred_%s.pdf", mod.name), width=9,height=6)
  return(mod)
}

#==========================================================================================
## Question 6 (blinding)
#==========================================================================================


#========================
## model definitions
#========================
models.q6 <- list(
  formula(q6~1),
  formula(q6~1+lab_code),
  formula(q6~1+stim_setting),
  formula(q6~1+imp_start),
  formula(q6~1+stim_setting+lab_code),
  formula(q6~1+stim_setting+imp_start),
  formula(q6~1+lab_code+imp_start),
  formula(q6~1+lab_code+stim_setting+imp_start),
  formula(q6~1+stim_setting*lab_code+imp_start),
  formula(q6~1+stim_setting*lab_code*imp_start),
  formula(bf(q6~1+stim_setting+lab_code)+
            lf(disc ~ 0+lab_code, cmc=F)),
  formula(bf(q6~1+stim_setting+lab_code)+
            lf(disc ~ 0+stim_setting, cmc=F))
)

description=c("Null", "Lab", "Stim(ulation)", "Imp(edance)", "Stim+Lab", "Stim+Imp", "Lab+Imp", "Lab+Stim+Imp", "Stim$\\times$Lab+Imp", "Stim$\\times$Lab$\\times$Imp",  "Stim+Lab", "Stim+Lab")

names(models.q6) <- sprintf("mod%02i.q6", 0:(length(models.q6)-1))
#========================
## fit models
#========================
library(parallel)
#models.fitted=map(models, fit_and_plot)
#models.fitted=mclapply(models, fit_and_plot, mc.cores = 4)
#models.fitted=map2(names(models), models, fit_and_plot)
models.fitted.q6=mcmapply(fit_and_plot, names(models.q6), models.q6, mc.cores = 3, SIMPLIFY = FALSE)


#========================
## model-selection
#========================
loo_wrapper <- function(...) {
  dots <- list(...)
  if (!"x" %in% names(dots)) {
    names(dots)[1] <- "x"
  }
  do.call(brms::loo, dots)
}

#uncache.var("loo.q6", base=bname)
loo.q6=if.cached.load("loo.q6",
                      invoke(loo_wrapper, .x = models.fitted.q6, model_names = names(models.fitted.q6)),
                      base=bname)

sink("analysis/output/modsel.q6.log")
print(loo.q6)
as.data.frame(loo.q6$ic_diffs__) %>% rownames_to_column() %>% 
  mutate(z=LOOIC/SE) %>% print

sink(NULL)

#========================
## Summary table 
#========================

## anodal coefficient for all models
map2_df(names(models.fitted.q6), models.fitted.q6, function(modname, mod){
  if("stim_settingC" %in% rownames(fixef(mod)) ){
    coeffs=as.list(fixef(mod)["stim_settingC",])
  } else {
    coeffs=rep(NA,4)
    names(coeffs) <- colnames(fixef(mod))
  }
  c(list(model=modname), coeffs)# formula=toString(capture.output(mod$formula))), coeffs)
}) %>%
  mutate(LOOIC=map_dbl(head(loo.q6,-1), function(obj) {obj$estimates[3,1]}),
         SE.loo=map_dbl(head(loo.q6,-1), function(obj) {obj$estimates[3,2]})) -> coeff.tab

coeff.tab

library(kableExtra)
viewer <- getOption("viewer")
options(knitr.kable.NA = '--')

coeff.tab %>%
  mutate(HDI=if_else(is.na(Estimate), "--", sprintf("$[%.2f,%.2f]$", `Q2.5`, `Q97.5`))) %>%
  mutate(model=0:(n()-1), description=description) %>%
  select(-`Q2.5`,-`Q97.5`) %>%
  select(Model=model,
         Description=description,
         `$b$`=Estimate,
         `SE(b)`=`Est.Error`,
         `95 HDI`=HDI,
         LOOIC=LOOIC,
         `SE(LOO)`=SE.loo) -> tab
names(tab)[3]<- paste0(names(tab)[3], footnote_marker_alphabet(1, "latex"))
names(tab)[4]<- paste0(names(tab)[4], footnote_marker_alphabet(2, "latex"))
names(tab)[5]=paste0("95\\% HDI", footnote_marker_alphabet(3, "latex"))
names(tab)[6]<- paste0(names(tab)[6], footnote_marker_alphabet(4, "latex"))
tab%>%
  knitr::kable(digits = 2, escape = F, format = "latex", align=c("l", "l", "c", "c", "l", "c", "c"), booktabs=T, caption = "\\label{tab:q6}Summary of models for the blinding question.") %>%
  kable_styling(font_size = 9, full_width = T, latex_options=c("striped", "scale_down"), position="center")  %>%
  column_spec(2,width="2.5cm") %>%
  column_spec(5,width="2cm") %>%
  column_spec(7,width="1.5cm") %>%
  group_rows("equal variances", 2,10, bold = F, italic = T) %>%
  group_rows("unequal variances lab", 11,11, bold=F, italic=T) %>%
  group_rows("unequal variances stimulation", 12,12, bold=F, italic=T) %>%
  add_header_above(c(" " = 2, "Stimulation Effect" = 3, "LOO" = 2)) %>%
  footnote(alphabet=c("Effect of anodal stimulation on 7-point scale",
                    "SE=standard error",
                    "HDI=Highest Density Interval",
                    "LOOIC=Leave-One-Out Information Criterion")) -> tab.tex

write(tab.tex, file="supp_tab_q6.tex")

#tab.tex%>%
#  kable_as_image(file_format = "pdf", keep_tex = F) %>% viewer 

#==========================================================================================
## Question 3 (blinding)
#==========================================================================================


#========================
## model definitions
#========================
models.q3 <- list(
  formula(q3~1),
  formula(q3~1+lab_code),
  formula(q3~1+stim_setting),
  formula(q3~1+imp_start),
  formula(q3~1+stim_setting+lab_code),
  formula(q3~1+stim_setting+imp_start),
  formula(q3~1+lab_code+imp_start),
  formula(q3~1+lab_code+stim_setting+imp_start),
  formula(q3~1+stim_setting*lab_code+imp_start),
  formula(q3~1+stim_setting*lab_code*imp_start),
  formula(bf(q3~1+stim_setting+lab_code)+
            lf(disc ~ 0+lab_code, cmc=F)),
  formula(bf(q3~1+stim_setting+lab_code)+
            lf(disc ~ 0+stim_setting, cmc=F))
)

description=c("Null", "Lab", "Stim(ulation)", "Imp(edance)", "Stim+Lab", "Stim+Imp", "Lab+Imp", "Lab+Stim+Imp", "Stim$\\times$Lab+Imp", "Stim$\\times$Lab$\\times$Imp",  "Stim+Lab", "Stim+Lab")

names(models.q3) <- sprintf("mod%02i.q3", 0:(length(models.q3)-1))
#========================
## fit models
#========================
library(parallel)
#models.fitted=map(models, fit_and_plot)
#models.fitted=mclapply(models, fit_and_plot, mc.cores = 4)
#models.fitted=map2(names(models), models, fit_and_plot)
models.fitted.q3=mcmapply(fit_and_plot, names(models.q3), models.q3, mc.cores = 3, SIMPLIFY = FALSE)


#========================
## model-selection
#========================
loo_wrapper <- function(...) {
  dots <- list(...)
  if (!"x" %in% names(dots)) {
    names(dots)[1] <- "x"
  }
  do.call(brms::loo, dots)
}

#uncache.var("loo.q3", base=bname)
loo.q3=if.cached.load("loo.q3",
                      invoke(loo_wrapper, .x = models.fitted.q3, model_names = names(models.fitted.q3)),
                      base=bname)

sink("analysis/output/modsel.q3.log")
print(loo.q3)
as.data.frame(loo.q3$ic_diffs__) %>% rownames_to_column() %>% 
  mutate(z=LOOIC/SE) %>% print

sink(NULL)

#========================
## Summary table 
#========================

## anodal coefficient for all models
map2_df(names(models.fitted.q3), models.fitted.q3, function(modname, mod){
  if("stim_settingC" %in% rownames(fixef(mod)) ){
    coeffs=as.list(fixef(mod)["stim_settingC",])
  } else {
    coeffs=rep(NA,4)
    names(coeffs) <- colnames(fixef(mod))
  }
  c(list(model=modname), coeffs)# formula=toString(capture.output(mod$formula))), coeffs)
}) %>%
  mutate(LOOIC=map_dbl(head(loo.q3,-1), function(obj) {obj$estimates[3,1]}),
         SE.loo=map_dbl(head(loo.q3,-1), function(obj) {obj$estimates[3,2]})) -> coeff.tab

coeff.tab

library(kableExtra)
viewer <- getOption("viewer")
options(knitr.kable.NA = '--')

coeff.tab %>%
  mutate(HDI=if_else(is.na(Estimate), "--", sprintf("$[%.2f,%.2f]$", `Q2.5`, `Q97.5`))) %>%
  mutate(model=0:(n()-1), description=description) %>%
  select(-`Q2.5`,-`Q97.5`) %>%
  select(Model=model,
         Description=description,
         `$b$`=Estimate,
         `SE(b)`=`Est.Error`,
         `95 HDI`=HDI,
         LOOIC=LOOIC,
         `SE(LOO)`=SE.loo) -> tab
names(tab)[3]<- paste0(names(tab)[3], footnote_marker_alphabet(1, "latex"))
names(tab)[4]<- paste0(names(tab)[4], footnote_marker_alphabet(2, "latex"))
names(tab)[5]=paste0("95\\% HDI", footnote_marker_alphabet(3, "latex"))
names(tab)[6]<- paste0(names(tab)[6], footnote_marker_alphabet(4, "latex"))
tab%>%
  knitr::kable(digits = 2, escape = F, format = "latex", align=c("l", "l", "c", "c", "l", "c", "c"), booktabs=T, caption = "\\label{tab:q3}Summary of models for the discomfort question.") %>%
  kable_styling(font_size = 9, full_width = T, latex_options=c("striped", "scale_down"), position="center")  %>%
  column_spec(2,width="2.5cm") %>%
  column_spec(5,width="2cm") %>%
  column_spec(7,width="1.5cm") %>%
  group_rows("equal variances", 2,10, bold = F, italic = T) %>%
  group_rows("unequal variances lab", 11,11, bold=F, italic=T) %>%
  group_rows("unequal variances stimulation", 12,12, bold=F, italic=T) %>%
  add_header_above(c(" " = 2, "Stimulation Effect" = 3, "LOO" = 2)) %>%
  footnote(alphabet=c("Effect of anodal stimulation on 7-point scale",
                      "SE=standard error",
                      "HDI=Highest Density Interval",
                      "LOOIC=Leave-One-Out Information Criterion")) -> tab.tex


write(tab.tex, file="supp_tab_q3.tex")

tab.tex%>%
  kable_as_image(file_format = "pdf", keep_tex = F) %>% viewer 


#==========================================================================================
## IMPEDANCE changes
#==========================================================================================

qd %>% 
  mutate(stimulation=case_when( stim_setting=="B" ~ "sham",
                                stim_setting=="C" ~ "anodal")) %>%
  ggplot(aes(stimulation, imp_start,color=stimulation))+
  geom_boxplot()+
  geom_jitter(width=0.1)+
  stat_summary(fun.data=mean_cl_boot, color="black")+
  facet_wrap(~lab_code)+guides(color=F)+
  labs(x="Stimulation", y="Impedance")
ggsave("pics/impedance.png", width=6, height=2.5)

library(BayesFactor)
result=anovaBF(imp_start~stim_setting*lab_code,data=data.frame(qd) %>% mutate(stim_setting=as.factor(stim_setting), lab_code=as.factor(lab_code)))

qd %>%
  group_by(lab_code) %>%
  summarise(mean(imp_start), sd(imp_start))

qd %>%
  group_by(stim_setting) %>%
  summarise(mean(imp_start), sd(imp_start))
