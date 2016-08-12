USE [DenverChessClub-Test]
GO

/****** Object:  Table [dbo].[inv.LectureSchedule]    Script Date: 8/12/2016 9:10:00 AM ******/
DROP TABLE [dbo].[inv.LectureSchedule]
GO

/****** Object:  Table [dbo].[inv.LectureSchedule]    Script Date: 8/12/2016 9:10:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[inv.LectureSchedule](
	[id] [int] NOT NULL IDENTITY(1,1),
	[eventid] [uniqueidentifier] NOT NULL,
	[start] [datetime] NULL,
	[end] [datetime] NULL,
	[location] [nvarchar](50) NULL,
	[inserted_by] [int] NOT NULL,
	[inserted_date] [datetime] NOT NULL,
	[presenter] [nvarchar](50) NOT NULL,
	[description] [text] NULL,
	[previous_status] [int] NOT NULL,
	[status] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[eventid] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO