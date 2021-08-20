library(devtools)
library(tidyverse)
library(occupationcross)
#create_package()
#use_git()
devtools::load_all()
suma(1:10)
#check() # Es el chequeo general del paquete
use_mit_license("Guido Weksler")
  devtools::document()
  devtools::install()
use_testthat()

library(testthat)
devtools::test()
use_package("dplyr")
use_package("tidyr")
use_package("purrr")
use_package("stringr")
use_package("stringr")
use_r("Census_to_SOC")
use_r("soc2010_to_isco_08")
use_r("cno2017_to_isco_08")
use_r("cno2001_to_isco_08")

use_r("sinco2011_to_isco_08")
use_r("isco_08_to_isco_88_4digit")
use_r("reclassify_to_isco08")

use_test("isco08_to_isco88")
use_test("census2010_to_isco08")
use_test("isco_08_to_isco_88_4digit")
usethis::use_github()
browse_github_token()
use_readme_rmd()
devtools::build()
##On Windows the collection of tools needed for building packages from source is called Rtools. Rtools is NOT an R package. It is NOT installed with install.packages(). Instead, download it from https://cran.r-project.org/bin/windows/Rtools/ and run the installer.
#usethis::use_build_ignore("notes")#.Rbuildignore is a way to resolve some of the tension between the practices that support your development process and CRAN’s requirements for submission and distribution

###Elegir nombres
available::available("occupationcross")
###Evitar caracteres raros
stringi::stri_escape_unicode()

####Credenciales en github####
usethis::create_github_token()
gitcreds::gitcreds_set()
#Vignettes
usethis::use_vignette("occupationcross")
