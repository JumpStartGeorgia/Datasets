# School Teacher/Student Count + School Reports

## Summary
JumpStart requested data about how many students and teachers are in each Georgian school. At the same time JumpStart also requested a list of all schools that have had some kind of renovation work. JumpStart was given these two datasets in two different spreadsheet files and for analysis, these two files need to be merged into one.

## How match school records in spreadsheets
Matches will be made by comparing school names. The 3rd column in schools.csv file is the school name and the 3rd column in the school_repairs_[year].csv files is the school name.

Unfortunately, it is not that easy. In the schools.csv file, many school names start with 'სსიპ - ' which is not in the school_repairs_[year].csv files. So when comparing this prefix will have to be removed.

## Columns in the merged spreadsheet
The merged spreadsheet should have the following columns:
* school name (schools.csv col 3)
* region (schools.csv col 1)
* district (schools.csv col 2)
* address (schools.csv col 6)
* number students (schools.csv col 4)
* number teachers (schools.csv col 5)
And for each reconstruction csv file
* [year] reconstruction type (school_repairs_[year].csv col 4)
* [year] cost (school_repairs_[year].csv last col)

## Notes
### Reconstruction Type
* Some records do not have a value for this column. When this happens, use 'Unknown'
* Some schools have multiple records for the same year. When this happens, use 'Multiple Types' and then sum up the cost for these records
### Cost
2010 and 2011 have an extra column before the cost indicating how much the tender was for. Because of this, to get the cost value, use '.last' instead of an index
