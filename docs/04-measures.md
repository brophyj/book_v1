# Contingency tables, measures of association & R packages {#meas}

### R packages required for this chapter


```r
library(knitr)
library(kableExtra)
library(tidyverse) # specifically dplyr and ggplot2
library(epiR)
library(epibasix)
library(epitools)
```

## Proportions - One sample $\chi^2$ tests {#meas1}

Suppose we have the following data and want to test if the hypothesis that $\pi$ = 0.80 is true. In this simple example, the base `R` `chisq.test` function is more than adequate.

|            | Success | Failure |
|------------|---------|---------|
| Population | 60      | 40      |    


```r
# one sample chi sq test
x <- c(60,40)
chisq.test(x, p = c(.8, .2))
```

```
## 
## 	Chi-squared test for given probabilities
## 
## data:  x
## X-squared = 25, df = 1, p-value = 6e-07
```

For small sample sizes (n < 5), `chisq.test` is not valid. A famous example of a small data set is Fisher's [lady tasting tea example](https://en.wikipedia.org/wiki/Lady_tasting_tea). In this experiment, a lady claims she can tell if milk is added to the cup before or after the tea. suppose there are 8 cups, 4 with milk added first and 4 with milk added after the tea. How unlikely would it be if she could identify correctly the 8 cups? This can be calculated by hand using the [hypergeometric distribution](https://en.wikipedia.org/wiki/Hypergeometric_distribution) or using `fisher.test`.


```r
Tea <- matrix(c(4, 0, 0, 4), nrow = 2,
      dimnames = list(Guess = c("Milk", "Tea"), Truth = c("Milk", "Tea")))
temp <- fisher.test(Tea, alternative = "greater")
Tea
```

```
##       Truth
## Guess  Milk Tea
##   Milk    4   0
##   Tea     0   4
```

```r
temp
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  Tea
## p-value = 0.01
## alternative hypothesis: true odds ratio is greater than 1
## 95 percent confidence interval:
##  2.004   Inf
## sample estimates:
## odds ratio 
##        Inf
```

```r
# more precise p value
temp$p.value
```

```
## [1] 0.01429
```
There is a 1.4% chance of this occurring.    


More commonly we will have larger 2X2 datasets, or more generally nXm datasets to investigate and these may be helpfully presented in contingency tables.

## Contingency tables 

