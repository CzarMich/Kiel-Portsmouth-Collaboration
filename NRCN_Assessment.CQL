library NRCN_Assessment_USECASE_v2
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

//Defining secondary Population that have positive complications results above normal and conditions .
define NRCN_Risk_Inclusion:
exists ([Condition: Code '38341003' from SNOMED]) or //Check for condition Hypertension.
exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or // check for BMI above normal
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') or //check for Fasting glucose test with mmol
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') or // check for Fasting glucose with units mg/dL
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or // HbA1c with units mmol/mol
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 6.5 '%') or  // HBA1c with units %
exists ([Condition: Code '700449008' from SNOMED]) // Define Patients with Non-Diabetic_Hyperglycaemia (NDH)

//ROUTE 1: Define Population with 2 Type Diabetes.
define ROUTE1:
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') and // check for Fasting glucose P with units mg/dL
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or // HbA1c with units mmol/mol
exists ([Observation: Code '249477003' from SNOMED]) or //Increased thirst (finding)
exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or // check for BMI above normal
exists ([Observation: Code '45735-8' from LOINC] O where O.value as Quantity >= 5 '%') or //Weight Loss 5% or more in last 30 days.
exists ([Observation: Code '45735-8' from LOINC] O where O.value as Quantity >= 10 '%') or //Weight Loss 10% or more in last 180 days.
exists ([Observation: Code '28442001' from SNOMED]) //Existance of Polyuria condition.

//Define Patients in exclusion zone
define NRCN_Risk_Exclusion:
not exists ([Condition: Code '38341003' from SNOMED]) or //Hypertension condition
not exists ([Observation: Code '28442001' from SNOMED]) or //Polyuria condition
not exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or //BMI above normal
not exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') or //FGP (mmol/L) above normal
not exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') or //FGP (mg/dL) above normal
not exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or //HbA1C above normal (mmol/mol)
not exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 6.5 '%') or //HbA1C above normal (% unit)
not exists ([Observation: Code '45735-8' from LOINC] O where O.value as Quantity >= 5 '%') or //Weight Loss 5%  (% unit)
not exists ([Observation: Code '45735-8' from LOINC] O where O.value as Quantity >= 10 '%') or //Weight Loss 10%


//ROUTE 2: Defining Population that meet criteria for the assement of Unhealthy Nephropathy, Retinopathy, Cardiovascular or Neuropathy
define ROUTE2:
"T2Diabetes" or "NRCN_Risk_Inclusion"