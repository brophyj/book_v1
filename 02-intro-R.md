# Introduction to statistical software - R {#soft}

### R packages required for this chapter


```r
library(knitr)
library(tidyverse)
library(broom)
library(psych)
library(magrittr)
```

A [twitter post](https://twitter.com/MaartenvSmeden/status/995791001825431552) has nicely summarized 10 reasons "Why should I bother learning to code";  

1. Encourages reproducible statistical analyses    
2. Enables easy incorporation of “New” and "personalized" statistical methods    
3. Code sharing - be inspired and inspiring    
4. Career perspectives increased with this skill    
5. Data visualization -> better understanding of your data      
6. Avoid copy / paste frustrations      
7. Customization - get exactly what you want    
8. Develop interactive graphs and web-apps to increase dissemination and understanding of your work   
9. Consults with a statistician easier        
10. Personal satisfaction (it can be fun)    

In summary, coding has the attributes of flexibility, transparency, and reproduciblity which should enhance overall research quality.
 
## Statistical software - R

The most important element in clinical epidemiology is NOT which statistical software is chosen but rather an in depth understanding the basic epidemiologic and statistical concepts. Having said that, there are many advantages for `R`, largely summarized by the fact that [R](https://www.nytimes.com/2009/01/07/technology/business-computing/07program.html?pagewanted=all) is the lingua franca of data science, used by millions of data experts. 


**Why `R`? **     

* Free and open source software environment for statistical computing and graphics     
* Open source indicates the original source code is freely available, may be redistributed, and modified     
* Allows & encourages researchers to modify, extend, and develop additions to the base program     
* Additions are referred to as packages    
* Use of scripts and Rmarkdown encourages reproducible research    
* Active online community facilitates formal courses, sharing of solutions to coding queries   
* [Rstudio](https://rstudio.com), an integrated development environment (IDE) greatly facilitates the `R` experience    
* Combining with `Rmarkdown` can easily create, reproduce and share your work via html or pdf files      

This book is not intended to be first line resource for learning `R`, as there are many excellent online learning resources. It should be noted that there are at least 2 flavors or `R` - 1) standard base `R` 2) [tidyverse version](https://www.tidyverse.org), a collection of R packages designed with a common  philosophy, grammar, and data structures especially useful for data science. 

**Learning and help resources **     

* `R` definitive online resource can be found at [CRAN](https://cran.r-project.org/doc/manuals/R-intro.html) has a number of manuals online    
* Condensed `R` reference card can be found [here][https://cran.r-project.org/doc/contrib/Short-refcard.pdf]  
* The [swirl](http://swirlstats.com/) tutorial teaches R programming and data science interactively, install `swirl` with `install.packages("swirl")` and run  with the `swirl()` command   
* Helpful cheet sheets can be found as the [RStudio website](https://rstudio.com/resources/cheatsheets/)    
* [UCLA](http://statistics.ats.ucla.edu/stat/r/)
* [Quick R](http://www.statmethods.net)
* [R blogger](http://www.r-bloggers.com), a daily compilation of R blogs from over the interent
* [Advanced R](http://adv-r.had.co.nz)
* After acquiring the basics, many questions are answered with the help of [Stackoverflow](https://stackoverflow.com/questions/tagged/r)    
* Good old [Google](https://www.google.com/search?sxsrf=ALeKk01Tqej0EWIEpcnxnJzIMqQG5GTjXg%3A1610916306178&ei=0qEEYMWiCqqyggfTz6vYAw&q=r+questions+and+answers&oq=r+questions&gs_lcp=CgZwc3ktYWIQARgBMgUIABDJAzICCAAyAggAMgIIADICCAAyAggAMgYIABAWEB4yBggAEBYQHjIGCAAQFhAeMgYIABAWEB46BAgjECc6CggAELEDEIMBEEM6BAgAEEM6BwgAELEDEEM6BwgjEOoCECc6CwguELEDEMcBEKMCOggIABCxAxCDAToICC4QsQMQgwE6BQguELEDOg0IABCxAxCDARDJAxBDOgoILhCxAxCDARBDOggIABDJAxCRAjoHCAAQFBCHAjoICC4QxwEQrwFQkj1YnmRgnIoBaAFwAHgAgAFuiAHIB5IBBDExLjGYAQCgAQGqAQdnd3Mtd2l6sAEKwAEB&sclient=psy-ab) using "r type your question"     

Within the `R` environment to find help for a specific function, for example `epi.2by2` in the `EpiR` package try typing     
* `help("epi.2by2")`      
* `example("epi.2by2")`     
* `help.search("epi.2by2")`   
* RSiteSearch("epi.2by2") - provides online search    

**Packages **    

The capabilities of base `R` are greatly extended using “packages”. These are distributed over the Internet via [CRAN](https://cran.r-project.org/) and can be downloaded either directly during an `R` session by typing the command `install.packages("pakage.name")`. Alternatively this can be done via RStudio which also provides a directory of all downloaded and installed packages. In 2010, there were about 2,000 packages, by 2016 there were almost 10,000 and by 2020 this has reached almost 17,000. This rapid growth of these important resources is one of the prime reasons for the ever increasing popularity of `R`. Of course, there is also a chick and egg argument that sees the increasing popularity of R as a reason why more people are contributing packages.  
For epidemiologists some of the standard epidemiology packages include `epiR`, `epibasix`, `epitools`, and `Epi` but there are over 30 packages including some that are ultra specialized. 

\begin{figure}

{\centering \includegraphics[width=23.53in]{img/cran_epi} 

}

\caption{Epi packages available on CRAN}(\#fig:unnamed-chunk-2)
\end{figure}

## R - Common data and variable manipulations

`R` is a programming language based on the concept of objects, which may be data or code, in the form of procedures. The data structures are a form of organizing and storing data are four basic types - vector (single dimension structure of 1 type), matrix (two dimension structure of 1 type), list (single dimensional data structure of different types), & data frame (special case of a list where each component is of same length). Data frames are the most common data structure used in epidemiology analyses.    
Here are some common data manipulations in R that represent the minimal knowledge or comfortable level that the reader may like to have to easily follow the code in later chapters.

**Creating a data frame**

```r
# creation of a simple data frame (dat)
dat <-  data.frame('id'=1:4, 'Age'=c(21,15,14,18), 'Gender'=c('M','F','F','M'))
dat
```

```
##   id Age Gender
## 1  1  21      M
## 2  2  15      F
## 3  3  14      F
## 4  4  18      M
```

**Read a data file**

```r
dat1 <- read.csv("data/pima_db.csv")
head(dat1,3)
```

```
##   Pregnancies Glucose BloodPressure SkinThickness Insulin  BMI
## 1           6     148            72            35       0 33.6
## 2           1      85            66            29       0 26.6
## 3           8     183            64             0       0 23.3
##   DiabetesPedigreeFunction Age Outcome
## 1                    0.627  50       1
## 2                    0.351  31       0
## 3                    0.672  32       1
```
Other file formats including Excel, SAS, Stata, SPSS files can be read with `readxl::read_excel()`, `sas7bdat::read.sas7bdat()`, `Hmisc::spss.get()`, `foreign::read.dta()` respectively.   

**Variable manipulation**


```r
# create a new variable based on cutoff on existing variable
# Base R
dat1$Glucose_hi <- NA
dat1[dat1$Glucose >120, 'Glucose_hi'] <- 1
dat1[dat1$Glucose <=120, 'Glucose_hi'] <- 0
head(dat1[,c(1:3,8:10)],4)
```

```
##   Pregnancies Glucose BloodPressure Age Outcome Glucose_hi
## 1           6     148            72  50       1          1
## 2           1      85            66  31       0          0
## 3           8     183            64  32       1          1
## 4           1      89            66  21       0          0
```

```r
#tidyverse
library(tidyverse)
dat2 <- dat1 %>% mutate(Age_old = ifelse(Age > 50, 1, 0))  
head(dat2[,c(1:3,8:11)],10)
```

```
##    Pregnancies Glucose BloodPressure Age Outcome Glucose_hi Age_old
## 1            6     148            72  50       1          1       0
## 2            1      85            66  31       0          0       0
## 3            8     183            64  32       1          1       0
## 4            1      89            66  21       0          0       0
## 5            0     137            40  33       1          1       0
## 6            5     116            74  30       0          0       0
## 7            3      78            50  26       1          0       0
## 8           10     115             0  29       0          0       0
## 9            2     197            70  53       1          1       1
## 10           8     125            96  54       1          1       1
```

**Variable and data subsetting**


```r
#################
# Variable subsetting
#################
# Base R
dat1s = subset(dat1, select = c('Pregnancies', 'Glucose'))
head(dat1s)
```

```
##   Pregnancies Glucose
## 1           6     148
## 2           1      85
## 3           8     183
## 4           1      89
## 5           0     137
## 6           5     116
```

```r
# tidyverse
dat1 %>% dplyr::select(Pregnancies, Glucose) %>% head()
```

```
##   Pregnancies Glucose
## 1           6     148
## 2           1      85
## 3           8     183
## 4           1      89
## 5           0     137
## 6           5     116
```

```r
#################
# Data subsetting
#################
# Base R #1
dat1s <-  subset(dat1, subset = Pregnancies >2 & Glucose_hi == 1) # notice need for == when looking for equality
head(dat1s[,c(1:4,8:10)])
```

```
##    Pregnancies Glucose BloodPressure SkinThickness Age Outcome Glucose_hi
## 1            6     148            72            35  50       1          1
## 3            8     183            64             0  32       1          1
## 10           8     125            96             0  54       1          1
## 12          10     168            74             0  34       1          1
## 13          10     139            80             0  57       0          1
## 15           5     166            72            19  51       1          1
```

```r
# Base R #2
dat1ss = dat1[which(dat1$Pregnancies >2 & dat1$Glucose_hi ==1),]
head(dat1ss[,c(1:4,8:10)])
```

```
##    Pregnancies Glucose BloodPressure SkinThickness Age Outcome Glucose_hi
## 1            6     148            72            35  50       1          1
## 3            8     183            64             0  32       1          1
## 10           8     125            96             0  54       1          1
## 12          10     168            74             0  34       1          1
## 13          10     139            80             0  57       0          1
## 15           5     166            72            19  51       1          1
```

```r
# tidyverse
library(tidyverse)
dat1 %>% dplyr::filter(Pregnancies >2 & Glucose_hi == 1) %>% head(,c(1:4,8:10))
```

```
##   Pregnancies Glucose BloodPressure SkinThickness Insulin  BMI
## 1           6     148            72            35       0 33.6
## 2           8     183            64             0       0 23.3
## 3           8     125            96             0       0  0.0
## 4          10     168            74             0       0 38.0
## 5          10     139            80             0       0 27.1
## 6           5     166            72            19     175 25.8
##   DiabetesPedigreeFunction Age Outcome Glucose_hi
## 1                    0.627  50       1          1
## 2                    0.672  32       1          1
## 3                    0.232  54       1          1
## 4                    0.537  34       1          1
## 5                    1.441  57       0          1
## 6                    0.587  51       1          1
```

**Basic Data Descriptions**


```r
# Base R
summary(dat1)
```

```
##   Pregnancies       Glucose    BloodPressure   SkinThickness     Insulin     
##  Min.   : 0.00   Min.   :  0   Min.   :  0.0   Min.   : 0.0   Min.   :  0.0  
##  1st Qu.: 1.00   1st Qu.: 99   1st Qu.: 62.0   1st Qu.: 0.0   1st Qu.:  0.0  
##  Median : 3.00   Median :117   Median : 72.0   Median :23.0   Median : 30.5  
##  Mean   : 3.85   Mean   :121   Mean   : 69.1   Mean   :20.5   Mean   : 79.8  
##  3rd Qu.: 6.00   3rd Qu.:140   3rd Qu.: 80.0   3rd Qu.:32.0   3rd Qu.:127.2  
##  Max.   :17.00   Max.   :199   Max.   :122.0   Max.   :99.0   Max.   :846.0  
##       BMI       DiabetesPedigreeFunction      Age          Outcome     
##  Min.   : 0.0   Min.   :0.078            Min.   :21.0   Min.   :0.000  
##  1st Qu.:27.3   1st Qu.:0.244            1st Qu.:24.0   1st Qu.:0.000  
##  Median :32.0   Median :0.372            Median :29.0   Median :0.000  
##  Mean   :32.0   Mean   :0.472            Mean   :33.2   Mean   :0.349  
##  3rd Qu.:36.6   3rd Qu.:0.626            3rd Qu.:41.0   3rd Qu.:1.000  
##  Max.   :67.1   Max.   :2.420            Max.   :81.0   Max.   :1.000  
##    Glucose_hi   
##  Min.   :0.000  
##  1st Qu.:0.000  
##  Median :0.000  
##  Mean   :0.454  
##  3rd Qu.:1.000  
##  Max.   :1.000
```

```r
# Other approaches
psych::describe(dat1)
```

```
##                          vars   n   mean     sd median trimmed   mad   min
## Pregnancies                 1 768   3.85   3.37   3.00    3.46  2.97  0.00
## Glucose                     2 768 120.89  31.97 117.00  119.38 29.65  0.00
## BloodPressure               3 768  69.11  19.36  72.00   71.36 11.86  0.00
## SkinThickness               4 768  20.54  15.95  23.00   19.94 17.79  0.00
## Insulin                     5 768  79.80 115.24  30.50   56.75 45.22  0.00
## BMI                         6 768  31.99   7.88  32.00   31.96  6.82  0.00
## DiabetesPedigreeFunction    7 768   0.47   0.33   0.37    0.42  0.25  0.08
## Age                         8 768  33.24  11.76  29.00   31.54 10.38 21.00
## Outcome                     9 768   0.35   0.48   0.00    0.31  0.00  0.00
## Glucose_hi                 10 768   0.45   0.50   0.00    0.44  0.00  0.00
##                             max  range  skew kurtosis   se
## Pregnancies               17.00  17.00  0.90     0.14 0.12
## Glucose                  199.00 199.00  0.17     0.62 1.15
## BloodPressure            122.00 122.00 -1.84     5.12 0.70
## SkinThickness             99.00  99.00  0.11    -0.53 0.58
## Insulin                  846.00 846.00  2.26     7.13 4.16
## BMI                       67.10  67.10 -0.43     3.24 0.28
## DiabetesPedigreeFunction   2.42   2.34  1.91     5.53 0.01
## Age                       81.00  60.00  1.13     0.62 0.42
## Outcome                    1.00   1.00  0.63    -1.60 0.02
## Glucose_hi                 1.00   1.00  0.18    -1.97 0.02
```

```r
broom::tidy(dat1)
```

```
## # A tibble: 10 x 13
##    column     n    mean      sd  median trimmed    mad    min    max  range
##    <chr>  <dbl>   <dbl>   <dbl>   <dbl>   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 Pregn~   768   3.85    3.37    3       3.46   2      0      17     17   
##  2 Gluco~   768 121.     32.0   117     119.    20      0     199    199   
##  3 Blood~   768  69.1    19.4    72      71.4    8      0     122    122   
##  4 SkinT~   768  20.5    16.0    23      19.9   12      0      99     99   
##  5 Insul~   768  79.8   115.     30.5    56.7   30.5    0     846    846   
##  6 BMI      768  32.0     7.88   32      32.0    4.6    0      67.1   67.1 
##  7 Diabe~   768   0.472   0.331   0.372   0.422  0.168  0.078   2.42   2.34
##  8 Age      768  33.2    11.8    29      31.5    7     21      81     60   
##  9 Outco~   768   0.349   0.477   0       0.312  0      0       1      1   
## 10 Gluco~   768   0.454   0.498   0       0.443  0      0       1      1   
## # ... with 3 more variables: skew <dbl>, kurtosis <dbl>, se <dbl>
```

## RStudio - **The** IDE for R

[RStudio](https://rstudio.com) is an integrated development environment (IDE) for R. For overall convenience, flexibility, educational resources, and ongoing development it is in my opinion an unparalleled environment for working in R. It offers a multi-pane console, syntax-highlighting editor that supports direct code execution, as well as tools for plotting, history, project and workspace management. There are many tools within RStudio that facilitate coding including numerous shortcuts which accessed from a drop down menu within RStudio and can be found [here]( https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts). Several shortcuts that I find most helpful are listed below.

```markdown
Table: Very useful RStudio shortcuts
| Command                          	| Windows                                     	| Mac             	|
|----------------------------------	|---------------------------------------------	|-----------------	|
| Assignment operator              	| Alt + -                                     	| Opt + -         	|
| Commenting & Uncommenting Code   	| Ctrl + Shift + C                            	| Cmd + Shift + C 	|
| Add the Pipe %>%                 	| Ctrl + Shift + M                            	| Cmd + Shift + M 	|
| Keyboard Shortcut Cheat Sheet    	| Alt + Shift + K                             	| Opt + Shift + K 	|
| Move cursor beginning of line    	| Home                                        	| Cmd+Left        	|
| Move cursor to end of line       	| End                                         	| Cmd+Right       	|
```

When using RStudio, it generally most helpful to begin by creating a `New Project from the `File` drop down menu. As you will soon appreciate this has definitely file management advantages. For individual files, I find it most useful to create individual RMarkdown documents. For this book, each chapter is a separate `Rmd` file. These files have the advantage of being able to combine free text and `R` code chunks which via a synthesis of the `markdown` language and `Pandoc` allows the output to be on the format of your choice (html, LaTex/pdf, WORD).

## R - More than a statistical program 

`R` is  much more than a mere statistical program. It is a complete programming language which while highly advantageous does result in a non trivial learning curve. One of the most outstanding attributes of `R` is the ability to produce publication quality data visualizations with either base `R` or within the tidyverse universe by using `ggplot2` (see next chapter). Interactive graphics can also be easily produced. To appreciate the range of graphical activities possible, here is a self portrait drawn by `R`. The code for this may be found [here](https://github.com/brophyj/epi_book/blob/main/portrait.R). 


\begin{figure}

{\centering \includegraphics[width=0.33\linewidth]{img/brophy} 

}

\caption{Self portrait}(\#fig:unnamed-chunk-8)
\end{figure}

Some beautiful art and the accompanying `R` code can be found [here](https://jasmines.djnavarro.net)

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{img/navarro_art} 

}

\caption{R art}(\#fig:unnamed-chunk-9)
\end{figure}

## R - General Public License
\begin{FOO}
R is free software and comes with ABSOLUTELY NO WARRANTY. You are
welcome to redistribute it under the terms of the GNU General Public
License versions 2 or 3. For more information about these matters see
\url{http://www.gnu.org/licenses/}.
\end{FOO}

