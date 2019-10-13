
n=20
L=c(2,4,8,6)

print_breaks = function(L, break_, i, j) {
    if (j-i >= 2) {
        k = break_[i, j]
        print(paste0("Break at ", L[k]))
        print_breaks(L, break_, i, k)
        print_breaks(L, break_, k, j)
    }
}
    
    
break_string = function(n, L) {
    L = append(L, 0, after=0)
    L = append(L, n, after=length(x))
    L = sort(L)
    m = length(L)
    cost = break_ = array(0, c(m,m))
    for (i in 1:(m-1)) {
        cost[1,1] = cost[i, i+1] = 0
    }
    cost[m,m] = 0
    for (len in 3:m) {
        for (i in 1:(m-len+1)) {
            j = i + len - 1
            print(paste0('i=',i,' j=', j))
            cost[i, j] = Inf
            for (k in (i+1):(j-1)) {
                print(paste0('i=',i,' j=', j, ' k=', k))
                if (cost[i, k] + cost[k, j] < cost[i,j]) {
                    cost[i,j] = cost[i, k] + cost[k, j]
                    break_[i, j] = k
                }
            }
            cost[i, j] = cost[i, j] + L[j] - L[i]
        }
    }
    print(paste0("Min cost is ", cost[1, m]))
    print_breaks(L, break_, 1, m)
}

break_string(n, L)
