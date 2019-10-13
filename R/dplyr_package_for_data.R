# installs dplyr package if you don't have it
if (!"dplyr" %in% installed.packages()) install.packages("dplyr")

# installs dowloader package if you don't have it
if (!"dowloader" %in% installed.packages()) install.packages("dowloader")

# load both packages
library(downloader)
library(dplyr)

# stole this from http://genomicsclass.github.io/book/pages/dplyr_tutorial.html
url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"
filename <- "msleep_ggplot2.csv"
if (!file.exists(filename)) download(url,filename)
msleep <- read.csv("msleep_ggplot2.csv")
head(msleep)
names(msleep)

# This is easier way to filter stuff using the dpylr package.  Here are help pages.
?dplyr::select
?dplyr::filter
?dplyr::mutate
?dplyr::arrange
?dplyr::summarise
?dplyr::group_by

# You just use your data in first line and then the "%>%" after each function
msleep %>%
        select(genus, order, conservation, brainwt) %>%
        filter(brainwt > .1) %>%
        mutate(mean_brain_wt_above_.1 = mean(brainwt), 
               difference_from_mean_above_.1 = brainwt - mean_brain_wt_above_.1,
               diff_from_all_weight_means = brainwt - mean(msleep[complete.cases(msleep$brainwt), ]$brainwt)
               ) %>%
        arrange(desc(brainwt))
 

msleep %>%
        select(brainwt) %>%
        filter(brainwt > .1) %>%
        summarise(average_wt = mean(brainwt))


msleep %>% 
        summarise(avg_sleep = mean(sleep_total), 
                  min_sleep = min(sleep_total),
                  max_sleep = max(sleep_total),
                  total = n())

# lets get the average body weight or the type of vore they are
msleep %>%
        group_by(vore) %>%
        summarise(mean(bodywt))
        