--cleaning data in sql queries

select*
from pwebsite. dbo.housingdata

--task 1 formating the SaleDate

select SaleDateConverted
from pwebsite. dbo.housingdata

select SaleDate, convert(Date, SaleDate) as SaleDate
from pwebsite. dbo.housingdata

Update housingdata
set SaleDateconverted= convert(Date, SaleDate)  
 
 alter table housingdata
 Add SaleDate Date;

 --task 2 : property address clean up

select PropertyAddress
from housingdata
 -- checking the null value in table

select PropertyAddress
from housingdata
where PropertyAddress is null

-- checking the null value in overall database table

select*
from housingdata
order by ParcelID

--populating propertyaddress with parcelID repeating value for given null values

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress
from housingdata a
Join  housingdata b
   on a.ParcelID= b.ParcelID
   and a.[UniqueID ]<> b.[UniqueID ]


 select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress
from housingdata a
Join  housingdata b
   on a.ParcelID= b.ParcelID
   and a.[UniqueID ]<> b.[UniqueID ]
   where a.PropertyAddress is null
   -- populating null propertyadress to given property address

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from housingdata a
Join  housingdata b
   on a.ParcelID= b.ParcelID
   and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from housingdata a
Join  housingdata b
   on a.ParcelID= b.ParcelID
   and a.[UniqueID ]<> b.[UniqueID ]
   where a.PropertyAddress is null


   -------------------------------------------------------------------------------------------------------------------\
   --breaking address in to individuals columns(address, city, state)

select PropertyAddress
from housingdata

select 
SUBSTRING(PropertyAddress, 1,charindex(',',PropertyAddress)-1 ) as Address
 ,SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1 ,len(PropertyAddress)) as Address
from housingdata


Alter table housingdata 
add PropertySpiltAddress nvarchar(255)

update housingdata
set PropertySpiltAddress =SUBSTRING(PropertyAddress, 1,charindex(',',PropertyAddress)-1 )

Alter table housingdata 
add PropertySpiltCity nvarchar(255)

update housingdata
set PropertySpiltCity = SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1 ,len(PropertyAddress))  

 select* from housingdata

 ------------------------------------------------------------------
 -- implementing change in owners address

 select OwnerAddress
 from housingdata

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From housingdata


ALTER TABLE housingdata
Add OwnerSplitAddress Nvarchar(255);

Update housingdata
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housingdata
Add OwnerSplitCity Nvarchar(255);

Update housingdata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housingdata
Add OwnerSplitState Nvarchar(255);

Update housingdata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From housingdata


-----------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From housingdata
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From housingdata

Update housingdata
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress









WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata
--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1
 --Order by PropertyAddress

Select *
From housingdata




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From housingdata


ALTER TABLE housingdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
 