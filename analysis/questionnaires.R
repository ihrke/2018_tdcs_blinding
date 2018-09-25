source("secret_codebook.R")
source("load_data.R")

qd <- readxl::read_xlsx("data/questionnaire_data.xlsx") %>%
  unite(subj, lab_code, subj_code,remove=F)


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

## blinding with ordinal model

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

#install.packages("brms")
library(brms)

## Q6
fit1.q6 <-brm(formula = q6~1+stim_setting,data = qd,family =cumulative("probit"))
summary(fit1.q6)
marginal_effects(fit1.q6, "stim_setting", categorical = T)

fit2.q6 <-brm(formula = q6~1+stim_setting+lab_code,data = qd,family =cumulative("probit"))
summary(fit2.q6)
marginal_effects(fit2.q6, categorical = T)

fit3.q6 <-brm(formula = q6~1+stim_setting*lab_code,data = qd,family =cumulative("probit"))
summary(fit3.q6)
marginal_effects(fit3.q6, categorical = T)

loo(fit1.q6, fit2.q6, fit3.q6)

# uneq variances
fit1b.q6 <-brm(formula = bf(q6~1+stim_setting)+
                 lf(disc ~ 0+stim_setting, cmc=F),
               data = qd,family =cumulative("probit"))
summary(fit1b.q6)

fit2b.q6 <-brm(formula = bf(q6~1+stim_setting+lab_code)+
                 lf(disc ~ 0+stim_setting, cmc=F),
               data = qd,family =cumulative("probit"))
summary(fit2b.q6)


fit3b.q6 <-brm(formula = bf(q6~1+stim_setting*lab_code)+
                 lf(disc ~ 0+stim_setting, cmc=F),
               data = qd,family =cumulative("probit"))
summary(fit3b.q6)


loo(fit1.q6, fit1b.q6, fit2.q6, fit2b.q6, fit3.q6, fit3b.q6)


## Q3
fit1.q3 <-brm(formula = q3~1+stim_setting,data = qd,family =cumulative("probit"))
summary(fit1.q3)
marginal_effects(fit1.q3, "stim_setting", categorical = T)

fit2.q3 <-brm(formula = q3~1+stim_setting+lab_code,data = qd,family =cumulative("probit"))
summary(fit2.q3)
marginal_effects(fit2.q3, categorical = T)

fit3.q3 <-brm(formula = q3~1+stim_setting*lab_code,data = qd,family =cumulative("probit"))
summary(fit3.q3)
marginal_effects(fit3.q3, categorical = T)

loo(fit1.q3, fit2.q3, fit3.q3)

# uneq variances
fit1b.q3 <-brm(formula = bf(q3~1+stim_setting)+
                 lf(disc ~ 0+stim_setting, cmc=F),
               data = qd,family =cumulative("probit"))
summary(fit1b.q3)

fit2b.q3 <-brm(formula = bf(q3~1+stim_setting+lab_code)+
                 lf(disc ~ 0+stim_setting, cmc=F),
               data = qd,family =cumulative("probit"))
summary(fit2b.q3)


fit3b.q3 <-brm(formula = bf(q3~1+stim_setting*lab_code)+
                 lf(disc ~ 0+stim_setting, cmc=F),
               data = qd,family =cumulative("probit"))
summary(fit3b.q3)


loo(fit1.q3, fit1b.q3, fit2.q3, fit2b.q3, fit3.q3, fit3b.q3)


## Q3+Q6 model
qd %>% select(subj,lab_code,stim_setting, q3, q6) %>%
  gather(question,response,q3,q6) -> qd.long

fit1.q36 <-brm(formula = response~1+stim_setting+(1|subj)+(1|question),
               data = qd.long, family =cumulative("probit"))
summary(fit1.q36)
marginal_effects(fit1.q36,  categorical = T)
