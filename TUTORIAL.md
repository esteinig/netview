### Pearl Oyster Tutorial

######Data
---

The data used for this tutorial is from our initial analysis of 83 pearl oysters from Aru Islands, Bali and West Papua. The data file can be found at Dryad or loaded via the data function in R. This is a fairly small data set and calculations for larger graphs can take longer. For our purposes though, the oyster data can demonstrate 

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
library(netview)
data(netview)

distMatrix <- data$distMatrix
metaData <- data$metaData
```

Have a look at distMatrix and metaData. The rows in the distance matrix are ordered the same as the rows in the data frame. Let's see what we have named the data columns and test that the number of samples is the same in both matrix and meta data:

```r
names(metaData)
nrow(metaData) == nrow(distMatrix)
is.matrix(distMatrix)
is.data.frame(metaData)
```

This should return:

```
[1] "ID" "Population" "Colour" 
[1] TRUE
[1] TRUE
[1] TRUE
```

Let's now set some options and make the data columns accessible for the graph construction. We will specify only the grouping column, since the other two are already named "ID" and "Colour" by default. Colour is defined for populations (green: Aru Islands, blue: Bali, purple: West Papua). The group will be used later to colour the nodes in the networks with networkD3. We also set a title for our k-selection plot:

```r
oysterOptions <- netviewOptions(nodeGroup="Population", selectionTitle="Oyster k-Selection")
```

######Selecting k for mNNGs
---

Before we run the final networks, we want to know an appropriate value for k, which defines the maximum number of mutual nearest neighbours that can be connected by edges during construction of the mkNNG. The choice of an optimal value of k is still a challenge (Neuditschko et al. 2012). Essentially, we are looking for a network topology within the possible range of mkNNGs that represents the genetic similarity of isolates at an appropriate level of resolution on the genetic structure in the data, depending on your question and application of your data. We also want to avoid the selection of a network that has very little information on population-wide structure. 

We can use community (cluster) detection algorithms as a proxy for showing the effect of k on the construction and structure of the mkNNG. There are inherent differences to the way these algorithms detect communities in the network topology. Further reading can be found in the [Community-Detection]() section and the [Reading List](). In order to select an appropriate k for the mkNNG, we can use multiple algorithms (to account for their variation) and plot the resulting number of clusters n against k, across k = 1 to k = 60 (approx. 3/4 N):

```r
netview(distMatrix, metaData, k=1:60, step=1, options = oysterOptions, selectionPlot = TRUE)
```

![]

The selected algorithms show a general congruence with some variation in individual resolution across the mkNNGs. You can see, for instance, that the state-of-the-art Infomap algorithm continously detects clusters at a higher resolution, while the fast-greedy modularity optimisation detects fewer clusters in the topology of the network. The shape of the curve is inherent to mkNNGs across a wide variety of data (see [Examples]()) and shows a community-based approximation to the construction of population-level mkNNGs.

At low values of k (k < 10) a large number of communities is detected. There is some important information on the genetically most similar samples in the data (for instance at k = 1, single mNNs), but little about population-wide structure. This is because at low values of k, few edges produce a sparse network with little information on larger-scale clustering of individuals and consequently, the algorithms find many isolated communities:

![]

As we increase k, the number of detected communities declines, first rapidly (k < 10) and then more slowly (k > 10). The rapidly declining range of n across k is important since it indicates where little structure is found in the topology, and we want to avoid this range of the parameter for population-level analysis. There are exceptions discussed by Neuditschko et al. (2012), where a step-wise decrease from k = 10 can compensate for some data with few individuals per sampled population. Also, if population-wide structure is not of importance, but we want to detect only the most similar samples in the data, low values of k may be appropriate for the analysis (see [MRSA Tutorial]()). The oyster network and detected communities (polygons) looks like this at values of k < 10:

![]

In the slowly declining part of the k-selection plot, fine-scale structures emerge in the mkNNG. This threshold (after the rapidly declining 'assembly' phase of the population network) approximately corresponds to the empirical value of k = 10 previously used by us and our colleagues (Neuditschko et al. 2012, Steinig et al. 2015):

![]

As k increases, n decreases in the elbow of the plot until it stabilizes in the tail - this region shows the values for k, at which we construct a network depicting the large-scale similarity of samples in the mkNNG:

![]

The plot is representative of the 'zoom' effect discussed by Neuditschko et al. (2012). Although not suggesting an optimal value for k, in the oyster data we can limit our range to k >= 10 and select either a lower value for higher resolution on the fine-scale structures in the network or a more conservative value for looking at large-scale structure in the tail of the plot at approximately k >= 30. The ultimate choice depends on your questions on the data and purpose of your study and should be justified in the application to your data.

######Running NetView
---

Now that we have an idea of which network topologies may be appropriate for our analysis, let's generate the networks. We will make two runs to generate a list of network objects for visualization in iGraph and a list of widgets holding the D3 visualization with networkD3. We will compute the networks from k = 10 to k = 60 in increments of 5 and use our previously defined oysterOptions. On the first run, we will also use the default community-detection algorithms (Infomap, Fast-Greedy, Walktrap) to find communities and decorate the graphs with the resulting objects. We will use these later to demonstrate how to highlight the communities of a particular mkNNG.

```r
graphs <- netview(distMatrix, metaData, k=10:60, step=5, options = oysterOptions, cluster=TRUE)

