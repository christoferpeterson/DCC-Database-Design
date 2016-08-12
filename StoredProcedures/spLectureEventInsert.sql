SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Peterson, Christofer
-- Create date: August 12, 2016
-- Description:	Add a new lecture event to the database.
-- =============================================

DROP PROCEDURE IF EXISTS spLectureEventInsert;
GO

CREATE PROCEDURE spLectureEventInsert
	@start DATETIME,
	@end DATETIME,
	@location NVARCHAR(50),
	@presenter NVARCHAR(50),
	@description TEXT,
	@inserted_by INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Verify the inputs to the stored procedure, no parameters save for description
	-- can be null and make sure the start time is not greater than the end time
	IF @start IS NULL OR @end IS NULL OR @location IS NULL OR @presenter IS NULL OR @inserted_by IS NULL
		THROW 50000, 'No input parameters besides @description can be null.', 1;

	IF @start > @end
		THROW 50000, 'Start time must be less than end time.', 1;

	DECLARE @now DATETIME;
	SET @now = GETUTCDATE();

    -- Add the new transaction to the lecture schedule inventory table
	INSERT INTO [dbo].[inv.LectureSchedule]
		(eventid, start, [end], location, inserted_by, inserted_date, presenter, [description], previous_status, [status])
	VALUES
		(NEWID(), @start, @end, @location, @inserted_by, @now, @presenter, @description, 6, 1)
END
GO
