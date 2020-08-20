
<!-- README.md is generated from README.Rmd. Please edit that file -->
occupationcross
===============

<!-- badges: start -->
<!-- badges: end -->
The goal of occupationcross is to facilitate the application of crosswalks between occupational classifiers from different parts of the world.

Installation
------------

Install the development version of occupationcross from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Guidowe/occupationcross")
```

Example
-------

This is a basic example of how this package works :

Let´s load first *occupationcross*, and also *tidyverse*

``` r
library(occupationcross)
library(tidyverse)
```

Below is a sample from a database from USA - Current Population Survey, which contains a variable corresponding to the Census 2010 occupational code, named as *"OCC"*

``` r
toy_base_ipums_cps_2018
#> # A tibble: 2,000 x 8
#>     YEAR MONTH   SEX   AGE  EDUC LABFORCE WKSTAT   OCC
#>    <dbl> <int> <int> <int> <int>    <int>  <int> <dbl>
#>  1  2018     3     1    27    73        2     11  4050
#>  2  2018     3     1    55    92        2     13  4850
#>  3  2018     3     1    54    73        1     99     0
#>  4  2018     3     1    40    81        2     11  7330
#>  5  2018     3     1    51    92        2     12  6260
#>  6  2018     3     1    45    73        2     11  9130
#>  7  2018     3     2    46    91        1     99     0
#>  8  2018     3     1    22    73        2     11  5240
#>  9  2018     3     2    59    81        2     50  4720
#> 10  2018     3     1    71    81        1     99     0
#> # ... with 1,990 more rows
```

Applying the `census2010_to_isco08()` function we can obtain a reclassification of each case of our database into International Standard Classification of Occupations - 08 (ISCO-08) codes.

``` r
census2010_to_isco08(base = toy_base_ipums_cps_2018,
                     census = "OCC",
                     code_titles=TRUE)
#> # A tibble: 2,000 x 11
#>     YEAR MONTH   SEX   AGE  EDUC LABFORCE WKSTAT Census SOC   ISCO.08 ISCO.title
#>    <dbl> <int> <int> <int> <int>    <int>  <int> <chr>  <chr>   <dbl> <chr>     
#>  1  2018     3     1    27    73        2     11 4050   35-3~    5246 Food serv~
#>  2  2018     3     1    55    92        2     13 4850   41-4~    2433 Technical~
#>  3  2018     3     1    54    73        1     99 0      <NA>       NA <NA>      
#>  4  2018     3     1    40    81        2     11 7330   49-9~    7233 Agricultu~
#>  5  2018     3     1    51    92        2     12 6260   47-2~    9313 Building ~
#>  6  2018     3     1    45    73        2     11 9130   53-3~    8322 Car, taxi~
#>  7  2018     3     2    46    91        1     99 0      <NA>       NA <NA>      
#>  8  2018     3     1    22    73        2     11 5240   43-4~    4222 Contact c~
#>  9  2018     3     2    59    81        2     50 4720   41-2~    5230 Cashiers ~
#> 10  2018     3     1    71    81        1     99 0      <NA>       NA <NA>      
#> # ... with 1,990 more rows
```
