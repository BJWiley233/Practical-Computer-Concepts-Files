library(e1071)
install.packages("sloop")

e1071::svm.formula

set.seed(1)
x=matrix(rnorm(20*2), ncol=2)
y=c(rep(-1,10), rep(1,10))
x[y==1,]=x[y==1,] + 1

plot(x, col=(3-y))
dat=data.frame(x=x, y=as.factor(y))
svmfit=svm(y???., data=dat, kernel="linear", cost=10,
           scale=FALSE)
x <- svm()
sloop::s3_dispatch(print(svmfit))
