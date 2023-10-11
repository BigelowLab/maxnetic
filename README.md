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

Collect the responses.

``` r
r <- plot(model, type = "cloglog", plot = FALSE)
```

Plot the response curves

``` r
plot(model, type = 'cloglog', mar = c(2,2,2,1))
```

![](README_files/figure-gfm/plot_response-1.png)<!-- -->

Now compute ROC and show.

``` r
roc = ROC(x)
plot(roc, title = "Bradypus model")
```

![](README_files/figure-gfm/roc-1.png)<!-- -->

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
