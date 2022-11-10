
 select*from NashvinHousing

--- Standardize Date Format

alter table NashvinHousing
add saledateconverted date

update NashvinHousing
set SaleDateconverted = convert(date,saledate)

select SaleDateconverted from NashvinHousing

alter table NashvinHousing
	drop column saledate
---Populate Property Adress Data
select PropertyAddress from NashvinHousing
where PropertyAddress is null

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress 
from NashvinHousing a, NashvinHousing b
where a.ParcelID=b.ParcelID
and a.[UniqueID ]!=b.[UniqueID ]
and a.PropertyAddress is null

update a
set PropertyAddress = b.PropertyAddress
from NashvinHousing a, NashvinHousing b
where a.ParcelID=b.ParcelID
and a.[UniqueID ]!=b.[UniqueID ]
and a.PropertyAddress is null

select PropertyAddress from NashvinHousing
where PropertyAddress is null

---Breaking out Adress into Individual Columns(Adress,City, State)
select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as property_adress,

SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as propertycity
from NashvinHousing

alter table NashvinHousing
add property_adress varchar(50),
propertycity varchar(50)

update NashvinHousing

set  property_adress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) ,
propertycity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select *from NashvinHousing

---- change Y and N to Yes and No in"SoldAsVacant"
select distinct(SoldAsVacant)

from NashvinHousing

select SoldAsVacant,
case SoldAsVacant
	when 'N' then'No'
	when 'Y' then'Yes'
	else SoldAsVacant
end 

from NashvinHousing

update NashvinHousing 
set  SoldAsVacant= case SoldAsVacant
	when 'N' then'No'
	when 'Y' then'Yes'
	else SoldAsVacant
end 

--- Delete duplicate
with rownumcte as
(select*,
ROW_NUMBER() over (partition by
		ParcelID,
		PropertyAddress,
		LegalReference,
		OwnerAddress
		order by
		UniqueId
		) as a


from NashvinHousing
)

delete
from rownumcte
where a>1
with rownumcte as
(select*,
ROW_NUMBER() over (partition by
		ParcelID,
		PropertyAddress,
		LegalReference,
		OwnerAddress
		order by
		UniqueId
		) as a


from NashvinHousing
)

select*
from rownumcte
where a>1
















