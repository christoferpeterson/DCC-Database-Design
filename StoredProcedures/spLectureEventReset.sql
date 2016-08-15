-- ==========================================================
-- Create Stored Procedure Template for Windows Azure SQL Database
-- ==========================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Peterson, Christofer
-- Create date: August 15, 2016
-- Description:	Reset the event status to a
--				to a specific transaction,
--				null transaction id will reset
--				to the previous transaction
-- =============================================

DROP PROCEDURE IF EXISTS spLectureEventReset;
GO

CREATE PROCEDURE spLectureEventReset 
	@eventid UNIQUEIDENTIFIER,
	@transactionId INT,
	@inserted_by INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tempTransId INT;
	DECLARE @tempEventId UNIQUEIDENTIFIER;
	DECLARE @oldStatus INT;
	DECLARE @currentId INT;

		-- event id and inserted by are required
	IF @eventid IS NULL OR @inserted_by IS NULL
		THROW 50000, 'Event ID and User ID is required.', 1;

	IF @transactionId IS NOT NULL
		BEGIN
			SELECT @tempTransId = id, @tempEventId = eventid
			FROM [dbo].[inv.LectureSchedule]
			WHERE id = @transactionId;

			IF @tempTransId IS NULL
				THROW 50000, 'Unable to locate specified transaction', 1;
			IF @tempEventId != @eventid
				THROW 50000, 'Event ids do not match.', 1;
		END
	ELSE
		BEGIN
			SELECT @transactionId = id
			FROM [dbo].[inv.LectureSchedule]
			WHERE eventid = @eventid
			ORDER BY id DESC
			OFFSET 1 ROWS
			FETCH NEXT 1 ROWS ONLY;

			IF @transactionId IS NULL
				THROW 50000, 'No previous state to roll back to', 1;
		END

	SELECT TOP 1 @oldStatus = previous_status, @currentId = id
	FROM [dbo].[inv.LectureSchedule]
	WHERE eventid = @eventid
	ORDER BY id DESC;

	-- Update the old transaction record to be marked "removed"
	UPDATE [dbo].[inv.LectureSchedule]
	SET [status] = 5
	WHERE id = @currentId;

	-- create a new transaction from the old transaction setting the status to removed
	INSERT INTO [dbo].[inv.LectureSchedule]
		(eventid, start, [end], location, inserted_by, inserted_date, presenter, [description], previous_status, [status])
	SELECT
		eventid, start, [end], location, @inserted_by, GETUTCDATE(), presenter, [description], previous_status, @oldStatus
	FROM [dbo].[inv.LectureSchedule]
	WHERE id = @transactionId;
END
GO
