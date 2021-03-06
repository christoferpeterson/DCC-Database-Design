DECLARE @eventid UNIQUEIDENTIFIER;

SELECT TOP 1
	@eventid = eventid
FROM [dbo].[inv.LectureSchedule]
WHERE [status] NOT IN (4,5)
ORDER BY inserted_date DESC;

EXEC spLectureEventDelete
	@eventid = @eventid,
	@inserted_by = 1017;

SELECT TOP 2 *
FROM [dbo].[inv.LectureSchedule]
WHERE eventid = @eventid
ORDER BY inserted_date DESC;