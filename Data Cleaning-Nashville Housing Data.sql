
SELECT * FROM PortfolioProject.dbo.NashvilleHousing$

------------------------------Standardize Date Format by removing time 

SELECT SaleDate, SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing$

ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
ADD SaleDateConverted Date;

UPDATE PortfolioProject.dbo.NashvilleHousing$
SET SaleDateConverted=CONVERT(Date,SaleDate)

-----------------------------Populate Property Address data where PropertyAddress is null, records with same ParcelID have equivalent propertyAddress. 
--ISNULL()--> checks whether first argument null, if yes, sets it to second argument

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing$

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing$ a
JOIN PortfolioProject.dbo.NashvilleHousing$ b
  ON a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
 SET a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProject.dbo.NashvilleHousing$ a
 JOIN PortfolioProject.dbo.NashvilleHousing$ b
   ON a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress is null

----------------------------Breaking PropertyAddress and OwnerAddress Columns into Individual columns (Address, City,State)

--PropertyAddress Column
SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address, 
		SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing$


--first creating columns to store the split address values
ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
ADD PropertySplitAddress Nvarchar(255), PropertyCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing$
SET SplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1), 
City= SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--OwnerAddress Column
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	   PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	   PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing$

ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
ADD OwnerSplitAddress Nvarchar(255), OwnerCity Nvarchar(255), OwnerState Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing$
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT OwnerSplitAddress, OwnerCity, OwnerState 
FROM PortfolioProject.dbo.NashvilleHousing$


------------------------------ Change Y to Yes and N to No in SoldAsVacant

SELECT DISTINCT(SoldasVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing$
GROUP BY SoldAsVacant

UPDATE PortfolioProject.dbo.NashvilleHousing$
SET SoldAsVacant='Yes'
WHERE SoldAsVacant='Y'

UPDATE PortfolioProject.dbo.NashvilleHousing$
SET SoldAsVacant='No'
WHERE SoldAsVacant='N'


-------------------------------Remove Duplicates
WITH RowNumCTE AS( 
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID ) row_num
FROM PortfolioProject.dbo.NashvilleHousing$
)

DELETE 
FROM RowNumCTE
WHERE row_num>1

-------------------------Delete unnecessary columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
DROP COLUMN PropertyAddress,OwnerAddress, TaxDistrict, SaleDate
