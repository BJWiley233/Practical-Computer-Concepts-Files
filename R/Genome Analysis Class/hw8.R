exons <- read.table("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_8/hs_5q31_exons.bed", sep = "\t")

library(dplyr)
names(exons)

exons %>% distinct(V2, V3)
exons %>% distinct(V4)

exons %>% group_by(V2, V3) %>% summarise(n = n()) %>% arrange(desc(n))

exons %>% distinct(V2, V3) %>% tally()
542+4296


part_1a <- read.table("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_8/part_1a.bed", sep = "\t")
part_1a %>% distinct(V2, V3) %>% tally()
  
part_1b <- read.table("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_8/part_1b.bed", sep = "\t")
part_1b %>% distinct(V2, V3) %>% tally()


part_1c <- read.table("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_8/part_1c.bed", sep = "\t")
part_1c %>% distinct(V2, V3) %>% tally()

part_1d <- read.table("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_8/part_1d.bed", sep = "\t")
part_1d %>% distinct(V2, V3) %>% tally()