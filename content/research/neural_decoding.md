---
title: "Neural Decoding with Kernel-based Metric Learning"
shortTitle: "Metric Learning for Neural Decoding"
shortDescription: "Machine learning (optimizing feature weightings and projections using kernel-based dependence) for enhancing neural data analysis, applied to a somatosensory neural decoding task."

authors: "Austin J. Brockmeier, John S. Choi, Evan G. Kriminger, Joseph T. Francis, and Jose C. Principe"
journal: "Neural Computation"
volume: 26
issue: 6
pages: "1080-1107"
year: 2014

imageLink: "/images/research/metricLearning_thumb.png"
externalLink:
journalLink: "http://dx.doi.org/10.1162/NECO_a_00591"
pdfLink: "/papers/brockmeier2014_kernel_metric_learning.pdf"
codeLink: "/code/neural_decoding.zip"

date: 2014-04-28T23:19:06-04:00
draft: false
---

## Overview
Given a sample of data points, we often assume the points reside in some space in which we can measure distances between pairs of points. From these measurements we can understand which points are close to each other. Nearby points are often assumed to share characteristics. This assumption is the foundation of nearest-neighbor classification and regression as well as clustering. 

The function that measures the distance between pairs of points in a particular space is called a distance metric. 

![In the original metric space, the white gold circle is closer to three black circles (two of which are equidistant from it). In a new metric space, changes in the vertical axes contribute more to the distance. Now, two gold circles are closer than the black circles.](/images/research/metricLearning.png "Example of metric learning. ")

When studying the function of the nervous system, the choice of metric for the neural responses is a pivotal assumption. A well-suited distance metric enables neuroscientists to gauge the similarity of neural responses to various stimuli and assess the variability of responses to a repeated stimulus. In particular, neural spike train metrics have been used to quantify the information content carried by the timing of action potentials. While a number of metrics for individual neurons exist, a method to optimally combine single-neuron metrics into multi-neuron, or population-based, metrics is lacking. For time-locked neural responses, we pose the problem of the supervised optimization of multi-neuron metrics and other metrics (including those for local field potentials (LFPs), which are the electric potentials measured within brain tissue). The goal is to tune the metric to better predict the stimulus from the neural response. Predicting the stimulus from the response is known as neural decoding.


To guide the choice of metric learning, we propose to use centered alignment, a kernel-based dependence measure, to measure the correlation between the similarity in the data space (determined by the metric) and the similarity in the stimulus space. We provide mathematical formulation of the appropriate kernel and distance functions, as well as a MATLAB implementation of the batch and mini-batch optimization of the centered alignment metric learning (CAML). 

