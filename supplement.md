---
title:  'Supplemental Material: Blinding is compromised for transcranial direct current stimulation at 1 mA for 20 minutes in young healthy adults'
journal: 'Brain Stimulation'
author:
- name: Zsolt Turi
  footnote: 1
- name: Gábor Csifcsák
  footnote: 2
- name: Nya Mehnwolo Boayue
  footnote: 2
- name: Per Aslaksen
  footnote: 2
- name: Andrea Antal
  footnote: 1,3
- name: Walter Paulus
  footnote: 1
- name: Josephine Groot
  footnote: 2,4
- name: Guy E. Hawkins
  footnote: 5
- name: Birte Forstmann
  footnote: 4
- name: Alexander Opitz
  footnote: 6
- name: Axel Thielscher
  footnote: 7,8
- name: Matthias Mittner
  footnote: 2
  corresponding: matthias.mittner@uit.no
affiliation:
- number: 1
  name: Department of Clinical Neurophysiology, University Medical Center Goettingen
- number: 2
  name: Department of Psychology, University of Tromsø 
- number: 3
  name: Medical Psychology, Otto-Guericke University Magdeburg
- number: 4
  name: Integrative Model-based Cognitive Neuroscience Research Unit, University of Amsterdam
- number: 5
  name: School of Psychology, University of Newcastle
- number: 6
  name: Department of Biomedical Engineering, University of Minnesota
- number: 7
  name: Department of Electrical Engineering, Technical University of Denmark
- number: 8
  name: Danish Research Centre for Magnetic Resonance, Centre for Functional and Diagnostic Imaging and Research, Copenhagen University Hospital Hvidovre, Denmark
bibliography: references.bib   
...

<!--# Supplemental Material 

## Stimulation administration

 The stimulator was operating in study mode:  The active sham and the real stimulation protocols were assigned to pseudo-codes B and C, respectively.  The display window of the stimulator was covered 30s after the start of the stimulation by a non-transparent material. This was necessary to avoid accidental unblinding of the experimenter. -->
 
# Supplemental Analyses

## Analysis methods -- details

It has recently been pointed out that treating ordinal variables, such as responses to Likert-scales, as metric can have a strong impact on the validity of the statistical analyses: It can distort effect-size estimates, inflate error rates and cause other problems [@liddell2018analyzing,@buerkner_vuorre_2018]. Despite these severe problems, treating ordinal variables as metric is extremely common in psychology and related disciplines [@liddell2018analyzing]. A more appropriate approach uses specific ordinal models such as ordinal probit regression [@buerkner_vuorre_2018]. Here we use a Bayesian approach to estimate such a model as implemented in the R-package `brms` [@buerkner_2018_brms]. We used the default priors implemented in the `brms`-package [@buerkner_2018_brms]. Those include uniform priors for all regression coefficients and a Students' t-prior centered at zero with df=3 and sd=10 for the thresholds.
In addition, we use Bayesian methods for model selection based on the leave-one-out crossvalidation criterion (LOOIC; @vehtari2017practical) procedure. Lower scores of the LOOIC imply a better model.

All Bayesian analyses used four independent chains with 2000 samples each. We treated the first 1000 iterations as a warm-up phase such that all inferences are based on 4000 iterations. We ensured that the Gelman-Rubin diagnostic [@gelman1992inference] $\hat{R}\le 1.05$ for all variables in all models. In addition, traceplots for all variables were visually inspected and no anomalies were found.
  
## Model-selection details
 
We tested a sequence of models of increasing complexity independently for each of the two outcome measures (guessing sham vs. anodal stimulation and discomfort caused by stimulation).
We started with a model that contains no factors (Null-model) and then added each of the factors (lab: AMS, GOE and TRM; stimulation condition: sham vs. real) in various combinations. In addition, we tested models that included the achieved impedance at the electrodes (see next section for a rationale). We also relaxed the assumption of homoscedasticity by testing models that allowed for unequal variances across labs and stimulation conditions. A summary of all models  is provided in Table \ref{tab:q6} for the blinding question and  in Table \ref{tab:q3} for the discomfort question. For each model, we list the estimated effect of the anodal stimulation and the LOOIC (@vehtari2017practical).

\input{supp_tab_q6.tex}
 
For the blinding question, model-selection favored a model that included stimulation and lab as factors. Including their interaction decreased the model-selection score ($\Delta$LOOIC=-3.97, SE=1.77). Allowing unequal variances across labs or stimulation did not appear to strongly improve model-fit. We therefore report the model that included only Stimulation and Lab as factors in the main paper. However, the conclusions drawn from this model, in particular with respect to the effect of sham vs. anodal stimulation on blinding efficacy and discomfort, were robust against model choice: All models (except models 8 and 9 that included higher-order interaction terms) showed a positive effect of real stimulation on both questions with the posterior 95% interval exlucing zero. We disregard models 8 and 9 here since they show worse model-selection scores and produce a much higher posterior uncertainty around the estimates for the effects.


