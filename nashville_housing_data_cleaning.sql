-- Altering the table to have the "date" data type as datetime

alter table nashville_data.nashville_housing_data
modify Saledate date;


-- Populate Property Address Data

Select *
From nashville_data.nashville_housing_data
where PropertyAddress is NUll
order by ParcelID;



-- Creating a Join to check if the ParcelID is the same, if it is and the UniqueID is differt populate the property address of the matching(cont'd)
-- (cont'd) ParcelID if one is empty

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
From nashville_data.nashville_housing_data a
JOIN nashville_data.nashville_housing_data b
	on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is NUll;

Update nashville_data.nashville_housing_data a
JOIN nashville_data.nashville_housing_data b
	on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
Set a.PropertyAddress =  ifnull(a.PropertyAddress, b.PropertyAddress)
Where a.PropertyAddress is NUll;



-- Breaking out Address into Individual Columns(Address,City, State)

-- Gets all the information before the first comma in the PropertyAddress
-- Position returns an Int so -1 index is to get the address without the comma included in it
Select substring(PropertyAddress, 1, position("," IN PropertyAddress) -1) as Address, 
-- Gets all the information after the first comma in the PropertyAddress
substring(PropertyAddress,position("," IN PropertyAddress) +1, length(PropertyAddress)) as Address
From nashville_data.nashville_housing_data;

Alter table nashville_data.nashville_housing_data
Add PropertySplitAddress nvarchar(255);

Update nashville_data.nashville_housing_data
Set PropertySplitAddress = substring(PropertyAddress, 1, position("," IN PropertyAddress) -1);


Alter table nashville_data.nashville_housing_data
Add PropertySplitCity nvarchar(255);

Update nashville_data.nashville_housing_data
Set PropertySplitCity = substring(PropertyAddress,position("," IN PropertyAddress) +1, length(PropertyAddress));



-- Getting the State, City and Address from OwnerAddress

select OwnerAddress
From nashville_data.nashville_housing_data;

-- To get the state I have to look backwards until I reach a comma
Select substring(OwnerAddress, 1, position("," IN OwnerAddress) -1) as Address,
substring(OwnerAddress,position("," IN OwnerAddress) +1, length(OwnerAddress)) as City,
substring(OwnerAddress, -2, position("," IN OwnerAddress)) as State
From nashville_data.nashville_housing_data;

Alter table nashville_data.nashville_housing_data
Add OwnerSplitAddress nvarchar(255);

Update nashville_data.nashville_housing_data
Set OwnerSplitAddress = substring(OwnerAddress, 1, position("," IN OwnerAddress) -1);

Alter table nashville_data.nashville_housing_data
Add OwnerSplitCity nvarchar(255);

Update nashville_data.nashville_housing_data
Set OwnerSplitCity = substring(OwnerAddress,position("," IN OwnerAddress) +1, length(OwnerAddress));

Alter table nashville_data.nashville_housing_data
Add OwnerSplitState nvarchar(255);

Update nashville_data.nashville_housing_data
Set OwnerSplitState = substring(OwnerAddress, -2, position("," IN OwnerAddress));

-- Change Y and N to Yes and No in "Sold as Vacant" field

-- Checking to see how many Y and N are there
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from nashville_data.nashville_housing_data
Group by SoldAsVacant
order by 2;

Select SoldAsVacant,  
Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No' 
     Else SoldAsVacant
     END
from nashville_data.nashville_housing_data;

Update nashville_data.nashville_housing_data 
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes' 
                        When SoldAsVacant = 'N' Then 'No' 
                        Else SoldAsVacant 
                        END;

-- Remove Duplicates (Using ROW NUMBER)

-- Checking to see how many identical rows are present
Select *,
row_number() over(partition by ParcelID, PropertyAddress, SalePrice, Saledate, LegalReference order by UniqueID) row_num
from nashville_data.nashville_housing_data
order by ParcelID;

WITH RowNumCTE AS(
Select *,
row_number() over(partition by ParcelID, PropertyAddress, SalePrice, Saledate, LegalReference order by UniqueID) row_num
from nashville_data.nashville_housing_data
)
Delete 
from nashville_data.nashville_housing_data
WHERE UniqueID IN (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);

-- Delete Unused Columns
Alter table nashville_data.nashville_housing_data
drop column PropertyAddress,
drop column TaxDistrict,
drop column OwnerAddress,
drop column SaleDate;






