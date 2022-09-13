/*Cleaning data in SQL Queries
*/

Select *
from PortfolioProject..Nashville_Housing

---------------------------------------------------

-- Standardize/ change Sale Date/ Date Format:

Select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject..Nashville_Housing

Update PortfolioProject..Nashville_Housing
SET SaleDate = CONVERT(Date,SaleDate)

-----------------------------------------------------

---- Populate Property Address Data

Select *
from PortfolioProject..Nashville_Housing
---WHERE PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Nashville_Housing a
JOIN PortfolioProject..Nashville_Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID ]
Where a.PropertyAddress IS NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject..Nashville_Housing a
JOIN PortfolioProject..Nashville_Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID ]
Where a.PropertyAddress IS NULL

---------------------------------------------------------------------------
---Breaking out PropertyAddress into individual columns (Address, City, State)

Select PropertyAddress
from PortfolioProject..Nashville_Housing
---WHERE PropertyAddress is null
---order by ParcelID

---Using Substrings
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

From PortfolioProject..Nashville_Housing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address

From PortfolioProject..Nashville_Housing

ALTER TABLE PortfolioProject..Nashville_Housing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..Nashville_Housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProject..Nashville_Housing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..Nashville_Housing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


SELECT *
From PortfolioProject..Nashville_Housing
----------------------------------------------------

------Breaking out OwnerAddress into individual columns (Address, City, State)

SELECT OwnerAddress
From PortfolioProject..Nashville_Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) 
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1) 
FROM PortfolioProject..Nashville_Housing


ALTER TABLE PortfolioProject..Nashville_Housing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..Nashville_Housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) 


ALTER TABLE PortfolioProject..Nashville_Housing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..Nashville_Housing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE PortfolioProject..Nashville_Housing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..Nashville_Housing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


------------------------------------------------------------------------------

------- Changing Y and N to Yes and No in "SoldAsVacant" field:

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..Nashville_Housing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

Update PortfolioProject..Nashville_Housing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

---------------------------------------------------------------------

-------- Removing Duplicates:
----- Using CTE and windows functions

With RowNumCTE AS(
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


From PortfolioProject..Nashville_Housing
---ORDER BY ParcelID
)

select *
FROM RowNumCTE
WHERE row_num > 1
----Order by PropertyAddress

Select *
FROM PortfolioProject..Nashville_Housing
--------------------------------------------------
-----Deleting unused columns

Select *
FROM PortfolioProject..Nashville_Housing

ALTER TABLE PortfolioProject..Nashville_Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..Nashville_Housing
DROP COLUMN SaleDate
