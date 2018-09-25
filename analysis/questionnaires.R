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

fit3b.q6 <-if.cached.load("fit3b.q6", 
                          brm(formula = bf(q6~1+stim_setting*lab_code)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit3b.q6)

loo(fit1.q6, fit1b.q6, fit2.q6, fit2b.q6, fit3.q6, fit3b.q6)


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

loo(fit1.q3, fit2.q3, fit3.q3)

# uneq variances
fit1b.q3 <-if.cached.load("fit1b.q3", 
                          brm(formula = bf(q3~1+stim_setting)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit1b.q3)

fit2b.q3 <-if.cached.load("fit1b.q6", 
                          brm(formula = bf(q3~1+stim_setting+lab_code)+
                                lf(disc ~ 0+stim_setting, cmc=F),
                          data = qd,family =cumulative("probit")),
                          base=bname)
summary(fit2b.q3)


fit3b.q3 <-if.cached.load("fit1b.q6", 
                          brm(formula = bf(q3~1+stim_setting*lab_code)+
                               lf(disc ~ 0+stim_setting, cmc=F),
                         data = qd,family =cumulative("probit")),
                         base=bname)
summary(fit3b.q3)


loo(fit1.q3, fit1b.q3, fit2.q3, fit2b.q3, fit3.q3, fit3b.q3)


## Q3+Q6 model
qd %>% select(subj,lab_code,stim_setting, q3, q6) %>%
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

conditions=expand.grid( c("AMS","GOE","TRM"), c("q3","q6")) %>%
  setNames(c("lab_code","question")) %>%
  mutate(cond__=paste(question,lab_code,sep=" "))
marginal_effects(fit3.q36, "stim_setting", conditions=conditions, categorical=T)
summary(fit3.q36)

loo(fit1.q36, fit1.q36b, fit2.q36, fit2.q36b)
loo(fit2.q36, fit2.q36b, fit3.q36)

#                     LOOIC    SE
# fit2.q36             1312.35 26.40
# fit2.q36b            1282.26 29.32
# fit3.q36             1277.24 28.59
# fit2.q36 - fit2.q36b   30.10 16.04
# fit2.q36 - fit3.q36    35.11 17.89
# fit2.q36b - fit3.q36    5.02  6.66

## other analyses 
#--------------------------------------------------------------------

t.test(q6 ~ stim_setting, data=qd)
t.test(q6 ~ stim_setting, data=qd[qd$lab_code=="AMS",])
t.test(q6 ~ stim_setting, data=qd[qd$lab_code=="TRM",])
t.test(q6 ~ stim_setting, data=qd[qd$lab_code=="GOE",])

library(ez)
ezANOVA(qd,
        q6,
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
  gather(q, n, q3, q6) %>%
  ggplot(aes(level,n,fill=stim_setting))+geom_bar(stat="identity", position = position_dodge())+facet_grid(q~.)
 
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

