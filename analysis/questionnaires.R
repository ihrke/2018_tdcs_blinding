# Extra-Questions:
# ----------------------------------------------------
#
#Q1. When your thoughts were not related to the task, what were you thinking of?
#Q2. Please rate the magnitude to which you were thinking about the task (e.g., 
#    how easy or difcult it is, how good you are at it, what is the purpose of the task, etc.) 
#    when your attention was not fully focused on performing the task!
#Q3. Please rate the magnitude to which the placement and/or efect of either electrode was disturbing during the task 
#    (e.g., feeling that the electrodes were dislocated, wet or cold feeling in the skin under the electrodes,
#    tingling or itching in the skin under the electrodes, etc.)!
#Q4. Please rate the magnitude to which you were distracted by external stimuli 
#    (e.g., noises or sights of objects in the lab, body sensations such as back pain 
#    or feeling thirsty, etc.) during performing the task! Please do not regard the 
#    direct efects of transcranial brain stimulation (e.g., tingling in the skin under 
#    the electrodes) as “external stimulus“ here!
#Q5. Please rate the magnitude to which you were thinking about personal issues 
#    (e.g., past memories, future plans, recent concerns about everyday life, 
#    thinking aboutrelationships with others, etc.) when your attention was 
#    not fully focused on performing the task!
#Q6. Please tell us if you think you were receiving real or fake (placebo) stimulation today!
#
library(tidyverse)
library(tidybayes)
source("analysis/cache_var.R")
library(brms)
theme_set(theme_bw())
options(mc.cores=parallel::detectCores())

bname<-tools::file_path_sans_ext(basename(this.file.name()))
stop()
qd <- readxl::read_xlsx("analysis/questionnaire_data.xlsx") %>%
  unite(subj, lab_code, subj_code,remove=F)


## blinding with ordinal model

