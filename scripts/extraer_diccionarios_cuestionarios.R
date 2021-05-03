

# objetivo: descargar todas las los cuestionarios y diccionarios de la encuesta

# obtener los links
# descargar los links 
# guardar los archivos en formato SAV

# cargar los paquetes necesarios
pacman::p_load(tidyverse, #  para data management 
               here, #  para manejar carpetas y archivos
               lubridate, #  para manejar fechas 
               srvyr, #  para trabajar con encuestas,
               haven, #  para trabajar con dataos en formato dta o sav,
               rvest, #  para realizar web scrapping
               stringr, # para trabajar con strings 
               xml2, # para trabajar con la html web,
               readxl, # para trabajar con archivos excel,
               urltools # for working with urls 
)


# obtener la pagina
pagina <- read_html("https://www.ine.gov.py/microdatos/microdatos.php")

# obtener todos los archivos de la pagina
files <- pagina %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset("\\.pdf")   # find those that end in xlsx


# solo los archivos que necesito
files <- files %>%
  head(16)

# crear nombres
cuest <- c("cuestionario")
trim <- c("primer", "segundo", "tercer", "cuarto")
tipo <- c("trimestre")
year <- c("2020", "2019", "2018", "2017")

# expand
nombres <- expand.grid(cuest, trim, tipo, year)

# construir el nombre
nombres$nombre <- with(nombres, paste(Var1, Var2, Var3, Var4, sep = "_")) 

# solamente el nombre
nombre <- nombres$nombre

# crear vector de destinos para los archivos
destino <- here("docs", paste0(nombre,".pdf"))


# descargar todos los cuestionarios
for(i in seq_along(files)){
  download.file(url = files[i], destfile = destino[i], mode = "wb")
}


################################################################################

# obtener todos los diccionarios en la pagina, archivos xls

# obtener todos los archivos de la pagina
diccionarios <- pagina %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset("\\.xls")   # find those that end in xls


# solo los archivos que necesito
diccionarios <- diccionarios[grepl("_EPHC", diccionarios)] %>%
  url_escape(reserved = ":/")


# crear nombres
dicc <- c("diccionario")

# expand
nombres.dicc <- expand.grid(dicc, trim, tipo, year)

# construir el nombre
nombres.dicc$nombre <- with(nombres.dicc, paste(Var1, Var2, Var3, Var4, sep = "_")) 

# solamente el nombre
nombre.dicc <- nombres.dicc$nombre

# crear vector de destinos para los archivos
destino.dicc <- here("raw_data", paste0(nombre.dicc,".xls"))

# descargar todos los diccionarios
for(i in seq_along(diccionarios)){
  download.file(url = diccionarios[i], destfile = destino.dicc[i], mode = "wb")
}

