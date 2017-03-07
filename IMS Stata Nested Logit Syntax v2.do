clear

* Import file
import delimited "/Users/macbookpro/Downloads/PMD_C07.v8.csv", delimiter(comma) case(preserve) encoding(ISO-8859-1)
import delimited "/Users/macbookpro/Downloads/PMD_C10.v8.csv", delimiter(comma) case(preserve) encoding(ISO-8859-1)

* Drop redundant variables (row number and redundant molecule type variable)
drop v1
drop PackMoleculeString

* Convert LicenseType variable to float, n's are equal because this is the choice set
tabulate MoleculeType 
encode MoleculeType, generate(MoleculeType2)

* Convert variables
	gen logprice = log(MeanPrice)

* Skip
	egen PatientSex1 = group(PatientSex), label
	egen PatientWhereSeen1 = group(PatientWhereSeen), label
	egen PatientVisitIndicator1 = group(PatientVisitIndicator), label
	egen PatientDrugIndicator1 = group(PatientDrugIndicator), label
	egen DoctorSex1 = group(DoctorSex), label
	egen DoctorSpecialtyA = group(DoctorSpecialty), label
	egen DoctorPracticeType1 = group(DoctorPracticeType), label
	egen Region1 = group(Region), label
	
* Create dummy variable for each factor variable
	tabulate PatientSex, gen(PatientSex)
	tabulate PatientWhereSeen, gen(PatientWhereSeen)
	tabulate PatientVisitIndicator, gen(PatientVisitIndicator)
	tabulate PatientDrugIndicator, gen(PatientDrugIndicator)
	tabulate DoctorSex, gen(DoctorSex)
	tabulate DoctorSpecialty, gen(DoctorSpecialty)
	tabulate DoctorPracticeType, gen(DoctorPracticeType)
	tabulate Region, gen(Region)

* Rename dummies
	rename PatientSex1 PatientSex_Female
	rename PatientSex2 PatientSex_Male
	
	rename PatientWhereSeen1 PatientWhereSeen_Clinic
	rename PatientWhereSeen2 PatientWhereSeen_Hospital
	rename PatientWhereSeen3 PatientWhereSeen_Others
	rename PatientWhereSeen4 PatientWhereSeen_Phone
	
	rename PatientVisitIndicator1 PatientVisitIndicator_First
	rename PatientVisitIndicator2 PatientVisitIndicator_Subsequent
	rename PatientVisitIndicator3 PatientVisitIndicator_Uncertain
	
	rename PatientDrugIndicator1 PatientDrugIndicator_First
	rename PatientDrugIndicator2 PatientDrugIndicator_Repeat
	rename PatientDrugIndicator3 PatientDrugIndicator_Uncertain
	
	rename DoctorSex1 DoctorSex_Female
	rename DoctorSex2 DoctorSex_Male
	
	rename DoctorSpecialty1 DoctorSpecialty_Cardio
	rename DoctorSpecialty2 DoctorSpecialty_Derma
	rename DoctorSpecialty3 DoctorSpecialty_Diab
	rename DoctorSpecialty4 DoctorSpecialty_Endo
	rename DoctorSpecialty5 DoctorSpecialty_Ent
	rename DoctorSpecialty6 DoctorSpecialty_Gastro
	rename DoctorSpecialty7 DoctorSpecialty_GP
	rename DoctorSpecialty8 DoctorSpecialty_IM
	rename DoctorSpecialty9 DoctorSpecialty_Nephro
	rename DoctorSpecialty10 DoctorSpecialty_Neuro
	rename DoctorSpecialty11 DoctorSpecialty_Obygyn
	rename DoctorSpecialty12 DoctorSpecialty_Onco
	rename DoctorSpecialty13 DoctorSpecialty_Ophtha
	rename DoctorSpecialty14 DoctorSpecialty_Ortho
	rename DoctorSpecialty15 DoctorSpecialty_Ped
	rename DoctorSpecialty16 DoctorSpecialty_Psych
	rename DoctorSpecialty17 DoctorSpecialty_Pulmo
	rename DoctorSpecialty18 DoctorSpecialty_Rheuma
	rename DoctorSpecialty19 DoctorSpecialty_Sur
	rename DoctorSpecialty20 DoctorSpecialty_Urosur
	
	rename DoctorPracticeType1 DoctorPracticeType_GovtHosp_only
	rename DoctorPracticeType2 DoctorPracticeType_Clinic_only
    rename DoctorPracticeType3 DoctorPracticeType_Clin_GovtHosp
	rename DoctorPracticeType4 DoctorPracticeType_Clin_PrivHosp
	rename DoctorPracticeType5 DoctorPracticeType_PrivHosp_only
	
	rename Region1 Region_Luz
	rename Region2 Region_Min
	rename Region3 Region_NCR
	rename Region4 Region_Vis

* Sort by ID to see case groups (choices grouped by common unique ID)
	sort ID

* List to view groups
	list ID MoleculeType2 Choice PatientAge MeanPrice in 1/90, sepby(ID)

* Gen categorical variable (type) that identifies first-level alternatives: 
* First-level: generic, metoo, breakthrough

