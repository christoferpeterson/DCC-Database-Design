SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Peterson, Christofer
-- Create date: August 12, 2016
-- Description:	Update an existing lecture event.
-- =============================================

DROP PROCEDURE IF EXISTS spLectureEventUpdate;
GO

CREATE PROCEDURE spLectureEventUpdate
	@eventid UNIQUEIDENTIFIER,
	@start DATETIME,
	@end DATETIME,
	@location NVARCHAR(50),
	@presenter NVARCHAR(50),
	@description TEXT,
	@inserted_by INT,
	@status INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tempid INT;
	DECLARE @tempeventid UNIQUEIDENTIFIER;
	DECLARE @oldstatus INT;

	-- Search for an lecture to update
	SELECT TOP 1  
		@tempid = id, @tempeventid = eventid, @oldstatus = [status]
	FROM [dbo].[inv.LectureSchedule] 
	WHERE [status] NOT IN (4,5)
	ORDER BY inserted_date
	DESC;

	IF @status IS NULL
		SET @status = @oldstatus;

	-- if the lecture was not found throw an error
	IF @tempeventid IS NULL OR @oldstatus = 4
		THROW 50000, 'Cannot locate lecture.', 1;

	-- Verify the inputs to the stored procedure, no parameters save for description
	-- can be null and make sure the start time is not greater than the end time
	IF @start IS NULL OR @end IS NULL OR @location IS NULL OR @presenter IS NULL OR @inserted_by IS NULL
		THROW 50000, 'No input parameters besides @description can be null.', 1;
	IF @start > @end
		THROW 50000, 'Start time must be less than end time.', 1;

	-- Update the old transaction record to be marked "removed"
	UPDATE [dbo].[inv.LectureSchedule]
		SET [status] = 5
		WHERE id = @tempid;

    -- Add the new transaction to the lecture schedule inventory table
	INSERT INTO [dbo].[inv.LectureSchedule]
		(eventid, start, [end], location, inserted_by, inserted_date, presenter, [description], previous_status, [status])
	VALUES
		(@eventid, @start, @end, @location, @inserted_by, GETUTCDATE(), @presenter, @description, @oldstatus, @oldstatus)
END
GO