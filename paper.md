---
title:  'Blinding is compromised for transcranial direct current stimulation at 1 mA for 20 minutes in young healthy adults'
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
keyword:
  - tDCS
  - blinding
  - double-blinding
  - active sham tDCS
  - placebo

abstract: |
  Transcranial direct current stimulation (tDCS) is a non-invasive brain stimulation method that is frequently used to study cortical excitability changes and their impact on cognitive functions in humans. While most stimulators are capable of operating in double-blind mode, the amount of discomfort experienced during tDCS may break blinding. Therefore, specifically designed sham stimulation protocols are being used. The "fade-in, short-stimulation, fade-out" (FSF) protocol has been used in hundreds of studies and is commonly believed to be indistinguishable from real stimulation applied at 1 mA for 20 minutes. We analyzed subjective reports of 192 volunteers, who either received real tDCS (n=96) or FSF tDCS (n=96). Participants reported more discomfort for real tDCS and correctly guessed the condition above chance-level. These findings indicate that FSF does not ensure complete blinding and that better active sham protocols are needed for effectively blinding this commonly used real tDCS protocol.
linenumbers: true
bibliography: references.bib 
acknowledgements: |
  AT received support from Lundbeckfonden (R118-A11308) and Novo Nordisk Fonden by a synergy grant on Biophysically adjusted state-informed cortex stimulation (BASICS; NNF14OC0011413).
contribution: | 
  Must include all authors, identified by initials, for example:
  A.A. conceived the experiment(s),  A.A. and B.A. conducted the experiment(s), C.A. and D.A. analysed the results.  All authors reviewed the manuscript.
