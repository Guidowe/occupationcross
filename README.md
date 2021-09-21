
<!-- README.md is generated from README.Rmd. Please edit that file -->

# occupationcross

<!-- badges: start -->
<!-- badges: end -->

## Description

**Occupationcross** is designed to facilitate the application of
crosswalks between occupational classifiers from different parts of the
world.

The main function of this package is **`reclassify_to_isco08()`**.
Basically, this function takes as an imput a database containing a
variable associated with a national occupational classifier and performs
a reclassification to [International Standard Classification of
Occupations
08](https://www.ilo.org/public/english/bureau/stat/isco/isco08/)
developed by International Labour Organization.

In addition, the package also has dataframes specifying the available
classifications and crosswalks, as well as the tables used to make the
crosswalks.

-   **`available_classifications`**
-   **`available_crosswalks`**
-   **`crosstable_sinco2011_isco08`**
-   **`crosstable_cno2001_isco08`**

## Instalation

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
#> 1         ISCO08 International Standard Classification of Occupations 08
#> 2         ISCO88 International Standard Classification of Occupations 88
#> 3      SINCO2011   Sistema Nacional de Clasificación de Ocupaciones 2011
#> 4        CNO2001               Clasificador Nacional de Ocupaciones 2001
#> 5        CNO2017               Clasificador Nacional de Ocupaciones 2017
#> 6     Census2010                 2010 Census Occupational Classification
#> 7        SOC2010               2010 Standard Occupational Classification
#>         country
#> 1 International
#> 2 International
#> 3        Mexico
#> 4     Argentina
#> 5     Argentina
#> 6 United States
#> 7 United States
```

``` r
occupationcross::available_crosswalks
#> # A tibble: 8 x 3
#>   from          to     detail                                                   
#>   <chr>         <chr>  <chr>                                                    
#> 1 SINCO2011     ISCO08 complete crosswalk                                       
#> 2 Census2010    ISCO08 complete crosswalk                                       
#> 3 CNO2001       ISCO08 crosswalk only available to isco digits 1 and 2          
#> 4 CNO2017       ISCO08 crosswalk only available to isco digits 1 and 2          
#> 5 ISCO88        ISCO08 complete crosswalk                                       
#> 6 ISCO88_3digi~ ISCO08 crosswalk designed for databases with ISCO88 containing ~
#> 7 ISCO08        ISCO88 complete crosswalk                                       
#> 8 Census2010    SOC20~ complete crosswalk
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

Applying the `reclassify_to_isco08()` function we can obtain a
reclassification of each case of our database into International
Standard Classification of Occupations - 08 (ISCO-08) codes.  
- The `classif_origin` is used to specify which classification is used
in the original database.  
- The `add_major_groups` parameter allows you to add a new variable
identifying ISCO-08 major group.  
- The `add_skill` parameter allows you to add a new variable identifying
skill level of each occupation according to ISCO-08 classification of
major groups.  
- The `code_titles` parameter allows you to get the occupation names
both from the origin classification and isco 08 classification

``` r
crossed_base <- reclassify_to_isco08(base = toy_base_mexico,
                                     variable = p3,
                                     classif_origin = "SINCO2011",
                                     add_major_groups = T,
                                     add_skill = T,
                                     code_titles = T)


crossed_base %>% 
  select(p3,ISCO.08,major_group)
#> # A tibble: 200 x 3
#>       p3 ISCO.08 major_group                                          
#>    <dbl> <chr>   <fct>                                                
#>  1  7121 7112    7. Craft and Related Trades Workers                  
#>  2  5116 5131    5. Services and Sales Workers                        
#>  3  9611 9111    9. Elementary Occupations                            
#>  4    NA 0000    <NA>                                                 
#>  5    NA 0000    <NA>                                                 
#>  6    NA 0000    <NA>                                                 
#>  7    NA 0000    <NA>                                                 
#>  8    NA 0000    <NA>                                                 
#>  9  6111 6111    6. Skilled Agricultural, Forestry and Fishery Workers
#> 10  4111 5221    5. Services and Sales Workers                        
#> # ... with 190 more rows
```