Begin by reading in the `heart.csv` [dataset](https://github.com/brophyj/book_v1/blob/main/data/heart.csv) where the outcome status is the `fstat` variable. Details about the other variables can be obtained with `str()`. It is often of interest to initially explore any categorical exposure and outcome create a contingency table of `fstat` (alive / dead)  versus `gender` (men=0, women=1).


```r
heart <- read.csv("data/heart.csv", header = TRUE)
# create gender factor variable
heart$gender <- factor(heart$gender, labels = c("men", "women"))
# Create a 2-way contingency table of gender vs outcome
table(heart$gender,heart$fstat )
```

```
##        
##         alive dead
##   men     189  111
##   women    96  104
```

As discussed in Chapter \@ref(vis), graphical displays are often helpful and informative.

```r
# Create side-by-side barchart outcome and gender
ggplot(heart, aes(x = gender, fill = fstat)) + 
  geom_bar(position = "dodge")  +  #position = "dodge", to have a side-by-side (i.e. not stacked) barchart
  theme_bw()
```

<img src="04-measures_files/figure-html/unnamed-chunk-5-1.png" width="672" />
     
There are more males than females in this dataset. Total male and female deaths are about equal but better survival rates in males. Marginals can be easily obtained as can statistical testing with `chisq.test` or `fisher.test`   

```r
tab <- table(heart$gender,heart$fstat )
# marginals
rowSums(tab)
```

```
##   men women 
##   300   200
```

```r
colSums(tab)
```

```
## alive  dead 
##   285   215
```

```r
paste("Probabilities conditional on columns")
```

```
## [1] "Probabilities conditional on columns"
```

```r
prop.table(tab, 2)  
```

```
##        
##          alive   dead
##   men   0.6632 0.5163
##   women 0.3368 0.4837
```

```r
paste("\nProbabilities conditional on rows")
```

```
## [1] "\nProbabilities conditional on rows"
```

```r
prop.table(tab, 1) 
```

```
##        
##         alive dead
##   men    0.63 0.37
##   women  0.48 0.52
```

```r
# statistical testing
chisq.test(tab)
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  tab
## X-squared = 10, df = 1, p-value = 0.001
```

```r
fisher.test(tab)
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  tab
## p-value = 0.001
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  1.262 2.696
## sample estimates:
## odds ratio 
##      1.842
```
Now while the base `R` `chisq.test` function provides the OR, 95% CI, and a p value, we will show in section \@ref(packages) that the use of epidemiologic specific `R` packages allows the use of more customized and detailed functions.    
Suppose we are now interested in the gender outcomes association but according to the presence or absence of pre-existing cardiac disease. Adding this third variable, ` cvd` is straightforward but the limits of this approach are  readily appreciated as the number of variables increases.      


```r
table(heart$gender, heart$fstat, heart$cvd)
```

```
## , ,  = no
## 
##        
##         alive dead
##   men      65   24
##   women    15   21
## 
## , ,  = yes
## 
##        
##         alive dead
##   men     124   87
##   women    81   83
```

```r
# Plot of alignment broken down by gender
ggplot(heart, aes(x = gender,fill = fstat )) + 
  geom_bar() +
  facet_wrap(~ cvd) +
  theme_bw()
```

<img src="04-measures_files/figure-html/unnamed-chunk-7-1.png" width="672" />

## Some basic defintions

1.  **Cumulative incidence** ---proportion of new cases developing in an initial disease free population during a given risk period.

2.  **Incidence time** ---time span from 0 to the time of outcome/event/failure/occurrence

3.  **Person-time** ---length of time that each individual was in the population at risk of the event

4.  **Total person-time at risk** - sum of all individual person-times

5.  **Incidence rate** ---number of new cases of disease divided by person-time over the period

6.  **Incidence proportion or cumulative incidence** ---with complete cohort follow-up, it is the proportion of people who become cases among those in the population at the start of the interval. Can also be considered a measure of average risk

**Comparison of cumulative incidence and incidence rate**

+-------------+----------------------+----------------------+-------------------+--------------------+
|             | Cumulative Incidence | Cumulative Incidence | Incidence rate    | Incidence rate     |
+=============+======================+======================+===================+====================+
|             | FU complete          | FU incomplete        | FU complete       | FU incomplete      |
+-------------+----------------------+----------------------+-------------------+--------------------+
| Numerator   | cases                | Kaplan Meier         | Number cases      | Number cases       |
|             |                      |                      |                   |                    |
|             |                      | Lfe Table            |                   |                    |
+-------------+----------------------+----------------------+-------------------+--------------------+
| Denominator | population           | Kaplan Meier         | Person - time     | Average population |
|             |                      |                      |                   |                    |
|             |                      | Lfe Table            |                   |                    |
+-------------+----------------------+----------------------+-------------------+--------------------+
| Units       | no units             | no units             | Time^-1^          | Time^-1^           |
+-------------+----------------------+----------------------+-------------------+--------------------+
| Range       | 0 to 1               | 0 to 1               | 0 to infinity     | 0 to infinity      |
+-------------+----------------------+----------------------+-------------------+--------------------+
| Synonyms    | Probability          | Probability          | Incidence density | Incidence density  |
|             |                      |                      |                   |                    |
|             | Proportion           | Proportion           |                   |                    |
+-------------+----------------------+----------------------+-------------------+--------------------+

Risk is a general term but often refers to cumulative incidence (Q) but other interpretations including instantaneous risk (hazard) and risk at a given time point (prevalence).\
Incidence rate and cumulative incidence proportion are longitudinal measures. In contrast prevalence measures are cross-sectional. The numerator of cumulative incidence and incidence rates are the number of cases while the denominator is proportional to the size (counts or person time) of the population from whioch the cases are derived. Numerator and denominator must cover the same population and the same time period.

### Relative comparative measures

Generic name "relative risk" (RR) comparing occurrences between exposed (1) and unexposed (0) groups can refer to\
\* Incidence rate ratio IR = I1 / I0 (the most commonly used comparative measure)\
\* Incidence proportion ratio IPR = Q1 / Q0\
\* Incidence odds ratio IOR = [Q1/(1 − Q1)] / [Q0/(1 − Q0)]\
\* Prevalence ratio PR = P1/P0\
\* Prevalence odds ratio POR = [P1/(1 − P1)] / [P0/(1 − P0)]

### Absolute comparative measures

Generic term "excess risk" or "risk difference" (RD) between exposed and unexposed can refer to\
\* Incidence rate difference ID = I1 − I0\
\* Incidence proportion difference IPD = Q1 − Q0\
\* Prevalence difference PD = P1 − P0

Ratios -- most often employed to describe the biological strength of the exposure\
Differences -- absolute differences better inform about public health importance

### Attributal measures

\-**Attributable fraction** (excess fraction or attributable risk) is a measures of potential impact. $$AF = \dfrac{I_{1} - I_{0}}{I_{1}} = \dfrac{RR-1}{RR}$$\
This measure estimates the fraction out of all new cases of disease *among those exposed*, which are attributable to (or "caused" by) the exposure itself, and which thus could be avoided if the exposure were absent. This represents the biological impact of exposure and is represented diagrammatically as

<p align="center">

![](img/assoc/af.png)

<p align="center">

where AF fraction = black area out of total black + gray area.

\-**Prevented fraction** When the incidence in exposed is lower, we define the prevented fraction as $$AF = \dfrac{I_{0} - I_{1}}{I_{0}} = 1 - RR$$

\-**Population attributable (excess) fraction (PAF)** addresses the impact of exposure on the population level and also depends $p_E$, the proportion of exposed in the population.


\begin{equation} 
  PAF = I - I_{0} 
  (\#eq:paf)
\end{equation} 



   
where $I$ = population incidence that can be expressed as a weighted average among exposed and unexposed as follows   
$I = p_{E}*I_{1} + (1-p_{E})*I_{0}$ and substituting into Equation \@ref(eq:paf) gives   


\begin{equation} 
  PAF = \dfrac{I - I_{0}}{I} = \dfrac{p_{E} * (RR-1)}{1 + p_{E}* (RR-1) }
  (\#eq:paf1)
\end{equation} 

**Important:** Use the crude and NOT adjusted RR in the above PAF formula that uses the fraction of the entire population exposed  



Diagrammatically represented as

<p align="center">

![](img/assoc/paf.png)

<p align="center">

where PAF fraction = black area out of total black + gray area.      

The PAF is only a simple fraction derived from the arithmetic manipulation of probabilities.  As with  other measures in public health, how this fraction is interpreted is key. For PAF to be important in the discussion of the public health consequences of intervening to reduce the prevalence  of risk exposures, we need to be sure of     
- the causal model    
- absence or control of confounding      
- understanding of multiple exposures & their combinations      
- existence of a feasible intervention with no untoward effects       

`R` packages for AF estimation include `epiR`, `attribrisk`, `paf` and `AF`. `AF` can handle confounders for different research designs, including survival data, matched case/control and clustered data. 


### Standardization

Sometimes the exposure disease relationship is distorted by another variable and stratification is the most transparent manner of dealing with this confounding. Combining this strata is most often used for age adjustment.Other more advanced techniques for dealing with confounding will be discussed in later chapters.\
- **Direct adjustment** by standardization $= \sum_{k=1}^K weight_k * rate_k /$ *sum of weights*\
is a weighted average of stratum-specific rates for each group and applies them to a common standard, but often arbitrary, population, thereby removing differences due to distribution of the population\
- **Indirect adjustment** is performed whenever the stratum-specific incidence risk estimates are either unknown or unreliable. In this case external stratum specific rates are applied.

## Examples using base R

### Example 1 - basic incidence measures

Consider the follow-up of a small cohort of 10 subjects.


```r
# Create small data set
set.seed(1234)
data <- data.frame(
  x=factor(c(1:10)),
  y=abs(runif(10, 1,24)),
  cen=factor(c("n","y","n", "y","n","n","y","n","y","n"), labels = c("died", "censored"))
)

# plot of follow-up time
p <- ggplot(data, aes(x=x, y=y, color=cen)) +
  geom_segment( aes(x=x, xend=x, y=0, yend=y ) ) +
  geom_point( color=ifelse(data$cen == "died", "orange", "blue"), size=ifelse(data$cen == "died", 5, 2) ) +
  theme_bw() +
  coord_flip() +
  xlab("subject") +
  scale_y_continuous(name="Follow-up (months)", breaks = seq(0, 24, 3), limits=c(0, 24)) +
  ggtitle("Horizontal plot of follow-up time") +
  labs(color = "Status")
p
```

<img src="04-measures_files/figure-html/unnamed-chunk-8-1.png" width="672" />

The incidence rate at the end of the follow-up (21 months) = total number of deaths / total person time follow-up


```r
options(scipen = 1, digits = 2)
ir_m <- sum(data$cen=="died") / sum(data$y)
```

The incidence rate at the end of the follow-up (21 months) = 0.05 / person month or 4.9 / 100 person months\
The incidence rate at the end of the follow-up could also be expressed in person years = 0.59 / person year or 58.76 / 100 person years\
One could also calculate the incidence rate for the first 12 months.


```r
options(scipen = 1, digits = 2)
deaths_1 <- data %>%
  filter( y<= 12) %>% 
  summarise(n=n(), months=sum(y))
```

In this time period there were 3 deaths in 11.18 months of follow-up. There were also 7 subjects who completed the 12 months follow-up with no deaths. So the total follow-up time = 95.18\
Therefore the incidence rate at 12 months = 0.03 / person month or 3.15 / 100 person months.\
What is the cumulative incidence over 21 months?\
On the surface, straightforward calculation of number of deaths / initial population = 0.6. However this ignores the censoring.\
The incidence proportions in the presence of censoring can be estimated by assuming a constant rates. $$Q = 1 − exp^{(−I × ∆)} = 1- exp^{(-0.049 * 21)} = 0.64$$ With dynamic study population individual follow-up times are variable and difficult to measure accurately such that a common approximation is to use the mid-population average of the initial and final populations multiplied by the follow-up time.

### Example 2 - rare disease

For *rare disease*, the cumulative incidence, rate incidence and incident odds ratio are very similar.\
Consider the following data;


```r
options(digits = 5)
dt <- data.frame(Yes= c(4000,30, 7970), No=c(16000,60, 31940), row.names=c("No. initally at risk", "No. cases", "Person years at risk"))
kbl(dt) %>%
  kable_paper() %>%
  add_header_above(c(" ", "Exposure" = 2)) 
```

<table class=" lightable-paper" style='font-family: "Arial Narrow", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
<tr>
<th style="empty-cells: hide;" colspan="1"></th>
<th style="padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="2"><div style="border-bottom: 1px solid #00000020; padding-bottom: 5px; ">Exposure</div></th>
</tr>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Yes </th>
   <th style="text-align:right;"> No </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> No. initally at risk </td>
   <td style="text-align:right;"> 4000 </td>
   <td style="text-align:right;"> 16000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> No. cases </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:right;"> 60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Person years at risk </td>
   <td style="text-align:right;"> 7970 </td>
   <td style="text-align:right;"> 31940 </td>
  </tr>
</tbody>
</table>

```r
cum_inc <- (dt[2,1]/dt[1,1]) / (dt[2,2]/dt[1,2])                           #    30/4000  /   60/16000
rate_ratio <- (dt[2,1]/dt[3,1]) / (dt[2,2]/dt[3,2])
odds_ratio <- (dt[2,1]/(dt[1,1]-dt[2,1])) / (dt[2,2]/(dt[1,2]-dt[2,2]))
```

This gives a cumulative incidence, rate incidence and incident odds ratio of 2 , 2.0038 , 2.0076, respectively

### Example 3 - Standardization

Consider the following cases and populations at risk from 2 different cities

<table>
<caption>(\#tab:unnamed-chunk-12)Cases and numbers at risk</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> age </th>
   <th style="text-align:right;"> cases </th>
   <th style="text-align:right;"> at_risk </th>
   <th style="text-align:left;"> city </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> &lt;40 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:left;"> Pop1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> &gt;40 </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 200 </td>
   <td style="text-align:left;"> Pop1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> &lt;40 </td>
   <td style="text-align:right;"> 40 </td>
   <td style="text-align:right;"> 400 </td>
   <td style="text-align:left;"> Pop2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> &gt;40 </td>
   <td style="text-align:right;"> 80 </td>
   <td style="text-align:right;"> 200 </td>
   <td style="text-align:left;"> Pop2 </td>
  </tr>
</tbody>
</table>

The crude risk ratio (Population 1 : Population 2) is 2 but there is severe unbalancing in the age distributions of the 2 populations and age influences the outcome.


```r
# stratum specific rates
rate1 <- dat[1:2,"cases"] /dat[1:2, "at_risk"]
rate2 <- dat[3:4,"cases"] /dat[3:4, "at_risk"]

std.pop <- c(500, 100)  # standard young population

# adjusted risk ratio
std.pop1 <- rate1*std.pop; std.pop2 <- rate2*std.pop
rr_std_y <- sum(std.pop1) / sum(std.pop2)

std.pop <- c(100, 500)  # standard older population

# adjusted risk ratio
std.pop2 <- rate1*std.pop; std.pop2 <- rate2*std.pop
rr_std_o <- sum(std.pop1) / sum(std.pop2)
```

Standardizing the age distributions (500, 100), we see that Population 2 still has an increased risk, 1.66667, but part of the crude difference was due to the confounding effect of age. Standardizing to an older population (100,500) leads to a smaller relative risk, 0.71429.\
The calculations could be incorporated into a user defined function.


```r
std.pop <- c(100, 500)
std.direct <- function(x1,y1,x2,y2,std.pop){
  rate1 <- x1/y1; rate2 <- x2/y2
   std.pop1 <- rate1*std.pop; std.pop2 <- rate2*std.pop
   sum(std.pop1) / sum(std.pop2)
 }
std.direct(dat[1:2,2], dat[1:2,3], dat[3:4,2], dat[3:4,3], std.pop)
```

```
## [1] 1.2857
```

## Examples using R epidemiology packages {#packages}

### Example 4 Standardization  

Continuing with the above example, rather than writing your own function, one could use `epi.directadj` from the `epiR` package.   
Care must be taken to provide the arguments as matrices.


```r
# preprocessing function arguments to matrices
obs <- matrix(dat$cases, nrow = 2, byrow = TRUE,
  dimnames = list(c("Pop1","Pop2"), c("<40",">40")))
tar <- matrix(dat$at_risk, nrow = 2, byrow = TRUE,
  dimnames = list(c("Pop1","Pop2"), c("<40",">40")))
std <- matrix(data = c(500,100), nrow = 1, byrow = TRUE,
  dimnames = list("", c("<40",">40")))

ans <- epi.directadj(obs, tar, std, units = 1, conf.level = 0.95)
rr <- ans$adj.strata$est[1] / ans$adj.strata$est[2]
ans
```

```
## $crude
##   strata cov est    lower   upper
## 1   Pop1 <40 0.2 0.122165 0.30888
## 2   Pop2 <40 0.1 0.071441 0.13617
## 3   Pop1 >40 0.5 0.406820 0.60813
## 4   Pop2 >40 0.4 0.317175 0.49783
## 
## $crude.strata
##   strata est   lower   upper
## 1   Pop1 0.4 0.33164 0.47830
## 2   Pop2 0.2 0.16582 0.23915
## 
## $adj.strata
##   strata  est   lower   upper
## 1   Pop1 0.25 0.18082 0.34038
## 2   Pop2 0.15 0.12180 0.18346
```

The `epi.directadj` function provides additional outputs including the crude, crude by stratum and adjusted values along with the 95% confidence intervals. The adjusted value for population 1 = 0.25 and the adjusted value for population 1 = 0.15 so the relative risk is 1.66667 as calculated previously for the older standard population.

It is most helpful to include a measure of the variation around this point estimate and the general structure is: **Point estimate ± [1.96 × SE (estimate)]** where 1.96 is the z-score (standard normal score) corresponding to the 95% confidence level (i.e., an alpha error of 5%). Confidence intervals for different levels of alpha error obtained by replacing this value with the corresponding z-score value (e.g., 1.64 for 90%, 2.58 for 99% confidence intervals).

Because the RR is a multiplicative measure and thus asymmetrically distributed, its SE needs to be calculated in a logarithmic scale. $$Se(log RR) = \sqrt{\frac{b}{a + b} + \frac{d}{c + d}}$$ where a = exposed cases, b = exposed non cases, c = unexposed cases, d = unexposed non cases\
The 95% CI calculated on the logarithmic scale is therefore log(95%CI RR) = log RR ± 1.96 X SE(log RR)


```r
log_se <- sqrt((150/(150*450)) + (90/(90+510)))
log_CI <- log(rr) + c(-1,1)* 1.96 * log_se
CI <- exp(log_CI)
```

The 95% CI for the relative risk are therefore from 0.77578 to 3.58061.

::: {.tip}
Remembering that these CIs are calculated on a multiplicative scale it is noticed that the point estimate is **not** the arithmetic mean of the confidence limits. Rather the point estimate equals the geometric mean, so as expected $\sqrt{.78 * 3.58} = 1.66$.     

This follows from lower limit 95% CI (RR) = RR × e^--[1.96 × SE(log RR)]^ and upper limit 95% CI (RR) = RR × e^[1.96 × SE(log RR)]^     

so lower CI \* upper CI = RR^2^ or RR = $\sqrt{LCI * UCI}$.
:::    


### Example 5 - Contingency Tables with `epiR` package
A most useful function for contingency tables is `epi.2by2()` from the `epiR` package which calculates multiple measures of association.      
But it needs a specific 2 by 2 table that **must** look like this  for risk and odds ratio     

|            | Outcome +     | Outcome -  |
|----------- | ------------- | -----------|
| Exposure + |               |            |
| Exposure - |               |            |
|                                         |

or like this for an incidence rate ratio.       


|            | No. events    | PersonTime |
|----------- | ------------- | -----------|
| Exposure + |               |            |
| Exposure - |               |            |
|                                         |

`epi.2by2` is a useful function but its first argument must be a `table` object and the cell order must be **exactly** as shown above.        

Using the `heart.csv` data, what is the risk ratio for women with men as the reference (non-exposed) group?       
What is the odds ratio for the same association?   


```r
# Remember epi.2by2 needs the table in the right order
# 1st column is events and the 2nd row is the reference group
# previous tab needs to be adjusted accordingly

# risk ratio
tab<- tab[c(2,1),c(2,1)] 
epi.2by2(tab, method="cohort.count")
```

```
##              Outcome +    Outcome -      Total        Inc risk *        Odds
## Exposed +          104           96        200                52       1.083
## Exposed -          111          189        300                37       0.587
## Total              215          285        500                43       0.754
## 
## Point estimates and 95% CIs:
## -------------------------------------------------------------------
## Inc risk ratio                               1.41 (1.15, 1.71)
## Odds ratio                                   1.84 (1.28, 2.65)
## Attrib risk *                                15.00 (6.18, 23.82)
## Attrib risk in population *                  6.00 (-0.98, 12.98)
## Attrib fraction in exposed (%)               28.85 (13.19, 41.68)
## Attrib fraction in population (%)            13.95 (5.16, 21.93)
## -------------------------------------------------------------------
##  Test that OR = 1: chi2(1) = 11.016 Pr>chi2 = <0.001
##  Wald confidence limits
##  CI: confidence interval
##  * Outcomes per 100 population units
```

```r
# odds ratio
epi.2by2(tab, method="case.control")
```

```
##              Outcome +    Outcome -      Total        Prevalence *        Odds
## Exposed +          104           96        200                  52       1.083
## Exposed -          111          189        300                  37       0.587
## Total              215          285        500                  43       0.754
## 
## Point estimates and 95% CIs:
## -------------------------------------------------------------------
## Odds ratio (W)                               1.84 (1.28, 2.65)
## Attrib prevalence *                          15.00 (6.18, 23.82)
## Attrib prevalence in population *            6.00 (-0.98, 12.98)
## Attrib fraction (est) in exposed  (%)        45.72 (20.74, 62.91)
## Attrib fraction (est) in population (%)      22.15 (9.22, 33.23)
## -------------------------------------------------------------------
##  Test that OR = 1: chi2(1) = 11.016 Pr>chi2 = <0.001
##  Wald confidence limits
##  CI: confidence interval
##  * Outcomes per 100 population units
```
      
This  risk (or odds) ratio) can hand checked by calculating the ratio of the risk (or odds) for women and men.   

```r
cat("Hand calculated risk ratio is ", (tab[1,1] /(tab[1,2] + tab[1,1])) / (tab[2,1] /(tab[2,2] + tab[2,1])))
```

```
## Hand calculated risk ratio is  1.4054
```

```r
cat("\nHand calculated odds ratio is ", (tab[1,1] /tab[1,2]) / (tab[2,1] /tab[2,2]))
```

```
## 
## Hand calculated odds ratio is  1.8446
```

What is the incidence rate ratio for women with men as the reference group?
Hint: need to calculate the total number of events and person time according to gender.     


```r
# Base R - tapply for SUM of people who DIED by GENDER and the SUM of FOLLOW-UP TIME by GENDER 
events <- tapply(heart$fstat=="dead", heart$gender, sum) 
persontime <- tapply(heart$lenfol, heart$gender, sum)
# make a 2 by 2 table, remembering to make the unexposed group the 2nd row 
tab_gender <- cbind(events, persontime) 
tab_gender <- tab_gender[c(2,1),]
epi.2by2(tab_gender, method = "cohort.time")
```

```
##              Outcome +    Time at risk        Inc rate *
## Exposed +          104          165492            0.0628
## Exposed -          111          275726            0.0403
## Total              215          441218            0.0487
## 
## Point estimates and 95% CIs:
## -------------------------------------------------------------------
## Inc rate ratio                               1.56 (1.18, 2.06)
## Attrib rate *                                0.02 (0.01, 0.04)
## Attrib rate in population *                  0.01 (-0.00, 0.02)
## Attrib fraction in exposed (%)               35.94 (15.47, 51.42)
## Attrib fraction in population (%)            17.38 (12.96, 21.95)
## -------------------------------------------------------------------
##  Wald confidence limits
##  CI: confidence interval
##  * Outcomes per 100 units of population time at risk
```

Of course, this can also be accomplished with the `tidyverse` approach using the `dplyr` package.    

```r
# Tidyverse approach

heart_rate <- heart %>% 
  group_by(gender) %>% 
  summarise(events =  sum(fstat=="dead"),time = sum(lenfol)) %>% 
  select(-1) %>% 
  as.matrix
heart_rate <- heart_rate[c(2,1),]
epi.2by2(heart_rate, method = "cohort.time")
```

```
##              Outcome +    Time at risk        Inc rate *
## Exposed +          104          165492            0.0628
## Exposed -          111          275726            0.0403
## Total              215          441218            0.0487
## 
## Point estimates and 95% CIs:
## -------------------------------------------------------------------
## Inc rate ratio                               1.56 (1.18, 2.06)
## Attrib rate *                                0.02 (0.01, 0.04)
## Attrib rate in population *                  0.01 (-0.00, 0.02)
## Attrib fraction in exposed (%)               35.94 (15.47, 51.42)
## Attrib fraction in population (%)            17.38 (12.96, 21.95)
## -------------------------------------------------------------------
##  Wald confidence limits
##  CI: confidence interval
##  * Outcomes per 100 units of population time at risk
```
### Example 6 - Contingency Tables with other `R` packages

An advantage of `r` is that there are often multiple ways to get the right answer to a problem. Similarly, there are multiple packages that can used used to calculate epidemiologic measures of association.    
                    

With the `heart.csv` dataset, what is the incidence rate ratio for women with men as the reference group?    
a) Using  `epi2X2()` in the `epibasix` package.                                   
b) Using `epitab()` in the `epitools` package.      

**Again be careful that the data is entered in the correct format of rows and columns required by each package. The required structure varies between packages and can be checked with `help(package="XXX")`. Using the wrong structure would produce incorrect results. **


```r
# Using  `epi2X2()` in the `epibasix` package

#cases should be entered as column one and controls as column two.
#treatment as columns and outcome as row -> need to transpose the original 2X2 table
summary(epi2x2(t(tab))) # note need to transpose the rows
```

```
## Epidemiological 2x2 Table Analysis 
##  
## Input Matrix: 
##        
##         women men
##   dead    104 111
##   alive    96 189
## 
## Pearson Chi-Squared Statistic (Includes Yates' Continuity Correction): NA
## Associated p.value for H0: There is no association between exposure and outcome vs. HA: There is an association : NA
## p.value using Fisher's Exact Test (1 DF) : 0.001
##  
## Estimate of Odds Ratio: 1.845
## 95% Confidence Limits for true Odds Ratio are: [1.283, 2.652]
##  
## Estimate of Relative Risk (Cohort, Col1): 1.436
## 95% Confidence Limits for true Relative Risk are: [1.16, 1.778]
##  
## Estimate of Risk Difference (p1 - p2) in Cohort Studies: 0.147
## 95% Confidence Limits for Risk Difference: [0.056, 0.237]
##  
## Estimate of Risk Difference (p1 - p2) in Case Control Studies: 0.15
## 95% Confidence Limits for Risk Difference: [0.059, 0.241]
##  
## Note: Above Confidence Intervals employ a continuity correction.
```

```r
# Using `epitab()` in the `epitools` package.
#rows and columns need to be reversed/transposed
epitab(tab, method = "riskratio", rev = "both")
```

```
## $tab
##        
##         alive   p0 dead   p1 riskratio lower  upper   p.value
##   men     189 0.63  111 0.37    1.0000    NA     NA        NA
##   women    96 0.48  104 0.52    1.4054 1.152 1.7146 0.0012243
## 
## $measure
## [1] "wald"
## 
## $conf.level
## [1] 0.95
## 
## $pvalue
## [1] "fisher.exact"
```

```r
epitab(tab, method = "oddsratio", rev = "both")
```

```
## $tab
##        
##         alive      p0 dead      p1 oddsratio  lower  upper   p.value
##   men     189 0.66316  111 0.51628    1.0000     NA     NA        NA
##   women    96 0.33684  104 0.48372    1.8446 1.2829 2.6523 0.0012243
## 
## $measure
## [1] "wald"
## 
## $conf.level
## [1] 0.95
## 
## $pvalue
## [1] "fisher.exact"
```
Thus it can be seen that the risk ratio and odds ratios as calculated with 3 different functions from 3 different `R` packages produce the same results.
