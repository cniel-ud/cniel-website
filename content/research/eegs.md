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

imageLink: "/images/research/eegs2.png"
externalLink:
journalLink: "http://dx.doi.org/10.1109/TBME.2015.2499241"
pdfLink: "/papers/brockmeier2016_learning_recurrent_waveforms.pdf"
codeLink: "/code/eegs.zip"

date: 2016-04-28T22:42:02-04:00
draft: false
---

## Overview

When experts analyze EEGs they look for landmarks in the traces corresponding to established patterns such as oscillatory and phasic events of particular frequency or morphology. Long records motivate automated analysis techniques. Automation techniques often require design choices such as wavelet family or number of bandpass filters. To overcome this, we explore a modeling approach that automatically learns recurrent temporal waveforms within EEG traces. The estimation is based on a multiple-input, single-output linear model with sparsely excited inputs.

![We assume that an EEG signal can be described by a convolutional sparse coding model. The EEG trace is approximated as an additive mixture of component signals each described by a convolution of a sparse source with a waveform. Although this is a linear model (multiple input and single output), to separate the components requires a nonlinear analysis. Additionally, when the waveforms are unknown, this blind source separation problem is even more challenging.](/images/research/eegs1.png "Convolutional sparse coding model for EEG")

We apply the approach to various data sets to better understand the specificity and consistency of the estimated waveforms. In particular, we cluster the waveforms found on different electrodes/channels and subjects. 

![Each cluster of waveforms is described by its centroid, the waveform nearest the centroid, the spectrum of the centroid, and the spatial distribution of the originating electrodes for the cluster waveforms.](/images/research/eegs2.png "Recurrent waveforms")