## Q6
fit1.q6 <- if.cached.load("fit1.q6", 
                          brm(formula = q6~1+stim_setting,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit1.q6)

fit2.q6 <-if.cached.load("fit2.q6", 
                         brm(formula = q6~1+stim_setting+lab_code,data = qd,family =cumulative("probit")),
                         base=bname)
summary(fit2.q6)
loo(fit1.q6, fit2.q6)


fit3.q6 <-if.cached.load("fit3.q6", 
                         brm(formula = q6~1+stim_setting*lab_code,data = qd,family =cumulative("probit")),
                         base=bname)
summary(fit3.q6)

loo(fit1.q6, fit2.q6, fit3.q6)

# uneq variances
fit1b.q6 <-if.cached.load("fit1b.q6", 
                          brm(formula = bf(q6~1+stim_setting)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                              data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit1b.q6)

fit2b.q6 <-if.cached.load("fit2b.q6",
                          brm(formula = bf(q6~1+stim_setting+lab_code)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit2b.q6)

fit2c.q6 <-if.cached.load("fit2c.q6",
                          brm(formula = bf(q6~1+stim_setting+lab_code)+
                                lf(disc ~ 0+lab_code, cmc=F),
                              data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit2c.q6)

fit3b.q6 <-if.cached.load("fit3b.q6", 
                          brm(formula = bf(q6~1+stim_setting*lab_code)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit3b.q6)

mods=list(fit1.q6, fit1b.q6, fit2.q6, fit2b.q6,fit2c.q6, fit3.q6, fit3b.q6)

loo.1.q6 <- if.cached.load("loo.1.q6",
                           do.call(loo, mods),
                            #loo(fit1.q6, fit1b.q6, fit2.q6, fit2b.q6,fit2c.q6, fit3.q6, fit3b.q6),
                           base=bname)

## anodal coefficient for all models
map_df(mods, function(mod){
  c(list(model=toString(capture.output(mod$formula))), 
    as.list(fixef(mod)["stim_settingC",]))
  }) %>%
  mutate(model=sprintf("`%s`",model)) -> coeff

knitr::kable(coeff)

coeff %>%
  mutate(LOOIC=map_dbl(head(loo.1.q6,-1), function(obj) {obj$estimates[3,1]}),
         `SE(LOOIC)`=map_dbl(head(loo.1.q6,-1), function(obj) {obj$estimates[3,2]}))

as.data.frame(loo.1.q6$ic_diffs__) %>% rownames_to_column() %>% 
  mutate(z=LOOIC/SE)
# 
#                     LOOIC    SE
# fit1.q6             688.14 17.13
# fit1b.q6            688.88 17.41
# fit2.q6             686.51 16.98
# fit2b.q6            687.60 17.14
# fit2c.q6            685.45 18.01
# fit3.q6             690.58 17.04
# fit3b.q6            691.50 17.24

## control for impedance
fit4.q6 <- if.cached.load("fit4.q6", 
                          brm(formula = q6~1+imp_start,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit4.q6)

fit5.q6 <- if.cached.load("fit5.q6", 
                          brm(formula = q6~1+stim_setting+imp_start,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit5.q6)

fit6.q6 <- if.cached.load("fit6.q6", 
                          brm(formula = q6~1+stim_setting+lab_code+imp_start,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit6.q6)

## Q3
fit1.q3 <-if.cached.load("fit1.q3", 
                         brm(formula = q3~1+stim_setting,data = qd,family =cumulative("probit")),
                         base=bname)
summary(fit1.q3)

fit2.q3 <-if.cached.load("fit2.q3", 
                         brm(formula = q3~1+stim_setting+lab_code,data = qd,family =cumulative("probit")),
                         base=bname)
summary(fit2.q3)

fit3.q3 <- if.cached.load("fit3.q3", 
                          brm(formula = q3~1+stim_setting*lab_code,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit3.q3)


fit4.q3 <- if.cached.load("fit4.q3", 
                          brm(formula = q3~1+imp_start,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit4.q3)

fit5.q3 <- if.cached.load("fit5.q3", 
                          brm(formula = q3~1+stim_setting+imp_start,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit5.q3)

fit6.q3 <- if.cached.load("fit6.q3", 
                          brm(formula = q3~1+stim_setting+lab_code+imp_start,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit6.q3)

loo.1.q3=if.cached.load("loo.1.q3",
               loo(fit1.q3, fit2.q3, fit3.q3, fit4.q3, fit5.q3, fit6.q3),
               base=bname)

#                   LOOIC    SE
# fit1.q3           635.27 20.55
# fit2.q3           627.22 19.62
# fit3.q3           629.68 20.02
# fit4.q3           635.73 20.04
# fit5.q3           634.60 20.33
# fit6.q3           626.26 19.30

ps=list(plot.post.pred(fit1.q3),
        plot.post.pred(fit2.q3),
        plot.post.pred(fit3.q3),
        plot.post.pred(fit4.q3),
        plot.post.pred(fit5.q3),
        plot.post.pred(fit6.q3))
pdf("analysis/postpred3.1.pdf", width=9,height=6)
print(ps)
dev.off()


# uneq variances
fit1b.q3 <-if.cached.load("fit1b.q3", 
                          brm(formula = bf(q3~1+stim_setting)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit1b.q3)

fit2b.q3 <-if.cached.load("fit2b.q3", 
                          brm(formula = bf(q3~1+stim_setting+lab_code)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit2b.q3)


fit3b.q3 <-if.cached.load("fit3b.q3", 
                          brm(formula = bf(q3~1+stim_setting*lab_code)+
                               lf(disc ~ 0+stim_setting, cmc=F),
                         data = qd,family =cumulative("probit")),
                         base=bname)
summary(fit3b.q3)

fit4b.q3 <-if.cached.load("fit4b.q3", 
                          brm(formula = bf(q3~1+imp_start)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                              data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit4b.q3)

fit5b.q3 <-if.cached.load("fit5b.q3", 
                          brm(formula = bf(q3~1+imp_start+stim_setting)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                              data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit5b.q3)

fit6b.q3 <-if.cached.load("fit6b.q3", 
                          brm(formula = bf(q3~1+imp_start+stim_setting+lab_code)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                              data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit6b.q3)


loo.2.q3=if.cached.load("loo.2.q3",
                        loo(fit1b.q3, fit2b.q3, fit3b.q3, fit4b.q3, fit5b.q3, fit6b.q3),
                        base=bname)

#                     LOOIC    SE
# fit1b.q3            637.56 20.72
# fit2b.q3            629.60 19.76
# fit3b.q3            632.08 20.17
# fit4b.q3            638.48 20.30
# fit5b.q3            636.62 20.47
# fit6b.q3            628.18 19.34

ps=list(plot.post.pred(fit1b.q3),
        plot.post.pred(fit2b.q3),
        plot.post.pred(fit3b.q3),
        plot.post.pred(fit4b.q3),
        plot.post.pred(fit5b.q3),
        plot.post.pred(fit6b.q3))
pdf("analysis/postpred3.2.pdf", width=9,height=6)
print(ps)
dev.off()

## Q3+Q6 model
qd %>% select(subj,lab_code,stim_setting, imp_start, q3, q6) %>%
  gather(question,response,q3,q6) -> qd.long

fit1.q36 <-if.cached.load("fit1.q36", 
                          brm(formula = response~1+stim_setting+(1|subj)+(1|question),
                          data = qd.long, family =cumulative("probit"), iter = 5000), 
                        base=bname)
summary(fit1.q36)

fit1.q36b <-if.cached.load("fit1.q36b", 
                           brm(formula = response~1+question+stim_setting+(1|subj),
                          data = qd.long, family =cumulative("probit"), iter = 2000),
                          base=bname)

fit2.q36 <-if.cached.load("fit2.q36", 
                           brm(formula = response~1+question+lab_code+stim_setting+(1|subj),
                               data = qd.long, family =cumulative("probit"), iter = 2000),
                           base=bname)
summary(fit2.q36)

fit2.q36b <-if.cached.load("fit2.q36b", 
                          brm(formula = bf(response~1+question+lab_code+stim_setting+(1|subj))+
                                        lf(disc ~ 0 + lab_code, cmc=F),
                              data = qd.long, family =cumulative("probit"), iter = 2000),
                          base=bname)
summary(fit2.q36b)

fit3.q36 <-if.cached.load("fit3.q36", 
                           brm(formula = bf(response~1+question*lab_code+stim_setting+(1|subj))+
                                 lf(disc ~ 0 + lab_code, cmc=F),
                               data = qd.long, family =cumulative("probit"), iter = 2000),
                           base=bname)


# full IA
fit3b.q36 <-if.cached.load("fit3b.q36", 
                          brm(formula = bf(response~1+question*lab_code*stim_setting+(1|subj))+
                                lf(disc ~ 0 + lab_code, cmc=F),
                              data = qd.long, family =cumulative("probit"), iter = 2000),
                          base=bname)
summary(fit3b.q36)

# impedance?
fit4.q36 <-if.cached.load("fit4.q36", 
                          brm(formula = bf(response~1+question*lab_code+imp_start+stim_setting+(1|subj))+
                                lf(disc ~ 0 + lab_code, cmc=F),
                              data = qd.long, family =cumulative("probit"), iter = 2000),
                          base=bname)
summary(fit4.q36)


conditions=expand.grid( c("AMS","GOE","TRM"), c("q3","q6")) %>%
  setNames(c("lab_code","question")) %>%
  mutate(cond__=paste(question,lab_code,sep=" "))
marginal_effects(fit3.q36, "stim_setting", conditions=conditions, categorical=T)
summary(fit3.q36)

loo(fit1.q36, fit1.q36b, fit2.q36, fit2.q36b)
loo(fit2.q36, fit2.q36b, fit3.q36, fit3b.q36, fit4.q36)

#                         LOOIC    SE
# fit2.q36              1312.35 26.40
# fit2.q36b             1281.13 28.63
# fit3.q36              1275.88 27.69
# fit3b.q36             1287.32 30.74
# fit2.q36 - fit2.q36b    31.22 15.21
# fit2.q36 - fit3.q36     36.48 16.96
# fit2.q36 - fit3b.q36    25.04 20.82
# fit2.q36b - fit3.q36     5.25  6.69
# fit2.q36b - fit3b.q36   -6.19  9.26
# fit3.q36 - fit3b.q36   -11.44  6.44

# function to plot models that have just one question
plot.post.pred <- function(fit, nrep=100) {
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
}
# function to plot models that combine questions 3 and 6
plot.post.pred.36 <- function(fit, nrep=100) {
  pred=predict(fit)
  
  qd.long %>%
    cbind(
      replicate(n=nrep, apply(pred, 1, function(x){sample(1:7,1, prob=x)})) 
    ) %>%
    gather(sim.n,sim.response, -subj,-lab_code,-stim_setting,-question,-response) %>%
    group_by(stim_setting,question,lab_code, sim.n) %>%
    do({
      tibble(response=1:7,n=tabulate(.$sim.response, nbins=7))
    }) -> qd.pred
  
  qd.tab <- qd.long %>% mutate(stim_setting=fct_recode(stim_setting, anodal="C", sham="B")) %>%
    group_by(stim_setting, lab_code, question) %>%
    do({
      tibble(response=1:7,n=tabulate(.$response, nbins=7))
    })
    
  
  qd.pred %>% ungroup %>% mutate(stim_setting=fct_recode(stim_setting, anodal="C", sham="B")) %>%
    ggplot(aes(x=factor(response),y=n,color=stim_setting))+
    geom_bar(data=qd.tab, mapping=aes(fill=stim_setting), stat="identity",position = position_dodge(width=1), alpha=0.2)+
    #geom_violin(aes(group=interaction(stim_setting,response),color=NULL),fill="grey",color=0, alpha=1, position=position_dodge(width=1))+
    stat_summary(fun.data = mean_qi,  position=position_dodge(width=1), geom="pointrange")+
    #facet_wrap(~question,ncol=1) +
    facet_grid(lab_code~question) +
    labs(x="Response",y="Number of subjects",title="Posterior predictive", subtitle=toString(capture.output(fit$formula)))
}

ps=list(plot.post.pred.36(fit1.q36),
        plot.post.pred.36(fit1.q36b),
        plot.post.pred.36(fit2.q36),
        plot.post.pred.36(fit2.q36b),
        plot.post.pred.36(fit3.q36),
        plot.post.pred.36(fit3b.q36),
        plot.post.pred.36(fit4.q36))
pdf("analysis/postpred36.pdf", width=9,height=6)
print(ps)
dev.off()


summary(mod<-lm(q3 ~ imp_start, data=qd))
qd %>%
  ggplot(aes(y=imp_start,x=q3))+geom_jitter(width=0.1)+geom_smooth(method="lm")

## other analyses 
#--------------------------------------------------------------------

## impedance between labs and stim vs. sham
t.test(imp_start ~ stim_setting, data=qd)

qd %>%
  ggplot(aes(stim_setting, imp_start,color=stim_setting))+geom_violin()+geom_jitter(width=0.1)+stat_summary(fun.data=mean_cl_boot)+facet_wrap(~lab_code)



qd %>%
  ggplot(aes(stim_setting, imp_start,color=stim_setting))+
  geom_boxplot()+
  geom_jitter(width=0.1)+
  stat_summary(fun.data=mean_cl_boot, color="black")+
  facet_wrap(~lab_code)

library(BayesFactor)
result=anovaBF(imp_start~stim_setting*lab_code,data=data.frame(qd) %>% mutate(stim_setting=as.factor(stim_setting), lab_code=as.factor(lab_code)))

write.table(qd, file="analysis/questionnaire_data.csv", row.names = F, sep=",")

mod=brm(imp_start~stim_setting*lab_code, data=qd)
summary(mod)
marginal_effects(mod)
plot(mod)

qd %>%
  ggplot(aes( q3, imp_start, color=stim_setting))+geom_jitter(width=0.1)+geom_smooth(method="lm")

# relationship impedance and q3/q6 overall?
fit.imp <- if.cached.load("fit.imp", 
                          brm(formula = q3~1+imp_start*lab_code,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit.imp)
bayesplot::mcmc_intervals(as.matrix(fit.imp), regex_pars = "b_*")

fit.imp.q6 <- if.cached.load("fit.imp.q6", 
                          brm(formula = q6~1+imp_start*lab_code,data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit.imp.q6)
bayesplot::mcmc_intervals(as.matrix(fit.imp.q6), regex_pars = "b_*")

## ANOVA impedance
summary(aov(imp_start ~ stim_setting*lab_code, data=qd))

summary(aov(imp_start ~ as.numeric(subj_code)*lab_code*stim_setting, data=qd))

qd %>%
  ggplot(aes(as.numeric(subj_code), imp_start,color=lab_code))+geom_point()+geom_smooth(method="lm")+facet_wrap(~stim_setting)

## plain t-tests
t.test(q6 ~ stim_setting, data=qd)
effsize::cohen.d(q6 ~ stim_setting, data=qd)
t.test(q3 ~ stim_setting, data=qd)
effsize::cohen.d(q3 ~ stim_setting, data=qd)

t.test(q6 ~ stim_setting, data=qd[qd$lab_code=="AMS",])
t.test(q6 ~ stim_setting, data=qd[qd$lab_code=="TRM",])
t.test(q6 ~ stim_setting, data=qd[qd$lab_code=="GOE",])

library(ez)
ezANOVA(qd,
        q6,
        wid=subj,
        between=.(stim_setting,lab_code))

ezANOVA(qd,
        q3,
        wid=subj,
        between=.(stim_setting,lab_code))

## Q3/Q6 histograms
qd %>%
  group_by(stim_setting) %>%
  do({
    tibble(
      stim_setting=first(.$stim_setting),
      level=1:7,
      q3=tabulate(.$q3, nbins=7),
      q6=tabulate(.$q6, nbins=7),
    )
  }) %>%
  gather(q, n, q3, q6) -> d3


d3 %>%
  group_by(q, stim_setting) %>%
  summarise(less=sum(n[level<4]),
            more=sum(n[level>4]), more/less, mean(level))

qd %>% group_by(stim_setting) %>%
  summarize(mean(q3))
mean(qd$q3)
sd(qd$q3)
d3 %>%
  ggplot(aes(level,n,fill=stim_setting))+geom_bar(stat="identity", position = position_dodge())+facet_grid(q~.)
 

d3 %>% group_by(stim_setting, q) %>%
  mutate(perc=n/96*100) %>%
  mutate(cperc=cumsum(perc), cn=cumsum(n)) %>%
  ungroup %>%
  ggplot(aes(level,cn,fill=stim_setting))+geom_bar(stat="identity", position = position_dodge())+facet_wrap(~q)

## Correlations Q3/Q6?
mod <- lm(q6 ~ q3*stim_setting, data=qd)
summary(mod)


qd %>%
  ggplot(aes(q3,q6,color=stim_setting))+
  geom_jitter(width=0.1,height=0.1)+geom_smooth(method="lm")

rb=with(qd[qd$stim_setting=="B",],
     cor(q3,q6))
rc=with(qd[qd$stim_setting=="C",],
        cor(q3,q6))
zb=psych::fisherz(rb)
zc=psych::fisherz(rc)
pnorm( (zb-zc)/(sqrt(2/(93))) )



# gender ------------------------------------------------------------------

qd %>% group_by(lab_code) %>%
  summarize(nmale=sum(gender==1),
            mean(age), sd(age), min(age), max(age)) -> tab
xtable::xtable(tab)

qd %>% 
  summarize(nmale=sum(gender==1),
            mean(age), sd(age), min(age), max(age)) -> tab

