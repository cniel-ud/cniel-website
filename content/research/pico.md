---
title: "Improving reference prioritisation with PICO recognition"
shortTitle: "Reference Prioritisation with PICO"
shortDescription: "Machine learning can assist with multiple tasks during systematic reviews to facilitate the rapid retrieval of relevant references during screening and to identify and extract information relevant to the study characteristics, which include the PICO elements of patient/population, intervention, comparator, and outcomes."

authors: "Austin J. Brockmeier, Meizhi Ju, Piotr Przybyła, Sophia Ananiadou"
journal: "BMC Medical Informatics and Decision Making"
volume: 19
issue: 1
pages: "1–14"
year: 2019

imageLink: "/images/research/pico1.png"
externalLink: 
journalLink: "https://doi.org/10.1186/s12911-019-0992-8"
pdfLink: "/papers/brockmeier2019_improving_reference_prioritisation.pdf"
codeLink: 

date: 2019-06-01T00:59:28-04:00
draft: false
---

## Overview

![Systematic reviews of biomedical research focus on specific questions framed in terms of the patient population, intervention, control, and outcomes measured (PICO). These terms are used to query literature databases. The resulting hits (which could be hundreds or thousands of articles) need to be sorted into relevant and irrelevant groups.](/images/research/pico2.png "Example of systematic reviews. ")

Machine learning can assist with multiple tasks during systematic reviews to facilitate the rapid retrieval of relevant references during screening and to identify and extract information relevant to the study characteristics, which include the PICO elements of patient/population, intervention, comparator, and outcomes. 


![Example of automatically extracted participants, intervention, and outmodes (PIO). Techniques similar to named entity recognition  are used for identifying and categorising fragments of text. ](/images/research/pico3.png "Example of PICO. ")


A publicly available corpus of PICO annotations on biomedical abstracts is used to train a named entity recognition model, which is implemented as a recurrent neural network. This model is then applied to a separate collection of abstracts for references from systematic reviews within biomedical and health domains. The occurrences of words tagged in the context of specific PICO contexts are used as additional features for a relevancy classification model. Simulations of the machine learning-assisted screening are used to evaluate the work saved by the relevancy model with and without the PICO features.

![PICO recognition and abstract screening process. In the first phase, the PICO recognition model is trained to predict the PICO mention spans
on a human annotated corpus of abstracts. In the second phase, a collection of abstracts is processed by the PICO recognition model and the
results along with the original abstract are used to create a vector representation of each abstract. In the final phase, a user labels abstracts as being
included (relevant) or excluded, these decisions are used to train a machine learning (ML) model that uses the vector representation. The ML model
is applied to the remaining unlabelled abstracts, which are then sorted by their predicted relevancy, the user sees the top ranked abstracts, labels
them, and this process repeats ](/images/research/pico4.png "Data flow across the entire project. ")


 Chi-squared and statistical significance of positive predicted values are used to identify words that are more indicative of relevancy within PICO contexts. Inclusion of PICO features improves the performance metric on 15 of the 20 collections, with substantial gains on certain systematic reviews. Examples of words whose PICO context are more precise can explain this increase. Words within PICO tagged segments in abstracts are predictive features for determining inclusion. Combining PICO annotation model into the relevancy classification pipeline is a promising approach.