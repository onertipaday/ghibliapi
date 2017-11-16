# ghibliapi

> R wrapper for the Ghibli API

This package provides access to the [Ghibli](https://ghibliapi.herokuapp.com) API from R.

## Installation
Installation from github requires the devtools package to be installed.

```R
devtools::install_github("onertipaday/ghibliapi")
```
## Usage

```R
# A use case for finding information on all the cats of Studio Ghibli.
require("tidyverse")
get_ghibli("species") %>%
filter(name=="Cat") %>%
select(id) %>%
get_ghibli("species",id=.) -> tmp
str_detect(tmp,"people") %>% subset(tmp,.) %>%
str_replace("https://ghibliapi.herokuapp.com/people/","") %>%
map(~ get_ghibli("people",.)) %>%
{
 tibble(
 name = map_chr(., "name"),
 gender = map_chr(., "gender"),
 eye_color = map_chr(., "eye_color"),
 hair_color = map_chr(., "hair_color")
 )
}
```
