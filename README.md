maxnetic
================

[Maxnetic](https://github.com/BigelowLab/maxnetic) provide supplementary
tools to augment the [maxnet](https://CRAN.R-project.org/package=maxnet)
package.

Metrics like, TPR, FPR, ROC and AUC are all computed with the
[AUC](https://CRAN.R-project.org/package=AUC) R package.

### Requirements

- [R v 4.1+](https://www.r-project.org/)
- [AUC](https://CRAN.R-project.org/package=AUC)
- [dplyr](https://CRAN.R-project.org/package=dplyr)
- [ggplot2](https://CRAN.R-project.org/package=ggplot2)

### Installation

    if (!("AUC" %in% rownames(installed.packages())) install.packages("AUC")
    remotes::install_github("BigelowLab/maxnetic")

### Functionality

- `TPR()` true positive rate (“sensitivity”)
- `FPR()` false positive rate (“specificity”)
- `ROC()` receiver operator values
- `AUC()` compute are under curve of ROC
- `plot()` plot an `ROC` class object (base graphics or gpplot2)
- `write_maxnet()` and `read_maxnet()` for IO to R’s serialized file
  format

### Usage

``` r
suppressPackageStartupMessages({
  library(maxnet)
  library(dplyr)
  library(maxnetic)
  library(ggplot2)
})
```

Next we load data, make a model and then a data frame with the input
labels and the output prediction.

``` r
obs <- dplyr::as_tibble(maxnet::bradypus)

mod <- maxnet(obs$presence, dplyr::select(obs, -presence))
pred <- predict(mod, newdata = bradypus, na.rm = TRUE, type = "cloglog")

x <- dplyr::tibble(label = obs$presence,
                   pred = pred[,1])
dplyr::glimpse(x)
```

    ## Rows: 1,116
    ## Columns: 2
    ## $ label <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    ## $ pred  <dbl> 0.1112753, 0.1128391, 0.7038097, 0.1928364, 0.2621609, 0.4292576…

Collect the responses.

``` r
r <- plot(mod, type = "cloglog", plot = FALSE)
```

Plot the response curves

``` r
plot(mod, type = 'cloglog', mar = c(2,2,2,1))
```

![](README_files/figure-gfm/plot_response-1.png)<!-- -->

Now compute ROC and show using either base or ggplot2 graphics.

``` r
plot_ROC(x, use = "base", title = "Base Graphics")
```

![](README_files/figure-gfm/roc-1.png)<!-- -->

``` r
plot_ROC(x, use = "ggplot", title = "ggplot2 Graphics")
```

![](README_files/figure-gfm/roc-2.png)<!-- -->
