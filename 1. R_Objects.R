#========================================================
#Objects of R
#========================================================
#vectors
#========================================================

age <- c(60, 43, 72, 35, 47)
age

BMI <- c(28, 32, 21, 27, 35)
BMI

bp <- c(124, 145, 127, 133, 140)
bp

is.healthy <- c(TRUE, TRUE, FALSE, TRUE, FALSE)
is.healthy

sex <- c("male", "female", "female", "male", "female")
sex

#========================================================
#Matrices
#========================================================
#cbind = bind columns
mat <- cbind(age, BMI, bp)
mat

#========================================================
#Dataframes
#========================================================
df <- data.frame(age, sex, is.healthy, BMI, bp)
df

#========================================================
#list
lst <- list(data = df,
            names = c("Bob", "Mary", "Jenny", "Clark", "Sara"),
            data_managers = c("John", "Mary"))
lst
