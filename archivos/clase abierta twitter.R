install.packages("rtweet")
library(rtweet)
library(lubridate)
library(dplyr)

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



