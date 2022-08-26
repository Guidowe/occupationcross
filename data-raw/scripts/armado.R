library(devtools) # Libreria para desarrollar paquetes

#create_package() # Funcion crea paquete
#use_git() # Para linkear con git
devtools::load_all() # Carga el paquete (con los cambios locales que le hayamos hecho)

#check() # Es el chequeo general del paquete. Tarda tiempo. Avisa errores

use_mit_license("Guido Weksler") # Ponerle licencia. No se bien para que

devtools::document() #Genera los archivos de documentacion de las funciones y dataframes que se hayan agregado
devtools::install() # Prueba instalar en la computadora el paquete a partir de lo que encuentra en las carpetas, no desde la web
use_testthat() # Crea carpeta para armar tests para comprobar que las funciones no se rompan

library(testthat)
devtools::test() #Aplica todos los tests (para ver si alguna modificacion que hicimos a una funcion la cago)
use_package("dplyr") # Agrego en la documentacion, las dependencias del paquete (que otros paquetes usa mi paquete, y por ende deben ser instalados por usuaries)
use_package("tidyr")
use_package("purrr")
use_package("stringr")
use_package("stringr")
use_r("Census_to_SOC") # Creo una script para una funcion en el paquete que se llamara asi.
use_r("soc2010_to_isco_08")
use_r("cno2017_to_isco_08")
use_r("cno2001_to_isco_08")

use_r("sinco2011_to_isco_08")
use_r("isco_08_to_isco_88_4digit")
use_r("reclassify_to_isco08")

use_test("isco08_to_isco88") # Creo un test, asociado a la funcion con mismo nombre
use_test("census2010_to_isco08")
use_test("isco_08_to_isco_88_4digit")

usethis::use_github() # Cosas de autenticacion de github
browse_github_token()

use_readme_rmd() # Crea el readme del paquete
devtools::build() # Construye la estructura del paquete

##On Windows the collection of tools needed for building packages from source is called Rtools. Rtools is NOT an R package. It is NOT installed with install.packages(). Instead, download it from https://cran.r-project.org/bin/windows/Rtools/ and run the installer.
#usethis::use_build_ignore("notes")#.Rbuildignore is a way to resolve some of the tension between the practices that support your development process and CRAN’s requirements for submission and distribution

###Elegir nombres
available::available("occupationcross") # chequea si el nombre de paquete esta en CRAN
###Evitar caracteres raros
stringi::stri_escape_unicode() # Chequea caracteres raros en el paquete que puedan armar quilombo

####Credenciales de github####
usethis::create_github_token()
gitcreds::gitcreds_set()

#### citas ####
usethis::use_citation()


####Vignettes####
usethis::use_vignette("occupationcross") #Crea viñeta/docuemtnacion. En este caso es la viñeta ppal del paquete
usethis::use_vignette("Major_Groups_Genero") # Crea otra viñeta, que puede constitur un articulo en la pagina web

###Página del paquete####
pkgdown::build_site() # Arma las carpetas necesarias para armar un sitio web del paquete (o lo actualiza por completo si ya existe). Le da a la pagina formato tipico de un indice (Casita), y las secciones siguientes siguientes.
pkgdown::build_articles_index() #Arma (o actualiza) indice de articulos
pkgdown::build_articles() # Arma (o actualiza) articulos


