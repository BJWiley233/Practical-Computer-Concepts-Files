install.packages("e1071")
library(e1071)
data("Titanic")
Titanic_df <- as.data.frame(Titanic)
repeating_seq <- rep.int(seq_len(nrow(Titanic_df)), Titanic_df$Freq)
Titanic_dataset <- Titanic_df[repeating_seq,]
Titanic_dataset$Freq=NULL

NBM <- naiveBayes(Survived ~ ., data = Titanic_dataset)
NB_Predictions=predict(NBM,Titanic_dataset)
table(NB_Predictions, Titanic_dataset$Survived)

NBM <- naiveBayes(Survived ~ Class + Sex + Age, data = Titanic_dataset)
NB_Predictions=predict(NBM,Titanic_dataset)
table(NB_Predictions, Titanic_dataset$Survived)

library(tidyverse)
start_time_tidy = proc.time()
housing.tidy <- read.csv("C:/Users/bjwil/Downloads/housing.csv/housing.csv")
colnames(housing.tidy)
housing.tidy %>% gather(longitude:median_house_value, key = "variable", value = "value") %>%
        ggplot(aes(x = value)) +
        geom_histogram(bins = 30) + facet_wrap(~ variable, scales = 'free_x')
housing.tidy %>%
        gather(longitude:median_house_value, key = "variable", value = "value")
housing.tidy %>% ggplot(aes(x = ocean_proximity)) +
        geom_bar()
summary(housing.tidy)
colnames(housing.tidy)[colSums(is.na(housing.tidy)) > 0]
housing.tidy <- housing.tidy %>% mutate(total_bedrooms = ifelse(is.na(total_bedrooms),
                                                median(total_bedrooms, na.rm = T),
                                                total_bedrooms),
                                        mean_bedrooms = total_bedrooms/households,
                                        mean_rooms = total_rooms/households) %>%
                select(-c(total_rooms, total_bedrooms))                        
head(housing.tidy)

cat_housing.tidy = housing.tidy %>%
        model.matrix( ~ ocean_proximity -1, data = .) %>%
        as.tibble()
colSums(cat_housing.tidy)
plyr::count(housing.tidy, 'ocean_proximity')

names(cat_housing.tidy) <- names(cat_housing.tidy) %>%
        str_split('ocean_proximity') %>%
        map_chr(function(x) x[2])

#s = 'ocean_proximity<1H OCEAN'
#strsplit(s, '(?<=^ocean_proximity)', perl = T)

#t = 'AWCallibration#NoneBino-3'
#strsplit(t, "(?<=^..)(?=[A-Z])|#None|-", perl = T)
summary(housing.tidy)
cleaned_housing.tidy = housing.tidy %>% 
        select(-c(ocean_proximity, median_house_value)) %>%
        scale() %>% as.tibble() %>%
        bind_cols(cat_housing.tidy) %>%
        add_column(median_house_value = housing.tidy$median_house_value)

#cleaned_housing.tidy <- dplyr::select(cleaned_housing.tidy, -median_house_value, everything())

set.seed(1738)
sample_v <- sample.int(n = nrow(cleaned_housing.tidy), size = floor(.8*nrow(cleaned_housing.tidy)))
train<- cleaned_housing.tidy[sample_v,]
test <- cleaned_housing.tidy[-sample_v,]
head(train)

#library(boot)
nrow(train) + nrow(test) == nrow(cleaned_housing.tidy)
?boot::cv.glm
glm_house <- glm(median_house_value~median_income+mean_rooms+population, 
       data = cleaned_housing.tidy)
k_fold_cv_error <- cv.glm(cleaned_housing.tidy, glm_house, K=5)
k_fold_cv_error$delta
glm_cv_rmse <- sqrt(k_fold_cv_error$delta)[1]
glm_cv_rmse
glm_house$coefficients
library(randomForest)
rfNews()
?randomForest
options(dplyr.width = Inf)
