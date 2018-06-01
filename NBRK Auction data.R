library(rvest)
StartDate <- "2015-01-01"
EndDate <- "2018-04-09"
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
    
      #print(paste(as.Date(di, format="%Y-%m-%d", origin = "1960-10-01"),length(p)))
    
      dt = p[[11]]
      if(nrow(dt) == 14) {
      tdt = t(dt)
      tdt = tdt[-1, ]
      
      ML[[date]] = tdt
    }
  }

all = do.call(rbind, ML)
all