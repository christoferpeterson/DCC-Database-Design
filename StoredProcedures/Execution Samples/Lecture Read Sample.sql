DECLARE @updateEventId UNIQUEIDENTIFIER;
SELECT TOP 1 @updateEventId = eventid FROM [dbo].[inv.LectureSchedule] ORDER BY inserted_date DESC;

EXEC spLectureEventRead @eventid = @updateEventId, @includeHistory = 1