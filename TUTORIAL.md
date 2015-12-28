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

Let's now set some options and make the data columns accessible for the graph construction. We will specify only the grouping column, since the other two are already named "ID" and "Colour" by default. The group will be used later to colour the nodes in the networks with networkD3. We also set a title for our k-selection plot:

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

In the slowly declining part of the k-selection plot, fine-scale structures emerge in the mkNNG. This threshold, after the rapidly declining 'assembly' phase of the population network, in this case corresponds to the empirical values for k = 10 previously used by us and our colleagues (Neuditschko et al. 2012, Steinig et al. 2015):

![]

As k increases, n decreases in the elbow of the plot until it stabilizes in the tail - this region shows the values for k, at which we construct a network depicting the large-scale similarity of samples in the mkNNG:

![]

The plot is representative of the 'zoom' effect discussed by Neuditschko et al. (2012). Although not suggesting an optimal value for k, in the oyster data we can limit our range to k >= 10 and select either a lower value for higher resolution on the fine-scale structures in the network or a more conservative value for looking at large-scale structure in the tail of the plot at approximately k >= 30. The ultimate choice depends on your questions on the data and purpose of your study and should be justified in the application to your data.

######Running NetView
---

Now that we have an idea of which network topologies may be appropriate for our analysis, let's generate the networks. We will make two runs to generate a list of network objects for visualization in iGraph and a list of widgets holding the D3 visualization with networkD3. We will compute the networks from k = 10 to k = 60 in increments of 5 and use our previously defined oysterOptions:

```r
graphs <- netview(distMatrix, metaData, k=10:60, step=5, options = oysterOptions)

graphsD3 <- netview(distMatrix, metaData, k=10:60, step=5, options = oysterOptions, networkD3 = TRUE)
```

######Network Visualizations
---

Now that we have a list of the networks, let's visualize them - there are two great libraries, the comprehensive graph-analysis library [iGraph]() and the [D3]()-based networkD3. In iGraph, you can basically do anything related to graph objects (as returned by our first run), including plotting, community-detection, node and edge analysis and so on. D3 is a magnificent toolkit to generate interactive data-driven visualizations and the library networkD3 can generate really pretty networks, but may be computationally intensive for very large graphs. A great thing about networks is that you can attache meta data of your samples to the network nodes, for instance, colour them by geographical origin, highlight antibiotic resistance distribution in your population, attach labels for sex, phenotype, population and so on. This makes it really easy to compare sample data to the underlying, genetic structure depicted by the mkNNG.

Ok, let's start with simple plotting in iGraph:



