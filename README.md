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

[RStudio]() is great for showing the network visualizations from networkD3 and plot networks with iGraph, highly recommended.

* [cccd]()
* [networkD3]()
* [igraph]()
* [ggplot2]()
* [htmlwidgets]()
* [ape]()

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

###NetView

Network construction, analysis and visualization is accessible via `netview` ( `?netview` ):

```
netview(mdist, data, k=10:60, step=5, cluster=FALSE, mst=FALSE, networkD3=FALSE,
        selectionPlot=FALSE, save=FALSE, project="netview", options=netviewOptions() )
```

**Returns**:

* list of network objects in the given range of *k*
* network plots with D3 (`networkD3 = TRUE`)
* data and plot for selecting *k* (`selectionPlot = TRUE`).

**Parameters**:

```
mdist         matrix, symmetrical distance matrix (N x N)
data          data frame, meta data ordered as rows in matrix (N)
k             vector of integers, range of parameter k [10:60]
step          integer, step to construct networks through range of k [5]
cluster       bool, run community-detection and add to mkNNGs [TRUE]
mst           bool, add edges from minimum spanning tree to mkNNG [FALSE]
networkD3     bool, return list of network visualizations with networkD3 [FALSE]
selectionPlot bool, return data and plot for selecting k [FALSE]
save          bool, save networks as .gml or .html (D3) to project directory [FALSE]
project       character, directory name in cwd and prefix for saving networks ["netview"]
options       list, list of options from netviewOptions(...)

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

###Options

Network construction, plots and visualizations can be configured via `netviewOptions` ( `?netviewOptions` ):

```
defaultOptions <- netviewOptions()
optionsExample <- netviewOptions(mknn.weights=TRUE, nodeGroup="Population")
graphs <- netview(..., options=optionsExample)
```

**Options**:

```
nodeID                character, name of column in data frame containing sample IDs [ "ID" ]
nodeColour            character, name of column in data frame containing sample colours [ "Colour" ]
nodeGroup             character, name of column in data frame containing sample group [ "Group" ]

mknn.weights          include weights (distance) for edges in mkNNG [ TRUE ]
mknn.algorithm        choice of mutual k-Nearest Neighbour algorithm (cccd: ?nng ) [ "cover_tree" ]

cluster.algorithms    character vector of community algorithms (netview: ?netview) [ c("Walktrap", "Fast-Greedy",         "Infomap") ]

selection.plot        numeric vector of length [3] for selection ggPlot: k-breaks, n-breaks, line-width [ c(20, 5, 1) ]
selection.title       character, title for selection ggPlot

For  additional options to configure the visualization with networkD3, see the documentation ( ?netview ).
```

