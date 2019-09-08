
library(rvest)

pointsofsignificance <- read_html("https://www.nature.com/collections/qghhqm/pointsofsignificance")

### As the tutorial for using rvest states selectorgadget is used to determine what selector needs to be pulled. 

## this works but links are still in html and cannot readily access yet
paper_urls <- pointsofsignificance %>%
  html_node(".wysiwyg")#%>%
  html_node("a") #%>%
  html_attr("href")

paper_urls


### this is better. using selectorgadget allowed me to identify the links as 'p:nth-child(3) strong' as an example so using html_children was my next option
paper_urls <- pointsofsignificance %>%
  html_node(".wysiwyg") %>%
  html_children() %>%
  html_node("a") %>%
  html_attr("href")

paper_urls


# html node need to be suplied to identify where to scrape just running html_childern did not work
paper_urls <- pointsofsignificance %>%
  html_node(".wysiwyg") %>%
  html_children() %>%
  html_node("a") %>%
  html_attr("href") %>%
  na.omit() # could also use tidyr::drop_na() could work if this was not a character vector

# filter(complete.cases(.)) would also work

paper_urls

# testing with the first link generating the download link for the paper

library(stringr)

tmp1 <- read_html(paper_urls[1])

# this extracts the actual pdf url
x<- tmp1 %>%
  html_node("#pdf-download-button") %>%
  html_attr("href") 

paper_urls[1]

# this is the base link so that below str_c() can be used to combine the base link and the link to article
link <- str_sub(paper_urls[1], 1, 21)
str_c(link, x)

download_links <- c()
for (i in seq_along(paper_urls)) {
  tmp <- read_html(paper_urls[i])
  x1 <- tmp %>%
    html_node("#pdf-download-button") %>%
    html_attr("href")
  download_links <- c(download_links, str_c(link, x1))
}


# this worked the last 4 links gave NA values because the selector is different, in all other links it is "#pdf-download-button" but in the last 4 it is ".c-pdf-download__link"

download_links <- download_links %>%
  na.omit()

# input here the directory where the pdfs are to be stored
folder <- ("")

# seting str_sub to collect the last 15 characters will grab the pdf name for the nature articles this would need to be changed for other pdfs
nnames <- str_sub(download_links, -15,-1)
destination_fold <- str_c(folder, nnames)

for (i in seq_along(download_links)) {
  download.file(download_links[i], destination_fold[i], mode="wb")
}





