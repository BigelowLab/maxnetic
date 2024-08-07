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
p = gather_plots(r)
```

![](README_files/figure-gfm/plot_response-1.png)<!-- -->

``` r
p
```

![](README_files/figure-gfm/plot_response-2.png)<!-- -->

#### Now compute ROC and show.

``` r
roc = ROC(x)
plot(roc, title = "Bradypus model")
```

    ## Warning in ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1, yend = 1), : All aesthetics have length 1, but the data has 1115 rows.
    ## ℹ Please consider using `annotate()` or provide this layer with data containing
    ##   a single row.

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
    ##  1 tmn6190_ann      24.1  0.347 0.0245     0.317 0.332 0.348 0.355 0.382
    ##  2 tmx6190_ann      14.6  0.605 0.0168     0.586 0.591 0.610 0.611 0.628
    ##  3 h_dem             9.34 0.747 0.0196     0.728 0.731 0.739 0.764 0.771
    ##  4 dtr6190_ann       9.22 0.750 0.0130     0.733 0.739 0.756 0.759 0.763
    ##  5 pre6190_l10       7.65 0.793 0.0103     0.775 0.794 0.794 0.800 0.801
    ##  6 ecoreg            7.55 0.795 0.0173     0.776 0.786 0.788 0.807 0.819
    ##  7 pre6190_l7        7.5  0.797 0.00956    0.782 0.794 0.798 0.804 0.806
    ##  8 pre6190_l1        5.15 0.860 0.0116     0.841 0.859 0.862 0.869 0.870
    ##  9 frs6190_ann       5.05 0.863 0.0172     0.839 0.852 0.868 0.875 0.881
    ## 10 vap6190_ann       4.38 0.881 0.00624    0.870 0.881 0.884 0.885 0.886
    ## 11 cld6190_ann       2.55 0.931 0.00377    0.925 0.930 0.931 0.934 0.934
    ## 12 pre6190_l4        2.2  0.940 0.00444    0.935 0.936 0.941 0.943 0.945
    ## 13 tmp6190_ann       0.75 0.980 0.00343    0.976 0.977 0.980 0.981 0.985
    ## 14 pre6190_ann       0    1.00  0.00000245 1.00  1.00  1.00  1.00  1.00

#### pAUC (presence AUC)

You can also compute a “presence AUC” which involves only the presence
points. Unlike a ROC object, a pAUC object has it’s own plot method.

``` r
p = dplyr::filter(x, label == 1)
pauc = pAUC(x$pred, p$pred)
plot(pauc)
```

    ## Warning in ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1, yend = 1), : All aesthetics have length 1, but the data has 1001 rows.
    ## ℹ Please consider using `annotate()` or provide this layer with data containing
    ##   a single row.

![](README_files/figure-gfm/pauc-1.png)<!-- -->

You might be wondering why have pAUC if AUC already exists. AUC is used
where you have both presence and absence data. For presence only data we
need to use a modified computation.
