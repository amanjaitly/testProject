/*
*************************************************************************************************
--AJncljfsnvbfnldfn
@Build Stage: Addresses__c ---shfhseijg
@Description: Builds Staging Table for Addresses__c sObject.

@Developed By: Hemendra Singh Bhati.
@Dated: Wednesday, 1st August 2018.

*************************************************************************************************
*/

-- Source Database: _Source_Dev
-- Staging/Load Database: Migration_DataUpdate_Dev
-- Target Salesforce Org: CCDEVNEW
-- Linked Server Database: ClearCaptions_Dev

-- Declaring variables.
-- START.
DECLARE @LogMessage NVARCHAR(MAX);
-- END.

-- Drop table Addresses__c__Stage if already exists.
-- START.
IF EXISTS (SELECT 1 FROM [Migration_DataUpdate_Dev].INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Addresses__c__Stage')
BEGIN
	SET @LogMessage = 'Dropping Old Table: Addresses__c__Stage';
	PRINT @LogMessage;
	DROP TABLE [Migration_DataUpdate_Dev].[dbo].[Addresses__c__Stage];
END
-- END.

USE [_Source_Dev];

-- Create Staging Table Including Mapping & Transformations.
-- START.
SELECT TOP 1000
	-- Salesforce Results Fields.
	CAST('' AS NCHAR(18)) AS Id,
	CAST('' AS NVARCHAR(1000)) AS Error,

	-- Primary/Foreign Key Fields.
	--a.[Id] AS , --Legacy ID (not created in the org as of now)
	--b.[Id] AS Account__c, (the source column to Join the table is not confirmed in the mapping)

	--Other fields
	'Y' AS Active__c,
	a.[BillingCity] AS City__c,
	a.[BillingCountry] AS Country__c,
	--a.[Name] AS Name, --Auto number field
	c.[Id] AS OwnerId,
	a.[BillingState] AS State_Province__c,
	a.[BillingStreet] AS Street__c,
	a.[BillingPostalCode] AS Zip_Postal_Code__c

INTO [Migration_DataUpdate_Dev].[dbo].[Addresses__c__Stage]
FROM [_Source_Dev].[dbo].[Account] a

--LEFT JOIN [ClearCaptions_Dev].[dbo].[Account] b ON b.Legacy_ID__c = a.Id
LEFT JOIN [ClearCaptions_Dev].[dbo].[User] c ON c.Legacy_ID__c = a.OwnerId
-- END.
