## Goal: Merge quarterly physician and patient data sets
## Match each prescription to doctor's characteristics.

  library(plyr)
  library(dplyr)
  library(zoo)
  library(stringr)
  library(tidyr)

## DOCTOR DATA
## Open PMD.Doctor.Data files by Quarter
  PMD.Doctor.Data_1Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Doctor Data_1Q.csv", na.strings="")
  PMD.Doctor.Data_2Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Doctor Data_2Q.csv", na.strings="")
  PMD.Doctor.Data_3Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Doctor Data_3Q.csv", na.strings="")
  PMD.Doctor.Data_4Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Doctor Data_4Q.csv", na.strings="")

## Rename variables in Q2, Q3, Q4 to ensure uniformity of variable names (Follow Q1's variables)
  PMD.Doctor.Data_2Q <- plyr::rename(PMD.Doctor.Data_2Q, c(
                                "Years.of.Experience"="Year.Of.Practice", 
                                "Number.of.Patient"="Number.of.patients"
                                                          ))

  PMD.Doctor.Data_3Q <- plyr::rename(PMD.Doctor.Data_3Q, c(
                                "Age"="Year.Of.Practice", 
                                "PTType"= "Practice.Type", 
                                "PracSize" = "Practice.Size", 
                                "NoOfPat"= "Number.of.patients"
                                                          ))     

  PMD.Doctor.Data_4Q <- plyr::rename(PMD.Doctor.Data_4Q, c(
                                "Years.of.Practice" = "Year.Of.Practice", 
                                "Number.of.Patient" = "Number.of.patients"
                                                          ))

## Horizontally merge (Append) PMD.Doctor.Data Q1, Q2, Q3, Q4 dataframes
  
  PMD.Doctor.Data_Q <- rbind(PMD.Doctor.Data_1Q, 
                              PMD.Doctor.Data_2Q, 
                              PMD.Doctor.Data_3Q, 
                              PMD.Doctor.Data_4Q)

## Rename PMD.Doctor.Data_Q variables for precision
  PMD.Doctor.Data_Q <- plyr::rename(PMD.Doctor.Data_Q, c(
                              "DoctorNo" = "Doctor.No",
                              "Sex" = "Doctor.Sex",
                              "Specialty" = "Doctor.Specialty",
                              "Practice.Type" = "Doctor.Practice.Type",
                              "Practice.Size" = "Doctor.Practice.Size",
                              "Number.of.patients" = "Doctor.Number.of.Patients",
                              "Year.Of.Practice" = "Doctor.Yrs.of.Practice",
                              "Period" = "Quarter"
                                                      ))

## Convert Integer type variables into Factor type
  PMD.Doctor.Data_Q[,6:10]  <- lapply(PMD.Doctor.Data_Q[,6:10], factor)
  PMD.Doctor.Data_Q[,12:13] <- lapply(PMD.Doctor.Data_Q[,12:13], factor)

## Revalue variables into qualitative labels
  PMD.Doctor.Data_Q$Doctor.Sex <- revalue(PMD.Doctor.Data_Q$Doctor.Sex, c(
                                          "1"="Male", 
                                          "2"="Female", 
                                          "9"="Unspecified"
                                                                              ))

  PMD.Doctor.Data_Q$Doctor.Specialty <- revalue(PMD.Doctor.Data_Q$Doctor.Specialty, c(
                                          "1"="GP", 
                                          "2"="IM", 
                                          "3"="PED", 
                                          "6"="RHEUMA", 
                                          "7"="GASTRO", 
                                          "8"="CARDIO",
                                          "9"="SUR", 
                                          "10"="DERMA", 
                                          "11"="ENDO", 
                                          "12"="OPHTHA", 
                                          "13"="OBYGYN", 
                                          "16"="ENT", 
                                          "20"="PULMO", 
                                          "21"="NEURO", 
                                          "22"="PSYCH", 
                                          "25"="DIAB", 
                                          "37"="NEPHRO", 
                                          "40"="ONCO", 
                                          "69"="ORTHOSUR", 
                                          "78"="UROSUR"
                                                                    ))

  PMD.Doctor.Data_Q$Doctor.Practice.Type <- revalue(PMD.Doctor.Data_Q$Doctor.Practice.Type, c(
                                          "1"="Private Clinic Only", 
                                          "2"="Private Hospital Only",
                                          "3"="Govt Hospital Only", 
                                          "4"="Private Clinic and Private Hospital",
                                          "5"="Private Clinic and Govt Hospital"
                                                                              ))

  PMD.Doctor.Data_Q$Region <- revalue(PMD.Doctor.Data_Q$Region, c(
                                          "1"="NCR",
                                          "2"="Luz", 
                                          "3"="Vis", 
                                          "4"="Min"
                                                                ))

  PMD.Doctor.Data_Q$Doctor.Practice.Size <- revalue(PMD.Doctor.Data_Q$Doctor.Practice.Size, c(
                                          "1"="0 to 9", 
                                          "2"="10 to 15", 
                                          "3"="15 to 20",
                                          "4" ="More than 20"
                                                                              ))

  PMD.Doctor.Data_Q$Country <- revalue(PMD.Doctor.Data_Q$Country, c("50"="PH"))

