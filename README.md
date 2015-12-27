# NetView

###Package **netview** for R

NetView is a pipeline for the analysis of genetic population structure using mutual k-nearest neighbour graphs (mkNNGs). The network representation allows for the application of graph-theoretical concepts to the analysis of population structure. The main implementation of the pipeline is now availabe in R. 

We decided to move away from Python to enable a more user-friendly access to the main command-line functions, better interface integration with [Shiny](http://shiny.rstudio.com/) and visualization of the networks with [networkD3](https://christophergandrud.github.io/networkD3/). In addition, we have been working on some ideas to select appropriate parameter values for constructing mkNNGs, combining networks analysis with results from [Admixture]() and implementing community-detection and visualization through [iGraph]().

If you find any bugs or would like to contribute, feel free to contact us or use the issues function on GitHub. 

###Installation

```
require(devtools)
install_github("esteinig/netview")
```

###Dependencies

* Mutual nearest neighbour graphs: [cccd]()
* Network visualization with D3: [networkD3]()
* Network analysis and visualization: [iGraph]()
* Analysis plots: [ggplot2]()
* HTML integration: [htmlwidgets]()

###Versions

For a user-interface with Shiny see [netviewR](https://github.com/esteinig/netviewR). This will be updated and integrated with geographical projections using [geonet]() for R.

For the original Python implementation see [netviewP](https://github.com/esteinig/netviewP). This version will be discontinued, but source code will still be available. We recommend using the implementation in R.

###Quick Start

```
data(netview)

# Distance Matrix
distMatrix <- netview$distMatrix

# Data Frame
metaData <- netview$metaData

# mkNNGs in range of k = 10-50 by 5
graphs <- netview(distMatrix, metaData k=10:60, step=5)

# Networks D3
graphsD3 <- netview(distMatrix, metaData, k=10:60, step=5, networkD3=TRUE)

# Community Detection
graphsCommunities <- netview(distMatrix, metaData, k=10:60, step=5, cluster=TRUE)

# K Plot
selectionPlot <- netview(distMatrix, metaData, k=10:60, step=5, selectionPlot=TRUE)
```
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

