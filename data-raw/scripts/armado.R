library(devtools)
library(tidyverse)
library(occupationcross)
#create_package()
#use_git()
devtools::load_all()
suma(1:10)
#check() # Es el chequeo general del paquete
use_mit_license("Guido Weksler")
document()
install()
use_testthat()
use_test("ISCO88_to_ISCO_08")
use_test("census2010_to_isco08")
library(testthat)
test()
use_package("dplyr")
use_package("tidyr")
use_package("purrr")
use_package("stringr")
use_r("Census_to_SOC")
use_r("soc2010_to_isco_08")
usethis::use_github()
browse_github_token()
use_readme_rmd()
##On Windows the collection of tools needed for building packages from source is called Rtools. Rtools is NOT an R package. It is NOT installed with install.packages(). Instead, download it from https://cran.r-project.org/bin/windows/Rtools/ and run the installer.
#usethis::use_build_ignore("notes")#.Rbuildignore is a way to resolve some of the tension between the practices that support your development process and CRAN’s requirements for submission and distribution

###Elegir nombres
available::available("occupationcross")
###Evitar caracteres raros
stringi::stri_escape_unicode()

#Vignettes
usethis::use_vignette("occupationcross")
