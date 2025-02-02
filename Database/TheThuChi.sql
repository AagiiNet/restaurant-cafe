USE [Karaoke]
GO
/****** Object:  Table [dbo].[LOAITHUCHI]    Script Date: 12/20/2014 4:09:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAITHUCHI](
	[LoaiThuChiID] [int] NOT NULL,
	[TenLoaiThuChi] [nvarchar](50) NULL,
 CONSTRAINT [PK_LOAITHUCHI] PRIMARY KEY CLUSTERED 
(
	[LoaiThuChiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THUCHI]    Script Date: 12/20/2014 4:09:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THUCHI](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[LoaiThuChiID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[GhiChu] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_THUCHI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[LOAITHUCHI] ([LoaiThuChiID], [TenLoaiThuChi]) VALUES (1, N'Phiếu thu')
INSERT [dbo].[LOAITHUCHI] ([LoaiThuChiID], [TenLoaiThuChi]) VALUES (2, N'Phiếu chi')
SET IDENTITY_INSERT [dbo].[THUCHI] ON 

INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [ThoiGian], [TongTien], [GhiChu], [Visual], [Deleted], [Edit]) VALUES (1, NULL, NULL, NULL, CAST(60000 AS Decimal(18, 0)), N'Mua dầu', 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [ThoiGian], [TongTien], [GhiChu], [Visual], [Deleted], [Edit]) VALUES (2, 1, 1, CAST(0x0000A407002F9C57 AS DateTime), CAST(60000 AS Decimal(18, 0)), N'Bán ve chai', 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [ThoiGian], [TongTien], [GhiChu], [Visual], [Deleted], [Edit]) VALUES (3, 1, 2, CAST(0x0000A4070031EC66 AS DateTime), CAST(2000 AS Decimal(18, 0)), N'Mua đá', 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [ThoiGian], [TongTien], [GhiChu], [Visual], [Deleted], [Edit]) VALUES (4, 1, 2, CAST(0x0000A407003201F9 AS DateTime), CAST(60000 AS Decimal(18, 0)), N'Mua cà phê', 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [ThoiGian], [TongTien], [GhiChu], [Visual], [Deleted], [Edit]) VALUES (5, 1, 1, CAST(0x0000A40700432A78 AS DateTime), CAST(90000 AS Decimal(18, 0)), N'Lừa đảo', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[THUCHI] OFF
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[THUCHI]  WITH CHECK ADD  CONSTRAINT [FK_THUCHI_LOAITHUCHI] FOREIGN KEY([LoaiThuChiID])
REFERENCES [dbo].[LOAITHUCHI] ([LoaiThuChiID])
GO
ALTER TABLE [dbo].[THUCHI] CHECK CONSTRAINT [FK_THUCHI_LOAITHUCHI]
GO
ALTER TABLE [dbo].[THUCHI]  WITH CHECK ADD  CONSTRAINT [FK_THUCHI_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[THUCHI] CHECK CONSTRAINT [FK_THUCHI_NHANVIEN]
GO
