/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  Distinct
      A.[City] [CityName]
	  , CR.CountryRegionCode
  FROM [AdventureWorks2017].[Person].[Address] A
  left join [AdventureWorks2017].[Person].StateProvince SP
	on A.StateProvinceID = SP.StateProvinceID
left join [AdventureWorks2017].[Person].CountryRegion CR
	on SP.CountryRegionCode = CR.CountryRegionCode