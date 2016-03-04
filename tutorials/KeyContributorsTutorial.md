## Genetic Contribution Scores and Admixture Networks with NetView

![](https://github.com/esteinig/netview/blob/master/img/GCS_Flow.png)

This tutorial implements the workflow described in [Neuditschko et al. 2016](), which determine the genetic contribution of individuals within populations using a relationship matrix and its Eigen Value Decomposition (EVD). In combination with the network visualization from NetView and the computation of ancestry porportions with Admixture, this approach can help to select key contributors for informed management decisions in conservation genetics and animal breeding applications. 

Here, we focus on the implementation and usage of the method, rather than its mathematical foundation and interpretation which are described in detail in the publication. We will use three data sets to exemplify the workflow: pearl oysters (since computation is fast and the example data is included in NetView), simulated populations and highly structured experimental sheep populations (both from the publication with data files [available](https://github.com/esteinig/netview/blob/master/files) in the repository for NetView).

The determination of the genetic contribution scores (GCS) is very simple using `findKeyContributors`. Input is a relationship matrix (N x N) and the meta data file from NetView (N), where individuals are in the same row order. You can also use the distance matrix (D) from NetView, which will be converted to a similarity matrix by 1 - D, using the parameter `distMatrix`. Default values for parameters for Horn's Parallel Analysis should be fine for now, but number of iterations and significance (centile) values for determining the number of significant principal components (PC) can be adjusted in the parameters `paranIterations` and `paranCentile`.

---

####Pearl Oysters

The data used for this part is from our initial analysis of 83 pearl oysters from Aru Islands, Bali and West Papua. The data files can be loaded via the data function in R. For our purposes, the oyster data demonstrates the basic workflow of calculating GCS and visualizing key contributors with NetView.

[*Pinctada maxima*](http://dx.doi.org/10.5061/dryad.p3b3f), n = 83, genotyped at 999 SNPs after QC with PLINK v1.07:

* `--mind 0.1`
* `--maf 0.01`
* `--geno 0.1`
* `--hwe 0.001`

Shared-allele distance matrix via `--distance-matrix` in PLINK.

[Data files for Admixture](https://github.com/esteinig/netview/blob/master/files)

######Dependencies

* `netview`
* `scales`

---

We will run the analysis in four steps: 

1. Mutual nearest-neighbour networks (mkNNGs) are constructed with NetView and assuming we select the appropriate mkNNG (see [Pearl Oyster Tutorial]())
2. Admixture is run with a cross-validation error plot to generate the ancestry proportions at a particular value of K.
3. GCS are determined using `findKeyContributors` and - if necessary - rescaled to highlight top contributors in the mkNNG.
4. Ancestry proportions and GCS are visualized in the network topology as node pie charts and node sizes, respectively.

```r
library(netview)
library(scales)

data(oysterData)
data(oysterMatrix)

#### Step 1: NetView ####

# Run NetView
graphs <- netview(oysterMatrix, oysterData, k=10:30)

# Extract graph at k = 10
k10 <- graphs$k10

#### Step 2: Admixture ####

# Run admixture and check cross-validation error to select K = 4, for files see above in section Data
cvePlot <- runAdmixture("/home/esteinig/oyster.bed", K=2:10, processors=2, plotValidation=T)

# Get the admixture graph at k = 10
admGraph <- plotAdmixture("/home/esteinig/oyster.4.Q", oysterData, graph=k10, structurePlot=F)

#### Step 3: GCS ####

# Compute GCS
gcsOyster <- findKeyContributors(oysterMatrix, oysterData, distMatrix=TRUE)

# Order output and check key contributors according to GCS
gcsOrdered <- gcsOyster[order(gcsOyster$GCS, decreasing=TRUE),]

# Rescale GCS vector to highlight key contributors
scaledGCS <- rescale(gcsOyster$GCS, c(7, 15))

#### Step 4: Visualization ####

# Using scaled GCS in iGraph
plot(admGraph, vertex.shape="pie", vertex.pie=admGraph$pie.values, vertex.size=scaledGCS, vertex.label=NA)

```

![](https://github.com/esteinig/netview/blob/master/img/Oyster_GCS.jpeg)





