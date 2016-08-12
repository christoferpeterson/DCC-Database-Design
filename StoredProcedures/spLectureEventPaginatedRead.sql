SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS spLectureEventPaginatedRead;
GO

-- =============================================
-- Author:		Peterson, Christofer
-- Create date: August 12, 2016
-- Description:	Filter lecture events from the lecture schedule view
-- =============================================
CREATE PROCEDURE spLectureEventPaginatedRead 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME = NULL,
	@endDate DATETIME = NULL,
	@startRow INT = 1,
	@numRows INT = 25
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH AllRecords AS (
		SELECT EventId
		FROM [dbo].View_LectureSchedule
		WHERE 1=1
			AND
			(@startDate IS NULL OR [End] > @startDate)
			AND
			(@endDate IS NULL OR Start < @endDate)
	) 
	
	SELECT Count(EventId) AS TotalRecords FROM AllRecords;

	WITH AllRecords AS (
		SELECT
		ROW_NUMBER() OVER (ORDER BY Start DESC, [End] ASC) as RowNumber, 
		*
		FROM [dbo].View_LectureSchedule
		WHERE 1=1
			AND
			(@startDate IS NULL OR [End] > @startDate)
			AND
			(@endDate IS NULL OR Start < @endDate)
	)
	SELECT *
	FROM AllRecords
	WHERE RowNumber BETWEEN @startRow AND @startRow + @numRows;
END
GO