/*
*************************************************************************************************

@Build Stage: Opportunity
@Description: Builds Staging Table for Opportunity sObject.

@Developed By: Naresh Kumar Ojha
@Dated: Wednesday, 18th July 2018.
	
*************************************************************************************************
*/

-- Source Database: _Source_Dev
-- Staging Database: Migration_DataUpdate_Dev
-- Target Database : ClearCaptions_LegacyProd

-- DM_Logger Variables.

DECLARE @TableName NVARCHAR(50);
DECLARE @LogMessage NVARCHAR(MAX);

SET @TableName = 'Opportunity__Stage: ' + Convert(NVARCHAR(255), NEWID(), 20);

USE [_Source_Dev];

SET @LogMessage = 'Using Database: [_Source_Dev]';

PRINT @TableName;
PRINT @LogMessage;

-- Drop table Contact__Stage if already exists.
-- START.
IF EXISTS (SELECT 1 FROM [Migration_DataUpdate_Dev].INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Opportunity__Stage')
BEGIN
	SET @LogMessage = 'Dropping Previous Table: [Opportunity__Stage]';
	PRINT @LogMessage;
	DROP TABLE [Migration_DataUpdate_Dev].[dbo].[Opportunity__Stage];
END
-- END.

-- Create Staging Table Including Mapping & Transformations.
-- START.
SELECT TOP 1000
	CAST('' AS NCHAR(18)) AS Id,
	CAST('' AS NVARCHAR(1000)) AS [Error],
	b.[Id] as [AccountId], 
	c.[id] as [CampaignId], 
	a.[CloseDate] as [CloseDate],
	NULL as [Contact__c], --need to update in 2nd load 
	a.[CreatedById] as [CreatedById],
	a.[CreatedDate] as [CreatedDate],
	a.[Description] as [Description],
	a.[ForecastCategory] as [ForecastCategory],
	a.[ForecastCategoryName] as [ForecastCategoryName],
	a.[id] as [id],
	a.[LeadSource] as [LeadSource],
	a.[Name] as [Name],
	a.[NextStep] as [NextStep],
	d.[id] as [OwnerId], 
	a.[Probability] as [Probability],
	a.[SR_Start_Date__c] as [SR_Completed_Date__c],
	a.[SR_Id__c] as [SR_Id__c],
	a.[SR_Start_Date__c] as [SR_Start_Date__c],
	a.[StageName] as [StageName],
	a.[Type] as [Type],
	--a.[] as [utm_campaign__c],
	--a.[] as [utm_content__c],
	--a.[] as [utm_medium__c],
	--a.[] as [utm_source__c],
	--a.[] as [utm_term__c],
	--a.[] as [Work_Order__c], --joining condition not mentioned in the mapping 
	a.[Reason_Comments__c] as [Reason_Comments__c],
	a.[Reason_Detail__c] as [Reason_Detail__c],
	a.[Reason_Detail_Date__c] as [Reason_Detail_Date__c],
	a.[Feedback__c] as [Feedback__c],
	a.[Feedback_Comments__c] as [Feedback_Comments__c],
	a.[Service_Request_Status__c] as [Service_Request_Status__c],
	a.[SR_Completed_By__c] as [SR_Completed_By__c],
	a.[SR_Dossier_ContactId__c] as [SR_Dossier_ContactId__c]

INTO [Migration_DataUpdate_Dev].[dbo].[Opportunity__Stage]
FROM [_Source_Dev].[dbo].[Opportunity] a  
LEFT JOIN ClearCaptions_LegacyProd.[dbo].Account b on b.Legacy_ID__c = a.AccountId
LEFT JOIN ClearCaptions_LegacyProd.[dbo].Campaign c on c.Legacy_ID__c = a.CampaignId
LEFT JOIN ClearCaptions_LegacyProd.[dbo].[User] d on d.Legacy_Id__c = a.OwnerId;

-- END.

--NEED TO UPDATE Contact__c after loading Opportunity and OpportunityContactRole
/*
update x
set x.Contact__c = ocr.Contact__c
from [Migration_DataUpdate_Dev].[dbo].[Opportunity__Stage] x
LEFT JOIN ClearCaptions_LegacyProd.dbo.OpportunityContactRole ocr on ocr.OpportunityId = x.Id
*/  

-- Display Success And Error Statistics.
-- START.
DECLARE @theCount INT;
SELECT @theCount = COUNT(*) FROM [Migration_DataUpdate_Dev].dbo.Opportunity__Stage;
SET @LogMessage = 'Total Records Inserted: ' + CAST(@theCount AS NVARCHAR(MAX));
PRINT @LogMessage;
-- END.

-- Display Success And Error Statistics.
-- START.
DECLARE @countDifference INT;
SELECT @countDifference = COUNT(*) - @theCount FROM [_Source_Dev].dbo.Opportunity;
SET @LogMessage = 'Record Count Difference: ' + CAST(@countDifference AS NVARCHAR(MAX));
PRINT @LogMessage;
-- END.




