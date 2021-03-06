--- 
title: "(Mostly Clinical) Epidemiology with R"
author: "James Brophy"
date: "2021-03-02"
site: bookdown::bookdown_site
output:
  bookdown::gitbook:
    highlight: tango
    includes:
      in_header: hide_code.html
  bookdown::pdf_book:
    keep_tex: yes
  bookdown::html_book:
    theme: cerulean
    css: style.css
    includes:
      in_header: header.html
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: brophyj/book_v1
description: "This is an intermediate epidemiology book that focuses on clinical epidmeiology and its quantification using R. It stems from my belief that the learning of epidmeiologic principles is consolidated through hands on coding examples."
---







# About the Author {-}


[James (Jay) Brophy](https://www.brophyj.com/) is a full professor with a joint appointment in the Departments of Medicine and Epidemiology and Biostatistics at [McGill University](https://www.mcgill.ca/) where he works as a clinical cardiologist at the [McGill University Health Center](https://muhc.ca/) and does research in cardiovascular epidemiology. His research interests are eclectic and include clinical and outcomes research, pharmacoepidemiology, health technology assessment, and economic analyses.    

# Simple acknowledgment and request {-}

In writing this book, I was amazed at how much of this material I either never learned at all or didn't assimilate completely on my first, and occasionally second and third, efforts. Consequently, I'm sure there are imprecisions, clarifications and outright errors that will need addressing. For reasons that I outline in Section \@ref(outline), I am releasing the first six chapters as "volume 1". Hopefully, other chapters will be forthcoming in a timely manner.     

I would welcome all comments that may bring undoubted much needed clarifications, corrections, and improvements, including optimization of my `R` code. These may be addressed to me either by email or via Github. I should mention that any messages that begin "You ass@@@@ ...." will probably be ignored.

