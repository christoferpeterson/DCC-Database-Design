DECLARE @updateEventId UNIQUEIDENTIFIER;
SELECT TOP 1 @updateEventId = eventid FROM [dbo].[inv.LectureSchedule] ORDER BY inserted_date DESC;

EXEC spLectureEventReset
	@eventid = @updateEventId,
	@transactionId = NULL,
	@inserted_by = 1017;

SELECT TOP 3 * FROM [dbo].[inv.LectureSchedule] ORDER BY inserted_date DESC;

SELECT * FROM [dbo].[View_LectureSchedule]