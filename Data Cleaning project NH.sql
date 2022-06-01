-- Importing Nashville Housing data

USE PortfolioProject;


CREATE TABLE `NashvilleHousing` (
  `UniqueID` int DEFAULT NULL,
  `ParcelID` varchar(45) DEFAULT NULL,
  `LandUse` varchar(45) DEFAULT NULL,
  `SalePrice` int DEFAULT NULL,
  `LegalReference` varchar(45) DEFAULT NULL,
  `SoldAsVacant` varchar(45) DEFAULT NULL,
  `OwnerName` varchar(100) DEFAULT NULL,
  `Acreage` float DEFAULT NULL,
  `LandValue` int DEFAULT NULL,
  `BuildingValue` int DEFAULT NULL,
  `TotalValue` int DEFAULT NULL,
  `YearBuilt` smallint DEFAULT NULL,
  `Bedrooms` int DEFAULT NULL,
  `FullBath` int DEFAULT NULL,
  `HalfBath` int DEFAULT NULL,
  `PropertySplitAddress` varchar(45) DEFAULT NULL,
  `PropertySplitCity` varchar(45) DEFAULT NULL,
  `OwnerSplitAddress` varchar(45) DEFAULT NULL,
  `OwnerSplitCity` varchar(45) DEFAULT NULL,
  `OwnerSplitState` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SET FOREIGN_KEY_CHECKS = 0;

SET UNIQUE_CHECKS = 0;



LOAD DATA LOCAL INFILE '/Users/sawda/Downloads/NashvilleHousingData.csv' IGNORE
    
    INTO TABLE NashvilleHousing

    FIELDS TERMINATED BY ','

    ENCLOSED BY '"'

    LINES TERMINATED BY '\r\n'  -- a text file generated on a Windows system. Proper file reading might require LINES TERMINATED BY '\r\n'. OTHERWISE use \n 
    
    IGNORE 1 ROWS

	(@vUniqueID, @vParcelID, @vLandUse, @vPropertyAddress, @vSaleDate, @vSalePrice, @vLegalReference, @vSoldAsVacant, @vOwnerName, 
    @vOwnerAddress, @vAcreage, @vTaxDistrict, @vLandValue, @vBuildingValue, @vTotalValue, @vYearBuilt, @vBedrooms, @vFullBath, @vHalfBath)
    
    SET
    UniqueID = NULLIF(@vUniqueID,''),
    ParcelID = NULLIF(@vParcelID,''),
    LandUse = NULLIF(@vLandUse,''),
    PropertyAddress = NULLIF(@vPropertyAddress,''),
    SaleDate = NULLIF(@vSaleDate,''),
    SalePrice = NULLIF(@vSalePrice,''),
    LegalReference = NULLIF(@vLegalReference,''),
    SoldAsVacant = NULLIF(@vSoldAsVacant,''), 
    OwnerName = NULLIF(@vOwnerName,''),
    OwnerAddress = NULLIF(@vOwnerAddress,''),
	Acreage = NULLIF(@vAcreage,''),
    TaxDistrict = NULLIF(@vTaxDistrict,''),
    LandValue = NULLIF(@vLandValue,''),
    BuildingValue = NULLIF(@vBuildingValue,''),
    TotalValue = NULLIF(@vTotalValue,''),
	YearBuilt = NULLIF(@vYearBuilt,''),
    Bedrooms = NULLIF(@vBedrooms,''),
    FullBath = NULLIF(@vFullBath,''),
    HalfBath = NULLIF(@vHalfBath,'');


SET UNIQUE_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 1;


-- Check if data has loaded properly
SELECT * FROM PortfolioProject.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


SELECT *
 FROM PortfolioProject.NashvilleHousing
 WHERE PropertyAddress IS NULL;


SELECT *
 FROM PortfolioProject.NashvilleHousing
 ORDER BY ParcelID;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
 FROM PortfolioProject.NashvilleHousing AS a
 JOIN PortfolioProject.NashvilleHousing AS b
  ON a.ParcelID = b.ParcelID 
   AND a.UniqueID != b.UniqueID
 WHERE a.PropertyAddress IS NULL;


UPDATE PortfolioProject.NashvilleHousing AS a
 JOIN PortfolioProject.NashvilleHousing AS b
  ON a.ParcelID = b.ParcelID 
   AND a.UniqueID != b.UniqueID
 SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
 WHERE a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
 FROM PortfolioProject.NashvilleHousing;
 
 
SELECT SUBSTR(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1) AS Address,  -- -1 makes sure that the comma is not in the results
 SUBSTR(PropertyAddress, LOCATE(',', PropertyAddress) +1, LENGTH(PropertyAddress)) AS City -- +1 makes sure that the comma is not there
 FROM PortfolioProject.NashvilleHousing;

 
ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress VARCHAR(45);
 
UPDATE NashvilleHousing
 SET PropertySplitAddress = SUBSTR(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1);


ALTER TABLE NashvilleHousing
 ADD PropertySplitCity VARCHAR(45);
 
UPDATE NashvilleHousing
 SET PropertySplitCity = SUBSTR(PropertyAddress, LOCATE(',', PropertyAddress) +1, LENGTH(PropertyAddress));


SELECT *
 FROM PortfolioProject.NashvilleHousing;
 
 
SELECT OwnerAddress
 FROM PortfolioProject.NashvilleHousing;

 
-- SELECT SUBSTRING_INDEX(OwnerAddress, ',', 1), SUBSTRING_INDEX(OwnerAddress, ',', 2), SUBSTRING_INDEX(OwnerAddress, ',', 3) FROM PortfolioProject.NashvilleHousing;


SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 1), ',', -1) AS Address,
 SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS City,
 SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1) AS State
 FROM PortfolioProject.NashvilleHousing;

 
ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress VARCHAR(45);
 