*C07 Betablockers
	nlogitgen type = MoleculeType2(generic: ATENOLOLGeneric|BISOPROLOLGeneric|CARVEDILOLGeneric|METOPROLOLGeneric|NEBIVOLOLGeneric|PROPRANOLOLGeneric, metoo: ATENOLOLMe-too|BISOPROLOLMe-too|CARVEDILOLMe-too|METOPROLOLMe-too|NEBIVOLOLMe-too, break: ATENOLOLBreakthrough|BISOPROLOLBreakthrough|CARTEOLOLBreakthrough|CARVEDILOLBreakthrough|METOPROLOLBreakthrough|NEBIVOLOLBreakthrough|PROPRANOLOLBreakthrough)
	
*C10 Statins
	nlogitgen type = MoleculeType2(generic: ATORVASTATINGeneric|FENOFIBRATEGeneric|PRAVASTATINGeneric|ROSUVASTATINGeneric|SIMVASTATINGeneric|, metoo: ATORVASTATINMe-too|FENOFIBRATEMe-too|GEMFIBROZILMe-too|PRAVASTATINMe-too|PROBUCOLMe-too|ROSUVASTATINMe-too|SIMVASTATINMe-too|, break: ATORVASTATINBreakthrough|GEMFIBROZILBreakthrough|ROSUVASTATINBreakthrough|SIMVASTATINBreakthrough)
	
* View nlogit decision tree
	nlogittree MoleculeType2 type, choice(Choice) case(ID)
	
* Run estimation, simple specification
* Note: Variable License defines the three types of drugs - gen, metoo, break 
* Goal: How the alternative-specific attribute (mean price) affect bottom alternative set (18 molecules)
* and how prescription-specific attributes (patient and physician characteristics) apply to
* alternative set at first decision level (three types of drugs)

*Simple model
constraint 1 [break_tau]_cons = 1
constraint 2 [generic_tau]_cons = 1
nlogit Choice logprice || type: PatientAge DoctorNumberofPatients DoctorYrsofPractice, base(generic) || MoleculeType2:, noconstant case(ID) altwise constraint(1) constraint(2)

*Full model with constraints
constraint 1 [break_tau]_cons = 1
constraint 2 [generic_tau]_cons = 1
nlogit Choice logprice || type: PatientAge PatientSex1 PatientWhereSeen1 PatientVisitIndicator1 PatientDrugIndicator1 DoctorNumberofPatients DoctorSex1 DoctorYrsofPractice DoctorSpecialty1 DoctorPracticeType1 Region1, base(generic) || MoleculeType2:, noconstant case(ID) altwise constraint(1) constraint(2)

*full model Without constraints
constraint 1 [break_tau]_cons = 1
constraint 2 [generic_tau]_cons = 1
nlogit Choice logprice || type: PatientAge ///
PatientSex_Female PatientSex_Male ///
PatientWhereSeen_Clinic PatientWhereSeen_Hospital PatientWhereSeen_Others PatientWhereSeen_Phone ///
PatientVisitIndicator_First PatientVisitIndicator_Subsequent PatientVisitIndicator_Uncertain ///
PatientDrugIndicator_First PatientDrugIndicator_Repeat PatientDrugIndicator_Uncertain ///
DoctorSex_Female DoctorSex_Male ///
DoctorNumberofPatients ///
DoctorYrsofPractice ///
DoctorSpecialty_Cardio DoctorSpecialty_Derma  DoctorSpecialty_Diab DoctorSpecialty_Endo DoctorSpecialty_Ent ///
DoctorSpecialty_Gastro DoctorSpecialty_GP DoctorSpecialty_IM DoctorSpecialty_Nephro DoctorSpecialty_Neuro ///
DoctorSpecialty_Obygyn DoctorSpecialty_Onco DoctorSpecialty_Ophtha DoctorSpecialty_Ortho DoctorSpecialty_Ped ///
DoctorSpecialty_Psych DoctorSpecialty_Pulmo DoctorSpecialty_Rheuma DoctorSpecialty_Sur DoctorSpecialty_Urosur ///
DoctorPracticeType_GovtHosp DoctorPracticeType_Clinic DoctorPracticeType_Clin_GovtHosp ///
DoctorPracticeType_Clin_PrivHosp DoctorPracticeType_PrivHosp_only ///
Region_Luz Region_Min Region_NCR Region_Vis ///
, base(generic) || MoleculeType2:, noconstant case(ID) altwise constraint(1) constraint(2)

**TRIAL** 

constraint 1 [break_tau]_cons = 1
constraint 2 [generic_tau]_cons = 1
nlogit Choice logprice || type: PatientAge ///
PatientSex_Female ///
PatientWhereSeen_Clinic PatientWhereSeen_Hospital PatientWhereSeen_Phone ///
PatientVisitIndicator_First PatientVisitIndicator_Subsequent ///
PatientDrugIndicator_First PatientDrugIndicator_Repeat ///
DoctorSex_Female ///
DoctorNumberofPatients ///
DoctorYrsofPractice ///
DoctorSpecialtyA ///
DoctorPracticeType_GovtHosp_only DoctorPracticeType_Clinic_only ///
DoctorPracticeType_PrivHosp_only ///
Region_Luz Region_Min Region_Vis ///
, base(generic) || MoleculeType2:, noconstant case(ID) altwise constraint(1) constraint(2)

	

	
	


