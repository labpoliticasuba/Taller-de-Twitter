install.packages("rtweet")
install.packages("tidyverse")
install.packages("quanteda")

library(rtweet)
library(tidyverse)
library(quanteda)

## Comprobamos que funcione rtweet pidiéndole a la API las tendencias de AR
trendsAR <- get_trends("argentina")

write_as_csv(trendsAR, "trendsAR.csv")

View(trendsAR)

## Capturamos los últimos 3200 tuits de una cuenta

usuario <- get_timeline("msalnacion", n = 3200)

write_as_csv(usuario, "usuario.csv")

ts_plot(usuario, by = "days")

## Capturamos los últimos 3200 tuits de tres cuentas en un solo dataframe

timelines <- get_timelines(c("alferdez", "horaciorlarreta", "kicillofok"), n = 3200)

write_as_csv(timelines, "timelines.csv")

## Graficamos una línea de tiempo con los tuits de las tres cuentas

timelines %>%
  dplyr::filter(created_at > "2020-01-01") %>%
  dplyr::group_by(screen_name) %>%
  ts_plot("days", trim = 1L) +
  ggplot2::geom_point() +
  ggplot2::labs(
    title = "Tuits publicados por cada cuenta"
  )


######## ANÁLISIS DEL TEXTO ######## 

#Vemos como quedó el dataset que descargamos recientemente
View(timelines)
#Vamos a transformar ese dataset en un corpus que podamos trabajar
corpus_timelines <- corpus(timelines)

head(corpus_timelines)

#Ahora vamos a transformalo en una matriz de palabras y tweets
dfm_timelines <- dfm(corpus_timelines, remove_punct = TRUE, remove = stopwords("spa"), 
                     groups = "screen_name")
head(dfm_timelines)

#Nube de palabras
textplot_wordcloud(dfm_timelines, rotation = 0.25,
                   color = rev(RColorBrewer::brewer.pal(10, "RdBu")))

#Nube de palabras comparación
textplot_wordcloud(dfm_timelines, comparison = TRUE, max_words = 300,
                   color = c("blue", "red", "green"))

#Top Users
user_timelines <- dfm_select(dfm_timelines, pattern = "@*")
top_user_timelines <- names(topfeatures(user_timelines, 50))
View(top_user_timelines)

#Hacemos una matriz de palabras (palabras que aparecen juntas en el mismo texto/tweet)
user_timelines_fcm <- fcm(user_timelines)
head(user_timelines_fcm) 

#Visualizamos las relaciones
user_fcm <- fcm_select(user_timelines_fcm, pattern = top_user_timelines)
textplot_network(user_fcm, min_freq = 0.1, edge_color = "orange", edge_alpha = 0.8, edge_size = 5)

#Top hashtags
user_fcm <- fcm_select(user_fcm, pattern = topuser)
textplot_network(user_fcm, min_freq = 0.1, edge_color = "orange", edge_alpha = 0.8, edge_size = 5)