UPDATE NashvilleHousing
 SET OwnerSplitAddress = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 1), ',', -1);

 
ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity VARCHAR(45);
 
UPDATE NashvilleHousing
 SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);


ALTER TABLE NashvilleHousing
 ADD OwnerSplitState VARCHAR(45);
 
UPDATE NashvilleHousing
 SET OwnerSplitState = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1);

--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
 FROM PortfolioProject.NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER BY 2;
 
 
SELECT SoldAsVacant,
 CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
 END
 FROM PortfolioProject.NashvilleHousing;
 
UPDATE NashvilleHousing
 SET SoldAsVacant = 
 CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
 END;

--------------------------------------------------------------------------------------------------------------------------

-- Finding duplicates 


-- 1. Using CTE
	WITH RowNumCTE AS (
	 SELECT *,
	  ROW_NUMBER() OVER(
	  PARTITION BY ParcelID, 
				   PropertyAddress, 
				   SalePrice, 
				   SaleDate, 
				   LegalReference
				   ORDER BY UniqueID
				   ) row_num
	  FROM PortfolioProject.NashvilleHousing
	  )
	SELECT *
	 FROM RowNumCTE
	 WHERE row_num > 1
	 ORDER BY PropertyAddress;


-- 2. Using Self-Join
	SELECT *
	 FROM PortfolioProject.NashvilleHousing p1
	 INNER JOIN PortfolioProject.NashvilleHousing p2
	 ON p2.ParcelID = p1.ParcelID AND
					  p2.PropertyAddress = p1.PropertyAddress AND
					  p2.SalePrice = p1.SalePrice AND
					  p2.SaleDate = p1.SaleDate AND
					  p2.LegalReference = p1.LegalReference AND
					  p2.UniqueID < p1.UniqueID
	 ORDER BY p1.PropertyAddress;


-- Removing duplicates
-- You can't delete from a CTE in MySQL so we'll use the Join method


DELETE p1
 FROM PortfolioProject.NashvilleHousing p1
 INNER JOIN PortfolioProject.NashvilleHousing p2
  ON p2.ParcelID = p1.ParcelID AND
				   p2.PropertyAddress = p1.PropertyAddress AND
				   p2.SalePrice = p1.SalePrice AND
				   p2.SaleDate = p1.SaleDate AND
				   p2.LegalReference = p1.LegalReference AND
				   p2.UniqueID < p1.UniqueID;
                   
--------------------------------------------------------------------------------------------------------------------------

-- Delete unused columns


SELECT *
 FROM PortfolioProject.NashvilleHousing;
 
ALTER TABLE PortfolioProject.NashvilleHousing
 DROP COLUMN OwnerAddress, 
 DROP COLUMN TaxDistrict, 
 DROP COLUMN PropertyAddress,
 DROP COLUMN SaleDate; 