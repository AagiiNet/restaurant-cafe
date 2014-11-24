USE [master]
GO
/****** Object:  Database [Karaoke]    Script Date: 11/25/2014 3:53:45 AM ******/
CREATE DATABASE [Karaoke] ON  PRIMARY 
( NAME = N'Karaoke', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Karaoke.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Karaoke_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Karaoke_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Karaoke].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Karaoke] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Karaoke] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Karaoke] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Karaoke] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Karaoke] SET ARITHABORT OFF 
GO
ALTER DATABASE [Karaoke] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Karaoke] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Karaoke] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Karaoke] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Karaoke] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Karaoke] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Karaoke] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Karaoke] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Karaoke] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Karaoke] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Karaoke] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Karaoke] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Karaoke] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Karaoke] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Karaoke] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Karaoke] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Karaoke] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Karaoke] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Karaoke] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Karaoke] SET  MULTI_USER 
GO
ALTER DATABASE [Karaoke] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Karaoke] SET DB_CHAINING OFF 
GO
USE [Karaoke]
GO
/****** Object:  StoredProcedure [dbo].[SP_Login_NhanVien]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_Login_NhanVien](@TenDangNhap varchar(50), @MatKhau varchar(255))
As
 Select * From NHANVIEN Where TenDangNhap = @TenDangNhap And MatKhau = @MatKhau;







GO
/****** Object:  StoredProcedure [dbo].[SP_SAPXEP_KICHTHUOCMON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_SAPXEP_KICHTHUOCMON](@MonID int)
As
Begin
	DECLARE @KichThuocMonID int, @SapXep int = 1;
	DECLARE cursorKichThuocMon CURSOR FOR 
	SELECT KichThuocMonID FROM MENUKICHTHUOCMON Where MonID = @MonID Order by SapXep
	Open cursorKichThuocMon
	FETCH NEXT FROM cursorKichThuocMon INTO @KichThuocMonID 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		Update MENUKICHTHUOCMON Set SapXep = @SapXep Where KichThuocMonID = @KichThuocMonID;
		Set @SapXep = @SapXep + 1;
		FETCH NEXT FROM cursorKichThuocMon INTO @KichThuocMonID
	END		
	CLOSE cursorKichThuocMon
	DEALLOCATE cursorKichThuocMon
	Update MENUMON Set SapXepKichThuocMon = @SapXep Where MonID = @MonID;
	
End



GO
/****** Object:  StoredProcedure [dbo].[SP_SAPXEP_MENUMON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_SAPXEP_MENUMON](@NhomID int)
As
Begin
	DECLARE @MonID int, @SapXep int;
	SET @SapXep = 1;
	DECLARE cursorMon CURSOR 
	FOR 
	SELECT MonID FROM MENUMON Where NhomID = @NhomID And deleted = 0 Order by SapXep
	Open cursorMon
	FETCH NEXT FROM cursorMon INTO @MonID 
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		Update MENUMON Set SapXep = @SapXep Where MonID = @MonID;		
		Set @SapXep = @SapXep + 1;
		FETCH NEXT FROM cursorMon INTO @MonID
	END		
	CLOSE cursorMon
	DEALLOCATE cursorMon		
	Update MENUNHOM Set SapXepMon = @SapXep Where NhomID = @NhomID;
End


GO
/****** Object:  StoredProcedure [dbo].[SP_SAPXEP_NHOM]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_SAPXEP_NHOM](@LoaiNhomID int)
AS
BEGIN
	DECLARE @NhomID int, @SapXep int = 1;
	DECLARE cursorNhom CURSOR FOR 
	SELECT NhomID FROM MENUNHOM Where LoaiNhomID = @LoaiNhomID Order by SapXep
	Open cursorNhom
	FETCH NEXT FROM cursorNhom INTO @NhomID 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		Update MENUNHOM Set SapXep = @SapXep Where NhomID = @NhomID
		Set @SapXep = @SapXep + 1;
		FETCH NEXT FROM cursorNhom INTO @NhomID
	END	
	CLOSE cursorNhom
	DEALLOCATE cursorNhom		
	Update MENULOAINHOM Set SapXepNhom = @SapXep Where LoaiNhomID = @LoaiNhomID;
END


GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SOLUONGKICHTHUOCMON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_SOLUONGKICHTHUOCMON](@MonID int)
As
BEGIN
	DECLARE @SoLuongKichThuocMon int;
	Select @SoLuongKichThuocMon = Count(*) From MENUKICHTHUOCMON Where MonID = @MonID And Deleted = 0 And Visual = 1;
	Update MENUMON Set SoLuongKichThuocMon = @SoLuongKichThuocMon Where MonID = @MonID;
END








GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SOLUONGMON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_SOLUONGMON](@NhomID int)
As
BEGIN
	DECLARE @SoLuongMon int;
	Select @SoLuongMon = Count(*) From MENUMON Where NhomID = @NhomID And SoLuongKichThuocMon > 0 And Deleted = 0 And Visual = 1;
	Update MENUNHOM Set SoLuongMon = @SoLuongMon Where NhomID = @NhomID;
END








GO
/****** Object:  Table [dbo].[BAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BAN](
	[BanID] [int] IDENTITY(1,1) NOT NULL,
	[TenBan] [nvarchar](50) NULL,
	[KhuID] [int] NULL,
	[LocationX] [decimal](18, 10) NOT NULL,
	[LocationY] [decimal](18, 10) NOT NULL,
	[Height] [decimal](18, 10) NOT NULL,
	[Width] [decimal](18, 10) NOT NULL,
	[Hinh] [image] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_Table] PRIMARY KEY CLUSTERED 
(
	[BanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BANHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BANHANG](
	[BanHangID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[BanID] [int] NULL,
	[TrangThaiID] [int] NULL,
	[NgayBan] [datetime] NULL,
	[MaHoaDon] [varchar](20) NULL,
	[TienMat] [decimal](18, 0) NOT NULL,
	[TheID] [int] NULL,
	[TienThe] [decimal](18, 0) NOT NULL,
	[TienTraLai] [decimal](18, 0) NOT NULL,
	[TienGiam] [decimal](18, 0) NOT NULL,
	[ChietKhau] [decimal](18, 0) NOT NULL,
	[TienBo] [decimal](18, 0) NOT NULL,
	[PhiDichVu] [decimal](18, 0) NOT NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[KhachHangID] [int] NULL,
	[TienKhacHang] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_BANHANG] PRIMARY KEY CLUSTERED 
(
	[BanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAIDATTHONGTINCONGTY]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAIDATTHONGTINCONGTY](
	[ID] [int] NOT NULL,
	[TenCongTy] [nvarchar](255) NOT NULL,
	[TenVietTat] [nvarchar](50) NOT NULL,
	[NguoiDaiDien] [nvarchar](50) NOT NULL,
	[DiaChi] [nvarchar](255) NOT NULL,
	[DienThoaiBan] [varchar](50) NOT NULL,
	[DienThoaiDiDong] [varchar](50) NOT NULL,
	[Fax] [varchar](50) NOT NULL,
	[MaSoThue] [varchar](50) NOT NULL,
	[Email] [varchar](255) NOT NULL,
	[Hinh] [image] NULL,
	[Logo] [image] NULL,
 CONSTRAINT [PK_CAIDATTHONGTINCONGTY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CHINHKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHINHKHO](
	[ChinhKhoID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[KhoID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
 CONSTRAINT [PK_CHINHKHO] PRIMARY KEY CLUSTERED 
(
	[ChinhKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETBANHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETBANHANG](
	[ChiTietBanHangID] [int] IDENTITY(1,1) NOT NULL,
	[BanHangID] [int] NULL,
	[TonKhoID] [int] NULL,
	[SoLuongBan] [int] NOT NULL,
	[GiaBan] [decimal](18, 0) NOT NULL,
	[ThanhTien] [decimal](18, 0) NOT NULL,
	[KichThuocMonID] [int] NULL,
	[NhanVienID] [int] NULL,
 CONSTRAINT [PK_CHITIETBANHANG] PRIMARY KEY CLUSTERED 
(
	[ChiTietBanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETCHINHKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETCHINHKHO](
	[ChiTietChiKhoID] [int] IDENTITY(1,1) NOT NULL,
	[ChinhKhoID] [int] NULL,
	[TonKhoID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETCHINHKHO] PRIMARY KEY CLUSTERED 
(
	[ChiTietChiKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETCHUYENKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETCHUYENKHO](
	[ChiTietChuyenKhoID] [int] NOT NULL,
	[ChuyenKhoID] [int] NULL,
	[TonKhoID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETCHUYENKHO] PRIMARY KEY CLUSTERED 
(
	[ChiTietChuyenKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETGOPBAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETGOPBAN](
	[ChiTietGopBanID] [int] IDENTITY(1,1) NOT NULL,
	[GopBanID] [int] NULL,
	[BanID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETGOPBAN] PRIMARY KEY CLUSTERED 
(
	[ChiTietGopBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETHUKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETHUKHO](
	[ChiTietHuKhoID] [int] IDENTITY(1,1) NOT NULL,
	[HuKhoID] [int] NULL,
	[MonID] [int] NULL,
	[DonViID] [int] NULL,
	[DonViTinh] [int] NOT NULL,
	[LoaiBanID] [int] NULL,
	[SoLuong] [int] NOT NULL,
	[Gia] [decimal](18, 0) NOT NULL,
	[TonKhoID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETHUKHO] PRIMARY KEY CLUSTERED 
(
	[ChiTietHuKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETLICHSUBANHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETLICHSUBANHANG](
	[ChiTietLichSuBanHangID] [int] IDENTITY(1,1) NOT NULL,
	[LichSuBanHangID] [int] NULL,
	[KichThuocMonID] [int] NULL,
	[TonKhoID] [int] NULL,
	[SoLuong] [decimal](18, 0) NOT NULL,
	[GiaBan] [decimal](18, 0) NOT NULL,
	[ThanhTien] [decimal](18, 0) NOT NULL,
	[TrangThai] [int] NULL,
 CONSTRAINT [PK_CHITIETLICHSUBANHANG] PRIMARY KEY CLUSTERED 
(
	[ChiTietLichSuBanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETMATKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETMATKHO](
	[ChiTietMatKho] [int] IDENTITY(1,1) NOT NULL,
	[Gia] [decimal](18, 0) NOT NULL,
	[TonKhoID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETMATKHO] PRIMARY KEY CLUSTERED 
(
	[ChiTietMatKho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETNHAPKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETNHAPKHO](
	[ChiTietNhapKhoID] [int] IDENTITY(1,1) NOT NULL,
	[NhapKhoID] [int] NULL,
	[TonKhoID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETNHAPKHO] PRIMARY KEY CLUSTERED 
(
	[ChiTietNhapKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETQUYEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETQUYEN](
	[ChiTietQuyenID] [int] IDENTITY(1,1) NOT NULL,
	[QuyenID] [int] NULL,
	[ChucNangID] [int] NULL,
	[NhomChucNangID] [int] NOT NULL,
	[ChoPhep] [bit] NOT NULL,
	[DangNhap] [bit] NOT NULL,
	[Them] [bit] NOT NULL,
	[Xoa] [bit] NOT NULL,
	[Sua] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETQUYEN] PRIMARY KEY CLUSTERED 
(
	[ChiTietQuyenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETTACHBAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETTACHBAN](
	[ChiTietTachBanID] [int] IDENTITY(1,1) NOT NULL,
	[BanID] [int] NULL,
	[TachBanID] [int] NULL,
	[BanHangID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHITIETTACHBAN] PRIMARY KEY CLUSTERED 
(
	[ChiTietTachBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHUCNANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHUCNANG](
	[ChucNangID] [int] NOT NULL,
	[TenChucNang] [nvarchar](255) NULL,
	[NhomChucNangID] [int] NOT NULL,
	[ChoPhep] [bit] NOT NULL,
	[DangNhap] [bit] NOT NULL,
	[Them] [bit] NOT NULL,
	[Xoa] [bit] NOT NULL,
	[Sua] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHUCNANG] PRIMARY KEY CLUSTERED 
(
	[ChucNangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHUYENBAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHUYENBAN](
	[ChuyenBanID] [int] IDENTITY(1,1) NOT NULL,
	[TuBanID] [int] NULL,
	[DenBanID] [int] NULL,
	[BanHangID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[NhanVienID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHUYENBAN] PRIMARY KEY CLUSTERED 
(
	[ChuyenBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHUYENKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHUYENKHO](
	[ChuyenKhoID] [int] IDENTITY(1,1) NOT NULL,
	[KhoDiID] [int] NULL,
	[KhoDenID] [int] NULL,
	[NgayChuyen] [datetime] NULL,
	[NhanVienID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_CHUYENKHO] PRIMARY KEY CLUSTERED 
(
	[ChuyenKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DINHLUONG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DINHLUONG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KichThuocMonChinhID] [int] NOT NULL,
	[MonID] [int] NULL,
	[LoaiBanID] [int] NULL,
	[KichThuocBan] [int] NOT NULL,
	[SoLuong] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_DINHLUONG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DONVI]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DONVI](
	[DonViID] [int] IDENTITY(1,1) NOT NULL,
	[TenDonVi] [nvarchar](50) NULL,
	[Visual] [int] NOT NULL,
	[Deleted] [int] NOT NULL,
	[Edit] [int] NOT NULL,
 CONSTRAINT [PK_DONVI] PRIMARY KEY CLUSTERED 
(
	[DonViID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GIAODIENCHUCNANGBANHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAODIENCHUCNANGBANHANG](
	[ID] [int] NOT NULL,
	[ChucNangID] [int] NULL,
	[Hinh] [image] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_GIAODIENCHUCNANGBANHANG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GOPBAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GOPBAN](
	[GopBanID] [int] IDENTITY(1,1) NOT NULL,
	[GopThanhBanID] [int] NULL,
	[NhanVienID] [int] NULL,
	[BanHangID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_GOPBAN] PRIMARY KEY CLUSTERED 
(
	[GopBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HOPDUNGTIEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOPDUNGTIEN](
	[ID] [int] NOT NULL,
	[NhanVienID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[LoaiHopDungTienID] [int] NULL,
	[MayInID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_HOPDUNGTIEN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HUKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HUKHO](
	[HuKhoID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[KhoID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_HUKHO] PRIMARY KEY CLUSTERED 
(
	[HuKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HUYHOADON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HUYHOADON](
	[HuyHoaDonID] [int] IDENTITY(1,1) NOT NULL,
	[BanHangID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[NhanVienID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_HUYHOADON] PRIMARY KEY CLUSTERED 
(
	[HuyHoaDonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[INHOADON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INHOADON](
	[InHoaDonID] [int] NOT NULL,
	[BanHangID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[NhanVienID] [int] NULL,
	[MayInID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_INHOADON] PRIMARY KEY CLUSTERED 
(
	[InHoaDonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[KhachHangID] [int] IDENTITY(1,1) NOT NULL,
	[TenKhachHang] [nvarchar](255) NULL,
	[LoaiKhachHangID] [int] NULL,
	[DiaChi] [nvarchar](255) NULL,
	[Mobile] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[DuNo] [decimal](18, 0) NOT NULL,
	[DuNoToiThieu] [decimal](18, 0) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_KHACHHANG] PRIMARY KEY CLUSTERED 
(
	[KhachHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHO](
	[KhoID] [int] IDENTITY(1,1) NOT NULL,
	[TenKho] [nvarchar](100) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK__STOCKWAR__3214EC2798F089C3] PRIMARY KEY CLUSTERED 
(
	[KhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KHU]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHU](
	[KhuID] [int] IDENTITY(1,1) NOT NULL,
	[TenKhu] [nvarchar](50) NULL,
	[LoaiGiaID] [int] NULL,
	[MacDinhSoDoBan] [bit] NOT NULL,
	[Hinh] [image] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_GroupTable] PRIMARY KEY CLUSTERED 
(
	[KhuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHBIEUDINHKY]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHBIEUDINHKY](
	[LichBieuDinhKyID] [int] IDENTITY(1,1) NOT NULL,
	[TenLichBieu] [nvarchar](255) NULL,
	[LoaiGiaID] [int] NOT NULL,
	[TheLoaiID] [int] NOT NULL,
	[TenHienThi] [nvarchar](255) NULL,
	[GioBatDau] [time](3) NULL,
	[GioKetThuc] [time](3) NULL,
	[UuTien] [int] NOT NULL,
	[GiaTriBatDau] [int] NOT NULL,
	[GiaTriKetThuc] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHBIEU] PRIMARY KEY CLUSTERED 
(
	[LichBieuDinhKyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHBIEUKHONGDINHKY]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHBIEUKHONGDINHKY](
	[LichBieuKhongDinhKyID] [int] IDENTITY(1,1) NOT NULL,
	[TenLichBieu] [nvarchar](255) NULL,
	[NgayBatDau] [datetime] NULL,
	[NgayKetThuc] [datetime] NULL,
	[GioBatDau] [time](4) NULL,
	[GioKetThuc] [time](4) NULL,
	[LoaiGiaID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHBIEUKHONGDINHKY] PRIMARY KEY CLUSTERED 
(
	[LichBieuKhongDinhKyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHSUBANHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUBANHANG](
	[LichSuBanHangID] [int] IDENTITY(1,1) NOT NULL,
	[BanHangID] [int] NULL,
	[NhanVienID] [int] NULL,
	[NgayBan] [datetime] NULL,
	[InNhaBep] [bit] NOT NULL,
 CONSTRAINT [PK_LICHSUBANHANG] PRIMARY KEY CLUSTERED 
(
	[LichSuBanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHSUCONGNO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUCONGNO](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KhachHangID] [int] NULL,
	[NgayPhatSinh] [datetime] NULL,
	[SoTienPhatSinh] [decimal](18, 0) NOT NULL,
	[TienMat] [decimal](18, 0) NOT NULL,
	[TienThe] [decimal](18, 0) NOT NULL,
	[TheID] [int] NULL,
	[BanHangID] [int] NULL,
	[DuNoCuoi] [decimal](18, 0) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHSUCONGNO] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHSUDANGNHAP]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUDANGNHAP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHSUDANGNHAP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAIBAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIBAN](
	[LoaiBanID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiBan] [nvarchar](100) NULL,
	[KichThuocBan] [int] NOT NULL,
	[DonViID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK__LOAIBAN__1E8B08FEFDCB7945] PRIMARY KEY CLUSTERED 
(
	[LoaiBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAIHOPDUNGTIEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIHOPDUNGTIEN](
	[LoaiHopDungTienID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiHopDungTien] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LOAIHOPDUNGTIEN] PRIMARY KEY CLUSTERED 
(
	[LoaiHopDungTienID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAIKHACHHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIKHACHHANG](
	[LoaiKhachHangID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiKhachHang] [nvarchar](50) NULL,
	[PhanTramGiamGia] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LOAIKHACHHANG] PRIMARY KEY CLUSTERED 
(
	[LoaiKhachHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAILICHBIEU]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAILICHBIEU](
	[LoaiLichBieuID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiLichBieu] [nvarchar](50) NULL,
	[TheLoaiID] [int] NULL,
	[GiaTri] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHBIEUTYPE] PRIMARY KEY CLUSTERED 
(
	[LoaiLichBieuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAINHANVIEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAINHANVIEN](
	[LoaiNhanVienID] [int] NOT NULL,
	[TenLoaiNhanVien] [nvarchar](50) NULL,
	[CapDo] [int] NOT NULL,
	[Edit] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_LOAINHANVIEN] PRIMARY KEY CLUSTERED 
(
	[LoaiNhanVienID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAIPHATSINH]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIPHATSINH](
	[LoaiPhatSinhID] [int] IDENTITY(1,1) NOT NULL,
	[Ten] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LOAIPHATSINH] PRIMARY KEY CLUSTERED 
(
	[LoaiPhatSinhID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAITHONGTIN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAITHONGTIN](
	[LoaiThongTinID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiThongTin] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LOAITHONGTIN] PRIMARY KEY CLUSTERED 
(
	[LoaiThongTinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MATKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MATKHO](
	[MatKhoID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[KhoID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_MATKHO] PRIMARY KEY CLUSTERED 
(
	[MatKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MAYIN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAYIN](
	[MayInID] [int] IDENTITY(1,1) NOT NULL,
	[TenMayIn] [nvarchar](255) NULL,
	[TieuDeIn] [nvarchar](255) NULL,
	[HopDungTien] [bit] NOT NULL,
	[SoLanIn] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
	[MayInHoaDon] [bit] NOT NULL,
 CONSTRAINT [PK_PrinerVitual] PRIMARY KEY CLUSTERED 
(
	[MayInID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUGIA]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUGIA](
	[GiaID] [int] IDENTITY(1,1) NOT NULL,
	[KichThuocMonID] [int] NULL,
	[Gia] [decimal](18, 0) NOT NULL,
	[LoaiGiaID] [int] NULL,
 CONSTRAINT [PK__MENUPRIC__4957584FFDB27387] PRIMARY KEY CLUSTERED 
(
	[GiaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUITEMMAYIN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUITEMMAYIN](
	[MonID] [int] NOT NULL,
	[MayInID] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_MENUITEMPRINTER] PRIMARY KEY CLUSTERED 
(
	[MonID] ASC,
	[MayInID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUKHUYENMAI]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUKHUYENMAI](
	[KhuyenMaiID] [int] IDENTITY(1,1) NOT NULL,
	[KichThuocMonID] [int] NULL,
	[KichThuocMonTang] [int] NOT NULL,
	[TenKhuyenMai] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_MENUKHUYENMAI] PRIMARY KEY CLUSTERED 
(
	[KhuyenMaiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUKICHTHUOCMON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUKICHTHUOCMON](
	[KichThuocMonID] [int] IDENTITY(1,1) NOT NULL,
	[MonID] [int] NULL,
	[TenLoaiBan] [nvarchar](50) NULL,
	[LoaiBanID] [int] NULL,
	[DonVi] [int] NULL,
	[GiaBanMacDinh] [decimal](18, 0) NOT NULL,
	[ThoiGia] [bit] NOT NULL,
	[KichThuocLoaiBan] [int] NOT NULL,
	[SoLuongBanBan] [int] NOT NULL,
	[TonKhoToiThieu] [int] NOT NULL,
	[TonKhoToiDa] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
	[SapXep] [int] NOT NULL,
 CONSTRAINT [PK_MENUKICHTHUOCMON] PRIMARY KEY CLUSTERED 
(
	[KichThuocMonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENULOAIGIA]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENULOAIGIA](
	[LoaiGiaID] [int] IDENTITY(1,1) NOT NULL,
	[Ten] [nvarchar](100) NULL,
	[DienGiai] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK__MENUPRIC__3214EC277941E28A] PRIMARY KEY CLUSTERED 
(
	[LoaiGiaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENULOAINHOM]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENULOAINHOM](
	[LoaiNhomID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiNhom] [nvarchar](100) NULL,
	[SapXepNhom] [int] NULL,
 CONSTRAINT [PK__MENUGROU__3214EC272A95EA21] PRIMARY KEY CLUSTERED 
(
	[LoaiNhomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUMON]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUMON](
	[MonID] [int] IDENTITY(1,1) NOT NULL,
	[TenNgan] [nvarchar](100) NOT NULL,
	[TenDai] [nvarchar](255) NULL,
	[NhomID] [int] NULL,
	[Gia] [decimal](18, 0) NOT NULL,
	[GST] [int] NOT NULL,
	[MayIn] [int] NOT NULL,
	[SapXep] [int] NOT NULL,
	[SapXepKichThuocMon] [int] NOT NULL,
	[GiamGia] [int] NOT NULL,
	[Hinh] [image] NULL,
	[SoLuongKichThuocMon] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK__MENUITEM__727E83EBE6A88A96] PRIMARY KEY CLUSTERED 
(
	[MonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUNHOM]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUNHOM](
	[NhomID] [int] IDENTITY(1,1) NOT NULL,
	[TenNgan] [nvarchar](100) NULL,
	[TenDai] [nvarchar](255) NULL,
	[LoaiNhomID] [int] NULL,
	[MayIn] [int] NOT NULL,
	[SapXep] [int] NOT NULL,
	[SapXepMon] [int] NOT NULL,
	[GiamGia] [int] NOT NULL,
	[Hinh] [image] NULL,
	[SoLuongMon] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK__MENUGROU__149AF30AA30A825B] PRIMARY KEY CLUSTERED 
(
	[NhomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NHACUNGCAP](
	[NhaCungCapID] [int] IDENTITY(1,1) NOT NULL,
	[MaSoThue] [varchar](50) NULL,
	[TenNhaCungCap] [nvarchar](255) NULL,
	[DiaChi] [nvarchar](255) NULL,
	[Mobile] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_NHACUNGCAP] PRIMARY KEY CLUSTERED 
(
	[NhaCungCapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[NhanVienID] [int] IDENTITY(1,1) NOT NULL,
	[TenDangNhap] [varchar](50) NULL,
	[TenNhanVien] [nvarchar](50) NULL,
	[MatKhau] [varchar](255) NULL,
	[LoaiNhanVienID] [int] NULL,
	[CapDo] [int] NOT NULL,
	[Edit] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_NHANVIEN] PRIMARY KEY CLUSTERED 
(
	[NhanVienID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NHAPKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHAPKHO](
	[NhapKhoID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[KhoID] [int] NULL,
	[NhaCungCapID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[TongTien] [decimal](18, 0) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_NHAPKHO] PRIMARY KEY CLUSTERED 
(
	[NhapKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NHOMCHUCNANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHOMCHUCNANG](
	[NhomChucNangID] [int] NOT NULL,
	[TenNhomChucNang] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_NHOMCHUCNANG] PRIMARY KEY CLUSTERED 
(
	[NhomChucNangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QUYEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUYEN](
	[MaQuyen] [int] IDENTITY(1,1) NOT NULL,
	[TenQuyen] [nvarchar](255) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_QUYEN] PRIMARY KEY CLUSTERED 
(
	[MaQuyen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QUYENNHANVIEN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUYENNHANVIEN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QuyenID] [int] NULL,
	[NhanVienID] [int] NULL,
	[Edit] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_QUYENNHANVIEN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TACHBAN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TACHBAN](
	[TachBanID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[BanID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_TACHBAN] PRIMARY KEY CLUSTERED 
(
	[TachBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THAMSO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[THAMSO](
	[BanHangKhongKho] [bit] NULL,
	[SoMay] [int] NOT NULL,
	[MayInHoaDon] [int] NOT NULL,
	[MaBaoVe] [varchar](255) NULL,
	[Logo] [image] NULL,
	[BanChieuNgang] [decimal](18, 10) NOT NULL,
	[BanChieuCao] [decimal](18, 10) NOT NULL,
 CONSTRAINT [PK_THAMSO] PRIMARY KEY CLUSTERED 
(
	[SoMay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[THE]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THE](
	[TheID] [int] IDENTITY(1,1) NOT NULL,
	[TenThe] [nvarchar](50) NULL,
	[ChietKhau] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_THE] PRIMARY KEY CLUSTERED 
(
	[TheID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THELOAILICHBIEU]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THELOAILICHBIEU](
	[TheLoaiID] [int] IDENTITY(1,1) NOT NULL,
	[TenTheLoai] [nvarchar](50) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_THELOAILICHBIEU] PRIMARY KEY CLUSTERED 
(
	[TheLoaiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THONGTIN]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THONGTIN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GiaTri] [nvarchar](255) NULL,
	[SapXep] [int] NOT NULL,
	[LoaiThongTinID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_THONGTIN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TONKHO]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TONKHO](
	[TonKhoID] [int] IDENTITY(1,1) NOT NULL,
	[KhoID] [int] NULL,
	[MonID] [int] NULL,
	[LoaiBanID] [int] NULL,
	[DonViID] [int] NULL,
	[DonViTinh] [int] NOT NULL,
	[PhatSinhTuTonKhoID] [int] NULL,
	[SoLuongNhap] [int] NOT NULL,
	[SoLuongTon] [int] NOT NULL,
	[NgaySanXuat] [datetime] NULL,
	[NgayHetHan] [datetime] NOT NULL,
	[GiaBan] [decimal](18, 0) NOT NULL,
	[GiaNhap] [decimal](18, 0) NOT NULL,
	[LoaiPhatSinhID] [int] NOT NULL,
	[SoLuongPhatSinh] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_TONKHO] PRIMARY KEY CLUSTERED 
(
	[TonKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TONKHOTONG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TONKHOTONG](
	[MonID] [int] NOT NULL,
	[KhoID] [int] NOT NULL,
	[DonViID] [int] NOT NULL,
	[TenMonBaoCao] [nvarchar](256) NULL,
	[SoLuongTon] [int] NOT NULL,
	[SoLuongBan] [int] NOT NULL,
	[SoLuongNhap] [int] NOT NULL,
	[SoLuongHu] [int] NOT NULL,
	[SoLuongDieuChinh] [int] NOT NULL,
	[SoLuongMat] [int] NOT NULL,
 CONSTRAINT [PK_TONKHOTONG] PRIMARY KEY CLUSTERED 
(
	[MonID] ASC,
	[KhoID] ASC,
	[DonViID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TRANGTHAI]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRANGTHAI](
	[TrangThaiID] [int] IDENTITY(1,1) NOT NULL,
	[TenTrangThai] [nvarchar](50) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_TRANGTHAI] PRIMARY KEY CLUSTERED 
(
	[TrangThaiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[BAOCAOLICHDANGNHAP]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOLICHDANGNHAP]
As
SELECT        TOP (100) l.ID, l.ThoiGian, nv.TenNhanVien, lnv.TenLoaiNhanVien
FROM            dbo.LICHSUDANGNHAP AS l INNER JOIN
                         dbo.NHANVIEN AS nv ON l.NhanVienID = nv.NhanVienID INNER JOIN
                         dbo.LOAINHANVIEN AS lnv ON lnv.LoaiNhanVienID = nv.LoaiNhanVienID
ORDER BY l.ThoiGian DESC




GO
/****** Object:  View [dbo].[BAOCAOLICHSUBANHANG]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[BAOCAOLICHSUBANHANG]
As
Select NV.TenNhanVien, B.TenBan, BH.NgayBan, BH.MaHoaDon, BH.TienMat, BH.TienThe, T.TenThe, KH.TenKhachHang, BH.TienKhacHang, BH.TienTraLai, BH.TienGiam, BH.ChietKhau, BH.TienBo, BH.PhiDichVu, BH.TongTien
	from BANHANG BH
	Left join NHANVIEN NV On BH.NhanVienID = NV.NhanVienID
	Left join THE T On BH.TheID = T.TheID
	Left join KHACHHANG KH On BH.KhachHangID = Kh.KhachHangID
	Left join BAN B On BH.BanID = B.BanID
	Where BH.TrangThaiID = 4


GO
/****** Object:  View [dbo].[BAOCAONGAY]    Script Date: 11/25/2014 3:53:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAY]
AS
SELECT * From BANHANG




GO
SET IDENTITY_INSERT [dbo].[BAN] ON 

INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (1, N'15A', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.0030000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (2, N'15B', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.1010000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (3, N'16A', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.1990000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (4, N'16B', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.2970000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (5, N'17A', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.3950000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (6, N'17B', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.4930000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (7, N'21A', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.5910000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (8, N'21B', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.6890000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (9, N'22A', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.7870000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (10, N'22B', 1, CAST(0.0159314000 AS Decimal(18, 10)), CAST(0.8850000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (11, N'C1', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.1990000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (12, N'C2', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.2970000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (13, N'C3', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.3950000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (14, N'C4', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.4930000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (15, N'C5', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.5910000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (16, N'C6', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.6890000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (17, N'C7', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.7870000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (18, N'C8', 1, CAST(0.2732840000 AS Decimal(18, 10)), CAST(0.8850000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (19, N'1', 1, CAST(0.9019610000 AS Decimal(18, 10)), CAST(0.4000000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (20, N'2', 1, CAST(0.9019610000 AS Decimal(18, 10)), CAST(0.5300000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (21, N'3', 1, CAST(0.9019610000 AS Decimal(18, 10)), CAST(0.6600000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (22, N'4', 1, CAST(0.9019610000 AS Decimal(18, 10)), CAST(0.7900000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (23, N'5', 1, CAST(0.7720590000 AS Decimal(18, 10)), CAST(0.5300000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (24, N'6', 1, CAST(0.7720590000 AS Decimal(18, 10)), CAST(0.6600000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (25, N'7', 1, CAST(0.7720590000 AS Decimal(18, 10)), CAST(0.7900000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (26, N'8', 1, CAST(0.6250000000 AS Decimal(18, 10)), CAST(0.6600000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (27, N'9', 1, CAST(0.6250000000 AS Decimal(18, 10)), CAST(0.7900000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (28, N'LC1', 1, CAST(0.6176470000 AS Decimal(18, 10)), CAST(0.0030000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (29, N'LC2', 1, CAST(0.6176470000 AS Decimal(18, 10)), CAST(0.1010000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (30, N'LC3', 1, CAST(0.7291670000 AS Decimal(18, 10)), CAST(0.0030000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (31, N'LC4', 1, CAST(0.7291670000 AS Decimal(18, 10)), CAST(0.1010000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (32, N'LC5', 1, CAST(0.8419120000 AS Decimal(18, 10)), CAST(0.0030000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (33, N'LC6', 1, CAST(0.8419120000 AS Decimal(18, 10)), CAST(0.1010000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (34, N'F1', 1, CAST(0.3725490000 AS Decimal(18, 10)), CAST(0.1110000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (35, N'F2', 1, CAST(0.3725490000 AS Decimal(18, 10)), CAST(0.0130000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (36, N'F3', 1, CAST(0.1715690000 AS Decimal(18, 10)), CAST(0.1110000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (37, N'F4', 1, CAST(0.1715690000 AS Decimal(18, 10)), CAST(0.0130000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (38, N'T1', 1, CAST(0.1176470000 AS Decimal(18, 10)), CAST(0.7870000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (39, N'T2', 1, CAST(0.1176470000 AS Decimal(18, 10)), CAST(0.5910000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (40, N'T3', 1, CAST(0.1176470000 AS Decimal(18, 10)), CAST(0.3950000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (41, N'B1', 1, CAST(0.5049020000 AS Decimal(18, 10)), CAST(0.6670000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (42, N'B2', 1, CAST(0.5049020000 AS Decimal(18, 10)), CAST(0.4710000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (43, N'B3', 1, CAST(0.5049020000 AS Decimal(18, 10)), CAST(0.2750000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[BAN] OFF
INSERT [dbo].[CAIDATTHONGTINCONGTY] ([ID], [TenCongTy], [TenVietTat], [NguoiDaiDien], [DiaChi], [DienThoaiBan], [DienThoaiDiDong], [Fax], [MaSoThue], [Email], [Hinh], [Logo]) VALUES (0, N'Trần Minh Tiến', N'TMT', N'Trần Minh Tiến', N'Chưa có địa chỉ', N'(08) 3999 888', N'0909 999 888', N'(08) 3999 999', N'Không có', N'Không có', NULL, NULL)
SET IDENTITY_INSERT [dbo].[CHITIETNHAPKHO] ON 

INSERT [dbo].[CHITIETNHAPKHO] ([ChiTietNhapKhoID], [NhapKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (13, 20, 25, 1, 0, 0)
INSERT [dbo].[CHITIETNHAPKHO] ([ChiTietNhapKhoID], [NhapKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (14, 21, 26, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[CHITIETNHAPKHO] OFF
SET IDENTITY_INSERT [dbo].[CHITIETQUYEN] ON 

INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (109, 6, 101, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (110, 6, 102, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (111, 6, 103, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (112, 6, 104, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (113, 6, 105, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (114, 6, 106, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (115, 6, 107, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (116, 6, 201, 2, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (117, 6, 301, 3, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (118, 6, 302, 3, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (119, 6, 401, 4, 1, 0, 1, 1, 1, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (120, 6, 501, 5, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (121, 6, 502, 5, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (122, 6, 601, 6, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (123, 6, 701, 7, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (124, 6, 702, 7, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (125, 6, 703, 7, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (126, 6, 704, 7, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (127, 6, 705, 7, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (128, 6, 706, 7, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (129, 6, 901, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (130, 6, 902, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (131, 6, 903, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (132, 6, 904, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (133, 6, 905, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (134, 6, 906, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (135, 6, 907, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (136, 6, 1001, 10, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (137, 6, 1101, 11, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (138, 6, 1102, 11, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (139, 6, 1301, 13, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (140, 6, 1401, 14, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (141, 6, 1501, 15, 0, 0, 0, 0, 0, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[CHITIETQUYEN] OFF
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (101, N'Tính tiền', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (102, N'Lưu hóa đơn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (103, N'Thay đổi giá', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (104, N'Chuyển bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (105, N'Tách bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (106, N'Xóa món', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (107, N'Xóa toàn bộ món', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (201, N'Quản lý nhân viên', 2, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (301, N'Cài đặt máy in', 3, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (302, N'Cài đặt thực đơn máy in', 3, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (401, N'Quản lý thực đơn', 4, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (501, N'Khách hàng', 5, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (502, N'Loại khách hàng', 5, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (601, N'Quản lý thu chi', 6, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (701, N'Loại giá', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (702, N'Lịch biểu định kỳ', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (703, N'Lịch biểu không định kỳ', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (704, N'Danh sách bán', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (705, N'Danh sách giá', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (706, N'Khuyễn mãi', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (901, N'Tồn kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (902, N'Nhà kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (903, N'Nhập kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (904, N'Hư kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (905, N'Mất kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (906, N'Chuyển kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (907, N'Chỉnh kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1001, N'Định lượng', 10, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1101, N'Quản lý khu', 11, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1102, N'Quản lý bàn', 11, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1301, N'Quản lý thẻ', 13, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1401, N'Cài đặt chương trình', 14, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1501, N'Thông tin phần mềm', 15, 1, 1, 0, 0, 0, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[DINHLUONG] ON 

INSERT [dbo].[DINHLUONG] ([ID], [KichThuocMonChinhID], [MonID], [LoaiBanID], [KichThuocBan], [SoLuong], [Visual], [Deleted], [Edit]) VALUES (3, 4, 30, 1, 10, 0, 1, 0, 1)
INSERT [dbo].[DINHLUONG] ([ID], [KichThuocMonChinhID], [MonID], [LoaiBanID], [KichThuocBan], [SoLuong], [Visual], [Deleted], [Edit]) VALUES (4, 4, 37, 2, 100, 0, 1, 0, 1)
INSERT [dbo].[DINHLUONG] ([ID], [KichThuocMonChinhID], [MonID], [LoaiBanID], [KichThuocBan], [SoLuong], [Visual], [Deleted], [Edit]) VALUES (5, 4, 23, 2, 15, 0, 1, 0, 1)
INSERT [dbo].[DINHLUONG] ([ID], [KichThuocMonChinhID], [MonID], [LoaiBanID], [KichThuocBan], [SoLuong], [Visual], [Deleted], [Edit]) VALUES (6, 4, 34, 1, 1, 0, 1, 0, 0)
INSERT [dbo].[DINHLUONG] ([ID], [KichThuocMonChinhID], [MonID], [LoaiBanID], [KichThuocBan], [SoLuong], [Visual], [Deleted], [Edit]) VALUES (7, 9, 22, 2, 20, 0, 1, 0, 1)
INSERT [dbo].[DINHLUONG] ([ID], [KichThuocMonChinhID], [MonID], [LoaiBanID], [KichThuocBan], [SoLuong], [Visual], [Deleted], [Edit]) VALUES (8, 9, 23, 2, 50, 0, 1, 0, 1)
SET IDENTITY_INSERT [dbo].[DINHLUONG] OFF
SET IDENTITY_INSERT [dbo].[DONVI] ON 

INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (1, N'Số lượng', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (2, N'Trọng lượng', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (3, N'Thể tích', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (4, N'Thời gian', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (5, N'Định lượng', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[DONVI] OFF
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (1, 101, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (2, 102, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (3, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (4, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (5, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (6, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (7, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (8, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (9, 0, NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [Hinh], [Visual], [Deleted], [Edit]) VALUES (10, 0, NULL, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHACHHANG] ON 

INSERT [dbo].[KHACHHANG] ([KhachHangID], [TenKhachHang], [LoaiKhachHangID], [DiaChi], [Mobile], [Phone], [Fax], [Email], [DuNo], [DuNoToiThieu], [Visual], [Deleted], [Edit]) VALUES (1, N'Tiến', 2, N'', N'', N'', N'', N'', CAST(0 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[KHACHHANG] ([KhachHangID], [TenKhachHang], [LoaiKhachHangID], [DiaChi], [Mobile], [Phone], [Fax], [Email], [DuNo], [DuNoToiThieu], [Visual], [Deleted], [Edit]) VALUES (2, N'Khoa', 1, N'fdsfgdgdf', N'43645645', N'6454545', N'', N'', CAST(0 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHACHHANG] OFF
SET IDENTITY_INSERT [dbo].[KHO] ON 

INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (1, N'Kho B', 1, 0, 1)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (2, N'Kho D', 1, 0, 1)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (3, N'Kho C', 1, 0, 0)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (5, N'Kho B', 1, 0, 1)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (6, N'Kho B', 1, 0, 1)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (7, N'Kho B', 1, 0, 1)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (9, N'Kho B', 1, 0, 1)
SET IDENTITY_INSERT [dbo].[KHO] OFF
SET IDENTITY_INSERT [dbo].[KHU] ON 

INSERT [dbo].[KHU] ([KhuID], [TenKhu], [LoaiGiaID], [MacDinhSoDoBan], [Hinh], [Visual], [Deleted], [Edit]) VALUES (1, N'Khu A', 1, 1, NULL, 1, 0, 0)
INSERT [dbo].[KHU] ([KhuID], [TenKhu], [LoaiGiaID], [MacDinhSoDoBan], [Hinh], [Visual], [Deleted], [Edit]) VALUES (2, N'Khu B', 1, 0, NULL, 1, 0, 0)
INSERT [dbo].[KHU] ([KhuID], [TenKhu], [LoaiGiaID], [MacDinhSoDoBan], [Hinh], [Visual], [Deleted], [Edit]) VALUES (3, N'Khu C', 1, 0, NULL, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHU] OFF
SET IDENTITY_INSERT [dbo].[LICHBIEUDINHKY] ON 

INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (2, N'Quốc  tế phụ nữ 8/3', 14, 3, N'Ngày 3 Tháng 8', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 3, 8, 1, 0, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (3, N'Giải phóng miền nam 30/4', 14, 3, N'Ngày 30 Tháng 4', CAST(0x0300000000000000 AS Time), CAST(0x0318582605000000 AS Time), 1, 30, 4, 1, 0, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (4, N'Quốc tế lao động 1/5', 14, 3, N'Ngày 1 Tháng 5', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 1, 5, 1, 0, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (5, N'Valentine 14/2', 14, 3, N'Ngày 14 Tháng 2', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 14, 2, 1, 0, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (6, N'Quốc khánh 2/9', 14, 3, N'Ngày 2 Tháng 9', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 2, 9, 1, 0, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (7, N'Noel 25/12', 14, 3, N'Ngày 25 Tháng 12', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 25, 12, 1, 0, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (8, N'Khai trương', 15, 3, N'Ngày 5 Tháng 1', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 5, 1, 1, 0, 1)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (9, N'Sinh nhât Bác Hồ', 15, 3, N'Ngày 19 Tháng 5', CAST(0x0300000000000000 AS Time), CAST(0x0300000000000000 AS Time), 1, 19, 5, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LICHBIEUDINHKY] OFF
SET IDENTITY_INSERT [dbo].[LICHBIEUKHONGDINHKY] ON 

INSERT [dbo].[LICHBIEUKHONGDINHKY] ([LichBieuKhongDinhKyID], [TenLichBieu], [NgayBatDau], [NgayKetThuc], [GioBatDau], [GioKetThuc], [LoaiGiaID], [Visual], [Deleted], [Edit]) VALUES (1, N'Khuyến mãi khai trương', CAST(0x0000A3DA001817D7 AS DateTime), CAST(0x0000A3F200000000 AS DateTime), CAST(0x0400000000000000 AS Time), CAST(0x04F0707F33000000 AS Time), 14, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LICHBIEUKHONGDINHKY] OFF
SET IDENTITY_INSERT [dbo].[LICHSUDANGNHAP] ON 

INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1, 1, CAST(0x0000000000001771 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2, 1, CAST(0x0000000000001772 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (3, 1, CAST(0x0000000000001773 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (4, 1, CAST(0x0000A3E90002BC80 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (5, 1, CAST(0x0000A3E90003A585 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (6, 1, CAST(0x0000A3E90005914F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (7, 1, CAST(0x0000A3E90005C950 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (8, 1, CAST(0x0000A3E9000636E0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (9, 1, CAST(0x0000A3E90006DE14 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (10, 2, CAST(0x0000A3E900073B0F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (11, 1, CAST(0x0000A3E9000773BC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (12, 2, CAST(0x0000A3E90007829F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (13, 2, CAST(0x0000A3E9000B297B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (14, 2, CAST(0x0000A3E9000BE173 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (15, 4, CAST(0x0000A3E900106BBB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (16, 1, CAST(0x0000A3E9001079AC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (17, 2, CAST(0x0000A3E900129CD2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (18, 1, CAST(0x0000A3E9001307DF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (19, 1, CAST(0x0000A3E90014AD43 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (20, 1, CAST(0x0000A3E900155F3B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (21, 1, CAST(0x0000A3E9001578ED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (22, 1, CAST(0x0000A3E900159863 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (23, 2, CAST(0x0000A3E90168A754 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (24, 2, CAST(0x0000A3E90169C0A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (25, 2, CAST(0x0000A3E9016C0FBB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (26, 2, CAST(0x0000A3E9016E9B54 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (27, 2, CAST(0x0000A3E90170A659 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (28, 2, CAST(0x0000A3E901722A2B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (29, 2, CAST(0x0000A3E90172B9AF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (30, 2, CAST(0x0000A3E90173C67B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (31, 2, CAST(0x0000A3E901745DFB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (32, 2, CAST(0x0000A3E90174E7D4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (33, 2, CAST(0x0000A3E901750DB8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (34, 2, CAST(0x0000A3E90176D3DB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (35, 2, CAST(0x0000A3E90178B68F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (36, 2, CAST(0x0000A3E901797380 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (37, 2, CAST(0x0000A3E9017DA79A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (38, 2, CAST(0x0000A3E9017DDE81 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (39, 2, CAST(0x0000A3E9017E1F27 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (40, 2, CAST(0x0000A3E9017E4EEE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (41, 2, CAST(0x0000A3E9017EE8F2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (42, 2, CAST(0x0000A3E9017FABDC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (43, 2, CAST(0x0000A3E901815BBA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (44, 2, CAST(0x0000A3E90181D74F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (45, 2, CAST(0x0000A3E90182719F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (46, 2, CAST(0x0000A3E90182DB22 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (47, 2, CAST(0x0000A3E901834A1C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (48, 2, CAST(0x0000A3E90183B656 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (49, 2, CAST(0x0000A3E9018430CF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (50, 2, CAST(0x0000A3E9018443FD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (51, 1, CAST(0x0000A3E90184F605 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (52, 2, CAST(0x0000A3E90185435E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (53, 2, CAST(0x0000A3E90185F31A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (54, 2, CAST(0x0000A3E9018778C8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (55, 2, CAST(0x0000A3E9018B0995 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (56, 2, CAST(0x0000A3EA00006B26 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (57, 2, CAST(0x0000A3EA0000F910 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (58, 2, CAST(0x0000A3EA0001CACC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (59, 2, CAST(0x0000A3EA00025BC2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (60, 2, CAST(0x0000A3EA0002928C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (61, 2, CAST(0x0000A3EA00037674 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (62, 2, CAST(0x0000A3EA0003ACBE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (63, 2, CAST(0x0000A3EA0003CEB6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (64, 1, CAST(0x0000A3EB001DD718 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (65, 1, CAST(0x0000A3EB002CF344 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (66, 2, CAST(0x0000A3EB002D3C5A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (67, 1, CAST(0x0000A3EB002D90FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (68, 1, CAST(0x0000A3EB002E44D1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (69, 1, CAST(0x0000A3EB002E8D13 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (70, 1, CAST(0x0000A3EB002EE5C2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (71, 1, CAST(0x0000A3EB002FF015 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (72, 1, CAST(0x0000A3EB00308B0A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (73, 1, CAST(0x0000A3EB00324B60 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (74, 4, CAST(0x0000A3EB00351AEA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (75, 1, CAST(0x0000A3EB00353E39 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (76, 1, CAST(0x0000A3EB00397860 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (77, 1, CAST(0x0000A3EB003CDBAD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (78, 1, CAST(0x0000A3EB003DD2B1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (79, 1, CAST(0x0000A3EB003F5AD1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (80, 1, CAST(0x0000A3EB00413BAC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (81, 1, CAST(0x0000A3EB00424E38 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (82, 1, CAST(0x0000A3EB0043C66B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (83, 1, CAST(0x0000A3EB00442276 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (84, 1, CAST(0x0000A3EB0044EAA0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (85, 1, CAST(0x0000A3EB00460692 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (86, 1, CAST(0x0000A3EB0046AD44 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (87, 1, CAST(0x0000A3EB00476297 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (88, 1, CAST(0x0000A3EB00484CB4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (89, 1, CAST(0x0000A3EB0048E399 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (90, 1, CAST(0x0000A3EB00491656 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (91, 1, CAST(0x0000A3EB00497112 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (92, 1, CAST(0x0000A3EB0105967A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (93, 1, CAST(0x0000A3EB0105CE54 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (94, 1, CAST(0x0000A3EB01065653 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (95, 1, CAST(0x0000A3EB010CCDC2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (96, 1, CAST(0x0000A3EB010D5D90 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (97, 1, CAST(0x0000A3EB010DB2E0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (98, 1, CAST(0x0000A3EB010E059C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (99, 1, CAST(0x0000A3EC003CCD48 AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (100, 1, CAST(0x0000A3EC004E6308 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (101, 1, CAST(0x0000A3EC004EF7A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (102, 1, CAST(0x0000A3EC004FE697 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (103, 1, CAST(0x0000A3EC0050DC82 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (104, 1, CAST(0x0000A3EC0052172C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (105, 1, CAST(0x0000A3EC005DBCED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (106, 1, CAST(0x0000A3EC005DF19E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (107, 1, CAST(0x0000A3EC005E8DC3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (108, 1, CAST(0x0000A3EC005EE0C0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (109, 1, CAST(0x0000A3EC005F3446 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (110, 1, CAST(0x0000A3EC00614526 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (111, 1, CAST(0x0000A3EC0066C4E2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (112, 1, CAST(0x0000A3EC006740E0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (113, 1, CAST(0x0000A3EC006814E4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (114, 1, CAST(0x0000A3EC0078C729 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (115, 1, CAST(0x0000A3EC00790934 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (116, 1, CAST(0x0000A3EC007A4473 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (117, 1, CAST(0x0000A3EC007CCD6C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (118, 1, CAST(0x0000A3EC007D6D39 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (119, 1, CAST(0x0000A3EC007DCEB6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (120, 1, CAST(0x0000A3EC007EC77C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (121, 1, CAST(0x0000A3EC008067BC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (122, 1, CAST(0x0000A3EC0082A350 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (123, 1, CAST(0x0000A3EC008344EB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (124, 1, CAST(0x0000A3EC0083D5D3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (125, 1, CAST(0x0000A3EC00842A73 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (126, 1, CAST(0x0000A3EC0084A1B5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (127, 1, CAST(0x0000A3EC0085729D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (128, 1, CAST(0x0000A3EC0085D4A9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (129, 1, CAST(0x0000A3EC008624B1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (130, 1, CAST(0x0000A3EC008739B7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (131, 1, CAST(0x0000A3EC0087BEEC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (132, 1, CAST(0x0000A3EC0088A78F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (133, 1, CAST(0x0000A3EC008A2F12 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (134, 1, CAST(0x0000A3EC008C2A2F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (135, 1, CAST(0x0000A3EC008CA875 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (136, 1, CAST(0x0000A3EC00C7B1A1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (137, 1, CAST(0x0000A3EC00CF7859 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (138, 1, CAST(0x0000A3EC00D05214 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (139, 1, CAST(0x0000A3EC00D0A3A0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (140, 1, CAST(0x0000A3EC00D0FCA3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (141, 1, CAST(0x0000A3EC00D29259 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (142, 1, CAST(0x0000A3EC00D2FAAD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (143, 1, CAST(0x0000A3EC00E23EB0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (144, 1, CAST(0x0000A3EC00E3D8F0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (145, 1, CAST(0x0000A3EC00E45090 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (146, 1, CAST(0x0000A3EC00E934AD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (147, 1, CAST(0x0000A3EC00E954BA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (148, 1, CAST(0x0000A3EC00E9E361 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (149, 1, CAST(0x0000A3EC00EB1151 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (150, 1, CAST(0x0000A3EC00EB7700 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (151, 1, CAST(0x0000A3EC00EF3BEF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (152, 1, CAST(0x0000A3EC00F0B225 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (153, 1, CAST(0x0000A3EC00F54CCB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (154, 1, CAST(0x0000A3EC00F6B6C3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (155, 1, CAST(0x0000A3EC00F758CD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (156, 1, CAST(0x0000A3EC00F8AC54 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (157, 1, CAST(0x0000A3EC00FBEBFE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (158, 1, CAST(0x0000A3EC00FCFFD0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (159, 1, CAST(0x0000A3EC01769A67 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (160, 1, CAST(0x0000A3EC01772FB5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (161, 1, CAST(0x0000A3EC0178FE23 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (162, 1, CAST(0x0000A3EC0179426B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (163, 1, CAST(0x0000A3EC017A10EC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (164, 1, CAST(0x0000A3EC017ABCF7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (165, 1, CAST(0x0000A3EC017B6364 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (166, 1, CAST(0x0000A3EC017BF97D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (167, 1, CAST(0x0000A3EC017C4569 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (168, 1, CAST(0x0000A3EC017ED56C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (169, 1, CAST(0x0000A3ED0003C7D3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (170, 1, CAST(0x0000A3ED0008DB38 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (171, 1, CAST(0x0000A3ED000BB5D2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (172, 1, CAST(0x0000A3ED000C71FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (173, 1, CAST(0x0000A3ED00112319 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (174, 11, CAST(0x0000A3ED00119C37 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (175, 11, CAST(0x0000A3ED00124379 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (176, 1, CAST(0x0000A3ED0012F1C7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (177, 1, CAST(0x0000A3ED00156B23 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (178, 1, CAST(0x0000A3ED00179AA7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (179, 1, CAST(0x0000A3ED00182858 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (180, 1, CAST(0x0000A3ED00187E51 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (181, 1, CAST(0x0000A3ED00191CFB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (182, 1, CAST(0x0000A3ED001971CE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (183, 1, CAST(0x0000A3ED0019FA4B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (184, 1, CAST(0x0000A3ED001C52B8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (185, 1, CAST(0x0000A3ED001C9D11 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (186, 1, CAST(0x0000A3ED001CF76A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (187, 1, CAST(0x0000A3ED001DE2EA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (188, 1, CAST(0x0000A3ED001E5B3C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (189, 1, CAST(0x0000A3ED001F3394 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (190, 1, CAST(0x0000A3ED001FF301 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (191, 1, CAST(0x0000A3ED002120E2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (192, 1, CAST(0x0000A3ED002176E5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (193, 1, CAST(0x0000A3ED00231E0F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (194, 1, CAST(0x0000A3ED002382F0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (195, 1, CAST(0x0000A3ED002432F9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (196, 1, CAST(0x0000A3ED0024DB1D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (197, 1, CAST(0x0000A3ED00268C22 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (198, 1, CAST(0x0000A3ED0026EF46 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (199, 1, CAST(0x0000A3ED0027AF63 AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (200, 1, CAST(0x0000A3ED00287222 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (201, 1, CAST(0x0000A3ED0028FEE6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (202, 1, CAST(0x0000A3ED0029C0DE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (203, 1, CAST(0x0000A3ED002A2279 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (204, 1, CAST(0x0000A3ED002AAFDB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (205, 1, CAST(0x0000A3ED002AF94D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (206, 1, CAST(0x0000A3ED002B292B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (207, 1, CAST(0x0000A3ED002C9ADA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (208, 1, CAST(0x0000A3ED002EAE88 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (209, 1, CAST(0x0000A3ED002FB04D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (210, 1, CAST(0x0000A3ED00302C56 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (211, 1, CAST(0x0000A3ED0031615E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (212, 1, CAST(0x0000A3ED0031AFFE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (213, 1, CAST(0x0000A3ED00324090 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (214, 1, CAST(0x0000A3ED003261DB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (215, 1, CAST(0x0000A3ED00340238 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (216, 1, CAST(0x0000A3ED00361D4B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (217, 1, CAST(0x0000A3ED0036AACB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (218, 1, CAST(0x0000A3ED00370C78 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (219, 1, CAST(0x0000A3ED00373E44 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (220, 1, CAST(0x0000A3ED0037A576 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (221, 1, CAST(0x0000A3ED0037DED6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (222, 1, CAST(0x0000A3ED009F57F1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (223, 1, CAST(0x0000A3ED00A03802 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (224, 11, CAST(0x0000A3ED011948DC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (225, 11, CAST(0x0000A3ED0119A2A8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (226, 11, CAST(0x0000A3ED011A064D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (227, 11, CAST(0x0000A3ED011A61EE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (228, 11, CAST(0x0000A3ED011AE7D3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (229, 11, CAST(0x0000A3ED011AFF1E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (230, 11, CAST(0x0000A3ED011B403B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (231, 11, CAST(0x0000A3ED011B8E0C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (232, 11, CAST(0x0000A3ED011C6118 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (233, 1, CAST(0x0000A3ED011C85CE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (234, 11, CAST(0x0000A3ED011CF01C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (235, 1, CAST(0x0000A3ED01227337 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (236, 11, CAST(0x0000A3ED0122A1B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (237, 1, CAST(0x0000A3ED0122C158 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (238, 1, CAST(0x0000A3ED01230B55 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (239, 1, CAST(0x0000A3ED01766F97 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (240, 1, CAST(0x0000A3ED0176F6F5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (241, 11, CAST(0x0000A3ED01770634 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (242, 1, CAST(0x0000A3ED01831525 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (243, 1, CAST(0x0000A3ED0183365D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (244, 11, CAST(0x0000A3ED0184CACD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (245, 1, CAST(0x0000A3ED0184E4CD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (246, 1, CAST(0x0000A3ED018A4658 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (247, 1, CAST(0x0000A3ED018AE19C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (248, 1, CAST(0x0000A3EE000100B8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (249, 1, CAST(0x0000A3EE00013218 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (250, 1, CAST(0x0000A3EE0001773F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (251, 1, CAST(0x0000A3EE0001CAC6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (252, 1, CAST(0x0000A3EE0002037F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (253, 1, CAST(0x0000A3EE000C2579 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (254, 1, CAST(0x0000A3EE000D56B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (255, 1, CAST(0x0000A3EE000DE5FC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (256, 11, CAST(0x0000A3EE000E05FA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (257, 11, CAST(0x0000A3EE001F0C02 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (258, 11, CAST(0x0000A3EE001F86F8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (259, 11, CAST(0x0000A3EE001FFA90 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (260, 1, CAST(0x0000A3EE00202256 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (261, 11, CAST(0x0000A3EE00206097 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (262, 11, CAST(0x0000A3EE00214979 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (263, 11, CAST(0x0000A3EE00217AB4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (264, 11, CAST(0x0000A3EE00219F9E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (265, 1, CAST(0x0000A3EE0021AD8F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (266, 11, CAST(0x0000A3EE0021E724 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (267, 11, CAST(0x0000A3EE0023126B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (268, 11, CAST(0x0000A3EE0024AD6D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (269, 11, CAST(0x0000A3EE0026DAF3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (270, 1, CAST(0x0000A3EE0029513D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (271, 1, CAST(0x0000A3EE00297F66 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (272, 11, CAST(0x0000A3EE002993D3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (273, 11, CAST(0x0000A3EE002AFAE9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (274, 11, CAST(0x0000A3EE002B3EF9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (275, 11, CAST(0x0000A3EE002B7F90 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (276, 11, CAST(0x0000A3EE002BB460 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (277, 1, CAST(0x0000A3EE002CC63D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (278, 11, CAST(0x0000A3EE002D514F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (279, 1, CAST(0x0000A3EE002D8E6D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (280, 11, CAST(0x0000A3EE002DC78A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (281, 11, CAST(0x0000A3EE002EEDC0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (282, 11, CAST(0x0000A3EE002F3459 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (283, 11, CAST(0x0000A3EE002FCCC7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (284, 1, CAST(0x0000A3EE0038C612 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (285, 1, CAST(0x0000A3EE00390167 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (286, 1, CAST(0x0000A3EE003D03B9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (287, 1, CAST(0x0000A3EE003D9E9A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (288, 1, CAST(0x0000A3EE003F6EA1 AS DateTime), 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LICHSUDANGNHAP] OFF
SET IDENTITY_INSERT [dbo].[LOAIBAN] ON 

INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (1, N'Cái', 1, 1, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (2, N'Gram', 1, 2, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (3, N'Kg', 1000, 2, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (4, N'Millilit ', 1, 3, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (5, N'Lít', 1000, 3, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (6, N'Giờ', 3600, 4, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (7, N'Phút', 60, 4, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (8, N'Giây', 1, 4, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (9, N'Định lượng', 1, 5, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LOAIBAN] OFF
SET IDENTITY_INSERT [dbo].[LOAIKHACHHANG] ON 

INSERT [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID], [TenLoaiKhachHang], [PhanTramGiamGia], [Visual], [Deleted], [Edit]) VALUES (1, N'VIP 1', 2, 1, 0, 0)
INSERT [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID], [TenLoaiKhachHang], [PhanTramGiamGia], [Visual], [Deleted], [Edit]) VALUES (2, N'VIP 2', 5, 1, 0, 0)
INSERT [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID], [TenLoaiKhachHang], [PhanTramGiamGia], [Visual], [Deleted], [Edit]) VALUES (3, N'VIP 3', 7, 1, 0, 0)
INSERT [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID], [TenLoaiKhachHang], [PhanTramGiamGia], [Visual], [Deleted], [Edit]) VALUES (4, N'VIP 4', 10, 1, 0, 1)
INSERT [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID], [TenLoaiKhachHang], [PhanTramGiamGia], [Visual], [Deleted], [Edit]) VALUES (5, N'VIP 5', 15, 1, 0, 1)
INSERT [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID], [TenLoaiKhachHang], [PhanTramGiamGia], [Visual], [Deleted], [Edit]) VALUES (6, N'VIP 6', 18, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LOAIKHACHHANG] OFF
SET IDENTITY_INSERT [dbo].[LOAILICHBIEU] ON 

INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (1, N'Thứ 2', 1, 1, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (2, N'Thứ 3', 1, 2, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (3, N'Thứ 4', 1, 3, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (4, N'Thứ 5', 1, 4, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (5, N'Thứ 6', 1, 5, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (6, N'Thứ 7', 1, 6, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (7, N'Chủ nhật', 1, 0, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (8, N'Ngày 1', 2, 1, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (9, N'Ngày 2', 2, 2, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (10, N'Ngày 3', 2, 3, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (11, N'Ngày 4', 2, 4, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (12, N'Ngày 5', 2, 5, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (13, N'Ngày 6', 2, 6, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (14, N'Ngày 7', 2, 7, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (15, N'Ngày 8', 2, 8, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (16, N'Ngày 9', 2, 9, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (17, N'Ngày 10', 2, 10, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (18, N'Ngày 11', 2, 11, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (19, N'Ngày 12', 2, 12, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (20, N'Ngày 13', 2, 13, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (21, N'Ngày 14', 2, 14, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (22, N'Ngày 15', 2, 15, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (23, N'Ngày 16', 2, 16, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (24, N'Ngày 17', 2, 17, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (25, N'Ngày 18', 2, 18, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (26, N'Ngày 19', 2, 19, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (27, N'Ngày 20', 2, 20, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (28, N'Ngày 21', 2, 21, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (29, N'Ngày 22', 2, 22, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (30, N'Ngày 23', 2, 23, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (31, N'Ngày 24', 2, 24, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (32, N'Ngày 25', 2, 25, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (33, N'Ngày 26', 2, 26, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (34, N'Ngày 27', 2, 27, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (35, N'Ngày 28', 2, 28, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (36, N'Ngày 29', 2, 29, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (37, N'Ngày 30', 2, 30, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (38, N'Ngày 31', 2, 31, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (39, N'Tháng 1', 3, 1, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (40, N'Tháng 2', 3, 2, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (41, N'Tháng 3', 3, 3, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (42, N'Tháng 4', 3, 4, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (43, N'Tháng 5', 3, 5, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (44, N'Tháng 6', 3, 6, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (45, N'Tháng 7', 3, 7, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (46, N'Tháng 8', 3, 8, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (47, N'Tháng 9', 3, 9, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (48, N'Tháng 10', 3, 10, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (49, N'Tháng 11', 3, 11, 1, 0, 0)
INSERT [dbo].[LOAILICHBIEU] ([LoaiLichBieuID], [TenLoaiLichBieu], [TheLoaiID], [GiaTri], [Visual], [Deleted], [Edit]) VALUES (50, N'Tháng 12', 3, 12, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LOAILICHBIEU] OFF
INSERT [dbo].[LOAINHANVIEN] ([LoaiNhanVienID], [TenLoaiNhanVien], [CapDo], [Edit], [Visual], [Deleted]) VALUES (1, N'Admin', 1, 0, 1, 0)
INSERT [dbo].[LOAINHANVIEN] ([LoaiNhanVienID], [TenLoaiNhanVien], [CapDo], [Edit], [Visual], [Deleted]) VALUES (2, N'Quản Lý', 2, 0, 1, 0)
INSERT [dbo].[LOAINHANVIEN] ([LoaiNhanVienID], [TenLoaiNhanVien], [CapDo], [Edit], [Visual], [Deleted]) VALUES (3, N'Giám Sát', 3, 0, 1, 0)
INSERT [dbo].[LOAINHANVIEN] ([LoaiNhanVienID], [TenLoaiNhanVien], [CapDo], [Edit], [Visual], [Deleted]) VALUES (4, N'Nhân Viên', 4, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[LOAIPHATSINH] ON 

INSERT [dbo].[LOAIPHATSINH] ([LoaiPhatSinhID], [Ten], [Visual], [Deleted], [Edit]) VALUES (1, N'Nhập Kho', 1, 0, 0)
INSERT [dbo].[LOAIPHATSINH] ([LoaiPhatSinhID], [Ten], [Visual], [Deleted], [Edit]) VALUES (2, N'Chuyển kho', 1, 0, 0)
INSERT [dbo].[LOAIPHATSINH] ([LoaiPhatSinhID], [Ten], [Visual], [Deleted], [Edit]) VALUES (3, N'Mất kho', 1, 0, 0)
INSERT [dbo].[LOAIPHATSINH] ([LoaiPhatSinhID], [Ten], [Visual], [Deleted], [Edit]) VALUES (4, N'Hư kho', 1, 0, 0)
INSERT [dbo].[LOAIPHATSINH] ([LoaiPhatSinhID], [Ten], [Visual], [Deleted], [Edit]) VALUES (5, N'Chuyển kho', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LOAIPHATSINH] OFF
SET IDENTITY_INSERT [dbo].[MAYIN] ON 

INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (2, N'Foxit Reader PDF Printer', N'Nước', 1, 1, 1, 0, 1, 0)
INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (3, N'Foxit Reader PDF Printer', N'Nhà bếp', 1, 1, 1, 0, 1, 0)
INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (4, N'Foxit Reader PDF Printer', N'Nhà bếp', 1, 1, 1, 1, 0, 0)
INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (5, N'Snagit 12', N'Nước', 0, 1, 1, 1, 0, 0)
INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (6, N'Foxit Reader PDF Printer', N'In Hóa đơn', 1, 1, 1, 0, 1, 1)
SET IDENTITY_INSERT [dbo].[MAYIN] OFF
SET IDENTITY_INSERT [dbo].[MENUGIA] ON 

INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (1, 1, CAST(15000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (2, 1, CAST(15000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (3, 1, CAST(15000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (4, 1, CAST(28000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (5, 1, CAST(0 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (6, 1, CAST(0 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (8, 1, CAST(0 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (9, 1, CAST(0 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (10, 2, CAST(8000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (11, 2, CAST(8000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (12, 2, CAST(8000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (13, 2, CAST(8000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (14, 2, CAST(8000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (15, 2, CAST(8000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (17, 2, CAST(8000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (18, 2, CAST(8000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (19, 3, CAST(9000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (20, 3, CAST(9000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (21, 3, CAST(9000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (22, 3, CAST(9000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (23, 3, CAST(9000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (24, 3, CAST(9000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (26, 3, CAST(9000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (27, 3, CAST(9000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (28, 4, CAST(60000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (29, 4, CAST(60000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (30, 4, CAST(60000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (31, 4, CAST(60000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (32, 4, CAST(60000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (33, 4, CAST(60000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (35, 4, CAST(60000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (36, 4, CAST(60000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (37, 5, CAST(65000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (38, 5, CAST(65000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (39, 5, CAST(65000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (40, 5, CAST(65000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (41, 5, CAST(65000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (42, 5, CAST(65000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (44, 5, CAST(65000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (45, 5, CAST(65000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (46, 6, CAST(1300000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (47, 6, CAST(1300000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (48, 6, CAST(1300000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (49, 6, CAST(1300000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (50, 6, CAST(1300000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (51, 6, CAST(1300000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (53, 6, CAST(1300000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (54, 6, CAST(1300000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (55, 7, CAST(90000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (56, 7, CAST(90000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (57, 7, CAST(90000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (58, 7, CAST(90000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (59, 7, CAST(90000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (60, 7, CAST(90000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (62, 7, CAST(90000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (63, 7, CAST(90000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (64, 8, CAST(150000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (65, 8, CAST(150000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (66, 8, CAST(150000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (67, 8, CAST(150000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (68, 8, CAST(130000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (69, 8, CAST(150000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (71, 8, CAST(150000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (72, 8, CAST(150000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (73, 1, CAST(0 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (74, 2, CAST(8000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (75, 3, CAST(9000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (76, 4, CAST(60000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (77, 5, CAST(65000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (78, 6, CAST(1300000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (79, 7, CAST(90000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (80, 8, CAST(150000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (81, 9, CAST(60000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (82, 9, CAST(60000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (83, 9, CAST(60000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (84, 9, CAST(60000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (85, 9, CAST(60000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (86, 9, CAST(60000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (87, 9, CAST(60000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (88, 9, CAST(60000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (89, 9, CAST(60000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (90, 10, CAST(5000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (91, 10, CAST(5000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (92, 10, CAST(5000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (93, 10, CAST(5000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (94, 10, CAST(5000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (95, 10, CAST(5000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (96, 10, CAST(5000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (97, 10, CAST(5000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (98, 10, CAST(5000 AS Decimal(18, 0)), 16)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (99, 11, CAST(3000 AS Decimal(18, 0)), 1)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (100, 11, CAST(3000 AS Decimal(18, 0)), 2)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (101, 11, CAST(3000 AS Decimal(18, 0)), 3)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (102, 11, CAST(3000 AS Decimal(18, 0)), 4)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (103, 11, CAST(3000 AS Decimal(18, 0)), 5)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (104, 11, CAST(3000 AS Decimal(18, 0)), 6)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (105, 11, CAST(3000 AS Decimal(18, 0)), 14)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (106, 11, CAST(3000 AS Decimal(18, 0)), 15)
INSERT [dbo].[MENUGIA] ([GiaID], [KichThuocMonID], [Gia], [LoaiGiaID]) VALUES (107, 11, CAST(3000 AS Decimal(18, 0)), 16)
GO
SET IDENTITY_INSERT [dbo].[MENUGIA] OFF
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (1, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (1, 4, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (1, 5, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (2, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (3, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (4, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (4, 4, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (4, 5, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (5, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (5, 3, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (9, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (9, 3, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (10, 3, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (11, 3, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (12, 3, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (34, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (47, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (48, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (49, 2, 1, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (60, 2, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[MENUKHUYENMAI] ON 

INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (1, 2, 3, N'', 0, 1, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (2, 1, 5, N'', 1, 0, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (3, 1, 6, N'', 1, 0, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (4, 1, 7, N'', 1, 0, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (5, 1, 8, N'', 1, 0, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (6, 3, 5, N'', 1, 1, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (7, 6, 7, N'', 1, 1, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (8, 6, 5, N'', 1, 0, 0)
INSERT [dbo].[MENUKHUYENMAI] ([KhuyenMaiID], [KichThuocMonID], [KichThuocMonTang], [TenKhuyenMai], [Visual], [Deleted], [Edit]) VALUES (9, 6, 8, N'', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[MENUKHUYENMAI] OFF
SET IDENTITY_INSERT [dbo].[MENUKICHTHUOCMON] ON 

INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (1, 5, N'1 Thùng 24', 1, 1, CAST(0 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 1, 1)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (2, 1, N'1 chai', 1, 1, CAST(8000 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 1, 1)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (3, 2, N'1 chai', 1, 1, CAST(9000 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 1, 1)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (4, 19, N'Lớn', 9, 5, CAST(60000 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 1, 1)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (5, 62, N'Ly Nhỏ', 4, 3, CAST(65000 AS Decimal(18, 0)), 0, 150, 1, 0, 0, 1, 0, 1, 1)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (6, 62, N'Chai lớn', 5, 3, CAST(1300000 AS Decimal(18, 0)), 0, 1000, 1, 0, 0, 1, 0, 1, 2)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (7, 62, N'Chai nhỏ', 4, 3, CAST(90000 AS Decimal(18, 0)), 0, 500, 1, 0, 0, 1, 0, 1, 3)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (8, 62, N'Ly lớn', 4, 3, CAST(150000 AS Decimal(18, 0)), 0, 300, 1, 0, 0, 1, 0, 1, 4)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (9, 15, N'Lớn', 9, 5, CAST(60000 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 1, 0)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (10, 9, N'Bịch lớn', 1, 1, CAST(5000 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 1, 0)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonVi], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [TonKhoToiThieu], [TonKhoToiDa], [Visual], [Deleted], [Edit], [SapXep]) VALUES (11, 9, N'Bịch nhỏ', 1, 1, CAST(3000 AS Decimal(18, 0)), 0, 1, 1, 0, 0, 1, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[MENUKICHTHUOCMON] OFF
SET IDENTITY_INSERT [dbo].[MENULOAIGIA] ON 

INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (1, N'Tết nguyên đán', N'Tết nguyên đán', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (2, N'Sáng chủ nhật', N'Sáng chủ nhật', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (3, N'Tối chủ nhật', N'Tối chủ nhật', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (4, N'Sáng thứ 7', N'Sáng thứ 7', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (5, N'Tối thứ 7', N'Tối thứ 7', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (6, N'Sáng từ thứ 2 đến thứ 6', N'Sáng từ thứ 2 đến thứ 6', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (14, N'Lễ trong năm', N'Lễ trong năm', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (15, N'Sinh nhật', N'Sinh nhật', 1, 0, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (16, N'Tối từ thứ 2 đến thứ 6', N'Tối từ thứ 2 đến thứ 6', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[MENULOAIGIA] OFF
SET IDENTITY_INSERT [dbo].[MENULOAINHOM] ON 

INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom]) VALUES (1, N'Nước', 4)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom]) VALUES (2, N'Thức Ăn', 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom]) VALUES (3, N'Nguyên Liệu', 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom]) VALUES (4, N'Karaoke', 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom]) VALUES (5, N'Dịch Vụ', 0)
SET IDENTITY_INSERT [dbo].[MENULOAINHOM] OFF
SET IDENTITY_INSERT [dbo].[MENUMON] ON 

INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (1, N'Lavie', N'Lavie', 1, CAST(59000 AS Decimal(18, 0)), 10, 1, 1, 2, 0, 0xFFD8FFE000104A46494600010100000100010000FFDB008400090607120F100F0F0F120F100F0F0F0F0F0E0F0F0F0F100F0F0F1611161714141415181C2820181A251C141421312125292C2E2E2E171F3338332C37282D2E2B010A0A0A0E0D0E1A10101A2C241C242C2D2C2F2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CFFC000110800B7011303011100021101031101FFC4001B00000300030101000000000000000000000102030004050607FFC400401000020201030106030602080407000000010200110304122131051322415161067181143291A1B1C12342335262728292D1F00743B2F1536383A3B3E1E2FFC4001A010003010101010000000000000000000000010203040506FFC400351100020201030204050107040300000000000102110304122131411322516105327181A19114233342B1D1F01552C1F10682E1FFDA000C03010002110311003F00D20B3DF3E764CAAAC0CDB2AAB18ACAAAC62B28AB01595558C565156315945580AC70B0158C04056354056180ACCA8006A02336C2C03B6000DB0B0336C2C0CDB0032A3005400150032A200540760223014AC06295800A56302652002148089B2C009B240289B240968864C71D99B892EEA3B16D28AB39CF4E45008CC996458C0B2AC622AAB1D08AAAC04CA2AC04381010D5026C20405610B000858580C162B1D0E122B1D07642C28CEEE163A33BB858519DDC2C540290B0A0148EC542ED858500AC76216A000A808044600A80C15180A4407629580132B010A560326CB0026C9011174812C4D91880A93147732AA919055163116558C4555602B2CAB010E0405610204D8C160219562B1D1409158D21824563486D91594305880CDB000ED8C0CDB0005406654040DB000148EC285290B1508C91D92D08563B2680563B0A148808522300540602230148801322002958013658013658084D9018816667532AAB19059163159654809B2AAB02460202B1808087558982455522B2921C2C9B2870B000858807090B1842456141D9158E8212161466C858503642C280563B150A563B00AE2BB3D07A9F59129A4EA8D2189C96E6E91D0D3F61BBA860EA01162C1E939A7AC516D51DB0F8739C776EE0D7D77661C40924357A03FBC4B5D1F41BF864BB48E7693F8C8722740583034194A9A36274C33A97A9C993492836AD30149B59CAD08565592D0856310A44042D460022318A560029580085600499602176C0622AC83A1B2A891925D16022A040918081363058588A2A49B2A8B2AC9B2921C2C431C2C0070B26CAA1C245634870916E2B68C124D95B43B21B87B4A8C6A1416BE6FA5000091B9B7C1A6C8A8A6C9938FF00AD5EC4A9FDE579FD09AC6FA30B621560D8F3E28C14BD44E0AAD13292AC8DA2948EC545708055D0D72372DFA8912E1A91AE3E61283FA9D4D0EAB2AAAA0C2C4280376F500FC84E3C98E0E4DEE3D0C39B2C62A2A1D3BD9A3DA999D8306429EFBAE38E183FE6FC0E5A8CCBAC3F2798D0038FF86A77EFC990BB00405068D1FA09E862845428F2F51927E26EAAB3A044B3114AC0542324764D13658EC968991289054000446316A0002231885602176C064D5249B32CAB024A81026C602048EAB1585155488AA2AAB24A28AB10145489B29228A921C8A512831C9DC528945C725C8D14470926CAA0ED8AC69076C2C28D1F88149D33000920834013C6E04F49AE99A593930D645CB0348F2DDB1D9ECAB7B1EB6024B2D54EF8E58C9559E761C32C59137747ACECD0461C286EC61C5BAFAD850399E74FAB7EE7AF76F8364A49B0A14A4762A259481C79FA79CAB329B4B837B4DAE72000C49AA0A2947D4D7E939A78E37D0EAC5A8C8D55F24F5BA0D5B720A38F35DCD7F4B134C59702EAA89CD835AF98B4FDB9385A64DA5BC050B1FE2290410E3D6763A5D19E6C72CDCAA7FF0046C11035148800A44602158C4D13648D322842B1D8A852231508446002200022000A80C555926ACA01190D8E04091D56202CA925B2D228AB10CAAA4563A2AA921B2922AA921C8D144AAA4872345128164D95410B26CAA1B6C2C7410B158E83B6161B4E7EA99B23F778C80ABFD2311767D07CA6D1DB15BA473CE4E52D9119FB272651B5F30A3C7896C11E9D225A98C7A44BFD9A73EB21B4BA76C2C70E4A2C05E3C8B7B7227A73D08F48A53535BA3FA0471F852D92EBEBEA8DA2B22CD289E66DA2FA93C01EA652E489BDAACD9D1687C3FC422CD9E8A4F3E57531C9939E0DB0E9FCBE767430E118A8AF2A3F11316F71D9082C6B8E86E26B5667B19BACC8D2D4F6760CECC486DCD5B8ABB2DFE066B1CB920A91CD934B83349B69DBF7395DA1D8DDC0B4DC71FB9B2BF3F69D58753E23A9753833E8BC1570F94E6159D699C942158C9A2644000446226CB192D1322558A84223B10A44620110005443B081116D8C046431D562045D164B65A4515648CAAAC4D8D22C8921B34512E89336CD544A8590D9690C0492A8709159490E31C9B2D44A0C71596A230C7158F69AFDA193BAC6CFE7C05FEF13425E25BE4919E67B20E469765E2FFB9FC4FEF35D44B93934B03A6E2A72AE4EE92A35B5BF7775F29E25E2E8FF00BE26B8FAD7A9866F96FD3A14C74CAAC3A300441F0E8D12DDCA39FF0068DD91ABA23141F31C13F8DCD650DB1470F8BBB23F675FDCEF63D312BBACCE372E4F5E38DB5641B394E09B1D2555993C9B7864D0EEBDA7EED5FCE37EE427BAE854D5D1A3F888DC2C98E6A66DFDBEC513608A20FA4CF67274F8EAA99C3CA82CD74BE3E53BE12B89E54E2ADD11659AA66744CACAB108440429118132B1D92D13658C9A1088C542912846544332A0363AAC5622C8B25B2D22AAB246591626C69174499B66AA2591266D9AA8950B22CB48A2A496CB48AA6392D9A28965C525C8D140A2E391668A250638ACADA3048AC7B4F3DF17E5DA34EBD37E4627FC2BFF00EA7668D5C9B3875CBC8914EC6C8A579E7AF43EFC58FDE1A84D330D238D72573E5F150F2FD666A2E8D273F35213339AF3FC0C14489C9D0DF0F78B07422B2E75E411C77ADEBF38F3BF39D5A75FBB470FB309209F5663F5DC676E74BF0783A76EDBF77FD4F57832B6DA33CB6959F4509CB69CACB90924CD92A479F3936CA0C8571B57563FB0855C8BDEE38D90C2A4B0952A4638D372371B1FCFE866675381A85793F21FBCE98BF29CF5C88CB2EC9689B2CA4C8689959564D0844602110011965225A264464D0844648B5018C1601459164B6524555621964592D949174499B6689174599366A91402436689164492D9A28974C721B358C0D85C721B355128124D9A2893D6E538F164C80594C6EE07A90A4D420AE4904B84D9E0DFE35D5ED0C134FCFF00E5E4AFFAE7ACF418FD59E443E232964DAE8F59F0A76ABEB34A99F2AAA3B3E45210305F0B90080493E53CED46358F238A3D883B562FC4BA15CDDCEEDDE0391FC15B8F87A743C4C9EA25A7C539C15BE2918E5C5E24E31FA9A3A6ECB718C32A32E51932285C843060AD5754281E672CBE25AA7185C55BEBC77FD4E38E994B1EE8C6A56F87DE8E968B44C46EC98D51ECDF8FC343A1E071F8CEB8E69B8F98DF069EF9946A5EC727B6FB4B661EF70F74E84EDBDAC4137D56C0B14451E93AB4C9647D4AD6E27A6F2C972757E1AC8B934C8CB55BB20355CB07218F1E77731CDC4CD31F28F3F834F9919D06366557601A88DC371E4713D09CB1CA29B7CD1F3D1C596127149B57E87670EA7355145FAB807F09C4E38EFE63D2865CDB798A358335F23E7E212F6AAE1982949BE50FA8CA6A8015C1EBED51462BB95926DAA457401FA84157D770FD229EDF534D3A975AFC9BCCAD5F747F984C957A9D4D3AE86851B6268741C1BFF7D67427C2A3964B96232CB4C8689309666D136594992D13612908422310844602308C9689911922D400AAAC5655145110CB22C96C123611666D9AC625D1664D9B24554486CD122C8925B2D23631E399B66F189B28921B3551281641A50D5019A7DAFA94C585CB8243028117EF3B30A0A3FDFACD3141CE69231CF9638B1B948F19A2F847265C6AA5B1AB5724EEAE9D27A93D7421DACF0F0E832CDEE4D23D37C31A6FB3611A461B72E0277D1B570CC48C8BEC79E3C8833CECEF7CB7AE8CF6F0C9AB84BE65FE595ED9C9B4E2A34C7BC551FD62540FDE2C716E32F61BC8A3960BBB748D6D0F695EA726F358F4FBC64E09BBDAB89554726CF7878EB5233F976A5DD5FEA74E87078B8E791AF36EDB1F4A4B934FB4754C73EB3123E47C3A9D369F57B4963B7085CA730407950C1116BFB73939B67D0E2C4BC1C536927194A37EFE5ABF5AB6CF2FDBACDB5D72155746C67BA5DCA3217C4A7704028ADB7DE24F18D47ACEDD07F138FF00383CCF8CA8474C9A5E57DF87552E17ADF1D3DDB3D8FC12B5A2403FF1751FFCCD34D57F13EC8F2317CA75F3670BB147DE7C8AA793E6D5328C6EDF648A94EB6A5D5B25ACEC2C3A9F1866657EA4657208E39147DA7939F4CE73DF07474E4C3195C6688E9BE12C589D5F1E5CE02FFCB6757C67E6185FE73AF1A943F999CD1D1628BB566F0EC8C7609087904DE35E7AD89D1E34EAACBFD9B0FF00B511CDD96801A623E4AA252CB27D46F0E34B84790F8A76E2AACD954B50015AB9AE48FD6A7442E4613D9174CB7C2B959F4F6F648C8EA18DDB0E0D93E7D4CD25D8E3925B9A47598408A24EB2D33368932CA4CCDA26C25264B26C25089911885223026C2325A16A3268B8590594458985174590D9A246C63599366D1458099B6689164592D9A246CE3499B66F189B28B336CD92353B67B5B1E8F18CB977152E10040092C413E6479032F16296596D884E6B1AB679FCDFF1134A80964D4051C92110FE5BA747EC197D8CF1EA633E88F5D8B2075575E8CA181F622C7EB389AA74741E5FB6B56726B1709FB98515BE6EFC93F850FA99E869E1B70B9F7678BAFC9BB3C71F65C9DA6D4850A17D074F39C9B6FA9DEF2A8D513CBAB01D1C81658632D5CED6355F8D18E30B4D12F354D4ABDBF51BB6315B69CF5ACA4D0BB3E135F9D431CAA12FA1AE48AF1B137DA5FF000738260C7A8CE99F7A0C8C3262625970642377DE20583E26045D1B84F0CB2454E3CF1CA34C1F135A56F04F856DA957FBA9B57D3AA46C0ED8D3E0F1262C61B62E2DD8DB13028B655771606AC9EA3CE671D3646FE567464F89609AE7511ABBE6FABEF493E4F37DB5DAEDAB6B6AC787090557A877F2B3D3CB813D3C181E18EE7D59E266D5E3D44F6E37718F2DFAFD3DBFA9E8BE112A74A850865393390CA081CE56F59C59DDCECEEC125285A37BB4769EE0786CE4F158E7DA4E3B563CD4D44B765EB718C48A947EFB11E6B6E4F4E7CCF49CD183DB7D8F435396B2B8F7E3FA0DACD48C48D9F330C58945B3359A1F212A538C1726787065CF35182E5F61D75B89707DABBD0706CEF3BCBF095F599BCB1DBBBB1BC34997C5F06BCF755EE79EECEEDDCB9732FDA02E1C5970B67C788E23FC2C1CEDC99B3120296AFBB47CBD6658F2C9CB9E9F4FEACF4757A1C30C4FC2F3493A6EFABEEA31F45EA78EF8D75185F2AE4C45722EEBDC8DB941BAAE27BBA671963747CAEB30E4C396B22A7EE7A0F8358B6941228778FB7E5C7EF733C9C3463D5BA3B24490684612910D12612D19B44984B2093094892644621488C4211180950151B0AB24659164B65246C63599499AC51751336CD522AA241A246C63590D9B451B58D666D9B45155124D51E6FF00E20630DA540480DDFA151D598D303B479F06E75E87F8BF63935D3D989C8F0FDA7D800E262D902AEDEBDDB1AE3F29EA2CBE6AA3C8C199E376CFACE9140C78C2905422052BF7480A0023DA78127CBB3E8972B83C7F6E699D75D97228660D8D5B853C6D417CF4F29D2B5F8F0E250945BEAF85F83C6D669673CEE7166D6919F263EF5C3620078BBEA4239AF335CC1658495AE3EA560D3E5CBD3A9A5ADD66FC834C0B075CBA7DD6280BC8A78A3D674421B63BBD532650939A57D1A3D0FC4E405C27C41BBDB461FCA40BE7D7A4E6D22B6FD28ECF884B6A8BEF64F4B9733FFCFC60F9EFC4CD7F3A31CD635D22FF00531C53CD3FE75F746C1ECCEF7966D33FF6BB8AFCFF00FB91E36CE97FA9ABD2789CCB6BFF00D4197E1EC7DDB2B775B0F3C626A27FCD1AD5CF75F3FA87FA763841A54BE885EC0C2B8F02A635DAAAF9401E47C66C8F6867773B65E95258F8F561EDACFB171B106B7AF35C05BFF5A8F04773689D5CF6413383D8DAE1A86C7A5EED3736A72BEA1BC4BB7161218103D77301F59C7A94D6C87AABFC9F45A48A5FB46A7D1A8AF7B4BFA2B3D68ED4D36A1DB4A18643911C320562AD8FA31BAA2BCD5F4BE265BA32F290F4D9F0A59AA926B9F7FEFDCF9EFC3AE736930E91ADF0699F51ABD50EA1B0E376EEB19FEF383C7A03393173051ECADBFB1F4FAD5B3512CEB89CD4631FAB4B74BECB8FA9219B33BF672E52B99B581F5F9575194A61C846EEE715D10154283B6BA9846526E29F7E7FF8138618C33CA09AD9505B55C97FB9FD5F4BF4397F1262542EA1F1E6D4E5CCF9729C5671AE562B58D7CB80147AF53C589EEE863251E39EEFD3EC7C6FC5A709C939C5C528A8C13EAEAF97EC7B0F84F1EDD3D5823BC7AAE82AAFF3B9AE5EA8F1A3CD9D6612100844A25A26C25A33688B0968CD926129124D84A1310C04298C42D4606CA890C691741219A4517413266A8AAC86688B2090CD11B38C4CD9BC51B09219B22A2496790D3B0D66A8E6724E305B1E05F25406B757BD13F51E93D2927870D2EAFA9E1EF5A9D479BA2E11DC3D9D8CB9FBDC556D3E13EA0AF49C7E24A8EFFD9E1B98BD92AD87264D330A5A3970DB6EE091BC0E3A5B035EE63CB538A9F7E8CAD3A78E6F13E9D51CFF0088323FDA11537D16C4AE1012CCA55D8D01E7C08E2F6E16D7537C508E4D428CDF1EFDF8E3FBFD8CD6E873EA0E46A5C18D863C811DC32F7C37A3707A00A14D50FBDEA271ADCD9EE473E9F0462BAB57DAB8E1AFCDAFA1E474C846A1B26EDC0EA3498EC64DC58F7E9B886FE61D04F671C6B0A4FD1B3E5F599633D4370F54BA57F9FDCF79F155ECC6457F4BE63DA7268FE66BD87F12F917D4876691D4ED040B2A483CFBC3298E9D2EE76F08361C515FE65E7C27D40F7F49CB27C51E9453BDCBA7A1B1972D834540AE437522BF2909726B295A38DD8A2B17FEAE63FF00B8675E6F9BEC8E0D2FF0FEECD0EDCCED91D718DC71E25DCFB28F8C9A453E9D7F0336C118C62DF77D0E7D4CE5932462B951E59ABF0B61CCFDE6C1800746C595995C66C4C5D8B300078C358F31C89E7E7C72DFBBB347D361D4E9D63F0E4E5BE32BF69269577E2971D19D5ECDEC94C39B1B65D4FF001D310C3DDA2AE0C2F8968A8543668559DA7924DFA4E75149DB7C9D39B56F2E394618FCADDDBE5DF7B7C7E571D8DEEC1EC2D3E871B63C409EF18B647C945B21AF3E2AABCA563C4A0A91CDACD7E5D54D4B23E8A92E9468F6FE4ECFC1853167C781D3183DCE0D8AE547F647F28F7E04A5854DA855FB0A1A9D44376653715DE56D2FBFABFCB3E75AECEB9322BEC4C589413871A22A22A8606EB835C8E6B9FACF7B0E25870ECFD4F9CD46A1EA352F35B6BA5BEAFDFEE7AEF854A9D3EE460CAF91CF1E47815F97E7397234DAAF408B4EDAF53AA64A06218C4234B44322D2D19B24D288649A50843188531885801B68266CA2E824B348A2CA264CD515590CB45924B3546C6399B3589753219AA1DB907E47F48975453E87CFFB235670AF8972028BB895476E2C0F21D7C4BC7BCEBD5EBB02938B6F8ABE1F73E7B061CD89DB5D793D3767F680650FE2DAD55B9194D9E8288BB98ED4D268F5304E52562E93B6F16A7538971306DA3287E1AC52F4E47AFE92E58650C6ED7A0D665933C5C7A726AF6CE753AA7C4E001B70BA32BB264B00D15208A3C99B6187EE9497BA39F539DC73B835C70CCCFD8CB9FEFE4D46D6EBF7083F5A911C8A1FCAACD7F7991578924BEDFF0066AEB7E1AD363C9A7CCB97396C59710C78AD0E3277015557E729679E46D492E8F9227871E3517176ED23BFF1126E441C7F4A2C9F4DAD31D33A937EC746B96E825EE4B4D8C0FD8D723DA127C99628A48EC699BA0363F2B9CF24CF420FB19ADC3FC3340351069988157CF3141F21961E4748E76836F76367DDB7AF7F119D13BDDCF539B156DF2F425D9F86DB37F0F783909A6AE69AEE8FBFED2B2BE23CF633D3C799547B9C6D569355818E4D22E408385A18DE87522C9B3E43E93A714B038ECC870EA96AFC579B15FE08EA7E29CC5766A74F8D81EA32210A7FC2C0895FE9D865D25C10BE3BA9C54DC69FAF28E46ABB4B1374D395F64D4EAB1A9FF0A38112F8462F56752FFCBB58970A3F749FFC13D3E2FB4640AB8B6A0A2555782479BB136DF533A6183169A3E454DF73CFC9F11D5FC472A79A569765D17DBA1B5F1126DC54CA53712AA48E039BABF4139E4F745D1DD1C6FA1BFF0003E0EEF46ABCEEEF32170455371C75F4A9CEE3B525EC3C2A93FA9DC302D8A4CA44B26C65221916968864DA512C99944B10C6210C0182311B6B33659643219A44B2CCD9A228B25968AA192CD132E8D21A344CB2B4868D1329BA4D17678F7CF95B50941DF11C99D8E2009B1858281E7C120D93E4DF29D195ECC7C75B5C8B4B8619F2FEF1F15C27F5ABFB7A0FDA9A4D4307C84A61C78F21CB8932E452554A233907CA8EF03A551E80CE28C67267B4B51A4C51DBD5B54E977575C7A5559C9F80B16DCD8D89B6C8FAA7ABB6EEC2A805BE64FE73D7D4DF874FD8F98C7B7C6B5DECF45DB34354B6B7BB129E2AFA91FB09960BF09D18EB12F19368E86931A900A9AF5AB1C7BCE7937DCE9C518B5C329DA482F003449CD8C8DA38A06F9FC22C4FE6FA1AE68A4E3F513B71C7762FFAE0D9E9D0CBD3AF37D8CF5AEE1F727A07B039B1E5EC62C888C0CEAE3C9E5F5BF40260D1DCA5D87D4E70508A26EC1A2018A31E4AC93F29CCECFE13FC790FCBC6674E4E59C785D47F534749932066DB95C6E6268D11D65CF6B5CC4E3C52C8A4F6CD9D9D3E622CDF88F535D7DCF339648F4F1CDF5BE496625CF88636FEF2032A3C74339F9FE649FD51CDD576561626F1A59E6FC439FA19D10D4645D247165D1E193F957E4CD27668C66D0229F9B9FD4C279DCB89061D24717C8922BA9ECFEF3EF953F43FEB263976F446F2C527CB6474BA55C3B913A5DF90E65B9B9F2CC9476B7CD9526090C4265512D926694910D92632D104C98C4C463284298084318858C0DA06665955689A1964690D1A26554C868B4C70D268B4CA07934526555E4D16A438C927697B8F31A05EF3697DE193264652A4A32B331DD447A99DD9928AF2F73C9C396727E67D0DBCBD81A7D450C88CE0FF006DABF233996494398A5FA1E8A94E6A9CE55F50F67762E9B4DAA57D3A9DE71E45C877646014570771E0D911394A7193977A263151CAB6BBEA5BB5720FB427BE2A1D28F889AF9CD3127E1BFA986A9FEF57D0E8699EB91FA75FF7FEB39E5C9D58A55C99ACCB4F8403C17E840EBB4F20F9730C71E195965E6892ED4E5578B1BF9FF299AE2EACCB52EE24701AAA15C55FA9848CE0E8DB4D41E78E781C7B7CFE732703A2391FA18D9801CF5E7E5CFF00DA1B7D07BE973D48E9325A0AE396FF00A8CD671F319639794E7E27E7EA7F5973471425C9D1C39B898389DB0C9C0C73C368FC423973F31A899CF272663CC7DE0D0466D94394FA1FC0C2916E6E8D7DC6CDD8E9D66D15C18DBB76067969039136794910D932F289B265A142B14B47421098C4213188526310B700366E41A0C1A14328AF2680AAE492D169955C927695B871922712D31C3C968A4C75792D0D48F35A3CE43E406B8C8FD4D6DE6EA76CE09C533CC4EA6CEB63D681EA45D7879F3E9395E23AA39683A3D633E760DD062BE01E0EE50013EB42FEB1CF1A8C38F534C595CA6EC8F69E55EFD6FA84EBF53D2698A2F63461A87FBC4CBE2D4A9FE6FC264F1B5D8D23913EE3E6CDB9F1F1C0607E7F2FCE28C2933573DD240ED5CBE000572C3AFB4AC31E459E5E527A4CA4F9D7E3FE91E48A32C7266C7DA08F7FA4CF61A788D05B5BC1B03EAA7F68BC22BC6E391346E760BE796E40AF39A4D724E37E5238B17247BC9948C6107746DE3C6664D9D31891CB90A9A1D65C629AB329C9C5D2116DACF520F31CAA24AB9725111BCAC496D17152EC5D71BFF58C9B46AA33F534F50D4C45DD70674635E539E6EA5444E49AD1162178E8562978E856217850AC52F2A82C52D0A158A5A301498081701960D24D070D1500C1A143183C54038C9150EC71922A1D8E32C5B46A431CF409F4E62DA3DC797D139672C411B893F741A1678B33B24AA3470AE656CE8E2CC493B416F2B5665FC6A64E25A74F82DA062B9812AC37232D924D743FB499C5389AE2954A987564B673D28051CD7A7BC20AA04E47732E9908AAFF007F8C871BEA55B5D0197236E463D032FB7175E90495348ADCF726CAEBC96DA07A98A0AAEC791DD031A9F7E91B688498FB79F7FA8322F82AB9E3A999B705BE0F90B06C1F28A3B5B1C9492B64B48E55006ABE6EBE735946D93195227F6C38F2FAAB807E44707F684B12947DC8799C257D8EAA6BD2AFC5F41393C191D8B530EF6737B4FB550100EDC7C71B8F88FE137C58697A9CD9B339FCAA9034DDA38D02DB01BB8160D13F3A8E78DC98F1CB62E4EAE3D529F261FE13395C1A3AA39A2CA64CDC58E16ACB1F21128F35DCD253F2FB1C039F712C3A12489E8A852A3CD73B6D80E48E89DC21C91D0B70A5E141B81BE3A15837C287602D0A0B06E850EC1BA3005C00B06906A10D0018342841DD15058C1E143B0878A82C6EF214161DF0A0B34F1622960015E57C91F2329C9B27C285D99D9F8DB095A767DA1853D90D75CB7B8AF2AEA64E45BD726905B1DA365F33BB8662A0283415768E7EA64C60A2A90E6EDD93D4296607E47D89175FACB5C221A52357EC47787EF1AFC0790BBAD5AF86AB17D2BA7B4ADDC519F851BBEE74759A86C80021000C1BC20DD8E964998E3C6A2ECDE79372AA30E497B4CF712CE8AE2985F24DF9F97FA412A7C09BB35B4BA418EE893641F2F2EA3A79F9CB93DC6318D3BB66E77D42801D08E79EBD7DA64B19B78BD892B54D28CDC896A1AE3AA2A2E3DCD6CBA70FD49078E5491D3DBA7E51AB40E7122FA1BFE6FC7996A4C8DF1EC16D33115BF8F402B982742728B2F859D0860CCC57950CCDB47D055FE3225052E070C918BB06B351973507C8768FE450157F0930C5187446B2D46F54C646A1534A39B7077C285B8CDD0A1D8374282CCDD01D99BA0306E80CCB81464430C45515926860318837026C3BA001DD0033740561DD01599BE141666F8506E303C2837877C542DE66F8E8370374541BCCDF1D0B700E48E89DC03923A16E14E48513BC53923DA4B988724744EF14E48E897307791D0B783BC8506F06F8506E3374283719BA01666E850ECCDD01D86E0332E22ACCB80EC371148CB88A0C452320506228A99268C1192CCB8C80DC4232E3102E142B32E315997015837405666E80ACCDD1D0ACCDD0A1582E14160DD1D0ACCDD0A26C05A3A15885A3158A4C64362968512D82E3A26C04C600B8006E21D86033221A0C0B3221A0C06181418868351169191141111683501D06A22E8D92B33B36685291D92D00A4AB21C41B63B27680AC2C4E266D8EC9A05409A054054C15192646262C6499702582E311970005C040302580C626218C9A32A162A16A316D0858AC1442161656D32A2B2B6842C452886A03A0ED8595B43B62B2B68D51594A266D8ACADA1DB0B2B6876C43A0858ACB510ED8594A21DB1594A21DB11547FFD9, 1, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (2, N'C2', N'C2', 1, CAST(11000 AS Decimal(18, 0)), 10, 1, 2, 2, 0, 0xFFD8FFE000104A46494600010100000100010000FFDB0084000906071313121414131416161517181C1818171819181D1A1A1D181B1C1C171C18201B1C2820181D251C1C1823312225292B2E2E2E1A1F3338332C37282D2E2B010A0A0A0E0D0E1B10101B3426202434342C2C2C2C2C2C2F2C342C2C342C2C2F2C342C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CFFC000110800C600FF03011100021101031101FFC4001C0000020203010100000000000000000000050604070002030108FFC4004A100002010203050407030808060105000001021100030412210506314151132261710732428191A1B11423C15262727382B2D1F01524336392C2E1F117344353A2D28316446493E3FFC4001B01000105010100000000000000000000000400020305060107FFC4003A11000104000402070801030402030000000100020311041221310541133251617181F014223391A1B1C1D12306E1F14252627234D2151692FFDA000C03010002110311003F00BC6924B2924A26D6C70B166E5D22422968E131CBC2B8E342D4D8784CD2B6306ACD2AFDBD27BF2B283CD98FD050DED0568C7F4EB79BCFC87ED71FF8A573FECDB3EF6AE7B41EC4FF00FEB8CFF79FA26FDCBDE6FB75BB8E6D8428F9603483A033C0471E1E1534526716A9789E0060E40D0EBB17B5262A9556ACA492CA492CA492D6E340AE849706BCDF9BF3AED24A35FDA5904B47BA69524A46CDC68BD6C38100923E0629A929549259492594925949241F7876AB58C9940EF4F113C23C475A1313398AAB9A8A5796D52057379AF7E50FF00FFDA85F6D7A80CCEEDFA28F7B7CAF209856FD9FE0697B648A2762DCD09D767623B4B56EE44674568E99803F8D59B1D99A0F6A3A376668776A914E4F59492594925949251EFE232988AAAC6F12F677E4014AC8F30B5C4E34F87CE80771B78E43EA9E210A35EDB8AA402389034F134F878D97BC34B37EF4FF0065D2ED17AD0A116524965249652496524901DFA78C0620931DC8F89000F7F0A8E5EA1561C285E323F154B59C1BB2E601638EAE80FB81209A0B29216E9D2B1AECA6FE44FE143834C532B2BD0CDD1971493DECC8D1E04113F107E028AC31DD653FA8DA73B1DCA8AB268A59A5949259492594925CB11C079D7424A35C07A5397105DAAA729D292EA9BBA0DF711D1D81F0E7F8D34A48DD7125949259492594924B3BE2B26D0075018FC623E86AB71FA9680879C5D25CC56159402623DFF88A04B4B45943B9A420FB450C72AE042CC34567EED38384C391FF006907BC000FCC1ABC80FF001B7C15A61CDC4DF008954AA659492594925949250317EB1AC9F1505D8935DDF644C7D551AE29FE4D54C91BDBB8FA8FDA99A4205B4D48652440044FC69F8734F17DA88DDBA275ADFAA85949259492594925949243378F670C4586B4C85C347743E43A1046B079814D7B730A4461310EC3CA2469D4775AACF03B9F75E7BA627D9BDFFF00120FC681A3B05A0771A70A240F91FDA983D1EB4184727F3B1083CB8618D3844E3C970F1F7F637E47FF0064CDB89BBE30C1DFB3CACDDD2FDA960D958E806500475A2216068B555C431F262480E3A0E5549B6A655AB2924B2924B2924A06D8C43A2164B79C804FAC0011CCCEB1E55C2682E816503C36D9C4389FB34FE83A9FDE22A03883D8A6E8876AF31AD896524619869ED5CB607C8B1A709DF579573237B514DD8C314B52C850B1CC65834C81A881A0F03AD4A09235511DD18AEAE2CA492CA492CA49207BCB81675CCBD9820012C189E3A443011AD078B8C16E63C926C4247520A362DE6024593FB4EBF2EF553B85E8D3F6523B0B1735EDEDD972A2459034E26E1E7E0CB45C7867502E50BB0B09D136ECFC30B76D51542851EAAC903CA75AB76B4345049AD0D14148A7272CA492CA492CA49256DBFB43136EE00966D956260B5C32D11A881DDF23354B8DC134BF3ED7DFF845C3948A25796F138C68FEAABE62F69F34A04F0DE90EE4A92D839A8B8EB38A67456B0815B976DDE24024807B381A6B5247C21A1C2EFE7FD977A6681A1FA7F74E3641CA24418122663C279F9D68C0A0ABCADEBA92CA492CA492CA4925ADF0DE94C2A94586BCC341C967DA6FC073A8DEF0D53451179BE491B606F5BD85CAC1DBC8AFCE575A0CB8235D1028B36FE3653DD6063A2F1F393F18AE74AFDAD37D9DB6BDDC6DF10BF7188300B129709E058924378493AF8D1114A362A29A03D66AB1E8941ACA492CA492CA49255DF1DBEA88F66D997610C47B20F1F7D432C800A44430971B2977666DE6B76F2CF7B91234F865FC6832F6D77A24C56574C66F4DF642A1D448E214CFBB4A6F4CEAAB4840DBBA47F73B7896EDB4B2FA5C550A09E0F020478F851B0CC1C2B9A1A684B4D8D934D4E8759492594925E3B00092600D493C079D249567BE1BEC2E3765635B6A659B81623847403E750C94E148A8A223550137E6EE45509047B4189274E60E83DD404B102DA02BCCA25B18BB2A26D4DF3BF710282C3819903506472F0AE451B81049D974C6D1B04FFB99BDC98B5C8F0B7D46ABC9A3DA5FC472AB263ED032C59351B268A9142B2924B2924B4BD75514B310140924F01489A5D02F40AADDE5DF4ED31086D2836EDC8D665A789F0E1404EF0F47430E51AAEF6BD20B888B2BFE26FE4D0ED796EC9C70E0F350F17BFB79AF597ECD02DB62635D641078F0D27FD6A56CE4B838F24BD99A1A40565EC6DAD6B136C5CB464731CD4F43560C7870B0807B0B4D153E9C9AB2924B292481EF5EF02E16D6906E37A83FCC7C07CEA391F9429A188BCF72A9D95EF397724B31924F3A01D22B26B2850442C6CBEB503E5A4F0C5D4ECB1439C4529044876376732EA2A58E70523114E1B87BD5EAE1AF9F0B6C7E487F0F874AB3826BD0AADC4415EF0560514825949240379F6D764B910F7C8D4FE48FE343CF3060A1BA270F06736764862C163278D56992D5965A52170950BA4A5D0D58D841439994818B81C3953229CCC452E98EC27BDD9DB9DB0C8E7EF0703F9407E357786C489051DD54E270E63363647E8B422CA492AE37D7784DF6387B27EEC7AEC3DA23FCA3E751B8A3218AB52946DE041F2A15EF47B62531300A070A0E490A259105C6F6CC53C285F6A734A9BD9DA50EB962E5975B96C9054C82388E946C38A6BB7424D8520772B7B7337917196B581753475EBF9C3C0FC8FBAACE390382A69A1319EE4C5522856AEE00249800492794524B7554EFA6F3B6258DBB648B40FF0088F53FC2809A7BD02B2860CA2CEE9730F82268373D13954D180A81D2A788D70C46CFAE09C27744BA6C1DAB7709743AF0E054F061D0FE1D28B871194D8504B0661455CBB27692622D2DCB6743C47353CC1F1156CC7878B0AA5EC2C3454CA7262E789BEA88CEC61541627C06A6B84D2E816682A4F6B6D56C55F6B8DCCE83A01C00AAF95C49B57314618DA47B606C8ED08E55135998AEC8F0C08C6D0D946DACF2A87110968B5C8660F3485CD56B8A342D2F5B9149A68A40A59DA7672991A558432263D80AB5B71B6E7DAB0C0B19B88723F8C706F78F98357513F335516223C8FAE48AED6C70B369AE1E4341D49E15D91F91A4A6451E7706AAD5F126E3166324993548F7971D55EB581A28233B37651713C2A48E02E43C9286ACC760CDB30685C4C6587552C2F0F1A2882AB5CE4480BD7B75C04AE8A50DAE1B6C194C10641144C33163AC2EBA30F6D15636C6C78BF652E0E246A3A11C6B530C9D2303966E78BA3796A03E90F6EFD9EC0453172F12A3C147AC7F0F7D39E682EC2CCCEB48B85B432003567E3E02A271D158306B69AF66EEACA82CD0489AE7436B8EC586941769E0CDA62A6AB713196AB28240F16A003355C4128B0B9E2134AE374291D509D97B5DB078A4BABC01861D54FAC3E1F38AB6C3C84515578A883810AF9B1783AABA99560181EA08907E156E0DAA2228D248F491B7B2018743AB6AFE5C87E3F0A1313250CA11B838ACE6291B016331AACB24AB22004D587DDF7C99A394D4A70EECB6A0E99B9A90ABCB060D56C960A398010B9F1A89499544C5D8A9637AE16A9FB93B78E1B10118FDDDC215BA0E8DEEFA1356D849A8D155D8C83336C6E15BF56AA9929FA4CC7F65822A0C1B8C107CD8FEED4533A9A8CC142E924B68BAD55498168D68072B409AF656D936E29A1C5A9AF8C394FDA1BC66E2E5E5EFA8A698B85250E1C34DA18B8BAAF7351A1AA50BFA52CA9B483ED96906888824887A21DA3971572C93A5C491E6867E85AADF0E68D2ACC7444B33D6C9A7D26621825A500E525998C180440593CB8B52C59341418102C949B80BD1556ACCA6AD95B672888D288662320D50D2419972DA5B48B9E14062710243A2260872050ED5D334056A8921490D4A932942C78D2BA0152B1307A38BAD92EA1072860CA483067431D780AD1F0D2EC8411A2A6E26D19C1093BD2C5F738C12084450AADEC92756D7AC988F0A2DCF6B9C5A0EA10F87AAD10AD9B8DCA413518DED1BCA958180DEE408332B683954F9C215D872E3A253DBBB68DDB85A0F8557E21E1CACF0ECC8DA50B0B7493FE82836B4128A254B9244546E8C2E87256DB564E68E27A01AD1187285C490D16E3415CFE8DB14CF80B41C10D6E6D99E30A7BBFF008903DD56D03C39BA7259F91ED7BC969D12DEF6EEADEBF887BA9710C9F55A4111C81120FCAB3D88E2B1895CD703E2AC60786B002A060F60E26DF1B64C742A7E86B8CC7407FD5F744191A46E99FF00A70ADB005B6CC041054F43C28F3C4220DD1C2D4030D99D6764A77D2E3B1391B53D0D56492B09B2E0ACD94D14B7B385B9F90DFE13FC9A81D233B7EA9E5CD5EB60AE1F67F0AE74D18E6966085DDD8ACCE2582FCCFCB4F9D12CC5B5A2C0B504AE14AE5D9577359B6D324A893E2041F9D6930D2F4B135FDA167A46E571090FD325CEEE197916B87E0147F98D478A3B2D17F4E0F7A43DC3F3FA55AAB1006B422D3BE18DE7DE683E4B76C73AC77BE95D02D053E0E11B0AF9ADCED871D3E0298620547ECB185A7F4DDCEA079015CF6767625ECEC0BA2ED4C4BA3382EC8919D80002E6200D40D4EA3DC6A46E15A75A42CD2C113C32B5286E3B18CC0CB31F326A56C607249EF6F244FD186208DA586F1665F8A354ACD1C10B8CD70AFF005CC2BE368BF7945176B3F10D146B982B4DEB5AB67CD567E94C31B1DB80A50E70D8A03B712D5B70A96D47741D047127F80AA4E234D932B4569FB565836B9EC2E71F5A21AD7D39A2FF003EFAAB2118233DABC388B623BBE46969D8BA2371E6B4B7B464ACDB215A4A34086CA44E5F8823AF1A29F8773181CE1BA818F6BDE58D3B2D3118FE31113C850AE16114D8BB532EE65FCC17C987C1AB45C34FF037CFEEA978936A43E5F642B1F773622F742C411D60C6B5578A37293DEA803C879A519B65D86E3693DC32FEEC53462251B3BF3F745B71320E681636DAA3B2A8800E824FE2668C64F216EE84938B4EC90815A7728376C29E39BE34B5B4E3C7F13D8DF91FDADF0E15384FBCD72B54D3C7B155CBE5FDD753896111A489048E20F02278831C6A71196EA50F3716C6BB77D0EE007E106C7E25A4F7ABB945EC84323E5D64713E26FEEACCF455882D62ECF2607E2BFE953617DD0E56D8636D4585C926B0529CCF255D81A2EC1AA35C409F9C6944DA382F24534DA752E37AE9D02005DD82283312C749E640124C720688C2E1CCF286264CFE8D96A3DEED2DDCB966E105D329062255D641FF001075F751B8EC10C3C800D8A661A5E901B509E730F31500D94EE1A2B0775DA70EBE0587CC9FC6B4DC21D7856F9FDCAA3C48FE42953D316118D8B378095B6CCADE1DA40527C2401FB428AC4B4900AB8E013B1923D8EE605792AA52E88E34190B5E1E0EC572C4B70AEB54188E41443764C2C93D0024FC00A9430955D262A361ABD51DD93B9B8FC51FBBB0C8A3DBBD36D4786A331F729F7548D88940CFC4E26754DA7CC5EC9B3B3B63E22D5DBB6EE5CB81F3301C59881080CC1519402798074A2034342A492674D2672AA77791C6873415D4599C0263F451806B9B46C951DDB79AE39E832903E2CCB4982DC12C7B8330CE079FF9576ED960AC84E83513E345159F87621696EE83CEB96A5A4ABBD9700BB248002024931D78D50F11B33D0EC1F95718121B0D9ED40171CAE62D0779E4A8EDD3A2F97C450C30931FF4A9BDAE11BB914C36EDE2EF0D1458433DFBA61C0EA2D8933FA4451B0F0C7D82F3E4839B8A328B582D10DFA7B7697096AD950CAD007B4172E520F4054FC42D1F8C6B4C64207044F4A0A5E6279723FCFD2B3AE22969081CD396E4E1CE50790CDAF99FF7ABDE197D003E3F759FE24E0642836D95EC715703E9998B03D43191FC3DD55F8B89CD94FCFE6B3AE392420AF56F29E045084A943825CDA2E3B47D79D1D1F542A99FE21507382617BC7A2F78FCAA60C79E4A3CA4EC11BD93BA38ABECB9AD9B5689199AE182567BC157D69227D6028A8B0CEB05C8A8B0723882ED0297E92AF5A17ED2A15CCB6C8600EB198C03D20831E6DE144CA052971F9740120E30C9D3A50A7741C7A056BFA2CC1B2E16E31101DA1679855027E323DD5261D96D777AB8C2821B6A45BBE03107423420F8560E58DCC790792BC1A852D1A87715DA4A788DB233F676476B726201851D64C127C80357187E1F24DA9D07D7E49F2621ACD3745B03B1F17744B359B43C99CC1FDA51E33F48D6D23E04D3BB8FD140EC73B905200C0E0EF276D799AEC160D718055194C95510BC240804F013244DA4184C3E188CA35ED43492C92EE500C46386271576FA00102ADB07AF3241E9A011FC4D55F169DA486F9A37031916EE4BC36F5154F9B4560764FF00BB964AD859E64B7C4E9F2AD5709616615B7CF5F9ECA87126E42817A4EDA696F08D64EAF7FBA0745041663E5A01E2478D17887D36BB559705C2BA5C4749C9BAF9F21EB92A54E0C12682CC56C7A16AE373645CBACB6ED9824C93AC2AF0931E30001A930054D0EA750AA78BB846C680ED4F2E74ADADD8DD2B584B26EDC716D1012CED1C3DA8264289D275CDAC48CAC4B0DE6B2CE975CA1256F47A47BD7CBDAC2B325AE19C8EF30FCD523B8B039C923F278535CFA454185749B04A373B5BC156E5EB8CABC03130352741C38927E1D04446428F8F02CB04AD5B0A00999A8EF55611C672DD27FF0042BB5ADDAC4DCB4FA1BEAA109FCA4CC72F990C7FC3E552C469DE2AB38AC4E7C4D7B7FD3BF9AB7B6BDB0C994EB268823454716F6842ECC8E048A66444E6487B6763BE2B1C40B8CF6EDC081044AC48511A90C609EA72CE84AC5D182E2EE6B8F96865E499F68625366D952CEA1DB44B6A016279C753D589023AC6AF351851B7DF35495317B5F198BD5DCA5BE2114024F8B1220C69ECAF955562388169CADD55BE1F87B48B7AE49826374DDB975EE5C830CE7513C620003F808140CD8B9256E528D8B0B1446DA3E6A72E1C05049D0C70E3E34113AD15317D9A563EC1BAB93208D351E22B651068680DD9653100E6CC52DEF685BD78409C832CF533AD53E3A6CD27BBCB45593303DC82FF0045F9D036E51740866CDDDB7C45F2ED3D94E8A3DBD60472330753C753C0161798588B58090A064799C9DF1D88B1B36D02633B6888A258E9AF1E7C7BC481E646A617060D518E73206A41DA7BC38CC43ABF686DAAEA88B06398264413E303CA867626CD35032631E4A08D806259DDD998F124C93EFA8CBF36E8774E5DC946B96729D784F1F0A65DA91AEB575EE0ED4B7770888BA35A50AE3E8DE475F7CD13048DC9AF2DFF006ADB0EE0E600392F315860CECDD493583C6CF9E67387324ABA668D0141DB196C58B970F055E131A9D06BCB53C795438763A699AC1CCAEB9E00B50B71B76617B424839BBC60827406003EA0331075006B25BBBE8104400D157B9F66D73DB9BCAF71FECF81D14139AEF1920C12B32227DB699F675D686C5E3D90835CBD79A9E184BCA8D84D8E124C966632CCD24B1EA6649F3266B2D3E35F2BADCAE226323140293F60810073A83A6D6C94FCE17336C2B01E3F515D0ECCD5C71F74A7DD8D7C3D9423900A7C08115B6E1D2B64C3308E42BCC68B3F3B4B5E6D573E986C95BB66EFB2D6CA791469F987F957712DF7815A4FE9F9C08DD19EDBF9E9F84816EFAF5A19692C1561FA3DC1DA5C2B6D0BCE7249214C428B6C578F3248FA0EB5611B72B561B88625D34C7E5E495B7CB7F0633BAAF70599FECF22807A12D98924711A0F2A4F7E9413F0B866B4873D25FDA167411AC0EBAD42412ACD92319DC3F09DB75370B138B55B84AD8B449EF3025C81C72AC88F79EBA75EB60BDD413716E8FDD8C6BDE856F36CCB387BAD6EDE256F005A6009402328675EEB39EF4803BA009D69B246D6EC88C17109E6B12015DB55AA19BB419B198709C7B7B71E79C572B50A595E0C5213D87ECBE88DA988C8E27811F4A309A59788584376DED8EC6C97482C59517CDD8283E3C6B8E769A2710A2DEC4D9D9B6957367BCE08072CF0D492019CBEFE5E14D7B8463551318E91D412A6308BF73B6BEE6EB1103BB9400380035900F2F33CEA97178CCC69A55E613045A2CAE03140B6440CEE74CABF8F2027AF4A0E2C33E4DB6464D89645D64CCBBAD712DB5CC45F4B2156405880788CECE222790506ACD9C2E30DF7CDFD1543F89C8E75302186F028492180308F93216103BD94925466CD00F28AA8C5431C6FA8CD85618532385BD31EE4E66504F052D1E5034F893577C2DCE30D1E5B782078A06B5FA73A41EE63325D7561AAB11C3A1AAA93335E6FB566FA401C415BE2319DA3DAB40806F364CD3C0449E47951782A925D792E4CF2E01ADE7A23FB676C5AC0A2A4B33B0EE8D18C0D24C913E67F80ABA7BC3775D9656E1DB5CD571B4B19DB5C372E31663CC8023C000741D2ABA6973E8154B9E5CE2E71B2A359B99982202CC60003E5E02A3644E71D170027609A1F731D2CBDCC45FB766077468541E45D8F11E0049E464D163062B528D18221A4BCD24DC7DE5048539941395B2E524722564C50E6301D40A10B466A6EC9DBD16D826D622E7E6AA8FF00C8FF00EB5DE88BE2940E62BE8ADF0028DF8260B18D078E9E758591A6ED5F655CAE64BF89B7608CC8A86F5CE900E54063A99F300D5FF01C33647191C36434E4814B7DA1B5B0D743D839F22B64397405871120EA048F7CFBAF3138F86226375F6E8A38F0EF78B08638B1611B2C2A03C79CF2F3AC7CA5D8897DCBD760ACD83A26EBA293B2F057AF90429B36CFB4C3BE47829E1E647BAADF09C11CFA32EC869719C9AB86DAC1E153EEED9B97B1024C8BACB1032FDE329011466072AEA4C69C6ACB111E0B0B153DA2BC372A08CCD23B42A1632E0014139980127A91C4F86BAD65A26D9246815DB1A6B54DBBA887B363D5B87901FCFBAB51C098440E7769FB00152E30FBE0248F4C9766E61D0F008CDEF6207E156189BB0AEFFA7F280F27990AB9C8A1499800124F950BA92B4CECAD6971E4ACFDABBAB7DB62D8C25951982A769044EA33DD806266E66044CD59D68BCEDAF19C97253D8BE88F16E7EF2F5BB4BC4E85D81E900E59FDAD3A534B2D10315D1EDAF3FEE9E3616E9E0B0AC7B25FB5E2471778CAA7CC02A9E5A9E14800340A396596539DE6909F48D8D74C395BD88EFBB15166CCAA81F93C733B004492720E624A82E27B5722198D342AC5ED80000BC3E14183AAD2B9A43405A6EFDE36F1165C6852F230F730AE93A84E0CCD0BC1EC3F65F476D882CA0F4A30ACAC3B20BB6367ABFD9D34EF5FB67FC1370FC908A6D6A139EEF74A03BDBBB78AB98A172DA0CBD9E40C4881DECC4939865331F0D386A3E26132E9C93B0D89109BAB52701B8F70057C46245B45F66D88F8B3EA3970150B30118D5FAA9A5E232BF46E9E098B66E0ADD9B6461116DAC19BD701D63DA3305BAC93CBDF45B76F7079A089B3EF253DE202EE2ADA8B8F74DA8662FC0100C77602A133C0004684F214163A40D8C82774760D84B81E4144C529327F9F2ACFD001681869396E49FBA5F3607E335A1E167F8079FDD51F151FC87C92DDE75B975C93A9627E66AA26712F24F6ACD0CAE7144361ECD0D8CB4DA11695DFDE6117E458FECD5870C67BCE727867F2B7BACFE140DECDDFC55FC53B84014850A588CA00E3DE27893CA2785584B1B9C50D888647BF6F5E2BDC17A3D680F89BEA8A38AA0E5E2EDA0F85264006EB8CC0D0B794CD83C0259B6460EDDBB6A3537AE027CCC182DA4EA48D478CD4E286C8C6B4347F18AEF290F7BEE0B9898ED5AEF67C737006003DDD154CCE80489D64E8B0CEE154AB7172026AEFD7AFCA57C7DBD6840755046744FDE8BAEE54C47416D0FC03D7038B5929EE3F956F81D5D5E09830E8ADA8AC149983A9686E966C9B483177CCC7DD584911A19C41FD9E2B07A815AEFE9CB187713CCFE020B10EB7043ED7A3FB76D999AFDCC858B68D9627562664712797BEADA4C1C6F36E4D64EF68A69463676C5C2DB6CF66CF6973FEEB966F7E7791FE19A7B228D8298DFD7EBE4A373DCE36E2BA6D9BE88A5AFB98583D9AB155D7806CBABCFE4EA4F214E71A16F290EE4A583C266B972F9529986554E8B32640D06BC870D75249272BC5316D95C18DD86AAD708C2DF78AE78BB70D41466C2B1BD13AEEA3FDD30E8E7E605697813AF0E4761FC02A87163DF07B9217A601F7F6FF0053FE7356188DD5BF05EA1F1FC2AE09CD6D97C08F71FE4D0C34702B472073A1735BBD2B5F7277A5FECCAF88B986467020DCBC96CBC482E4076EFF0009191208E7CAC0158596219B28074EEF5F728CE2778706DFF3388B4408196DDD6284B18019540067F258B71AED84CE8DC3AA3E682EF86FE2D843670F61C96195612E2A01C8E65004113A212607B24CAA253A38B33B52AA6B38BB97EE9BB79B331E11A0006A1500D1144E8A3C49D4D0D23C9D02BCC2619AC6E67797AF5DEB5DB17E3BA0C13C7CA9A14EEB5C365FACA7F3D7EA2B8EDD1710FE171F1FB2FA2B6D89BBEE1F8D18E5918BAA96F7A7157112C5C45CD92EC15FCAED01B606841D433099001209351B8904527380A4CD86DA8C106736D481DECEE01F220C153E608F3E25E5D435436551936CE1334E7176F41600335C3A402524401FA20536DBE2577294A9BCFBE176E936ADA359035171D1D1B5D25038EEC6BF78C011AC09222196520683D7DFD7253C51349D4AE3B3AC2DB4CA4C999CC260F1D04EBC4F13A98ACF493995D6AFA387201F55CF18DA71E3C4544E28B8C6A9DF74122D5AF10C7E249AD170F6E581BF3F9AA0E24EB91DE5F8490C21C9E798FD4D533F72165468EB44B038FB89894C8A585D5CB0267BB2D22398D7AC8274347F0E7D580A52F70905734EEFB4606A55606A59D47BC4C111CE57DDCAAE2D15D256FEBD782827696154C9B82EDD0334662C44F35110BCFD50098E75CD1333C777B9F5EB4499BD1BE372F1C9655ADA8397390CA4CFE403194C7B47BC0480071A8659685841E23144E8DD12F5B40AB14366CDAAAC283E3AE12C7A0E1482218282B03D1D081891FDC8F94D0E4FF14C7FE27F2ADB01D7F923986EEB0E874AC64C2D6810DDA28D63163119DD6DB290D9412495CB95203AE87BC4132019041062AEB81E358D69638D57D50B3309D9491BF7620B018B3075CD6D00806388044796B35A4F6C8AC0BDFC3ECA1E89FBD22D7B6D625D26DE1CA3130AB75B2CF4272AB14F2600F954E64711A051D049B7ACDF6C4A7DB7386965589ECE78C248194113DE198988CC341545C4DD886B0BB90FA77F7FD917870C2691EC45C0178401F874ACDB012AD636EA8166CCE3C48A3366A25DA353D6EB7A8E3F3BF0ABDFE9F370BFC7F0150633AC120FA616FEB1687F75FE66AB3C47595CF041FC67C7F01577646A6873B2D2C6B98D907117ED5AB4B372EB40E8248059BA28064D4D0171D1537166C118CEE1A9BD3BF456C6CBDCBC26CBB6F76EDF08C4C7DA5D6D828B1EADA0D21598F8316888E146014B2EE94C8741E48B6C4C56CFC4AB5AB7706211DBBE2E5B5124680C7669CF981A18E14810B8F6C8DD4E8AB5DF4DDEFB163F2A99B77A5EDF5074CE0FBC8D7999A86567356BC3F156321F5FE5286D607B4322A26AB37B6B5AD16F82D20FE70FA8A63B7474007447CD7D19B547DE1F21471DD62E2EAA8C70EAEAC8E032B02AC0F020F106B957A2794998FDCFB0F895C3E1B20608CF74B22B0B6A2320217297662DA0278027CC6740E73A83A873EDEE4E12B631B027BD1E1B3F0981B496EEDEEC4112C02A1B975B8B3300AC4A898EEA80BC262A721AC144D0435B9E6C6E8CE1B0F85C5D9ECD61D02C2315198023589D7989D04F8EB5CA6C8344D36D3690F0E1ADDCB987732F64E59EA20653E06089F1ACF62A0E8E4BE47EEB45849C491D1DC2E78CF5BDC2852AC63D9585BB622D58FD01FBB5A6C1FC16780FB2CCE3BE23FC7F2916249FD23F5ACFB8EAB3605A96D8757B7958693F0A6B5E586C298B0399450DD89BA4314F77B360B6ED982D94196FC95120481C499891C758BBC2B1F232DDA211985CEE397609CAF61F078455B4D7C59580020542EE74059F32B1624FB5028FD06968D2D8E3F749AEEF56A66D2D91631969C08CF972ADC0A3340D403A0E6263483D2939A1C139D1B256FE55577332E756D190956F31D281C85BA2A27B72BA8A5F63EEAEA25597E8FBD6C48FEE7F1A10FC097FEA559E07E223B96B19215A15DF686216DDA777F555496F21CBC49E942C4C7C9206B372744CBA51F77361A7663138945570C6E004CA5A449CB1C1780CC5A3DAD3808F47C160990462F53DA829667487BBB1721BC3641175709990B09BEF018CF0700867CBC20B111A701AD45FFC9E1BA6E886AEFCF65AEFB3C997322BB7708B88C2316EEB20CEADED2148607C7969C3EB46CAC6CB1104289A4B5D6128D9C69BB8747220B0D7CFC2B152C22194B0725A1C33B30CCA3E17FB45F3A749D42A797A853DEEC7AB73F487D2AEFF00A77E13FC7F0A8319D60ABDF4C47FAD5AFD48FDF7AB5C47595DF03F827C7F0120271A18AD1469DBD0CDA56BD89BEF336D60740BACFBF53F1F0A3E16803458DE2933E592DDE5E0847A5ADB0D7B1EC867B3C3A2285E41DD43B9F168655FD9AE4A6F452F0B8DAD6BA570D9337A0FD8AC6CDEC4DD5EE5D741681FEE49971FB472CFF767953D8DA080C6CE647DA05BFDB6062B6A30423261D7B2079170C4DC8EB06079834C95DC919C3A02467276487B59FEF9B8C6BFC9F7D300D1583A4B703C8DFAF9AED85F501F1A81FBAB8C28B897D1FB4BFB46F21F4A3CAC447D5516F5DC88EF139519A3AE504C5709A169E86FA3FBB9ED5CC43FF6976F10FE043E4503A8CA53E1E14A33A5A1DFA94A5B4369FF006D8A612F759A09FC8CC45A4F05080131F9C6B3D892EC4E2725E83D1FD0577866B61833F33EBFCA7EDCFC17D9B02972F00AC11EE313A6457637329FC98113E3357F1B7A360BE415248EE91E48E691308DDADCBD883A1BD70B81D10CE5F7E50B59FC6CD9E5CA397DD683050F46C04F35A62CF7BE94215671F55589BBC7EEEC7EAD7F76B4B84F82CF01F6598C6F5DFE27EE9193F1359D2B38D5EED3C535BB0597D6981EFA7C0C0F7D14E91E5B1D84EFB36E5BC260432EA16D35DD789CA93AF8C05135A714D6E8888C88E2BF3553DFBAEC4969B97AE9EF6925D9B8E9F203C8555FBD23ED52925E6CEEADCC05B5C160C3DD3ADBB2A2E19E250701EF303AD5AF546AAEDA0451D9E435550E6660EEFEB39676F02C498F9D059B32A17BADD697B31278D245D50567EE07AF88FD49FAD02FFF00C79ABFDA51F80F888FD62DC568908DF5572B632FABDAA661C8F7D3286F03A8F7D1FC0CB7A737BE95F543CBD547F7C5BFAB76234576B36FCD59FBEBE59148F7D6D31F298B0CF70E410B0B7348014B870CF8AC5261C696D21AF796923C88EE8EA493EC1ACEF08C1890E7F55FB3EB747E2E5CA3284C7BF38F8B430C87EF6FF77F46DFFD463D34D078915A2C7E25B0445C503044647D04B78EB2A96D557808007BBF8D6318F73DC5CE5A2C38AD142C06B716A59B461524DD429F376385CF31F4AB9FE9DF86FF0011F65418CDC2AEFD317FCDDAFD40FDFB956D88EB2BBE07F00F8FE02424A1CAD0C689EED6F39C03DD581D9DEB6E2729255CAC5B242EA564006358268B81F628ACD718C196C81EDE7C979BBDB16F6D9C6BDC7EE23B8B97D94180044A27E7405127ACEB06A40331B40C92F41108DA6FF7EB7561FA4CDE76D9D66CE1708AA8CE85563416D00CA0A8E647293A183AF0A7B8D20F0F0995CA96D9B7FBE157969C753D4F8D46D6EB6559CB3DB4323D869DEBCDA8A7B6B9A46A01F803F8530D22581C497555E87EFF008F92916C427F3D050EE3AABEC38A67AEE5F46638F7CF92FD2AC16159D55A2206041E04107DFA1A5569E94B158FBDB351ED04560F715EC3490AC4DD5372DB40255A092394031C22A1CFD134E6E5AA6088BDC00E7A28BB8FB0CE25ED7684361F0A009E576E281A78A833CFD91C8D0983C38CC6623576B5F653E327A0216F2D09FBA27BEFB69AEDD7C2081653235E33AB19CC13C01EE933C80EB4B1F8A31B72B773B7EFF49DC3F0A2476776C101B18A572726A0687FDB8D52362734FBCAFDAF6BAE8AD3103BD31C69AE5333AAAC4DDFFECECFE80FDDAD260CFF000B3C07D96671BD77F89FBA4643F5359E2B34177BB605CB454F3FAD26BF23AD4A5B9994B5DABBD0E70BF676550E43DA7249816D802AEBA6BA08331AC75ABF18A6BE3CC1432E22A3C846BB225E8FF774BB0C5DE1A0FEC57C75966F11C00E4679815261E1C82CA760F0FF00EB779217BE7BC4712ED64776C5BB9D7D7651A4F45064C6BAF95478898F5428715882F3906C962E5D0418E1AD363690D40734BF6D7F9FA5751CE5686E01EFE23F527EA2817FC09BFEA51D80F888FAD629CB44BBE3708B750A3CC1E86083C883C8D430CEF85E1ECDC28C8BD0A50C43DFCF6EDB335C655C96403EB942D92E5D58D322B904CEA72C098AD89C53F1F1B636E9FEFECAEEEF4C310C39CC7C93C6CDC1A6030AEEEDDE8372EBB449204C69C638003C7AD5F451330F1D3504E7179B2932D63CAF7EEE6B988BA07746ACA352B6D401EC83240049249D66B278A336366A1D51A0FDF9AB4883206FBDBF35E62F132B2D03BC548322082646B064107E14C3018CE5AD42B1824638075AF7003BE3879F969504C7DC2A498FB853B6EBF0B9E63E86AF3FA77A92788FB2A0C66E1579E98BFE6EDFEA07EFDCAB7C47595DF04F807C4FD8242434315A08946BD866BB7AD594F5AE10A0C49127520738127DD53C0DB553C5E6E8C8F057A6C6C32E02C5E5B285858525950497B844A5A5E7A0224F337264411460D164DC73149B81F4778ADA37FED3B4EE95CC17EEEDC4E80699BD5507530B9B8FAC0D20139CF0DD0235B677270F604B5E4C3606DC37656D076B75D471B97189673EB401D452212648EBB1BF6AA4F6D5C0B88BA753A8807A15119BC62A323368158B26E87DE76AE3CBF7EBFB77C13136E5B8924D0B300090168F86BE47C01F21D49257D1F8D3DF3E4BFBA28E58E6755661CEB493900DF7B2D74E1AC2CE6BAE56418850017D7948EE8F161434F0F4B232F6167ED4A464C628DF5B9A0A6DEC6B60F06170D6F3B665B3695468CCA62EB9E10AB0C01240EE0D60D10741A20055EA85EEFEE135C1DA639CB3162E51091998F377D188D0001638716150370CDCC5EED4EC887629D9046DD07D541DBDB05B0C0DC7BF696E1EE58C3D8B41446691249CC74CC4B1D79CF2A6CF1B0B7F93927E1A593354637FAA4CDABB4AE5A616D5C35FB8401AF72DCE838F3E1C7CFCEBDB878E5FE422983E67D7AEEB37E26485BD1836F3F21EBD77DC9B00FDDDAFD1FC28EC17C0678041637ACFF148B68E9EF3542B30D53AC1EE8A8CEE8866CA26CBD9431189B99C85B7680772741CB8F230013AF855D70F8ED998A10459E524EC1366F16D2C42DAB7670D6CF69741E51D95B884CC49856263AFAAC003564E27608C95EF0D0D60D4FD07AFCA17B1BD1E0099EFBF68F04ADBEF2A663C0DC3A3B6BA9F578F0A8DB001A9D4A8A3C10ACCED4FAF34037AF61FD9D66E5DB66FBE82CD940B6D1003EF0232C13AF1E3C439CD006A87C444D66AF3AF6055C5AC41CCA8A67A9F2E31EE9A80B74B2A4730517156C6E01EF623F507EA2ABDFF00026FFA944E03E223CBCAB16568910A053108DDDB599AE6208199EE0B587E842E6924740DDA39EAAA23857A270AC3745002773AF9FF00842E2A4CF21EC1A299B7B60DEC55D54370A61ADA8D265AE34C9267BA07ABA904C83A41AB09A274872F25035D975442E6EF584B2E8A5ACE61DFBCAD174FED993EEF84539B878E265374EF48BDCE3675559EF97D8D029B60AD8B7A68497C43CCC6BAE40471E1C6222ABE67667F4700D7993CBFBD7245C00346790E9D9DBDDE085EE56D0B989C59766CA96D216D2CE5018FCC88E3E3A4557F13859061B281649D4F3D1130CCF9DEE713400D07256FEEBF0B9E63F1A9BFA77A92788FB21719B855F7A631FD6AD1FEE47EFBD5BE23ACAEB821FE13E3F80ABF56038D0C45AD031C1A2DC9A3D160B2F8F376E3DB516AD9099EE2292CC78AACCB4471D0098F0A330ED2D1AACBF1AC43669006721EBD7A169ED0DAF83D9D600C45E5E258CC17B8EC4BB3051CCB1274D0511B2A40D73CD855FED5F4DA0C8C3E1980F65AE32C93E4242C71F6A7869C6B96A4108E6907686F2E27197F3DEB8489955E4A3901E407C64F126B8A669AD906DA96F36258752BAFEC89AE38D0B4E862334C23ED2892205480341FC281792752B6D046C8D9918340BE85C6B77CF92FEE8A3D6119B2D52F05D5880073274AEA721BB295B1588C45E462A2DAF6161CA985275BCEA1803983684703D9ACF0AE36CD95048ED6917DB1B6B0981445B8C06558B76D7BCE4011A2CF4E67E35D739ADDD31AC738E89136C7A5B660461EC953C0339591D098907969E1C4CE8C2E2764FE8C0DD237F4BDEB8E5DDC97220B7B44749E43CB8F39A88C4D26CEBEBD6EA76CAE68A6E9EBD6CBCD8DB3FB6C62CFAA8039F183DD1F1FA1A1F884FD1406B73A29707174936BB0D55E1BBE7EEEDF97F1A7E07FF1D9E0BB8EEB3D22D93A551D6CB2CD2A5362D2DA4B18D0FF00BD3046E7BA805387B5ADD5356E9EC73F65B65E54DC7ED6E8220B006513A8121267881046B5A8863C9186852C319C809E66CFAF5D8A46DDDEFC26149CCD9EE7E45B8661E72405F8D3DCF0D5D93131B0F69EE497B67D265C752B613B39D3313AAF0988E278EB2227C24C4E97B10B2631CE14DD1265DC53DCCCCC49669249E24D21B5941816EB2816C5C3492E79683CF9FCBEB5148EE48BC43E86556BFA3FF5EFFEA0FD4500F1704BFF005288C07C44790D62CAD1285B7B7812D232A77AE153104F912201260F38891133A17E0B87BA5782ED069BFE76FDD6B55AA8DCEA45361ED5C05BB168FDA2D0EC105B3DE2B0C40CDDD6839B4E6246BC24D7A331D1E50E07455E41BA4036EFA510095C2A0313F79701D7F454107DEC4791A89F893B3079A7060E692F6DEF662B1232DC684990A39CF0CDF95A1F2D4C0034A85CE2E3A94B64176FDC26D8278C8D7C853A1681A05D712774E5B87804B787B6E20B5CEF337C728F70E5D49ACD71699D24CE69D9BA0FDF9FDA95C61A30C82C6E75564EEBF0B9E63F1AB2FE9DEA49E2157E3370903D318FEB36BF523F7DAADF11D6571C13E19F1FC05596350C813EB08035249E800D4CE9A5322D761AA3B1C4348CEE01A47F9F1E5DC85E2D9640820AE9AE8647111CA3C75A25808DD51E2648DF4180E9CF6FA6BF52574C360EEDE0F714170A573BCCC172426624C9920FC2BA4868CC5451B1F2BC44DDCEC137E02CECEB2A03DC85BD8364BAF2CEE2EF6B63B40A9D9E542A05DCA4169035F14D7876C96230F2C3D6EDD0820835A1F91DFBD49C26CDD8CB7CC621D940420166CB05D85C2192D316608108431AB1D47057A82DC97F799F08D76D8C3210C849BAE734B9296B27AC7930B9C00104719A64874A45E0232E98389DB55130EF287CCFD0507205ABC23F3309EFFD2FA171E7EF0F92FEE8A396299D5495BE388B99F2330B7682839CB0412746963C39081AC79E5663ED71C92F696DBB76990E0EE5C0EA08674CD6D3A081399C805C490B13A014D01D7A15C05801B1650FC061AE622EA35D2F919876979A4C282339CCDEB15066249D4571EF647AB8EE9CC8DF2921836F24DAB80D9EA0D8BD70264BD7194875666536AD7661AE6450149CE780822279D398E6BC5B4A8DEC7B1D44515A61B03B2C027B766EF371621A05D014045B5DE06D4B67CC35E5D3A137DE5AE16CDAFB435EB00A5BECB24778E66CEE4B0CC67D416FDEC78455571491A408C6FBF87F9573C2A075990EDB78AB3B761BEE6DF91FC68CC1FC06F8217887C47A48B274F7D521E4B26D40F11735FBD20413DDE3F00353E67E23851EC143DC1EBC542E3AEAA10DA171332DA77446D08562B22498217489274F1A319980A2534388BA2A56C3D91DADD5174B5BB67BC58C2CCA9290584778C00D046B348BD8D7538D27C6CCC75D02376F66E05D116E5E5B4D6D583057B3989EDAE09776015CAA05D3424111A54D4C3CD4B9222059AAF0EDFD2E56367E016D2B35F2E4A82C038124DB7254A842D6E1C22EA4CCCD48D02926B62146FD7F94A08A886E76722DB31280CC85F66675E1D75A1A420BB45C98873B4E4AC8F47FA35F3FDC1FA8A05E6A194FFC4A3301F1117C72936AE056CA4A34369A69C75D34F1D2B1F19024048B17B2D09D920E236D59B64B806F3C804A48407809B87BC74E19758D25622B44CC1CCF197AADEFDFFF00CEDF3E7AD143191A3BD2BE2B18EE7BDA4700348079758F3AB4646C6051BE573B74EFB0B7405B537317963B177543DA151014AB5C368F08339419323A1141BF8844CC4981E0F217DEED4683523BC6DCD70464B6C2F313B47665D426E076BA2DDB411DA29EE5A45FBBD0A921C34E7E2235AB3390EFBF9FAF9A8D72DE1C7ECFECF25AB6B2F9903B236550C18213DA333665959207106229D6D6B4902FD77A7345902D17D97656D0B5693D55D07E27E26B213B9D26691DB95A33188E2CA3927BDD7E173CC7E3573FD3BD493C42A4C66E120FA62FF99B5FA91FBED56F89DD5CF031FC67C7F0155381DA9730F8B17D20BDB7240331C08234208D091A10472A9A3ACA2957E3333A77879BD7D0F24E1BBFBE0F74A61CE1EDB2839FEF1DDD02A5D378128DEB5C2CC10DD273106483CF92C9D1B732AFC43C44DCDEBE6B86DCDED58BD66E618DB3705A1DAE7476636AE3B8662B6D15FD70A200202899E5C71E959EE22F86E2F0EC99B2B8E82F96C48ECBE494F68E2EDBAE939846A781113A4181334D8A3734F72B3E218CC3E219A5E715A91B8DF400D0BBD74D7E4B4D988734C18EB0635E1AD4F615235E09CA0EAB7C6DA22F5C246A623E02A37B81D15AE0E17C76F2353B2ED833DD6F3FC28595683026DA6FB57D09B5490EE40920081D61069472C633AAA87FFEA1BAD8A6B98B1DA10AE9948422D16D2515814953C88D635D75A4144E24EE8B61B6AE05C2C60E195753950853D9E5E19C7DA0E7EFF7F2F314D73805149208EB31DFD7AA53576EE1DD0DBB36AE5BCB719C2F66CEB95D6D8719509CA4946307419841341639A5E1B5B6BCC0F0D4AB3E1F2B185C49D4D72274E7A0ED4BFB6B1169DC35B99D7386CD9A679CE9A0D23953B08C958DCAFF002AAA4B1B2452383A3F3BBB5CF67E1DDDA114B1F01FCC510F91AC16E34848DA5E69A2FC1356CCC1B5953981CCC648D3C87870AA3C6CCD964F74E8168F87C06288E6DC95656EB37DC27937E356B833FC0D553C447F23FD72485B41D96C314F5873D34D753F5AA98435D200E591D9A876C0DA96EDA32DDB42EE6B88E49CA4B0527323165260CCC82351AC82455C35C069498246B49045EDFE116B7B67032CE7084A8CAAC7B3B52D198BF7010B6E41419D24F77853FA465D109E248AFABF6FF01737DBB61D2D44AE4B56EDB29058936D601420C7BCEA7A0A0710C7BDFA0E407ED2323687CBE497B68B267250CA9D64CCC9F589CC38CC9A9A2CD97DEDD42EA2745CEC82418D78D16080354DB00EAA15A5CAAABE1FEFC2873A9B53B8D925597B81C6FF00EA0FD450327C09BFEA51B80F8A87FA532E308B95B2A9B8038920B020C288E3AEA478552F03C87126C59AD3BBBD5DE22F2253D83BCF730AA1151580BBDB096702728560C1480E3281123BAC246B5AA6BC84123B637EEE05CDD829900006E3966088C83B76227120C930D1C06B4E326BB20CE2C094B08D073EF5287A42C39545B969DA1511AD96B66DFDDC4309125B41A181A0E9359EC5F0AC44F3BA663836F63ADEC1B5D95A78EAACD92B434049988B81EE3B2062A5891DD0224F021640F755BC4C735803B703D6FAA1A59E261F79C0789011AC2EEFDC616EE5C5CB6D583C371603580BC7E3424F8F8DA0C6C36EDB4E5E6AC7098573DC1CEDB74CF86BB2EBC63420F233D0D52BDB4C2AEA4D5A53E6EB70B9E63E86AE3FA7BA92788FB2A1C66E157BE9909FB55AE9D88FDF7AB6C48F782BCE004746E1DFF8557E36CDB452C41667631AC44C9AE46E7B88034A52E370F87C3C6E91E0B9CE3DB55767D735BEEFDDCBDBF26ECF4E3F942639F4A7CE2F2F8AC8E3DA4E5F15376263D2DE6B97905CCE38FB49CC1B67D922A2901272B56AF876163C3E143EE8EE4FE0F7221BC38CC1DD5ED6D67ED8411996D81E25B2AF7BE3CAB8C0E1A6ABB3E1639E170786915A1177F3ECEED941B58D76B60127561F207C78548C8C07E8B238284367B1C8725076CA430699913279472F3E152917C968192E5AF7B6D7CBB0769EF5C7653662CA3598F9E950CCDA0159F0BC4B5E5E2F6A3AF9AFA3B688FBE7F023F7568B5988FAAA96DE2DD3B382C3E7C45D67C45D63916D8EE0035692C3C46BF01CE9BAA616D6A52E6CF42C328D0B3AACF499D7EB514AE0DF78F204A19D099A7647DBA279B032205B6008E0391FD23CCF8D679E73BB33D6E62C3B208F2443650B78B54174001D6016004952620F582441F3A2B00EA7F46763CBBF754BC77011BA0330DC55F7DE8B6D8ACCC336660011A7AA9A7366E2FE434D35352627207550BF99F21B0F13E484E0B0B9B058D0124F60ECD4EE76D869DA88DDB9EDE691C0BC403D320E809F7F534148CA205797ECF6AD040EB04FD7F49E7712E8B96160CC330FA9FC6AE7002A203B2FF6A9789F5DC7B47F64AD8CC197B450684C7D41AA5649D1C96792CA1612CA09731D854B6722924AC6627849D74AB386473C663B1D9052801D4A0DEBA55160C496F8E63FED52816E2BAD6E63AAE3A9198703A9201D23891E73F1069DDC53A86C574B37D4110BCE24EA7FD3DD5C209DCAE3986B5288A39D48F1D380FF005A700280433A90ABFDD99E1D4F3AE56A8B67BC02B13D1C19ED8FFF008FF88FE141CADFE1987FC4AB1C07C545B6EEC1B78B5B6970B045B82E10BED402209E435E5AD6370B8E7E15CE7306A456BCBBD5F3E30F14555FBDEB6BB7B8B670FD925A6ECD9BBC64824027909E3CC9899E55ADE1A64E85AE964CC5DA81A7AD3E41072D5D01B2D773B652627176ADDC3F7696CBB81A4E4200527C5889F006A4E298A761B0AE7B37268775F3F90F9A070B87E926735C3993EBE6AE2B6D66DAE455455E1954003E034AC393348733B53DA77F9ABE661CD501A2ACF7C30A96F188B6011DA2E636C01954CC0C807E541D3A83D6B5DC26691F852663D535677AEFF0ED545C4B00C1200C1ABB97D3EA8A2610ADBD3BEE6254B66668E1DA3810141F64683F3A877499CEBA01CEA80F01B927B4EBE0B491B321DACF67ECF6776DE2B738B28E81CA29CDC24EBAE867969CBC46B5008F334E5B28C91DEEEAAC6DD6F56E798FA55AFF004F7C37F8FE150E3370AB8F4DF88CD88C3DB000296CB13CCF68D11EEC93EFAB799DEF52B7E0B0BBA373DA79D5787F949FB3FECAC8897D4AB1CF9AE97B82263B229965401ACCA31E10398E46185158D38ABB1B72005EBCFBEFB141C16C05376CADBC4E1DCDC52C54B3A95586CD9C94CA0E9A2CE6D57489353105CD59FC5B1BAB0020F2BDFBBFBA917373B145AE046B0D6D02B6717572E5B8C45BFCE04904410223CA9359CCEE9EDC5C9D108DDD94B3666E6E2D995596DAE6B8D684DEB4333A09655EFF0078C6A2293D9CC2E0C63E388B4762E9B3F66D9B96AEDFEDCA8B2C96CDA16C162D75F22431B8AB24893F923AC5758D206BBA1611906BE6A7DDD82A8E6DE22F5A5EE392A099636CAC0437022192DA1CDAE5689D25D488CE01D47D52DECCBD6B0F8D66B44DDB366F2B2B3083715181322044C1F88A866A1455870B6B9C2560D0915F35F406DECDDB67B7A8CA011D4F19F811F0A98AAB887BBAA51DEEC975556E116CAAB15778956238A82B074075CE22446B04708B5C7920A444DDD64602DB23DDB7172E77C0CA188ECE41E133C35893AF48E4639C0B79109A1C58448DEB34823F21307F465E2338803BC002E9A94F5C0EF418F3D794D547B24A06AD5A71C4A02410EDFB8FD547DB1B25C5B79287FB27750EA5956E902DB11234668E7D66A6830EF61E91C2801F7F0EE40712C4B310CF678F5CC75EEAF1ED23C39A9C9B2153B3FBF2E0D91780708AAAAC480B01D8B3C83A011CE6A5930F9BE1D59D4F87AFF2A2867E8F478D1BA003D7AEC5CF197AC947FBE0EDDEC81350193D5CD22619BC2214EBC2873860D6DB9C2C76230629CF700C6E87B536FA2F6CB6731E059CC7901C3E07E345E0C06B49EFFC040F1237E43F284DD670EE42CA9626068449E1154D23A37BAF6594FE469342C28FB5764ADC20DA6399EE6401FB35CE7D9D7302240F54891A4EB568C84000C66C78FADD472C59B56FD69007D8EECACCA030218AB2DCB6C0E4FED0AC34B65E71206BD2A611C8002428FA291BAD2DD7616202A28B57573113DD92B9B555206A09D6018D0D274643AC85D746F06DCD5C1F61DCB4C81FB8D7272B38609A1D758274302353244D75A0B8EA2BC527079201143BD4DC4ECB7B771AD97B659182390D08AE57305CCE143346A40981C6A6E89DC946EC2480D0F5F3A40F6EE10ADA5B8D714310A56DFB4C1E4E6E90044C4C1201D6BAE8AB528CC3C058DF79585E89310B92F21125AD2B0EB009047FE6B42B5CD6F496392270BD7211DB59EDCC837144C4713D27FD2B1317B23A71D2E8CBD7C3CBCAD5F3B365F7774A9B7F67E1EFDB26EB9B66DA976622EE5D2334AB296CCC23280E59A0F0802B49878DA1CDF677345836DCD7B6D4472F1BEE1A941B89A3981D39A1DB2F086CBAE2ECB586B6D6C7705C0AE51D80006701438214C120F1040249A267E1F24D0746F3ADD83DFEBE5CBB147D2F473091834AA23F499F1765BB4C81D19A5948CE241442E4198F641D7878D56B783CEDA040F9FF00656C388C2073F920784D8D73118BB6EEC62EDB46B776D657508C5B2717531EB9260EBC883560D82380370CE359BCECAAB6F4B2CCEC4B8757402F61DBE3EB544ADE1912C1B82EF66A4B2AB5C8926DB6497CA48404F01C874E1513F873DCEB04651E23C7B7EFAAB18F16D600DA367CFC12CEF176271160DAB9DA02E55DC6564904042A5654E6D5A24E9C62A57C2D863735A6CD1F5CD39B2BA4707385056FEEB38C8E398693EF1A7D0D73803DA617346E0FDC20B1A3DF05561E9AACBAE36D3C771EC000F29477CC3E0CBF1AB499BADAB8E092D30B7BFF004932CE20693A7CE842C2B4AD782885FC56CD2A8311661954F787684DC24A6BDD655581DA774E87BBACC925C145B416678B192399AE79046A40AE5B6F5EB9281FD46D5C636314EAE60215B57328EEB169D7399210082B1C49224091CD046EAA1CC3210036AF6ABBFEFDA543D9D72D953DA632F2BADDB9D9C0788C84ADEE6559DA14C6B075EB4E279A4D6920B40D7D7253B0780C2AE87179C1CB252C3C1EF104F7D80242F7B5EB035914AD20D26AC7AA59B4AF585D2CE76D0E62CAA04FE601AC78989E82BA571868E897B655A372F054125C8503A966007D6A29458A47F0E7E4797F71BF2217D27B42F65BEEA75023F7454AABE3EAA908C8DC63DE292724BDEEC0D8B796E3D95B65EF126E5B866685206798224742787398A1714DF7453B29ED53E1490E36DCC962EE1B0D0D92E5E96E00210AE40707300D073116C4FE719142091ED04192FC912EC3B5F207F455DA01D3E5B7EF45EE1F03852B948BB9F2AE7240612337740E300840390CC6018A699C100992BCB452881CD2436307CF5F14453058404936D9A44CFDDA8F7F1E51AF298E52626BE302B3935EBD7D54E5B313791A2FB542BF71551F288E7DD1C3C27F1A6B8173BBBBD4CDD1BAEFDC9ABD1F6A8E8260DC21678EA827872A3703AB083EB4559C507D946C0DDCBA30D46879111C6A8A565159585F5BA20D711B8E53FA4BF88A8DA4828925AEDD2DE2F0D62E5E361545B0C55004B8CA87301399471E9E55A0C2BE4318AE77CFF76AAE679E972B4D6DE0A3DBC063196D3DB7762A2DDC1DE19E0C049668CC54100024D120CA6D398E988DFBD0EC7606EA3DA4B865559EE2AE64D0BB6AC23592C2493E14DE91FB3B451C92C81B44EABD7BAD0F2EC731EFCB93989E6DAF78F9D4A2424E886E9A4277DD04DA6C8088893C4FD29AF06D15850E20A73F45E19BB661EC61DC4F9DC523E4A7E141CF19747281FED2ACB082A6B4F584C569AFC6B03343D8AF949BAF2202AB4F104C69074E04193F4F1A586F676D89C1E545BB8DEFF1DBB263C3FF00D2917176F0572EDD372C1CFDA193F74C74810B3103D7F82F5217531358D8DB9247014371E1BD6FA29DA64AD580A1876660C321447688194AAC01AE70A4119469E1208D04C5132CF2063B24B646DA11F5BEFEC4A284177BD1D5EFAFE110B3B1F06CD9912E84EFA20C864852326502320D4C69A6874AE492B7AA27A235B3AFEBBEF55C19DA09310F25D7FA23089DE5B2C6E03955C8452206849CC48009E527A52E9185A6E4BE75475BFEFBA90749985300EFBD909DBEC92994A8C80B8D0932B1E1CCC081D26A18739BCDCF4F2FECA6757E55A3B9AC596E31E793E3049FAD13C063CA243DE07CAFF6AAF1BBB42DB7E376463B0E6D8212EA9CD69CF00DCC37E6B0D0FB8F2ABE736C521A199D13F335507B6B6662308F9715877B7AC071EA37E8B7AADF107C050CE8E968B0DC55C77A3F428563ED2DDCA55F80F68471F299A747EE5A1F894A312E691A5223B3EFDDB4A8A56DDC45474009753176E25C6D4F3CC8380E04F9D3BA56A0461C8A20ADB1DB456E2B7F52B0AE44070C6410A0668E05B4267A99E324BBA46F6A6985D5A7DF5411332F4F88A5D204BA17ECBA592CED92DE6773A05B6A598F9015C2E279291AD11D9CCADBF455E8EEE59B83178A4C8CA3EEAD319604FB6FC960701C7593114E6B4DD9504D8815923D8EE99F7EB6462732E2B092CCA32DDB220E751C1941F686A34D488E905499EAD8A285CD069C95B07BFB6C314BB6D90AF107461E055A20FBE8618970EBB75EE46F420EAD72CDEADAF87C6D9B696EEA865B81A1F4D32B0FC45438AC435CD140FC94B878CB1C4943F017AE58083B4B2517340398E8C558EA3C5411EFA00CB7A01EB43DBDC8CF779DFAB1F95D717B4BB4119EC8950B98210E408E71E00794D73A4711AB47952700C06C13E6861BB6978DD24782B7C04814E6E6FF006A71942F13695B63D9D8B772EB34774713E10A098A71C3C8F3AFD947ED21A2D597B81B02FD90D771002337A9687B039963ACB1D071D079902D30987E85B5DAA9F198AE99CB96F7EC1BA18DFC3DBED01D5ED2E8F3CD93934F35E33C3A54789C0B65F7868556981AE377492D76F5A92AF9ADB0E2AEA411E713F3AAB770F906DAFAEF4D761651B6A96F6B1CD892EAC8C095225944C01D48E9563878DCD88348A414B0CA2C653F22BA25D2175E19A601911D160C0D629E5AEB423A3936A3F22A28661A7BE091E7C4D3CB6F55DE89C4EC7E45731889D095F88FA0A78D149EC729D434FC8FE56D84C2BE29D6D58B6D79C71C8BD7F299A150789A45AE7145C18191B65C6BD772BCB71B76460B0F91A0DD7D6E11C3C141E6049F793D6A66332846358D66C95F79767E3F0571AE61ADFDA70C4C8413DA5AEABA6ACBD0C13C8F093538BE1104A4B80AF0FD23A296F42509C1FA45B13172D5DB6468740C01F719F9551CBC01C7A8F1E7A227DEEC41AC6D4B0311DBA5F507B4370065B83DA900F76ACA38668DAD197515CC725266045108F60F796C05CACF869E049932A4B9823A82E7E551E499B5FC77A11AF99EDEFF00B27666937647A1FA50F19B76C368B7AC5B009202C93F42790D38571F03DE6FA2A4F64B9799287BEDDC34435FCDACC25B7F948029CDC24D7A36BC4FF95D3303C97984DA0716E96F0584371D4467702149E2CF1A0EBA9F21CAA78B87C849CCEBBE4364C7CE1A2CE8AE7DDCD9670F616DB3E77E371E23331E303901A003A015750C2D89995A282A791E5EEB289D4A98B5B8818104020F10750692480633723675D92D84B209E251721F8A41AE650A412BC73436E7A2FD987FE8B8F2BD7BFF007A6F46DEC4FF006993B7E8169FF0AB6673B570F9DEBBFF00B52E8DA97B4C9DAA5617D1B6CB4D46111BF4D9DFE4EC4574302E19E43CD30ECFD9B66C0CB66D5BB4BD2DA2A8FF00C453944493BA9749716524941DA5B1F0F88117ECDBB9D33A2B479122457080774E0E2DD8A057BD1D6CE6D7B0CBFA372E0F9668A618987929062241CD473E8CF01D2E8FFE46A6FB3C7D89FED72F6AD97D1A6039ADD3E775FF00035CF668FB177DB25EDFA29787DC1D9C9FFDBAB7E9B3BFC9988A7889839263B1329E68F60B016AC8CB6ADA5B1D11428F90A78006CA12E277522BAB8B2924A16D0D9362F88BD66DDCFD35531E448D2B956BA091B20389F473B39FFE815FD1B9740F8078AE6409E2570E6A1FFC2CD9FD2EFF00FB09FAD70C6D29C2778E6B61E8B767734BA7C3B5703FF122B8236848CF21E6A7613D1F6CDB7C30A8DFAC2F73E4EC45383404C3238EE530E170A96D42DB45451C1554281EE1A5393176A492CA49283B4363E1EFFF006D66D5CFD34563EE2448AE1683B84E6BDCDD8A0988F479B35F8E1C0FD17B8BF25602986261E4A4188907350CFA2DD9DF91707FF2BFE269BD0313BDAA4EDFA2D97D17ECDE76EE1F3BB73F0615DE859D897B54BDBF40A6E13D1FECDB7A8C2DB6FD32D73F7C9A708DA392619E43CD30E1F0E96D42A2AA28E0AA0003C80D29F4A3249DD75A4B8BFFD9, 1, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (3, N'0 độ', N'0 độ', 1, CAST(9000 AS Decimal(18, 0)), 10, 1, 3, 0, 0, 0xFFD8FFE000104A46494600010100000100010000FFDB0084000906071313121514131416161517191F1818181719201D1E1B202118181D1F1C1D20201C28201E1C261C1A1821312225292C2E2E2E1C1F3338332C37282D2E2B010A0A0A0E0D0E1B10101B342420262C2C342C2C2C2E2C2F2F2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CFFC000110800C2010303012200021101031101FFC4001B00000203010101000000000000000000000405020306000107FFC4004410000201020403060305050702060300000102110003041221310541510613226171813291A11442B1C1D123526272F00715243382E1F192B2164393A2C2D2253573FFC4001A010003010101010000000000000000000001020300040506FFC4003411000202010302030605040203000000000001021103122131044113225114326171819105A1B1C1D1233372F04262345253FFDA000C03010002110311003F004F8EE1969018B76D8C6AA4007F0A0F8770EC2DCF89154FEE95A3EDD94CC0B29724684B7F5069ADAC1BAA92D87D3909066BE6DE694235A9FDCF2B5CB8B14627806187C3667F9489F91A5B7B098743051D7F9907E314DAF70825CBAE7B7D5666BC4C3E63A3871B11CC7B53C32BAF79B0EA7EA0B85C1619BE196F445FD28F1C06D9FBB1EAA9FA578DC306B25923A6D511600FBEEE3A4CD4E7964DF966C1ADFA9D7F85228F0C7FE9A9FCA97DEC2003E2B40F46B4A3F2A37ECE3724A03C81A95DE236560125CED1F11A68E4CAB86D854A5EA265C2391316C0EB917F4ABED3E4DECDB6F3C8BFA536C3711B6C72891E4534A17169733785ADC1E474355F1E4F696C1527DC1571369BC26DA29FE45FD288B96D72C22DA3A7345FD287CA402A5C1F459AAB0F802E616E1FC29AFF00ECD7D47D4460813DD5B3E96C7E953BB8AB597C58643A6A4201459E1CC8B1DE7CCD4735F20C432ED147C4BDAFF361D4DF2430FC5AD2AC0489F53157E1F88A06196D891D41DE84B08D3257D8575EE20660A115B42BE3F3168738FE217710435FEEDB20850DBFD2865E236C023ECF6E3C813401B59B7044D1F648B600CB23AC52CA2B86313B0CAE3E136C75063E95EA776A7C6F9BA027F2A96331594A823E213ED503654EB03CCD65BFC8290E2C622D44401A7415CE158821508F3A5986B8B3E120C51566EB024B099D808D2A7E1D3BB0D079671A02BEF5E2BB699B27AD096D5AE300037B55B7B81DD912D964C0CC699685EF33241576EB910B940EB22BD162E303E2D39EB51C37040BFE6DECA018D8D1ED83B5A2A166079C102B2CF8E2E93FC83680470D2C64B09F5A26C028085607F78355F85E1D694E9989EB263E73563D85274553EF27E545F556E8DAB717BB82332349FDD9A1138817F0852277A6563076C1245A20F5FD0515870BB04693B18CB1EE69FDA631EC6B425BD812560120F2D2BDB56EE8D015F42C35F6A7D75949C8D07CC8DBDF6A113076B312824F3207E749ED8DF6358B57825F3AED3CA6BAAEBD6ED9632587A16AEA1ED520588F81614B942CB2A441F51D679CD683BC36981370E43A6531EC79D4704E2DDA36C20611B83A027F7B9FBD25BD66E3B4DC2028D626341CB4E75E6665AE5BBD8E44CD75C752A595803B7D77F3134A31A2C8B805E40C4890C891CB9C1FAD5B86C8AA00CB03693AFE356E2B20D4C3183BE91B7AD7141B8CA95D0ECA6F70FB6E84217DA6334FE5A500D6D547779A0F2CFBFF00D434341E071ED9CB297D49F84031076F953138F47D4E8342D2BFEDA574D6483A7BA145D8AE0770A962AF700D214803E875A5B6B1966CFF00E5B5A3B78967F1A3ED710BD689EE3C484EC35DE4FC3D08A669C74BA91730EC446C44EB5D3AF247956BE0E9851926C733DCD4816FAAEE7E7475CBD850BBC9E53AD35B4F82BB990DB16DFA0060FF00BD45FB276CC7737154F4613FFBAAAFA9C5C4AE236CF9338DC42E1D12D822AF4B571C02432F9014C715C131820A895D75583B1A13198EBA832B21CDCA46F57538C9541A1F6EC50D8253A11798FB455A8D6C0CB2CA7A1114361AEC89BACFE59748A22EE295B4419FC9BF5A76998B72AAAEB267A50A550B0CA1BDE8EB183B8C4655C9F8533FEECB283F6988404F432693C48C7B99348506D9993B74ABEDD8B8E34527D07E75EE32C580C08BC1874927E829EE1B098A29FB2BEA01DB4DBDA84F2A4AFF0051B5246731BC22E48671A6C3369ED069B61782B9502396807F514D70FD9BB9BDDBA2E30322797A4D598DC36242467CBFC52047AD45F569F962D1BC6EC0984ECFA2CE7503AEBFA5116AD066C9696DE5D8BEF150B76EE2A85FB5DA63CE4033E557D8C0951F19D4CF8600A8CB249EED8AE4D9EDFC4D9B23297970274027E8284FB7A4666CCF72341AC0F4E42A769ED5B72005679DC993573715B99B55416E371BFB8A2BE560B643077EC839AE3B663C98181E9575B4EF4127C36C1D209F10F3E95463F16AD91C36DBEBF951176E2B5B392EB2B7A69F2AD2BE7819153E203BAA27F969A9CBA6BD0D4158BB10C996D8DDA4827E54360711711614A1D4C9223E75EAF152092D710FF0A8248AAA8B4F60A414D89B594261C5C2DD60FCE4D4ECD8B9F090C7A9356E038DAB6814CC7EEC577F7BB06CB7085E800FC49A4B6B648D7B8BB1F7DF364544DF596E5E957ADA62C1736441B810268EC3E2ED39955527991FAD47895956124907611CA8F895B346D456D60030B11CB5AEA4E7047F79CF9C5756B8FF00EC12B3C4002752CD111FBC23A73D34A131B76F9CC16D45B6820F40674DE8EFB559CA3C203C6E375D36F9C541F1C860660B3BF9D73B96FB47EE73501E1B08E742F94C72D44EB1553F0C24C35F68E72D047A8E9567106B2B19C92ABCC34113C8C50EF7F0EA332B49DB34E68E93D6AB1D4F75FA052636C1DCB76C0199A46B2763BF4F2ABDF8C008C42E71B301B8E7FF001599B9C76D2C66F175045762B882807BA2C808CDBCD0F65727724C3A586B0171C186000E6C41D67681CA28E16F2804332C6FE23AD67ECF68180209CC0890DA7D47489A078BF1B65B61E6093F74C6907A55BD972C9A8F602833459435C0596E12C633281AC7B537B382B9CEE3041AE56036FEA2BE7B83ED95D0B9114931A9075A689DB3BFA6604031A913A49FC7F2AD97A3CFC2AFA8CF1C8D3607B42B6EE772D7003A982237D6053BB789475D35F227F026BE61DA1C73DC652BE2668F12A8E5C8E93A535E0BC2AFBA8CF7089D632EBE409EB52CDD0C14564D5A5F7368ADCD262ECF30A8C7F72E2853F35FCEABE18D691BF6B6B2161E1820807A19E5E743E2708560B5CB9A684000F2A171CE8D68C0733A6DAEFA469B52E36DA4AED01C99AFE1B718AB1CE17C500318D3AED57714E17870D2D6558C0D49AF9DF0CC612E1017727C390F3D361CC57D338B5D3000C9A01009DBC234DE9DE2962B911CB27185D996C6DCB16CC8C3DB9F7FD29962494828D0B1F0E9D3CCD67F8BD9BA4C85B67D1CFF00F6A7A975847810F32D3AF9E9B54F24DB8A6F727D36472F79D8A0626EB12D188603EEEC0FCA98277D7166E0C88DA656324FE9445AC54B15CA9EAAD1AFB55D7AC2B6FB8DB5A8E4EA22A969A3B35215B70CB169C116F336FA37EB5E5FBAB75878EE5B8DC30007B1AB1590B112000762C6A7731365810D90803AEDEBAD3F8CFBDB0EA2A5C459B640B4BDE5C3CC6BF3335D7D7137560DB5404FBD43FBD70D667280394A0E75D73B4E8B121C83EDF2D29F5C9EF1837F3037E8148D90653871006EA35351B10FE208C91C98C50973B4AACC14231E7A4D52DC4714C612C183CE349E5E546F23E635F361B63C1C4AD8393BB6926018D3E755DDB090C72A89FDD1AFCE93B5FC58427BB504721A9D2AB18FC6B810A441D748A58A97316BEE6B639B6D74281648FF0058DFDEA6B6AE37F9C134E875FAD28BBC3B10D07BE559E5AC7A69565BECD4197BAEC0EBBC006797952BCB14ADC97DACDAAC3EE0B76CF858003E941E2388A0048BB2DB08D057A387D819B32127F989E7EB562258D32D91AEBD4E83CE878CBE2CD1934F7163F1579D43D75683FBE2D7288F38FD2BA97DA25FFCCA78AFD0F9927140601650CC60CEC07ACE86BB2DE4BEA50124C658D411D418889AD45BE036ADB9640B2360C0104F33268E7BF741139408D0E61E903A57A52EAE17FD357F322F247B23318FE138A75D518123991CA7973D681B7D9FC582196D3382049F33ACC74ADA623117160E753EE2368E5EF565BBCA0652C15B4E720FA7B7E1528F5B922B648CB2D7633367B357480AF92DE5DCB34927A7B93575CEC631B8D9EFA78B900607AF953F06D0624BB65F31A7F2E93BD4DB8796232A5C86048D4400396BB1A57D6E5BD9D7D012CC27C0F65ACCB4DC50C342176D39FBD5C9D92C35CB796E3120199420723A74A656B87A6B9ADE58E733CB9C54570E8AA4A9503EE99913CE7A4CD49F5395CAD49D816576214EC9E1D01085D74DC9107DF9510980B4A832DC507F8BC53E54C315C52D688CE246D974F9D058AC461890CC931A49DBCB4F6AA2CD9A7EF58DAA5260988C45C0CAB6EEA65DFC2B11FD75A22CE2AF8D733183ED577FE21B2AA40B22340BA01EA34AAEDF682E924DBB0D967511F3FA5349E46AB4FDE81B831C7DD419CE7224810373E5CF9D5D76EDFBE14F70E36209F0FCBCA2A78BE38E01240491B409F4F2AAF03C631171877435D808DE748A294AB528A4FE66A0AE09C0435E9BA8CAB198F26D3580679D39C7DA5BA65906C0091AC0D00D3CAB63C1F85B25945BA433C4B18E7D27981451C280740BF2AF17AAFC51EB715BD7A1EB60E854A1FD43003825BCB2135F4AF78B3A88770C34CA23AF2ADEF760F21415DE196AF2BDBB83C2748FCEA30FC47CDE7E069FE178E9B86CCC161F8CDB5D541304684807D4D34B805E50E4E527CE97711E02B66EB2A2CB47DE3CBAC9A0916EAF86E36500E80190479F4AF4E508644A78D9E4CA3A5E97C8562380DB2F21987223F2A2B07C0ECA1274F32C679C69F2AA83820651A8EA7F0AA3176C3804B658D5B59815AF24BCAE5B006787365330296C11A6804EF507B969C0014100749A4AF824F895DAE0DA1B6F523E946DAB8408D976F3D3CEB4B125BA6D9862D76CDB00C00046C04D09778E5B56043183B89FEB5AA5AE2EAAD254EC7A73F7FF006AA82230205955CBB369331BFAFEB4238E3FF2B6061F638935D261635F4F98AB062B48001227D759A5965491333FD7E1575D0C236046809235FD6B3C51BD80C862B8BDD61A5A30362ABB7957B631979CCB1CA236E63F9AA4E6E29019C229130235FCAAE1C3D089565CC20C5379147832A01C56261B4931CD4EBE750BD89664533006B24FF5AD33C3D942092BAE9EB33CA877B6096528A5437B031B8E5B4D34671F4E06035C75881275E706BAB8D8C38D0AEBFCA3F5AEAAD43D19AC36E5DB39845CF0F205B4DF5D3A69435BEE2D316772C1A23590079751B522FF00C398A769214A91A409D373CA9861BB2374824E839113EBB72DC73A79431416F904710DC7E27053918C311E1E83CA972F11B76DF264694F14800C0891ED5CFD87B8CF05B6D752091B124EBAD7BC4BB0ACC599B11955A0800480623AED14D0F655B4B258CA31EECAB13DA75099954C1249D4403A69F9C79D0D89ED316556552436E01D8743E545E0FB116C2B23E224EE200234D88134737636C828CD75F41104003E29E436F2A7F13A38BF5FA30E9808711C69AE5B3DDB44E8A2750676A06C63EE0525FAE530624EFF00956D476630C873E68D7EBE9CEA8C6E030CB3AF483B8F3AD1EAF07BB18FE46B4B805C32DA36C12A99FF0078F2AA2F7080D0CD7432F30B56DF5B31BF909F2AB6D5E4C872E8073DF5FF009A9DCA3BC6C4B68BB0B86451972E9D4D12F8AC8BA499E9BD08D8D70045B2C36DA074F7AB143699A00DC6B509C5BDE43583259B37666DB4EF2769E523A56A7B0D825CEF7580CB6C6903EF1D3E9492C61CC49D07956ABB1D6DBBBBDE16C9A69FC47CBE552EA72D639516E9A379526692CE2D8B81032C1277E51FA8A8DCC621901879D57C3C12DE2B6EB037274E5A7D2AAB9C31C125726A7FAFCABE71C61AB7D8FA5C4A2F9630C33A91A10696F170D6CE758039CD1385B973984F6A8717CB76DB5BEBFD69420B4E4F8770A4D4B6313DA16EFC076255ADB1468E73B7D680C87C263C234327F3F5A6986C0BA2DC67800993AEE034CB7CE81C462B0E41976CDB0D341D74024D7D263A515186E91E27E250D19B8EC0EF7D4120F28DBFAD69762312558828446F069865B6AF9849819848F0C7979D5EF892C4A958465CF9B2EB11FF0003DAAD1A5DACF3EC0F0D7D6E2C1303C86DA514F7C0CA55B30DB6DAA9C0626DBFDDDB99103A5506D5ECC024656241DB4D771E82B694DD3D801588C52A90C6608F840DC6D540C429932085049E51ED4562D8154528585BFBD3BCCCFE662A816AD8CF9D1413396667CBF0AD151D202071F6CA1F032124C103499EBD2A38A0F72DC00ADCA41D7D454AF5FCC15BBA20CF8575DB9FE755DCC6DAB4A6521889D0D3254F65B81B03BC14309566511124EDCE0FF5B55FC2EEF78F057BA20C669DC7FC45556B8DC2FF0096421940635F38A0ED6259892EA7283B9D24440F39AE9D32926A4A83433B18F2978AB382448046C4F59A9E185B6562AED23478DB78123A0EB42044203436B2B2C36D36F3A1C2770A724C11E223DF4A9E88BE3930E5B8737EF2FBCCD75255C792272CF9FF0046BCA578B2FA9A8D5BDF3B67D3EF2EC47A6BBD42CE34AAB78D81234063FE7481F3AC7B5DBAED28C20CEA0C13EA29D59E14ECCA7BCCC06BB4927A7AD69F4D8E0BCCFF002049050BDAC9B876D4481A419F7E5EF50B78E4519549649D43133331ED4B2F767EE8209BAF958E8072F9FF005A51BC3B84DA2D0E59A1B553CC41CC2799060D170C295DDFC834A817178F21832A000685B7883C8F3AA171D7AEB1D5E18C820E8418E5D79FBD6A9787DACB9150912615BA6E2013A75A8AE1563481EA3D2A6BA9C6BFE3F735884615F28CEED9809D35074A20F0EB6560862488276311D3ACD33C2395E92349512049D41E5B49A9DBC7ABB3282C4A8DE2018F5E469279A6F8144D7382D8C84852CD9801A990235244ED4559B211542CAC6F034F7A3EE5D52394813D0F3A1C12549981E7AC56F166D6EC6A3DC46E814EDA340D0EBA7A69A50BC4AD9000063CCEF47E0EF2282CC646D239E9B5537B13877D007927C59B507789E435A48377C6C8C93B01C1DC70616E161F5F3AD2F6738D3DB4608334BA839BCC1D446FB0A4384B896D8C2B6A635D492798F2AD1764AF1378ADD580AD0B222480D03EBBD57C159E5A1AD9D0D19CA2EE2C8F11ED96282E6B7690AAC97D09CA24004F8A92F16FED23136CC0EE44A83F093BFF00AAB5FDA3E1A6D25E5B4BE3C43E5B6390CF947CBE334AD30581E1D92D35B188C532C9900B11EFA2AE9A54F2F4FD2F4D91E378F54970BD7E3F04764659A4F539D25C8B38176B2FDDB46EDC2BAFC2AAB04EB1D799AF31DDA7BE847C104C4821A08D581E8DAED4F70F63098D945B5F67C42F89600041074611A309DC57CFB88DD62CEAC8A852E306824CBEC4EBB0D341E743063C19A72F2535D9FA76F9832649E383C8A769F14C2B05DADBF88BC6CDCC9DD1620E90600277E5B530C45DD82A652A352353ACEE4EF59AE17842312E48F0E4CFEA5963F12699F17E28AB6ED30B84662654EA1408DCEF5E864E9E0A5158D57C88CF24F2B4E6EC36C07B8C333A6FE4223CB9CE9533C51006B648236D89F3D3A520B98B2C65546527302BA03D564D5389604C1FD993A903461FEC74ACBA5D5C91711D916D154AFC5B9524E92741AFD6AAFEF69569004403AC18914A516E5C104B49120CC9DFCFD2A2986CAEB2AF33E256D9A29BC086FA9DB325EA366E360A35B5F857511BB1F5FA52FBF8BCB2CE58B0D003A013D4D1B785A0A1913F687A09E7BF4AA713853964281313E54B0F0D7616D1770DB776EA296B99412749D403B913BD7BDD966656F180A402043791A1F12D9597C5A1024B68046FEFB50F86C61CECC0EA360275F7F4A3A5BDD189DBBC45B8604321CD13BFE534606EF510910BB68751EC686B58C0A58EF22006E5E7545CC690172EAC77DF6F2ACE2DF08234650A02212483A93C88F2E7545CBE589CC43041AE51F29A1F0F8BCA3E113D4EA76DA833C45EDBB14222006D06A35D0D18E2936CD411715492448F2AEA15F10589399B5F21F98AEAAF86C34138B3000CA148EBA6E4C4F59FCAABC3E36E29943A8E63979D2FBAD0413AED3D0F2FD6AC5C4B3481CFA690390DF698A7F0F6DCDA47DFDF97000A7C61750D11EA3E756371A76F15C5195B40363B6FA521B4C25803A919A2093E636D34E7555E796D9889DCF4E9E5AD4BD9A17C00D0DFE30B9C5CD4EC2189811B7CA2A7FDFF00074D0492454BB258E271B650DBB7959D50A150CB0C44E8740D006B5B7E11692ED86B8F6EC697EF87B62C296BA96C464B63486000323CE9E1D1C66B7EC3421A8C5E071B73235E5426DA119D87DD9DA46F1CA6BCC571252D9A2091B4C0F23EA0D68385767EC9C2772C6D2623140DDB419A2E0820DA51A6CC034EBCE90F63B0E1EF5C4BC80D828DDFB369DD28FBE1A3C2C1B481BEB425D1C149342E96A804E220125A4FF0F91A33098AD233A89E47DA2B476F8728C73DC64B76F0B85B61AD96205BB80822D9668F1677924EBF0C54EDE030F66F62EEB22DDC35CB0B750AEA02BDCCAD90F553311E54CFA2B0E8667B0B8C4CA50A02C26019F113CC7B57B89C7312CE9E0DE2040D3691CF6E75A93C16CDBB392E952A30571BBE550C48EFA56E0EA7211CFCAB31DAE44B7F64EE5BC070CA7315CA5E5986661D6A72E8B4AD56338E9DD9EE154196375586F0624CF91A71D9CE23DEB640750330D22208E66B0ED7DD8293C891A7EBE94FBB0B7C8C46574CB99188249DA57950C1852C89CBD4471D8FA8F112CCF85BADA0CF963D6DB807D731AF9DF1717178ADE2CA48D1B346C99217D0669ADA328B96FB9672AB9B4206A0886533CA185058F166F45BC77F87C42081701CAAE3AAB6C41FDD3B1AE6FC41E9CBE3C55A71D2EB94FD68EA8259F0BC774EC45C3AE96C6E1B27EF9D79E5CAD9BDA9176A4FF8EC4E53137634EB9541FACD6B30F89E1FC395DEDDE17EFB68BE20CDE434D157AD24ECEF057BB376E1124B3EBBB3124CFA4D72E09A52792A9254AF6BDEDEDF0252C0F1E1582EE4DDEDD8863100B25F20D004D39893590E27832DE103C279F3ADB768ED9B78613A7886DCB73594C47110CD3D00004577F4EE6A29AF881271E4152C9B61510B646DE769F3E42B904BE6B9074CA493B88FC7CE99E02F64BEAEA41F10F880224900C83A6C4D7D1F0F695F138C5FD8DBC97ACDBB7365181190B1B604012D2403E95DD8A3E26F7B995C9D1F38E14B74DB716175B492791CB325A0EA63CB6152C4621542B41676993D2B65C1F87E1077ED88096462AEBDBB297747440489511A3672072D0566F82D9BCB8E165ADABC314BAAC3C39367627EE8CBE20DE94993A7DD315C6A85CB8D7DC110A0475DF69DF9D2EBBC418DCD882A64F9CF9D6FB11C1ECBE270EB6C20E1E886EF7C35CEAA66E1B8D1339A160F23475AC0D838D18AB4B6AED87C3DD2CA826D8B88A091A8D2441DBAD347A6499B43B3E6372E29D0B318D483D7CAAA5C590C0F3991276FEBA57D538570AC304C332056B575EFBA9CA0B05EE09CADA7C48411EAB590ED661B0EB82C19C392CACD7A5DD02B9865DE3A72A7F069721D34665F15220AC8DA45526F9F0CB12574D6A8B973C31CE7FA15E3E216028E675F58A0A1B1A83572CCB189D4C73FF6AAAD282483A44C9F4D40FCA87B249F12EEA663F4F4AF2C31631AEF24F99FCC9A651A0972E3634815D553A3A9CA634F2AEA3B0BA911C4A92C3A089CBB475F33565D6F14832A448234D35FAE95E3DB02D2C31CED3981F8544C002ABC6E19ADA8DE40034323593F853527B150FB97612DF77F1EA598687580079E827DEA5C27139AE4466DC1007F09F16BCE696A390B074CBFA55D83C7656195741C86E691C3668568D570BE198ABD6D1EDAAE56765CF30572282C58F25008D6BCC3F0CC433D8446F15ECCF6887E85831F23E13EB46702ED3DBB786FB0DDB770E7B8E6E851A80CA994AEBAB065D41D08A238476D859386B60B1B7655D6F7816492CE4652751A113AF5ACB1C5226E1121C27B3AF76D0B972E9B77184E1C35C552FD23319898888DE84FEE5BE969EF3A37779CDA713A87FE21FBB988D76ABC63F0988B561F13DF2BDA45B445A0A45C54F87720A13EF57B76F11B2CA1F1621CDD4FBAD6D9557283B9601419D3500D0F0E2FB99422C12DF673124DDB771D116D32A335CB996D868CC1413B983B01CE86C7E06F5894B8E34CA4057CCACA5A641063293AD3AC4F6B7097EEDCEF15C20BC6F5A3DDABC66B6A8CB72D9304787420E948FB4DDA2B372EDB6C35A16D2DA8139157330339881E1E9A5696355B304A11AD986F13ECDE26CAB92E195043ADBB998A2B41019770BA8E51AD1BFF0085D8DA92DFE215732D92E85956240CB39A6358DFCAAEE39DAEC3E7BB7ED0BA6EDFB62D8EF1555116167E132E4C73EB5E58E2984375B88A8BA6E8707BA250277ACB00E6CD9CDB9D76F2ACE116C2E11BD98BF0D845B812009BA480372BA09603682245697B0385CD8A0E7C4B0CA491FC3001FF00A7E558BC263D59D94125F914E7E2048F201736D5AAEC4718B678825B546EEE72A4195572A24CF3D038F2AE4C5092CCBD2C7C7EF235DDAC6EEEE8CAD9011A9027930D7D48026B1589C4ADD90D7DEE2AE6079E5D4E550B07303CCF2815F43E3AA4625349050C8FF537EB5F36B37459C7DD51F0969A8F598DC724E4B8BE3EDFC873750B037E54CAF0F854B6D084E5F11242EBB684F87C3CFD60513D9FC58173286F096D0CCEF227CA56091C8935A8E23891954A7C57185B1E64FE5A540F666D5B221A5C4932DCE2663D6BCFCFD4E35149BBBE0A47566FEDC5214F6893BCB257E339A74DE02B19FA5656DE019AC35EB76C1B76A15DE751980831BC4C7A569FB47862328529E20ABE36215490FE2D353FEF4A383717385C3BDA233B9C42A94DD6E20475759E841FC2BD4E9D2718EA7DBF92596573DC17FB86FB3945B70722DC62CC0280C3462D2002790DEA9C5704C4AB32B2C6543789CE08655025C3030D1F315AAE23C570D79DAD10EB64F74D6D990B09B6B94A5C50412A41E477D685BFC47088CB692DF768F62E5A7BCA8C35B91056DB3139446BAC99AEB51C6B8908D47D4CAE2F82623BAEF5C164C8B7643C908E480D13313BF4A6FC33B217CADE6BCE6DB0007C6BBB2660AC59C72891A9A6785E26898AC3B292D62C58187BA4AFC6B0731C9A9CB9A34DC555C2F8AAFD9EFAE21D45CBD7CDC0D76CF7AADE0CA6048832441E428C5E3F53251BA621B7D9FC495B2814CE2016B3E319584063CE0181CE82E15C1EFDE396D34B490C80C65006ACC4C285E5335B7E0FDA9B28D85EF433594B4801CA652F28704AF50558A9F51D290703C45B097ED5C2CB6F10A067412CA4392A4AEE50EC7DAB3D2AA9F20DBB317627B338CB6D1F74235D055C15CAA067208313D46F5D86E1073E14DC136AF1955524E601F29004C824E9CA9FF09BD6308EC6DDCB978F757525ADC5BCED195421D48D35274A32DF682D0387BD71077B86B4E05B44CA86E33F876D0000CCF5F3A29C3BB36CF97424E21D96EFB197EC5BB61596084196DC01B882C4191CC13B4D2F5ECE2943673A2DD5669D644291CC687C27974AD48E3569B1187C5BDB6B66D06B57809611908B6C18EAC483079ED48FECED6EDDC0D97455B627EEC932C7A68A753E551CF3D2AA0FFDDBF934E55C0161785D926D2985FDA35BB8C1A431001565D345E551C5E06C071770E2154A0757D466998079CC4D32E2D8451850F985B7B4148402732B7770C4F989352B576CDA4EF004C45BB9169846B98298CA09D09661AF45A878927BABF4A11311E392D35C666CC0932406511E5045756B311855462B73096CB8DE5893A8913A6F045754BDA52DBF712E5E87CCF0B88017294CE58E9A91AC687CEA39892D33E73E55A0BDC3CDB2A4B031932F863D7E479D3FC170DB252E2B89463A11F1C3493E5A31247CABBA7D5423B9D0F2247CE1AE4913D7E756DAB8C8F997420C89FA56F703C045DC1F776CAB5C2E729CBE2412241F750411E754F69B86D9BC30E96505BB9245CB87E13AC41E524826B2EB31B969F987C58B7465931AEACD7944130A0CC99813AFD680468924933BF4DEBE87C47B376570ED86CEACE886E87D019D72A4F3D29160785EB87B214336F7246F9B65FA8AD8FAAC728B6BFD46538888E3064D19878811F9FA55176F91A0FE6F7EB5A3ED6709B4B76DDBB36CDBB64C778FA963A491C8289114C1FB1C0592C486CCE2D211B939A07A1331ED4DED18A2949F70EA462DEEC001772649279C5197B1971F0C04016D1A3CCB44C9F6AD6F14EC7DBB6D6D01CCB955DE7426601023A11F5AB388F65EDDB41DD5B6775005C13201823340EB537D661D80F2453A30B76E92F0DAC7EE9D2ACEF4E89A804EA46E413FA56B2D701B76AFDEB2C332E5F0B6D07BA2C07FD522A27B36183150CB91D4063A861D3C9B9FA533EA7181CE25381E22F8756361067B80A2699982C1DA39C6B447F6797B263EC344842736BA09054B6BCF58A1EC58BEAF69D0006C92E197620124FAE920D59C2ED358C5A051317533B0D3437048F48FC28C651D5E5E4C9D707DBAFE32DDDC42E59316DA748E6237F7AF9876D30CC8D6F10042B92BEE0FE7F956E311890714C2D080B682CFF31A4BDB5BA1C0C20D4B29BB6CF983007FABC54B97CDADBED2FD92239DAC977F908B01C5F3DCC22B185472DEF1E115A3E2A97090EB251A64F52447E3590EC6E04DC724ACE450C011CF6AD4715C604B6B94B4B18443C893131E5AEBE55F3DD5412CCA30EDFBD94E8726884A325F21371CC3000677624B0CAAA35D013BEDA004ED4BAE5916EE088B882E92189F8FF8B7DE1B96947F6CD9ED1C2647EED8B39CC04EBE05008E864CFBD2AE2B82C8E984BAD999543A15F0A9D0E600EFB8DEBD68E37184137CAFE4D916F436C7DEB9670D91586D9C9804F880050748D0CF4A8F0DC30C53DF668089DD2DA63FBC0491A9D8EE6B31C24DF165D8BC20CD20EB2600581CCE86A2B8A372DADB40C5D9A51576E9ACEE4F5ADECF249A4F7F51298E2FD954C4622C26706335B20C913AE53AEC730F3D2AFBF95185AEF32B25B94900CAE4524AF4B8DE2107C8EF4B6E615AC2ADE285EF3052730990EBF0C751D7CAA3C270A46390DE1DF389729B6A26030E500668A2A2B9BE17DDA338EF6538C16C7796EDBDC652AB7126254CC92D0222011EF4D1B8A261D335A2AE4FEC9D5960980D036800B3CC8D600A4DC5F12EB7311E100DD9316C48CBB8F6106A9E1B86BAF6C98919CB682468B3AF98FC2AAE09C2E5C6DF50E95566C38BF07BC96ADA130E8626D9993933C1EA4409D2B3FC1B1CEC816E9509703B666124153BC8D77FCAA7C7712CF6ADB2DD6C906E0E449F85A48E749ED61DEEE8340A85D8131A0224FA99DA930E3F23D5EBF6328261D8CED05C64EED4780FEF6FB8833D63614DB8C61D94155BA1AEDD46BD8A33A2A8D97E4623AD6641B8C1B310B954C08F880D40F581A55F8DE10E9865C416FF00314B46B2006020F5D587B557C38A692DBF76150483F8FE26D5BC158B08CCCE7F69758EDB689A72CD1F2A107146EE90DC0A595F3010274F84E8348DA284C270EBB702B880B73440DCF52341E513448ECC5D17D6CBF8B62EC0CC483A0237037F4A64B1C5696FD58ED2ADC796B8B35F1DE96505F523373AEACC5CC361ED936D9DA5095310068634F2AEA1EC985EF4158A2F7B35788BF9ADDBB642AA3B0027EEB2991AF52A6285E257FBB7299A16D8324733BA8FD69AF6810DD8B6818C46555585533A111BCE9AFAD6678BDFBA5D8DF560C0E560CB00888E95CB8529A4C8C52668B8196B784CE2435E2F11B800EF3E7F855FC56C32E1AD82156D295733199A6016EB0674F4AB7EDAA30B874452DDE785803AE49E47916247AE5A0BB538655B68E09232C6F10412351D46D150DDE4B7DDB072C2F86F104379AE65199810AA7E1FE1D360749D77A5298A65B7DFEE16E6FCF9126A1C038E0B6AE988B65AD5C101B2C3291B1568E4751554017D59D435A0433823C05994686AFE1252763B5A4D2F0EBDF6ACD72FC65CAC6D5B8DB504EC359EBCAADC0945B2C4898BA8EAA0FC2731113D4035670755B6F6D6D92E067555300A8D0C393D342237D6A8C470F76EED4103BD20B4682258CFCC81ED5C727E6AE17624EDB34D678587677D7BC232EBA82B9440F49D7D6B3CB83CAED9EEB5BB971C22226E7291A99D9679D33C55F6C38BE0130BFE5CF3CC8001ECC66B1FC5F12C1CB31D7228049DB291AFA93143A7C527DCAC62B8EE33E257C3624F7A15240048D54B2F99D79C1F4A6563088A9FB42C55D99ED91F080A07C51A4B1D20F5ACD8C2DCBEAAC61431CA8CC777DC881B024C49F2AB38A630AE16D618C860EDDE21DC41981E5AD5A58AE9585C532EC00EF30B76DECC85DC7CD815FAD68ADD9477B2BDDA10F0338D0E65324E9A820961EF48B1D7322DCB96845A5B9908F26591F97CA98F62B1616F2DAD198DB375411D0C983B0DE9B1E373C8ABD44517743AC3E3117157D582E610832F30263DE6BE7FDADE246EE2C382CB9532883B4124479CCD1656E7DA4BDCCCA19D8C8D480093CFCE97E2785DDCD0ACA50151AEF1E23EDBFD69AFFACE5296DB94A6D38F6FCC61D9CE2E2C5AC45C632D9A02F3272CE83A6A4D28E137EE5FC693799C9CE8C6674558623C869157BD862C087512C09DA7E00BF808A17845F7B77589692D64A823AB3401ED35A308A539C79688A4E38F56E6FF008B636DDCC3A31B4321B85434EAA44946F2048F91AC8F6BF0D9D90B9865B6594EE0899653E9AC7956E78A70ECDC3EFDA5FBA17DBE11A7D6B03C36D3632C7705A2F5A5653E711A7CA7E55B0CB54219AF65B7D38B3A324649A93F43B0183571642E6CA17BC2B3F78E51CFCA9A5FECFDBC2DDB5894245AB4333127C419A5B51E9A7AD20E1F8D0B69B3785D5B289D2146631F87CABCC00EF5EEDDCCC2DA0CF6C1FBECBF8AA99AACA13D4FCD51FD6C924ED9B3C4F130EF76E5C5EEC2E4B68ADB869060C73F4AAF19608BD89C5C900C285F4801C69B4E714BF8871021FBCB90C1AEF79691753735891E5E750E1DC71F1097D5A149532A768572601EBAD72BC7249B4B6FD80ADB7E82EE0DC3FBCB989BBDE9B70324289660F2088FA4F9D3BB366CE12CBDB40E6E20374812485261998ECA48100748D293F02E22963122E3980DAB74300E5FAD33E378966EF0DB0A16E24661F0DD312FAF323F2AA64D529697EEEC16F61671FC2A15B6966DB20619F2BF2CFAFB6BF8D79C4D45AC1D8423F6B7659FAC6AA17DA36AEE2F8F188B76D329520AE62753F08FFE40E943F1EBDA5A86CCF6CAACF51008F7931558DDA8FC5842F8E7075B7829CB2C3BA77B927EFC82B1B08115A7E17C391F0B65AE8CE1AD85B768EDAFC4EDE44C1F90ACF5CC79B984C8BA2DCB815949960514179E83341A71D96C6F7A5EC403FB280DB810607A09D7FE2A199CFC3DF94C374B731BC771A5B11FB2508B665115440D3768F3D4D3DB1C54A5B40A2732657D6082042B7A81A7A1ACDA619ED3DC2EB98212AE7A66959F9ED456371502DAA19490CDCA342089DF5135D33C6A4A315C024AD2238E5B2F7198AC126488AEA578BC477AECE14286D80D857B5651925566A63AFEF4F1B679CF3E12750000415036D668AC35C5316D943A5D24113050EC08F2F2A5F63825DC5106C239E658E8B3CF52634A99C29B573BA6B8A2E830181F08D09FC27E751718F09EE071DB6218E7B96D00B44C2C2061CB5247BFE94C3B3383172D5C4B924642C35E6BBFF5E7405AC6101EDEE1E0FA10674F6247BD34E1201580CA14983AEABAEA0FAEF4B36D42BF33708BFB317AF5AB17AEA1CF696E1B6B6DC0209001120EC083122B49846C2637077461D52C5D604B2368B9E227D341A8A8700C061EF59BD8599CAE5B43075D41FCAB07C5ED359C464506D80C644EDA8E7D0EF508BF16728AD9F3B8E9F97D5319F160F86005CD0B2946CBB82A7C2C3D63EB44F6371172E3E624E45580018CC46D3CE35D62B3FDA0C75CBC9601F146650799D5601EA472A7DD9EB0F64DAB60ACB2B5C107524AFC27CE46D56942B16FCEE4F64A8338D6359EE04BBADC17396D11257DA0528C7E0DAEB77AE22D926DA72D40993EF34D3885F04ADC5426E10C4002492604C0E817F0A071D6F146D0CD69D514803C074D77DBACFCE8E34D550EACF7ECED672BEC18C01FCBAE7F59047B508B7DB1172C6A58852093BFC44093E42B5387E1D6EDDCBA97416B174855B8DBA336B97CB59123CA823C3CDABD77ECA8A7B819406D65890029EA6649A5D6ADFAFA98138B719CF66EA9021B27B1468FA8A6DD83B42CDBFB60399CABDB00FDD13323DD4566B8F70ABA88ECC74072B8FDD3A99F4241D69FF02E216F0A962D5DF85ED12F1AC166689F28356E9A50C728CB957BFD838E552DC3F8932BA86E6C548F224889D7AD2CBDC3883AC6FF00D73A73770366FDA75B37966019DB2C1044F4AA2F602544776E4896657503D449DABC5526E4F427CBDA8E2CF0C89BD2BB98DE35875100912E79CE83E7CF4A1385D85EF59D23BBB794E8080750637F2AD4716E00F742F7776DDADE41604F21C8D2EC17040B6CD8EFEC869327303AFCFA57A18F32F0AAF7F93FBF007AFC3AADCFA6606D97EFD1767B520F29868FCABE77C35FBA2D8802D8B968CBE56F8C6CDE1EBBD6BFB2FC7F0B6AC84FB4A5EBAAA2D9CB3A9D63DBA9AF966371AB6C47C2C58E7239EA444F48E5CE4D6E9717F4163DEEDFD8F533EF18AEF439E25C0BBFC63A592B95D45C0C4E811A098F3D6288E25C43BAC1DCB0C16418B640810623283A8040ACEF06C69B6E4E7392748FDD9D40FC7DE96F10E297B1374BDC69893E50047E15D7E04A52516FCABF521A5B66BBB2162DB5DB46E98B994CE7602160E5CB3A65D469BC8AAB13C12EE1CBE6560A1CE563F784E9B75ACE61B1CD799436C8B941EA3A56C30574DEB4D6599DC052E8336C5479F21D2A7994A0EDBE7B7F0076B911332E74CCA597E12A3733A4797AD68AD9FB24640B770AC40BB69B5EE9D86E0F4834BECB20CB754CA369E6AC3753F91E75E63FB596E5ACA5B0C8C082018D7FDBF3A47ADBD3157EA0DDF04388DB4EF2E3E1896B720329F8AD9D371CD6762292DDB24DDB999BC4B0C04E862351FA5577F883B5F6F004600242088004B13D6799355E37100092A737DC70623A822359AEB8E37175F028A27D1BB33C2D58E2714C64B2158FE26F8881E902BE7B8CE2776CE6084A1624165304C6FF005D6B4FD8CED245BBD6492D29994F30762A7F1155769387D9386C2E48CD999DCF339882C0FA47D2B971B70CCE3916DB5036DAC138D5EB9702ABDC5B76D1119847C6CC352DFBC7D6945EC2B056214943E20DF4D7A7BD5D8DBAB76ECDC9CABA69F423AD34C3E3585D488CA615CB7C306267E67E42BA2DC52A05D0830DC4D91428881FC23AD7559C6385E4BD71535507C2474DEBDAB29C1AB0F886E317C64E1EF5CB7A2DAB833A0E8DA0650069AE875DAB138F07B96B864937201E7A519C77890BB692D0209B6EC738FBF24430E9A72F2A1ED5E636ADD8892ACCCDE608027F1AE6C38746FDF6BF8D770535B96DBB4FDDFDA575B68CAA67A90640D36D3EA286B4FE2EF396E47A72FA51EC8C30A2CAABB35C2B935F0AF8B723692349AB388F026B2C0BB1642219D473101B4E81B4A7D51EE6B46A7FB29657EF4932F2353E7AFE24D09FDA5E1D9F196EDA68CE07E627D607D281ECB9B984175ACB5BBD303C332BAEE54C1DBD69671CE3B72EE23BE7D58185CBA4413B7A4D72C70DF52E686D5E5D279C4B35ABB66350A6509DFC27491D46DE94562AE96970C4670440F3335DDA8CAE6CE21183F78B0C46D986860729DE3ACD2CBD8A54EEC13A0F11F9ED5649C92F516AC7CB6CE42E1886B2015E73E5FA9E54D7B35DAB662E3BD32760FB4E9237A4BD97C36231B7C776322A9F196D5751044732472A77DAFE1383C32A846FDBAA8F22DA8126398A94E93D12E7E1D8D18C926D87F18E2F6F10972D993035F23C98526ECC7148003B497C4AE63D46913F2A476AF626C9D6D37307C2675D483F39AB31D6CA3ABA29542431D35067A1A458528B876620D3B71892B72E2A191709047A11F5D0D644662E2DC9CEDCE768D453BC5E638CB9074CBDE03BC1651F99A63C6EC3613ECEF7ADA5F561E360B959581D832C7C8F4AB626B1250EEC78D999C7F16BD6D6DDEB4E549192E01B665DC30D88220FB9A870CC777AACAC4231E5F7753A01D072AD860F8461AC58B98D24DC500B5A471F788804F52274AC961F06D6ED5BC4BFFE63955E842C4CFCC47A1ABC278E716A2BBD7D465BC4B2F5B7B2C54E49CB0D3AC099D3A1E54BEE235A39DD44C83EF3CFCA298D8B6CCFE31E19C99B91D246BD60D558EC6774191A1EF3BE62BC95760A7AB1E836A683775DC08078A5816B14E134524E583CA769DE29A2606F8520217B4DE2396184CFDE893A51DC5786A9B77B388BAAB6DD07482C1D7E5F850CD86FF0E2F5972B72D6970030402CB90E9BFDEF9507954927F4FE0D7689E0B056EE5AD14032645BD0A8D06620E87D34A55C470412D964D16E5C281899014053BF523534F2D622FADBEF2E052AEA53BF5D4198395E398237DFD6B23C545C50B6DC9CA09813A6BAC8F5D3E5470A96A7B8637639E19894CAB6D6CE7E6BE220B7998E7E54EED632D2875747B532875CEAA48E646A3EB597E1189BB666F2055800066DF7D2053DED8F0D4EE5719873E0BBA9599CADF787CE972C22E693E1FEA6947716E1714D696E5A71A6E8797941D88A5582B05D881F11D475DF41F333ED5561312E465925409239014D2E6081B4F746855C2C0F407F3357A506FE2371B1560B1289789B92CA4C310753D75A2F18A5D1ED5B32AB73320CB2CC1800BAF488A75D98E1001BA8CAAFDF5A60AA773A48CA76066292E0B1D7787DF25975CB041DC741EA0D4B5A949E9E5013DE853C1F186D5C3A6E329ABAC639C394627296E7CA79D5DC47879B57D7310E6E2ADC197639C03F313F8D36ECCF045BAEED784007C33CE3FA14F925049CE5E8693EE365ECE3DE4B296EDCE5073BC42EB0449E741F176FB32AE11DD2EAAB66CC010527420EBAF51D3DEB7F6F882AA19205BB4999BDB41F335F16E27882F75E49672493EFAD7074729E66F570858AD4695CEA403980D01EA391F95752EC0F14CB6D4159206F5D5D0F06E6D028E1BADCF634D71062E291A78797BD75755F2723BE0D1F0F626E61B5FBBFFDE9DC4A80751DDDED0EDBAD757579993DE89091F3FB5708CCC090430820EA3D0D36ED35B1DE9D06B04E9CC8593EA6BABABB9FBC877C9E6207F86B7FCE3FECACE62773E9FF00C857575362E4689F6EFECF2D8181C3C00254930373275F5A482D86E2AD9806FD9F3135D5D5E24BFBD93E4FF60CFDC5F51E6298E63E9593ED67C0C7C85757547A37E6443B09B067F6A3FF00E69FF7AD6B7B627F677C74BD663FE89AEAEAF472FF007225A026ED09FF00F1A07293FF0072D2EEDC88C15A51A0179E00D87846C3957B5D54E9395FE6FF0040438612DFFEAF0FFCE4FF00EE51F869594ECD8CDC4EDE6F17ED79EBCEBABABA3A6F7727D4D1E59AEE2E7FC5DCF43FF73561F1AE43AC13A813E75D5D49D1F1F442479343C14C2E2147C3DD4E5E53E2D6369ACB638F82D7BFE35D5D5D183DF97FBD8AC791D7195030A9006E2BCC031FB044E9DEEDCB6AEAEAD3F717F906428C08D2FF00B7E74D7831D6F0E5DD031E7A6B5D5D54CDC334B93EA36500C0E0C8027C3AFF00AABE7BFDA99FF17FE85AEAEAF37A7FFCBFA315FBE25B7708FB3B024302B04182351B1AD4ADC24DC2499CE79F99AEAEABF55C2FAFEA0CBC06E28FF83BC3AB203E7A8AF9BE14FED9ABABA9FA1F766362EE5D70EA7D6BABABABA827FFD9, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (4, N'Trà đá', N'Trà đá', 1, CAST(9000 AS Decimal(18, 0)), 10, 1, 4, 0, 0, 0xFFD8FFE000104A46494600010100000100010000FFDB008400090606121010121412121415141414141414141414121014100F1410151414141414171C261E1719241914141F2F202427292C2C2C151E3135302A35262B2C2901090A0A0E0C0E1A0F0F1A2C201C1C29292C2C29292929292C292C29292C29292C292C292C292929292929292929292C2C292929292C2929292929292C2C2C292CFFC000110800CB00F803012200021101031101FFC4001C0000020203010100000000000000000000040502030001060708FFC400451000010302020607020B0605050000000001000203041121310512415161810607137191A1B12232141533437292B2C1D1E1F023526282A2F124427383C2446393D2E2FFC4001A010002030101000000000000000000000002030104050006FFC4002C1100020201040200050402030000000000000102031104122131134105142251612332427152B1069192FFDA000C03010002110311003F006C24B2D8A8553954E256F6133C9B9B4182A829B67052EC55AC0546D472B184C98A0DF05D18C6A998D727825C37F62D148B669D1A6C156E7045B853AE2809D12DB5AAD7B957AA548A6B1D0544F036A245681B52E14E4A90A27142D2636339AE9071D2237A81D25C50BF1695A768E72851804ECB7EC318ABAFB51B14C4A451C45A99D3CC97382F43EAB1BEC6402D398AB6D40586A02461973288BA35539AAC74C1566444B22E582B2141CD5617A8B9C8D0A78047920AB6199426285ED6C537192BE76B1E44E0A6E684AE1ABE28B655049716996E138B45BD9A9322516CC15D1B82163145330D3DD52EA247B085220205368275262A34565A4CDC162356303C111498156EA74539CAA7CA131362DC220FF0759D9AD495210CFAA4C498894A310CBAADF2213B75A74851288B772F46E59553AEB1E541A9982ACA7C84C4D474300DC808DF646C5529724FD162A92F61D1403722594E1002B6CA43482AEE322F46C8218F6010D340AAF8C38AC151742A2D06E70609344A9170998602B7F0709BBCAEEACBCA17890A98BA33B10B61A143912AB7EC1044558D80A2DA02917042E43141013A2553C22A578404D28471CB1563512A95C82794411758DA42E4F585D946599740BAEAE8A4E28B6E882B5F1610A1CA24C6BB11B8A6EF454551C508612DCD6D8EC52E586588C9C4710CC8A68297D2A67139559F068572C9823256D5ED705B4AC8FDA8E7A485C107335CBACA9A70964D0856216E4A9651F93997B5DB9566376E5D03A946E5B6D104F56A29BD2B7ECE7C42E52EC4A7EEA30879294044AEC80F4B812F6456DB114C8C0AC652845E416B4EF22E6B0A9B5BC1356D08586846E41E44C62A1A15951BA366A4B215D1A3524C5CE2E2403C857C752862146E8B6A62958E23315C16FE1C9438A8EBAEF1209EAE437358B46AD2E8DC4A2D94E4A1704838DD39177C2D67C294D943757B34525B7043E2AD97404E96EA87A7ADD18CDA54BE2B67EAE855B144BD3592EC451B094D686949D97EE04A2A3D1ECB81717EF1E89CD3B6387DD04939B8D89E5B956D4EAE305F92DE9743293E7A17C71293E991953083ED333CC8DFF9A17B655EBB7C8B28B93ABC6F0C5D514C12C920B1C13E98DD2D9E3572B651BA0BD11A67D91A262951B8564351BD31C44A9E064272B6A80EBED5897B466F65D51A4C1C8A1C54DD2812857C75011F892E8EF98DCF919EBAB1AF4032757B64250B886AC2F92542CAF5375D50E0A628894B253AD8ABD8F551629C71A37814B219148AE36433225636E1218F59C7263E2BA0A7A43B13560BAB3B25CACDA73A77A39A7C0772A1D0F05D2CD4B7421A51B9588DC5296979103A13B94A3A327627CDA11B9094F25E4711946ED5682302F06CE79DF63B3628B354A11C874FC3BC92C06536826B181D23836F9348BBC8FA1F8A2E3801C1919237BC81FD2D5A822271B627326C49E651C059B8EB6EC0B481C6D9ACF7A9DDDB35A3A350E9141A73BDA3E8B413E38959F0570D9277836B8E3AB64C689B181604DCE275B337DBADFD91720B61B107998F5A75D891C00C0F0C1D21FBCD9608D87FC8D3DCE07D0AB6A69DAF3867B10EFD1CCB8FFE71033D8A5DB859607872F082DB0B5B6B023F99C45BB89B792DB8283E400002C38603C95065D81616A752A5234AAAB6AE02A17DB0E3F9A12ADAF63DC75759998D4B970BECD53EF7F29BE1928BAA2CE03F58A630CEDD66B49C5CDB8B8203B3C03B2D6E17BDB15DA0BBF5651EB823515A705942A8E76C8DD663839BBC2A248D555F088AB99D9E02617959BDD721B25B61C313B75533F832F4909F19312CAB9C214BE9CEC559A329E0A6536532679B027E5F2226C0F0B17442942D28F3A0BE54E1638C947D3515D4218F14E68E316566DB3051A69CF652CA15688884786AD3A1557C9F72FF00878E00DACBABE3A41B9150D222DB08086567D8657467B17B6801D8AE668B6A340016C3825791FA2C2A60BB17C9A3C8C90B24046C4E9E50D231729BF60CEA5E85ACC110D7ADBE358D6A3E1809638212154946766A8961214A6809C5F653DA2A7E2D734F691B75DAF75E48C5B583B22F889C2F8025A73B5C6E5610530D17360E61C2F88E07828B96601E9A4F7E0269A818E00B1D7F220EE20E20F056494B61F9A02AA67349ED19ACDD8F6DC3BEB3711CD542A6E3F6750E1C256B6603B9D8159AE714CD6516CB2AA511B1C5D8346FC2E97688E9842E1AB23AD6F74D9C46AEC0EB0C0F7A2AA207B9C35CB1C00CC021AE3FBD637C7F0528A86C70318DA7D923CC0545DB39D9983E87C6118C7EA09F8EE2D84907224102DDE6DB50B3545C92DB63B01BE57D9BFF000574DA3838DC3A320641C43ADBC6B10829E96C7D90393F0FC52F531D4BEB944D6ABF6571C22F722E4E64EC2AED520171B0032BED3C16E3A47D9A5DAB8EC2E2EB73B0BDD16EA30F235DD87EEB4580F555A34CE5DE1341394509E27991D80DA3139607F5922F4A68BED2368123EE083AAD0358B865B6CCC71D636F745AE9B3B46B23C40B9B7127C4A1446FF78DF5464D3669238019F7ABFA4D12A399BCB622EB9CBF6A2349A3B53F692383E577F9B76006673CB3B22DA4216A6B4B80E596CE0AB8E62B692CA32E734A58188B2B591A0A39931810C960657866C46B48901625E4B1B4F3B68C532A37AD1A70B6D65969CE4A460420E01ED7A98910626E2A2E9D236E4B5E4C0D639ECAC7558DE903A73BD5324C4AEF0E4EF99C0F26D20D1B5087488BE6933DEA3DA26AA305796A59D1B2B2FB55C2A42E6D95C42B3E323C50BA586B5287724D75064F8A502B0956C73AEF160957658F5925D63CA5B1D52B4D55D2B631EAD4D13900518459C2CAA3305914B67039E392EB2398340C2494D308AF9DF6FD6294C0D7075C604E07B974D21691EE7241F68D69C63B03B4E2BC16B6AB2AB73BBFD9EA6A9A71C602346C376824346E162ECBE9260DA661CDA3C357D0A044966DDB6B6795C214699C6C5A01EF216CD5AAAAA8C558F9FBFDCAEEB949BC21F86D8616F4487486902093D9C65C32B9D669EFB05B9AAE47025A41162E22F6200F53B572D53A61C49D98F720D56BF6A5E35D8CA74FBBB1A49524E32B8E2700D22DC063B132A698E1700EECF0F05CAD3C85D6BE77B8B94FE85AEC4DBEE0150A75764ACE47DB4C62864FAA36F1B01F8E7B154E88B85EFC96CD57B36B03C76A8191C7219AD5AA7BE4B9C9427C20594580E656E3705755523AC0F04035B62BD2412713CFDADC67C8C1B823A9E74AD81111B104A236B9B1CB260B12A6C842C49D85AF30BC01B15325D4C3ACAA9A556D2E4CE6F8319112510296E1428A404D8A6D1B021949C43AEB524219A9ACA8704FAAE9AE0A4D2B2C53213DC26DAF632873550F6AB9EF43BDC9E932ACDA20B35940B96AE9982BEE2F6BD111BD08D6AB81B21686C64C284C5619D09DA283DE83604EDC060A85312A5ED56872975A215ACEBA9AA039A3B81574A1A46F5CC52CE48B0758A3636380F7C9F45E17E25A975592ADC727B2D245595C6792AAEAD31136171DF977245555EE2E1EF0EF4DAA2935B324F354494F858B41E2BCCAB7D336AB514BF26E29EE00209E276A9BB460936041989C07B26C8AA1D24E660E449B6F9674A3859898DD16588D8EB2C2C6E8AA7983C5CFE4A9ADD41B477AB294A2B7265772DCF0D1B1518600FA2BA17389FD6E4342EB804027F5C55F4B2B9CE02C182F6DE4E2B73E1A9B650D4AC21E98FD91DC97D4D0039230CA15324ABD2C1B4655AA32586011C5638A2DAD43492E2A4254D926CAD1C4782C9162A4B8958BB04EE1518CAA256B93DEC02AA4A509D1B0AF2A05342D76B5D7451498206284056EB04BB1EE63298EC4113BB0496A9F756E90ABB600A58F9EE99541F62AFB57446572A1CA4E7A8DD5C48CC93C95962931AAC0D56358BB20A8E4C6B56DC16C316EC832392C229EC4956368CED44C4110B9D8D744C6A4C5EE8ADB154E28E95E84732E8A3202514BA274CDBB4919B483FCBB536A494118A554D765EE3022CAE82A6CBC27FC8A3B2E535ECF5BF07FAE8DAFB43DF82B1C307055BF45B7F7906CAB69DBF75D5B25644C1EDBC0FA4E24F82C28CEAB3B8F26B6D9C7A232D0B06D4AF4AD3FB176DAE3CC29D5F48A1C9B7777036F340C95524990B0E292E189705982976CDE8BAA7BC816213D8F47ED7024F1492883E3C458F9782630749C0C1C30B6D1BC6F57295094BEA1776EFE03989960A51DB59BE495334E31D966765F6F34652C97249B646DCD7A3D1CA19518A322F8CB0DC82652819253757CB320DD262B7E08C4B65C976B29B0AA2395586446D031698646D58A88A476C04F22B129AFC8F5FD031D2237AADD5E96BC2A88569548A12BE433F878DEAB7D7714BACB45A99E3429DD265934B72AB5B6B5190535D1F1142D45C981766B4634E851E192C14010F950CF9762A8A128D8A9094C23A40AF6D3A54AD43A1A76BB159A42143E0C9BBA255EA20560C74A16884852ECDC8E73146CA7700EB0031157B29C6E44766B6C365CE7C12AB59E4ADD49769C3614A1F40ED8EEE5D443885CBBEBC35EE63B02D2463B45F0C5798F8F272AE32FC9E83E16B126A20D56C7B1BC42069E42EF7C63B2F8FE68FABAD6DB1290BF4A82F2E6F82F2B541C9747A78EE6BA3ACA1A16B85EF73E9C91E3421734EA9BF3D5701DDB57190697C6F7B1DE2E6E53AA2E923DB604870E771CD1469C3FA8AD642CF41A745BF11736E60F82C3A3AC3117EF4E6974D891ADB80EC32D61768E2ED87BD23D29A71A0D81E5BB9ED5615515CC5E4AC9CDF18073086BB0C3F04EF44C04876A8C755A3C7FB2E6A3D221C7F25D8745C5DB21FE203FA6FF00F25B5A04D493656D4ACC70CB3E2D71DA079AD0D0636BCF2013901496F796465FCBD7ED0BE1D0510C6C4F7928B8E8A36E4C1E0AC74A066A41039B7DB1AAB8AE91B006E58B02C5190B08E16A60B142B823AA5F8A15CD5B30E8F3135C8392A24AB1ED502CBA60866DAF4CA81F742C1A3C94D29286C956CA382C51093616C68B2848EB2B7B22362AA4A473B7054F72F6CD2719638441B500299AA0A2CD187691C95ADD18CDA5DCB05CECAD7B3A34DCFD03BAA42889D1CDA18C64DE64DD5CD8C0D83C12DDF15D218B493FE4C5ED6B8E40F82B63A376D08F6DD48140EF6FA4396962BB60A288EF0A43460DA4FA22815240ED97DC67821F62B653B4643C715C174DA8F527240C1C01E792F426AE6BA71464C61E36020F3C967EB96FA9B7E8D1D0B50B57E4F36121734E387DE97CA08253C8280EAE473545468975AF63E6B02364533D52DA29139445357381C0955CB4A4661460610E19AB2B6B2655A68710D63CE57079A2191921C493ECAA69E2C55DA62A3B38AC3338228A8AE8CE9C32F05FA0BDBD62711AC2DC00173EBE4BD0FA37AAC85E4902F2BB3205806B46DEE5C3747690B6360C8D85F8927F34AFA41475B256D4321866780FC35633AA6EC6E4F2357CD5DD3B6BEA33B51152938E4F57A8E91D347EF4F18FE607D12D9FAC4A2660242F3FC2DB8F15E714FD5C6929AD789B1EF3348D69F06DD3EA0EA725F9EAA60DE238DCE3F59D8792B9E49BE9157C75AEE435A9EB5221EE40E77173834780BA5753D6B4E47B10C6CE24B9DF784F693AA7A26FCA3E7978193B207FF1D8F9A7545D0CA186C594B15DB8073876AFFAEFBB8F8AEDB6BF64EEA5749B3CCE4E9E57CC6CC738DF26C4C71FB2162F658E30DC1A0347F080DF458BBC32FF00223CD0FF00139196949D9E8150345BCED03BCA621BFAC9581B82BDF373F4657C8D6FB17B3436F7F8057C3A2631BCA2C35581A81EA2C7EC6C749547D140A70320AD69B7F75211958388F14A7293EC7A8C5748D0182C0EE0AC2C1B945D1586380DE70F543808D5CAD8BA0E7D334D1FBF5110B6CD7693E452AAAEB0A863F9C73FE833EF360BBA2526FD1D1B58AC6C4B83AAEB72117ECE073B76B380FB2126ACEB6EA5C3F671B19CB5C8F143E4886AA9BF47AC358B66C332077903D5787D575835F2673B80E1668F201269B4CCB31B3A573C93EEEB6B1F0C4A876AF4835A77ED9EF951D20A58FDFA8885B607079F06DD26ACEB22863FF3B9DF446AFDAB2F29A4E8D57D47C9D2D4BB8963A36FD690B4109B537543A45F6D61047738EBCB72386AB1A7D5429CD92EA847B674759D7542DBF65038EE2E77DC07DE83D0BD65BEBEA990491B446FD6F75B88205C5EE4DC2E5B4D742452BFB33551CAF1F28D8E2706C5B86BB9D89E16435151F6123258DEE1246E0E6385859C380188CC1EF47B5B5F57281FA7D1ECD1747C47B1A5BFBCD06D6D9702F6F451ADA765B068B5B6588BA97457A630D535AD27B39B6C6481AC7698C9F7870CD74B3451E6E6B7BC803CD606A3E13558DCAA96DFBE474751641FD7C9E695FA35A49B04A24D15FC2BD12BB4331C7D921BFEE822DCDA52DABD0A71D4900C7FCD24797788EE55787C3EF8FF0028FF00E8D08FC422961E7FE8E6A0A071B7B36EECD10FE8D994346A8BEB0712F36B01C53A8298467F69AAE3C6775BEA850AAAE86369B9C36E20340E04E255DA34987FA962FE97256B357297EC8BFED96686A66472358DB3DFAC2EF1EE300D8DDE78AEDB5F05C5743EBDB512B844CB322B1748727975F558C6F22493C37AECB3FD596DC21182C47A332726DE646EF75B6B540290B9DE98092042DEB2167AF8A3F7E4637BDCD095D674DE8E318CDADF445D43689C363EBAC5C45675B14CDF7237BBBFD91E02EB10F923F70BC52FB0EBB20A461E5E4BC7AA7AC5AC93E78B47F0D9BE6D17F348EA3A4133CFB72B9C4EC71ED09E4EBF04BF221CA967BB54694822C649E2677BDBE8129A9E9FD033E78BFE831C47D6360578F53E8CA994FECE9AA1FF00E9C13387321A404EE97AB8D25267008BFD7963613C985CE1CC2EDD27D23BC715FB99D8D575AF4CDF9386471FE221A3CAE9255F5B5507E4A289837B83A43F680F253A6EA72A1C0769550B2E310D8E4988EE25CCBA7147D4FD2B719679E5DE06A42C3E00BBCD77D6CEFD289C55775875D27CF6AFD06867E690D5E9A7CCEB492EB93B1C4124EE00E2BDBE0EAFB46B00FF0008C7DB6CA5D29FEA29CD1D04300B450C516EECE2647F642EF1B7DB3BC915D23C0A8BA35592FC9D24EEFF0069D18E45E0029CD1F563A4E4CE18E2E334CC1FD31EB9F25EDA5E4E77F15A45E3447999E5D43D4D4A7E5AAE36F0898F791DCE7903C93AA4EA7A89BF292D4CBC35D908FE86DFCD7717B6E5B054A844176CDFB1150F40B4743EE524648DB217CEEF17929FD3C4D8C7B0D6B3E83437D028DCFEBF15603DDE360892485B6D9271278AE27A5DD3170261A538FBB24C360DAD8CFF00C957D29E959935A1A777B193E404DE4D9AAC2326F1DAB988E80DC0B0F450E580A30CF62FF830B589C379C4A8B2945F0B9E564E61D183763BF0FC115F03636C5C401BCB87A9C156B2EC172BAD0A297479DA2FCF62F45D0F4F512443FC43A368B8B10C901E16705CBC7A42963F69D20B6F6B4C83EB01ABE6AF97AD5A6886AC31BE42DDEE644398F69C3980AAC56F9E6591D6BFA71145BA4F494D13CB5EE8A4B1D916A9E643AC91D674825D8C88712D37FB494E93E993A77977661B7395CBBCD0834A9373703F042B4956732593BC8F0B0860ED2F51261AED6FD0686DB99BAA258013791C5C76173B5AC8075602369557C25C720AF57E3AFF0064444E339FEE91EA5D1EE9351D1D2B58359CF3EDC966FCE1D9739D800392CAAEB380F93879BCFDC179E50E8BA994D991C84EED477AD93BA5EAF6BE618C6E67D3B342272B24F3815B2B5DB0EA9EB1EA9FEE766CEE6DCF994834A748EAA4F7E779BECBEA8F00BADD19D52496BCB3B5A7735A5FE69CD3F5574C3E51EF7E3C1A87658D93BEA5D1E3CF99CECC93E654E0A1964203237BC9C835A4DD7BBD074268A1BEAC0C37DAE1ADEA9C434AC65B518D6DB01AA00B78262A7EE43D47D91E030742348C96D4A392C76B8B231CF5882B17D06B1178901E799E7B49D5B68D8FFE9B5CFF00DD925947D52EB7927945A2E9E1168A0898373228D9E83345171BF82992A52485B6DFB36493F993F82D01FACD45CE2AC705241A0DE2B2EB61AA27EF5192304ADFAB2CE4B7B14F629C1C405F67AD961FD7F75B295F48AB9F0C5AD1900EF2D6BBED02B8E1A35AA4F6DB13EC8E366F9AF20D33D30AD2E2DF843C0DCDB47B0ED6805723A42A5F23EEF7171C31712E396F28370C503DFEA7A414B17BF510B7F9C13E4B86E94F5891CB78A173BB2C9EE0D03B6E03588219EBDCBCC1EE3777017E6A0CCAFDC85CD86AB4750EE933064DBFF313E807AA88E98B813AAC20F10D6FFEC573E3DD278DB9238C200C06CEF4B9723E2B92F9FA4350F1BBCFF0F44299277E6E7790C3BD6A9262EA88D84FB2E786B80F66E375C62BD7E8BABED1E0071A70F247CEC934E2F6393647380E4A55673B31C1E32FECC3BDB9630EDCE7DDDE19A3A97434D2FC9413BB8F63235BC9CE0079AF6E6533226811C71B065EC318CC39054559CB3C8666FEA85E1031B1B3CEA0EAD2A9D6D611C7F4DD73E0DBA3A2EACB1F6EA07731870E64AF41933B21D3A2900EC91CC53F40A9DA2C75DE6F9921B7E41769A0FA1F4D4CC1FB26175EE491AD6E173EAAAD12C0676DF89E6BA34EE844A4D916B40C801DC0052BADD96594806AEB2EB765965C71A5B58B171C696292C5C71FFFD9, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (5, N'Tiger', N'Tiger', 3, CAST(45000 AS Decimal(18, 0)), 10, 1, 1, 2, 0, 0xFFD8FFE000104A46494600010100000100010000FFDB0084000906071413121514131415161517181F1515181818171817161D1717181818191719182028201D1E251B171A21312225292B2E2E2E17203338342C37282D2E2B010A0A0A0E0D0E1B10101B2D252026302F342C2C2C2C2C2C2C2D342C342C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CFFC000110800BF010703011100021101031101FFC4001C0000010501010100000000000000000000000304050607020108FFC4004A1000020102040403040607020C07010000010211000304122131050641511322613271819107144252A1B123627282B2C1F033D11524435373839293A2B3E1F125344463A3C2E217FFC4001A010100020301000000000000000000000000040502030601FFC4003811000202020103020306050401050100000001020304112105123141511322611432718191A1233342B1D11552E1F0C106244362F134FFDA000C03010002110311003F00DC6802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802802680280280280E4BD01CF8A280E83D01D500500500500500500500500500500500500500500500500500500500500500500500500500DEFDF8A02ADC779BCD87089685D6D266EADB8CC5C09907EE37E15EA40538473778A10B5ACB9A345B8AF94312016DBB6B1A8D29A05AD1A6BC00E68088E238B2A0C6A636A0337E2572F3DD24DDBE84CE5517DD40F39890A3EE40F7D640B7F02BF756F22B1B991958C16CEBA1F2C96F3061A0EC64D182E086B107A5A80698AE236ED82CEEA8A372C4003E26806385E69C25C30989B0C476B887F9D34C12E8F3407740140140140140140140140140140140140140140140140785A80E7C4140741A800D0111C4DA80CEB9B71411FC969C49DCA9198F565D369D26B24784A602E8366DE6B2F9BC442A4A9224329D4C10359ED408D0B0C74AC4F452EED40407106607CA406E848900FA8913F3AF50336E2386B8312A0DF5E9A8124F59CA18C69D26BD312EDC2D1FC6B40DD0CA8A7652A75500024B19D1A761D28FC1EA2E36B6AC4F44B18F0280A77331250316850C244292C4191A329ED5EA04072AE1D5E42B91E503409AF860E59943F78F5D66B23C2FFCB040B08A32E808F2885D18E8076AC0F49AA0392E280E45D140761A80F680280280280280280280280280280280F09A023F1B888A033BE3B8DC49BDA5DBD6B70AAB70A8D962405EF9BE63B564785AF80622F0BB96E33152858490DF6801E62034C18EC6BC67A5A01D2BC044714A0287CED718640B24660342019CA36D09EFDFF1ACD1E0FF00875F1E1A993E464111A6B95CC499020803FEB5E02FF85DAB13D3BBA74A0207167CD3DA80CE38B304C48B858E5F2822091DB50A098F7FA8ACBCF1B093F42E3C2D8E7B0C7292410C446A5813A107504C1FEB4F0174B3B57806F8FDA80A673258B66D335C5060183A02BA198276E827D7A57A8101CA186B4CA62DA12741DFACEA7AC6BF102B2678689CB6A059400408DBE26B17E4F497B86BC042714C53056C825A34131EFD40314067F81175AFFF006D74B751E3DECB2523698F6FCD1F0AC8F0D07972EDCCAEB709255C812D9B485220C031AF5D6B13D27680280280280280280280280280280280E5E8084E255EA0673CC3841F5959B97092493EC8333DE00F70F875AF4F0B8F05B5178799C85B642868EEA0C401EEEBB578C22DC0E95E1E9118E32C07AD019D739E3AD8BFE1B3A90A970DE40558AE55190B01AC6A7CA21890BDE6B29A9461BD7E0650D363FE5ABA8F69EC0BA99944AA66CCD10672E68300CF49D4ED5AA8573839D8B8D99E44AAEE4A1E74687C32EE6453DC03F31599A871893A5015AE298D4B4971EE12142F41249EC17A9ACEBADCDE918CE4A2B6CCAAEF1C9BCFFA1BA86E5C5395940784B64062C011A91ECEC3336BA835AB220A6BB6324D7D3DFD895529434F4D32D3CB5CCF87BAB6EDF992EAB8CB9F6B90F9A17580D1A4100F6ED52BEC53A6A5EABE843965C6DB5AD699A8E1CE951CD836E20DA1A029FCD57FC3C3B311308CC468091948D274F8F4AC90D6C80E595C978A1CAC374CB33ADB9333218448CC20695A7ED1173ECD73FB1BBE07F0FBD3340E5BD10AC4656223DF0DFCEB6B349357B6AF015AE2899B30960083254C18EB07A694050F84E153EB6FE6B860F46888F413DBF2EF591E1A0F2CDB8F13DA9CFAE6DFD95D36E95E33D2C62BC07B4014014014014014014014014014072E74A02131C6580AF5033AE63607119940CF6F2B4920021DC81AEA677E9020C9149CE305DD2F0670AFBDE8B67026D6C30CD94A94D663ED36FB132B1A5631929C5497A9E4E0E12717E85C09F2D7A62557997186DAC8306607C8931F006B7E3414A7C9A6F938C368C57197919CABDA933724F84352D94A92FA4ECE20900E751206A3DCFAACEFEF84BDB8DBFAEF8FD3F424E0CE0AB519AF7F41D62AE590AEC8AC970110C332819091994C0130148200F9D4AC0AF214529C976E9F1EBCEBFE7D485D4674F7EE31E77E4D97E8EB899C4606C5C620B152AC4756462A4E9EEA87910ECB1A2441EE29960C6B695A4C8CFF009BF87DFBC1C5AB6CC328132A06A589D588FD5A9D8B6D705F33E48B7D539C968A1E1B018B5660D65013B0176D1D42641219BF557BF5D24822BEDC6AA534E32E3FE77EC5B579338C5A6BFB7F916E3BC0F1F72D0230CE0A9CC3232319D0CE866411B8F4EB56D8BF66A62D465E7DCA9B95F3B549AE17B1B9709BC5EDA31041650C4110412012083D6AB1F964A11E26D5E0328E78E34F7A2D0BAF6ED84CD0A5467F30FED09D5841072ED1F3A996D6E9A94A2B6DFE26BC69AB6D6A4F4910F81F1C1053145583E606606A4C80110011A7A198CA04668587743B9B957BE3F4FD7FEFD4979B4350D467A342FA34E626C578EB723C4B6CB99808570C080F1D0F948223A03A4C0999747C26B5E1FEC41C7B3E2436FC97CBE74A886F2BB8F3A39F48EC35F5AF5033DC338F1CB800233B2B8901A51C0919646E272913A1EF5AECBA35E93F2CDB5D2E7BD3346E05A5CB80822487D7D64189F70AD8CD458D6BC07B401401401401401401401401401402778E94055B8EF12F04671A9D40EC0E5264F71A6DEB5BA8ABE24B46ABACEC8ECC84E2EE5DBA6E1C45CCC619BD8D23379532AF9146F9477D89AD3992EC9F6B82D7A7926E2C14EB4FBB9F527782731DDC3DEC3DABB77C6B4F7428D3CD68B3E5520F624EABD8C88EB3D551B29EE50EDD15CE728DFDAE7DDBFD8D8CB796A0124A9F1DE61B78420BA176604200546B206EC7F5BB77AD56DAAB5B66FC7A1DB2D2E086938C39D6E35A1D479A3BEE22AA2EEB71AFFA37F9936DE9F3AFFA896B78A162DB66CD700D0F9483FF001EF5E55D76137A70D7E6610C1B26F5DC3AE45E336B10977C252A12E1520AAAC12037D9D0EFBD5D42C562EE21DD54AA976B2C1C41B4ACCD4671C639C2E25E6C3A8408A4C9CA493B0227346F3D2A065E4CEBE21A2D70B0A172DCC7D83E1D69E1D81CE7A06D27DFB550DBD632A2F86BF43DB706B8BE0EB8DF187C3DA85553FAADAF4DA41152B17AB5D64B52D34675605538BE5961E46E2471183B37597296041133195D937FDDAE8632EE5B2A6C87649A1CF14B835921475248000EF274ACB7A30D6CA1F1EE0581BDFD9017DD7CBA5D73B003ECB014B3AAC60BB65346C860CA3F3283FDC4B857285931E3D875034137AEC01A69AB9FE8568ABAC63C1EABB12FCBFE05944AD5A9C77F9BFF0024F72B708C2E1B16E70EE49B890CBE207F60C8D3DA1B9EBD6A5CB31E4453DA7F81AFECFF00056BB5A2EB887F2D6B05039D78DB59B6CA8C50B65975203004EA149D14E9BD4CC7A7BA2E7ADFB223DB66A6A1EE6798356839713706EA09CA4CE666966001627B9237DF61502364BE3A52AD37EC59CEA8FC26E33D7D4BCF20731DC7C5B61AEBF8A45A2C977AB052B21BEF6FA36FBCCE9563934AEC5625ADFA1558F637B8B7BD7A9A926D504947540140140140140140140140140140218A3A50150E3B8DC2A7FE664CFB0B95DA67433974DBBD792C8F80B7BD1B2BC677BED4B6555396ECDC7F12D61F0DE19DC9500C7506ABEDEBB4297CEE4DFE048961DB5F1A43BE25C2F86DAB41AE5B4B6561D5973812A641CC9A6E054AA3ADC6DF96337F99ABFD3A5F7D417E46836EF0640C0C860181EE08915BCD0663F49939ED1D202927E2E834A8599F74B2E9CFE71CF2D48451BEA4E8BE513D08927E23B572D95A6F65CE4C74892E3684DB124880410C267D748FEA24547C76948D38EBE61BFD103698CFF4E3FE58AECF0FF948AAEA4BF8A5EF889D2A595E62BC5F5C6B9CC619EE2E91A65B8C860C7706AA33BDF4741D3798E8BB70A42574D88037D1A07DAEBF2AE66F6B66EBD2D91FCDA8323104C91AEBA4C46DFCB6ADB86DA6919E3C5F6F24EFD153FF00E1B67D0DC07DE2FDCAED2AFB88E7323F98C5F9D2E1187BB13B01A6FAB28D3E75ED9F7598D5F7D19EF28DD20C9D4807562201D8026675D475AE63362752B9A922F4EF2A4E5960244C06D778E91D8D5376EA5A2125F3152E05A718B063522E7CB2369B915D4F4A7C68C3A9AFE1AD9ABE2DBCB5745114AE378CC0B136AEA0B977ED664255634125BCBD0EDDAB5599FF00016B6FF22455813BBE6497E64560B95AD29CCF630BE193206451FCB7A83FEBF42970E5B3296259F75A449E19301631960A22DBBE4F86B01D673A95CBA794F4DEA7D3D4E3951ED526FF00135CB0654C7BFB525F4345B074AD86914A00A00A00A00A00A00A00A00A00A01AE34E940647F48C7F4F6BA801675D7CCD723F2A819CBE52D7A67DE26380BB6451BC28DA489EEBDCFA1AE532526DB2CB263A7C915CFEA7C273B8839476D0687A7F5F1ADDD3DAEE42B5FC365EB825F1F54B067FC8A1FF00E35AECD708E665F78CA79AB8A1C4DD2CA7C8C556C8EE96CB1373DCEE74FD5507AD40CBB116F814BD937C12EBA28135CFDD1522F6E826B4C5F89622E303A9D6B5421146154229F046720F1BFAA639AD5DD13130AA7A0B8B3967D18123DE05749836A71D14DD5296A5DC5FF9BB8DF8167328CD7188B7653EFBB7B20FEA812C4F455356127A5B2A611727A322C2592D7400C5820CA5BEFB162CEFFBCECC7E3549956ECE9B029EDE4B9E08B81026AA2C51DEC93676EC63C5AC3303335956E29ECCE3DAD690A7D1671EF06EDCC0DCD039376C1F5806E27E19C7EF574D8B6A944E6FA850E13D93DCFBC515112DFDAB8E0C764B4C1EE31F48017DEE2B75AF5122E3C5B9149E54BE46A46E67E75CE65C76CEAAA8B74F25C6EF1585D140EF02AB151CF2CD31C7F9B965407161631F87BF73CA8AF0E7A0575284FB86607DC2AFBA6B517A34F53ADBAF48D8B1773CB57A73463B899FAF5D3A6B71E0C9FB379C198F7455267F97B3A3E9CB75E8BEF0FB86275D67A6BE93D23D7AD733725B3CB57CC5478ACAE3B064904FD66D027F7D40DF6FEB7ABDE92D390CB5BC6D9B361B6AE90E745A802802802802802802802802800D011DC46F000C98EE4EC3D4D0187F3071138ABF99642B956B63A8B481BC363D8B97678E8196AB332C5E0BCE9D43DA6597855F75500135CFDB08BF25B5D08C9F246F310B8E84126B663F6C5AD1EF6C7B1A421C2B99B3F0F5C21392EA918672244590ACC6E0236FD0A324FDEAE9D5A9D7B3999E3B5734C8EC09F1AF17885D9474551A2803A002A9F2A7B3A2C3AFB63B2EDC2B0B54F759A31BACD1238BC108A8B0B5ECD10B5ECCDF9D705A12342350468411B11F1ABDC1B74CDD931F895EC5B1DCC8D89B6979FDA5B22D28FF00DDBA26F3FF00BB0A07A5C35737D9C68A7C6A74C71CBB85D07AD515F3E4E862BB205DF86E1C46B55374C8375879C470A22BCAAC62AB39332E6846B3716F5BD1EDB075F7A99F974F71AE8702DE74679D5A9D7B1E71BE24710DE21F6AFC151F72CA9FD1AFEF1973EF1DAA764D9C15F8346D939C1B07000AA1BACE765E592ED5A458BFC1A32D40773EE20FC6E4A9F34F0A050E95638B73524C92F56C1A1EF27F3715C0325C97BB866165167CD773E9607E6B3D0249AE9E166E3B398BA871B7B4AE60833DECD9B31510CC36762C5EE30F42ECD1E9154F99352D9D074FA9C63B65D2CE26E64804D53CA10EED9B6508776CAA73378A22E29F3DB65B893D191832CFC40AB0C19C613479935A9D2E28D939538D262F0F6EFDBD038D57AA30D190FA86047E3D6BA54F68E4E51717A64DD7A621401401401401401401401407175A050141FA44C7C59168CC5E7F0DA3FCD856B9747C510A7EF8AD76CBB63B37E3C3BE467DC1E6EDC6BADBB19F77A7F2AA0CA99D4E2C7B61B2FBC2B0BA6A2A96FB191EEB3425C730C329F7531E6F679558CCC6FAF8775C8FB8DF89B6BFDF5D25526EA355D15F1764CF2CDBD0541C97C96752D565E386E240D02BB91A1C8A5829EC5B607D26A32E9B937ADC571F529F272EB8BD6C91B97411ECB2FA302A7E00EE3DD512EC0C8C7E671E3DCD745D09BE1942E724D0FBAA761BE516A9EEB654ED9F2AAF4CEC7E50A3F051571690B1E3C976E0B014130001249D00F8D53591727A5EA59DF2518ED967C27100001E1BC1D89C893FB21D831F957AFA1E54D6F84505B9906F81CE29A57623D08823DE0D41B70EEC696A68938F6465E0CEF9C2DF94D5961BF9916762DD457F977CC53D140FF64903F0153F2D917A7AE76695C21001AE9EFE95476EDF08DD913D72CB05BBA8479595BDC41FCAABE55D917B945A2B54D49F0CAFF305B9535371E459E333315BBE1622E10352872FA34E50DEFC8EE3F7ABA4AA6DD441C9AF57A2D9CB585F28AA9BE7CB2D56A15A45E70785196AA2DB3E62BACB3921B983060A9D2A4E358F64AC79EF8647FD1071136B1788C21F66E0F1D3D194847F9A953FBB5D76259DD028FA955D966CD8D4D4B2B4EA802802802802802802802806F8B3A501907D2A6208BB61674F0EF37C73595FC89A8D95F749F8297732379656147FDFE42A86E84AC9F6C7C9D1B9C614F73E0B15FE655C390B721274D52F3FC0B22E4074D406688D6A557FFA7A37476ECE7E9AFF00273B766CA4F85C0FF1789176C8B8A4329EAB31EED4020FA100D5764F4BB30E5EEBDC938990ACE17932EE36D17C8EE87F8D6AD31FF9449B7F98BF02C3CB4065F318500B311B85504B47AC035AE8A95991A97824665AEBC5DC7CBE031368E330372F5EB41156CE6B201248CC247876C6EABB93B98D6674BF6E544B6A5FD497D35B3995A93D3F62639610E19F24FE859C8CA5891048CAC93B10AC663736FF0058D554BAAFDA1C6BB16F7C3E3F27FBEBF527D983F093B22FC781873B2652EA7EC922AB2157C2B5C3D996F44BBE952F7452704D247ED37F1558DFE08F8BF7BF32E8D8B366C070A19CDCB76AD83A8CF71A33475CAA1881F78AF6ACFA5E3A9774DFD7F235758B1B92AD78F2CE38C70347F01EEDB55BD75DB315966116DB2F8ADF789D759F67D48A9D764D98B0D45B7A5BFDD1598F5C2E969963E5490A30EE742B36D664DB21339504EB964388F45F59AD9E52CE72ADAF7D3FAAFF008244A878AE33FC368AAF36BF94D56E27DE47432FE532BFCAABECFC7F89AA6E6117A7FDD6CBA36294DC187126F3052BE40E13C49C8023020B42E62581015846B35658989F0A319249B7E5B28F2F21DB37B7C7A210E198EC4DABD0F716FA666026DDB5308CAA61AD8041F306D3480DA1D056776763CE0D4E3AF1FB98AC4B38945962E608C8AC272B8CC2771D083EA0E95CDE4E3C6AB14ABFBB2E5175D3AC73DA9795E4C9F1E3FC67E07F315674BFE0B192BF8F12FDC0B4510093D07B86B24E800EE74155CB1A57CFB63FA92332F8D31E7F244961F9B6D0B9E0B3DB56EC45F1D6273B5B0BF1DBD6A63FFD33DF1EF8CF7FA7F939F966B6F6D0FB8D0F299EA24763EA3A1AA6962D98D6F64CB8C3B54F98945E59729C670B1F699D4FB8DA7FE607CABA1E9FF74D1D591BE593A55A942294014014014014014014014036C66D4062FF004B4D17F0FF00E8EEFF00159A8F93F749D84FE61AE085CB785BAEA1838B2CD6F4824E52015F74E607D2A2E054D5FDF25C7B963D46E84A98D717CFB0FEDE4387B62DB35D8756763ACA94308A01858067D46B5B32EC8A4A11E1E9FE4F8F25663BD4B72F0497044D2E5B4960D6893BC964CA1499D8CC9F7B13D6A0D2EDBD590B3DBC7F8255BF0EB94250FD4AADBE5CBB8AC6E4045B55B64DD771A20CE234D249830240D099A91894C9C3B5F1C9B32B22319292E781CF10E2F84C3CDBC3B35D55052E3EA7386195B26801D09D741EFABBC7E92A29CBC3D14F91D56764A317E367180C49B3855769BA85D6DDA4580DE19745CD960B4FE94A47981CBA2F9C915D7C256DAA9DEB5B6FDB7E9FDB7E9E7C9BD692725C8FCE3ED5B04C5D45583E1DCCA088D97CA489310006907520006A363E04EEC88CA3A6B7CC96FF00136DD94AAA24A7BF1C23BE62E2787C5F9730B78861226425C27A0CDB31EC7E04D59E6749ED977A22F4EEB12947B75C111CB3CAE3C27C5632E0B1611DC0FBF70AB95F288DA440001662348DEA3C711DCF44C79DF063B5E44F8B718B5707856B3282CAF64C1660E84E5CC0779D849D23AD58FF00A77D9EADC7F4FEE418E7BC8B9FC4FD498BF88CAD6ACDEB776E3BA1B8DE10462AE3C36C9A9510A5F5260F596CD154B24EE94ED53D28F0B7EABFEFFF008495F2251D7239C0F1AB766E23E62C4332A0699332A64013A29209D60E5DE75DBD2FA7593B5CFB528EB8D7A98751CE8D752DBDC84398C61F14B73EAADFA5404BD927CD03AA7DE03B8DBA815B323A47C097747FE09187D65DB5F6CB95EFEA41F2A70CCB864C45C75452595175CEC51D8369E867BFAC56B5832BE48D9FEA51C683496F648F0BE22C71575ACC45E452CF226D782855E4ACC08240E8635815332652C78B52F2970BDF7EC40825645490EF0B8BB6D2F6AEDB21D99CA1956512C0B1D3A9592751BEBA4D50E5634924EC8BDA5E569FE4FF00F058E35FA7DA9F0FDC9EB6D6AF61D6D78A12E5B2CBE680A4BB4E5267CA75020C19D20D595BD2AC9E3C1F8697F7F722E3754AE9C8947CECCC78AE15EDE3323A90D04475DC6DFD75A8CAB942B7168B477D76DB19C1F059B16596DD84CE6D0B97B2DC68F642DB665041EEE54C7745A93835A8D4FE22F3FE5113A958ACB7717BD21F6385B67420936FC35863E624AB92CCCC0C1571987BA77A8F977494DFC1F2BD3F15E9F81AF1541AEDB3D49CB085F064282C2DBC291E6F29593AC6BE6D7DE4D43B2365D8EA4F96992F1E50AF29C77A4D149E5E33C6709FB6FF00F26E54BE9FF74D9D58DFAC6D56A73E2B4014014014014014014014036C66D40671CE1E0DBBD6F157905DF05196D5B3B3DCB8E8549F4516C9EB1BEE056CA69F8B3ED3C95BF0A0E4669C6B997137D9AE3B410656042A6FA283D3F13D49AB78D54A8B82D321295BF16327B3A5E6528D6116D5DB22DE6D12E1477F124924651ED163A01DAA9BEC717DD3EF4F7C6DADA5AFCCB4737B49A63D5E3B79AE282AE844B79D619B78DC69D751A93AD4EE9B858F08B7069EFCB456F56C8B5249ED685138BDEBF8570CDABDF5B2EC0416401D955A37D49F781AF59CD4215DB2925E16F465DD2B2A8ADF97CB2371BC1156DB117D58B296519480D07586935168EAD75937074B493D37BDEB64BB3A6D55F6C95A9B7CA5AF2466278303756D5866B8DFE558A15543DF690B1275DFA76AC7EDD28D6ECB925FED5BDB648FB3774D42BDBF7E3C120DC3ED151E05EB97AE2982814C28EA42C481A773B6BAD65879D777EF2231841AE1EFCFEE68CDC6ADD7AAA4E52F55A1973229244027CA3604F4EB1EEFC2ADF26C824B6D73F5297A5C26D4B87C32C9C651F10D6ACE70A96ECA14CD3965C2CB7A925A27D2AB164AC5A3E276B936DF8FA16AB1E5937F6772496BCFD486C6702828A6F5B02583B6BE4CA2608DC9EDEEAC63D5A56D4E4AA7BD2D2F7DFD4D91E9CA9B5FF113F7FA688FC1E0335D709742D95F6AF34AA907A47524FD99F7D6BBB2FE1C23B86E6FC4568DD0A3BA4F4F515FD44B0C32A5EB66DDE3781033347B30600993035D054FE9B953B17F1A3D8F7C2DF2CABEB5428C1FC37DCB5CB2278A5F6B77B3A12AC8D9948DD48D8FF5DFD6A5E4A4FE566AE9DB75264DF13E1576EDE2CAA02CC805800B99B33000EC331354F4F53C7C65D93DEFE8B65959D3EFBD39475AFC48F54C561D2EBA5DF097365619806B85586C20C807E1A1ACAFBF1F26C8C3B5CB6B7E385F89955459557B6F5AE3F11D709C2E2EE59045CB689ADC40F0189D0F88005327CA21DB5D011D2A2BCBC5AAF4941B978DAF0BE84858D74EA72DA4BFB88DE3386EFE633D6646B27AD751FD072517FF00BB1C708E61B8B6BC5687BB86212D3BF98E4BD6EE2E56FBD94A0227BC6D54B6510772FA9D0BB1C6B633BDC699DC1BD3715FDB51199E09232920C10768DA4C4549C8C787C2F978D78647C5B25DF2F524D39C19AEDD2BE32E788B621D44020C8224EFB083DD86D54AFA6AF86A3371FAC9F058AB7E6DA4FF0001F6139AAF8172E5B3908000046A35DD8753E864680749ABBC5C0A2BA3B22B828B3332D7949C98EF9471AB8CE2186C40516EF5B72B7947B0E1ECDD0B712751E61054ED3B99D2AB2315553DC7C1771BE52AFB5BD9B9D8DAB59A856802802802802802802802806D8CDA80CBBE91FD8DA4A65BBF2BAA87F8EA4626A56383F0D346BBF6ABEE5E8D32A4B8B6B870C8EC72DD019A02FB418B2913B415155EF1A14D7916C1730934B97E34B8FDCB2FB44ECB68AE6F89476F8F512C36180BD6D99EE35FBE2E05BB20F8412600044130209F53516EB9FC394524A10D7CBFEED92EBAA3DD16DBEE96F9F6D0BDBC1E6447BD7335C36C90E5801B9850806A32EEDEEDEA761E5CE16F663C528A969C75EFEAE5FD9159D4F1A1655DD736DB5E7F0FA7F7636B38655C3E251493945ABFAFED156DBF55AA6E164CECBFBA7AF2D71F4E0D195442BA1461EC9F3F53CCACA3079601580DAAF9658133DBCB351D38CA396A49F3E387CF1FE49128C94B17B5AE173CA1DE2035C372DD9708E312B758E68F1134D411BC4411E9EB54A9AAD4676C76BB1AD6BC3FFBEA5BB4E6E5183D3EEDEF7E50BE0B1569AEE215464B9E22BE52DE135C0A8A264EB008248F5F5AD8A9B635D4E6F70ED6B69776B6DFA7BEB8D9A6DB20E534B896D3E78DFF00C6C65CD38974B770A950738F67A823CDBEB5610C587C7AE328BD287AFBFA73F815F4E44FE0D8D497DEF4F6F5FDCE31F6C93826124B2AA11DCD8BC437CB4F9558C6C4B0ED4FD13FDC8AE0DE5D7DBEAD7EC2F8556FAC62865D0DB7331AC93E583EA09DB7AAACA9C3EC38CD3E535FF59638F097DB32135C0AE1D8CD96581831608753119868432EF9A7F2355B66977465FCEEFE1FD3E8FD8B186FE592FE5F6F3F88EB9742F8168D90CD6C865650572C9304DD9D4FA7C37D2B7DAA52C8942F7A96D69E9B93D7A47D3F12159A54A75ADAD3DAF0BF1644F1E6722C5955005F636CE9D0DD01751BE8667AEF5674D50965DD66DB717C73F4E7F72346C9AC2AA1A4BB973AFC7838B9882ED8C3A950485EC00BCFFC85649C55D8FBD6FBA46B6A4E9BF5EC85F0B85B570615AE5B5CC56E150DB3BAC05CD3BF941307B557665D6C2CBA109709AF1E8BD745862D7095754A51E5A7F9B39C1E116EB615B10AA98862F291973050D90328F403E123D2B0774E98DCB1DB705AE7DB7E74CD9F0A13F86ED494B9E3FB704B5FC3A304CD6E4F9B3136FC3562AA48393D2009EB5215D38634FB2DD2DC7493DEB7FF00DBF72BA15C27990EEAF6F52E75ADEBE856F8762A2D0BAA8A9E2E2150281A016ED65303DF7AA6E4D0943E14A4E5A4DEFD7C310BDFC4F88925B6B8F4F44481BACEF7CAB05B96815B642AE81DC0D4FA476D8EF50E75429A694E3B8CD6DEDBF296CDF5D92BADB79D383D2E3D1BD0961B0C6CF8F6F0CE45EB6C9E23BAA91733C68349001331EB51E56AB9C27931DC249E926F8D12A15FC3528D4F524D6DBF5D92188E10A43CBB06770AE58A92D240CEAA3613A41E9AD59E2F55BD51271827151DAF2B5AF4FAFE451E674EA67950EE9352EED3F5DEFD7E873F47362DA63C642CC33ADA96D0E6C9886611EEB63E75B2CB6D9C22ED4937EDEDE8499C2119355B6D2F737BB1B56A340AD00500500500500500500500DB19B5019773BAE6C40B7F7F078981DCA1B3717F82B6532EDB62FEA26B754919BDBE3072062D172DE96B2DB4851960493AEFE9FCEACA5D3E9ED9C75C4BCF3E4D31CCB7E2439F0B8E3C12182E203F4792E59365866C487708EACDFDA15510C24FDD907F1AE66FC67B97745F7A7F26BC34BC6FDCBFAADD6B525DAFEF6FCFE471C1B89AA97B22E5CF0C16168429014EB0189CC24CFCA6BA1A3021271BAC8AEFD73F8FBEBDCE77A8E5CA117183F977C0A72A5D7BD7B10ADAE7C25E5D0000640ACBF911519D51C7BD2878F2495395B8FDD3F241E0AFB0B6F96DA34C12593311EE3D2AEE4BEA56FF005C78155C42361EDD9BAB76DF864956B66D8660D264A310D3FAC26A86DC6B637CECADA7DDE54BD0BD8DD54AB8C27B5DBEA85F19C4CDDC4061680840805D504C6E19B3680EBA1FD6F5A99D2F0FECD53837BDBDF044EA590AE7DDAF43DE60B66E626CA9555CED6D6140CBA90BE589153B23883E4A7E9BEADA1FF183381475906DE37116A44820393746BF0AAEE9CD3724CB6CB8B4E2C83C66387868029044666F11C96CBB823613AFBA74A9F6D49C1F8FD3C1171AC7F11EFF00B931FE11B4B7D6F8BCD66D900B59F09D7368444FB07F6876AE5E5877BA5D32AD4A5E93DFFD67451C8AA36AB54F51F58E847816310E21CAD9243B96D19D4807A426913275EF5D362D2E35C2337B692E4E6FA9D9DCA528AE1FA0AF0A39B88A124E542F760924016ADBB81AFB85639CA31AE4C74EDBAD6C88C1E3191D412D94C96556CB9892DD7DF51B02B8594C5B49B25E6CE55CE493E07783E256CBDC576750522C162F705A61B37975F881A7A547EA58D34E32AD27CFCC970E489583747B3563F4E1FB33AC7E3D0D854B9756F5F0E183A482ABA699C81AE8758EDDAA3E062CD64B9C61DB0D7DD7EAFF0002464DF17428B9774B7E50FF0088712270CAC86EAB4C4B5C2C488E8481E9F2ABF8E2D5F0FB7B56BDB4730AFB3ED7BDBDEBCEC638C736EC60CE84E4B97F51326E5E804FC2D8AA89C63664FC27E34D71F817A9B855F1179DA3D1C4D644BA017F28C47E8C80019CD0C4F43D63D6B6E5E04634A714DB82F956CD78995295B3EED2EE7F37048626E97B7796F155B6A26CDE5B8B9AE95F633643E7D237154545495B5CA94DB7F7A2D7097AF9F05C593DC26ACD697DD69F2FD8530FC68B61D9CBAB5D1958FE882E66DA5883E6CBDE06D5D1D5D231D465149E9AF7F0BD97B1CC64751B9644395B4FDBCFE23AE40FEDF04C601BD8BBF70C6DE4C3B269FBCCF50B2D28D8A0BD168B3AF7284A6CDEEC6D5A4D42B4014014014014014014014036C66D40655CFD8AF0AF788A0675C25EC8489CB9EED8B4C40EF95CD6CC78A95D14CCA4F553338E1972D8B4EAD683B130BA8581FB4675DC6BA6DEB37B35271DECAC528AB121C5DB4832F9036C029BF6CA062428D3D98933A2C083D3687F36F827AED7E58BF0DB6B6C8394ACE9E5C4234E8770ABE9D74A9356D95BD42518C78E46FC2310CB6B1D90952517D9FBA6F2AB2CF6CAD150A493CA49FB13EB7FFB6425C231ED691C2E50588199866CA0EF03B1133DFE5564EB52441958E3647D855B882051E7B19812C4782C149D1A215177624492749EF350A5096C9EA51F53BC2E214EBE25863ED91F57D4B3292C092B13202927433DA6B755096FC1A726C8A83D0CF9A6F92C844295008CA02C1D35D3AE83E55B3223C3441E993DA63CE358C6384C35BD02B35DBAF020B5C171D0B31EA7293F33E9503A7457CD22DB2BEF24776F161ADDBB62CAB102598B8420CAACA9919402C76234824F966A75B0696F641C7B139B4171155A52CA4B1014F8A8219E209F3198D7CDA448DA3587A64F5DBAE58B70EB010AB359503CA34C4499330614C93A1D4CEFAF4A9946E4CADEA128C60F5CFEC34FAEB2E3D1944677169849694B916DC13B92549D7BD619905D8D33674F97756B5C0C30B7156F82466504E9DC6668F774D77DEA3F4F5BA525EEC919F2D36D92E1D6E333784A80FB317944F9A173296598CA267D4C8CDAECB62D3D1E5334E098D92D2B682CAE55EF8950492A84924EAC619403AEC7A8358C1C93F06E97625F7BF61E715B80619932C10D07F4A6E2C88323A1F783D6A7A4FB7651C66BED5AD1118CC417C358CDBA67B4A7F510A1507A686E36BEEED54FDA9662FCCE83FF00858F2D59B2EB6D45972E002E44409DC4199021B520F4EB5637292457E34A2DC8E2EF0D5CC4783759BBC5B042A95048D06E594491224C7A45849A64DD27CED0FD6D2DBB1710A5C525642B787DC806544E846F3D2AC2BEE6B65264CA2AF8A63CFA3AC4E7C460148836AFDD45F50F66E5D33EA1988F7476AA3CE8256A91D052FF0087247D01636A8E6B15A00A00A00A00A00A00A00A01AE376A0327E7CB46E632D591ED5DC2E22DA7ABF91D3FE24159556285B17F533ECEE83289C36CDB7B643794F5906647E3B74AE82C9351DC4A782FE2A8B199C1206202E61DFA46A247F5D6A1F7CB658F6A26380E1EDA992361D648F302223A9DBA7515223293E115D9918A5B90872FD9172FDDB2B03C6C3DEB69EAC087B7AFED20155B91355E545B2CB1A1DD8ACE384E52A55C153B308EB0371DFB55B49FCBB455E946D51636BD8650D08034EC7B911034F53D3B542727EA59A8AF41DF0CB085E72839BDD1B120CFCBDF35220DEB48D17A5AE4579A145FBF69506F9431888504493E804D2FDC2B7B21E0B5397037E2081B0B6AE7D94C4DFB2476F1185C4FE17A83D3669B944B3CF8CB49A15B9C2D5ED8CB1A7A9FC7D7E5D6AC2DB1C51071E2A526C895C1A03041276F7699BD3A7E751FBDEC9DDBC139CB3C3EDE759EF313D35DFA01A7E1526364BD0AFCCAE328F22772D28E20A57D94CD78EBA016D0BE9E99C003DE2B566CBB696E46CE9CB7C47C111C2D573A868DA75DBDA235AD3D379A11BBA97163F61E713E1680E6991BE876DF7EDFF5ADB65ADBD1ED304A086D6F04848D32EFBCEA14C1FEBF3A55366738F058B8961ED2E0E3ED4C8DC347AFA54A8CA4FCF8299C631BB8F257B18996CE1D4FF9B6BA7FD6DC91FF000043F1AA75352CD48E82716B15B1E5EE1C8F6C10468369D4F51BF58F85595B3715A2B71926DB2397049B41F7FAC91F9FA75AD309BD931C568B2617096970B7677234D4EE27D9EFA8EBD0FCE642527C14F9108C6C4DF93AE414CB8BE1FDEE5EBD760F6F05AD2FFCB635459D24EFD23A0A22D52DB3E82B1B5683015A00A00A00A00A00A00A00A01AE376A0315FA55BEC98CC23A186547607B10F6C8AD17BD4764BC48F74B4C46FF0BB58B5376DB0B175B57462424F52AC01107D40F7D4CC5EAD1EDEC91AB2FA4CE12566B6BDD1116F95715988536D97B8B969BA7EDFAF5A97F6BADBDB23AADA5A26784F273819F117902F501B393F05FC81AF2EEA95551DF8FC4D12E9F2BA45738CDC167176CD895F0D2549DE43EEDEFEDDB4AA4B327E37F117B9794E37C1D56FD8B25FE196B18A6EDB6166F30F3231CAB9BA95682209E87F0AB2C4EAAB5D8C8199D2A7192935B5EE41DCE51C6AB42DBCEA7A836D81DC1221EA67DAEB979E0D30AA4BC123C3392F18EF2F16D7B92A23D0005BF2ACFEDD5417069BB1653E18FB8FF0DB586421087BA443389CA34D6277275D6A973BAAAB5F6C0B3E99D25C23DD2F05779531B6CF8F86BC62D5E76F36F91D5DB2B11DB520FF0074D634E47C1B766DB687756FB7CAD8B719E0188C3A8F2CA6C186AB036F3C65DBBC1AE8565556456CA18634EB9B6884B38A69D46BE8E8018F79D358DBB76AC528B7B2573A2739770589BED16ED98260C09007BC48303B98ADEADAA0F6D9032A9B2C4E2893E3BC24612DDC0CD9AF5C10FB12AB20C123A920683B0F52683A9750564BB225E748E9D2843BDAE1117CB983B789B16EDE6097D0B1524C075676313D08D77FFB67859AA9976B30CDC395B1725E06DC5781E2ECB6B6DE3A1C8C411EF40C07FB55692C8AA7E0835552824B7C0961F0189780965F5D202B92074DD6001F90AF636571F2CCA70935A45CF0FCA4E2D8B98B6C80190B233346C02F79EA622B4E5F54AAA8691A70FA65965FB4B6CA9DFC4AFD781B8A4DB2194A8DC295CA23F6441F8573F464F2EE3A5C8C4ED8C688F92431BCA774A838671757A00406F4F2120FE75D043A8D7644A0FB0CE99BDED318D9E5EC71D3C0607B9561F9E93FDC2BD8E4529EDB364AA935AD167E1BC9CE2D16C5DC08BF74105FDC00267E3A7A56191D56AA60C8D4F4CB2EB93F247F07B93C6B09021433051D80B37001FD77AA2A6F774DD8CE8B2F1963D2A1FA9BCD8DAA69502B4014014014014014014014035C6ED40623F4B83FC6B0A4EC6DDC1F2649FCC547C9FBA4EC17F39DF020328AE7ADF2CEA77F216FE1F6ADB1059109F55527E66AB6D9D8BC37FA9597D6BD8EB8CE50A40DBB56BA1C9BE4D75268C93987FF0034BD8A1FE2AE9A8FE48B17F197E059F81AF94557DAFE62DFFA345A30380B2C416B56C9EA7289F9D439E55F0FBB36BF32B2FA2B7CF6A25CE12DA0F22AAF7800543793759C4E4DFE646AE118BE1147E6B88356B89E859477DACA37084976FF0048FF00C46ADF25F043C15F37E668DC2AEBA8015DD47A18FC36AAF8E65B52F95F1EC4CCAC3AADE5AD3FA13784C033193798CEBADBB33F3082B09F5BB61FD2BF7FF254598718FAFF006FF048B8745CB9D8E9B9CA3F840151A5D6322DE385F87FCECCE9C6AF7B7C940E6D5F2B56FC57B9265D71F09A2BDCA6BA0F8FF11A9D96F922F4F5F232FF0080B408825C7ECBBA7CF2913F1A812CEBEBFBB2FF00C98E462D527BD73F4E09FB18050273DC27D6E39FE75167D5F2DBD776BF2457BA229917C6C69AD635DB3B1EE6DB2D3122A3C2465B8F1FE363E357B4BFE0B30C8FFF00A625E3855A0409018762241F9D56593947EEBD12AE8C64B525B2CD80E1D663FB34F7469F2DAA15B9B94B8EF7FA953663C13E2284B8B280A7F08AC6994A52DC9EC998EB5E1147E063FF0019C27EDBFE165EBA6E9DF748FD5DF08DEAC6D56C73E2B4014014014014014014014037C52C8A0330FA4DE59BB8A4B4D632F8B6589018C065600309EF2AA75EC6B09C7B968DB558E0F68A0E1AC715B3E5182631D886FC41A853E9F093DECB387579C569A1DDBE3BC5537C05DF82B1FC81AD12E915BF5327D553F30FDCEB11C7B89B8D7017BE208FCC5791E9108F8679FEA70F487EE57F8C58C542DFBD86740A4A9FB5A100C98D4090753DEA6471BB23DA99A659AA7352D6B42BC339CED5B10D9BE550ACC09C9ED1655F54A75A913B86FA48C3AFDEF95459F4BB24259B8D2FEA1FDDFA4EC311B9F91FEEAD0BA3DA9F8305918AB9EEFD8ADF1AE71B1741CAC67DC6A6D3816C1F28CA79F8EA2D45917C371216E3CE8736600E9A3F987E62A5E456DA34615D152F25F787712B703CCBF3AA79D72F62E64E325E4B0E038CDB1F6D7E62A0DB8F27E844B296FC0BE2F8C5B20C30AD50C692F43CAF1E48A4F35E314A13356D895BEE448B9A854D156E09C6ADD9CA1DA206BFBDE6FE7565918F39F82B70F2EBAD6A4CB66139D70C23F482ABA7816BF4264B271E5FD4899B5CFF0085CBFDAAFCC0A872E9776FC1A1FC26F7DE88FE21CE1867062EA7CC56FAF06D8FF4922BB6987F522917AFBDDBB72E5847BC10007C305A33B68607A2B55D538EFE1F6B2B32B322AEEE8F3A24B0BCD77ED8D7097FFD861FCAB4CFA6397A9B7FD620D73164859FA4A74D0E1AE8FDD351A5D15BF5317D471E5E533CBDCF8F734185BE67B21ACA1D1E51F0D19C7A9E3C7C264CFD1A70DBF7B1FF005AB962E5AB76D182788A54B3BC01941D480A5B5F515698D8FF000A3A657E6E62BDF06DB6469528AF14A00A00A00A00A00A00A00A039759A018DFC1CD00D8F0EA03CFF07501CDCE19340346E0FAD00D6EF2C58632D62CB1EE6DA13F88A01B5CE4BC21DF0B873FEA93FBA80E1391B0636C261FFDD27F7500A0E55B09EC58B4BFB36D01FC050101CC3F47587C5B1770E970882F6CC1302066041074115E68CBB9900DF4376FA62AF8FDD53FCC53B57B0EF97BB126FA1DFBB8DBA3DE9FDCF5E7647D8CBE2D9FEE7FA9DAFD109EB8EBDF04FF00F75E7C38FB23DF8D67FB9FEA38C3FD11DA047897F117075590A0FA1893F222BD518AF431764DF96CB4DEE44C25CD6E61AD13B4E583A6DAAC1AC8C5BD883FD1970F3FFA55F835C1FF00DA87821FFF002AE1F33F573FEF2EC7CB3500B27D18E006D865F8B39FCDA809EE15CB36ECAE5B56D2DACCC2A8027B98DCD012A3879F5A03CFF079A03A5C01A01EE1B0B1403E51407B4014014014014014014014014014079140114011407850501E786280F3C31401E18A0036850099C30A039FAA0A03CFAA0A03DFAA0A03D5C28A03B160501EF822803C11401E08A03B16C50065A00CB407B96802280F680280280280280FFFD9, 1, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (6, N'Sài gòn đỏ', N'Sài gòn đỏ', 3, CAST(30000 AS Decimal(18, 0)), 10, 1, 2, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (7, N'Sài gòn xanh', N'Sài gòn xanh', 3, CAST(17000 AS Decimal(18, 0)), 10, 1, 3, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (8, N'Heineken', N'Heineken', 3, CAST(9000 AS Decimal(18, 0)), 10, 1, 4, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (9, N'Đậu phộng', N'Đậu phộng', 4, CAST(49000 AS Decimal(18, 0)), 10, 1, 1, 1, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (10, N'Khô mực', N'Khô mực', 4, CAST(30000 AS Decimal(18, 0)), 10, 1, 2, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (11, N'Tôm khô', N'Tôm khô', 4, CAST(63000 AS Decimal(18, 0)), 10, 1, 3, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (12, N'Khô đuối', N'Khô đuối', 4, CAST(20000 AS Decimal(18, 0)), 10, 1, 4, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (13, N'Thèo lèo', N'Thèo lèo', 9, CAST(57000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (14, N'Cơm cháy', N'Cơm cháy', 9, CAST(67000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (15, N'Cá viên chiên', N'Cá viên chiên', 5, CAST(21000 AS Decimal(18, 0)), 10, 1, 1, 2, 0, NULL, 1, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (16, N'Cơn chiên dương châu', N'Cơn chiên dương châu', 5, CAST(71000 AS Decimal(18, 0)), 10, 1, 2, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (17, N'Ếch xào', N'Ếch xào', 5, CAST(23000 AS Decimal(18, 0)), 10, 1, 3, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (18, N'Chân gà hấp', N'Chân gà hấp', 5, CAST(39000 AS Decimal(18, 0)), 10, 1, 4, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (19, N'Cơm cuộn trứng', N'Cơm cuộn trứng', 5, CAST(91000 AS Decimal(18, 0)), 10, 1, 5, 2, 0, NULL, 1, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (20, N'Khoai tây chiên', N'Khoai tây chiên', 5, CAST(96000 AS Decimal(18, 0)), 10, 1, 6, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (21, N'Đường', N'Đường', 6, CAST(64000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (22, N'Muối', N'Muối', 6, CAST(70000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (23, N'Bột ngọt', N'Bột ngọt', 6, CAST(97000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (24, N'Cà phê', N'Cà phê', 6, CAST(16000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (25, N'Thịt gà', N'Thịt gà', 6, CAST(54000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (26, N'Thịt heo', N'Thịt heo', 6, CAST(78000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (27, N'Thịt bò', N'Thịt bò', 6, CAST(51000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (28, N'Thịt vịt', N'Thịt vịt', 6, CAST(42000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (29, N'Cá diêu hồng', N'Cá diêu hồng', 6, CAST(81000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (30, N'Trứng gà', N'Trứng gà', 6, CAST(87000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (31, N'Trứng vịt', N'Trứng vịt', 6, CAST(79000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (32, N'Đá', N'Đá', 6, CAST(69000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (33, N'Trà', N'Trà', 6, CAST(10000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (34, N'Soda', N'Soda', 1, CAST(23000 AS Decimal(18, 0)), 10, 1, 5, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (35, N'Cháo vịt', N'Cháo vịt', 5, CAST(78000 AS Decimal(18, 0)), 10, 1, 7, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (36, N'Cháo gà', N'Cháo gà', 5, CAST(75000 AS Decimal(18, 0)), 10, 1, 8, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (37, N'Gạo', N'Gạo', 6, CAST(51000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (38, N'Vịt quay Bắc Kinh', N'Vịt quay Bắc Kinh', 5, CAST(97000 AS Decimal(18, 0)), 10, 1, 9, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (39, N'Heo quay', N'Heo quay', 5, CAST(85000 AS Decimal(18, 0)), 10, 1, 10, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (40, N'Gà nướng', N'Gà nướng', 5, CAST(7000 AS Decimal(18, 0)), 10, 1, 11, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (41, N'Cá lóc hấp bầu', N'Cá lóc hấp bầu', 5, CAST(13000 AS Decimal(18, 0)), 10, 1, 12, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (42, N'Cá diêu hồng chiên', N'Cá diêu hồng chiên', 5, CAST(88000 AS Decimal(18, 0)), 10, 1, 13, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (43, N'Dầu ăn', N'Dầu ăn', 6, CAST(61000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (44, N'Dầu hào', N'Dầu hào', 6, CAST(43000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (45, N'Socola', N'Socola', 6, CAST(13000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (46, N'Nước tương', N'Nước tương', 6, CAST(43000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (47, N'Sting', N'Sting', 1, CAST(36000 AS Decimal(18, 0)), 10, 1, 6, 0, 0, 0xFFD8FFE000104A46494600010100000100010000FFDB008400090607141010151010101514151616101014151714141415140F1415161614141415181C2820181A251C141521312125292C2E2E2E171F3338332C37282D2E2B010A0A0A0E0D0E1B10101B2C2420242C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CFFC000110800E100E003011100021101031101FFC4001C0000010501010100000000000000000000000103040506020708FFC40044100002010204030503080708010500000001020003110405122106314113225161713281910714234252A1B1C11543536283C2D1253372738292E1F0631624343554FFC4001A010100030101010000000000000000000000020304010506FFC40033110002020104000502040602030100000000010203110412213105132241513261144281A11523337191D152B1C1F0F124FFDA000C03010002110311003F00F718010020040080100200400801002004008010020040080100200400801002004008010020040080100200400801002004008010020040080100200400801004802C0080240160040080100200400801002004008010020040080100200400801002004008010020040080100200400801002004008010020040080100200400801002004008024008010058010020040080100200401200B004802C0080100200400801002004008010020040080100200400801002004008010020040080100200400801002004008010020040080100200400801002004008010020040080100200401200B00200400801002004008010020040080100200400801002004008010020040080100200400801004802C008072ED6178067717C4E88C5448EE25B58C8E27B9E539B8E6097433C0D3B918268CD17C63273072F990B6D193A41C46725671B1822D4E26D33B90D0C8E30DF94E64EED668B29CC4575D40492671AC1613A7020090058024016004022E3B16292EA338D8291B8981E427371DC1CA7125CF28DC304EC3E701B9C6460927325F19DC9C1BA998784E64102BE74567324B047ABC4FA6327303238CD41DC4EE4619A1CA3321885D4B3A99CC1613A08B98D7094D98F819C6C94165E0F9FF39CD5DB10C55B6BCC329BC9F4946920E3C852CC2A817D51BD96AD054D9268675549B0339E632CFE195632683098A7B0D4FB997C72FB3C6D4C6BAE5B5227D2AAFF006FEF96189D91F81F5C3EBE6E6307158BE0B1C1E4F46DDF6BCEE0E3B7EC5951C161D3925E77041CD92FB6D1B53B01043392156CEEA21DED19677823D7E2975F03EF9DCB2246FF00D7047B4A3E339B8EE19A0CBF8816AD035AD6024B3C0C32B5B8BEE7BA82DEB23B86045E28727D91F18C8C13686785B9DA7723049C462E9D45D2C6FE51D8E88A94A90040413877732AB1B978BEA59C689A9A2ADE9907DBB48ED64FCC4BD88B531ACBF5FEF9DC339E62F8185CD589B769CF611C938CA0FB446CE0D7A7ED37395C9B47ADA7D1D76ACA33D8BC654FB52B76335C7C36B2B1F18F7DCC8F98C93F0FAD1EC3F2638CD7474F5134D52CA3C1D753E5CB83712E30193F942CC3B1C31F3DA556BC23668EBDD33C3F0E9AD8998BB3EAA2B6A2755A802DA196422F275815D7515473915D96CDED836C5E20C5325614D1FD9163EB2D9368F2A34C2D6E4D0CE1F1B5C9D9F94E294893D0D2FD89299D575FAF38EC689C7C2E964DA19D57B8EF73F59256483F0AA4BCC17CEAA8245555B6FBF84BA2E4CC376934F5ACB3A438822C6B313FBAA48B7AC92C98273D327C210E11DBDAAB52FE807E53BB6454EDA575115786DAA7EB9FEEFE939B5FC9257D4BF296B83E05A2CA0D5ACE0F5BB28BFDD3AA1F720F531F689A9C0E1E850A3D8A905396FBDE4FAE0CD29E5E4AFCD324A2E34A2853E236338E39251B31D99FAD941A7C99C1F127AFC241C596AB23F047383AAA2FDA1F74E6D64BCEABFE270D5AA28F69EFEE9DC30ADABDD0C1C6573B2D71ABEC9B5CFC0CE3DC69A169ED96DC126BE031BA359A9DDB5E312C17AD3E9F76DF73335ABD72483537DEF2B7391BBF8654BD8A9C4E2AB756907648B578752BD832DC5B2D54666E44188D8F2576E8AB517847A7F10B53AB455F50F66FF74D13C3462D1D8EB960F36C79DCCC923E8EB9268AF669144668F42F922C6FFEE0D2BF3476F85BFACD343E707CF78B43D3BBEE7AE4D678260BE5556F87945DD1E8F87BFE61E2C2A11CA603EA62B81FA0ACCD61BC924CB37A8AE4D165386EC58D47DACA48F59646387930EAB50A71DB133B52A1AB559CEF763F8C8B7C93AA3B605AE11340218D89925C137CE30451516CD7E77D8CA9B35C53CA26D224A037D86C249743852C1A1E1E662ACDABBAA096BFD99757D1835FB1476BF732787E21AC0921508B9B5B52F76FB72322EC79302F0CAE4BB27E1F8A6BFEC81FF5BFE779D56BC117E0F0FF0091329717D41CE901FEB3FD23CE3BFC11BEA44CA3C5F54EC69FB8B5FF0029D577D84BC0DAFCC4FA3C4D8B71F4585D606D7007F496A9B7EC513F0950E256242D1E2BC6545634F0970B627D9277361B69B9DE15927D2392F098C1A529AE4878EE20C6DD55E8D8BFB20B01F5B48BEDB6FE338EC92F63B0F0A8CB389F4536273CC469D4D4B624ADF5B91A813B6DE87E122EE97C1747C1A0DE37FEC55D6CE6AB1F65474FAC7F1323E7C8B3F8357F25A70A629EA6234B15DD59400A059A763636F073F095E9DEE3D6B0C51B0DA4B01B5BD0CD3C60F3EC6E376E48F33E24C28A4C42B6AB9B9332591C747D1E92FF0035665C60CBD66DF632836C92686C9EBD649332D91C17188CC5DA8A90DCB6B4B37BC18AAA23E614AD589DCCAF393D2DA970862A3C1C66D7E471BFB4BF8357F1497D1F51E278BFF47F5FF67B94D87CE186F9515BE1A537747A1A0FEA1E274A9163613CF4B93EAB728C72CD06580521761BCD11583CFD4599E98E62F186AAB81CB499D6CA2154B8933354DF48B83633336F27AD15943D5316CDDE6379DCB2D824B843D450B0D842E49B9A89A9C0E01128B76BCF9803C7A4BE30583C9BF592F33D3D0D63733EC72E7A6B60CEFD98239E9E6649FA60677357DE9FB2327854B027CADF1941EAA45CD34D3401B799F5E824FD8E7E7C113B2FA357D4A492CBA7EB0B7D63E46FF74A9E0D7197ADAC13890749542B652AC6F70D507323C362BB49FDD1C8A7CA93FF00E1A3CAB39A815DC5EEC6E748B0165B6C07297467268C76E96B6D459A0E0C626B588E4A01FF001733F8CB6A7C983C4D62AC8BC799654A809A6BABBBA8DAC2C05CF5E7CBEE9DB62DAE0AFC2B555D7C4D9E7398390CC8A4DA98451E1AD46E6DE37D5BCC6DB3DFAE09C773EDFF00D1566A5CF7C7566661ED12C3E1CE4727271F81DCBF1068D54A80F2B1DBF0924F0CC5A886F8B8FB9A2CC389AA23B20A6003B83BF23D65D2BB060A7452B16E6CCF6333277E66552B1B3D4AB4908222355DAD205E88CCE7C675109B2C701BD27BF8892C70668BF5915D644D89F1C9CB61DAD7B6D25B5E0A6574738367F237FF00D97F06AFE2B2EA3EA3CAF17FE8FEBFECF729ACF9B31DF28C97C3CAECE8DBA37899E4F95E182BEA3D2648C7D47BB75AF60CE6158D4A9A4494DE3A2AD357B9EE9745E53CB452C33B3732A6D3918F193B6DDBA6A2BA313333ECF52BE8B0CB309DA30079733E92D8A21759B23946A2A55A546894502D6DCF527CA5D85D1E44AD96ECBEFE0CFD6C63D45D2B755BDBCFDE6737E3845F0D1CAC7BED6339C8654A087D9D2CD6FDEBF395CE5C725D4C20AC6A27185C425273DAD12C749006AD256A586963B588F2EB2119A35B8B92F4BC1D3E3C90CBAD806D24AF43A6FA79785E376516C6B8E53C1C1E43BC2DFF0032382F5EE68B0B9655A985ED011A50D566B83A886D2469502ED70072F1972AE4E2609EAEBAAFDAFB6586435A80A4BAF12C432D51529206D6B56E02D940DC5AFB9204B2AC60CDADBAC53784963186CB26E28C352746A7894A0CA5B5268ED9DD0F464A7CBD4B5F797F5F63CA76EFCC1E679F8F621E71C68185A9D77ACBD495F9BAAD8EC3480CCDF112B9591F93469F476B7950C7F73178AC5863B0037BEDAC9B9F53BCCD269F47BB5C6E8FD72235670395CF227D64705BBF2B2C64D7FBE48A2659D673528D266DCF7C5FC81D84EBE8A68786D109D2D206B52C8C1824F81B224B051279E8B7C968EAA4FE1B5E4D2C986DB5572CB1AAD8BA74CD946A696C6B31DBAD93FA469EAB904BEC0F2113692C1DD2467296E66B3E4707F691FF0026AFE2B2347D44FC5BFA3FAA3DCA6C3E6CC9F1EADE8CAECE8D7A4FA8F27A8963B79CCC9727B537E939C930DAAB0246D79CC65964E4A157068F375D44AEA160A45BDD26D18AA9A51FB98318525F481D6D33CA3EA3D885A94325FE69469D145B0DD79F99F097ED4798F51379FBF456E191EBB72B93B01E12B94B7708DB4D31A63BE7D9A15C026169DEAEEE6D65F0F59351515C943BA77CB11E8A2E24ABAD68B30FAB500B721B8E7E52BB1E516511DB6348A4EA25313D24895430AD51BB82FECDF702DA8D87BAFF000966DDCF8232B6305991A7A991F6094D83ABE21583AD20350701B71A798502F763B7396797B7FB9856BBCC6D3588FC9CE679F05A7D9D23A882476749C8A74C77BB95313CDAC58F753972BCB5F0BD479B172B26FC98EE7F2CCB62AB54AA0076B25F48A54FB94EE7C45EEDEF320EEF68A3743C362DEEBE4DBF838A54B4EC80017D200161B75F4953CB7C9E9571AAB588AC0F6F60072BB11E76E67D24305B9591A3B6FD4F2F4F19D3AFD5C2E8E18DA11C781A2249144CBA1FFC6A3FC4FC64A5D19EAFAA4252C133EE058789D84E28364ECD4421DB1AC462A850B8FEF6A7403700CBE1560F2F51E21297088D8FAC5F4B32E9246E3C2576F66ED136EBE47F04E7B1641F58892A8C5AFE648AEAF57B26B2A75E665C8C127B7D8958DAA4DBD266B1F27BFA38FF002F26CBE46C7F681FF2AA7E2B2747D462F17FE92FEE7B84D87CD999E354BD29099A74CF0CF2CC7E29291B05D4656A06C95EDF051E3332ACA352AE913B8442564DAE4B5C9E83B21A8EE492247259158C64616F4C86037BCA5F67A6B128E08B9B542F502F86E7D4CED8F8C15E92B52B1CDF4BA357C3D875C3619B12E37B777D620B6ACB21A9B2575AAA465B158DA95D8B58924CAB2E4CF5615554C70C5CF70ECB470FAC6E35EDEB693947D265AEC8CAE7B4A9C3D16770882EC4EC36173E02FD65105966E94D421966932F0F84A8D4CA2AB81DA0AE7D85A2459FB4079A5AF60399134C534F08F375165738798DF1F043C76686AA94A65969BDB5BB6D5ABDF6BD4237A69E082DB73894F6F5D9551A596A3D76711F643B94E4CF5554A2FB151958F250AA3A74E77FCE423173E59B6DBEAA16C8FC7182362168D10027D3380CDAB7ECC31361E05F7F77AC70841DB63CBE110AA3127723AADC00028FAE401F09C2F8F076479780B79744FCC991E090C555BDFD3FEFA2F846324D4B6AFB12E964CDA51EBB8A14D88552DED3963601298DCCB615679661BFC4209E20B2FF0062AAA8B12BF65997D6C48FCA40D2BD514CD26578AA2B4292D55BF76A313E02F2E8A4D1E35D64958D4594D8DC6D4C55C8714682EC3A5FFACB784634DCF9C8992BD00CE29AEA2149D6DE3E42725D64B74F184AC497246AD50B1249991B3E854125C13E9965A3A905CDE5F51E2EBF3BD608FF00367A87554D87849B9A4555E9E767671891DEDA6693CB3DDA6B708E0DDFC8EA5B1D7FFC553F965B47D4797E2EFF0095FA9ED7361F3867F8B87D148C8BA9ECF15CCF5A3136EB205FCA38CC496C3A9237244E63059B9CB82EB294FA103CA568D124D2432F862C7BAB7DFF00EDE45A3529A8C7922E272BD3519EA54541E677B7A4ECA0D9CA7551AE0D13B17C57865A030E14D5D3E1C89F8C9EDE306256E2DDE9999C6712D40DD9D2414C5AFB0DE712E0B6763DE93E49C5DAB60E9173762E6C4F89BEC4C4D1DD1CFD6D92B87F0EB45EA621C8B530574DBBDADAE34DADE5F7CA2B8A4DB36EAEC738A847DFFE8819F62199FB262366D55C8370D88E7A3FCBA7B01E773D259396C5F728D2D0B5166E7F447AFB977C35C3C7100B543A692DD6AEE6E59486054DB969E66575D7B9F26BD76B7CAF443BF63BCF33B56029503A28A9F4354766C413FBBAADB7C64A535D22BD2E924BD73E64FF006E4CA33A8B0BF20807FA5401F7927DD2A4F07A7B24D7475486B20202C7A002E76E5B7DFEA449A59E8A67255F33782E1322A8A3557B51A6175B3B9D825F71EBB6E3A9DA4954FDCC73F11863D1CB29B15C514A931A780A06A543B76B55433123AD3A62E3D2F2F8C144F36ED54ACE3BFB2E8E1F2BABA931998D56D4194AD3075552E3BC1581DA9ADADFD2253514774FA4B2D9664FAF6F622D56BB163CCB16B785C93F9CC9EE7BF8E30779E0D387A5E6ADF8CD35F48F035326A736143138738545A8492A49D23A99369E4A2B9C36619CE514B48AB57415522CA0C859D60D5A18FF0037763839E7329F42DA6B25ED23A70E7DD2C4F83CE9453B3923126DBC8C8DD5C56060A5E44B65D1BDF9254B633F8753F9669A3B3C2F167FCBFD4F629A8F9E33FC5C6D44C8C8B6AE59E398AC3977258DFCA52E67A30D3C9F6491872C9A48B01CA437366C55C223D960085949BDF6918F64EF598F0739C62EA0228D0216C2ECDEB2F583CA949CA5C14B4B23ED89356B97D89B0DEDEBBC6E24AAE32D8C707E1D7B47D81B3E9171D2466FA27A6827B8ACE2061F3CAA46C00B7DD3BF948279B1BFB1A3CAA86BC0D0162772D61CCEE7948D85DA37DB1DC38B56ED49D4111AA6A1F58530582565F1D858CAE2BD46DD44B6D2F1DFFEF4536090937BF7AE05CEF7773BEA5E6431241F0BC84DEE964D9541554C62BE326F78A8B61F034B07415B53F76CB72DD9AEEDB8F124096D998C76A3CBD06DB6F95B6BE11945E1CADA355629417C6A3007FDBCE531A9FB9EACFC46A4F104E4FEC41D18267141316CF55BBAAE134D1153A0624F23CAE258E958E0CB1F149BB167097C07106615B0382A09498D2A951AB0A84001EC9A469D5CC6E4F297571E123CDD6DF9B276479E782B71F8F7C4FCD72F0C4282AAF7372F5AABDCBB78D8185F246FFAA305DB4B218ECCDE81AB470340525A45A9D4AE05EA3693A493508EEDCF411FDD9D94A514D571E17B8ED0A87E6542E6E59AB5424EE4EE05C932ABDE1E0F4BC253941C9B2301B8F5947B9E9CFA350D96D3AB8702AF2B369F116E734C5E227856C1CA6D7C94B84C1D0A67BA9AC8EADFD271DAD9A2AF0F845E18F629CB0B1E5E0394A24DB3D5AAA8C170444A5BCE2253E8D061B0DAE985F312E8A3CAB1B522467197A5251E33938A468D2DB2994A29F84ACD9297C9BAF92B5B633F86FF0094D14F6787E2BFD3FD4F5C9A8F00CDF1A1FA03213E8D3A6FA8F24AAE4136991B3DF84728E4D63D4C64B541649196A12FB4EC7B23A8E20719FE0535EA7AC176DC03BCD0B2785249CB392170AD02057617234B69F3D8CEB6209E381BE194EC37ABDDBB93BF84A6725946FD2D33DB2E063159653356A546D4FAB7B01B5BD645D85D4E8F9CC8BFC3229C3D2544000160BAB4B733EC9F19D4F710956AAB1C50F55CAB45DF13569D20D4EA53FA42057B3ADB7453DEF7CEC57396556DEA70DB15FE8A07CDF0186B6815712EA7502C42530FE2146FD277CA5D8B75F26B6B78F6E07DF8BB31C70D386A6541217E894DED7DC6ADE49FC332D587CC23C7CB32589AACD8AAA6A331282A5F5124861DDB6FD6E6731E834798FF001584F84BFF00053361DB476A077430526DECB73179767D8F35426E3E6AF92CB3ECEDF1A987152DAA9A9A44F56DC779BCEDD67170CB2DB236462977EE255C43E1B1BDA15B3D37570ADB72B15B8F848C166382CD4B70D46EC64B8ACF8DCC14DC2D0C35EE469ECA8DEF7BDB9D46BFACE7A625A95D77A52C2FDCEF1D4C22D1A34C965A4ACA59974962CDAAE17A0E5CE669C9499EE68E89D30497433412EC2411AACE8D2629F450563E0E07BE5BD44F321EBB7054E59847705D50917E923B708D71B62E6DB6159483B823D656CD9192C702D25DE751558CD4E50A052673D397ACBD747973CB9E115398D56ACD732A93C9E8D515522161EB053622F09155B36FA37DF26D6F9E5C7ECDFF009668ABEA3C8D7B6EAFD4F549A0F14CD71BFF007065767469D2FD479314049B999B193DDF3369C33228DDAF1B4EF9EFD87F2CC75DEC8BB78C9C4A6E7294791AC6E0D1EA9B82C492773B4EB9BE919A1A458DD21FA1856E7AC5351B58784872CD917082C24358AA54810412E6FBF3B5A464964D153B1AC747431FD15428B5AE77368C9175BF9E4B2CA710802B0008A62A3D8A9372A09041E9BDA5B0C18754A51CB664EBE1D2A8EDF178B235DDB428667F3B9E43E32DCBF63028A92CCE5C123179661930389AD429DC04A5D9552C4B135188375FAA45AD690CB6CD128D7182DBEE9933E4F56C987DCDB562AB1DFA22585FC79C8CFEB2542FFF002B6615AADDB12FE25CFF00BAA1326FA4535BC4AC97C2343C2EF4D300CB596F4EBD5ECAA6DBAAAAB10EBE04120CE4E4932ED1E9E5655C7B73FDFD8835B821E8115313595289722938FA46ACA37BAAAF2D88F6ADCE76766D5C95E9B47E659E879C73FD8D1710E697D15453A65991D833D25675452426FE83ADE5129E307ABA6D3C5A9EEFCA407AAD57BCEDACD87EB74DB6E8BB01EE95CB97C9BAA4941617EC4575BC81A5F47785A5BC92467B5F058E7A0B2D141CBBC4FC44BBD964F3EB9624D2ED9A1C8E9AE1B0CCEE77B6C24A2F0B2CAED86EB142265EB624BB9277B999F7727B0AA518922960CF30369248CF3B5744FD645020788926F82AA5276658C54A2452BCE244E73CCB08AAA297613A5524F07A1FC9B6D8DB7FE37FE596D5F51E6F882FE57EA7AA4D278A67F8C6896A06C2427D1A34CF123C4B1D70C6FB4C4F28FA7AA31686F03A4B8D7CA132DB295B7D269F0F8AA2A34D31BDA5AA48F3A74D9DC8ACC4B77AE0DA45B2CAE39586475F33791346105E09A43A996971A8F757A93B6D3BB484AE51E1765BE4D4D0D32054011410ECC6CA54DD4F2E677E52D82C1E5EAE6DCB9F732199E1B094A9B2AD47AD52C421B05507A6D7B9972723CE6AA8AE7965B3E5953F43760885AA355A5703A5FBD63E161BFBE45C8BBCA96147EC2E435D306B4A9D76D2CB43114CE9EFE9AB598817B7958CA6535BCF4AAD2D8E8DA97BA2B28E574A8EB55C355AC477DCD4EEA7746ABE9427617BDAFD646563E97B16D3A3AE3DC92DDFE44C3AD5C6544A2AAA101EEA228445D5CED6E64F89264229D8CD974AAD156DC7B7C22DF8A3102AD4A384A2C0AD0529A87B26A93F48CA79102D696D9EB928A3CFD145E9A995B3ED94399D5EDEB2D34E5DDA6BE5493DA3E5FF00323DCB3EC8D1874E9D41FD537965D63722AC94F59ECDD01035029A96E7BA491F54F43D646507D97D3ABAB3B56532A1E915366523DDFF006F2BC60D9B949703F8602FF87E7271335A6D32AC2D3EC854AA0585FD7697AC6393C89396EC47B28738C6F6D53BA4003603C44A672CBE0F574D43AA1991558E508001ED1E73983B2B5B1CCAAB36BB5F6B492325982D01029127C61F44E94F70E54757A5613B9580E0D4CA8A1873D048963C2ECD9FC98A918DEF7ECEA7F2CB69FA8F37C4DAF2B8F93D666A3C11BAB4C30B110CEA78317C47C1D4DEEEA2DEE94CAB4CDB56B6703195F8437EEB4A9D2CF421E2DF23543871E912E4EC019C55B45B3F118D8B69099016219AD39824A785910D3A6BBB551EE9DD83F13F088EF9B53436A54CB1E576E53B8487992982D2C4628F7AFA7C06C2321C70B9782E572C14B0ED46A5C6AB7B3B9BEABD80F1D8C9A6D7663BA11B1E2054E1F0C8AAD528E1D6E973AAA10E4E922F65E961EB22E6D96D7A5AAB694BDC9FFA28AB17C462459F596173A3BCA6CF6BEF63A7A48ED7F25FF884D6DAE3D111D30F4DEF4E996434AA23ED73DA9170C8EDC8581EF5B948B514CD09DD387A9E3943CD9B5460DFDDD1461DE1ED960A8179743A0806C37B4EEEC95F9114F8E5905F1E29AF61855281BE89AA7EB1B50BAE9B7B20F5DEE7C6714BF2C49F9197E6DCF38FF056E3AB0C3A14BF7DADDA5B70A4FD44F33D6D3BD7A576CE292B1F9F67108FD2BE47F87B2DD6E1AA9D20697AACBBF6740734047C4FBFC231F957437BC3BA7F54B84BE0D0718664AC130F48A140A2EC83BACAA4E85563BD80DEC49B13174B8C21E1DA669BB27D99EC3DC820DF4D881CCA873B2FA1BCA964F42DDAB9F727B608D306EC1B490A6DB84D4799F5B49ED68C4EE537D13B33C591429A0DAFAEFF0074ECE5C1DD1D49C9B641CAA86A7B9E921059669D559B63823E70B6AC7DD6937C33225BA299D65B65058F8584648CA1F05A60CA9A6750B89D5CA23CA9702DC0D950C23AE5F2C9187C2D4720253B4924D99ACBA0BB66EF82F87DA8D4EDAA732A57E3697C238E4F3353A8535B51B296184201CB2DF630083572A4637B4E6015B9BE516A2FA773633925C1656FD478CE684EB208B5891314B867D469D2712B88DE4773362A61F06A32D5C25340EE6EDB1B79CB63B7DCF3AD5A894B105C0ED7E255D928ADB7E70ED5EC761E1F27EA9B1BF9CB544BB9D46E57D45CEC3C2F0A59442DAA3092C156CC5559439086E4E903753B301D6CC400A3ADAF2397D17C629B4DF622A01CEC0DDAEDCF4903E9083E08BB5FED319CE09F2FA158EAD88B5F42DBC1AA9000F75351F18CE4B123AC3E56F5C1740025F121AA31D34D05F4AEA73B74E51B5B2165D0AF8EDF1C22163716B47E8F0D7A9508546A80779AC2DF46BF557F78C9C7E23FE4CF6C96775FFA47FD8C64B939A8FDA31F637A8FA4B53A0876D5FBC79EFE538B8E23FE49C937EBBFBFCB13D033FCDFE6AA69D23F48C09D4AC34B21165761C98106C06D6B4B2525158465D2E9657CF74BA46330D4435C2B12BCDD596C4798236BF9CCE964F62C96D5D7257E22A2B3928ACABDD03F227FAC9631D19A52DDCBFD4B1CB19851A8092136B00A3497245EEDD0F292F633E333C9618C4069D3D5FBF6F889C97468D2E79C11B2FC6953A48DBC848C645D7D2A4B391735A7DA306504F4361252FB19EA492C30FD18EC2F6B28F1DA36B647CF845E3DCD2F06607B556056F6B4BAB8A3CCD75AE2D346B28E43FBB6F74B7623CC95D27EE5B60327086E4492454E4D970A2D3A70580100200401185F6300C6F1370452AF7A8BDD6E66D2A95699B68D6CEBE0C0627835EE74383E476943A59EAD5E2F1F7440ADC31885FA97F42243CA66C8789D2C63F42E217F54647632E5AFA5FB93C507A7446B520EFF008C9A4D2315B642CB3D2C45C0D43DE50A48B5BBCAA0553B2DC311B20E93BB58F3A0B86C4FD1A029156B52A69754DDFB46345776EED3BEEC79C6D7EE77F12BF2ACFEC477CE30B48F715B135359A80905298722C3B8BB90078992514572BDBE1CB1F65CB236271B88C590951B42DEC94A9A824780545D81F5B986D7BF24A10B3B82DABE5F2CBAE18C80A962C4D26A6E808035D4BB0EEBD46E452FB1B72F2B4EC5B977C15DAEAA97A3D4E5EECB0CCF88A9512D4F0D4C1752FA9BF560B0B3DBF680F5076B8B8895915C227A6D0D96E276BE3F732588ABAAE7CBEE1333793DD8C54782E70786B61DADED14661E6C45F9FA4B631F49E5DD666E5F066939586DCBADFC45E713E0EB83CB6D96E842D00B7EF31ED2DCB63B0F5F49D6F82B506A79448CC58E8A56526DABA7989C97B16E96514A49B24D2C531034E1B7F4925FD8A64A39E663D4E9E29CDD690507D2496EF8289D9A78AE6592CF2AE12AD886FA5A840E6409355B7D98ECD7C17D08F48C9B27A7854D083D4F8CB947079965B2B1E59620491584016004008010020040108805563723473A86C7CA73008872361C8DE3006CE50FE13983A6538E68F65D9861F5491E66FB4AAC3D1D072CF3D763D188BEE6CC45CFB8CCFBDAE8F7BC8AE7DA19A74F5B0566D8955BB1660351B5C827CE1592671E8A98C5CB6E7F566C701C234E90D55DF505D7AD14844045EDB837E9F7896A87BC9981EB1AF4D30C7E8495CDF0F40AD2C3852490BF463BB6DC0BD43BEAF65BAEF710E518F477F0BA8B732B5F1F73379AE7556B917B2001974A5C0218DD813CC8245EDCA532B1B3D5D368E1547E4861760C3EAD94FF0080FB3F98F84876695C3C31EAFA6985640096BD8B1D4CB636DD3D917E9CE4BAE882529B6A45B60B340E2ECC030DD86CA3C2E3A012C8CF279F769DC5FA4A4A3414552BED00C42A8B9BDC9237F0B9B48ACE4BA505B73FE493532EACA0D5AB4CA816BDEDB5CD80B0E51B65D957E22A7E98B37FC2983ED30AA745ECCE2F6F49A60934783AC9B5634997699439E4A04B3063726C974B2327DA33B82192DF09855A62CA2740FC01600400801002004008010020040080100A2E2AE1E5C6D3D24E975B946FC8F9484E3B917517BAA594792E6BC218AA2C4767AC0FB3CFD6C6659D5247BD4789552FA9E0CF6228BD3DAA2327F89489561A3D585D5CFA698953186A1BBD42E4F3BB13BFBE732CB63082E91DE1EBE860C3A10DEF1384A4B72C0A5EFF00127E3BC128F0B03F4317A55934821AD736EF585EC01E82E6FEE13A9F18212AF32524FA1EC06328AEA15D3502005DBBC39DEC6FB4945AFCC53A98592C796F04F39E61B5376786ED092AC2FA7A281A48DEFC8FC659BA2BD8C7F86BB0B7CF03D43118AA94C53A5840A0054D456DDD5DC0DEDD6C67536FA467B169E0F32B33F62E32BE0FC4E2DAF5EBD9058155BD879784B1424FB30D9AEAA1C551FD4F50CB300987A4B4A98B2AFDE7A93E72F4B0B079539B9BCB254E911600900580100200400801002004008010020040080240206719776F4F486D2C0EA56F06F3F29C60CD3E1B114FBB510B0F1035AFDDCA7308EA782354C0D2A9EDD1427CD45E4762F82D8DF62EA4C8EF90618F3C3A7FB4FE522EA8FC16AD65EBA93383C2D85FFF003AFC1A73CA8125E21A8FF91D0E1BC28E5864FF00699DF2A3F01EBF50FF0030FD3C9682EEB8741FE81F9CEF971F82B96AAE977264CA3856E494C8FF0008B7E024945154A727DB2650C96A39EF770753D6DE4277040D16170E29A8451603EFF3324707A009005802400802C008010020040080100200400801002004008025A01C3D153CD41F50200DFCCA9FECD7E139802FCD13EC0F84013E669F604E83B14147251F080380400802C008010020090058010020040080100200400801002004008010020040080100200400801002004008024016004008010020040080100200400801002004008010020040080100200401200B0020040080100200401200B0043005807FFFD9, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (48, N'Cocacola', N'Cocacola', 1, CAST(22000 AS Decimal(18, 0)), 10, 1, 7, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (49, N'Pepsi', N'Pepsi', 1, CAST(71000 AS Decimal(18, 0)), 10, 1, 8, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (50, N'Hành lá', N'Hành lá', 6, CAST(34000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (51, N'Tỏi', N'Tỏi', 6, CAST(47000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (52, N'Ớt', N'Ớt', 6, CAST(12000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (53, N'Tiêu', N'Tiêu', 6, CAST(50000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (54, N'Xà bông', N'Xà bông', 6, CAST(61000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (55, N'Thùng bia ngoài', N'Thùng bia ngoài', 7, CAST(18000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (56, N'Bánh sinh nhật', N'Bánh sinh nhật', 7, CAST(69000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (57, N'Đồ ăn ngoài', N'Đồ ăn ngoài', 7, CAST(99000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (58, N'Thùng nước ngọt ngoài', N'Thùng nước ngọt ngoài', 7, CAST(5000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (59, N'Giờ hát', N'Giờ hát', 8, CAST(25000 AS Decimal(18, 0)), 10, 1, 1, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (60, N'Tẩy đá', N'Tẩy đá', 1, CAST(66000 AS Decimal(18, 0)), 10, 1, 9, 0, 0, NULL, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (61, N'Chivas 38', N'Chivas 38', 1, CAST(50000 AS Decimal(18, 0)), 10, 1, 10, 0, 0, NULL, 0, 1, 1, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [MayIn], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SoLuongKichThuocMon], [Visual], [Deleted], [Edit]) VALUES (62, N'Chivas 38', N'Chivas 38', 2, CAST(5000 AS Decimal(18, 0)), 10, 1, 1, 5, 0, NULL, 4, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[MENUMON] OFF
SET IDENTITY_INSERT [dbo].[MENUNHOM] ON 

INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (1, N'Nước', N'Nước', 1, 0, 3, 10, 0, NULL, 2, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (2, N'Rượi', N'Rượi', 1, 0, 1, 1, 0, NULL, 1, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (3, N'Bia', N'Bia', 1, 0, 2, 5, 0, NULL, 1, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (4, N'Đồ Khô', N'Đồ Khô', 2, 0, 1, 5, 0, NULL, 1, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (5, N'Đồ chế biến', N'Đồ chế biến', 2, 0, 2, 14, 0, NULL, 1, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (6, N'Nguyên liệu', N'Nguyên liệu', 3, 0, 1, 0, 0, NULL, 0, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (7, N'Dịch vụ', N'Dịch vụ', 5, 0, 1, 0, 0, NULL, 0, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (8, N'Karaoke', N'Karaoke', 4, 0, 1, 0, 0, NULL, 0, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [MayIn], [SapXep], [SapXepMon], [GiamGia], [Hinh], [SoLuongMon], [Visual], [Deleted]) VALUES (9, N'Bánh', N'Bánh', 2, 0, 3, 0, 0, NULL, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[MENUNHOM] OFF
SET IDENTITY_INSERT [dbo].[NHACUNGCAP] ON 

INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (1, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (3, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (4, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (5, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (7, N'45615121561', N'Trần Minh Tiến', N'142 Võ Văn Tần', N'0986954226', N'0986954226', N'5345345643', N'minhtien05@gmail.com', 1, 1, 0)
SET IDENTITY_INSERT [dbo].[NHACUNGCAP] OFF
SET IDENTITY_INSERT [dbo].[NHANVIEN] ON 

INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (1, N'1111', N'Trần Thu Khoa', N'b59c67bf196a4758191e42f76670ceba', 1, 1, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (2, N'2222', N'Trần Minh Tiến', N'934b535800b1cba8f96a5d72f72f1611', 1, 1, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (4, N'3333', N'Nhân viên bán hàng 1', N'2be9bd7a3434f7038ca27d1918de58bd', 4, 4, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (6, N'4444', N'Nhân viên bán hàng 2', N'dbc4d84bfcfe2284ba11beffb853a8c4', 4, 4, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (7, N'5555', N'Nhân viên bán hàng 3', N'6074c6aa3488f3c2dddff2a7ca821aab', 4, 4, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (8, N'6666', N'Nhân viên bán hàng 4', N'e9510081ac30ffa83f10b68cde1cac07', 4, 4, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (10, N'7777', N'Quản lý 1', N'd79c8788088c2193f0244d8f1f36d2db', 2, 2, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (11, N'1234', N'Giám sát 1', N'81dc9bdb52d04dc20036dbd8313ed055', 3, 3, 0, 1, 0)
INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (12, N'4321', N'Giám sát 2', N'd93591bdf7860e1e4ee2fca799911215', 3, 3, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[NHANVIEN] OFF
SET IDENTITY_INSERT [dbo].[NHAPKHO] ON 

INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (20, 2, 1, 1, CAST(0x0000A3E9018796FA AS DateTime), CAST(250000 AS Decimal(18, 0)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (21, 2, 1, 1, CAST(0x0000A3EA000095B9 AS DateTime), CAST(750 AS Decimal(18, 0)), 1, 0, 0)
SET IDENTITY_INSERT [dbo].[NHAPKHO] OFF
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (1, N'Bán hàng', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (2, N'Quản lý nhân viến', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (3, N'Quản lý máy in', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (4, N'Quản lý thực đơn', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (5, N'Quản lý khách hàng', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (6, N'Quản lý thu chi', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (7, N'Quản lý giá', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (9, N'Quản lý kho', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (10, N'Định lượng', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (11, N'Quản lý sơ đồ bàn', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (12, N'Báo cáo', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (13, N'Quản lý thẻ', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (14, N'Cài đặt chương trình', 1, 0, 0)
INSERT [dbo].[NHOMCHUCNANG] ([NhomChucNangID], [TenNhomChucNang], [Visual], [Deleted], [Edit]) VALUES (15, N'Thông tin phần mềm', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[QUYEN] ON 

INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (1, N'Nhân viên bán hàng', 1, 1, 0)
INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (2, N'Quản kho', 1, 1, 0)
INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (3, N'Quản lý', 1, 1, 0)
INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (4, N'Khách Hàng', 1, 1, 0)
INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (5, N'Nhân viên bán hàng', 1, 0, 0)
INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (6, N'Giám sát', 1, 0, 0)
INSERT [dbo].[QUYEN] ([MaQuyen], [TenQuyen], [Visual], [Deleted], [Edit]) VALUES (7, N'Quản Lý', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[QUYEN] OFF
SET IDENTITY_INSERT [dbo].[QUYENNHANVIEN] ON 

INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (3, 3, 1, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (4, 3, 2, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (5, 1, 4, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (6, 1, 6, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (7, 1, 7, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (8, 1, 8, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (9, 3, 10, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (10, 5, 4, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (11, 5, 6, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (12, 5, 7, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (13, 5, 8, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (14, 6, 11, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (15, 6, 12, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (16, 7, 1, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (17, 7, 2, 0, 1, 0)
INSERT [dbo].[QUYENNHANVIEN] ([ID], [QuyenID], [NhanVienID], [Edit], [Visual], [Deleted]) VALUES (18, 7, 10, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[QUYENNHANVIEN] OFF
INSERT [dbo].[THAMSO] ([BanHangKhongKho], [SoMay], [MayInHoaDon], [MaBaoVe], [Logo], [BanChieuNgang], [BanChieuCao]) VALUES (0, 1, 1, NULL, NULL, CAST(0.0735294000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)))
SET IDENTITY_INSERT [dbo].[THE] ON 

INSERT [dbo].[THE] ([TheID], [TenThe], [ChietKhau], [Visual], [Deleted], [Edit]) VALUES (1, N'Đông Á', 0, 1, 0, 0)
INSERT [dbo].[THE] ([TheID], [TenThe], [ChietKhau], [Visual], [Deleted], [Edit]) VALUES (2, N'Vietinbank', 0, 1, 0, 0)
INSERT [dbo].[THE] ([TheID], [TenThe], [ChietKhau], [Visual], [Deleted], [Edit]) VALUES (3, N'Techcombank', 0, 1, 0, 0)
INSERT [dbo].[THE] ([TheID], [TenThe], [ChietKhau], [Visual], [Deleted], [Edit]) VALUES (4, N'HDBank', 0, 1, 0, 0)
INSERT [dbo].[THE] ([TheID], [TenThe], [ChietKhau], [Visual], [Deleted], [Edit]) VALUES (5, N'Agribank', 0, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[THE] OFF
SET IDENTITY_INSERT [dbo].[THELOAILICHBIEU] ON 

INSERT [dbo].[THELOAILICHBIEU] ([TheLoaiID], [TenTheLoai], [Visual], [Deleted], [Edit]) VALUES (1, N'Ngày trong tuần', 1, 0, 0)
INSERT [dbo].[THELOAILICHBIEU] ([TheLoaiID], [TenTheLoai], [Visual], [Deleted], [Edit]) VALUES (2, N'Ngày trong tháng', 1, 0, 0)
INSERT [dbo].[THELOAILICHBIEU] ([TheLoaiID], [TenTheLoai], [Visual], [Deleted], [Edit]) VALUES (3, N'Ngày trong năm', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[THELOAILICHBIEU] OFF
SET IDENTITY_INSERT [dbo].[TONKHO] ON 

INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (25, 1, 61, 5, 3, 1, NULL, 5, 5, CAST(0x0000A3E901878362 AS DateTime), CAST(0x0000A3E901878362 AS DateTime), CAST(60000 AS Decimal(18, 0)), CAST(50000 AS Decimal(18, 0)), 1, 0, 1, 0, 0)
INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (26, 1, 61, 5, 3, 1000, NULL, 15, 15, CAST(0x0000A3EA00007A32 AS DateTime), CAST(0x0000A3EA00007A32 AS DateTime), CAST(60 AS Decimal(18, 0)), CAST(50 AS Decimal(18, 0)), 1, 0, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[TONKHO] OFF
INSERT [dbo].[TONKHOTONG] ([MonID], [KhoID], [DonViID], [TenMonBaoCao], [SoLuongTon], [SoLuongBan], [SoLuongNhap], [SoLuongHu], [SoLuongDieuChinh], [SoLuongMat]) VALUES (61, 1, 3, N'', 0, 0, 15005000, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[TRANGTHAI] ON 

INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (1, N'Bàn dang l?y món', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (2, N'Bàn dang ra hóa don', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (3, N'Bàn dã tính ti?n', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (4, N'Bàn dã hoàn thành', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[TRANGTHAI] OFF
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_LocationX]  DEFAULT ((0)) FOR [LocationX]
GO
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_LocationY]  DEFAULT ((0)) FOR [LocationY]
GO
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[BAN] ADD  CONSTRAINT [DF_BAN_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_BanID]  DEFAULT ((0)) FOR [BanID]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_MaHoaDon]  DEFAULT ((0)) FOR [MaHoaDon]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienMat]  DEFAULT ((0)) FOR [TienMat]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienThe]  DEFAULT ((0)) FOR [TienThe]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienTraLai]  DEFAULT ((0)) FOR [TienTraLai]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienGiam]  DEFAULT ((0)) FOR [TienGiam]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_ChietKhau]  DEFAULT ((0)) FOR [ChietKhau]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienBo]  DEFAULT ((0)) FOR [TienBo]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_PhiDichVu]  DEFAULT ((0)) FOR [PhiDichVu]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienKhacHang]  DEFAULT ((0)) FOR [TienKhacHang]
GO
ALTER TABLE [dbo].[CHINHKHO] ADD  CONSTRAINT [DF_CHINHKHO_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[CHINHKHO] ADD  CONSTRAINT [DF_CHINHKHO_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHINHKHO] ADD  CONSTRAINT [DF_CHINHKHO_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHINHKHO] ADD  CONSTRAINT [DF_CHINHKHO_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_SoLuongBan]  DEFAULT ((0)) FOR [SoLuongBan]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_GiaBan]  DEFAULT ((0)) FOR [GiaBan]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_ThanhTien]  DEFAULT ((0)) FOR [ThanhTien]
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO] ADD  CONSTRAINT [DF__CHITIETCH__Visua__09A971A2]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO] ADD  CONSTRAINT [DF__CHITIETCH__Delet__0A9D95DB]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO] ADD  CONSTRAINT [DF__CHITIETCHI__Edit__0B91BA14]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] ADD  CONSTRAINT [DF_CHITIETCHUYENKHO_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] ADD  CONSTRAINT [DF_CHITIETCHUYENKHO_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] ADD  CONSTRAINT [DF_CHITIETCHUYENKHO_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETGOPBAN] ADD  CONSTRAINT [DF__CHITIETGO__Visua__3587F3E0]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETGOPBAN] ADD  CONSTRAINT [DF__CHITIETGO__Delet__367C1819]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETGOPBAN] ADD  CONSTRAINT [DF__CHITIETGOP__Edit__37703C52]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETHUKHO] ADD  CONSTRAINT [DF_CHITIETHUKHO_DonViTinh]  DEFAULT ((0)) FOR [DonViTinh]
GO
ALTER TABLE [dbo].[CHITIETHUKHO] ADD  CONSTRAINT [DF_CHITIETHUKHO_SoLuong]  DEFAULT ((0)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[CHITIETHUKHO] ADD  CONSTRAINT [DF_CHITIETHUKHO_Gia]  DEFAULT ((0)) FOR [Gia]
GO
ALTER TABLE [dbo].[CHITIETHUKHO] ADD  CONSTRAINT [DF__CHITIETHU__Visua__0F624AF8]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETHUKHO] ADD  CONSTRAINT [DF__CHITIETHU__Delet__10566F31]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETHUKHO] ADD  CONSTRAINT [DF__CHITIETHUK__Edit__114A936A]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_SoLuong]  DEFAULT ((0)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_GiaBan]  DEFAULT ((0)) FOR [GiaBan]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_ThanhTien]  DEFAULT ((0)) FOR [ThanhTien]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_TrangThai]  DEFAULT ((0)) FOR [TrangThai]
GO
ALTER TABLE [dbo].[CHITIETMATKHO] ADD  CONSTRAINT [DF_CHITIETMATKHO_Gia]  DEFAULT ((0)) FOR [Gia]
GO
ALTER TABLE [dbo].[CHITIETMATKHO] ADD  CONSTRAINT [DF__CHITIETMA__Visua__4B7734FF]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETMATKHO] ADD  CONSTRAINT [DF__CHITIETMA__Delet__4C6B5938]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETMATKHO] ADD  CONSTRAINT [DF__CHITIETMAT__Edit__4D5F7D71]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO] ADD  CONSTRAINT [DF__CHITIETNH__Visua__0D7A0286]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO] ADD  CONSTRAINT [DF__CHITIETNH__Delet__0E6E26BF]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO] ADD  CONSTRAINT [DF__CHITIETNHA__Edit__0F624AF8]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF_CHITIETQUYEN_NhomChucNangID]  DEFAULT ((0)) FOR [NhomChucNangID]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF_CHITIETQUYEN_ChoPhep]  DEFAULT ((0)) FOR [ChoPhep]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF_CHITIETQUYEN_DangNhap]  DEFAULT ((0)) FOR [DangNhap]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF_CHITIETQUYEN_Them]  DEFAULT ((0)) FOR [Them]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF_CHITIETQUYEN_Xoa]  DEFAULT ((0)) FOR [Xoa]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF_CHITIETQUYEN_Sua]  DEFAULT ((0)) FOR [Sua]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF__CHITIETQUY__Edit__10566F31]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF__CHITIETQU__Visua__114A936A]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETQUYEN] ADD  CONSTRAINT [DF__CHITIETQU__Delet__123EB7A3]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETTACHBAN] ADD  CONSTRAINT [DF__CHITIETTA__Visua__6166761E]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETTACHBAN] ADD  CONSTRAINT [DF__CHITIETTA__Delet__625A9A57]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETTACHBAN] ADD  CONSTRAINT [DF__CHITIETTAC__Edit__634EBE90]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF_CHUCNANG_ChoPhep]  DEFAULT ((0)) FOR [ChoPhep]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF_CHUCNANG_DangNhap]  DEFAULT ((0)) FOR [DangNhap]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF_CHUCNANG_Them]  DEFAULT ((0)) FOR [Them]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF_CHUCNANG_Xoa]  DEFAULT ((0)) FOR [Xoa]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF_CHUCNANG_Sua]  DEFAULT ((0)) FOR [Sua]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF__CHUCNANG__Visual__160F4887]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF__CHUCNANG__Delete__17036CC0]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHUCNANG] ADD  CONSTRAINT [DF__CHUCNANG__Edit__17F790F9]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHUYENBAN] ADD  CONSTRAINT [DF__CHUYENBAN__Visua__6CD828CA]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHUYENBAN] ADD  CONSTRAINT [DF__CHUYENBAN__Delet__6DCC4D03]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHUYENBAN] ADD  CONSTRAINT [DF__CHUYENBAN__Edit__6EC0713C]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHUYENKHO] ADD  CONSTRAINT [DF__CHUYENKHO__Visua__72910220]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHUYENKHO] ADD  CONSTRAINT [DF__CHUYENKHO__Delet__73852659]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHUYENKHO] ADD  CONSTRAINT [DF__CHUYENKHO__Edit__74794A92]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[DINHLUONG] ADD  CONSTRAINT [DF_DINHLUONG_KichThuocBan]  DEFAULT ((0)) FOR [KichThuocBan]
GO
ALTER TABLE [dbo].[DINHLUONG] ADD  CONSTRAINT [DF_DINHLUONG_SoLuong]  DEFAULT ((0)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[DINHLUONG] ADD  CONSTRAINT [DF__DINHLUONG__Visua__1EA48E88]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[DINHLUONG] ADD  CONSTRAINT [DF__DINHLUONG__Delet__1F98B2C1]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[DINHLUONG] ADD  CONSTRAINT [DF__DINHLUONG__Edit__208CD6FA]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[DONVI] ADD  CONSTRAINT [DF_DONVI_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[DONVI] ADD  CONSTRAINT [DF_DONVI_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[DONVI] ADD  CONSTRAINT [DF_DONVI_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[GIAODIENCHUCNANGBANHANG] ADD  CONSTRAINT [DF__GIAODIENC__Visua__30C33EC3]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[GIAODIENCHUCNANGBANHANG] ADD  CONSTRAINT [DF__GIAODIENC__Delet__31B762FC]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[GIAODIENCHUCNANGBANHANG] ADD  CONSTRAINT [DF__GIAODIENCH__Edit__32AB8735]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[GOPBAN] ADD  CONSTRAINT [DF__GOPBAN__Visual__0697FACD]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[GOPBAN] ADD  CONSTRAINT [DF__GOPBAN__Deleted__078C1F06]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[GOPBAN] ADD  CONSTRAINT [DF__GOPBAN__Edit__0880433F]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] ADD  CONSTRAINT [DF__HOPDUNGTI__Visua__27F8EE98]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] ADD  CONSTRAINT [DF__HOPDUNGTI__Delet__28ED12D1]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] ADD  CONSTRAINT [DF__HOPDUNGTIE__Edit__29E1370A]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[HUKHO] ADD  CONSTRAINT [DF_HUKHO_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[HUKHO] ADD  CONSTRAINT [DF__HUKHO__Visual__1209AD79]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[HUKHO] ADD  CONSTRAINT [DF__HUKHO__Deleted__12FDD1B2]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[HUKHO] ADD  CONSTRAINT [DF__HUKHO__Edit__13F1F5EB]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[HUYHOADON] ADD  CONSTRAINT [DF_HUYHOADON_BanHangID]  DEFAULT ((0)) FOR [BanHangID]
GO
ALTER TABLE [dbo].[HUYHOADON] ADD  CONSTRAINT [DF_HUYHOADON_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[HUYHOADON] ADD  CONSTRAINT [DF__HUYHOADON__Visua__251C81ED]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[HUYHOADON] ADD  CONSTRAINT [DF__HUYHOADON__Delet__2610A626]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[HUYHOADON] ADD  CONSTRAINT [DF__HUYHOADON__Edit__2704CA5F]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[INHOADON] ADD  CONSTRAINT [DF_INHOADON_BanHangID]  DEFAULT ((0)) FOR [BanHangID]
GO
ALTER TABLE [dbo].[INHOADON] ADD  CONSTRAINT [DF_INHOADON_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[INHOADON] ADD  CONSTRAINT [DF_INHOADON_MayInID]  DEFAULT ((0)) FOR [MayInID]
GO
ALTER TABLE [dbo].[INHOADON] ADD  CONSTRAINT [DF__INHOADON__Visual__1C873BEC]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[INHOADON] ADD  CONSTRAINT [DF__INHOADON__Delete__1D7B6025]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[INHOADON] ADD  CONSTRAINT [DF__INHOADON__Edit__1E6F845E]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [DF_KHACHHANG_LoaiKhachHangID]  DEFAULT ((0)) FOR [LoaiKhachHangID]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [DF_KHACHHANG_DuNo]  DEFAULT ((0)) FOR [DuNo]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [DF_KHACHHANG_DuNoToiThieu]  DEFAULT ((0)) FOR [DuNoToiThieu]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [DF_KHACHHANG_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [DF_KHACHHANG_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[KHACHHANG] ADD  CONSTRAINT [DF__KHACHHANG__Edit__24285DB4]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[KHO] ADD  CONSTRAINT [DF__STOCKWAREH__Name__534D60F1]  DEFAULT ('') FOR [TenKho]
GO
ALTER TABLE [dbo].[KHO] ADD  CONSTRAINT [DF__STOCKWARE__Visua__5441852A]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[KHO] ADD  CONSTRAINT [DF__STOCKWARE__Delet__5535A963]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[KHO] ADD  CONSTRAINT [DF__KHO__Edit__27F8EE98]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[KHU] ADD  CONSTRAINT [DF_KHU_LoaiGiaID]  DEFAULT ((0)) FOR [LoaiGiaID]
GO
ALTER TABLE [dbo].[KHU] ADD  CONSTRAINT [DF_KHU_MacDinhSoDoBan]  DEFAULT ((0)) FOR [MacDinhSoDoBan]
GO
ALTER TABLE [dbo].[KHU] ADD  CONSTRAINT [DF_KHU_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[KHU] ADD  CONSTRAINT [DF_KHU_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[KHU] ADD  CONSTRAINT [DF__KHU__Edit__3335971A]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_LoaiGiaID]  DEFAULT ((0)) FOR [LoaiGiaID]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_TheLoaiID]  DEFAULT ((0)) FOR [TheLoaiID]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_UuTien]  DEFAULT ((0)) FOR [UuTien]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_GiaTriBatDau]  DEFAULT ((0)) FOR [GiaTriBatDau]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_GiaTriKetThuc]  DEFAULT ((0)) FOR [GiaTriKetThuc]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF_LICHBIEUDINHKY_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] ADD  CONSTRAINT [DF__LICHBIEUDI__Edit__345EC57D]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY] ADD  CONSTRAINT [DF_LICHBIEUKHONGDINHKY_LoaiGiaID]  DEFAULT ((0)) FOR [LoaiGiaID]
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY] ADD  CONSTRAINT [DF_LICHBIEUKHONGDINHKY_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY] ADD  CONSTRAINT [DF_LICHBIEUKHONGDINHKY_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY] ADD  CONSTRAINT [DF__LICHBIEUKH__Edit__37FA4C37]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LICHSUBANHANG] ADD  CONSTRAINT [DF_LICHSUBANHANG_BanHangID]  DEFAULT ((0)) FOR [BanHangID]
GO
ALTER TABLE [dbo].[LICHSUBANHANG] ADD  CONSTRAINT [DF_LICHSUBANHANG_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[LICHSUBANHANG] ADD  CONSTRAINT [DF_LICHSUBANHANG_InNhaBep]  DEFAULT ((0)) FOR [InNhaBep]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_KhachHangID]  DEFAULT ((0)) FOR [KhachHangID]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_SoTienPhatSinh]  DEFAULT ((0)) FOR [SoTienPhatSinh]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_TienMat]  DEFAULT ((0)) FOR [TienMat]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_TienThe]  DEFAULT ((0)) FOR [TienThe]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_TheID]  DEFAULT ((0)) FOR [TheID]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_BanHangID]  DEFAULT ((0)) FOR [BanHangID]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF_LICHSUCONGNO_DuNoCuoi]  DEFAULT ((0)) FOR [DuNoCuoi]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF__LICHSUCON__Visua__42ACE4D4]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF__LICHSUCON__Delet__43A1090D]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LICHSUCONGNO] ADD  CONSTRAINT [DF__LICHSUCONG__Edit__44952D46]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LICHSUDANGNHAP] ADD  CONSTRAINT [DF_LICHSUDANGNHAP_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[LICHSUDANGNHAP] ADD  CONSTRAINT [DF__LICHSUDAN__Visua__1C873BEC]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LICHSUDANGNHAP] ADD  CONSTRAINT [DF__LICHSUDAN__Delet__1D7B6025]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LICHSUDANGNHAP] ADD  CONSTRAINT [DF__LICHSUDANG__Edit__1E6F845E]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAIBAN] ADD  CONSTRAINT [DF__LOAIBAN__TenLoai__41EDCAC5]  DEFAULT ('') FOR [TenLoaiBan]
GO
ALTER TABLE [dbo].[LOAIBAN] ADD  CONSTRAINT [DF_LOAIBAN_KichThuocBan]  DEFAULT ((0)) FOR [KichThuocBan]
GO
ALTER TABLE [dbo].[LOAIBAN] ADD  CONSTRAINT [DF_LOAIBAN_DonViID]  DEFAULT ((0)) FOR [DonViID]
GO
ALTER TABLE [dbo].[LOAIBAN] ADD  CONSTRAINT [DF__LOAIBAN__Visual__42E1EEFE]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LOAIBAN] ADD  CONSTRAINT [DF__LOAIBAN__Deleted__43D61337]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LOAIBAN] ADD  CONSTRAINT [DF__LOAIBAN__Edit__44CA3770]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAIHOPDUNGTIEN] ADD  CONSTRAINT [DF__LOAIHOPDU__Visua__4F12BBB9]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LOAIHOPDUNGTIEN] ADD  CONSTRAINT [DF__LOAIHOPDU__Delet__5006DFF2]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LOAIHOPDUNGTIEN] ADD  CONSTRAINT [DF__LOAIHOPDUN__Edit__50FB042B]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAIKHACHHANG] ADD  CONSTRAINT [DF_LOAIKHACHHANG_PhanTramGiamGia]  DEFAULT ((0)) FOR [PhanTramGiamGia]
GO
ALTER TABLE [dbo].[LOAIKHACHHANG] ADD  CONSTRAINT [DF_LOAIKHACHHANG_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LOAIKHACHHANG] ADD  CONSTRAINT [DF_LOAIKHACHHANG_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LOAIKHACHHANG] ADD  CONSTRAINT [DF__LOAIKHACHH__Edit__54CB950F]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAILICHBIEU] ADD  CONSTRAINT [DF_LOAILICHBIEU_TheLoaiID]  DEFAULT ((0)) FOR [TheLoaiID]
GO
ALTER TABLE [dbo].[LOAILICHBIEU] ADD  CONSTRAINT [DF_LOAILICHBIEU_GiaTri]  DEFAULT ((0)) FOR [GiaTri]
GO
ALTER TABLE [dbo].[LOAILICHBIEU] ADD  CONSTRAINT [DF__LOAILICHB__Visua__57A801BA]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LOAILICHBIEU] ADD  CONSTRAINT [DF__LOAILICHB__Delet__589C25F3]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LOAILICHBIEU] ADD  CONSTRAINT [DF__LOAILICHBI__Edit__59904A2C]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAINHANVIEN] ADD  CONSTRAINT [DF_LOAINHANVIEN_CapDo]  DEFAULT ((0)) FOR [CapDo]
GO
ALTER TABLE [dbo].[LOAINHANVIEN] ADD  CONSTRAINT [DF_LOAINHANVIEN_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAIPHATSINH] ADD  CONSTRAINT [DF__LOAIPHATS__Visua__5B78929E]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LOAIPHATSINH] ADD  CONSTRAINT [DF__LOAIPHATS__Delet__5C6CB6D7]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LOAIPHATSINH] ADD  CONSTRAINT [DF__LOAIPHATSI__Edit__5D60DB10]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[LOAITHONGTIN] ADD  CONSTRAINT [DF__LOAITHONG__Visua__5E54FF49]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[LOAITHONGTIN] ADD  CONSTRAINT [DF__LOAITHONG__Delet__5F492382]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[LOAITHONGTIN] ADD  CONSTRAINT [DF__LOAITHONGT__Edit__603D47BB]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MATKHO] ADD  CONSTRAINT [DF_MATKHO_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[MATKHO] ADD  CONSTRAINT [DF_MATKHO_KhoID]  DEFAULT ((0)) FOR [KhoID]
GO
ALTER TABLE [dbo].[MATKHO] ADD  CONSTRAINT [DF_MATKHO_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[MATKHO] ADD  CONSTRAINT [DF__MATKHO__Visual__640DD89F]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MATKHO] ADD  CONSTRAINT [DF__MATKHO__Deleted__6501FCD8]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MATKHO] ADD  CONSTRAINT [DF__MATKHO__Edit__65F62111]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MAYIN] ADD  CONSTRAINT [DF_MAYIN_HopDungTien]  DEFAULT ((0)) FOR [HopDungTien]
GO
ALTER TABLE [dbo].[MAYIN] ADD  CONSTRAINT [DF_MAYIN_SoLanIn]  DEFAULT ((1)) FOR [SoLanIn]
GO
ALTER TABLE [dbo].[MAYIN] ADD  CONSTRAINT [DF_MAYIN_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MAYIN] ADD  CONSTRAINT [DF_MAYIN_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MAYIN] ADD  CONSTRAINT [DF__MAYIN__Edit__6ABAD62E]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MAYIN] ADD  CONSTRAINT [DF_MAYIN_MayInHoaDon]  DEFAULT ((0)) FOR [MayInHoaDon]
GO
ALTER TABLE [dbo].[MENUGIA] ADD  CONSTRAINT [DF__MENUPRICE__ItemI__4E88ABD4]  DEFAULT ((0)) FOR [KichThuocMonID]
GO
ALTER TABLE [dbo].[MENUGIA] ADD  CONSTRAINT [DF__MENUPRICE__UnitP__4F7CD00D]  DEFAULT ((0)) FOR [Gia]
GO
ALTER TABLE [dbo].[MENUGIA] ADD  CONSTRAINT [DF__MENUPRICE__Price__5070F446]  DEFAULT ((0)) FOR [LoaiGiaID]
GO
ALTER TABLE [dbo].[MENUITEMMAYIN] ADD  CONSTRAINT [DF_MENUITEMMAYIN_MayInID]  DEFAULT ((0)) FOR [MayInID]
GO
ALTER TABLE [dbo].[MENUITEMMAYIN] ADD  CONSTRAINT [DF_MENUITEMMAYIN_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENUITEMMAYIN] ADD  CONSTRAINT [DF_MENUITEMMAYIN_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENUITEMMAYIN] ADD  CONSTRAINT [DF_MENUITEMMAYIN_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] ADD  CONSTRAINT [DF_MENUKHUYENMAI_KichThuocMonID]  DEFAULT ((0)) FOR [KichThuocMonID]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] ADD  CONSTRAINT [DF_MENUKHUYENMAI_KichThuocMonTang]  DEFAULT ((0)) FOR [KichThuocMonTang]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] ADD  CONSTRAINT [DF_MENUKHUYENMAI_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] ADD  CONSTRAINT [DF_MENUKHUYENMAI_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] ADD  CONSTRAINT [DF__MENUKHUYEN__Edit__671F4F74]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_MonID]  DEFAULT ((0)) FOR [MonID]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_LoaiBanID]  DEFAULT ((0)) FOR [LoaiBanID]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_DonVi]  DEFAULT ((0)) FOR [DonVi]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_GiaBanMacDinh]  DEFAULT ((0)) FOR [GiaBanMacDinh]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_ThoiGia]  DEFAULT ((0)) FOR [ThoiGia]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_KichThuocLoaiBan]  DEFAULT ((0)) FOR [KichThuocLoaiBan]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_SoLuongBanBan]  DEFAULT ((0)) FOR [SoLuongBanBan]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_TonKhoToiThieu]  DEFAULT ((0)) FOR [TonKhoToiThieu]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_TonKhoToiDa]  DEFAULT ((0)) FOR [TonKhoToiDa]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF__MENUKICHTH__Edit__69FBBC1F]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_SapXep]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[MENULOAIGIA] ADD  CONSTRAINT [DF_MENULOAIGIA_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENULOAIGIA] ADD  CONSTRAINT [DF_MENULOAIGIA_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENULOAIGIA] ADD  CONSTRAINT [DF__MENULOAIGI__Edit__038683F8]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENULOAINHOM] ADD  CONSTRAINT [DF_MENULOAINHOM_SapXepNhom]  DEFAULT ((0)) FOR [SapXepNhom]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__NameSh__3D5E1FD2]  DEFAULT ('') FOR [TenNgan]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__NameDe__3E52440B]  DEFAULT ('') FOR [TenDai]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__GroupI__3F466844]  DEFAULT ((0)) FOR [NhomID]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__PriceA__403A8C7D]  DEFAULT ((0)) FOR [Gia]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__GST__4222D4EF]  DEFAULT ((0)) FOR [GST]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Printe__44FF419A]  DEFAULT ((0)) FOR [MayIn]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Displa__45F365D3]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_SapXepKichThuocMon]  DEFAULT ((0)) FOR [SapXepKichThuocMon]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Discou__46E78A0C]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Bitmap__47DBAE45]  DEFAULT ('') FOR [Hinh]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_SoLuongKichThuocMon]  DEFAULT ((0)) FOR [SoLuongKichThuocMon]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Visual__48CFD27E]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Delete__49C3F6B7]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__NameS__300424B4]  DEFAULT ('') FOR [TenNgan]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__NameD__30F848ED]  DEFAULT ('') FOR [TenDai]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Group__31EC6D26]  DEFAULT ((0)) FOR [LoaiNhomID]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Print__32E0915F]  DEFAULT ((0)) FOR [MayIn]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Displ__33D4B598]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF_MENUNHOM_SapXepMon]  DEFAULT ((0)) FOR [SapXepMon]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Disco__34C8D9D1]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Bitma__35BCFE0A]  DEFAULT ('') FOR [Hinh]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF_MENUNHOM_SoLuongMon]  DEFAULT ((0)) FOR [SoLuongMon]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Visua__36B12243]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Delet__37A5467C]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[NHACUNGCAP] ADD  CONSTRAINT [DF_NHACUNGCAP_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[NHACUNGCAP] ADD  CONSTRAINT [DF_NHACUNGCAP_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[NHACUNGCAP] ADD  CONSTRAINT [DF__NHACUNGCAP__Edit__1C5231C2]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [DF_NHANVIEN_LoaiNhanVienID]  DEFAULT ((0)) FOR [LoaiNhanVienID]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [DF_NHANVIEN_CapDo]  DEFAULT ((0)) FOR [CapDo]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [DF_NHANVIEN_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [DF_NHANVIEN_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [DF_NHANVIEN_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  CONSTRAINT [DF_NHAPKHO_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  CONSTRAINT [DF_NHAPKHO_KhoID]  DEFAULT ((0)) FOR [KhoID]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  CONSTRAINT [DF_NHAPKHO_NhaCungCapID]  DEFAULT ((0)) FOR [NhaCungCapID]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  CONSTRAINT [DF__NHAPKHO__Visual__23F3538A]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  CONSTRAINT [DF__NHAPKHO__Deleted__24E777C3]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[NHAPKHO] ADD  CONSTRAINT [DF__NHAPKHO__Edit__25DB9BFC]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[NHOMCHUCNANG] ADD  CONSTRAINT [DF_NHOMCHUCNANG_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[NHOMCHUCNANG] ADD  CONSTRAINT [DF_NHOMCHUCNANG_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[NHOMCHUCNANG] ADD  CONSTRAINT [DF__NHOMCHUCNA__Edit__28B808A7]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[QUYEN] ADD  CONSTRAINT [DF_QUYEN_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[QUYEN] ADD  CONSTRAINT [DF_QUYEN_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[QUYEN] ADD  CONSTRAINT [DF__QUYEN__Edit__2A164134]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] ADD  CONSTRAINT [DF_QUYENNHANVIEN_QuyenID]  DEFAULT ((0)) FOR [QuyenID]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] ADD  CONSTRAINT [DF_QUYENNHANVIEN_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] ADD  CONSTRAINT [DF__QUYENNHANV__Edit__2E70E1FD]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] ADD  CONSTRAINT [DF__QUYENNHAN__Visua__2F650636]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] ADD  CONSTRAINT [DF__QUYENNHAN__Delet__30592A6F]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF_TACHBAN_NhanVienID]  DEFAULT ((0)) FOR [NhanVienID]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF_TACHBAN_BanID]  DEFAULT ((0)) FOR [BanID]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF__TACHBAN__Visual__3335971A]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF__TACHBAN__Deleted__3429BB53]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF__TACHBAN__Edit__351DDF8C]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[THAMSO] ADD  CONSTRAINT [DF_THAMSO_SoMay]  DEFAULT ((0)) FOR [SoMay]
GO
ALTER TABLE [dbo].[THAMSO] ADD  CONSTRAINT [DF_THAMSO_MayInHoaDon]  DEFAULT ((0)) FOR [MayInHoaDon]
GO
ALTER TABLE [dbo].[THE] ADD  CONSTRAINT [DF_THE_ChietKhau]  DEFAULT ((0)) FOR [ChietKhau]
GO
ALTER TABLE [dbo].[THE] ADD  CONSTRAINT [DF__THE__Visual__7C1A6C5A]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[THE] ADD  CONSTRAINT [DF__THE__Deleted__7D0E9093]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[THE] ADD  CONSTRAINT [DF__THE__Edit__7E02B4CC]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[THELOAILICHBIEU] ADD  CONSTRAINT [DF__THELOAILI__Visua__3BCADD1B]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[THELOAILICHBIEU] ADD  CONSTRAINT [DF__THELOAILI__Delet__3CBF0154]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[THELOAILICHBIEU] ADD  CONSTRAINT [DF__THELOAILIC__Edit__3DB3258D]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[THONGTIN] ADD  CONSTRAINT [DF_THONGTIN_SapXep]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[THONGTIN] ADD  CONSTRAINT [DF_THONGTIN_LoaiThongTinID]  DEFAULT ((0)) FOR [LoaiThongTinID]
GO
ALTER TABLE [dbo].[THONGTIN] ADD  CONSTRAINT [DF__THONGTIN__Visual__408F9238]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[THONGTIN] ADD  CONSTRAINT [DF__THONGTIN__Delete__4183B671]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[THONGTIN] ADD  CONSTRAINT [DF__THONGTIN__Edit__4277DAAA]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_KhoID]  DEFAULT ((0)) FOR [KhoID]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_MonID]  DEFAULT ((0)) FOR [MonID]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_LoaiBanID]  DEFAULT ((0)) FOR [LoaiBanID]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_DonViID]  DEFAULT ((0)) FOR [DonViID]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_DonViTinh]  DEFAULT ((0)) FOR [DonViTinh]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_PhatSinhTuTonKhoID]  DEFAULT ((0)) FOR [PhatSinhTuTonKhoID]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_SoLuongNhap]  DEFAULT ((0)) FOR [SoLuongNhap]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_SoLuongTon]  DEFAULT ((0)) FOR [SoLuongTon]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_GiaMua]  DEFAULT ((0)) FOR [GiaBan]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_GiaNhap]  DEFAULT ((0)) FOR [GiaNhap]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_LoaiPhatSinhID]  DEFAULT ((0)) FOR [LoaiPhatSinhID]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF_TONKHO_SoLuongPhatSinh]  DEFAULT ((0)) FOR [SoLuongPhatSinh]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF__TONKHO__Visual__04AFB25B]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF__TONKHO__Deleted__05A3D694]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[TONKHO] ADD  CONSTRAINT [DF__TONKHO__Edit__0697FACD]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongTon]  DEFAULT ((0)) FOR [SoLuongTon]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongBan]  DEFAULT ((0)) FOR [SoLuongBan]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongNhap]  DEFAULT ((0)) FOR [SoLuongNhap]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongHu]  DEFAULT ((0)) FOR [SoLuongHu]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongDieuChinh]  DEFAULT ((0)) FOR [SoLuongDieuChinh]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongMat]  DEFAULT ((0)) FOR [SoLuongMat]
GO
ALTER TABLE [dbo].[TRANGTHAI] ADD  CONSTRAINT [DF__TRANGTHAI__Visua__5772F790]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[TRANGTHAI] ADD  CONSTRAINT [DF__TRANGTHAI__Delet__58671BC9]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[TRANGTHAI] ADD  CONSTRAINT [DF__TRANGTHAI__Edit__595B4002]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[BAN]  WITH CHECK ADD  CONSTRAINT [FK_BAN_KHU] FOREIGN KEY([KhuID])
REFERENCES [dbo].[KHU] ([KhuID])
GO
ALTER TABLE [dbo].[BAN] CHECK CONSTRAINT [FK_BAN_KHU]
GO
ALTER TABLE [dbo].[BANHANG]  WITH CHECK ADD  CONSTRAINT [FK_BANHANG_BAN] FOREIGN KEY([BanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[BANHANG] CHECK CONSTRAINT [FK_BANHANG_BAN]
GO
ALTER TABLE [dbo].[BANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_BANHANG_KHACHHANG] FOREIGN KEY([KhachHangID])
REFERENCES [dbo].[KHACHHANG] ([KhachHangID])
GO
ALTER TABLE [dbo].[BANHANG] CHECK CONSTRAINT [FK_BANHANG_KHACHHANG]
GO
ALTER TABLE [dbo].[BANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_BANHANG_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[BANHANG] CHECK CONSTRAINT [FK_BANHANG_NHANVIEN]
GO
ALTER TABLE [dbo].[BANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_BANHANG_THE] FOREIGN KEY([TheID])
REFERENCES [dbo].[THE] ([TheID])
GO
ALTER TABLE [dbo].[BANHANG] CHECK CONSTRAINT [FK_BANHANG_THE]
GO
ALTER TABLE [dbo].[BANHANG]  WITH CHECK ADD  CONSTRAINT [FK_BANHANG_TRANGTHAI] FOREIGN KEY([TrangThaiID])
REFERENCES [dbo].[TRANGTHAI] ([TrangThaiID])
GO
ALTER TABLE [dbo].[BANHANG] CHECK CONSTRAINT [FK_BANHANG_TRANGTHAI]
GO
ALTER TABLE [dbo].[CHINHKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHINHKHO_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[CHINHKHO] CHECK CONSTRAINT [FK_CHINHKHO_KHO]
GO
ALTER TABLE [dbo].[CHINHKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_CHINHKHO_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[CHINHKHO] CHECK CONSTRAINT [FK_CHINHKHO_NHANVIEN]
GO
ALTER TABLE [dbo].[CHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETBANHANG_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[CHITIETBANHANG] CHECK CONSTRAINT [FK_CHITIETBANHANG_BANHANG]
GO
ALTER TABLE [dbo].[CHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETBANHANG_MENUKICHTHUOCMON] FOREIGN KEY([KichThuocMonID])
REFERENCES [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID])
GO
ALTER TABLE [dbo].[CHITIETBANHANG] CHECK CONSTRAINT [FK_CHITIETBANHANG_MENUKICHTHUOCMON]
GO
ALTER TABLE [dbo].[CHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETBANHANG_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[CHITIETBANHANG] CHECK CONSTRAINT [FK_CHITIETBANHANG_NHANVIEN]
GO
ALTER TABLE [dbo].[CHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETBANHANG_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETBANHANG] CHECK CONSTRAINT [FK_CHITIETBANHANG_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETCHINHKHO_CHINHKHO] FOREIGN KEY([ChinhKhoID])
REFERENCES [dbo].[CHINHKHO] ([ChinhKhoID])
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO] CHECK CONSTRAINT [FK_CHITIETCHINHKHO_CHINHKHO]
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETCHINHKHO_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETCHINHKHO] CHECK CONSTRAINT [FK_CHITIETCHINHKHO_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETCHUYENKHO_CHUYENKHO] FOREIGN KEY([ChuyenKhoID])
REFERENCES [dbo].[CHUYENKHO] ([ChuyenKhoID])
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] CHECK CONSTRAINT [FK_CHITIETCHUYENKHO_CHUYENKHO]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETCHUYENKHO_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] CHECK CONSTRAINT [FK_CHITIETCHUYENKHO_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETGOPBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETGOPBAN_BAN] FOREIGN KEY([BanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[CHITIETGOPBAN] CHECK CONSTRAINT [FK_CHITIETGOPBAN_BAN]
GO
ALTER TABLE [dbo].[CHITIETGOPBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETGOPBAN_GOPBAN] FOREIGN KEY([GopBanID])
REFERENCES [dbo].[GOPBAN] ([GopBanID])
GO
ALTER TABLE [dbo].[CHITIETGOPBAN] CHECK CONSTRAINT [FK_CHITIETGOPBAN_GOPBAN]
GO
ALTER TABLE [dbo].[CHITIETHUKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETHUKHO_HUKHO] FOREIGN KEY([HuKhoID])
REFERENCES [dbo].[HUKHO] ([HuKhoID])
GO
ALTER TABLE [dbo].[CHITIETHUKHO] CHECK CONSTRAINT [FK_CHITIETHUKHO_HUKHO]
GO
ALTER TABLE [dbo].[CHITIETHUKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETHUKHO_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETHUKHO] CHECK CONSTRAINT [FK_CHITIETHUKHO_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_CHITIETLICHSUBANHANG_LICHSUBANHANG] FOREIGN KEY([LichSuBanHangID])
REFERENCES [dbo].[LICHSUBANHANG] ([LichSuBanHangID])
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] CHECK CONSTRAINT [FK_CHITIETLICHSUBANHANG_LICHSUBANHANG]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_CHITIETLICHSUBANHANG_MENUKICHTHUOCMON] FOREIGN KEY([KichThuocMonID])
REFERENCES [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID])
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] CHECK CONSTRAINT [FK_CHITIETLICHSUBANHANG_MENUKICHTHUOCMON]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETLICHSUBANHANG_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] CHECK CONSTRAINT [FK_CHITIETLICHSUBANHANG_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETMATKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETMATKHO_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETMATKHO] CHECK CONSTRAINT [FK_CHITIETMATKHO_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETNHAPKHO_NHAPKHO] FOREIGN KEY([NhapKhoID])
REFERENCES [dbo].[NHAPKHO] ([NhapKhoID])
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO] CHECK CONSTRAINT [FK_CHITIETNHAPKHO_NHAPKHO]
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETNHAPKHO_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[CHITIETNHAPKHO] CHECK CONSTRAINT [FK_CHITIETNHAPKHO_TONKHO]
GO
ALTER TABLE [dbo].[CHITIETQUYEN]  WITH NOCHECK ADD  CONSTRAINT [FK_CHITIETQUYEN_CHUCNANG] FOREIGN KEY([ChucNangID])
REFERENCES [dbo].[CHUCNANG] ([ChucNangID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[CHITIETQUYEN] NOCHECK CONSTRAINT [FK_CHITIETQUYEN_CHUCNANG]
GO
ALTER TABLE [dbo].[CHITIETQUYEN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETQUYEN_QUYEN] FOREIGN KEY([QuyenID])
REFERENCES [dbo].[QUYEN] ([MaQuyen])
GO
ALTER TABLE [dbo].[CHITIETQUYEN] CHECK CONSTRAINT [FK_CHITIETQUYEN_QUYEN]
GO
ALTER TABLE [dbo].[CHITIETTACHBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETTACHBAN_BAN] FOREIGN KEY([BanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[CHITIETTACHBAN] CHECK CONSTRAINT [FK_CHITIETTACHBAN_BAN]
GO
ALTER TABLE [dbo].[CHITIETTACHBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETTACHBAN_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[CHITIETTACHBAN] CHECK CONSTRAINT [FK_CHITIETTACHBAN_BANHANG]
GO
ALTER TABLE [dbo].[CHITIETTACHBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETTACHBAN_TACHBAN] FOREIGN KEY([TachBanID])
REFERENCES [dbo].[TACHBAN] ([TachBanID])
GO
ALTER TABLE [dbo].[CHITIETTACHBAN] CHECK CONSTRAINT [FK_CHITIETTACHBAN_TACHBAN]
GO
ALTER TABLE [dbo].[CHUCNANG]  WITH CHECK ADD  CONSTRAINT [FK_CHUCNANG_NHOMCHUCNANG] FOREIGN KEY([NhomChucNangID])
REFERENCES [dbo].[NHOMCHUCNANG] ([NhomChucNangID])
GO
ALTER TABLE [dbo].[CHUCNANG] CHECK CONSTRAINT [FK_CHUCNANG_NHOMCHUCNANG]
GO
ALTER TABLE [dbo].[CHUYENBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENBAN_BAN] FOREIGN KEY([TuBanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[CHUYENBAN] CHECK CONSTRAINT [FK_CHUYENBAN_BAN]
GO
ALTER TABLE [dbo].[CHUYENBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENBAN_BAN1] FOREIGN KEY([DenBanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[CHUYENBAN] CHECK CONSTRAINT [FK_CHUYENBAN_BAN1]
GO
ALTER TABLE [dbo].[CHUYENBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENBAN_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[CHUYENBAN] CHECK CONSTRAINT [FK_CHUYENBAN_NHANVIEN]
GO
ALTER TABLE [dbo].[CHUYENKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENKHO_KHO] FOREIGN KEY([KhoDiID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[CHUYENKHO] CHECK CONSTRAINT [FK_CHUYENKHO_KHO]
GO
ALTER TABLE [dbo].[CHUYENKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENKHO_KHO1] FOREIGN KEY([KhoDenID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[CHUYENKHO] CHECK CONSTRAINT [FK_CHUYENKHO_KHO1]
GO
ALTER TABLE [dbo].[CHUYENKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_CHUYENKHO_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[CHUYENKHO] CHECK CONSTRAINT [FK_CHUYENKHO_NHANVIEN]
GO
ALTER TABLE [dbo].[DINHLUONG]  WITH CHECK ADD  CONSTRAINT [FK_DINHLUONG_LOAIBAN] FOREIGN KEY([LoaiBanID])
REFERENCES [dbo].[LOAIBAN] ([LoaiBanID])
GO
ALTER TABLE [dbo].[DINHLUONG] CHECK CONSTRAINT [FK_DINHLUONG_LOAIBAN]
GO
ALTER TABLE [dbo].[DINHLUONG]  WITH CHECK ADD  CONSTRAINT [FK_DINHLUONG_MENUKICHTHUOCMON] FOREIGN KEY([KichThuocMonChinhID])
REFERENCES [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID])
GO
ALTER TABLE [dbo].[DINHLUONG] CHECK CONSTRAINT [FK_DINHLUONG_MENUKICHTHUOCMON]
GO
ALTER TABLE [dbo].[DINHLUONG]  WITH CHECK ADD  CONSTRAINT [FK_DINHLUONG_MENUMON] FOREIGN KEY([MonID])
REFERENCES [dbo].[MENUMON] ([MonID])
GO
ALTER TABLE [dbo].[DINHLUONG] CHECK CONSTRAINT [FK_DINHLUONG_MENUMON]
GO
ALTER TABLE [dbo].[GIAODIENCHUCNANGBANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_GIAODIENCHUCNANGBANHANG_CHUCNANG] FOREIGN KEY([ChucNangID])
REFERENCES [dbo].[CHUCNANG] ([ChucNangID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[GIAODIENCHUCNANGBANHANG] NOCHECK CONSTRAINT [FK_GIAODIENCHUCNANGBANHANG_CHUCNANG]
GO
ALTER TABLE [dbo].[GOPBAN]  WITH CHECK ADD  CONSTRAINT [FK_GOPBAN_BAN] FOREIGN KEY([GopThanhBanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[GOPBAN] CHECK CONSTRAINT [FK_GOPBAN_BAN]
GO
ALTER TABLE [dbo].[GOPBAN]  WITH CHECK ADD  CONSTRAINT [FK_GOPBAN_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[GOPBAN] CHECK CONSTRAINT [FK_GOPBAN_BANHANG]
GO
ALTER TABLE [dbo].[GOPBAN]  WITH CHECK ADD  CONSTRAINT [FK_GOPBAN_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[GOPBAN] CHECK CONSTRAINT [FK_GOPBAN_NHANVIEN]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN]  WITH CHECK ADD  CONSTRAINT [FK_HOPDUNGTIEN_LOAIHOPDUNGTIEN] FOREIGN KEY([LoaiHopDungTienID])
REFERENCES [dbo].[LOAIHOPDUNGTIEN] ([LoaiHopDungTienID])
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] CHECK CONSTRAINT [FK_HOPDUNGTIEN_LOAIHOPDUNGTIEN]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN]  WITH CHECK ADD  CONSTRAINT [FK_HOPDUNGTIEN_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] CHECK CONSTRAINT [FK_HOPDUNGTIEN_NHANVIEN]
GO
ALTER TABLE [dbo].[HUKHO]  WITH CHECK ADD  CONSTRAINT [FK_HUKHO_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[HUKHO] CHECK CONSTRAINT [FK_HUKHO_KHO]
GO
ALTER TABLE [dbo].[HUKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_HUKHO_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[HUKHO] CHECK CONSTRAINT [FK_HUKHO_NHANVIEN]
GO
ALTER TABLE [dbo].[HUYHOADON]  WITH CHECK ADD  CONSTRAINT [FK_HUYHOADON_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[HUYHOADON] CHECK CONSTRAINT [FK_HUYHOADON_BANHANG]
GO
ALTER TABLE [dbo].[HUYHOADON]  WITH CHECK ADD  CONSTRAINT [FK_HUYHOADON_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[HUYHOADON] CHECK CONSTRAINT [FK_HUYHOADON_NHANVIEN]
GO
ALTER TABLE [dbo].[INHOADON]  WITH CHECK ADD  CONSTRAINT [FK_INHOADON_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[INHOADON] CHECK CONSTRAINT [FK_INHOADON_BANHANG]
GO
ALTER TABLE [dbo].[INHOADON]  WITH CHECK ADD  CONSTRAINT [FK_INHOADON_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[INHOADON] CHECK CONSTRAINT [FK_INHOADON_NHANVIEN]
GO
ALTER TABLE [dbo].[KHACHHANG]  WITH CHECK ADD  CONSTRAINT [FK_KHACHHANG_LOAIKHACHHANG] FOREIGN KEY([LoaiKhachHangID])
REFERENCES [dbo].[LOAIKHACHHANG] ([LoaiKhachHangID])
GO
ALTER TABLE [dbo].[KHACHHANG] CHECK CONSTRAINT [FK_KHACHHANG_LOAIKHACHHANG]
GO
ALTER TABLE [dbo].[KHU]  WITH CHECK ADD  CONSTRAINT [FK_GroupTable_MENUPRICETYPE] FOREIGN KEY([LoaiGiaID])
REFERENCES [dbo].[MENULOAIGIA] ([LoaiGiaID])
GO
ALTER TABLE [dbo].[KHU] CHECK CONSTRAINT [FK_GroupTable_MENUPRICETYPE]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY]  WITH CHECK ADD  CONSTRAINT [FK_LICHBIEUDINHKY_MENULOAIGIA] FOREIGN KEY([LoaiGiaID])
REFERENCES [dbo].[MENULOAIGIA] ([LoaiGiaID])
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] CHECK CONSTRAINT [FK_LICHBIEUDINHKY_MENULOAIGIA]
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY]  WITH CHECK ADD  CONSTRAINT [FK_LICHBIEUKHONGDINHKY_MENULOAIGIA] FOREIGN KEY([LoaiGiaID])
REFERENCES [dbo].[MENULOAIGIA] ([LoaiGiaID])
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY] CHECK CONSTRAINT [FK_LICHBIEUKHONGDINHKY_MENULOAIGIA]
GO
ALTER TABLE [dbo].[LICHSUBANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_LICHSUBANHANG_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[LICHSUBANHANG] CHECK CONSTRAINT [FK_LICHSUBANHANG_BANHANG]
GO
ALTER TABLE [dbo].[LICHSUBANHANG]  WITH NOCHECK ADD  CONSTRAINT [FK_LICHSUBANHANG_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[LICHSUBANHANG] CHECK CONSTRAINT [FK_LICHSUBANHANG_NHANVIEN]
GO
ALTER TABLE [dbo].[LICHSUCONGNO]  WITH CHECK ADD  CONSTRAINT [FK_LICHSUCONGNO_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[LICHSUCONGNO] CHECK CONSTRAINT [FK_LICHSUCONGNO_BANHANG]
GO
ALTER TABLE [dbo].[LICHSUCONGNO]  WITH NOCHECK ADD  CONSTRAINT [FK_LICHSUCONGNO_KHACHHANG] FOREIGN KEY([KhachHangID])
REFERENCES [dbo].[KHACHHANG] ([KhachHangID])
GO
ALTER TABLE [dbo].[LICHSUCONGNO] CHECK CONSTRAINT [FK_LICHSUCONGNO_KHACHHANG]
GO
ALTER TABLE [dbo].[LICHSUCONGNO]  WITH CHECK ADD  CONSTRAINT [FK_LICHSUCONGNO_THE] FOREIGN KEY([TheID])
REFERENCES [dbo].[THE] ([TheID])
GO
ALTER TABLE [dbo].[LICHSUCONGNO] CHECK CONSTRAINT [FK_LICHSUCONGNO_THE]
GO
ALTER TABLE [dbo].[LICHSUDANGNHAP]  WITH CHECK ADD  CONSTRAINT [FK_LICHSUDANGNHAP_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[LICHSUDANGNHAP] CHECK CONSTRAINT [FK_LICHSUDANGNHAP_NHANVIEN]
GO
ALTER TABLE [dbo].[LOAIBAN]  WITH CHECK ADD  CONSTRAINT [FK_LOAIBAN_DONVI] FOREIGN KEY([DonViID])
REFERENCES [dbo].[DONVI] ([DonViID])
GO
ALTER TABLE [dbo].[LOAIBAN] CHECK CONSTRAINT [FK_LOAIBAN_DONVI]
GO
ALTER TABLE [dbo].[LOAILICHBIEU]  WITH CHECK ADD  CONSTRAINT [FK_LOAILICHBIEU_THELOAILICHBIEU] FOREIGN KEY([TheLoaiID])
REFERENCES [dbo].[THELOAILICHBIEU] ([TheLoaiID])
GO
ALTER TABLE [dbo].[LOAILICHBIEU] CHECK CONSTRAINT [FK_LOAILICHBIEU_THELOAILICHBIEU]
GO
ALTER TABLE [dbo].[MATKHO]  WITH CHECK ADD  CONSTRAINT [FK_MATKHO_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[MATKHO] CHECK CONSTRAINT [FK_MATKHO_KHO]
GO
ALTER TABLE [dbo].[MATKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_MATKHO_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[MATKHO] CHECK CONSTRAINT [FK_MATKHO_NHANVIEN]
GO
ALTER TABLE [dbo].[MENUGIA]  WITH CHECK ADD  CONSTRAINT [FK_MENUGIA_MENULOAIGIA] FOREIGN KEY([LoaiGiaID])
REFERENCES [dbo].[MENULOAIGIA] ([LoaiGiaID])
GO
ALTER TABLE [dbo].[MENUGIA] CHECK CONSTRAINT [FK_MENUGIA_MENULOAIGIA]
GO
ALTER TABLE [dbo].[MENUITEMMAYIN]  WITH CHECK ADD  CONSTRAINT [FK_MENUITEMMAYIN_MAYIN] FOREIGN KEY([MayInID])
REFERENCES [dbo].[MAYIN] ([MayInID])
GO
ALTER TABLE [dbo].[MENUITEMMAYIN] CHECK CONSTRAINT [FK_MENUITEMMAYIN_MAYIN]
GO
ALTER TABLE [dbo].[MENUITEMMAYIN]  WITH CHECK ADD  CONSTRAINT [FK_MENUITEMMAYIN_MENUMON] FOREIGN KEY([MonID])
REFERENCES [dbo].[MENUMON] ([MonID])
GO
ALTER TABLE [dbo].[MENUITEMMAYIN] CHECK CONSTRAINT [FK_MENUITEMMAYIN_MENUMON]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI]  WITH CHECK ADD  CONSTRAINT [FK_MENUKHUYENMAI_MENUKICHTHUOCMON] FOREIGN KEY([KichThuocMonID])
REFERENCES [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID])
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] CHECK CONSTRAINT [FK_MENUKHUYENMAI_MENUKICHTHUOCMON]
GO
ALTER TABLE [dbo].[MENUKHUYENMAI]  WITH CHECK ADD  CONSTRAINT [FK_MENUKHUYENMAI_MENUKICHTHUOCMON1] FOREIGN KEY([KichThuocMonTang])
REFERENCES [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID])
GO
ALTER TABLE [dbo].[MENUKHUYENMAI] CHECK CONSTRAINT [FK_MENUKHUYENMAI_MENUKICHTHUOCMON1]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON]  WITH CHECK ADD  CONSTRAINT [FK_MENUKICHTHUOCMON_LOAIBAN] FOREIGN KEY([LoaiBanID])
REFERENCES [dbo].[LOAIBAN] ([LoaiBanID])
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] CHECK CONSTRAINT [FK_MENUKICHTHUOCMON_LOAIBAN]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON]  WITH CHECK ADD  CONSTRAINT [FK_MENUKICHTHUOCMON_MENUMON] FOREIGN KEY([MonID])
REFERENCES [dbo].[MENUMON] ([MonID])
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] CHECK CONSTRAINT [FK_MENUKICHTHUOCMON_MENUMON]
GO
ALTER TABLE [dbo].[MENUMON]  WITH CHECK ADD  CONSTRAINT [fk_MENUITEM_MENUGROUP] FOREIGN KEY([NhomID])
REFERENCES [dbo].[MENUNHOM] ([NhomID])
GO
ALTER TABLE [dbo].[MENUMON] CHECK CONSTRAINT [fk_MENUITEM_MENUGROUP]
GO
ALTER TABLE [dbo].[MENUNHOM]  WITH NOCHECK ADD  CONSTRAINT [fk_MENUGROUP_MENUGROUPTYPE] FOREIGN KEY([LoaiNhomID])
REFERENCES [dbo].[MENULOAINHOM] ([LoaiNhomID])
GO
ALTER TABLE [dbo].[MENUNHOM] NOCHECK CONSTRAINT [fk_MENUGROUP_MENUGROUPTYPE]
GO
ALTER TABLE [dbo].[NHANVIEN]  WITH CHECK ADD  CONSTRAINT [FK_NHANVIEN_LOAINHANVIEN] FOREIGN KEY([LoaiNhanVienID])
REFERENCES [dbo].[LOAINHANVIEN] ([LoaiNhanVienID])
GO
ALTER TABLE [dbo].[NHANVIEN] CHECK CONSTRAINT [FK_NHANVIEN_LOAINHANVIEN]
GO
ALTER TABLE [dbo].[NHAPKHO]  WITH CHECK ADD  CONSTRAINT [FK_NHAPKHO_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[NHAPKHO] CHECK CONSTRAINT [FK_NHAPKHO_KHO]
GO
ALTER TABLE [dbo].[NHAPKHO]  WITH CHECK ADD  CONSTRAINT [FK_NHAPKHO_NHACUNGCAP] FOREIGN KEY([NhaCungCapID])
REFERENCES [dbo].[NHACUNGCAP] ([NhaCungCapID])
GO
ALTER TABLE [dbo].[NHAPKHO] CHECK CONSTRAINT [FK_NHAPKHO_NHACUNGCAP]
GO
ALTER TABLE [dbo].[NHAPKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_NHAPKHO_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[NHAPKHO] CHECK CONSTRAINT [FK_NHAPKHO_NHANVIEN]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN]  WITH CHECK ADD  CONSTRAINT [FK_QUYENNHANVIEN_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] CHECK CONSTRAINT [FK_QUYENNHANVIEN_NHANVIEN]
GO
ALTER TABLE [dbo].[QUYENNHANVIEN]  WITH CHECK ADD  CONSTRAINT [FK_QUYENNHANVIEN_QUYEN] FOREIGN KEY([QuyenID])
REFERENCES [dbo].[QUYEN] ([MaQuyen])
GO
ALTER TABLE [dbo].[QUYENNHANVIEN] CHECK CONSTRAINT [FK_QUYENNHANVIEN_QUYEN]
GO
ALTER TABLE [dbo].[TACHBAN]  WITH CHECK ADD  CONSTRAINT [FK_TACHBAN_BAN] FOREIGN KEY([BanID])
REFERENCES [dbo].[BAN] ([BanID])
GO
ALTER TABLE [dbo].[TACHBAN] CHECK CONSTRAINT [FK_TACHBAN_BAN]
GO
ALTER TABLE [dbo].[TACHBAN]  WITH CHECK ADD  CONSTRAINT [FK_TACHBAN_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[TACHBAN] CHECK CONSTRAINT [FK_TACHBAN_NHANVIEN]
GO
ALTER TABLE [dbo].[THONGTIN]  WITH CHECK ADD  CONSTRAINT [FK_THONGTIN_LOAITHONGTIN] FOREIGN KEY([LoaiThongTinID])
REFERENCES [dbo].[LOAITHONGTIN] ([LoaiThongTinID])
GO
ALTER TABLE [dbo].[THONGTIN] CHECK CONSTRAINT [FK_THONGTIN_LOAITHONGTIN]
GO
ALTER TABLE [dbo].[TONKHO]  WITH CHECK ADD  CONSTRAINT [FK_TONKHO_DONVI] FOREIGN KEY([DonViID])
REFERENCES [dbo].[DONVI] ([DonViID])
GO
ALTER TABLE [dbo].[TONKHO] CHECK CONSTRAINT [FK_TONKHO_DONVI]
GO
ALTER TABLE [dbo].[TONKHO]  WITH CHECK ADD  CONSTRAINT [FK_TONKHO_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[TONKHO] CHECK CONSTRAINT [FK_TONKHO_KHO]
GO
ALTER TABLE [dbo].[TONKHO]  WITH CHECK ADD  CONSTRAINT [FK_TONKHO_LOAIPHATSINH] FOREIGN KEY([LoaiPhatSinhID])
REFERENCES [dbo].[LOAIPHATSINH] ([LoaiPhatSinhID])
GO
ALTER TABLE [dbo].[TONKHO] CHECK CONSTRAINT [FK_TONKHO_LOAIPHATSINH]
GO
ALTER TABLE [dbo].[TONKHO]  WITH CHECK ADD  CONSTRAINT [FK_TONKHO_MENUMON] FOREIGN KEY([MonID])
REFERENCES [dbo].[MENUMON] ([MonID])
GO
ALTER TABLE [dbo].[TONKHO] CHECK CONSTRAINT [FK_TONKHO_MENUMON]
GO
ALTER TABLE [dbo].[TONKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_TONKHO_TONKHO1] FOREIGN KEY([PhatSinhTuTonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[TONKHO] NOCHECK CONSTRAINT [FK_TONKHO_TONKHO1]
GO
ALTER TABLE [dbo].[TONKHOTONG]  WITH CHECK ADD  CONSTRAINT [FK_TONKHOTONG_DONVI] FOREIGN KEY([DonViID])
REFERENCES [dbo].[DONVI] ([DonViID])
GO
ALTER TABLE [dbo].[TONKHOTONG] CHECK CONSTRAINT [FK_TONKHOTONG_DONVI]
GO
ALTER TABLE [dbo].[TONKHOTONG]  WITH CHECK ADD  CONSTRAINT [FK_TONKHOTONG_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[TONKHOTONG] CHECK CONSTRAINT [FK_TONKHOTONG_KHO]
GO
ALTER TABLE [dbo].[TONKHOTONG]  WITH CHECK ADD  CONSTRAINT [FK_TONKHOTONG_MENUMON] FOREIGN KEY([MonID])
REFERENCES [dbo].[MENUMON] ([MonID])
GO
ALTER TABLE [dbo].[TONKHOTONG] CHECK CONSTRAINT [FK_TONKHOTONG_MENUMON]
GO
/****** Object:  Trigger [dbo].[TRIGGER_MENUKICHTHUOCMON_INSERT]    Script Date: 11/25/2014 3:53:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIGGER_MENUKICHTHUOCMON_INSERT]
ON [dbo].[MENUKICHTHUOCMON]
AFTER INSERT AS
BEGIN
	DECLARE @KichThuocMonID int;
	DECLARE @Gia Decimal(18,0);
	SELECT @KichThuocMonID = KichThuocMonID, @Gia = GiaBanMacDinh FROM INSERTED;
	DELETE FROM MENUGIA Where KichThuocMonID = @KichThuocMonID;
	Insert Into MENUGIA(KichThuocMonID, Gia, LoaiGiaID) Select @KichThuocMonID as KichThuocMonID, @Gia as Gia, LoaiGiaID From MENULOAIGIA Where Deleted = 0 And Visual = 1;
END



GO
/****** Object:  Trigger [dbo].[TRIGGER_LOAIGIA_INSERT]    Script Date: 11/25/2014 3:53:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIGGER_LOAIGIA_INSERT]
ON [dbo].[MENULOAIGIA]
AFTER INSERT AS
BEGIN
	DECLARE @LoaiGia int;	
	SELECT @LoaiGia = LoaiGiaID FROM INSERTED;
	INSERT INTO MENUGIA(KichThuocMonID, Gia, LoaiGiaID) Select KichThuocMonID, GiaBanMacDinh, @LoaiGia as LoaiGia from MENUKICHTHUOCMON	
END



GO
/****** Object:  Trigger [dbo].[TRIGGER_LOAIGIA_UPDATE]    Script Date: 11/25/2014 3:53:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIGGER_LOAIGIA_UPDATE]
ON [dbo].[MENULOAIGIA]
AFTER UPDATE AS
BEGIN
	DECLARE @LoaiGia int;
	SELECT @LoaiGia = LoaiGiaID FROM INSERTED Where Deleted = 1;	
	Delete From MENUGIA Where LoaiGiaID = @LoaiGia	
END



GO
USE [master]
GO
ALTER DATABASE [Karaoke] SET  READ_WRITE 
GO
