---
title: "Quantifying the informativeness of similarity measurements"
shortTitle: "Quantifying Informativeness"
authors: "Austin J. Brockmeier, Tingting Mu, Sophia Ananiadou, and John Y. Goulermas"
journal: "Journal of Machine Learning Research"
volume: 18
issue: 18
pages: "1-61"
year: 2017

date: 2021-03-17T21:25:29-04:00
draft: false
---


![Example image](/images/logo-black-fill.svg)
![Example image](/images/logo-white-fill.svg)

## Overview

Choosing the particulars of a data representation is crucial for the successful application of machine learning techniques. In the unsupervised case, there is a lack of measures that can be used to compare different parameter choices that affect the representation. In this paper, we describe an unsupervised measure for quantifying the 'informativeness' of correlation matrices formed from the pairwise similarities or relationships among data instances.

The measure quantifies the heterogeneity of the correlations and is defined as the distance between a correlation matrix and the nearest correlation matrix with constant off-diagonal entries. While a homogenous correlation matrix indicates every instance is the same or equally dissimilar, informative correlation matrices are not uniform, some subsets of instances are more similar and themselves are dissimilar to other subsets. A set of distinct clusters is highly informative (Figure 1).

        <img src="../images/informativeness1.png" width=750
            alt="Informativeness versus von Neumann entropy for correlation matrices obtained from various configurations of four unit vectors. Both measures are minimal when the vectors are configured in a single cluster. Informativeness is higher for nontrivial clusterings, whereas entropy is maximized when the vectors are maximally separated." />
        <p>
            Figure 1: Informativeness versus von Neumann entropy for correlation matrices obtained from various
            configurations of four unit vectors.
            Both measures are minimal when the vectors are configured in a single cluster. Informativeness is higher for
            nontrivial clusterings, whereas entropy is maximized when the vectors are maximally separated.</p>
        Informativeness can be used as an function to choose between representations or perform parameter selection
        (Figure 2) or dimensionality reduction. Using it, we designed a convex optimization algorithm for de-noising
        correlation matrices that clarifies their cluster structure.

        <img src="../images/informativeness2.png" width=750
            alt="Informativeness versus the von Neumann entropy of correlation matrices obtained from a Gaussian kernel applied with varying bandwidths to a sample with 2 clusters." />
        <p>Figure 2: Informativeness versus the von Neumann entropy of correlation matrices obtained from a Gaussian
            kernel applied with varying bandwidths to a sample with 2 clusters.</p>
