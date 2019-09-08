
library(rvest)

pointsofsignificance <- read_html("https://www.nature.com/collections/qghhqm/pointsofsignificance")

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








