EXEC spLectureEventInsert
	@start = '2016-08-13',
	@end = '2016-08-14',
	@location = 'Denver Chess Club',
	@presenter = 'Christofer Peterson',
	@description = NULL,
	@inserted_by = 1017;

SELECT TOP 1 * FROM View_LectureSchedule ORDER BY CreatedDate DESC;