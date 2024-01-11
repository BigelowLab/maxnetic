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
correlation coeeficient is then computed for the baseline and temporary
models. A high correlation tells us that that variable doesn’t have much
influence on the model output, while conversely a low correlation tells
us that the variable has significant importance when computing the
model. The actual metric is transformed to a more familiar “higher is
more important” metric.

``` r
variable_importance(model, dplyr::select(obs, -presence), type = "cloglog",
                    arrange = "decreasing")
```

    ## tmn6190_ann tmx6190_ann       h_dem dtr6190_ann      ecoreg pre6190_l10 
    ##       25.33       14.07        9.11        9.11        7.60        7.58 
    ##  pre6190_l7 frs6190_ann  pre6190_l1 vap6190_ann cld6190_ann  pre6190_l4 
    ##        7.56        4.82        4.71        4.46        2.64        2.25 
    ## tmp6190_ann pre6190_ann 
    ##        0.75        0.00

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
