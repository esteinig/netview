# NetView

![](https://img.shields.io/badge/cran-available-orange.svg)
![](https://img.shields.io/badge/conda-available-orange.svg)
![](https://img.shields.io/badge/docker-available-orange.svg)
![](https://img.shields.io/badge/docs-latest-orange.svg)
![](https://img.shields.io/badge/lifecycle-maturing-blue.svg)

NetView is a pipeline for the analysis of genetic structure using mutual k-nearest neighbour graphs (mkNNGs). The main implementation of the pipeline is now availabe in R. 

We decided to move away from Python to enable a more user-friendly access to the main command-line functions, interface integration with [Shiny](http://shiny.rstudio.com/) and visualization of the networks with [networkD3](https://christophergandrud.github.io/networkD3/). 

Please note that the method is primarily designed for the *visualization* of population structure and does not have the same rigorous statistical backbone as other model-based approaches, such as Admixture or Structure. It is therefore recommended to use the networks as a tool to understand and visualize genomic data across the genetic structure inferred from population genetic (and phylogenetic) analyses or supported by independent data (e.g. pedigrees). We are expanding the scope of this package to better accommodate this approach, including a novel workflows to [detect key genetic contributors](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0177638) (Neuditschko et al. 2017), visualize admixture proportions and map samples in a geospatial framework powered by [GlobeJS](https://github.com/bwlewis/rthreejs) and [Leaflet](http://leafletjs.com/)

For an introduction to the analysis and visualization of population structure with NetView, see the [Pearl Oyster Tutorial](https://github.com/esteinig/netview/blob/master/tutorials/PearlOysterTutorial.md). 

If you find any bugs or would like to contribute, feel free to contact us or use the issues function on GitHub. Please note that this repository is still under development and is not the published version of NetView P. However, core calculations in the pipeline are identical to the methods described in the publication for NetView P.

If you use the package for publication, please cite:

* [Neuditschko et al. (2012) - NetView - PLoS One](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0048375)
* [Steinig et al. (2015) - NetView P - Molecular Ecology Resources](http://onlinelibrary.wiley.com/doi/10.1111/1755-0998.12442/abstract)


### Installation
---

```r
require("devtools")
install_github("esteinig/netview")
```

### Dependencies
---

[RStudio]() is highly recommended. Dependencies should be installed upon download, you can also use the convenience function `installNetView()` to install all packages for NetView.

### Versions
---

*NetView v.1.1*

For the original Python implementation see the repository for [NetView P](https://github.com/esteinig/netviewP). This version will be discontinued, but source code will still be available. We recommend using the current implementation in R.

We have removed the user-interface version NetView R. It will be updated and integrated with geographical projections using [geonet](https://github.com/esteinig/geonet) and [Shiny](http://shiny.rstudio.com/).

### Quick Start
---

```r
library("netview")

data("oysterData")
data("oysterMatrix")

oysterOptions <- netviewOptions(....)

graphs <- netview(oysterMatrix, oysterData, k=1:20, options=oysterOptions)

graphsD3 <- netview(oysterMatrix, oysterData, k=10:60, networkD3=TRUE, options=oysterOptions)

graphCommunities <- netview(oysterMatrix, oysterData, k=1:60, cluster=TRUE, options=oysterOptions)

selectionPlot <- plotSelection(graphCommunities, options=oysterOptions)
```

### NetView
---

Network construction, analysis and visualization is accessible via `netview` ( `?netview` ):

```r
netview(distMatrix, metaData, k=10:60, tree= NULL, cluster=FALSE, mst=FALSE, 
        networkD3=FALSE, save=FALSE, project="netview", options=netviewOptions())
```

###### Returns:

* List of network objects in the given range of *k* (`ǹetworkD3 = FALSE`)
* Network plots with D3 (`networkD3 = TRUE`)

###### Parameters:

```
distMatrix      matrix, symmetrical distance matrix (N x N)
metaData        data frame, meta data ordered as rows in matrix (N)

tree            phylo, rooted phylogeny for cophenetic distance [NULL]

k               vector of integers, range of parameter k [10:60]

cluster         bool, run community-detection and add to mkNNGs [TRUE]
mst             bool, add edges from minimum spanning tree to mkNNG [FALSE]
networkD3       bool, return list of network visualizations with networkD3 [FALSE]

save            bool, save networks as .gml or .html (D3) to project directory [FALSE]
project         character, directory name in cwd and prefix for saving networks ["netview"]

options         list, list of options from netviewOptions(...)
```

#### Input
---

###### Quality Control

Shared missing data can introduce artifical similarity between samples when calculating distance matrices from SNPs. We would recommend a missing rate < 10% per sample across SNPs, which can be implemented, through quality control functions as implemented, for instance, in [PLINK](http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml). Likewise, very short or long branch lengths in a phylogeny can introduce artificial similarity during the nearest neighbour search on a cophenetic distance matrix and we recommend to remove such branches prior to network construction. Homogenous sample population sizes are recommended (Neuditschko et al. 2012).

###### Distance Matrix

Main input is a symmetrical genetic distance matrix (N x N) using your preferred distance measure. The choice of distance measure is crucial for selecting nearest neighbours to construct the mkNNG. Depending on the purpose of your study, you can, for example, construct simple allele-sharing distances in PLINK, cophenetic distances from a phylogeny (e.g. `cophenetic.phylo()` from [ape](http://ape-package.ird.fr/) in R) or simple Hamming distance over an alignment of SNPs. The matrix input is less specific than the original SNP input in NetView P and allows for flexibility in the type of data (haploid, diploid, genetic or ecologigal data, distance measures) for construction of the mkNNGs.

###### Data Frame

The data frame contains at minimum three named columns of meta data for each sample (node) in the matrix: 

* Node ID (`"ID"`)
* Node Colour (`"Colour"`)
* Node Group (`"Group"`)

Colour and group attributes can be used to highlight associated data in the network representation, but are not required for the algorithm to construct the mkNNG. For instance, one could assign colour and population attributes to compare the final genetic structure to the sample populations or geographical locations. Samples in the data frame must be in the same order and number as the rows in the matrix.

#### Options
---

Network construction, plots and visualizations can be configured via `netviewOptions` ( `?netviewOptions` ):

```r
defaultOptions <- netviewOptions()
optionsExample <- netviewOptions(mknnWeights=TRUE, nodeGroup="Population", nodeID="ID", nodeColour="Colour")
```

###### Parameters:

```
nodeID               character, name of column in data frame containing sample IDs ["ID"]
nodeColour           character, name of column in data frame containing sample colours ["Colour"]
nodeGroup            character, name of column in data frame containing sample group ["Group"]

mknnWeights          include weights (distance) for edges in mkNNG [TRUE]
mknnAlgorithm        choice of mutual k-Nearest Neighbour algorithm ["cover_tree"]

communityAlgorithms  character vector of community algorithms [c("Walktrap", "Infomap", "Fast-Greedy")]

selectionPlot        numeric vector of length [3] for selection ggPlot: k-breaks, n-breaks, line-width [c(20, 5, 1)]
selectionTitle       character, title for selection ggPlot ["K Selection mkNNGs"]

For additional options to configure algorithms and the visualization with networkD3, please see manual pages ( ?netview )
```

#### Key Contributors
---

Please see our publication for a detailed description of the process: [Neuditschko et al. 2017 - Identification of key contributors in complex population structures](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0177638). From the abstract:

```
Based on the Eigenvalue Decomposition (EVD) of a genomic relationship matrix we describe a novel approach to evaluate the genetic contribution of individuals to population structure. We combined the identification of key contributors with model-based clustering and population network visualization into an integrated three-step approach, which allows identification of high-resolution population structures and substructures around such key contributors.
```

Implemented as part of NetView using the accessory function:

`findKeyContributors(relMatrix, metaData, paranIterations=100, paranCentile=99, distMatrix=FALSE, verbose=TRUE)`

Please note that the default input should be a relationship matrix or a distance matrix which will be converted to a relationship matrix by `1 - distance` and requires the flag `distMatrix`. We provide a [tutorial](https://github.com/esteinig/netview/blob/master/tutorials/KeyContributorsTutorial.md) for detecting and visualizing key contributors with NetView.

#### Accessory Functions
---

The following function are designed to process output from NetView and Admixture. Please see the manual pages or tutorials for usage.

```r
plotSelection(graphs, options=netviewOptions())

runAdmixture(filePath, K=1:10, processors=1, crossValidation=20, plotValidation=FALSE, admixturePath=NULL)

plotAdmixture(qFile, metaData, graph=NULL, structurePlot=FALSE, palette="Dark2", colourN=8)

findKeyContributors(relMatrix, metaData, paranIterations=100, paranCentile=99, distMatrix=FALSE, verbose=TRUE)
```

#### Tutorials
---

* [Tutorial 1: Pearl Oyster](https://github.com/esteinig/netview/blob/master/tutorials/PearlOysterTutorial.md)

#### References
---

If you use [Admixture](https://www.genetics.ucla.edu/software/admixture/), please cite:

* [Alexander et al. (2009) - Fast model-based estimation of ancestry in unrelated individuals - Genome Research](http://genome.cshlp.org/content/early/2009/07/31/gr.094052.109.abstract)

We adopted code from [Structure Plot](http://btismysore.in/strplot/) with permission from Ramasamy et al. for the visualization of results from Admixture. If you use the plots for publication, please cite:

* [Ramasamy et al. (2014) - Structure Plot: a program for drawing elegant STRUCTURE bar plots in user friendly interface - Springerplus](http://www.springerplus.com/content/3/1/431)

#### Examples
---

![](https://github.com/esteinig/netview/blob/master/img/Oyster_GCS.jpeg)


#### Contact
---

* eikejoachim.steinig@my.jcu.edu.au
* eike.steinig@menzies.edu.au
