# Exploratory Data Analysis - Data visualization{#vis}

### R packages required for this chapter


```r
library(dslabs)
library(ggplot2)
library(dplyr)
library(magrittr)
library(gganimate)
library(scales)
library(transformr)
library(dslabs) # contains gapminder data set, also found in gapminder package
library(HistData)
library(maptools)
library(rgdal)
library(leaflet)
library(ggmap)
```

## Introduction
There is a modern tendency for researchers to immediately present their results in the most complex and sophisticated manner. This is often seen as proof of their respectability and importance. However, a step wise approach that begins by presenting data in its rawest form of Tables and Graphs is both more logical and beneficial to understanding. In fact, there is are several historical examples of excellent visualizations involving epidemiology.   

Although remembered as the mother of modern nursing, Florence Nightingale was an accomplished statistician too being the first female fellow of the Statistical Society of London (now Royal Statistical Society)[@econ]. She was particularly innovative in presenting data visually as by this example published in her 1858 monograph, “Notes on matters affecting the health, efficiency and hospital administration of the British army”. The chart displays the causes of the deaths of soldiers during the Crimean war, divided into three categories: “Preventible or Mitigable Zymotic Diseases” (infectious diseases, including cholera and dysentery, coloured in blue), “wounds” (red) and “all other causes” (black). As with today's pie charts, the area of each wedge is proportional to the figure it stands for, but it is the radius of each slice (the distance from the common centre to the outer edge) rather than the angle that is altered to achieve this. Her principal message—that even during periods of heavy fighting, such as November 1854, far more soldiers died from infection than from wounds—can be seen at a glance. It seems a fair bet that her talents as a data scientist contributed to her successful introduction of medical advances in military hospitals.


\begin{figure}
\includegraphics[width=1\linewidth]{img/rose} \caption{Classic epidemiology visualizations - Nightingale's Rose}(\#fig:unnamed-chunk-2)
\end{figure}
[Charles Minard’s](https://en.wikipedia.org/wiki/Charles_Joseph_Minard) 1869 publication of a flow map of Napoleon’s Russian 1812 campaign has been called best statistical graphic ever drawn by [Edward Tufte](https://en.wikipedia.org/wiki/Edward_Tufte) who is a preeminent 21st century statistician and pioneer in the field of data visualization. The figure shows 6 six types of data in two dimensions: the number of Napoleon's troops; the distance traveled; temperature; latitude and longitude; direction of travel; and location relative to specific dates. The chart tells with painful clarity the atrocious losses associated with this campaign as an initial force of 422,000 saw only only 10,000 return. On the retrurn trip 50% of the forces were lost while crossing the Bérézina river under heavy attack. “C'est la Bérézina” is a French expression used to describe a total disaster.


\begin{figure}
\includegraphics[width=1\linewidth]{img/minard} \caption{Classic epidemiology visualizations - Napoleon’s Russian 1812 Campaign }(\#fig:unnamed-chunk-3)
\end{figure}
## Why is data visualization important? 

Specifically, data visualizations can help      
* understand your data    
* understand basic concepts   
* emphasize a message    
* build trust with your audience    
* clarify your story for others    
* inform / influence their decisions    
* **poor data visualizations can do the opposite!**
    
    
As an example of an uninspired visualization, consider the frequently observed bar plot which is a regular item in scientific publications. Contrast the lack of information provided by the commonly used bar plot format (Figure \@ref(fig:bad)) (avoiding any association with inferiority simply because it was created with Excel) with the additional data insights provided by simple histograms and box plots (Figure \@ref(fig:better)).     


\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{img/viz/bad} 

}

\caption{Poor presentation - Bar plot}(\#fig:bad)
\end{figure}


\begin{figure}
\includegraphics[width=1\linewidth]{img/viz/better} \caption{Improved presentation - histograms and box plots}(\#fig:better)
\end{figure}
   
As another example of an uninspired plot, consider the pie chart which has been rightly criticized as being difficult to understand as we are effectively being asked to compared angles and the area subtended by them rather than simply making linear comparisons as in barplots. Notwithstanding the presence of Steve Jobs with the pie chart, which visualization is easiest to understand?


---
output: html_document
---

:::: {style="display: flex;"}
::: {}

\begin{figure}

\includegraphics[width=2\linewidth]{img/viz/jobs} \hfill{}

\caption{Pie chart (with Steve Jobs)}(\#fig:unnamed-chunk-4)
\end{figure}
:::

::: {}

\begin{figure}

\hfill{}\includegraphics[width=0.5\linewidth]{03-visualizations_files/figure-latex/unnamed-chunk-5-1} 

\caption{Bar plot (without Steve Jobs)}(\#fig:unnamed-chunk-5)
\end{figure}
:::
::::

    
In contrast, if you have any doubts about the power of excellent visualizations, you **must** watch this [video](https://www.youtube.com/watch?v=Z8t4k0Q8e8Y) by [Hans Rosling](https://en.wikipedia.org/wiki/Hans_Rosling). Leaving aside his fabulous and infectious enthusiasm, (who wouldn't want to be a global health data scientist after watching this), the knowledge transfer from his data visualizations is simply amazing.   

## Creating an effective and professional appearing graph 

Here is a static image from Rosling's video. It certainly is of professional quality. Can we reproduce it?          

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{img/un_graph} 

}

\caption{Gapminder data}(\#fig:unnamed-chunk-6)
\end{figure}

If the first plot we produce is of this quality, it will hopefully inspire us to realize what we can accomplish with data visualizations using `R`. While this may rightly not completely dispel the notion that a definitive learning curve is associated with`R`, it is certainly suggests it can be manageable. Here is the code that reproduces the graph.          

























