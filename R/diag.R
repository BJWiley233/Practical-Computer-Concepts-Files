c <- matrix(c(14/3, -5/3, 1,
              17/3, -8/3, 1,
              1, -1, 2), nrow = 3, byrow = T)
c
diag(c)
v <- eigen(c)$vectors 
solve(v)%*%c%*%v
