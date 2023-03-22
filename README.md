maxnetic
================

[Maxnetic](https://github.com/BigelowLab/maxnetic) provide supplementary
tools to augment the [maxnet](https://CRAN.R-project.org/package=maxnet)
package.

Information about ROC and AUC were gleaned from the [Receiver operating
characteristic](#%20https://en.wikipedia.org/wiki/Receiver_operating_characteristic)
wikipedia page.

### Requirements

-   [R v 4.1+](https://www.r-project.org/)
-   [dplyr](https://CRAN.R-project.org/package=dplyr)
-   [ggplot2](https://CRAN.R-project.org/package=ggplot2)

### Installation

    remotes::install_github("BigelowLab/maxnetic")

### Functionality

-   `TPR()` true positive rate,
-   `FPR()` false positive rate
-   `ROC()` receiver operator values
-   `AUC()` compute are under curve of ROC
-   `plot()` plot an `ROC` class object (base graphics or gpplot2)
-   `write_maxnet()` and `read_maxnet()` for IO to R’s serialized file
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

x <- dplyr::tibble(pres = obs$presence,
                   pred = pred[,1])
dplyr::glimpse(x)
```

    ## Rows: 1,116
    ## Columns: 2
    ## $ pres <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    ## $ pred <dbl> 0.1112753, 0.1128391, 0.7038097, 0.1928364, 0.2621609, 0.4292576,…

Collect the responses.

``` r
r <- plot(mod, type = "cloglog", plot = FALSE)
```

<<<<<<< HEAD
![](README_files/figure-gfm/collect_response-1.png)<!-- -->
=======
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ cld6190_ann: num  26.8 27.4 28.1 28.7 29.3 ...
    ##  $ pred       : num  0.818 0.818 0.818 0.818 0.818 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ dtr6190_ann: num  42 43.5 44.9 46.4 47.8 ...
    ##  $ pred       : num  0.063 0.063 0.063 0.063 0.063 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ frs6190_ann: num  -20 -17.6 -15.2 -12.7 -10.3 ...
    ##  $ pred       : num  0.468 0.468 0.468 0.468 0.468 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ h_dem: num  -513 -450 -388 -326 -264 ...
    ##  $ pred : num  0.735 0.735 0.735 0.735 0.735 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ pre6190_ann: num  -18.5 -16.14 -13.77 -11.41 -9.05 ...
    ##  $ pred       : num  0.447 0.447 0.447 0.447 0.447 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ pre6190_l1: num  -16.3 -14.3 -12.3 -10.4 -8.4 ...
    ##  $ pred      : num  0.915 0.915 0.915 0.915 0.915 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ pre6190_l10: num  -23.8 -20.9 -18 -15.1 -12.3 ...
    ##  $ pred       : num  0.0319 0.0319 0.0319 0.0319 0.0319 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ pre6190_l4: num  -18.8 -16.52 -14.24 -11.96 -9.68 ...
    ##  $ pred      : num  0.327 0.327 0.327 0.327 0.327 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ pre6190_l7: num  -20.8 -18.3 -15.8 -13.2 -10.7 ...
    ##  $ pred      : num  0.147 0.147 0.147 0.147 0.147 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ tmn6190_ann: num  -126 -122 -118 -115 -111 ...
    ##  $ pred       : num  6.68e-05 6.68e-05 6.68e-05 6.68e-05 6.68e-05 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ tmp6190_ann: num  -22.6 -19.25 -15.91 -12.56 -9.22 ...
    ##  $ pred       : num  0.846 0.846 0.846 0.846 0.846 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ tmx6190_ann: num  75 78.2 81.3 84.5 87.6 ...
    ##  $ pred       : num  1 1 1 1 1 1 1 1 1 1 ...
    ## 'data.frame':    100 obs. of  2 variables:
    ##  $ vap6190_ann: num  -25.5 -21.8 -18.1 -14.4 -10.7 ...
    ##  $ pred       : num  0.572 0.572 0.572 0.572 0.572 ...
    ## 'data.frame':    14 obs. of  2 variables:
    ##  $ ecoreg: chr  "1" "2" "3" "4" ...
    ##  $ pred  : num  0.383 0.462 0.11 0.344 0.153 ...
>>>>>>> 61a47fd213596b61e6807af26d97ab4415657afc

Plot the response curves

``` r
plot(mod, type = 'cloglog', mar = c(2,2,2,1))
```

![](README_files/figure-gfm/plot_response-1.png)<!-- -->

Now compute ROC and show

``` r
roc <- ROC(x)
plot(roc, use = "base", title = "Base Graphics")
```

![](README_files/figure-gfm/roc-1.png)<!-- -->

``` r
plot(roc, use = "ggplot", title = "ggplot2")
```

![](README_files/figure-gfm/roc-2.png)<!-- -->