For the discomfort question, model selection also favored the inclusion of both Lab and Stimulation, while including their interaction decreased the score ($\Delta$LOOIC=-2.42, SE=2.76). For the discomfort question, including the impedance as a covariate resulted in slightly lower model-selection scores, though that improvement was not strong ($\Delta$LOOIC=0.87, SE=3.48). That pattern was consistent when allowing for heteroscedasticity (models 11 and 13, Table \ref{tab:q3}). The estimate for the effect of interest (i.e., the effect of stimulation condition on discomfort) was changed slightly when including impedance (model 4 w/o impedance: $b=0.34$, $[0.04, 0.63]$, model 7 w/ impedance: $b=0.29$ $[-0.02, 0.6]$) to the point that the 95% did include zero for the model including impedance. The effect of impedance was estimated close to zero, $b=0.07$ $[-0.01,0.14]$. We note that the effect of stimulation condition was positive across all model specifications, with the lower boundary of the effect fluctuating around zero. In addition, participants in both Göttingen and Tromsø reported more discomfort when compared to Amsterdam ($b_{\text{GOE}}=0.43$ $[0.05, 0.80]$, $b_{\text{TRM}}=0.67$ $[0.31,1.06]$). 

\input{supp_tab_q3.tex}

Diagnostic plots as well as posterior-predictive checks for all tested models can be found at our github-repository: <https://github.com/ihrke/2018_tdcs_blinding/tree/master/analysis>.

## Achieved impedance as a moderator

Our experimental protocol required the impedance of the electrodes to be below 10 k$\Omega$ before the stimulation could be started [@boayue2018registered]. Even though that value is quite low in comparison to what other studies in the field use, it is possible that differences in impedance may have had effects on discomfort or the blinding properties of the protocol. In order to investigate whether there were differences in what impedances were realized across labs and stimulation condition, we ran a Bayesian ANOVA [@rouder2012default] with factors lab and stimulation condition and impedance at the start of the stimulation as dependent variable (prior $r$-scale=0.5). Descriptive statistics for this variable are summarized in Figure @fig:impedance.

We found that there were clear differences in the achieved impedances across labs (BF$_{10}$=7.57$\times 10^{21}$). The Göttingen lab achieved the lowest impedances ($M=3.3$k$\Omega$, SD$=2.13$), followed by Amsterdam ($M=6.05$k$\Omega$, SD$=1.94$) and Tromsø ($M=7.65$k$\Omega$, SD$=1.94$). The reason for the different impedance levels among the laboratories remains elusive. We speculate that this might be due to the different amount of conductive paste used by the data collectors or other circumstantial differences, such as the amount of time spent by the data collectros with the preparation of the electrode-skin interface. Note, however, that the stimulation equipment was identical and that the exact procedure was pre-registered and pre-described in fine detail to ensure comparability across labs. There was no evidence for differences between the stimulation conditions (BF$_{10}$=1.11).

![Impedance at the start of the experiment across labs and stimulation conditions. The protocol required the impedance to be below 10k$\Omega$, placing a ceiling on the observed values. Black points and bars are means and confidence intervals. Colored dots show impedance for individual participants and boxplots summarize the distributions.](pics/impedance.png){ #fig:impedance width=100% }

In order to ensure that the differences between labs in achieved impedance of the stimulation was not causing differences in reported discomfort or above-chance levels of guessing the real stimulation condition, we included impedance as a variable in our analysis (see Table \ref{tab:q6} and Table \ref{tab:q3}). When including this variable, model-selection criteria were not improved. Model-selection was agnostic to the distinction between including or not including impedance as a covariate. The estimated positive effect of real stimulation on the scores on both answers was only minorly affected when including impedance. 

## Frequentist analysis treating ordinal scales as metric variables

Even though we believe that our reported Bayesian analyses are much more suitable for the analysis of ordinal-scale data [@liddell2018analyzing] we also report standard frequentist analyses that do not take the ordinal scale into account. We do this mostly of a desire to convince the reader that we did not cherry-pick our analysis method to achieve a particular result. Simple independent t-tests comparing sham vs. anodal stimulation find significant effects both for subjects guessing the stimulation condition ($t(185.9)=-2.38, p=0.018, d=0.34$) and skin sensations ($t(189.03)=-2.0, p=0.047, d=0.29$). The effect of actual stimulation condition on guessing stimulation condition is significant also when including lab-location in a 2 (sham vs. anodal) $\times$ 3 (lab: GOE, TRM, AMS) ANOVA, $F(1,186)=5.74, p=0.018, \eta^2=0.03$. In this analysis, neither the main effect of lab ($F(2,186)=2.67, p=0.07, \eta^2=0.028$) nor the lab $\times$ stimulation interaction were significant ($F(2,186)=0.25, p=0.78, \eta^2=0.003$). A corresponding ANOVA with reported skin-sensations as dependent variable also showed stronger sensations during anodal stimulation ($F(1,186)=4.31, p=0.039, \eta^2=0.023$). For this question, the main effect of lab was significant ($F(2,186)=8.46, p=0.00030, \eta^2=0.083$) but the interaction between lab and stimulation was not, $F(2,186)=0.94, p=0.39, \eta^2=0.01$. 



# References {-}

<!-- -->


