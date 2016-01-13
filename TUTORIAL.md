### Pearl Oyster Tutorial

*Please note that the selection plot and admixture graphs are ideas that have not been published. We are currently compiling the methods for review and publication.*

* Data
* Input
* Selecting k-limits for mkNNGs
* Visualization
* Selecting mkNNGs and Communities
* Admixture Networks

######Data
---

The data used for this tutorial is from our initial analysis of 83 pearl oysters from Aru Islands, Bali and West Papua. The data files can be found at Dryad or loaded via the data function in R. For our purposes, the oyster data demonstrates the basic workflow of NetView R.

[*Pinctada maxima*](http://dx.doi.org/10.5061/dryad.p3b3f), n = 83, genotyped at 999 SNPs after QC with PLINK v1.07:

* `--mind 0.1`
* `--maf 0.01`
* `--geno 0.1`
* `--hwe 0.001`

Shared-allele distance matrix via `--distance-matrix` in PLINK.

######Loading and Checking Data for NetView
---

Let's get started and load the data frame and the distance matrix from the package data:

```r
library("netview")
data("oysterMatrix")
data("oysterData")
```

Have a look at oysterMatrix and oysterData. The rows in the distance matrix are ordered the same as the rows in the data frame. Let's see what we have named the data columns and test that the number of samples is the same in both matrix and meta data:

```r
names(oysterData)
nrow(oysterData) == nrow(oysterMatrix)
```

This should return:

```
[1] "ID" "Group" "Colour" 
[1] TRUE
```

In the data frame, colour is defined for each population. The group attribute will be used later to colour the nodes in the networks with networkD3. We also set a title for our k-selection plot, for more options see `netviewOptions`:

```r
oysterOptions <- netviewOptions(selectionTitle="Oyster k-Selection")
```

######Selecting k for mNNGs
---

Before we run the final networks, we want to know an appropriate value for k, which defines the maximum number of mutual nearest neighbours that can be connected by edges during construction of the mkNNG. The choice of an optimal value of k is still a challenge (Neuditschko et al. 2012). Essentially, we are looking for a network topology within the possible range of mkNNGs that represents the genetic similarity of isolates at an appropriate level of resolution on the genetic structure in the data, depending on your question and application of your data. We also want to avoid the selection of a network that has very little information on population-wide structure. 

We can use community (cluster) detection algorithms as a proxy for showing the effect of k on the construction and structure of the mkNNG. There are inherent differences to the way these algorithms detect communities in the network topology. Further reading can be found in the [Community-Detection]() section and the [Reading List](). 

In order to select an appropriate k for the mkNNG, we can use multiple algorithms (to account for their variation) and plot the resulting number of clusters n against k, across k = 1 to k = 60, or approximately 3/4 N. Let's first construct the graphs with default community detection and pass them to the selection plot function:

```r
graphs <- netview(oysterMatrix, oysterData, k=1:60, cluster = TRUE, options=oysterOptions)
kPlot <- plotSelection(graphs, options=oysterOptions)
```

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P1.png)

The selected algorithms show a general congruence with some variation in individual resolution across the mkNNGs. You can see, for instance, that the state-of-the-art Infomap algorithm continously detects clusters at a higher resolution, while the fast-greedy modularity optimisation detects fewer clusters in the topology of the network. The shape of the curve is inherent to mkNNGs across a wide variety of data (see [Examples]()) and shows a community-based approximation to the construction of population-level mkNNGs.

At low values of k (k < 10) a large number of communities is detected. There is some important information on the genetically most similar samples in the data (for instance at k = 1, single mNNs), but little about population-wide structure. This is because at low values of k, few edges produce a sparse network and consequently, the algorithms find many isolated communities (**A**, for illustration we have selected results from Walktrap).

As we increase k, the number of detected communities declines, first rapidly (k < 10) and then more slowly (k > 10). The rapidly declining range of n across k is important since it indicates where little structure is found in the topology, and we want to avoid this range of the parameter for population-level analysis.

There are exceptions discussed by Neuditschko et al. (2012), where a step-wise decrease from k = 10 can compensate for some data with few individuals per sampled population. Also, if population-wide structure is not of importance, but we want to detect only the most similar samples in the data, low values of k may be appropriate for the analysis (see [MRSA Tutorial]()).

In the slowly declining part of the k-selection plot, fine-scale structures emerge in the mkNNG. This threshold (after the rapidly declining 'assembly' phase of the population network) approximately corresponds to the empirical value of k = 10 (**B**) previously used by us and our colleagues (Neuditschko et al. 2012, Steinig et al. 2015).

As k increases, n decreases in the elbow of the plot until it stabilizes in the tail - this region shows the values for k, at which we construct a network depicting the large-scale similarity of samples in the mkNNG (**C** and **D**).

