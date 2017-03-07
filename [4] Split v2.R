## Prepare C07 and C10 Data

##Merge FDA Data and TC2 Data
##Merge TC2/FDA data with PMD = final data set

## Read files
  FDA <- read.csv("~/Dropbox/IMS data/Edited/FDA/Registered Drug Products as of 05 September 2016.csv", na.strings="")
  PMD_merged <- read.csv("~/Dropbox/IMS data/Edited/PMD_merged.csv", na.strings="")
  TC2.merged_v3 <- read.csv("~/Dropbox/IMS data/Edited/TC2.merged_v3.csv", na.strings="")
  
## Delete first rows of csv files
  PMD_merged$X <- NULL
  TC2.merged_v3$X <- NULL

## Create unique ID for each prescription
  ## Pad with leading zeroes to create uniform width
  PMD_merged$Doctor.No <- sprintf("%04d", PMD_merged$Doctor.No)
  PMD_merged$Patient.No <- sprintf("%02d", PMD_merged$Patient.No)
  PMD_merged$Quarter<- sprintf("%02d", PMD_merged$Quarter)
  
  ## Generate unique ID from pasted Doctor.No, Patient.No, Quarter, separated by no space
  PMD_merged$ID <- paste(PMD_merged$Doctor.No, PMD_merged$Patient.No, PMD_merged$Quarter, sep = "")
  
## Rename variables in FDA Data
  FDA <- plyr::rename(FDA, c(
        "Registration.Status" = "Reg.Status",
        "Brand.Name" = "FDA.Brand.Name",
        "Generic.Name" = "FDA.Generic.Name",
        "Indication...Pharmacologic.Category"="Indication",
        "Certificate.of.Product.Registration..CPR..No."="CPR Np",
        "Packaging.Presentation" = "Presentation",
        "CLASS"="Class"
                            ))
  

## SUMMARY
  ## TC2.v3 is TC2 and PFC
  ## TC2.v4 is TC2 and PFC and FDA
  ## PMD.v1 is PMD and TC2.v4
  
## Merge TC2.merged_v3 with FDA Data => TC2.merged_v4 [1506 observations, 49 variables]
  TC2.merged_v4 <- merge(TC2.merged_v3, FDA, "Registration.Number", all.x = TRUE)

## Merge TC2.merged_v4 with PMD_merged => PMD_merged_v1 [51299 observations, 8something variables]
  PMD_merged_v1 <- merge(PMD_merged, TC2.merged_v4, "PFC", all.x = TRUE)
  
  sum(is.na(PMD_merged_v1$Drug.Type)) ##14163 cases missing - what is the cause of these missing cases?

## Drop unnecessary columns
  PMD_merged_v1$PFC.Product <- NULL
  PMD_merged_v1$PFC.Pack <- NULL
  PMD_merged_v1$Drug.Therapeutic.Class <- NULL
  PMD_merged_v1$PFC.Product.Pack.Name <- NULL
  PMD_merged_v1$ATC <- NULL
  PMD_merged_v1$NFC.y <- NULL
  PMD_merged_v1$PFC.Lab.Desc <- NULL
  
## Reorder columns in preparation for analysis and save as PMD_merged_v2
  refcols <- c("Country",
              "Quarter",
              "Year",
              "ID",
               "Product.Name",
               "Pack.Description", 
               "Pack.Molecule.String",
               "ATC1", 
               "ATC2",
               "PFC", 
               "License.Type", 
               "Drug.Type"
                  ) 
  
  PMD_merged_v1<- PMD_merged_v1[, c(refcols, setdiff(names(PMD_merged_v1), refcols))]

## Extract PMD rows on basis on ATC1 (extract prescriptions)
  PMD_C07 <- PMD_merged_v1[PMD_merged_v1$ATC1 == "C07", ]   ## PMD_C07 has 2536 observations
  PMD_C10 <- PMD_merged_v1[PMD_merged_v1$ATC1 == "C10", ]   ## PMD_C10 has 7007 observations
  PMD_A10 <- PMD_merged_v1[PMD_merged_v1$ATC1 == "A10", ]   ## PMD_A10 has 14184 observations
  PMD_M01 <- PMD_merged_v1[PMD_merged_v1$ATC1 == "M01", ]   ## PMD_M01 has 11484 observations
  PMD_N02 <- PMD_merged_v1[PMD_merged_v1$ATC1 == "N02", ]   ## PMD_N02 has 8779 observations
  PMD_R05 <- PMD_merged_v1[PMD_merged_v1$ATC1 == "R05", ]   ## PMD_R05 has 7309 observations
  
## Remove unnecessary files
  rm(PMD_merged, PMD_merged_v1, TC2.merged_v4, TC2.merged_v3, FDA)
  
## Proceed to [5] for product lists

