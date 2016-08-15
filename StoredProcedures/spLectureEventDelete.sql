SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Peterson, Christofer
-- Create date: August 12, 2016
-- Description:	Marks a lecture event as removed.
-- =============================================

DROP PROCEDURE IF EXISTS spLectureEventDelete;
GO

CREATE PROCEDURE spLectureEventDelete
	@eventid UNIQUEIDENTIFIER,
	@inserted_by INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- event id and inserted by are required
	IF @eventid IS NULL OR @inserted_by IS NULL
		THROW 50000, '@eventid and @inserted_by are required.', 1;

	DECLARE @oldTransactionId INT;
	DECLARE @oldStatus INT;

	-- search for the last transaction done on the lecture being deleted
	SELECT TOP 1
		@oldTransactionId = id,
		@oldStatus = [status]
	FROM [dbo].[inv.LectureSchedule]
	WHERE eventid = @eventid AND [status] NOT IN (4,5)
	ORDER BY inserted_date DESC;

	IF @oldTransactionId IS NULL
		THROW 50000, 'Unable to locate lecture.', 1;

	-- update the old transaction to be replaced
	UPDATE [dbo].[inv.LectureSchedule]
		SET [status] = 5
		WHERE id = @oldTransactionId;

	-- create a new transaction from the old transaction setting the status to removed
	INSERT INTO [dbo].[inv.LectureSchedule]
		(eventid, start, [end], location, inserted_by, inserted_date, presenter, [description], previous_status, [status])
	SELECT
		eventid, start, [end], location, @inserted_by, GETUTCDATE(), presenter, [description], @oldStatus, 4
	FROM [dbo].[inv.LectureSchedule]
	WHERE id = @oldTransactionId;
END
GO
