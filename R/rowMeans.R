A <- read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
B <- read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
C <- read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
D <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
E <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
F <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
G <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
H <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
I <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
L <- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
rowMeans(A[1, -ncol(A)])+
rowMeans(B[1, -ncol(B)])+
rowMeans(C[1, -ncol(C)])+
rowMeans(D[1, -ncol(D)])+
rowMeans(E[1, -ncol(E)])+
rowMeans(F[1, -ncol(F)])+
rowMeans(G[1, -ncol(G)])+
rowMeans(H[1, -ncol(H)])+
rowMeans(I[1, -ncol(I)])+

train <- read.table("UCI HAR Dataset/train/X_train.txt")