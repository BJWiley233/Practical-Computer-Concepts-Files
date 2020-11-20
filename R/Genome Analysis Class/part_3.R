snps <- read.table("part3.txt", comment.char = "", header=T, sep = "\t")
cat(paste(snps$name), sep = ", ")

cacna1a <- read.table("/home/coyote/Downloads/clinvar_result.txt", header = T, sep = "\t", na.strings = " ")

read.table("/home/coyote/Downloads/test.txt", sep = "\t")


length(grep("Epileptic encephalopathy, early infantile, 42", cacna1a$Condition.s.))
length(grep("Episodic ataxia type 2", cacna1a$Condition.s.))

length(grep("Epileptic", cacna1a$Condition.s.))
length(grep("Episodic ataxia type 2", cacna1a$Condition.s.))



eiee42 <- cacna1a[grep("Epileptic encephalopathy, early infantile, 42", cacna1a$Condition.s.), ]
eat2 <- cacna1a[grep("Episodic ataxia type 2", cacna1a$Condition.s.), ]

nrow(eiee42)
614/1387
length(grep("Episodic ataxia type 2", eiee42$Condition.s.))
length(grep("Epileptic encephalopathy, early infantile, 42", eat2$Condition.s.))
  