## Drop duplicates in PMD.Doctor.Data_Q so each row will have unique Doctor.No 
  PMD.Doctor.Data_Q_unique <- PMD.Doctor.Data_Q %>% distinct(Doctor.No, .keep_all = TRUE)
  ## 768 unique doctors in the sample

## Delete unnecessary data sets for faster runs
  rm(PMD.Doctor.Data_1Q, 
     PMD.Doctor.Data_2Q, 
     PMD.Doctor.Data_3Q, 
     PMD.Doctor.Data_4Q, 
     PMD.Doctor.Data_Q)
  
##PATIENT DATA
## Open Patient data files per quarter
  PMD.Patient.Data_1Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Patient Data_1Q.csv", na.strings="")
  PMD.Patient.Data_2Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Patient Data_2Q.csv", na.strings="")
  PMD.Patient.Data_3Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Patient Data_3Q.csv", na.strings="")
  PMD.Patient.Data_4Q <- read.csv("~/Dropbox/IMS data/Edited/PMD13/PMD Patient Data_4Q.csv", na.strings="")

## Rename variables in Q2, Q3, Q4 to ensure uniformity of variable names (Follow Q1's variables)
  
  PMD.Patient.Data_2Q <- plyr::rename(PMD.Patient.Data_2Q, c(
                                "Desired.Effect.Description"="DE_DESC"
                                                            ))
  
  PMD.Patient.Data_3Q <- plyr::rename(PMD.Patient.Data_3Q, c(
                                "Desired.Effect"="DE", 
                                "Desired.Effect.Description" = "DE_DESC", 
                                "QTY"="Quantity"
                                                            ))   
  
  PMD.Patient.Data_4Q <- plyr::rename(PMD.Patient.Data_4Q, c(
                                "Desired.Effect"="DE"
                                                            ))

## Horizontally merge (Append) Patient Q1, Q2, Q3, Q4 dataframes
  PMD.Patient.Data_Q <- rbind(PMD.Patient.Data_1Q, 
                              PMD.Patient.Data_2Q, 
                              PMD.Patient.Data_3Q, 
                              PMD.Patient.Data_4Q)
  
## Rename PMD.Patient.Data_Q variables to be more precise
  PMD.Patient.Data_Q <- plyr::rename(PMD.Patient.Data_Q, c(
                                                      "Sex" = "Patient.Sex",
                                                      "DoctorNo" = "Doctor.No",
                                                      "DaySeen" = "Patient.Day.Seen",
                                                      "Age" = "Patient.Age",
                                                      "Patient.Number" = "Patient.No",
                                                      "Where.Seen" = "Patient.Where.Seen",
                                                      "Visit.Indicator" = "Patient.Visit.Indicator",
                                                      "ICD10" = "Patient.ICD10",
                                                      "ICD10.Description" = "Patient.ICD10.Description",
                                                      "DE" = "Patient.Desired.Effect.Code",
                                                      "DE_DESC" = "Patient.Desired.Effect",
                                                      "Dosage" = "Patient.Dosage",
                                                      "Quantity" = "Patient.Quantity",
                                                      "Drug.Indicator" = "Patient.Drug.Indicator"
                                                      ))

