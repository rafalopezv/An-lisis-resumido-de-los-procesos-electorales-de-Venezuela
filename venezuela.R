library(tidyverse)
library(highcharter)
library(magrittr)

Sys.setlocale(locale = "es_ES.UTF-8")

a <- rio::import("venezuela.xlsx")
a %<>% mutate(
  `Chavismo%` = Chavismo/`Votos Válidos`*100,
  `oposición%` = 100 - `Chavismo%`
) %>% 
  rename(Emitidos = "Votos Emitidos")

# voto oficialismo oposición
g1 <- highchart() %>% 
  hc_chart(type = "area") %>% 
  hc_title(text = "Evolución del voto del Chavismo/Madurismo") %>%
  hc_subtitle(text = "20 años, 7 procesos electorales") %>% 
  hc_xAxis(categories = as.character(a$Elección) ,
           tickmarkPlacement = "on",
           title = list(enabled = FALSE)) %>% 
  hc_tooltip(pointFormat = "<span style=\"color:{series.color}\">{series.name}</span>:
             <b>{point.percentage:.1f}%</b> ({point.y:,.0f} votos)<br/>",
             shared = TRUE) %>% 
  hc_plotOptions(area = list(
    stacking = "percent",
    lineColor = "#ffffff",
    lineWidth = 1,
    marker = list(
      lineWidth = 1,
      lineColor = "#ffffff"
    ))
  ) %>% 
  hc_add_series(name = "Oposición", data = a$Oposición)  %>% 
  hc_add_series(name = "Chavismo/Madurismo", data = a$Chavismo)  %>%
  hc_add_theme(hc_theme_smpl())

# voto puro
g2 <- highchart() %>% 
  hc_chart(type = "line") %>% 
  hc_title(text = "Evolución del voto del Chavismo/Madurismo") %>%
  hc_subtitle(text = "20 años, 7 procesos electorales") %>% 
  hc_xAxis(categories = as.character(a$Elección)) %>% 
  hc_add_series(name = "Oposición", data = a$Oposición)  %>% 
  hc_add_series(name = "Chavismo/Madurismo", data = a$Chavismo)  %>%
  hc_tooltip(crosschairs = T, sort = T, shared = T, table = T) %>% 
  hc_add_theme(hc_theme_smpl())

# van  o no a votar
  highchart() %>% 
  hc_chart(type = "area") %>% 
  hc_title(text = "Nivel de absentismo") %>%
  hc_subtitle(text = "20 años, 7 procesos electorales") %>% 
  hc_xAxis(categories = as.character(a$Elección) ,
           tickmarkPlacement = "on",
           title = list(enabled = FALSE)) %>% 
  hc_tooltip(pointFormat = "<span style=\"color:{series.color}\">{series.name}</span>:
             <b>{point.percentage:.1f}%</b> ({point.y:,.0f} venezolan@s)<br/>",
             shared = TRUE) %>% 
  hc_plotOptions(area = list(
    stacking = "percent",
    lineColor = "#ffffff",
    lineWidth = 1,
    marker = list(
      lineWidth = 0.3,
      lineColor = "#ffffff"
    ))
  ) %>% 
    hc_add_series(name = "Votaron", data = a$Emitidos, color = "#000033") %>% 
  hc_add_series(name = "NO votaron", data = a$Inscritos - a$Emitidos,
                color = "#006600")  %>% 
    hc_add_theme(hc_theme_smpl())
    
  