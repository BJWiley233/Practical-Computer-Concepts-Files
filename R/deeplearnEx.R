install.packages("rpud")
install.packages("h2o")
library(h2o)
?h2o.init
h2o.removeAll()
h2o.init()
file <- h2o.importFile("pima-indians-diabetes.csv",header=TRUE, sep=",")
splits <- h2o.splitFrame(file, 0.75, seed=33)
splits[[1]]
splits[[1]][,9]<- as.factor(splits[[1]][,9])
splits[[2]][,9]<- as.factor(splits[[2]][,9])
splits[[2]]

dl1<-h2o.deeplearning(x=1:8, 
                      y="1",
                      activation="RectifierWithDropout",
                      training_frame = splits[[1]], 
                      hidden=c(190,63,21,7),
                      epochs=50,
                      input_dropout_ratio=0.1
                      )

pred1=h2o.predict(dl1,splits[[2]])
summary(pred1)