graphsD3 <- netview(distMatrix, metaData, k=10:60, step=5, options = oysterOptions, networkD3 = TRUE)
```

For demonstration, we will continue with the fine-scale (threshold) network at k = 10, but also have brief look at how the network looks like at k = 30.

######Network Visualizations
---

Now that we have a list of the networks, let's visualize them - there are two great libraries we will use for graph-analysis and -visualization in R: the comprehensive analysis library [iGraph]() and the [D3]()-based visualizaions from networkD3. In iGraph, you can basically do anything related to graph objects (as returned by our first run), including plotting, community-detection, edge analysis and so on. D3 is a magnificent toolkit to generate interactive data-driven visualizations as implemented for graphs in networkD3. The visualizations may be computationally intensive for very large graphs (especially in RStudio), but you can save them as HTML using `save=TRUE`. A great thing about networks is that you can attach meta data of your samples to the network nodes, for example, to colour nodes by geographical origin, highlight antibiotic resistance distribution in your population, attach labels for sex, phenotype, pedigree and so on. This makes it really easy to compare sample data to the underlying, genetic structure depicted by the mkNNG.

Ok, let's start with simple plotting in iGraph. The graph objects get decorated with the Fruchtermann-Reingold layout in NetView, but we can change [layouts](http://www.inside-r.org/packages/cran/igraph/docs/layout) and vertex (node) attributes using the adapted [plot function](http://igraph.org/r/doc/plot.common.html) from iGraph:

```r
# Get graphs from list
k10 <- graphs$k10

# Simple plot with iGraph
plot(k10)
```

![]

That's nice, but let's clean it up a bit:

```r
# Clean up graph
plot(k10, vertex.size=7, vertex.label=NA)

# Plot with different layout (Kamada-Kawai)
plot(k10, vertex.size=7, vertex.label=NA, layout=layout.kamada.kawai(k10))

# Use data column ID to set labels
plot(k10, vertex.size=7, vertex.label=as.character(metaData$ID))

```

Ok, there are a lot of things to customize your graph with, but let's see the interactive version with networkD3:

```r
graphsD3$k10
```

Hover over nodes to see their ID and play around with the force-directed layout, it's fun to watch! You can check the documentation ( `?netview` and `?networkD3` ) for more parameters to adjust the network visualizations in netviewOptions.

######Selecting networks and cluster configurations from mkNNGs
---

Seeing the networks is great, but how do we select the *right* configuration of the mkNNG? Unfortunately, there is no one-value-fits-it-all solution (a succinct discussion on clusters can be found in the [DAPC Tutorial]() by Thibaut Jombart). Instead, the selection of an appropriate topology and community-resolution depends on what we ask from our data. Are we interested in the large-scale population-level structure, e.g. to investigate admixed populations or define clades in a phylogeny? O are we interested in the potential fine-scale sub-structure within the populations, e.g. for family-level analysis of breeding populations? Or are we interested in only finding the single mNN for each sample in the network to trace high genetic similarity in a geographical context (see [MRSA Tutorial]())? In particular with fine-scale mkNNGs, pedigree data or detailed meta data for samples can help to validate structures in the topology. For exampe, we used manual pedigree data to trace genetic lineages in networks of cultured *P. maxima* and found that the network topology at k = 10 accurately grouped related individuals and families at a high-resolution (Steinig et al. 2015).

Although we have limited our range of k using the selection plot, we still need to look at some configurations within this range and finally, select one or more appropriate for discussion and further analysis. In the case of the oyster populations, we are interested in the large-scale admixture of the three geographically distinct populations, as well as potential sub-structures within each population. Let's first tracea look at networks and communities in the tail of the selection plot (k = 40), in the elbow (k = 20) and finally a our resolution minimum at k = 10. We will highlight the lower-resolution communities from Walktrap and compare them against Infomap communities at k = 10 to show the difference in algorithm choice for finding clusters:

```r
k40 <- graphs$k40
k25 <- graphs$k25
k10 <- graphs$k10

plot(k40, vertex.size=7, vertex.label=NA, mark.groups=communities(k40$waltrap))
plot(k25, vertex.size=7, vertex.label=NA, mark.groups=communities(k25$walktrap))
plot(k10, vertex.size=7, vertex.label=NA, mark.groups=communities(k10$walktrap))
```

**k = 40**
![]

At k = 40, the network topology and  clusters show the admixed populations from Bali (blue) and West-Papua (purple), a separate population of Aru Islands (green) and some interesting, separating oysters from Bali and West Papua, which get grouped with Aru Islands.

**k = 25**
![]

At k = 25, the population at West Papua separates partially from Bali, while  the separating samples fro Bali and West Papua remain connected to Aru as well as forming a separate group with oysters from West Papua. 

**k = 10**
![]

At k = 10, the network does not remain fully connected but seperates into modules. At this threshold resolution, fine-scale structure within the populations is evident in Aru Islands (retaining the two separate samples from Bali), as well as the formation of single groups from Bali (previously in main Bali) and West Papua (previously connected to Aru). Additional structuring becomes evident within the main population from West Papua, but is not detected by the Walktrap algorithm. COnnecting individuals from Bali and West Papua are grouped in a small cluster, and one sample from Aru Islands is singled out with no mNNs. At the limit of our resolution of the network, it is therefore useful to know the context of the modules at higher values of k. Let's have a look at the clusters the Infomap algorithm finds at k = 10:

**k = 10: Infomap**
![]

Infomap finds exactly the same clusters, with the exception of the additional substructure in the main population in West Papua. After choosing a suitable network configuration for your purpose, we would generally recommend to report on the progression of the networks across k in a supplementary section, with justifications for your choice of algorithm and k for the mkNNG. In this case, we would report on the networks at k = 40 and k = 10 for admixture and substructure, but also refer to the intermediate step at k = 25 (or others).

Another approach would be to run supplementary analyses with other established methods such as [Admixture](). This allows you to select an optimal configuration according to the software's methods and you can then use this cluster assignment as colours or admixture proportions to highlight on the nodes of your mkNNGs.

######Admixture Networks
---



