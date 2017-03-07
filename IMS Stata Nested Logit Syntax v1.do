clear

* Import file
import delimited "/Users/macbookpro/Downloads/PMD_C07.v8.csv", delimiter(comma) case(preserve) encoding(ISO-8859-1)
import delimited "/Users/macbookpro/Downloads/PMD_C10.v8.csv", delimiter(comma) case(preserve) encoding(ISO-8859-1)

* Drop redundant variables (row number and redundant molecule type variable)
drop v1
drop v2
drop PackMoleculeString

* Convert LicenseType variable to float, n's are equal because this is the choice set
tabulate MoleculeType 
encode MoleculeType, generate(MoleculeType2)

tabulate PatientSex
tabulate PatientWhereSeen
tabulate DoctorYrsofPractice

* Convert variables
	gen logprice = log(MeanPrice)

	egen PatientSex1 = group(PatientSex), label
	egen PatientWhereSeen1 = group(PatientWhereSeen), label
	egen PatientVisitIndicator1 = group(PatientVisitIndicator), label
	egen PatientDrugIndicator1 = group(PatientDrugIndicator), label
	
	egen DoctorSex1 = group(DoctorSex), label
	egen DoctorSpecialty1 = group(DoctorSpecialty), label
	egen DoctorPracticeType1 = group(DoctorPracticeType), label
	egen Region1 = group(Region), label
	
* Sort by ID to see case groups (choices grouped by common unique ID)
	sort ID

* List to view groups
	list ID MoleculeType2 Choice PatientAge PatientSex1 MeanPrice in 1/90, sepby(ID)

* Gen categorical variable (type) that identifies first-level alternatives: 
* First-level: generic, metoo, breakthrough

*C07 Betablockers
	nlogitgen type = MoleculeType2(generic: ATENOLOLGeneric|BISOPROLOLGeneric|CARVEDILOLGeneric|METOPROLOLGeneric|NEBIVOLOLGeneric|PROPRANOLOLGeneric, metoo: ATENOLOLMe-too|BISOPROLOLMe-too|CARVEDILOLMe-too|METOPROLOLMe-too|NEBIVOLOLMe-too, break: ATENOLOLBreakthrough|BISOPROLOLBreakthrough|CARTEOLOLBreakthrough|CARVEDILOLBreakthrough|METOPROLOLBreakthrough|NEBIVOLOLBreakthrough|PROPRANOLOLBreakthrough)
	
*C10 Statins
	nlogitgen type = MoleculeType2(generic: ATORVASTATINGeneric|FENOFIBRATEGeneric|GEMFIBROZILGeneric|PROBUCOLGeneric|PRAVASTATINGeneric|ROSUVASTATINGeneric|SIMVASTATINGeneric|, metoo: ATORVASTATINMe-too|FENOFIBRATEMe-too|GEMFIBROZILMe-too|PRAVASTATINMe-too|PROBUCOLMe-too|ROSUVASTATINMe-too|SIMVASTATINMe-too|, break: ATORVASTATINBreakthrough|GEMFIBROZILBreakthrough|ROSUVASTATINBreakthrough|SIMVASTATINBreakthrough)
	
* View nlogit decision tree
	nlogittree MoleculeType2 type, choice(Choice) case(ID)
	
* Run estimation, simple specification
* Note: Variable License defines the three types of drugs - gen, metoo, break 
* Goal: How the alternative-specific attribute (mean price) affect bottom alternative set (18 molecules)
* and how prescription-specific attributes (patient and physician characteristics) apply to
* alternative set at first decision level (three types of drugs)

*Full model
constraint 1 [break_tau]_cons = 1
constraint 2 [generic_tau]_cons = 1
nlogit Choice logprice || type: PatientAge PatientSex1 PatientWhereSeen1 PatientVisitIndicator1 PatientDrugIndicator1 DoctorNumberofPatients DoctorSex1 DoctorYrsofPractice DoctorSpecialty1 DoctorPracticeType1 Region1, base(generic) || MoleculeType2:, noconstant case(ID) altwise constraint(1) constraint(2)

*Simple model
constraint 1 [break_tau]_cons = 1
constraint 2 [generic_tau]_cons = 1
nlogit Choice logprice || type: PatientAge DoctorNumberofPatients DoctorYrsofPractice, base(generic) || MoleculeType2:, noconstant case(ID) altwise constraint(1) constraint(2)

