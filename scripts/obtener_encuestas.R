

# objetivo: descargar todas las encuestas continuas en formato SAV de la pagina 
# del instituto nacional de estadistica en Paraguay

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
               xml2 # para trabajar con la html web
)


# obtener la pagina
pagina <- read_html("https://www.ine.gov.py/microdatos/microdatos.php")

# obtener todos los archivos de la pagina
files <- pagina %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset("\\.SAV")   # find those that end in xlsx


# solo los archivos que necesito
files <- files %>%
  tail(-4)

# subtituir url strings
files <- files %>%
  str_replace(" ","%20") 

# creo que esta solucion es medio hacky
# los url tienen espacios y los links aparentemente reemplazan este espacio por %20
# deberia chequear y aprender el por que.

# descargar los archivos
data <- files %>% purrr::map(read_sav)

# crear nombres
nombres <- basename(files)

# eliminar sav al final
nombres <- nombres %>% 
  str_remove("(\\.SAV)+")

# nombrar a los archivos
data <- data %>% setNames(basename(nombres))

# guardar los achivos
purrr::iwalk(data, function(data, nombres) write_sav(data, here("raw_data", paste0(nombres, ".SAV"))))