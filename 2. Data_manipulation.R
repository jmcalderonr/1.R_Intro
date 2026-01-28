#========================================================
#Data manipulation
#https://bookdown.org/drki_musa/dataanalysis/data-wrangling.html#datasets
#========================================================
#install.packages("tidyverse", dependencies = TRUE)
#install.packages("readxl")
library(tidyverse)
library(readxl)

#========================================================
#Importing Data
#========================================================
stroke <- read_csv("stroke_data.csv")
glimpse(stroke)
stroke |> head()

pep <- read_excel("peptic_ulcer.xlsx", sheet = 1)
glimpse(pep)
pep |> head(n = 5)

#========================================================
#Select variables using dplyr::select()
#========================================================
pep2 <- pep |> 
  select(age, systolic, diastolic, perforation, twc,
         gender, vomiting, malena, ASA, outcome)
glimpse(pep2)

# In base r:
#Select only specific columns
#pep2 <- pep[, c("age", "systolic", "diastolic", "perforation", "twc",
#                "gender", "vomiting", "malena", "ASA", "outcome")]
#str(pep2)

#========================================================
#Generate new variable using mutate()
#========================================================
#create new column from others
pep2 <- pep2 |> 
  mutate(pulse_pressure = systolic - diastolic)

# In base r:
#pep2$pulse_pressure <- pep2$systolic - pep2$diastolic

pep2 |>
  select(systolic, diastolic, pulse_pressure ) |>  
  head()

#change the format in a column
stroke <- stroke %>% 
  mutate(doa = dmy(doa), dod = dmy(dod))
stroke

# In base r:
#stroke$doa <- as.Date(stroke$doa, format = "%d-%m-%Y")
#stroke$dod <- as.Date(stroke$dod, format = "%d-%m-%Y")

#========================================================
#Rename variable using rename()
#========================================================
pep2 <- pep2  |> rename(sex = gender,
                        asa = ASA)

# In base r:
#names(pep2)[names(pep2) == "gender"] <- "sex"
#names(pep2)[names(pep2) == "ASA"]    <- "asa"

#========================================================
#Sorting data using arrange()
#========================================================
stroke |> arrange(doa)
stroke |> arrange(desc(doa))

# In base r:
#stroke[order(stroke$doa), ]
#stroke[order(stroke$doa, decreasing = TRUE), ]

#========================================================
#Select observation using filter()
#========================================================
stroke_m_7 <- stroke |>  
  filter(sex == 'male', gcs >= 7) #gcs: Glasgow Coma Scale
stroke_m_7 |> head()

#In base r:
#stroke_m_7 <- stroke[stroke$sex == "male" & stroke$gcs >= 7, ]
#head(stroke_m_7)

stroke_high_BP <- stroke |>  
  filter(sbp > 130 | dbp > 90) #systolic and diastolic blood pressure
stroke_high_BP |> head()

#In base r:
#stroke_high_BP <- stroke[stroke$sbp > 130 | stroke$dbp > 90, ]
#head(stroke_high_BP)

#========================================================
#Group data and get summary statistics
#========================================================
#summarize without group
stroke |>  
  summarise(meansbp = mean(sbp, na.rm = TRUE), 
            meandbp  = mean(dbp, na.rm = TRUE),
            meangcs = mean(gcs, na.rm = TRUE))

#summarize with group
stroke_sex <- stroke |> group_by(sex)
stroke_sex |>  
  summarise(meansbp = mean(sbp, na.rm = TRUE), 
            meandbp  = mean(dbp, na.rm = TRUE),
            meangcs = mean(gcs, na.rm = TRUE))

#In base r:
#tapply(stroke$sbp, stroke$sex, mean, na.rm = TRUE)
#tapply(stroke$dbp, stroke$sex, mean, na.rm = TRUE)
#tapply(stroke$gcs, stroke$sex, mean, na.rm = TRUE)

#Caution: compare with stroke
glimpse(stroke)
glimpse(stroke_sex)

#Two ways to get the same
pep2 |> group_by(sex) |> count(outcome)
pep2 |> count(sex, outcome)

#In base r:
#table(pep2$sex, pep2$outcome)

#========================================================
#distinct()
#========================================================
pep2 |> distinct(sex, age)

#In base r:
#unique(pep2[, c("sex", "age")])

#========================================================
#count
#========================================================
pep2 |> count(sex, age, sort = TRUE)

#In base r:
#df_counts <- as.data.frame(table(pep2$sex, pep2$age))
#names(df_counts) <- c("sex", "age", "n")
#df_counts <- df_counts[df_counts$n > 0, ]
#df_counts <- df_counts[order(-df_counts$n), ]
#df_counts

#========================================================
#Using the pipe
#========================================================
#In several steps
pep3 <- pep2 |> filter(sex == "male", diastolic >= 60, systolic >= 80) 
pep3
pep3 <- pep3 |> select(age, systolic, diastolic, perforation, outcome) 
pep3
pep3 <- pep3 |> group_by(outcome) 
pep3
pep3 <- pep3 |> summarize(mean_sbp = mean(systolic, na.rm = TRUE), 
                          mean_dbp = mean(diastolic, na.rm = TRUE),
                          mean_perf = mean(perforation, na.rm = TRUE), freq = n())
pep3

#In one step
pep2 |> filter(sex == "male", diastolic >= 60, systolic >= 80) |>  
  select(age, systolic, diastolic, perforation, outcome) |> 
  group_by(outcome) |> 
  summarize(mean_sbp = mean(systolic, na.rm = TRUE), 
            mean_dbp = mean(diastolic, na.rm = TRUE),
            mean_perf = mean(perforation, na.rm = TRUE),
            freq = n())
