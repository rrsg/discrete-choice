##Goal: Merge all TC2 files and create TC2 File

## Read the files
  TC2_Grace_A10 <- read.csv("~/Dropbox/IMS data/Edited/TC2/TC2_Grace_A10.csv", na.strings="")
  TC2_Grace_C07 <- read.csv("~/Dropbox/IMS data/Edited/TC2/TC2_Grace_C07.csv", na.strings="")
  TC2_Grace_C10 <- read.csv("~/Dropbox/IMS data/Edited/TC2/TC2_Grace_C10.csv", na.strings="")
  TC2_Grace_M01 <- read.csv("~/Dropbox/IMS data/Edited/TC2/TC2_Grace_M01.csv", na.strings="")
  TC2_Grace_N02 <- read.csv("~/Dropbox/IMS data/Edited/TC2/TC2_Grace_N02.csv", na.strings="")
  TC2_Grace_R05 <- read.csv("~/Dropbox/IMS data/Edited/TC2/TC2_Grace_R05.csv", na.strings="")

## Fill NA cells with previous Product name
  TC2_Grace_A10$Product <- as.character(zoo::na.locf(TC2_Grace_A10$Product))
  TC2_Grace_C07$Product <- as.character(zoo::na.locf(TC2_Grace_C07$Product))
  TC2_Grace_C10$Product <- as.character(zoo::na.locf(TC2_Grace_C10$Product))
  TC2_Grace_M01$Product <- as.character(zoo::na.locf(TC2_Grace_M01$Product))
  TC2_Grace_N02$Product <- as.character(zoo::na.locf(TC2_Grace_N02$Product))
  TC2_Grace_R05$Product <- as.character(zoo::na.locf(TC2_Grace_R05$Product))

## Label each dataframe with their respective therapeutic class - create therapeutic class column
  TC2_Grace_A10$Drug.Therapeutic.Class <- "A10"
  TC2_Grace_C07$Drug.Therapeutic.Class <- "C07"
  TC2_Grace_C10$Drug.Therapeutic.Class <- "C10"
  TC2_Grace_M01$Drug.Therapeutic.Class <- "M01"
  TC2_Grace_N02$Drug.Therapeutic.Class <- "N02"
  TC2_Grace_R05$Drug.Therapeutic.Class <- "R05"
          
## Combine into one dataframe
  TC2 <- rbind(TC2_Grace_A10, 
                TC2_Grace_C07, 
                TC2_Grace_C10, 
                TC2_Grace_M01, 
                TC2_Grace_N02, 
                TC2_Grace_R05)

## Rename variable "Pack" as "Product.Pack.Name" for consistency
  TC2 <- plyr::rename(TC2, c("Pack"="Product.Pack.Name"))   

## Create Drug Type variable which is a recoding of license type
          TC2$Drug.Type <- plyr::revalue(TC2$License.Type, c(
                "Originator" = "Breakthrough", 
                "Branded Non-Originator"="Me-too", 
                "Unbranded Non-Originator"="Generic"
                                    ))

## Delete unnecessary data sets for faster runs
  rm(TC2_Grace_R05, 
     TC2_Grace_N02, 
     TC2_Grace_M01, 
     TC2_Grace_C10, 
     TC2_Grace_C07, 
     TC2_Grace_A10)
  
## Save as .csv file in Dropbox/Edited folder
  write.csv(TC2, "~/Dropbox/IMS data/Edited/TC2.csv")

## DONE 
## Proceed to 3-Drug PFC Merge.R
