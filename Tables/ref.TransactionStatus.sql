USE [DenverChessClub-Test]
GO

/****** Object:  Table [dbo].[ref.TransactionStatus]    Script Date: 8/12/2016 8:50:32 AM ******/
DROP TABLE [dbo].[ref.TransactionStatus]
GO

/****** Object:  Table [dbo].[ref.TransactionStatus]    Script Date: 8/12/2016 8:50:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ref.TransactionStatus](
	[id] [tinyint] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[status] [nchar](50) NOT NULL,
	[description] [nvarchar](50) NOT NULL,
	[inserted_by] [int] NULL,
	[inserted_date] [datetime] NULL
)

GO

INSERT INTO [dbo].[ref.TransactionStatus]
	([status], [description], [inserted_by], [inserted_date])
VALUES
	('new', 'New', 1001, GETUTCDATE()),
	('flagged', 'Flagged', 1001, GETUTCDATE()),
	('rejected', 'Rejected', 1001, GETUTCDATE()),
	('removed', 'Removed', 1001, GETUTCDATE()),
	('replaced', 'Replaced', 1001, GETUTCDATE()),
	('void', 'Did not exist', 1001, GETUTCDATE())

SELECT * FROM [dbo].[ref.TransactionStatus] ORDER BY id ASC;

GO