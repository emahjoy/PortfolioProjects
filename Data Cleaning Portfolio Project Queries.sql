select *
from NashvilleHousing


--Standardize the date format

select SaleDate, CONVERT(DATE, SaleDate)
from NashvilleHousing


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

update NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

select *
from NashvilleHousing

--Populate Property Address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing as a
join NashvilleHousing as b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing as a
join NashvilleHousing as b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]


select PropertyAddress
from NashvilleHousing
where PropertyAddress is null

select *
from NashvilleHousing


--Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as City
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


select *
from NashvilleHousing





select OwnerAddress
from NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select *
from NashvilleHousing




--Change Y and N to Yes and No in 'SoldAsVacant' field

select SoldAsVacant, COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by COUNT(SoldAsVacant)


select *
from NashvilleHousing


select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No' 
	 ELSE SoldAsVacant
END
from NashvilleHousing 

update NashvilleHousing
SET SoldAsVacant =
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No' 
	 ELSE SoldAsVacant
END


select *
from NashvilleHousing




--Remove Duplicates


 


with RowNumCTE AS (
select *,
     ROW_NUMBER() OVER (
     Partition by ParcelID, SaleDate, PropertyAddress, LegalReference, SalePrice
	 order by UniqueID) row_num
from NashvilleHousing
)
DELETE
FROM RowNumCTE
where row_num > 1




--delete unused columns


select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict