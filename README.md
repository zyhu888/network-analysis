Collaboration Network Analysis
================

## Project Overview

This project aims to analyze the collaboration network of
Otolaryngolotist from the United States. The data were collected and
maintained by research group led by Dr. Alexander Gelbard from the
[Department of Otolaryngology](https://www.vumc.org/ent/) at the
[Vanderbilt University Medical Center](https://www.vumc.org/main/home)
(VUMC). The statistical analyses were led by Drs. Panpan Zhang from the
[Department of
Biostatistics](https://www.vumc.org/biostatistics/vanderbilt-department-biostatistics)
at VUMC and Jun Yan from the [Department of
Statistics](https://statistics.uconn.edu/) at the University of
Connecticut (UConn).

## Network Measures

For each of the network measures listed in this section, we will not
only investigate the existing methods in the literature but also explore
the potential of new method development.

### Assortativity

Most standard methods can be found in the `igraph` package (Csárdi et
al. 2024).

#### Methods for Weighted, Directed Networks

- Yuan, Yan, and Zhang (2021)
- Yuan et al. (2023)

#### Methods (Pending for Development)

- Liu et al. (2018)
- Tu et al. (2023)
- Tu, Li, and Shepherd (2024)

### Clustering Coefficient

### Global Efficiency

### Community Detection

### Node-Level Centrality

#### PageRank

#### Betweenness

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-pkg_igraph" class="csl-entry">

Csárdi, G., T. Nepusz, V. Traag, S. Horvát, D. Noom, and K. Müller.
2024. *<span class="nocase">igraph</span>: Network Analysis and
Visualization in R*. R Studio.
<https://CRAN.R-project.org/package=igraph>.

</div>

<div id="ref-liu2018covariate" class="csl-entry">

Liu, Qi, Chun Li, Valentine Wanga, and Bryan E. Shepherd. 2018.
“Covariate-Adjusted Spearman’s Rank Correlation with Probability-Scale
Residuals.” *Biometrics* 74 (2): 595–605.

</div>

<div id="ref-tu2024between" class="csl-entry">

Tu, Shengxin, Chun Li, and Bryan E. Shepherd. 2024. *Between- and
Within-Cluster Spearman Rank*. Vanderbilt University Medical Center.
<https://arxiv.org/pdf/2402.11341>.

</div>

<div id="ref-tu2023rank" class="csl-entry">

Tu, Shengxin, Chun Li, Donglin Zeng, and Bryan E. Shepherd. 2023. “Rank
Intraclass Correlation for Clustered Data.” *Statistics in Medicine* 42
(24): 4333–48.

</div>

<div id="ref-yuan2023generating" class="csl-entry">

Yuan, Yelie, Tiandong Wang, Jun Yan, and Panpan Zhang. 2023. “Generating
General Preferential Attachment Networks with R Package Wdnet.” *Journal
of Data Science* 21 (3): 538–56.

</div>

<div id="ref-yuan2021assortativity" class="csl-entry">

Yuan, Yelie, Jun Yan, and Panpan Zhang. 2021. “Assortativity Measures
for Weighted and Directed Networks.” *Journal of Complex Networks* 9
(2): cnab017.

</div>

</div>
