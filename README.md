# Practiced Cleaning Data 
## Objective:
Practiced and learned more to clean data using SQL following Alex The Analyst. I learned about what to look for when it comes to cleaning data. I also learned what to consider and look for as well as the legality of certain actions.

## Data Source:
The data used was housing data from Nashville Tennessee from 2013 to 2016.

**Link:**  https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx

## Technology Used:
1. Excel - Data Preparation
2. MySQL - Data Cleaning

## Data Preparation and Cleaning
### Excel
Used to prepare the data by reformating Dates to the Acceptable MySQL Date format

### MySQL
1. Broke up the "OwnerAddress" into Address, City, State using **substring()** and altered the database accordingly.
2. Populated Empty "PropertyAddress" by checking if the "UniqueID" is the same using **Join** and altered the database accordingly.
3. Reformatted the "SoldAsVacant" column to only contain "Yes" and "No" because some rows had "Y" and "N" to ensure uniformity.
4. Removed duplicate rows if there were more than one identical property. Identified these duplicate rows by ensuring the  "ParcelID", "PropertyAddress", "SalePrice", "Saledate", "LegalReference" "UniqueID" were identical. Used Common Table Expressions for simplification and visualization.
