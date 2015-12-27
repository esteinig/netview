
###Input

#####Quality Control

Shared missing data can introduce artifical similarity between samples when calculating distance matrices from SNPs. We recommend a missing rate > 10% per sample, which can be implemented for instance through quality control in [PLINK](). Likewise, very short or long branch lengths in a phylogeny can introduce artificial similarity during the nearest neighbour search on a cophenetic distance matrix and we recommend to remove such samples before network construction.

#####Distance Matrix

Main input is a symmetrical genetic distance matrix (N x N) using your preferred distance measure. The choice of distance measure is crucial for selecting nearest neighbours to construct the mkNNG. Depending on the purpose of your study, you can for instance construct simple allele-sharing distances in PLINK, cophenetic distances from a phylogeny (e.g. `cophenetic` from [ape]() in R) or simple Hamming distance over an alignment of SNPs. The matrix input is less specific than the original SNP input in NetView P and allows for flexibility in the type of data (haploid, diploid, distance measures...) used to construct the mkNNG.

#####Data Frame

The data frame contains at minimum three named columns of meta data for each sample in the matrix: 

* sample ID ("ID")
* sample colour ("Colour")
* sample group ("Group")

Colour and group attributes can be used to highlight associated data in the network representation, but are not required to construct it. A possible start would be to assign colour and sample population attributes to compare the final genetic structure to the sample populations. The samples in the data frame must be in the same order and number as the rows in the matrix.

###Network Construction

MST



###Details
