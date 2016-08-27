DROP VIEW IF EXISTS View_LectureSchedule;
GO

CREATE VIEW View_LectureSchedule AS
SELECT 
	[event].eventid AS EventId,
	[event].start AS Start,
	[event].[end] AS [End],
	[event].presenter AS Presenter,
	[event].[description] AS [Description],
	[event].location AS Location,		
	[event].[status] AS StatusId,
	transStatus.[description] AS [Status],
	modifier.ID AS ModifiedById,
	modifier.Name AS ModifiedBy,
	[event].inserted_date AS ModifiedDate,
	created.ID AS CreatedById,
	created.Name AS CreatedBy,
	created.inserted_date AS CreatedDate
FROM [dbo].[inv.LectureSchedule] AS [event]

-- include the transaction status for display
LEFT JOIN [dbo].[ref.TransactionStatus] transStatus WITH (NOLOCK)
	ON [event].[status] = transStatus.id

-- include lastest modifier of the event
LEFT JOIN [dbo].[DCCUsers] modifier WITH (NOLOCK)
	ON [event].inserted_by = modifier.ID

-- look for the original transaction to display event creator
RIGHT JOIN (
	SELECT 
		a.inserted_by, 
		a.inserted_date, 
		a.eventid,
		a.previous_status,
		b.ID,
		b.Name
	FROM [dbo].[inv.LectureSchedule] a
	LEFT JOIN [dbo].[DCCUsers] b WITH (NOLOCK)
	ON a.inserted_by = b.ID
	WHERE a.previous_status = 6
) created 
	ON [event].eventid = created.eventid

-- exclude removed, replaced, and void transactions
WHERE [event].[status] NOT IN (4,5,6,7);