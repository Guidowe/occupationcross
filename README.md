
<!-- README.md is generated from README.Rmd. Please edit that file -->

# occupationcross

<!-- badges: start -->
<!-- badges: end -->

The goal of occupationcross is to facilitate the application of
crosswalks between occupational classifiers from different parts of the
world.

## Installation

Install the development version of occupationcross from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Guidowe/occupationcross")
```

## Example

This is a basic example of how this package works :

Let´s load first *occupationcross*, and also *tidyverse*

``` r
library(occupationcross)
library(tidyverse)
```

The objects `available_classifications` and `available_crosswalks` show
respectively which are the classifications collected and which
crosswalks can be obtained applying the functions contained in this
package.

``` r
occupationcross::available_classifications
#>   classification                                 classification_fullname
#> 1        isco 08 International Standard Classification of Occupations 08
#> 2        isco 88 International Standard Classification of Occupations 88
#> 3     sinco 2011   Sistema Nacional de Clasificación de Ocupaciones 2011
#> 4       cno 2001               Clasificador Nacional de Ocupaciones 2001
#> 5    census 2010                 2010 Census Occupational Classification
#> 6       soc 2010               2010 Standard Occupational Classification
#>         country
#> 1 International
#> 2 International
#> 3        Mexico
#> 4     Argentina
#> 5 United States
#> 6 United States
```

``` r
occupationcross::available_crosswalks
#> # A tibble: 5 x 3
#>   from        to       detail                                         
#>   <chr>       <chr>    <chr>                                          
#> 1 cno 2001    isco 08  crosswalk only available to isco digits 1 and 2
#> 2 sinco 2011  isco 08  complete crosswalk                             
#> 3 isco 08     isco 88  complete crosswalk                             
#> 4 census 2010 soc 2010 complete crosswalk                             
#> 5 census 2010 isco 08  complete crosswalk
```

Let´s use a sample database from a Mexico´s household survey (Encuesta
Nacional de Ocupación y Empleo) already embedded in this package. This
database contains a variable named *“p3”* corresponding to SINCO 2011
(Sistema Nacional de Clasificación de Ocupaciones - 2011) occupational
codes

``` r
toy_base_mexico
#> # A tibble: 200 x 8
#>      sex t_loc clase2  tue1 pos_ocu   per   fac    p3
#>    <dbl> <dbl>  <dbl> <dbl>   <dbl> <dbl> <dbl> <dbl>
#>  1     1     1      1     4       2   119   435  7121
#>  2     2     1      1     1       1   119   542  5116
#>  3     2     1      1     3       1   119   173  9611
#>  4     2     3      0     0       0   119   411    NA
#>  5     1     1      3     0       0   119   224    NA
#>  6     2     1      0     0       0   119   104    NA
#>  7     2     1      0     0       0   119   314    NA
#>  8     2     1      4     0       0   119   104    NA
#>  9     1     4      1     1       3   119   450  6111
#> 10     2     4      1     3       3   119   293  4111
#> # ... with 190 more rows
```

Applying the `sinco2011_to_isco08()` function we can obtain a
reclassification of each case of our database into International
Standard Classification of Occupations - 08 (ISCO-08) codes. The
`code_titles` parameter allows you to get the occupation names both from
the origin classification and isco 08 classification

``` r
crossed_base <- sinco2011_to_isco08(
  base = toy_base_mexico,
  sinco = p3,
  code_titles = TRUE)

crossed_base %>% 
  select(1,5:ncol(.))
#> # A tibble: 327 x 9
#>      sex pos_ocu   per   fac    p3 cod.origin label.origin               ISCO.08
#>    <dbl>   <dbl> <dbl> <dbl> <dbl> <chr>      <chr>                      <chr>  
#>  1     1       2   119   435  7121 7121       "Albañiles, mamposteros y~ 7112   
#>  2     2       1   119   542  5116 5116       "Meseros "                 5131   
#>  3     2       1   119   542  5116 5116       "Meseros "                 5131   
#>  4     2       1   119   173  9611 9611       "Trabajadores domésticos " 9111   
#>  5     2       0   119   411    NA 0000        <NA>                      0000   
#>  6     2       0   119   411    NA 0000        <NA>                      0000   
#>  7     1       0   119   224    NA 0000        <NA>                      0000   
#>  8     1       0   119   224    NA 0000        <NA>                      0000   
#>  9     2       0   119   104    NA 0000        <NA>                      0000   
#> 10     2       0   119   104    NA 0000        <NA>                      0000   
#> # ... with 317 more rows, and 1 more variable: label.destination <chr>
```
