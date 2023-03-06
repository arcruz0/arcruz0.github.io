# Code from the "Speedy R: loops, parallelization, and the cloud" workshop
# Andrés Cruz - <andres.cruz@utexas.edu>
# Materials: https://bit.ly/speedyr


## For loops (I) ----

for (i in 1:5){
  print(i)
}

set.seed(512)
for (i in 1:1000){
  m <- mtcars[sample(1:nrow(mtcars), size = nrow(mtcars), replace = T),]
  print(mean(m$mpg))
}


## For loops (II) – store results ----

set.seed(512)
bootstrapped_means <- vector(mode = "numeric", length = 1000)
for (i in 1:1000){
  m <- mtcars[sample(1:nrow(mtcars), size = nrow(mtcars), replace = T),]
  bootstrapped_means[[i]] <- mean(m$mpg)
}

hist(bootstrapped_means)


## Functional loops (I) ----

set.seed(512)
l_bootstrapped_means <- lapply(
  1:1000, 
  function(x){
    m <- mtcars[sample(1:nrow(mtcars), size = nrow(mtcars), replace = T),]
    return(mean(m$mpg))
  }
)


## Functional loops (II) ----

# generate 100 .csv datasets in the data/ folder
dir.create("data/")
for (i in 1:100){write.csv(mtcars, paste("data/dataset", i, ".csv", sep = ""))}

# recover the .csv files' filepaths
my_files <- list.files("data/", full.names = T)
sample(my_files, size = 3)

# load them into one unified dataset, with a column for the filepaths
l_datasets <- lapply(my_files, function(x){
  one_dataset <- read.csv(x)
  one_dataset$filepath <- x
  return(one_dataset)
})
unified_dataset <- do.call(rbind, l_datasets)

unified_dataset[c(1, nrow(unified_dataset)), c("X", "mpg", "filepath")]


## Loop limitations (I) ----

v1 <- rnorm(1000000); v2 <- rnorm(1000000)

system.time(v1 + v2)

system.time(lapply(seq_along(v1), function(i){sum(v1[i], v2[i])}))

lapply(list(0, 1, "apple"), function(x){log(x + 1)})

lapply(list(0, 1, "apple"), function(x){try(log(x + 1))})


## Functional loops in parallel (I) ----

parallel::detectCores() # ↓ this is the output for my laptop ↓

system.time(lapply(1:8, function(x){Sys.sleep(1)}))

library(future.apply)
plan(multisession, workers = 8)
system.time(future_lapply(1:8, function(x){Sys.sleep(1)}))


## Functional loops in parallel (II) ----

set.seed(512)
system.time(
  l_bootstrapped_means <- lapply(1:1000000, function(x){
      m <- mtcars[sample(1:nrow(mtcars), size = nrow(mtcars), replace = T),]
      return(mean(m$mpg))
  })
)

library(future.apply); plan(multisession, workers = 8)
system.time(
  l_bootstrapped_means <- future_lapply(1:1000000, function(x){
      m <- mtcars[sample(1:nrow(mtcars), size = nrow(mtcars), replace = T),]
      return(mean(m$mpg))
  }, future.seed = 512)
)
