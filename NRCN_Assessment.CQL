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

AgeInYears() >= 39 and AgeInYears() < 80 and
exists ([Condition: Code '44054006' from SNOMED]) //Check for existance condition 2 Type Diabetes in Population

//Defining secondary Population that have positive complications results above normal and conditions .
define NRCN_Risk_Inclusion:
exists ([Condition: Code '38341003' from SNOMED]) or //Check for condition Hypertension.
exists([FamilyMemberHistory: Condition.Code.Coding.Code '44054006' from snomed ] FMH where FMH.relationship = 'father') or //Check for 2 Type Diabetes in Population based on FamilyMemberHistroy
exists([FamilyMemberHistory: Condition.Code.Coding.Code '44054006' from snomed ] FMH where FMH.relationship = 'mother') or
exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or // check for BMI above normal
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') or //check for Fasting glucose test with mmol
exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') or // check for Fasting glucose with units mg/dL
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or // HbA1c with units mmol/mol
exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 6.5 '%') or  // HBA1c with units %
exists ([Condition: Code '700449008' from SNOMED]) // Define Patients with NDH

//Define Patients with (Non-Diabetic_Hyperglycaemia)
define NDH:
exists ([Condition: Code '700449008' from SNOMED])

//Define Patients in exclusion zone
define NRCN_Risk_Exclusion:
not exists ([Condition: Code '38341003' from SNOMED]) or
not exists ([Observation: Code '39156-5' from LOINC] O where O.value as Quantity >= 28 'kg/m2') or
not exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 7.0 'mmol/L') or
not exists ([Observation: Code '1558-6' from LOINC] O where O.value as Quantity >= 126 'mg/dL') or
not exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 48 'mmol/mol') or
not exists ([Observation: Code '4548-4' from LOINC] O where O.value as Quantity >= 6.5 '%')

//Defining Population that meet criteria for the assement of Unhealthy Nephropathy, Retinopathy, Cardiovascular or Neuropathy.
define NRCN_Inclusion_Population:
"InitialPopulation" or "NRCN_Risk_Inclusion" or "NDH"