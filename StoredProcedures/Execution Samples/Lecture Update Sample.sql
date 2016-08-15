DECLARE @updateEventId UNIQUEIDENTIFIER;
SELECT TOP 1 @updateEventId = eventid FROM [dbo].[inv.LectureSchedule] ORDER BY inserted_date DESC;

EXEC spLectureEventUpdate
	@eventid = @updateEventId,
	@start = '2016-08-15 12:15:00',
	@end = '2016-08-15 13:30:00',
	@location = 'Denver Chess Club',
	@presenter = 'Christofer Peterson',
	@description = NULL,
	@inserted_by = 1017,
	@status = NULL;

SELECT TOP 2 * FROM [dbo].[inv.LectureSchedule] ORDER BY inserted_date DESC;