additionalinformation: |
  To include, in this order: \textbf{Accession codes} (where applicable); \textbf{Competing financial interests} (mandatory statement).
  The corresponding author is responsible for submitting a \href{http://www.nature.com/srep/policies/index.html#competing}{competing financial interests statement} on behalf of all authors of the paper. This statement must be included in the submitted article file.
...

# Introduction

Transcranial direct current stimulation (tDCS) is a safe, non-invasive brain stimulation method, which applies low-intensity (most frequenty 1-2 mA) constant current between two or more electrodes placed over the scalp [@antal2017low]. tDCS is assumed to modulate cortical excitability depending on the polarity of the stimulation and is used to study cognitive functions in humans [@santarnecchi2015enhancing]. At low intensities, tDCS induces a moderate amount of perceptual adverse effects that include cutaneous discomfort such as itching, tingling, burning or piercing sensations [@poreisz2007safety; @matsumoto2017adverse; @fertonani2015you].

Most tDCS studies use active sham stimulation protocols for placebo control [@davis2013challenges]. The aim of the active sham stimulation is to induce cutaneous adverse effects that are reminiscent of the real tDCS protocol without inducing the neurophysiologically relevant primary effects of the stimulation [@woods2016technical]. The most frequently applied active sham stimulation is the so called 'fade-in, short-stimulation, fade-out' (FSF) protocol [@ambrus2012fade]. The FSF protocol consists of three stimulation stages: It starts with a fade-in period, where the current is gradually ramped up from 0 mA to the planned intensity (e.g., 1 mA) in a relatively short - 5-30 seconds - time period. Following the short stimulation period - most commonly 30 seconds - at the planned intensity, the current is gradually ramped down to 0 mA over a short - 5-30 seconds - time period. The FSF protocol is an extension of the initial "FS protocol", which only consists of the initial fade-in and the short-stimulation periods, but it lacks the fade-out period at the end [@gandiga2006transcranial]. Nevertheless, it is commonly believed that the fade-out period at the end of the active sham stimulation protocol further improves its blinding efficacy and therefore, the FS protocol is rarely applied nowdays.  

The blinding efficacy of the FSF protocol depends on the intensity and duration of the real tDCS protocol: While it is commonly assumed that FSF can maintain blinding at 1 mA applied for 20 minutes [based on @gandiga2006transcranial FS protocol], evidence suggests that blinding is compromised when tDCS is applied at 1.5 or 2 mA for 10 minutes or longer [@kessler2012differences; @o2012rethinking; @russo2013perception; @wallace2016perceived]. Following these findings, FSF has been used as a control in hundreds of studies using real tDCS at 1 mA for 20 minutes.

Given the enormous popularity of this sham procedure [@bikson2017rigor], we set out to investigate its blinding efficacy using data from our recent high-powered, multi-center, pre-registered study [@boayue2018registered]. In this study, we collected data from 192 volunteers, who either received real tDCS at 1 mA for 20 minutes over the left dorsolateral prefrontal cortex (DLPFC) or FSF tDCS. The primary goal was to investigate the behavioral effects of anodal tDCS over the left DLPFC on mind-wandering but we also collected subjective reports concerning blinding efficacy and cutaneous discomfort. Here, we analyze these subjective reports in order to investigate whether FSF is an effective control procedure for tDCS applied at 1 mA over 20 minutes. 

# Material and methods

The study followed a fully pre-registered protocol (<https://osf.io/bv32d/>) with a sequential sampling plan. Details are available in the original report [@boayue2018registered].

## Participants 

The dataset contains subjective reports of 192 healthy participants (134 female, mean age: 22.2 yrs $\pm$ 3.19 yrs SD)  collected at three labs: Amsterdam, Göttingen and Tromsø [@boayue2018registered]. The raw data and all reported analyses are available at our repository (<https://github.com/ihrke/2018_tdcs_blinding>). Participants had no previous experience with tDCS. The study was approved by the local ethic committee and was performed according to the Declaration of Helsinki. All participants provided written informed consent before participation. 

## Electrode preparation and stimulation protocols 

The experimenter followed a fully pre-registered protocol, which included the electrode preparation and stimulation application steps. The detailed description is available at our repository (<https://osf.io/qdk3x/>) and summarized here. 

First, the electrode locations were determined by using the international 10/20 EEG system. Then, alcohol on de-makeup pad was used to gently clean skin surface area where electrode will be positioned. A small amount of Ten/20 conductive electrode paste (Weaver and Company, USA) was homogeneously distributed over the previously cleaned skin areas and on the surfaces of the rubber electrodes. Medium pressure was applied to enable good electrode-skin contact. The anode electrode (4 × 4 cm) was placed over the F3 location (according to the international 10/20 EEG system), whereas the cathode (7 × 5 cm) over the right supraorbital region. The electrodes were held in place by using the conductive electrode paste and two loops of cohesive elastic fixation bandage (MaiMed GmbH, Germany). The pressure of the elastice bandage was adjusted individually to avoid too much pressure on the head while maintaining proper fixation. 

The stimulation was administered using a neuroConn DC-stimulator (neuroConn GmbH, Germany). The real tDCS protocol lasted for 20 minutes of continuous stimulation at 1 mA, whereas the FSF protocol for 15s at 1 mA. In addition, we utilized 30s-long fade-in/out periods at the beginning and at the end of both tDCS protocols. The details of the real and the FSF protocols are summarized in Figure @fig:results A and B. 
The stimulator was operating in study mode: The active sham and the real stimulation protocols were assigned to pseudo-codes B and C, respectively. 

The data was collected in a double-blind fashion. Although neurConn DS-stimulators can run in double-blind stimulation mode, the built-in active sham protocol consists of 30s fade-in/out periods and a 40s-long short-stimulation period. However, due to the nature of the present pre-registered replication study [@boayue2018registered], the active sham protocol was confined to 15s (instead of the non-programmable 40s-long short-stimulation period built-in for neuroConn DC-stimulators). Since the display window of the stimulator between protocol B and C was different as time progressed, it was covered 30s after the start of the stimulation by a non-transparent material. This was necessary to avoid accidental unblinding of the experimenter. 

## Assessing stimulation discomfort and blinding efficacy

Participants performed a cognitive task (Sustained Attention to Response Task) while receiving the stimulation [@boayue2018registered]. A 7-point Likert-scale was used to assess the amount of discomfort and the blinding efficacy of the FSF protocol. The questionnaires were completed at the end of the experiment by the participants. To investigate the amount of discomfort, participants were required to answer the question *“Please rate to what extent did you find the electrodes disturbing during the experiment (eg., cold or wet, tingling or itching)?”*. Available response categories ranged from  "not at all" (1) to "very strong" (7). To study the blinding efficacy, participants were asked to answer the question *“What do you think, did you receive real or sham/control stimulation?”* with response categories between "definitely sham" (1) and "definitely real" (7). 

## Analysis method

We used Bayesian estimation of ordinal probit regression models [@buerkner_vuorre_2018] designed specifically for analysing ordinal data [@liddell2018analyzing]. We report our results in terms of posterior mean parameters along with the 95% highest-density interval (HDI) calculated from the posterior distribution. This measure quantifies the interval in which the true parameter is located with 95% probability given the applied model. We conclude that a parameter is different from zero if the 95% interval excludes zero. For more details, see Supplemental Analysis.

# Results

![(A) The stimulation parameters for the real and FSF tDCS protocols. (B) The electrode montage. Graphical description of the results: (C) Responses to the blinding question were generally more correct in the real-stimulation condition (red) when compared to sham (grey). (D) Participants receiving real stimulation reported greater discomfort.](pics/figure1.png){ #fig:results width=100% }

Our results are summarized graphically in Figure @fig:results C and @fig:results D. Regarding the blinding efficacy, excluding subjects who were undecided, there were 2.6 as many subjects in the real stimulation group who guessed that they received real stimulation (52 with scores $>4$ vs. 20 with scores $<4$). In contrast, this figure was only 1.19 for the sham group (38 with scores $>4$ vs. 32 with scores $<4$). We submitted these responses for guessing stimulation condition to an ordinal regression model using lab (Amsterdam, Göttingen, Tromsø) and actual stimulation condition (anodal, sham) as predictors. We found that the effect of real stimulation was reliable ($b=0.35$, HDI=$[0.06, 0.65]$). This effect was robust against different choices of the analysis method (see Supplemental Analysis). While including lab as a factor was preferred by model-selection criteria, there was no clear effect for generally higher or lower scores across labs ($b_{\text{GOE}}=0.33$ $[-0.03, 0.69]$, $b_{\text{TRM}}=-0.10$ $[-0.45,0.28]$). 

The findings for the discomfort question were similar. In general, all subjects reported relatively low discomfort ($M=2.5$, SD=$1.56$). In a parallel model to that for the blinding question, real stimulation had a positive effect ($b=0.34$ $[0.04, 0.63]$) though that effect was slightly less robust to model-specification than the effect on the blinding question (see Supplemental Analyses). 

# Discussion

TDCS applied at 1 mA for 20 minutes is one of the most frequently used protocols in the literature and it is commonly assumed to be effectively blinded by the FSF protocol [@gandiga2006transcranial]. Our data, implementing the brain stimulation with the highest sample size investigating this issue to date, challenge this assumption: We found that our subjects could, to a degree, distinguish between active and sham conditions. It is important to note that this effect was present despite the fact that 1) none of the participants had any prior experience with tDCS and 2) every participant took part in only one condition so that they did not have a reference frame to which to compare their experience. It is likely that the actual distinguishability can be much stronger in many studies using repeated measures and/or participants with prior exposure to tDCS [@o2012rethinking]. Given that tDCS is a potent placebo-inducing procedure both in the clinical  [@aslaksen2014effect] and cognitive domains [@turi2017placebo; @turi2018cogplac], there seems to be an urgent need to test alternative active sham protocols [@palm2013evaluation; @boonstra2016change] or develop better active sham protocols to effectively maintain blinding.


<!--
Recent evidence indicates that younger participants can better distinguish between real and active sham stimulations than older participants, which could compromise effective blinding among younger adults [@wallace2016perceived]. One possible explanation for our findings might be that our participants were \textit{de facto} younger (mean age 22.2 years) than those in this earlier study (mean age between 46.3 and 62.3 years) [@gandiga2006transcranial]. Our findings demonstrate the need to develop active sham protocols to effectively blind tDCS at 1 mA for 20 minutes. 
-->


# References {-}

<!-- -->
