/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [TaxID]
      ,[Tax]
      ,[TaxRate]
      ,[CountryCode]
    --  ,[ModifiedDate]
  FROM [SportDB].[finance].[Taxes]