The plot is representative of the 'zoom' effect discussed by Neuditschko et al. (2012). Although not suggesting an optimal value for k, in the oyster data we can limit our range to k >= 10 and select either a lower value for higher resolution on the fine-scale structures in the network or a more conservative value for looking at large-scale structure in the tail of the plot at approximately k >= 30. The ultimate choice depends on your questions on the data and purpose of your study and should be justified in the application to your data.

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_Panel.png)

######Running NetView
---

Now that we have an idea of which network topologies may be appropriate for our analysis, let's generate the networks. We will make two runs to generate a list of network objects for visualization in iGraph and a list of widgets holding the D3 visualization with networkD3. We will compute the networks from k = 10 to k = 60 in increments of 5 and use our previously defined oysterOptions. 

On the first run, we will also use the default community-detection algorithms (Infomap, Fast-Greedy, Walktrap) to find communities and decorate the graphs with the resulting objects. We will use these later to demonstrate how to highlight the communities of a particular mkNNG.

```r
kRange <- seq(10, 60, by=10)
graphs <- netview(oysterMatrix, oysterData, k=kRange, options = oysterOptions, cluster=TRUE)
graphsD3 <- netview(oysterMatrix, oysterData, k=kRange, options = oysterOptions, networkD3 = TRUE)
```

######Network Visualizations
---

Now that we have a list of the networks, let's visualize them - there are two great libraries we will use for graph-analysis and -visualization in R: the comprehensive analysis library [iGraph]() and the [D3]()-based visualizations from [networkD3](). In iGraph, you can basically do anything related to graph objects (as returned by our first run), including plotting, community-detection, edge analysis and so on. D3 is a magnificent toolkit to generate interactive data-driven visualizations as implemented for graphs in networkD3. The visualizations may be computationally intensive for very large graphs. For presnetation, you can save them as HTML using `save = TRUE`. 

A great thing about networks is that you can attach meta data of your samples to the network nodes, for example, to colour nodes by geographical origin, highlight antibiotic resistance distribution in your population, attach labels for sex, phenotype, pedigree and so on. This makes it really easy to compare sample data to the underlying, genetic structure depicted by the mkNNG.

Ok, let's start with simple plotting in iGraph. The graph objects get decorated with the Fruchtermann-Reingold layout in NetView, but we can change [layouts](http://www.inside-r.org/packages/cran/igraph/docs/layout) and vertex (node) attributes using the adapted [plot function](http://igraph.org/r/doc/plot.common.html) from iGraph:

```r
# Get graphs from list
k10 <- graphs$k10

# Simple plot with iGraph
plot(k10)
```

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P11.jpeg)

That's nice, but you can use the full range of options for plotting to configure your graph, for example:

```r
plot(k10, vertex.size=7, vertex.label=NA)

# Plot with different layout (Kamada-Kawai)
plot(k10, vertex.size=7, vertex.label=NA, layout=layout.kamada.kawai(k10))

# Use data frame to set labels as ID
plot(k10, vertex.size=7, vertex.label=as.character(oysterData$ID))
```

Ok, there are a lot of things to customize your graph with, but let's see the interactive version with networkD3:

```r
graphsD3$k10
```

Hover over nodes to see their ID and play around with the force-directed layout, it's fun to watch! You can check the documentation (`?netview` and `?networkD3`) for more parameters to adjust the network visualizations in `netviewOptions`.

######Selecting networks and cluster configurations from mkNNGs
---

How do we select the *right* configuration of the mkNNG? Unfortunately, there is no one-value-fits-it-all solution - a succinct comment on cluster selection can be found in the [DAPC Tutorial]() by Thibaut Jombart. Instead, the selection of an appropriate topology and community-resolution depends on what we ask from our data. 

Are we interested in the large-scale population-level structure, e.g. to investigate admixed populations or define clades in a phylogeny? Or are we interested in the potential fine-scale sub-structure within the populations, e.g. for family-level analysis of breeding populations? Or are we interested in only finding the single mNN for each sample in the network to trace high genetic similarity in a geographical context (see [MRSA Tutorial]())? 

In fine-scale mkNNGs, pedigree data or detailed meta data for samples can help to validate structures in the topology. For exampe, we used manual pedigree data to trace genetic lineages in networks of cultured *P. maxima* and found that the network topology at k = 10 accurately grouped related individuals and families at a high-resolution (Steinig et al. 2015).

Although we have limited our range of k using the selection plot, we still need to look at some configurations within this range and finally, select one or more networks appropriate for discussion or further analysis. Regarding the oyster populations, we are interested in the large-scale admixture of the three geographically distinct populations, as well as potential sub-structures within each population. 

Let's look at networks and communities in the tail of the selection plot (k = 40), in the elbow (k = 25) and finally at our resolution threshold at k = 10. We will highlight the lower-resolution communities from Walktrap and compare them against Infomap communities at k = 10 in order to show the difference in algorithm choice:

```r
k40 <- graphs$k40
k25 <- graphs$k25
k10 <- graphs$k10

plot(k40, vertex.size=7, vertex.label=NA, mark.groups=communities(k40$walktrap))
plot(k25, vertex.size=7, vertex.label=NA, mark.groups=communities(k25$walktrap))
plot(k10, vertex.size=7, vertex.label=NA, mark.groups=communities(k10$walktrap))
```

######k = 40
---

At k = 40, the network topology and  clusters show the admixed populations from Bali (blue) and West-Papua (purple), a separate population of Aru Islands (green) and some interesting, separating oysters from Bali and West Papua, which get grouped with Aru Islands.

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P5.jpeg)

######k = 25
---

At k = 25, the population at West Papua separates partially from Bali, while  the separating samples fro Bali and West Papua remain connected to Aru as well as forming a separate group with oysters from West Papua. 

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P6.jpeg)

######k = 10
---

At k = 10, the network does not remain fully connected but seperates into modules. At the threshold resolution, fine-scale structure within the populations is evident in Aru Islands (retaining two separate samples from Bali), as well as the formation of single groups from Bali (previously in main Bali) and West Papua (previously connected to Aru). 

Additional structure is indicated within the main population from West Papua, but is not detected by the Walktrap algorithm. Connecting individuals from Bali and West Papua are grouped in a small cluster and one sample from Aru Islands is singled out with no mNNs. At the limit of our resolution of the network, it is therefore useful to know the context of the modules at higher values of k.

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P7.jpeg)

######k = 10 with Infomap
---

Infomap finds the same cluster configuration, with the exception of additional substructure in the main population of West Papua, as indicated in the distribution of edges between the two sub-structure in the network topology.

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P8.jpeg)

######Admixture Networks
---

An alernative approach to selecting an appropriate parameter value, would be to run supplementary analyses with other established methods such as [Admixture](). This allows you to select an optimal configuration according to the software's methods and you can then use this cluster assignment find a network topology where the selected algorithm finds an equal number of clusters. If you use NetView as a secondary analysis, you can also visualize the proportion results from your admixture analysis  as pie nodes to compare to your mkNNGs.

We have implemented a couple of functions that allow you to run and handle output from Admixture in R. You can also run the analysis separately and provide only the outputs for plotting. Tthe program must be in your $PATH. We provide the analysis function with a zip-file containing the `.bed`, `.bim`, `.fam` files of the oyster data (same sample order as data frame and distance matrix previously, see example directory) for input to Admixture. We will then run the program from K = 2 - 10 with cross-validation replicates by 20 and plot the error to select the optimal K:

```r
results <- runAdmixture("oyster.zip", project="oyster_admixture", K=2:10, processors=2, crossValidation=20)
cvPlot <- plotValidation(results$crossError)
```

The minimum in the cross-validation error plot is at K = 4:

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P9.jpeg)

We will use this value to first select a network with the same number of clusters according to Walktrap and compare the mkNNG to the admixture proportions per sample from Admixture. We will then use the same proportions to compare against the sub-structure network at k = 10.

If you provide your own output files for plotting (in original output format: `.Q`, `.P`). These also need to be in a zipped directory. Let's use the output from our admixture runs across K and labels from our graph data drame to plot the admixture bar-plot using [structurePlot]() at K = 4. We will use the qualitative `Dark2` colour palette from [RColorBrewer]() with all colours (`paletteN`) to distinguish the K clusters (for other available palettes, see `display.brewer.all()`). You can also pass a vector of colour names (length K) to the `palette` argument.

```r
structurePlot <- plotAdmixture(results$outFile, oysterData, K=4, palette="Dark2", paletteN=8, structurePlot=TRUE)
```

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P10.jpeg)

Earlier, we ran the Walktrap community-detection on our mkNNGs. Let's use the k-selection plot data to find a network configuration with Walktrap, that also contains four clusters:

```r
clusters <- kPlot$Data
clustersK4 <- clusters[clusters$n == 4 & clusters$Algorithm == "Walktrap",]
```

This indicates four clusters at k = 25, 30 and 35. Let's have a look at the individual admixture porportions in the context of the network topology at k = 25 and k = 30, highlighting the communites derived from Walktrap:

```r
k25 <- graphs$k25
k30 <- graphs$k30

g25 <- plotAdmixture(results$out_file, oysterData, graph=k25, K=4, palette="Dark2", paletteN=8)
g30 <- plotAdmixture(results$out_file, oysterData, graph=k30, K=4, palette="Dark2", paletteN=8)

plot(g25, vertex.shape="pie", vertex.pie=g25$pie.values, vertex.size=7, vertex.label=NA, mark.groups=communities(k25$walktrap))

plot(g30, vertex.shape="pie", vertex.pie=g30$pie.values, vertex.size=7, vertex.label=NA, mark.groups=communities(k30$walktrap))
```

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P12.jpeg)

![](https://github.com/esteinig/netview/blob/master/img/Tutorial_P13.jpeg)


