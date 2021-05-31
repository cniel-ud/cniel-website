---
title: "Learning Recurrent Waveforms within EEGs"
shortTitle: "Recurrent Waveforms within EEGs"
shortDescription: "We explore a modeling approach that automatically learns recurrent temporal waveforms within EEG traces."

authors: "Austin J. Brockmeier and Jose C. Principe"
journal: "IEEE Trans. on Biomedical Engineering"
volume: 63
issue: 1
pages: "43-54"
year: 2016

imageLink:
external: false
externalLink:
journalLink: "http://dx.doi.org/10.1109/TBME.2015.2499241"
pdfLink: "http://cnel.ufl.edu/files/1447193268.pdf"
codeLink: "/code/eegs.zip"

date: 2021-04-28T22:42:02-04:00
draft: false
---

## Overview

When experts analyze EEGs they look for landmarks in the traces corresponding to established patterns such as oscillatory and phasic events of particular frequency or morphology. Long records motivate automated analysis techniques. Automation techniques often require design choices such as wavelet family or number of bandpass filters. To overcome this, we explore a modeling approach that automatically learns recurrent temporal waveforms within EEG traces. The estimation is based on a multiple-input, single-output linear model with sparsely excited inputs.

![Figure 1](/images/eegs1.png "Figure 1")
