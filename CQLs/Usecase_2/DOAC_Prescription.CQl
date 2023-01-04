library Edoxaban_Prescription_v1
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0'

codesystem "SNOMED": 'http://snomed.info/sct'
codesystem "ICD10": 'http://icd10.org'
codesystem "LOINC": 'http://loinc.org'

context Patient

//Defining Initial Population Diagonaised with Atrial Fibrilation and age.
define InitialPopulation:
AgeInYears() >= 20 and AgeInYears() <= 80 and
exists ([Condition: Code '49436004' from SNOMED])

//Define Population for Edoxaban 60mg 1 tab per day prescritpion.
define Sixty_mg_Edoxaban_Prescription:
exists InitialPopulation and
exists ([Observation: Code '35591-7' from LOINC] O where O.value as Quantity >=50 'mL/min' and O.value as Quantity <= 95 'mL/min')


//Define Population to exclude from edoxaban 60mg prescription but include in edoxaban 30mg 1 tablet per day prescription
define Thirty_mg_Edoxaban_Prescription:
exists InitialPopulation and
exists ([Observation: Code '35591-7' from LOINC] O where O.value as Quantity >= 30 'mL/min' and O.value as Quantity <=50 'mL/min')

//Define Population to exclude from Edoxaban Prescription
define NO_Edoxaban_Prescription:
not exists "Sixty_mg_Edoxaban_Prescription" or
not exists "Thirty_mg_Edoxaban_Prescription"

//Define Population that can receive Edoxaban.
define Edoxaban_Prescription:
"Thirty_mg_Edoxaban_Prescription" or "Sixty_mg_Edoxaban_Prescription"