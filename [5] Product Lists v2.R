## Test to guide decision tree of nested logit
  
  ## Generate list of unique products in C07
  C07.Product.List <- PMD_C07[!duplicated(PMD_C07$Product.Name),] ##45 unique products
  C10.Product.List <- PMD_C10[!duplicated(PMD_C10$Product.Name),] ##107 unique products
  
  ## Generate frequency table to view most common Desired Effect
  C07.Desired.Effect <- as.data.frame(table(PMD_C07$Patient.Desired.Effect)) 
  C10.Desired.Effect <- as.data.frame(table(PMD_C10$DPatient.Desired.Effect))
  
  ## Subset prescriptions within highest desired effect
  C07.Hypo <- dplyr::filter(PMD_C07, Patient.Desired.Effect == "HYPOTENSIVE-OTHER" |Patient.Desired.Effect == "HYPOTENSIVE")
  C10.Chol <- dplyr::filter(PMD_C10, Patient.Desired.Effect == "REDUCE CHOLESTEROL" | Patient.Desired.Effect == "CHOL-REDUCER-OTHER")

  ## Generate list of unique products that treat diabaetes
  C07.Hypo.Product.List <- C07.Hypo[!duplicated(C07.Hypo$Product.Name),] ##42 unique products
  C10.Chol.Product.List <- C10.Chol[!duplicated(C10.Chol$Product.Name),] ##105 unique products
  
  ## Compare set of drugs within C07 to set of drugs with Desired Effect X
  write.csv(C07.Product.List, "~/Dropbox/IMS data/Edited/C07.Drugs.csv")
  write.csv(C10.Product.List, "~/Dropbox/IMS data/Edited/C10.Drugst.csv")
  write.csv(C07.Hypo.Product.List, "~/Dropbox/IMS data/Edited/C07.Hypo.Drugs.csv")
  write.csv(C10.Chol.Product.List, "~/Dropbox/IMS data/Edited/C10.Chol.Drugs.csv")

## Proceed to [6] Nested Logit