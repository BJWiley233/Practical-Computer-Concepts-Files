list.of.packages <- c("ggplot2", "reshape2", "readr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(ggplot2)
library(reshape2)
library(readr)

##########################################
# Naive
NSM = function(Text, P, printShift = F) {
    n = nchar(Text)
    m = nchar(P)
    for (s in 1:(n-m+1)) {
        # match = TRUE
        # for (i in 1:m) {
        #     if(substr(P, i, i) != substr(Text, s-1+i, s-1+i)) {
        #         match = FALSE
        #         break
        #     }
        # }
        # if (match) {
        #     if (printShift)
        #         print(paste('NSM Pattern occurs with shift' , s-1))
        # }
        if (P == substr(Text, s, s+m-1)) {
            if (printShift)
                print(paste('NSM Pattern occurs with shift' , s-1))
        }
    }
    
}


##########################################
# Automaton
getk = function(pattern, q, a, m) {
    if (q < m && substr(pattern, q+1, q+1) == a) {
        return(q + 1)
    }
    k = min(m, q+1)
    for (i in k:0) {
        if (endsWith(paste0(substr(pattern, 1, q), a), substr(pattern, 1, i))) {
            return(i)
        }
    }
}

getTF = function(P, alphabet) {
    m = nchar(P)
    d = length(alphabet)
    table = setNames(data.frame(matrix(ncol = d, nrow = m+1)), alphabet)
    rownames(table) = c(0:m)
    for (q in 0:m) {
        for (a in alphabet) {
            k = getk(pattern = P, q, a, m)
            table[as.character(q),a] = k
        }
    }
    
    return(table)
}

automaton = function(Text, P, alphabet, printShift = F) {
    n = nchar(Text)
    m = nchar(P)
    transition_func = getTF(P, alphabet)
    q = 0
    for (i in 1:n) {
        q = transition_func[as.character(q), substr(Text, i,i)]
        if (q == m) {
            if (printShift)
                print(paste('Pattern occurs with shift' , i - m))
        }
    }
}


##########################################
# Knuth Morris Pratt
prefix_function = function(P) {
    m = nchar(P)
    pi = c()
    pi[1] = 0
    k = 0
    for (q in 2:m) {
        while (k > 0 && substr(P, k+1, k+1) != substr(P, q, q)) {
            k = pi[k]
        }
        if (substr(P, k+1, k+1) == substr(P, q, q)) {
            k = k + 1
        }
    pi[q] = k
    }

    return(pi)
}

KMP = function(Text, P, printShift = F) {
    n = nchar(Text)
    m = nchar(P)
    pi = prefix_function(P)
    q = 0 
    for (i in 1:n) {
        while (q > 0 && substr(P, q+1, q+1) != substr(Text, i, i)) {
            q = pi[q]
        }
        if (substr(P, q+1, q+1) == substr(Text, i, i)) {
            q = q + 1
        }
        if (q == m) {
            if (printShift)
                print(paste('KMP Pattern occurs with shift' , i-m))
            q = pi[q]
        }
    }
}

##########################################
# Ex from book
alphabet = letters[1:3]
Text = 'abababacaba'
P = 'ababaca'
NSM(Text, P, TRUE)
automaton(Text, P, alphabet, TRUE)
KMP(Text, P, TRUE)




##########################################
# Tests

Text1 = 'aaababaabaababaab'
P1 = 'ab'
alphabet1 = letters[1:2]


P2 = 'agguragu'
alphabet2 = c('a', 'c', 'g', 'u', 'y', 'r', 'n')
Text2 = paste(replicate(50, P2), collapse = '')
#Text2 = paste(c(sample(alphabet2, size = 36000, replace = T), P2, P2, P2,
#        sample(alphabet2, size = 500, replace = T)), collapse = '')


alphabet3 = c("I","L","V","F","M","C","A","G","P","T","S","Y","W","Q","N","H","E","D","K","R")
P3 = paste(sample(alphabet3, size = 8, replace = T), collapse = '')
Text3 = paste(replicate(150, P3), collapse = '')
#Text3 = paste(c(sample(alphabet3, size = 80000, replace = T), P3, P3,
#                sample(alphabet3, size = 250, replace = T), P3, P3), collapse = '')

vec = 1:256
alphabet4 = intToUtf8(vec, TRUE)
P4 = 'children taking part'
Text4 <- read_file("~/3sonnets.txt")
Text4 <- paste(replicate(15, Text4), collapse = '')


alphabets = list(alphabet1, alphabet2, alphabet3, alphabet4)
patterns = list(P1, P2, P3, P4)
texts = list(Text1, Text2, Text3, Text4)


timeNaive = c()
timeAuto = c()
timeKPM = c()
num_times = 50
printShift = F

for (i in 1:4) {
    time1Naive = Sys.time()
    for (times in 1:num_times) {
        NSM(Text = texts[[i]], P = patterns[[i]], printShift)
    }
    time2Naive = Sys.time()
    timeNaive[i] = difftime(time2Naive, time1Naive, units = "secs") * 1000
    
    time1Auto = Sys.time()
    for (times in 1:num_times) {
        automaton(Text = texts[[i]], P = patterns[[i]], alphabet = alphabets[[i]], printShift)
    }
    time2Auto = Sys.time()
    timeAuto[i] = difftime(time2Auto, time1Auto, units = "secs") * 1000
    
    time1KMP = Sys.time()
    for (times in 1:num_times) {
        KMP(Text = texts[[i]], P = patterns[[i]], printShift)
    }
    time2KMP = Sys.time()
    timeKPM[i] = difftime(time2KMP, time1KMP, units = "secs") * 1000
    
}

timeNaive = log2(timeNaive)
timeAuto = log2(timeAuto)
timeKPM = log2(timeKPM)



lengths = c(paste0(nchar(P1), ':', length(alphabet1), ':', nchar(Text1)),
            paste0(nchar(P2), ':', length(alphabet2), ':', nchar(Text2)),
            paste0(nchar(P3), ':', length(alphabet3), ':', nchar(Text3)),
            paste0(nchar(P4), ':', length(alphabet4), ':', nchar(Text4)))
df = setNames(data.frame(matrix(ncol = 4, nrow = 2)), 
              lengths)
df[1,] = timeNaive
df[2,] = timeAuto
df[3,] = timeKPM
rownames(df) = c("Naive", "Automaton", "KPM")

df_test = melt(as.matrix(df), varnames=c("Algorithm", "Pat:Alpha:Text Length"))


myplot <- ggplot(df_test, aes(x=`Pat:Alpha:Text Length`, y=value, colour=Algorithm, group=Algorithm)) + 
     geom_line(size = 1) + ylab(expression(paste('Time log'[2], ' milliseconds')))
myplot
png("myplot.png")
print(myplot)
dev.off()
