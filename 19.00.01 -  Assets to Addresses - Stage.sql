
/*
Aman Jaitly
*************************************************************************************************

@Build Stage: Assets_Addresses__c 
@Description: Builds Staging Table for Assets_Addresses__c sObject.

@Developed By: Hemendra Singh Bhati.
@Dated: Tuesday, 7th August 2018.

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

-- Drop table Assets_Addresses__c__Stage if already exists.
-- START.
IF EXISTS (SELECT 1 FROM [Migration_DataUpdate_Dev].INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Assets_Addresses__c__Stage')
BEGIN
	SET @LogMessage = 'Dropping Old Table: Assets_Addresses__c__Stage';
	PRINT @LogMessage;
	DROP TABLE [Migration_DataUpdate_Dev].[dbo].[Assets_Addresses__c__Stage];
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
	a.[Id] AS Legacy_ID__c,
	b.[Id] AS Account__c,

	--Other fields
	--'Y' AS Active__c, --(Migrate? column in mapping says BLANK)
	--a.[MailingCity] AS City__c, --(Migrate? column in mapping says BLANK)
	--a.[MailingCountry] AS Country__c, --(Migrate? column in mapping says BLANK)
	--a.[Name] AS Name, --Auto number field
	--c.[Id] AS OwnerId, --(Migrate? column in mapping says BLANK)
	--a.[MailingState] AS State_Province__c, --(Migrate? column in mapping says BLANK)
	--a.[MailingStreet] AS Street__c, --(Migrate? column in mapping says BLANK)
	--a.[MailingPostalCode] AS Zip_Postal_Code__c --(Migrate? column in mapping says BLANK)

INTO [Migration_DataUpdate_Dev].[dbo].[Assets_Addresses__c__Stage]
FROM [_Source_Dev].[dbo].[Contact] a

LEFT JOIN [ClearCaptions_Dev].[dbo].[Account] b ON b.Legacy_ID__c = a.AccountId
--LEFT JOIN [ClearCaptions_Dev].[dbo].[User] d ON d.Legacy_ID__c = a.OwnerId
-- END.
