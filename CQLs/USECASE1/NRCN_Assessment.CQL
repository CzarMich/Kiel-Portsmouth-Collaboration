library NRCN_Assessment_v7
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0'

codesystem "SNOMED": 'http://snomed.info/sct'
codesystem "ICD10": 'http://icd10.org'
codesystem "LOINC": 'http://loinc.org'
codesystem "FHIRCodeSystemRoleCode": 'http://terminology.hl7.org/CodeSystem/v3-RoleCode'

context Patient

//Defining Initial Population Diagonaised with 2 Type Diabetes and of ages 39 years - 80 years old.
define InitialPopulation:

AgeInYears() >= 39 and AgeInYears() < 80
// and
//exists ([Condition: Code '44054006' from SNOMED]) //Check for existance condition 2 Type Diabetes in Population

//Defining secondary Population that have positive complications results above normal and conditions .
define NRCN_Risk_Inclusion:
exists ([Condition: Code '38341003' from SNOMED]) or //Check for condition Hypertension.
exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or // check for BMI above normal
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') or //check for Fasting glucose test with mmol
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') or // check for Fasting glucose with units mg/dL
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or // HbA1c with units mmol/mol
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 6.5 '%') or  // HBA1c with units %
exists ([Condition: Code '700449008' from SNOMED]) // Define Patients with NDH

//Define Patients with conditions that must exists for 2 Type Diabetes to be Positive(Pre-Route_one)
define Pre_Route_One:
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') and //FPG Above Normal
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') // HbA1c above Normal

// Define Pre-Route_one Conditions)
define Pre_Route_One_Conditions:
exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or  // None-Normal BMI
exists ([Observation: Code '45735-8' from LOINC] O where O.value as Quantity >= 5 '%') or //Weight loss
exists ([Condition: Code '84229001' from SNOMED]) or //thirst (finding)
exists ([Condition: Code '249477003' from SNOMED]) or //Increased thirst (finding)
exists ([Condition: Code '28442001' from SNOMED]) //Existance of Condition Polyuria

//Define ROUTE 1: Define Patients that will be diagonised with 2 Type Diabetes based on Pre_Route_one and Pre_Route_one_Conditions
define Route_One:
"Pre_Route_One" and "Pre_Route_One_Conditions"

//Define Patients in exclusion zone
define NRCN_Risk_Exclusion:
not exists ([Condition: Code '38341003' from SNOMED]) or
not exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or
not exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') or
not exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') or
not exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or
not exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 6.5 '%')

//Define ROUTE 2: Defining Population that meet criteria for the assement of Unhealthy Nephropathy, Retinopathy, Cardiovascular or Neuropathy.
define Route_Two:
"NRCN_Risk_Inclusion" or "Route_One"

//Managed by Michael Anywar
