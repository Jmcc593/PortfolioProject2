/*
	CLEANING DATA IN SQL QUERIES
*/


SELECT * 
FROM ProjectDB.Dbo.NashvilleHousing;



-- Standardize Data Formate

SELECT SaleDate,
	convert(date,SaleDate)
FROM ProjectDB.Dbo.NashvilleHousing;

UPDATE NashvilleHousing 
SET SaleDate = convert(date,SaleDate);

ALTER table NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing 
SET SaleDateConverted = convert(date,SaleDate);




-- Populate Property Address Data

SELECT PropertyAddress 
FROM ProjectDB.Dbo.NashvilleHousing
WHERE PropertyAddress IS NOT NULL
ORDER BY ParcelID;

SELECT A.ParcelID,
	A.PropertyAddress,
	B.ParcelID,
	B.PropertyAddress,
	isnull(A.Propertyaddress,B.PropertyAddress)
FROM ProjectDB.Dbo.NashvilleHousing A
		JOIN 
		ProjectDB.Dbo.NashvilleHousing B
		ON A.ParcelID = B.ParcelID AND
		A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL;

UPDATE A 
SET PropertyAddress = isnull(A.Propertyaddress,B.PropertyAddress) 
FROM ProjectDB.Dbo.NashvilleHousing A
		JOIN 
		ProjectDB.Dbo.NashvilleHousing B
		ON A.ParcelID = B.ParcelID AND
		A.[UniqueID ] <> B.[UniqueID ];




-- Breaking out Address into Individual Columns (Address, City, State)

SELECT Propertyaddress 
FROM ProjectDB.Dbo.NashvilleHousing

SELECT substring(Propertyaddress,1,charindex(',',PropertyAddress)-1) AS Address,
	substring(Propertyaddress,charindex(',',PROPERTYADDRESS)+1,len(PROPERTYADDRESS)) AS ADDRESS
FROM ProjectDB.Dbo.NashvilleHousing;


ALTER table NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitAddress = substring(Propertyaddress,1,charindex(',',PropertyAddress)-1)



ALTER table NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitCity = substring(Propertyaddress,charindex(',',PROPERTYADDRESS)+1,len(PROPERTYADDRESS))



SELECT * 
FROM ProjectDB.Dbo.NashvilleHousing


SELECT Owneraddress 
FROM ProjectDB.Dbo.NashvilleHousing


SELECT parsename(replace(Owneraddress,',','.'),3) AS Address,
	parsename(replace(Owneraddress,',','.'),2) AS City,
	parsename(replace(Owneraddress,',','.'),1) AS State
FROM ProjectDB.Dbo.NashvilleHousing;







ALTER table NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);
UPDATE NashvilleHousing 
SET OwnerSplitAddress = parsename(replace(Owneraddress,',','.'),3);

ALTER table NashvilleHousing
ADD OwnerSplitCity nvarchar(255);
UPDATE NashvilleHousing 
SET OwnerSplitCity = parsename(replace(Owneraddress,',','.'),2);


ALTER table NashvilleHousing
ADD OwnerSplitState nvarchar(255);
UPDATE NashvilleHousing 
SET OwnerSplitState = parsename(replace(Owneraddress,',','.'),1);


-- Property owners address/city/state

SELECT Ownersplitaddress,
	Ownersplitcity,
	Ownersplitstate
FROM ProjectDB.Dbo.NashvilleHousing;



-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT SoldAsVacant,
	count(Soldasvacant)
FROM ProjectDB.Dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


--test
SELECT Soldasvacant,
		CASE 
			WHEN Soldasvacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE Soldasvacant
		END
FROM ProjectDB.Dbo.NashvilleHousing
--test

UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN Soldasvacant = 'Y' THEN 'Yes' WHEN SoldAsVacant = 'N' THEN 'No' ELSE Soldasvacant END




-- Remove Duplicates

WITH RowNumCTE AS( SELECT *,row_number() OVER ( Partition BY ParcelID,Propertyaddress,Saleprice,Saledate,Legalreference ORDER BY UniqueID ) Row_num FROM ProjectDB.Dbo.NashvilleHousing)    select *
FROM RowNumCTE
where row_num > 1




-- Remove Unused Columns

select *
FROM ProjectDB.Dbo.NashvilleHousing


ALTER TABLE projectDB.dbo.nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress;

ALTER TABLE projectDB.dbo.nashvillehousing
drop column saledate