##Convert integer to factors
  PMD.Patient.Data_Q$Patient.Sex <- factor(PMD.Patient.Data_Q$Patient.Sex)
  PMD.Patient.Data_Q$Patient.Where.Seen <- factor(PMD.Patient.Data_Q$Patient.Where.Seen)
  PMD.Patient.Data_Q$Patient.Visit.Indicator <- factor(PMD.Patient.Data_Q$Patient.Visit.Indicator)
  PMD.Patient.Data_Q$Patient.Day.Seen <- factor(PMD.Patient.Data_Q$Patient.Day.Seen)
  PMD.Patient.Data_Q$Patient.Drug.Indicator <- factor(PMD.Patient.Data_Q$Patient.Drug.Indicator)
  PMD.Patient.Data_Q$Patient.Dosage <- factor(PMD.Patient.Data_Q$Patient.Dosage)
  PMD.Patient.Data_Q$Patient.Quantity <- factor(PMD.Patient.Data_Q$Patient.Quantity)
  
##Recode variables
  PMD.Patient.Data_Q$Patient.Sex <- revalue(PMD.Patient.Data_Q$Patient.Sex, c(
                                            "1"="Male", 
                                            "2"="Female"
                                                                                  ))
  
  PMD.Patient.Data_Q$Patient.Where.Seen <- revalue(PMD.Patient.Data_Q$Patient.Where.Seen,c(
                                            "1"="Clinic", 
                                            "2"="Hospital", 
                                            "3"="Phone Call", 
                                            "8"="Others",
                                            "9"="Unspecified"
                                                                          ))
  
  PMD.Patient.Data_Q$Patient.Visit.Indicator <- revalue(PMD.Patient.Data_Q$Patient.Visit.Indicator, c(
                                            "1"="First", 
                                            "2"="Subsequent", 
                                            "9"="Unspecified"
                                                                                    ))
  
  PMD.Patient.Data_Q$Patient.Drug.Indicator <- revalue(PMD.Patient.Data_Q$Patient.Drug.Indicator, c(
                                              "1"="First", 
                                              "2"="Repeat", 
                                              "9"="Unspecified"
                                                                                    ))
  
PMD.Patient.Data_Q$Patient.Dosage <- revalue(PMD.Patient.Data_Q$Patient.Dosage, c("999" = "Unspecified"))

PMD.Patient.Data_Q$Patient.Quantity <- revalue(PMD.Patient.Data_Q$Patient.Quantity, c("999" = "Unspecified"))
  
PMD.Patient.Data_Q$Patient.Day.Seen <- revalue(PMD.Patient.Data_Q$Patient.Day.Seen, c(
                                             "1"="Mon", 
                                             "2"="Tues", 
                                             "3"="Wed",
                                             "4"="Thurs",
                                             "5"="Fri", 
                                             "6"="Sat", 
                                             "7"="Sun"
                                                                    ))

## Delete unnecessary data sets for faster runs
  rm(PMD.Patient.Data_1Q, 
     PMD.Patient.Data_2Q, 
     PMD.Patient.Data_3Q, 
     PMD.Patient.Data_4Q)
  
## Right Merge Physician and Patient Data
  PMD_merged <- merge(PMD.Doctor.Data_Q_unique, 
                      PMD.Patient.Data_Q, 
                      "Doctor.No")
  
  ## NOTE: 33 variables, 51291 observations, unit of measure is prescription

## Create unique ID for each prescription
  ## Pad with leading zeroes to create uniform width
  PMD_merged$Doctor.No <- sprintf("%04d", PMD_merged$Doctor.No)
  PMD_merged$Patient.No <- sprintf("%02d", PMD_merged$Patient.No)
  PMD_merged$Quarter<- sprintf("%02d", PMD_merged$Quarter)

## Generate unique ID from pasted Doctor.No, Patient.No, Quarter, separated by no space
  PMD_merged$ID <- paste(PMD_merged$Doctor.No, PMD_merged$Patient.No, PMD_merged$Quarter, sep = "")
  
## Split ATC variable into two variables
  PMD_merged <- separate(PMD_merged, ATC, into = c("ATC1", "ATC2"), sep=3)
  
## Drop unnecessary files
  rm(PMD.Doctor.Data_Q_unique, PMD.Patient.Data_Q)
  
## Write csv
  write.csv(PMD_merged, "~/Dropbox/IMS data/Edited/PMD_merged.csv")

## Proceed to [2] Drug Characteristics.R file
## DONE
