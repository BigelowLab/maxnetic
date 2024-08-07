maxnetic
================

[Maxnetic](https://github.com/BigelowLab/maxnetic) provide supplementary
tools to augment the [maxnet](https://CRAN.R-project.org/package=maxnet)
package.

### Requirements

- [R v 4.1+](https://www.r-project.org/)
- [AUC](https://CRAN.R-project.org/package=AUC)
- [dplyr](https://CRAN.R-project.org/package=dplyr)
- [ggplot2](https://CRAN.R-project.org/package=ggplot2)
- [Rfast](https://CRAN.R-project.org/package=Rfast)
- [stars](https://CRAN.R-project.org/package=stars)

### Installation

    needed = c("AUC", "stars", "Rfast", "dplyr", "ggplot2")
    installed = rownames(installed.packages())
    for (need in needed) {
      if (!(need %in% installed)) install.packages(need)
    }
    remotes::install_github("BigelowLab/maxnetic")

### Functionality

#### Presence only datasets

- `pAUC()` for computing AUC for presence points only (aka forecasted
  AUC or fAUC)
- `plot`, a method to plot `pAUC` objects

#### Presence-Absence datasets

- `TPR()` true positive rate (“sensitivity”)
- `FPR()` false positive rate (“specificity”)
- `ROC()` receiver operator values
- `AUC()` compute are under curve of ROC
- `plot_ROC()` plot an `ROC` class object (base graphics or gpplot2)

#### General purpose utility

- `write_maxnet()` and `read_maxnet()` for IO to R’s serialized file
  format
- `variable_importance()` modeled after Peter D Wilson’s [fitMaxnet R
  package](https://github.com/peterbat1/fitMaxnet) `varImportance()`
  function.

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

model <- maxnet(obs$presence, dplyr::select(obs, -presence))
pred <- predict(model, newdata = bradypus, na.rm = TRUE, type = "cloglog")

x <- dplyr::tibble(label = obs$presence,
                   pred = pred[,1])
dplyr::glimpse(x)
```

    ## Rows: 1,116
    ## Columns: 2
    ## $ label <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    ## $ pred  <dbl> 0.1112753, 0.1128391, 0.7038097, 0.1928364, 0.2621609, 0.4292576…

#### Collect the responses.

``` r
r <- plot(model, type = "cloglog", plot = FALSE)
```

#### Plot the response curves

``` r
plot(model, type = 'cloglog', mar = c(2,2,2,1))
```

![](README_files/figure-gfm/plot_response-1.png)<!-- -->

#### Now compute ROC and show.

``` r
roc = ROC(x)
plot(roc, title = "Bradypus model")
```

![](README_files/figure-gfm/roc-1.png)<!-- -->

#### Variable importance via permutation

One way to ascertain “variable importance” is to repeatedly use the
model and the input environmental data in a permutation test. A baseline
prediction is made using th For each variable, the variable data is
randomly shuffled and a temporary prediction is made. The Pearson’s
correlation coefficient is then computed for the baseline and temporary
models. A high correlation tells us that that variable doesn’t have much
influence on the model output, while conversely a low correlation tells
us that the variable has significant importance when computing the
model. The actual metric is transformed to a more familiar “higher is
more important” metric.

``` r
variable_importance(model, dplyr::select(obs, -presence), type = "cloglog",
                    arrange = "decreasing")
```

    ## # A tibble: 14 × 9
    ##    var         importance  mean         sd   min   q25   med   q75   max
    ##    <chr>            <dbl> <dbl>      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ##  1 tmn6190_ann      24.6  0.317 0.0449     0.278 0.296 0.306 0.310 0.394
    ##  2 tmx6190_ann      14.3  0.604 0.0178     0.585 0.598 0.600 0.602 0.633
    ##  3 dtr6190_ann       9.17 0.746 0.0125     0.734 0.739 0.741 0.749 0.766
    ##  4 h_dem             8.91 0.753 0.0119     0.741 0.749 0.750 0.752 0.773
    ##  5 ecoreg            8.16 0.774 0.0148     0.757 0.761 0.775 0.783 0.792
    ##  6 pre6190_l7        7.8  0.784 0.0136     0.773 0.773 0.777 0.791 0.804
    ##  7 pre6190_l10       7.72 0.786 0.00979    0.770 0.784 0.791 0.792 0.793
    ##  8 pre6190_l1        5    0.861 0.00387    0.856 0.860 0.862 0.863 0.866
    ##  9 frs6190_ann       4.66 0.871 0.0125     0.850 0.868 0.875 0.879 0.882
    ## 10 vap6190_ann       4.29 0.881 0.00545    0.874 0.879 0.879 0.884 0.889
    ## 11 cld6190_ann       2.56 0.929 0.00426    0.922 0.929 0.929 0.931 0.933
    ## 12 pre6190_l4        2.06 0.943 0.00346    0.938 0.941 0.943 0.946 0.947
    ## 13 tmp6190_ann       0.71 0.980 0.00276    0.977 0.978 0.980 0.982 0.984
    ## 14 pre6190_ann       0    1.00  0.00000107 1.00  1.00  1.00  1.00  1.00

#### pAUC (presence AUC)

You can also compute a “presence AUC” which involves only the presence
points. Unlike a ROC object, a pAUC object has it’s own plot method.

``` r
p = dplyr::filter(x, label == 1)
pauc = pAUC(x$pred, p$pred)
plot(pauc)
```

![](README_files/figure-gfm/pauc-1.png)<!-- -->

You might be wondering why have pAUC if AUC already exists. AUC is used
where you have both presence and absence data. For presence only data we
need to use a modified computation.
