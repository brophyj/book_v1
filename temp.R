library (BayesFactor)

data(sleep)

## Compute difference scores
diffScores = sleep$extra[1:10] - sleep$extra[11:20]

## Traditional two-tailed t test
t.test(diffScores)

dead <- c(938,1238)
alive <- c(18760, 26340)
prop.test(dead,alive)

bf = proportionBF(y = 15, N = 25, p = .5)
bf

mat <- matrix(c(50,48,21,41), nrow=2, byrow = TRUE)
mat
contingencyTableBF(mat, sampleType = "indepMulti", fixedMargin = "cols")


mat <- matrix(c(938,1238,18760,26340), nrow=2, byrow = TRUE,
              dimnames = list(Outcome = c("Dead", "Alive"), Year = c("2005", "2008")))
mat
contingencyTableBF(mat, sampleType = "indepMulti", fixedMargin = "cols")

chisq.test(mat)

prop.test(mat[1,],mat[2,]+mat[1,])



min_bf <- function(z){
  bf <- exp((-z^2)/2)
  paste("Minimum Bayes Factor = ", round(bf,2), "so there is ", round(1/bf,2), "times more evidence supporting the alternative hypothesis of the observed data than for the null of no benefit")
}

min_bf(1.96)

post_prob <- function(prior,bf){
  odds <- prior/(1-prior)
  post_odds <- odds * bf
  post_prob <- post_odds / (1+ post_odds)
  paste("If Bayes Factor = ", round(bf,2), "and the prior probability = ", round(100*prior,2), "%, the posterior probability = ",round(100*post_prob,0), "%")
}


post_prob(.5,.15)

df <- data.frame (prior_prob=seq(0,.99, length.out = 99), post = seq(0,1, length.out = 99))

t <- rerun(4, df) %>%
  map_df( ~ tibble(.), .id = "dist", x.x ="x") %>% 
  mutate(bf = ifelse(dist == "1", 1/5,
                       ifelse(dist == "2", 1/10,
                              ifelse(dist == "3", 1/20,
                                     ifelse(dist == "4", 1/100, "NA"))))) %>% 
  mutate(bf=as.numeric(bf), prior_odds = prior_prob/(1-prior_prob)) %>% 
  mutate(post_odds = bf * prior_odds) %>% 
  mutate(post_prob = post_odds / (1+ post_odds)) 

ggplot(t, aes(prior_prob,post_prob,color = as.factor(bf))) +
  geom_line() +
  labs(x="Prior probability Ho true", y="Posterior probability Ho true") +
  labs(color='Bayes factor') +
  geom_hline(yintercept = 0.05, color="blue") +
  annotate("text", label ="Blue horizontal line = posterior probability Ho = 0.05", x=0, y=.1, hjust=0) +
  ggtitle("Posterior probability Ho is true", subtitle = "Varying levels of Bayes factors from weak (0.2) to strong (0.01))") +
  theme_bw()
