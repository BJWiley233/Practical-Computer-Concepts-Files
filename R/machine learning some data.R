
library(readstata13)
mydata <- read.dta13(file = "hsbdemo.dta", convert.factors = TRUE, nonint.factors = TRUE)

class(mydata$prog)

library(caret)
set.seed(7267166)
trainIndex=createDataPartition(mydata$prog, p=0.7)$Resample1
train=mydata[trainIndex, ]
test=mydata[-trainIndex, ]

## check the balance
print(table(mydata$prog))
print(table(train$prog))

library(e1071)
'''test <- read_dta(file = "hsbdemo.dta")
?read_dta'''
NBclassfier=naiveBayes(prog~science+socst+ses, data=train)
print(NBclassfier)

printALL=function(model){
        trainPred=predict(model, newdata = train, type = "class")
        trainTable=table(train$prog, trainPred)
        testPred=predict(NBclassfier, newdata=test, type="class")
        testTable=table(test$prog, testPred)
        trainAcc=(trainTable[1,1]+trainTable[2,2]+trainTable[3,3])/sum(trainTable)
        testAcc=(testTable[1,1]+testTable[2,2]+testTable[3,3])/sum(testTable)
        message("Contingency Table for Training Data")
        print(trainTable)
        message("Contingency Table for Test Data")
        print(testTable)
        message("Accuracy")
        print(round(cbind(trainAccuracy=trainAcc, testAccuracy=testAcc),3))
}
printALL(NBclassfier)