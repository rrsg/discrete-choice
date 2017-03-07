## Preparation for Nested Logit
## C07 Beta Blockers

## Generate indicating row number (unique ID for each prescription)
  Row.vector <- seq(1:1723)
  C07.Hypo.v1$Row <- Row.vector 
    
## Multiply rows by number of unique product choices (42 products)
  C07.Hypo.v2 <- C07.Hypo.v1[rep(seq_len(nrow(C07.Hypo.v1)), each=42),]
  
## Create a column with repeating product names
  C07.Hypo.Product.Vector <- C07.Hypo.Product.List$Product.Name   ##Create vector of repeating prod names
  C07.Hypo.v2$Rep <- C07.Hypo.Product.Vector                      ## Add vector as new row

## Create variable Choice that will be equal to "1" if rep and Product.Name are equal
  C07.Hypo.v3 <- mutate(C07.Hypo.v2, Choice = ifelse(
                            C07.Hypo.v2$Rep == C07.Hypo.v2$Product.Name, "1", "0"))
  
## Drop variables in C07.Hypo.v3 that are related to product
  C07.Hypo.v3[,39:81] <- NULL
  C07.Hypo.v3[,35] <- NULL
  C07.Hypo.v3[,5:12] <- NULL
  C07.Hypo.v3 <- plyr::rename(C07.Hypo.v3, c("Rep"="Product.Name")) 
  
## Generate list of unique products in C07
  C07.Hypo.Product.List <- C07.Hypo.v1[!duplicated(C07.Hypo.v1$Product.Name),] ##42 unique products
  
## Drop variables NOT related to product
  C07.Hypo.Product.List[,36:38] <- NULL
  C07.Hypo.Product.List[,13:34] <- NULL
  C07.Hypo.Product.List[,1:4] <- NULL
  C07.Hypo.Product.List$Drug.Therapeutic.Class <- NULL
  
## Merge C07.Hypo.v3 with Product List
  C07.Test <- merge(C07.Hypo.v3, C07.Hypo.Product.List, "Product.Name", all.x=TRUE)
  
## Reorder Columns
  refcols <- c("Choice",
               "Product.Name",
               "Mean.Price",
               "Country",
               "Quarter",
               "Year",
               "ID",
               "Pack.Description", 
               "Pack.Molecule.String",
               "ATC1", 
               "ATC2",
               "PFC", 
               "License.Type", 
               "Drug.Type"
  ) 
  
  C07.Testv1<- C07.Test[, c(refcols, setdiff(names(C07.Test), refcols))]
  
  write.csv(C07.Testv1, "~/Dropbox/IMS data/Edited/C07.Hypotensive.Trial.csv")
