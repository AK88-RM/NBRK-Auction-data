library(rvest)
StartDate <- "2003-03-18"
EndDate <- "2017-05-26"
dates <- seq(as.Date(StartDate, format="%Y-%m-%d"),
             as.Date(EndDate, format="%Y-%m-%d"), by='days')

ML = list()

for (date in seq_along(dates)) {
  di = dates[date]
  url = paste0("http://nationalbank.kz/?docid=105&cmomdate=",
               as.Date(di, format="%Y-%m-%d"),
               "&switch=english")
  p <- url %>%
    read_html() %>%
    html_nodes(xpath='//table[1]') %>%
    html_table(fill = T)
  
    gh = p[[11]]
    txt = gh[, 1]
    ans = lapply(strsplit(txt, '\r\n', fixed = T),
               function(x) strsplit(x, split="\t", fixed=TRUE))
  
    m = do.call(rbind, lapply(ans[[1]], function(x) {
      if(length(x)==2) {
        return(x)
      }
    }))
  
    if(is.matrix(m)) {
      txt = t(m)
      txt = txt[-1, ]
      
      ML[[date]] = txt
    }
}

all = do.call(rbind, ML)
all
