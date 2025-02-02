USE [Karaoke]
GO
ALTER TABLE [dbo].[THUCHI] DROP CONSTRAINT [FK_THUCHI_NHANVIEN]
GO
ALTER TABLE [dbo].[THUCHI] DROP CONSTRAINT [FK_THUCHI_LOAITHUCHI]
GO
ALTER TABLE [dbo].[CHITIETTHUCHI] DROP CONSTRAINT [FK_CHITIETTHUCHI_THUCHI]
GO
ALTER TABLE [dbo].[THUCHI] DROP CONSTRAINT [DF_THUCHI_Edit]
GO
ALTER TABLE [dbo].[THUCHI] DROP CONSTRAINT [DF_THUCHI_Deleted]
GO
ALTER TABLE [dbo].[THUCHI] DROP CONSTRAINT [DF_THUCHI_Visual]
GO
ALTER TABLE [dbo].[THUCHI] DROP CONSTRAINT [DF_THUCHI_TongTien]
GO
/****** Object:  Table [dbo].[THUCHI]    Script Date: 12/28/2014 11:55:09 PM ******/
DROP TABLE [dbo].[THUCHI]
GO
/****** Object:  Table [dbo].[CHITIETTHUCHI]    Script Date: 12/28/2014 11:55:09 PM ******/
DROP TABLE [dbo].[CHITIETTHUCHI]
GO
/****** Object:  Table [dbo].[CHITIETTHUCHI]    Script Date: 12/28/2014 11:55:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETTHUCHI](
	[ChiTietThuChiID] [int] IDENTITY(1,1) NOT NULL,
	[ThuChiID] [int] NULL,
	[GhiChu] [nvarchar](255) NULL,
	[SoTien] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_CHITIETTHUCHI] PRIMARY KEY CLUSTERED 
(
	[ChiTietThuChiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THUCHI]    Script Date: 12/28/2014 11:55:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THUCHI](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[LoaiThuChiID] [int] NULL,
	[NgayGhiSo] [datetime] NULL,
	[NgayChungTu] [datetime] NULL,
	[LyDo] [nvarchar](255) NULL,
	[NguoiThuNop] [nvarchar](255) NULL,
	[GhiChu] [nvarchar](255) NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_THUCHI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[THUCHI] ON 

INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (1, NULL, NULL, NULL, NULL, N'Mua dầu', NULL, NULL, CAST(60000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (2, 1, 1, CAST(0x0000A407002F9C57 AS DateTime), NULL, N'Bán ve chai', NULL, NULL, CAST(60000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (3, 1, 2, CAST(0x0000A4070031EC66 AS DateTime), NULL, N'Mua đá', NULL, NULL, CAST(2000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (4, 1, 2, CAST(0x0000A407003201F9 AS DateTime), NULL, N'Mua cà phê', NULL, NULL, CAST(60000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (5, 1, 1, CAST(0x0000A40700432A78 AS DateTime), NULL, N'Lừa đảo', NULL, NULL, CAST(90000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (6, 1, 1, CAST(0x0000A409000E6951 AS DateTime), NULL, N'khoa tran', NULL, NULL, CAST(100 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (7, 1, 2, CAST(0x0000A409000E805E AS DateTime), NULL, N'abc', NULL, NULL, CAST(120000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (8, 1, 1, NULL, NULL, N'', N'', N'', CAST(0 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[THUCHI] ([ID], [NhanVienID], [LoaiThuChiID], [NgayGhiSo], [NgayChungTu], [LyDo], [NguoiThuNop], [GhiChu], [TongTien], [Visual], [Deleted], [Edit]) VALUES (9, 1, 1, CAST(0x0000A40F018265BC AS DateTime), CAST(0x0000A40F018265A5 AS DateTime), N'Thu tiền điện', N'Tiến', N'', CAST(90000 AS Decimal(18, 0)), 1, 0, 0)
SET IDENTITY_INSERT [dbo].[THUCHI] OFF
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETTHUCHI]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETTHUCHI_THUCHI] FOREIGN KEY([ThuChiID])
REFERENCES [dbo].[THUCHI] ([ID])
GO
ALTER TABLE [dbo].[CHITIETTHUCHI] CHECK CONSTRAINT [FK_CHITIETTHUCHI_THUCHI]
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
