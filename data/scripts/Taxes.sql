/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) 'Simple tax' tax
		, 0.005 TaxRate
		, [CountryCode]
     -- ,[CountryEnglishName]
      --,[ModifiedDate]
  FROM [SportDB].[location].[Countries]