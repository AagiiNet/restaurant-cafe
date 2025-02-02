USE [master]
GO
/****** Object:  Database [Karaoke]    Script Date: 2/6/2015 3:27:57 AM ******/
CREATE DATABASE [Karaoke]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Karaoke', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Karaoke.mdf' , SIZE = 5184KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Karaoke_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Karaoke_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Karaoke] SET COMPATIBILITY_LEVEL = 110
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
ALTER DATABASE [Karaoke] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Karaoke] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Karaoke]
GO
/****** Object:  StoredProcedure [dbo].[SP_BAOCAOLICHSUTONKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_BAOCAOLICHSUTONKHO](@KhoID int, @DateFrom datetime, @DateTo datetime)
AS
BEGIN
	Select 	
	CASE WHEN M.DonViID = 1 THEN 'Cái' WHEN M.DonViID = 2 THEN 'Kg' WHEN M.DonViID = 3 THEN 'Lít' WHEN M.DonViID = 4 THEN 'Giờ' END AS DonViTinh, 
	M.TenDai AS TenBaoCao,
	MIN(ID) AS ID, 
	GetDate() As NgayGhiNhan,
	MIN(BC.KhoID) AS KhoID,
	M.MonID,		
	MIN(BC.DonViID) As DonViID,
	IIF(ISNULL(MIN(BC.ID),0)>0,(Select DauKySoLuong from BAOCAOLICHSUTONKHO Where ID = MIN(BC.ID)),0) As DauKySoLuong,
	IIF(ISNULL(MIN(BC.ID),0)>0,(Select DauKyThanhTien from BAOCAOLICHSUTONKHO Where ID = MIN(BC.ID)),0) As DauKyThanhTien,	
	ISNULL(SUM(BC.NhapSoLuong),0) As NhapSoLuong,
	ISNULL(SUM(BC.NhapThanhTien),0) As NhapThanhTien,
	ISNULL(SUM(BC.XuatSoLuong),0) As XuatSoLuong,
	ISNULL(SUM(BC.XuatThanhTien),0) As XuatThanhTien,
	IIF(ISNULL(MAX(BC.ID),0)>0,(Select CuoiKySoLuong from BAOCAOLICHSUTONKHO Where ID = MAX(BC.ID)),0) As CuoiKySoLuong,
	IIF(ISNULL(MAX(BC.ID),0)>0,(Select CuoiKyDonGia from BAOCAOLICHSUTONKHO Where ID = MAX(BC.ID)),0) As CuoiKyDonGia,
	IIF(ISNULL(MAX(BC.ID),0)>0,(Select CuoiKyThanhTien from BAOCAOLICHSUTONKHO Where ID = MAX(BC.ID)),0) As CuoiKyThanhTien
	from MENUMON AS M
	LEFT OUTER JOIN BAOCAOLICHSUTONKHO AS BC ON BC.MonID = M.MonID
	Where Deleted = 0 And BC.KhoID = @KhoID And CAST(BC.NgayGhiNhan As DATE) >= @DateFrom And CAST(BC.NgayGhiNhan As DATE) <= @DateTo
	GROUP BY M.MonID, M.DonViID, M.TenDai
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATEDEFAULT_KICHTHUOCMON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CREATEDEFAULT_KICHTHUOCMON]	
AS
BEGIN
	DECLARE @monID int, @donViID int, @gia decimal(18, 2);
	DECLARE vendor_cursor CURSOR FOR 
	SELECT M.MonID, M.DonViID, M.Gia FROM MENUMON M Where M.MonID Not in (Select KTM.MonID From MENUKICHTHUOCMON KTM)
	OPEN vendor_cursor
	FETCH NEXT FROM vendor_cursor INTO @monID, @donViID, @gia
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @donViID = 1	
			INSERT INTO	MENUKICHTHUOCMON(MonID, TenLoaiBan, LoaiBanID, DonViID, ChoPhepTonKho, GiaBanMacDinh, ThoiGia, KichThuocLoaiBan, SoLuongBanBan, Visual, Deleted, Edit, SapXep) Values
			(@monID, N'', 1, @donViID, 1, @gia,0,1,1,1,0,0,1);
		IF @donViID = 2
			INSERT INTO	MENUKICHTHUOCMON(MonID, TenLoaiBan, LoaiBanID, DonViID, ChoPhepTonKho, GiaBanMacDinh, ThoiGia, KichThuocLoaiBan, SoLuongBanBan, Visual, Deleted, Edit, SapXep) Values
			(@monID, N'', 3, @donViID, 1, @gia,0,1000,1,1,0,0,1);
			IF @donViID = 3
			INSERT INTO	MENUKICHTHUOCMON(MonID, TenLoaiBan, LoaiBanID, DonViID, ChoPhepTonKho, GiaBanMacDinh, ThoiGia, KichThuocLoaiBan, SoLuongBanBan, Visual, Deleted, Edit, SapXep) Values
			(@monID, N'', 5, @donViID, 1, @gia,0,1000,1,1,0,0,1);
		FETCH NEXT FROM vendor_cursor INTO @monID, @donViID, @gia
	END 
	CLOSE vendor_cursor;
	DEALLOCATE vendor_cursor;

END

GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_ALL_MENU]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DELETE_ALL_MENU] 	
AS
BEGIN		
	UPDATE MAYIN SET Deleted=1;
	UPDATE MENULOAIGIA SET Deleted=1;
	/*UPDATE DONVI SET Deleted=1;*/
	/*UPDATE LOAIBAN SET Deleted=1;*/
	UPDATE MENUNHOM SET Deleted=1;
	UPDATE MENUMON SET Deleted=1;
	UPDATE MENUKICHTHUOCMON SET Deleted=1;
	DELETE FROM MENUGIA;
	DELETE FROM MENUITEMMAYIN;		
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Login_NhanVien]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_Login_NhanVien](@TenDangNhap varchar(50), @MatKhau varchar(255))
As
 Select * From NHANVIEN Where TenDangNhap = @TenDangNhap And MatKhau = @MatKhau;

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BAOCAOBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_BAOCAOBAN](	
	@NgayBatDau DateTime,
	@NgayKetThuc DateTime
)	
AS
BEGIN
	SELECT 
		ID,
		NgayBan,
		TenBan,
		TenKhu,
		SUM(SoHoaDon) AS SoHoaDon,
		SUM(SoLuongBan) AS SoLuongBan,
		SUM(TongTien) AS TongTien
	FROM(
		SELECT     
		B.BanID AS ID, 
		CAST(GETDATE() AS DATE) AS NgayBan, 
		B.TenBan,
		K.TenKhu,
		1 AS SoHoaDon, 
		(SELECT SUM(CTBH.SoLuongBan) FROM CHITIETBANHANG CTBH WHERE CTBH.BanHangID=BH.BanHangID) AS SoLuongBan,
		BH.TongTien AS TongTien
		FROM         
			dbo.BANHANG AS BH INNER JOIN
			dbo.BAN AS B ON BH.BanID = B.BanID INNER JOIN
			dbo.KHU AS K ON B.KhuID = K.KhuID
		WHERE 
			TrangThaiID=4 AND
			CAST(NgayBan AS DATE)>=CAST(@NgayBatDau as DATE) AND
			CAST(NgayBan AS DATE)<=CAST(@NgayKetThuc as DATE)
	) AS TMP
	GROUP BY ID,TenBan,TenKhu,NgayBan;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BAOCAOKHU]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_BAOCAOKHU](	
	@NgayBatDau DateTime,
	@NgayKetThuc DateTime
)	
AS
BEGIN	

	SELECT 
		ID,
		NgayBan,		
		TenKhu,
		SUM(SoHoaDon) AS SoHoaDon,
		SUM(SoLuongBan) AS SoLuongBan,
		SUM(TongTien) AS TongTien
	FROM(
		SELECT     
		B.KhuID AS ID, 
		CAST(GETDATE() AS DATE) AS NgayBan, 		
		K.TenKhu,
		1 AS SoHoaDon, 
		(SELECT SUM(CTBH.SoLuongBan) FROM CHITIETBANHANG CTBH WHERE CTBH.BanHangID=BH.BanHangID) AS SoLuongBan,
		(BH.TienMat+BH.TienThe) AS TongTien
		FROM         
			dbo.BANHANG AS BH INNER JOIN
			dbo.BAN AS B ON BH.BanID = B.BanID INNER JOIN
			dbo.KHU AS K ON B.KhuID = K.KhuID
		WHERE 
			TrangThaiID=4 AND
			CAST(NgayBan AS DATE)>=CAST(@NgayBatDau as DATE) AND
			CAST(NgayBan AS DATE)<=CAST(@NgayKetThuc as DATE)
	) AS TMP
	GROUP BY ID,TenKhu,NgayBan;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BAOCAONGAYTONG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_BAOCAONGAYTONG](	
	@NgayBatDau DateTime,
	@NgayKetThuc DateTime
)	
AS
BEGIN
	SELECT
	1 As ID,
	GETDATE() as NgayBan,
	SUM(TienMat) as TienMat,
	SUM(TienThe) as TienThe,
	SUM(TienTraLai) as TienTraLai,
	SUM(GiamGia*TongTien/100) as GiamGia,
	SUM(ChietKhau) as ChietKhau,
	SUM(TienBo) as TienBo,
	SUM(PhiDichVu*TongTien/100) as PhiDichVu,
	SUM(TienKhacHang) as TienKhacHang,
	SUM(TongTien) as TongTien,
	COUNT_BIG(BanHangID) AS SoHoaDon
	FROM dbo.BANHANG 
	WHERE 
		TrangThaiID=4 AND
		CAST(NgayBan AS DATE)>=CAST(@NgayBatDau as DATE) AND
		CAST(NgayBan AS DATE)<=CAST(@NgayKetThuc as DATE);
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BAOCAONHANVIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_BAOCAONHANVIEN]
	@NgayBatDau DateTime,
	@NgayKetThuc DateTime
AS
BEGIN
	SELECT 
		ID,
		CAST(GETDATE() AS DATE) AS NgayBan,
		TenNhanVien,		
		SUM(SoHoaDon) AS SoHoaDon,
		SUM(SoLuongBan) AS SoLuongBan,
		SUM(TongTien) AS TongTien 
	FROM
	(	
		SELECT 
			NV.NhanVienID As ID,
			CAST(BH.NgayBan as DATE) AS NgayBan, 
			NV.TenNhanVien,
			1 AS SoHoaDon,
			(SELECT SUM(CTBH.SoLuongBan) FROM CHITIETBANHANG CTBH WHERE CTBH.BanHangID=BH.BanHangID) AS SoLuongBan,
			(BH.TienMat+BH.TienThe) As TongTien
		FROM BANHANG BH 	
			INNER JOIN NHANVIEN NV ON BH.NhanVienID=NV.NhanVienID			
		WHERE     		
			CAST(BH.NgayBan as DATE)>=CAST(@NgayBatDau as DATE) AND
			CAST(BH.NgayBan as DATE)<=CAST(@NgayKetThuc as DATE)
	) AS TMP
	GROUP BY ID,TenNhanVien;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAPXEP_KICHTHUOCMON]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SAPXEP_MENUMON]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SAPXEP_NHOM]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SOLUONGKICHTHUOCMON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_SOLUONGKICHTHUOCMON](@MonID int)
As
BEGIN
	DECLARE @DonViID int;
	Select @DonViID = Count(*) From MENUKICHTHUOCMON Where MonID = @MonID And Deleted = 0 And Visual = 1 And ChoPhepTonKho = 1;
	Update MENUMON Set SLMonChoPhepTonKho = @DonViID Where MonID = @MonID;	
	Select @DonViID = Count(*) From MENUKICHTHUOCMON Where MonID = @MonID And Deleted = 0 And Visual = 1 And ChoPhepTonKho = 0;
	Update MENUMON Set SLMonKhongChoPhepTonKho = @DonViID Where MonID = @MonID;
	DECLARE @NhomID int;
	Select @NhomID = NhomID From MENUMON Where MonID = @MonID;
	Exec SP_UPDATE_SOLUONGMON @NhomID = @NhomID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SOLUONGMON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_SOLUONGMON](@NhomID int)
As
BEGIN
	DECLARE @SLMon int;
	Select @SLMon = Count(*) From MENUMON Where NhomID = @NhomID And SLMonChoPhepTonKho > 0 And Deleted = 0 And Visual = 1;
	Update MENUNHOM Set SLMonChoPhepTonKho = @SLMon Where NhomID = @NhomID;
	Select @SLMon = Count(*) From MENUMON Where NhomID = @NhomID And SLMonKhongChoPhepTonKho> 0 And Deleted = 0 And Visual = 1;
	Update MENUNHOM Set SLMonKhongChoPhepTonKho = @SLMon Where NhomID = @NhomID;
END

GO
/****** Object:  Table [dbo].[BAN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[BANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
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
	[TheID] [int] NULL,
	[KhachHangID] [int] NULL,
	[NgayBan] [datetime] NULL,
	[NgayKetThuc] [datetime] NULL,
	[MaHoaDon] [varchar](20) NULL,
	[GiamGia] [int] NOT NULL,
	[PhiDichVu] [int] NOT NULL,
	[ThueVAT] [int] NOT NULL,
	[SoPhut] [int] NOT NULL,
	[TienMat] [decimal](18, 2) NOT NULL,
	[TienThe] [decimal](18, 2) NOT NULL,
	[TienTraLai] [decimal](18, 2) NOT NULL,
	[ChietKhau] [decimal](18, 2) NOT NULL,
	[TienBo] [decimal](18, 2) NOT NULL,
	[TongTien] [decimal](18, 2) NOT NULL,
	[TienKhacHang] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_BANHANG] PRIMARY KEY CLUSTERED 
(
	[BanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAIDATBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAIDATBAN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableWidth] [decimal](18, 10) NOT NULL,
	[TableHeight] [decimal](18, 10) NOT NULL,
	[TableImage] [image] NULL,
	[TableFontSize] [float] NOT NULL,
	[TableFontStyle] [int] NOT NULL,
	[TableFontWeights] [int] NOT NULL,
 CONSTRAINT [PK_CAIDATBAN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAIDATBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAIDATBANHANG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PhiDichVu] [int] NOT NULL,
	[ChoPhepPhiDichVu] [bit] NOT NULL,
	[ThueVAT] [int] NOT NULL,
	[ChoPhepThueVAT] [bit] NOT NULL,
	[MonTinhGio] [int] NULL,
	[SoPhutToiThieu] [int] NOT NULL,
	[KhoaSoDoBan] [bit] NOT NULL,
 CONSTRAINT [PK_CAIDATBANHANG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAIDATMAYINBEP]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAIDATMAYINBEP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TitleTextFontSize] [float] NOT NULL,
	[TitleTextFontStyle] [int] NOT NULL,
	[TitleTextFontWeights] [int] NOT NULL,
	[InfoTextFontSize] [float] NOT NULL,
	[InfoTextFontStyle] [int] NOT NULL,
	[InfoTextFontWeights] [int] NOT NULL,
	[ItemTextFontSize] [float] NOT NULL,
	[ItemTextFontStyle] [int] NOT NULL,
	[ItemTextFontWeights] [int] NOT NULL,
	[SumTextFontSize] [float] NOT NULL,
	[SumTextFontStyle] [int] NOT NULL,
	[SumTextFontWeights] [int] NOT NULL,
 CONSTRAINT [PK_CAIDATMAYINBEP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAIDATMAYINHOADON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAIDATMAYINHOADON](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HeaderTextString1] [nvarchar](50) NULL,
	[HeaderTextString2] [nvarchar](50) NULL,
	[HeaderTextString3] [nvarchar](50) NULL,
	[HeaderTextString4] [nvarchar](50) NULL,
	[HeaderTextFontSize1] [float] NOT NULL,
	[HeaderTextFontSize2] [float] NOT NULL,
	[HeaderTextFontSize3] [float] NOT NULL,
	[HeaderTextFontSize4] [float] NOT NULL,
	[HeaderTextFontStyle1] [int] NOT NULL,
	[HeaderTextFontStyle2] [int] NOT NULL,
	[HeaderTextFontStyle3] [int] NOT NULL,
	[HeaderTextFontStyle4] [int] NOT NULL,
	[HeaderTextFontWeights1] [int] NOT NULL,
	[HeaderTextFontWeights2] [int] NOT NULL,
	[HeaderTextFontWeights3] [int] NOT NULL,
	[HeaderTextFontWeights4] [int] NOT NULL,
	[FooterTextString1] [nvarchar](50) NULL,
	[FooterTextString2] [nvarchar](50) NULL,
	[FooterTextString3] [nvarchar](50) NULL,
	[FooterTextString4] [nvarchar](50) NULL,
	[FooterTextFontSize1] [float] NOT NULL,
	[FooterTextFontSize2] [float] NOT NULL,
	[FooterTextFontSize3] [float] NOT NULL,
	[FooterTextFontSize4] [float] NOT NULL,
	[FooterTextFontStyle1] [int] NOT NULL,
	[FooterTextFontStyle2] [int] NOT NULL,
	[FooterTextFontStyle3] [int] NOT NULL,
	[FooterTextFontStyle4] [int] NOT NULL,
	[FooterTextFontWeights1] [int] NOT NULL,
	[FooterTextFontWeights2] [int] NOT NULL,
	[FooterTextFontWeights3] [int] NOT NULL,
	[FooterTextFontWeights4] [int] NOT NULL,
	[SumanyFontSize] [float] NOT NULL,
	[SumanyFontStyle] [int] NOT NULL,
	[SumanyFontWeights] [int] NOT NULL,
	[SumanyFontSizeBig] [float] NOT NULL,
	[SumanyFontStyleBig] [int] NOT NULL,
	[SumanyFontWeightsBig] [int] NOT NULL,
	[TitleTextFontSize] [float] NOT NULL,
	[TitleTextFontStyle] [int] NOT NULL,
	[TitleTextFontWeights] [int] NOT NULL,
	[InfoTextFontSize] [float] NOT NULL,
	[InfoTextFontStyle] [int] NOT NULL,
	[InfoTextFontWeights] [int] NOT NULL,
	[ItemFontSize] [float] NOT NULL,
	[ItemTextFontStyle] [int] NOT NULL,
	[ItemTextFontWeights] [int] NOT NULL,
	[Logo] [image] NULL,
	[LogoHeight] [int] NOT NULL,
	[LogoWidth] [int] NOT NULL,
 CONSTRAINT [PK_CAIDATMAYINHOADON] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAIDATTHONGTINCONGTY]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[CAIDATTHUCDON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAIDATTHUCDON](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NhomTextFontSize] [float] NOT NULL,
	[NhomTextFontStyle] [int] NOT NULL,
	[NhomTextFontWeights] [int] NOT NULL,
	[NhomImages] [image] NULL,
	[MonTextFontSize] [float] NOT NULL,
	[MonTextFontStyle] [int] NOT NULL,
	[MonTextFontWeights] [int] NOT NULL,
	[MonImages] [image] NULL,
	[LoaiNhomTextFontSize] [float] NOT NULL,
	[LoaiNhomTextFontStyle] [int] NOT NULL,
	[LoaiNhomTextFontWeights] [int] NOT NULL,
	[LoaiNhomNuocImages] [image] NULL,
	[LoaiNhomThucAnImages] [image] NULL,
	[LoaiNhomThucTatCaImages] [image] NULL,
 CONSTRAINT [PK_CAIDATTHUCDON] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAIKHOBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAIKHOBANHANG](
	[ID] [int] NOT NULL,
	[KhoBanHang] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_CAIKHOBANHANG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETBANHANG](
	[ChiTietBanHangID] [int] IDENTITY(1,1) NOT NULL,
	[BanHangID] [int] NULL,
	[SoLuongBan] [int] NOT NULL,
	[KichThuocLoaiBan] [int] NOT NULL,
	[GiamGia] [int] NOT NULL,
	[GiaBan] [decimal](18, 2) NOT NULL,
	[ThanhTien] [decimal](18, 2) NOT NULL,
	[KichThuocMonID] [int] NULL,
	[NhanVienID] [int] NULL,
	[LoaiChiTietBanHang] [int] NOT NULL,
	[ChiTietBanHangID_Ref] [int] NULL,
	[KichThuocMonID_Ref] [int] NULL,
 CONSTRAINT [PK_CHITIETBANHANG] PRIMARY KEY CLUSTERED 
(
	[ChiTietBanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETCHUYENKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETCHUYENKHO](
	[ChiTietChuyenKhoID] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [dbo].[CHITIETGOPBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETGOPBAN](
	[ChiTietGopBanID] [int] IDENTITY(1,1) NOT NULL,
	[GopBanID] [int] NULL,
	[BanHangID] [int] NULL,
	[BanID] [int] NULL,
 CONSTRAINT [PK_CHITIETGOPBAN] PRIMARY KEY CLUSTERED 
(
	[ChiTietGopBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETLICHSUBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETLICHSUBANHANG](
	[ChiTietLichSuBanHangID] [int] IDENTITY(1,1) NOT NULL,
	[LichSuBanHangID] [int] NULL,
	[KichThuocMonID] [int] NULL,
	[TonKhoID] [int] NULL,
	[SoLuong] [int] NOT NULL,
	[KichThuocLoaiBan] [int] NOT NULL,
	[GiamGia] [int] NOT NULL,
	[GiaBan] [decimal](18, 2) NOT NULL,
	[ThanhTien] [decimal](18, 2) NOT NULL,
	[TrangThai] [int] NULL,
	[LoaiChiTietBanHang] [int] NOT NULL,
	[ChiTietLichSuBanHangID_Ref] [int] NULL,
	[KichThuocMonID_Ref] [int] NULL,
 CONSTRAINT [PK_CHITIETLICHSUBANHANG] PRIMARY KEY CLUSTERED 
(
	[ChiTietLichSuBanHangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETNHAPKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[CHITIETQUYEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[CHITIETTACHBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETTACHBAN](
	[ChiTietTachBanID] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [dbo].[CHITIETTHUCHI]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETTHUCHI](
	[ChiTietThuChiID] [int] IDENTITY(1,1) NOT NULL,
	[ThuChiID] [int] NULL,
	[GhiChu] [nvarchar](255) NULL,
	[SoTien] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CHITIETTHUCHI] PRIMARY KEY CLUSTERED 
(
	[ChiTietThuChiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHUCNANG]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[CHUYENBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHUYENBAN](
	[ChuyenBanID] [int] IDENTITY(1,1) NOT NULL,
	[TuBanHangID] [int] NULL,
	[DenBanHangID] [int] NULL,
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
/****** Object:  Table [dbo].[CHUYENKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[DINHLUONG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DINHLUONG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KichThuocMonChinhID] [int] NOT NULL,
	[MonID] [int] NULL,
	[DonViID] [int] NULL,
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
/****** Object:  Table [dbo].[DONVI]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DONVI](
	[DonViID] [int] IDENTITY(1,1) NOT NULL,
	[TenDonVi] [nvarchar](50) NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_DONVI] PRIMARY KEY CLUSTERED 
(
	[DonViID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GIAODIENCHUCNANGBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAODIENCHUCNANGBANHANG](
	[ID] [int] NOT NULL,
	[ChucNangID] [int] NULL,
	[HienThi] [nvarchar](100) NULL,
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
/****** Object:  Table [dbo].[GOPBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GOPBAN](
	[GopBanID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[BanHangID] [int] NULL,
	[ThoiGian] [datetime] NULL,
 CONSTRAINT [PK_GOPBAN] PRIMARY KEY CLUSTERED 
(
	[GopBanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HOPDUNGTIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[HUYHOADON]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[INHOADON]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
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
	[DuNo] [decimal](18, 2) NOT NULL,
	[DuNoToiThieu] [decimal](18, 2) NOT NULL,
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
/****** Object:  Table [dbo].[KHO]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[KHU]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHU](
	[KhuID] [int] IDENTITY(1,1) NOT NULL,
	[TenKhu] [nvarchar](50) NULL,
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
/****** Object:  Table [dbo].[LICHBIEUDINHKY]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHBIEUDINHKY](
	[LichBieuDinhKyID] [int] IDENTITY(1,1) NOT NULL,
	[TenLichBieu] [nvarchar](255) NULL,
	[LoaiGiaID] [int] NOT NULL,
	[TheLoaiID] [int] NOT NULL,
	[KhuID] [int] NULL,
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
/****** Object:  Table [dbo].[LICHBIEUKHONGDINHKY]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHBIEUKHONGDINHKY](
	[LichBieuKhongDinhKyID] [int] IDENTITY(1,1) NOT NULL,
	[TenLichBieu] [nvarchar](255) NULL,
	[NgayBatDau] [date] NULL,
	[NgayKetThuc] [date] NULL,
	[GioBatDau] [time](4) NULL,
	[GioKetThuc] [time](4) NULL,
	[LoaiGiaID] [int] NULL,
	[KhuID] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHBIEUKHONGDINHKY] PRIMARY KEY CLUSTERED 
(
	[LichBieuKhongDinhKyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHSUBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LICHSUCONGNO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUCONGNO](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KhachHangID] [int] NULL,
	[NgayPhatSinh] [datetime] NULL,
	[SoTienPhatSinh] [decimal](18, 2) NOT NULL,
	[TienMat] [decimal](18, 2) NOT NULL,
	[TienThe] [decimal](18, 2) NOT NULL,
	[TheID] [int] NULL,
	[BanHangID] [int] NULL,
	[DuNoCuoi] [decimal](18, 2) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_LICHSUCONGNO] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LICHSUDANGNHAP]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LICHSUTONKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUTONKHO](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NgayGhiNhan] [datetime] NOT NULL,
	[KhoID] [int] NULL,
	[MonID] [int] NULL,
	[DonViID] [int] NULL,
	[DauKySoLuong] [int] NULL,
	[DauKyThanhTien] [decimal](18, 2) NULL,
	[NhapSoLuong] [int] NOT NULL,
	[NhapThanhTien] [decimal](18, 2) NOT NULL,
	[XuatSoLuong] [int] NOT NULL,
	[XuatThanhTien] [decimal](18, 2) NOT NULL,
	[CuoiKySoLuong] [int] NOT NULL,
	[CuoiKyDonGia] [decimal](18, 2) NOT NULL,
	[CuoiKyThanhTien] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_LICHSUTONKHO] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAIBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAIHOPDUNGTIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAIKHACHHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAILICHBIEU]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAINHANVIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAIPHATSINH]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAITHONGTIN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[LOAITHUCHI]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[MAYIN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[MENUGIA]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUGIA](
	[GiaID] [int] IDENTITY(1,1) NOT NULL,
	[KichThuocMonID] [int] NULL,
	[Gia] [decimal](18, 2) NOT NULL,
	[LoaiGiaID] [int] NULL,
 CONSTRAINT [PK__MENUPRIC__4957584FFDB27387] PRIMARY KEY CLUSTERED 
(
	[GiaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUITEMMAYIN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[MENUKHUYENMAI]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[MENUKICHTHUOCMON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUKICHTHUOCMON](
	[KichThuocMonID] [int] IDENTITY(1,1) NOT NULL,
	[MonID] [int] NULL,
	[TenLoaiBan] [nvarchar](50) NULL,
	[LoaiBanID] [int] NULL,
	[DonViID] [int] NULL,
	[ChoPhepTonKho] [bit] NULL,
	[GiaBanMacDinh] [decimal](18, 2) NOT NULL,
	[ThoiGia] [bit] NOT NULL,
	[KichThuocLoaiBan] [int] NOT NULL,
	[SoLuongBanBan] [int] NOT NULL,
	[SapXep] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_MENUKICHTHUOCMON] PRIMARY KEY CLUSTERED 
(
	[KichThuocMonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENULOAIGIA]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[MENULOAINHOM]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENULOAINHOM](
	[LoaiNhomID] [int] IDENTITY(1,1) NOT NULL,
	[TenLoaiNhom] [nvarchar](100) NULL,
	[SapXepNhom] [int] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK__MENUGROU__3214EC272A95EA21] PRIMARY KEY CLUSTERED 
(
	[LoaiNhomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MENUMON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MENUMON](
	[MonID] [int] IDENTITY(1,1) NOT NULL,
	[TenNgan] [nvarchar](100) NOT NULL,
	[TenDai] [nvarchar](255) NULL,
	[NhomID] [int] NULL,
	[Gia] [decimal](18, 2) NOT NULL,
	[GST] [int] NOT NULL,
	[DonViID] [int] NULL,
	[MaVach] [varchar](20) NULL,
	[TonKhoToiThieu] [int] NOT NULL,
	[TonKhoToiDa] [int] NOT NULL,
	[SapXep] [int] NOT NULL,
	[SapXepKichThuocMon] [int] NOT NULL,
	[GiamGia] [int] NOT NULL,
	[Hinh] [image] NULL,
	[SLMonChoPhepTonKho] [int] NOT NULL,
	[SLMonKhongChoPhepTonKho] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK__MENUITEM__727E83EBE6A88A96] PRIMARY KEY CLUSTERED 
(
	[MonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MENUNHOM]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENUNHOM](
	[NhomID] [int] IDENTITY(1,1) NOT NULL,
	[TenNgan] [nvarchar](100) NULL,
	[TenDai] [nvarchar](255) NULL,
	[LoaiNhomID] [int] NULL,
	[SapXep] [int] NOT NULL,
	[SLMonChoPhepTonKho] [int] NOT NULL,
	[SLMonKhongChoPhepTonKho] [int] NOT NULL,
	[SapXepMon] [int] NOT NULL,
	[GiamGia] [int] NOT NULL,
	[Hinh] [image] NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK__MENUGROU__149AF30AA30A825B] PRIMARY KEY CLUSTERED 
(
	[NhomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[NHAPKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
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
	[TongTien] [decimal](18, 2) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_NHAPKHO] PRIMARY KEY CLUSTERED 
(
	[NhapKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NHOMCHUCNANG]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[QUYEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[QUYENNHANVIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[TACHBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TACHBAN](
	[TachBanID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[BanHangID] [int] NULL,
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
/****** Object:  Table [dbo].[THAMSO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THAMSO](
	[BanHangKhongKho] [bit] NULL,
	[SoMay] [int] NOT NULL,
	[BanQuyen] [nvarchar](255) NULL,
	[NgayBatDau] [date] NULL,
	[XacNhanNgayBatDau] [nvarchar](255) NULL,
	[NgayKetThuc] [date] NULL,
	[XacNhanNgayKetThuc] [nvarchar](255) NULL,
	[ThuTuMaHoaDon] [int] NOT NULL,
 CONSTRAINT [PK_THAMSO] PRIMARY KEY CLUSTERED 
(
	[SoMay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[THE]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[THELOAILICHBIEU]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[THONGTIN]    Script Date: 2/6/2015 3:27:58 AM ******/
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
/****** Object:  Table [dbo].[THUCHI]    Script Date: 2/6/2015 3:27:58 AM ******/
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
	[TongTien] [decimal](18, 2) NOT NULL,
	[Visual] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
 CONSTRAINT [PK_THUCHI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TONKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
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
	[GiaBan] [decimal](18, 2) NOT NULL,
	[GiaNhap] [decimal](18, 2) NOT NULL,
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
/****** Object:  Table [dbo].[TONKHOCHITIETBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TONKHOCHITIETBANHANG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KhoID] [int] NULL,
	[MonID] [int] NULL,
	[DonViID] [int] NULL,
	[MayID] [int] NULL,
	[BanHangID] [int] NULL,
	[ChiTietBanHangID] [int] NULL,
	[TonKhoID] [int] NULL,
	[SoLuong] [int] NULL,
 CONSTRAINT [PK_TONKHOCHITIETBANHANG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TONKHOTONG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TONKHOTONG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MonID] [int] NOT NULL,
	[KhoID] [int] NOT NULL,
	[DonViID] [int] NOT NULL,
	[TenMonBaoCao] [nvarchar](256) NULL,
	[SoLuongTon] [int] NOT NULL,
	[SoLuongBan] [int] NOT NULL,
	[SoLuongNhap] [int] NOT NULL,
	[SoLuongChuyen] [int] NOT NULL,
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
/****** Object:  Table [dbo].[TONKHOTONGLOG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TONKHOTONGLOG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MayID] [int] NULL,
	[KhoID] [int] NULL,
	[MonID] [int] NULL,
	[DonViID] [int] NULL,
	[SoLuong] [int] NOT NULL,
	[TrangThai] [bit] NOT NULL,
 CONSTRAINT [PK_TONKHOTONGLOG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TRANGTHAI]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRANGTHAI](
	[TrangThaiID] [int] NOT NULL,
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
/****** Object:  Table [dbo].[XULYKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XULYKHO](
	[ChinhKhoID] [int] IDENTITY(1,1) NOT NULL,
	[NhanVienID] [int] NULL,
	[KhoID] [int] NULL,
	[LoaiID] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[TongTien] [decimal](18, 2) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Edit] [bit] NOT NULL,
	[Visual] [bit] NOT NULL,
 CONSTRAINT [PK_CHINHKHO] PRIMARY KEY CLUSTERED 
(
	[ChinhKhoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XULYKHOCHITIET]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XULYKHOCHITIET](
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
/****** Object:  Table [dbo].[XULYKHOLOAI]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XULYKHOLOAI](
	[ID] [int] NOT NULL,
	[Ten] [nvarchar](50) NULL,
 CONSTRAINT [PK_XULYKHOLOAI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[BAOCAONGAYMON]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAYMON]
AS
SELECT 
	ISNULL(MAX(BH.BanHangID), 0) As ID,
	CAST(NgayBan AS DATE) as NgayBan, M.NhomID,
	CASE
		WHEN KTM.TenLoaiBan = '' THEN M.TenDai
		ELSE M.TenDai + ' ('+KTM.TenLoaiBan+')'
	END AS Ten,
	KTM.KichThuocMonID,
	SUM(CTBH.SoLuongBan) As SoLuongBan, SUM(ThanhTien) AS ThanhTien
	FROM BANHANG BH Inner Join CHITIETBANHANG CTBH ON BH.BanHangID = CTBH.BanHangID
	Inner Join MENUKICHTHUOCMON KTM ON CTBH.KichThuocMonID = KTM.KichThuocMonID
	Inner Join MENUMON M ON KTM.MonID = M.MonID
	GROUP BY CAST(NgayBan AS DATE), M.TenDai, KTM.TenLoaiBan, M.NhomID, KTM.KichThuocMonID

GO
/****** Object:  View [dbo].[BAOCAONGAYNHOM]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAYNHOM]
AS
SELECT 
	ISNULL(MAX(BCNM.ID), 0) As ID,
	CAST(NgayBan AS DATE) as NgayBan, 
	N.TenDai,  N.NhomID,
	SUM(BCNM.SoLuongBan) As SoLuongBan, 
	SUM(BCNM.ThanhTien) AS ThanhTien
	From BAOCAONGAYMON BCNM Inner Join MENUNHOM N ON N.NhomID = BCNM.NhomID
	GROUP BY CAST(NgayBan AS DATE), N.TenDai, N.NhomID

GO
/****** Object:  View [dbo].[BAOCAOBAN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOBAN]
AS
SELECT     
	ISNULL(MAX(BH.BanHangID), 0) AS ID, 
	CAST(BH.NgayBan AS DATE) AS NgayBan, 
	B.TenBan,
	K.TenKhu,
	COUNT(BH.BanHangID) AS SoHoaDon, 
	SUM(CTBH.SoLuongBan) AS SoLuongBan, 
    SUM(BH.TongTien) AS TongTien
FROM         
	dbo.BANHANG AS BH INNER JOIN
	dbo.BAN AS B ON BH.BanID = B.BanID INNER JOIN
	dbo.KHU AS K ON B.KhuID = K.KhuID INNER JOIN
	dbo.CHITIETBANHANG AS CTBH ON BH.BanHangID = CTBH.BanHangID
	WHERE BH.TrangThaiID=4
	GROUP BY B.TenBan, K.TenKhu, CAST(BH.NgayBan AS DATE)

GO
/****** Object:  View [dbo].[BAOCAOKHU]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOKHU]
AS
SELECT
	ISNULL(MAX(B.ID), 0) AS ID, 
	CAST(B.NgayBan AS DATE) AS NgayBan,
	B.TenKhu,
	SUM(B.SoHoaDon) AS SoHoaDon, 
	SUM(B.SoLuongBan) AS SoLuongBan, 
    SUM(B.TongTien) AS TongTien  
FROM 
	BAOCAOBAN AS B 
GROUP BY B.TenKhu, CAST(B.NgayBan AS DATE)

GO
/****** Object:  View [dbo].[BAOCAOCHITIETLICHSUBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOCHITIETLICHSUBANHANG]
AS
SELECT 
	CTLSBH.ChiTietLichSuBanHangID AS ID,
	LSBH.LichSuBanHangID,
	LSBH.NgayBan,
	CASE 
		WHEN KTM.TenLoaiBan <> '' THEN MM.TenDai + '('+KTM.TenLoaiBan+')'
		ELSE  MM.TenDai
	END AS Ten,
	CASE WHEN CTLSBH.SoLuong < 0 THEN CTLSBH.SoLuong * -1 ELSE CTLSBH.SoLuong END AS SoLuong,
	CASE WHEN CTLSBH.SoLuong < 0 THEN 'Xóa' ELSE 'Thêm' END AS TrangThai,
	NV.TenNhanVien,
	B.TenBan
	FROM LICHSUBANHANG LSBH
	INNER JOIN CHITIETLICHSUBANHANG CTLSBH ON LSBH.LichSuBanHangID = CTLSBH.LichSuBanHangID
	INNER JOIN MENUKICHTHUOCMON KTM ON CTLSBH.KichThuocMonID = KTM.KichThuocMonID
	INNER JOIN MENUMON MM ON KTM.MonID = MM.MonID
	INNER JOIN NHANVIEN NV ON NV.NhanVienID = LSBH.NhanVienID
	INNER JOIN BANHANG BH ON BH.BanHangID = LSBH.BanHangID
	INNER JOIN BAN B ON B.BanID = BH.BanID

GO
/****** Object:  View [dbo].[BAOCAODINHLUONG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAODINHLUONG]
AS	
	SELECT  
	CAST(NgayBan AS DATE) As NgayBan,
	ISNULL(MAX(DL.MonID), 0) As ID,	
	M.TenDai As TenMon,
	CASE
		WHEN M.DonViID = 1 THEN  'Cái, Lon, ...'
		WHEN M.DonViID = 2 THEN  'Kg' 
		WHEN M.DonViID = 3 THEN  'Lít'
		WHEN M.DonViID = 4 THEN  'Giờ'
	END As DonViTinh,
	CASE
		WHEN M.DonViID = 1 THEN ISNULL(SUM(DL.SoLuong * DL.KichThuocBan), 0)
		WHEN M.DonViID = 2 THEN CAST(ISNULL(SUM(DL.SoLuong * DL.KichThuocBan), 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN M.DonViID = 3 THEN CAST(ISNULL(SUM(DL.SoLuong * DL.KichThuocBan), 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN M.DonViID = 4 THEN CAST(ISNULL(SUM(DL.SoLuong * DL.KichThuocBan), 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(SUM(DL.SoLuong * DL.KichThuocBan), 0) AS DECIMAL(10,0)) 
	END
	AS SoLuong
	FROM BANHANG BH Inner Join CHITIETBANHANG CTBH ON BH.BanHangID = CTBH.BanHangID
	Inner Join MENUKICHTHUOCMON KTM ON CTBH.KichThuocMonID = KTM.KichThuocMonID	
	Inner join DINHLUONG DL ON DL.KichThuocMonChinhID = CTBH.KichThuocMonID
	Inner Join MENUMON M ON DL.MonID = M.MonID		
	Where KTM.ChoPhepTonKho = 0
	GROUP BY CAST(NgayBan AS DATE), DL.MonID, M.TenDai, M.DonViID

GO
/****** Object:  View [dbo].[BAOCAOLICHDANGNHAP]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOLICHDANGNHAP]
As
SELECT        l.ID, l.ThoiGian, nv.TenNhanVien, lnv.TenLoaiNhanVien
FROM            dbo.LICHSUDANGNHAP AS l INNER JOIN
                         dbo.NHANVIEN AS nv ON l.NhanVienID = nv.NhanVienID INNER JOIN
                         dbo.LOAINHANVIEN AS lnv ON lnv.LoaiNhanVienID = nv.LoaiNhanVienID

GO
/****** Object:  View [dbo].[BAOCAOLICHSUBANHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[BAOCAOLICHSUBANHANG]
As
Select NV.TenNhanVien, B.TenBan, BH.NgayBan, BH.MaHoaDon, BH.TienMat, BH.TienThe, T.TenThe, KH.TenKhachHang, BH.TienKhacHang, BH.TienTraLai, BH.GiamGia, BH.ChietKhau, BH.TienBo, BH.PhiDichVu, BH.TongTien
 from BANHANG BH
 Left join NHANVIEN NV On BH.NhanVienID = NV.NhanVienID
 Left join THE T On BH.TheID = T.TheID
 Left join KHACHHANG KH On BH.KhachHangID = Kh.KhachHangID
 Left join BAN B On BH.BanID = B.BanID
 Where BH.TrangThaiID = 4

GO
/****** Object:  View [dbo].[BAOCAOLICHSUTONKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOLICHSUTONKHO]
AS
SELECT  CASE WHEN M.DonViID = 1 THEN 'Cái' WHEN M.DonViID = 2 THEN 'Kg' WHEN M.DonViID = 3 THEN 'Lít' WHEN M.DonViID = 4 THEN 'Giờ' END AS DonViTinh, 
	M.TenDai AS TenBaoCao, T.*                    
FROM dbo.MENUMON AS M RIGHT OUTER JOIN
	 dbo.LICHSUTONKHO AS T ON M.MonID = T.MonID

GO
/****** Object:  View [dbo].[BAOCAONGAY]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAY]
AS
SELECT	
		CAST(NgayBan AS DATE) as NgayBan,
		SUM(TienMat) AS TienMat,
		SUM(TienThe) AS TienThe,
		SUM(TienTraLai) AS TienTraLai,		
		SUM(ChietKhau) AS ChietKhau,
		SUM(TienBo) AS TienMTienBoat,
		SUM(PhiDichVu) AS PhiDichVu,
		SUM(TongTien) AS TongTien,
		SUM(TienKhacHang) AS TienKhacHang
FROM BANHANG
GROUP BY CAST(NgayBan AS DATE)

GO
/****** Object:  View [dbo].[BAOCAONGAYKHACHHANG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAYKHACHHANG]
AS
Select 
	ISNULL(MAX(BanHangID), 0) As ID,
	CAST(NgayBan AS DATE) as NgayBan, 
	KH.TenKhachHang,
	SUM(TongTien) as TongTien
	from BANHANG BH Inner Join KHACHHANG KH ON KH.KhachHangID = BH.KhachHangID
	GROUP BY KH.TenKhachHang, CAST(NgayBan AS DATE)

GO
/****** Object:  View [dbo].[BAOCAONGAYTHE]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAYTHE]
AS
Select 
	ISNULL(MAX(BanHangID), 0) As ID,
	CAST(NgayBan AS DATE) as NgayBan, 
	T.TenThe,
	SUM(TienThe) as TongTien
	from BANHANG BH Inner Join THE T ON T.TheID = BH.TheID
	GROUP BY T.TenThe, CAST(NgayBan AS DATE)

GO
/****** Object:  View [dbo].[BAOCAONGAYTONG]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONGAYTONG]
AS
Select 
	ISNULL(MAX(BanHangID), 0) As ID,
	CAST(GETDATE() AS DATE) as NgayBan,
	SUM(TienMat) as TienMat,
	SUM(TienThe) as TienThe,
	SUM(TienTraLai) as TienTraLai,
	SUM(GiamGia*TongTien/100) as GiamGia,
	SUM(ChietKhau) as ChietKhau,
	SUM(TienBo) as TienBo,
	SUM(PhiDichVu*TongTien/100) as PhiDichVu,
	SUM(TienKhacHang) as TienKhacHang,
	SUM(TongTien) as TongTien,
	COUNT_BIG(*) AS SoHoaDon
	from dbo.BANHANG 
	where TrangThaiID=4
	GROUP BY CAST(NgayBan AS DATE)

GO
/****** Object:  View [dbo].[BAOCAONHANVIEN]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAONHANVIEN]
AS
SELECT 
	0 As ID,
	GETDATE() AS NgayBan, 
	'' AS TenNhanVien,
	0 AS SoHoaDon,
	0 AS SoLuongBan,
	BH.TongTien As TongTien
	FROM BANHANG BH 
	WHERE 1=2

GO
/****** Object:  View [dbo].[BAOCAOTHUCHI]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOTHUCHI]
AS
SELECT ID, TenNhanVien, CAST(ThoiGian AS DATE) as ThoiGian, ThoiGian As ThoiGianFull , TenLoaiThuChi, TongTien, GhiChu, Thu, Chi FROM
(
	SELECT ID, TenNhanVien,NgayChungTu as ThoiGian, TenLoaiThuChi, TongTien, GhiChu,
		CASE
			WHEN L.LoaiThuChiID = 1 THEN TongTien
			ELSE 0
		END AS Thu,
		CASE
			WHEN L.LoaiThuChiID = 2 THEN TongTien
			ELSE 0
		END AS Chi
		FROM THUCHI T
		INNER JOIN LOAITHUCHI L ON  L.LoaiThuChiID = T.LoaiThuChiID
		INNER JOIN NHANVIEN N ON N.NhanVienID = T.NhanVienID
	UNION
	SELECT 
		B.BanHangID As ID,
		N.TenNhanVien,
		NgayBan AS  ThoiGian,
		N'Phiếu thu' as TenLoaiThuChi,
		B.TongTien,
		N'Bán hàng' As GhiChu,
		B.TongTien AS Thu,
		0 As Chi
		FROM BANHANG B
		INNER JOIN NHANVIEN N ON N.NhanVienID = B.NhanVienID
) AS TC

GO
/****** Object:  View [dbo].[BAOCAOTONKHO]    Script Date: 2/6/2015 3:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BAOCAOTONKHO]
AS
SELECT  
	
	CASE
		WHEN M.DonViID = 1 THEN  'Cái, Lon, ...'
		WHEN M.DonViID = 2 THEN  'Kg' 
		WHEN M.DonViID = 3 THEN  'Lít'
		WHEN M.DonViID = 4 THEN  'Giờ'
	END As DonViTinh,					
	M.TenDai As TenBaoCao,       
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongTon, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongTon, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongTon, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongTon, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongTon, 0) AS DECIMAL(10,0)) 
	END
	AS SoluongTon,	
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongBan, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongBan, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongBan, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongBan, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongBan, 0) AS DECIMAL(10,0)) 
	END
	AS SoLuongBan,
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongNhap, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongNhap, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongNhap, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongNhap, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongNhap, 0) AS DECIMAL(10,0)) 
	END
	AS SoLuongNhap,
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongChuyen, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongChuyen, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongChuyen, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongChuyen, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongChuyen, 0) AS DECIMAL(10,0)) 
	END
	AS SoLuongChuyen,	
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongHu, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongHu, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongHu, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongHu, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongHu, 0) AS DECIMAL(10,0)) 
	END
	AS SoLuongHu,
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongDieuChinh, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongDieuChinh, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongDieuChinh, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongDieuChinh, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongDieuChinh, 0) AS DECIMAL(10,0)) 
	END
	AS SoLuongDieuChinh,
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(T.SoLuongMat, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(T.SoLuongMat, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(T.SoLuongMat, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(T.SoLuongMat, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongMat, 0) AS DECIMAL(10,0)) 
	END
	AS SoLuongMat,
	M.MonID,
	CASE
		WHEN T.DonViID = 1 THEN ISNULL(BN.SoLuongBan, 0)
		WHEN T.DonViID = 2 THEN CAST(ISNULL(BN.SoLuongBan, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 3 THEN CAST(ISNULL(BN.SoLuongBan, 0) / 1000.000 AS DECIMAL(10,3)) 
		WHEN T.DonViID = 4 THEN CAST(ISNULL(BN.SoLuongBan, 0) / 3600.000 AS DECIMAL(10,3)) 					
		ELSE CAST(ISNULL(T.SoLuongMat, 0) AS DECIMAL(10,0)) 
	END AS SLBanNgay,
	BN.NgayBan	
	FROM	dbo.MENUMON AS M LEFT OUTER JOIN
			dbo.TONKHOTONG AS T ON M.MonID = T.MonID
			LEFT OUTER JOIN
			(
				SELECT CAST(BH.NgayBan AS DATE) AS NgayBan, M.MonID, SUM(CTBH.SoLuongBan*KTM.KichThuocLoaiBan) AS  SoLuongBan
				FROM CHITIETBANHANG CTBH
				INNER JOIN BANHANG BH ON BH.BanHangID = CTBH.BanHangID
				INNER JOIN MENUKICHTHUOCMON KTM ON KTM.KichThuocMonID = CTBH.KichThuocMonID
				INNER JOIN MENUMON M ON M.MonID = KTM.MonID
				WHERE ChoPhepTonKho = 1
				GROUP BY M.MonID, CAST(BH.NgayBan AS DATE)	
			 UNION 
				SELECT CAST(BH.NgayBan AS DATE) AS NgayBan, DL.MonID, SUM(CTBH.SoLuongBan * DL.SoLuong * DL.KichThuocBan) AS SoLuongBan
				FROM CHITIETBANHANG CTBH 
				INNER JOIN BANHANG BH ON BH.BanHangID = CTBH.BanHangID
				INNER JOIN MENUKICHTHUOCMON KTM ON KTM.KichThuocMonID = CTBH.KichThuocMonID
				INNER JOIN DINHLUONG DL ON DL.KichThuocMonChinhID = KTM.KichThuocMonID
				INNER JOIN MENUMON M ON M.MonID = DL.MonID
				WHERE ChoPhepTonKho = 0
				GROUP BY DL.MonID, CAST(BH.NgayBan AS DATE)	
			) AS BN ON BN.MonID = T.MonID
	Where SLMonChoPhepTonKho > 0

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
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (33, N'LC6', 1, CAST(0.8410528934 AS Decimal(18, 10)), CAST(0.2070171919 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (34, N'F1', 1, CAST(0.3725490000 AS Decimal(18, 10)), CAST(0.1110000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (35, N'F2', 1, CAST(0.3725490000 AS Decimal(18, 10)), CAST(0.0130000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (36, N'F3', 1, CAST(0.1715690000 AS Decimal(18, 10)), CAST(0.1110000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (37, N'F4', 1, CAST(0.1715690000 AS Decimal(18, 10)), CAST(0.0130000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (38, N'T1', 1, CAST(0.1176470000 AS Decimal(18, 10)), CAST(0.7870000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (39, N'T2', 1, CAST(0.1176470000 AS Decimal(18, 10)), CAST(0.5910000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (40, N'T3', 1, CAST(0.1176470000 AS Decimal(18, 10)), CAST(0.3950000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (41, N'B1', 1, CAST(0.5049020000 AS Decimal(18, 10)), CAST(0.6670000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (42, N'B2', 1, CAST(0.5049020000 AS Decimal(18, 10)), CAST(0.4710000000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (43, N'B3', 1, CAST(0.5933899725 AS Decimal(18, 10)), CAST(0.3179799426 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
INSERT [dbo].[BAN] ([BanID], [TenBan], [KhuID], [LocationX], [LocationY], [Height], [Width], [Hinh], [Visual], [Deleted], [Edit]) VALUES (44, N'Ban Moi', 1, CAST(0.4029209621 AS Decimal(18, 10)), CAST(0.3194842406 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), CAST(0.0735294000 AS Decimal(18, 10)), NULL, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[BAN] OFF
SET IDENTITY_INSERT [dbo].[BANHANG] ON 

INSERT [dbo].[BANHANG] ([BanHangID], [NhanVienID], [BanID], [TrangThaiID], [TheID], [KhachHangID], [NgayBan], [NgayKetThuc], [MaHoaDon], [GiamGia], [PhiDichVu], [ThueVAT], [SoPhut], [TienMat], [TienThe], [TienTraLai], [ChietKhau], [TienBo], [TongTien], [TienKhacHang]) VALUES (1, 1, 22, 4, NULL, NULL, CAST(0x0000A432010BE804 AS DateTime), CAST(0x0000A432010BF18A AS DateTime), N'HD-01-000082', 0, 0, 0, 0, CAST(500000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(500000.00 AS Decimal(18, 2)), CAST(500000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[BANHANG] OFF
SET IDENTITY_INSERT [dbo].[CAIDATBAN] ON 

INSERT [dbo].[CAIDATBAN] ([ID], [TableWidth], [TableHeight], [TableImage], [TableFontSize], [TableFontStyle], [TableFontWeights]) VALUES (1, CAST(0.0735294000 AS Decimal(18, 10)), CAST(0.0938086000 AS Decimal(18, 10)), NULL, 14, 2, 10)
SET IDENTITY_INSERT [dbo].[CAIDATBAN] OFF
SET IDENTITY_INSERT [dbo].[CAIDATBANHANG] ON 

INSERT [dbo].[CAIDATBANHANG] ([ID], [PhiDichVu], [ChoPhepPhiDichVu], [ThueVAT], [ChoPhepThueVAT], [MonTinhGio], [SoPhutToiThieu], [KhoaSoDoBan]) VALUES (2, 5, 0, 10, 0, 1, 15, 0)
SET IDENTITY_INSERT [dbo].[CAIDATBANHANG] OFF
SET IDENTITY_INSERT [dbo].[CAIDATMAYINBEP] ON 

INSERT [dbo].[CAIDATMAYINBEP] ([ID], [TitleTextFontSize], [TitleTextFontStyle], [TitleTextFontWeights], [InfoTextFontSize], [InfoTextFontStyle], [InfoTextFontWeights], [ItemTextFontSize], [ItemTextFontStyle], [ItemTextFontWeights], [SumTextFontSize], [SumTextFontStyle], [SumTextFontWeights]) VALUES (1, 12, 1, 10, 12, 1, 10, 12, 1, 10, 12, 1, 10)
SET IDENTITY_INSERT [dbo].[CAIDATMAYINBEP] OFF
SET IDENTITY_INSERT [dbo].[CAIDATMAYINHOADON] ON 

INSERT [dbo].[CAIDATMAYINHOADON] ([ID], [HeaderTextString1], [HeaderTextString2], [HeaderTextString3], [HeaderTextString4], [HeaderTextFontSize1], [HeaderTextFontSize2], [HeaderTextFontSize3], [HeaderTextFontSize4], [HeaderTextFontStyle1], [HeaderTextFontStyle2], [HeaderTextFontStyle3], [HeaderTextFontStyle4], [HeaderTextFontWeights1], [HeaderTextFontWeights2], [HeaderTextFontWeights3], [HeaderTextFontWeights4], [FooterTextString1], [FooterTextString2], [FooterTextString3], [FooterTextString4], [FooterTextFontSize1], [FooterTextFontSize2], [FooterTextFontSize3], [FooterTextFontSize4], [FooterTextFontStyle1], [FooterTextFontStyle2], [FooterTextFontStyle3], [FooterTextFontStyle4], [FooterTextFontWeights1], [FooterTextFontWeights2], [FooterTextFontWeights3], [FooterTextFontWeights4], [SumanyFontSize], [SumanyFontStyle], [SumanyFontWeights], [SumanyFontSizeBig], [SumanyFontStyleBig], [SumanyFontWeightsBig], [TitleTextFontSize], [TitleTextFontStyle], [TitleTextFontWeights], [InfoTextFontSize], [InfoTextFontStyle], [InfoTextFontWeights], [ItemFontSize], [ItemTextFontStyle], [ItemTextFontWeights], [Logo], [LogoHeight], [LogoWidth]) VALUES (1, N'', N'', N'', N'', 12, 12, 12, 12, 0, 0, 0, 0, 10, 10, 10, 10, N'', N'', N'', N'', 12, 12, 12, 12, 0, 0, 0, 0, 10, 10, 10, 10, 13, 0, 10, 13, 1, 10, 14, 1, 10, 12, 0, 10, 12, 0, 10, NULL, 50, 50)
SET IDENTITY_INSERT [dbo].[CAIDATMAYINHOADON] OFF
INSERT [dbo].[CAIDATTHONGTINCONGTY] ([ID], [TenCongTy], [TenVietTat], [NguoiDaiDien], [DiaChi], [DienThoaiBan], [DienThoaiDiDong], [Fax], [MaSoThue], [Email], [Hinh], [Logo]) VALUES (0, N'Cafe Vuông Tròn', N'Vuông Tròn', N'Nguyễn Thị B', N'15/3A Thành Thái, Quận 10', N'(08) 3999 888', N'0909 999 888', N'(08) 3999 999', N'012345678', N'Không có', NULL, 0x89504E470D0A1A0A0000000D49484452000001000000010008060000005C72A866000085254944415478DAEC5D07601CC5D97D7B5557249D24ABBA48AE187730D5046C0CA1834D2F064C0949280935242121988410420810DA9F420B102085840E060CC634535CB0716F92AB7AD749BAB6FFCC96BBD9DDD9BD3BE9548C3D20DFEEEC6C9BDDF7BEF77D5356C0FE34E8D3EEAB0BA78A22A691C55922500151A4BF5212950511A2769DFC0ADE5CD8C89F2817907E05A71BF6DCE2785EB8B91A62B84B5A57F78D743421DAD14AD6C578BEFC9B3807B3BE52A47F2256929CC5132EBA6D95D5BDF8CFB84DC4FE34689230D017B03F1953CDB54514F0B340014FC04E7E03343F8E1C0580360264C1932B015A063B29E660009E28AE5B3012467CB3A8292611442CD4A5904233C24DD564B919A1A61A657F9524C8AB64B7C1E670C1E6747D26903F4F5EE9C2A1479CBA96395C88FCB52ABFE27E3218F8B49F000641AABFAE3897206116599C4BF034976023A06E5341691B3202B69C6209F4F45703721D68D9FD125067F29985548880772C5A3ED25A43FE1AC85F1D218A5A845BAAD1EACCC79EB017BB3AEDD8D5E5405BD4DE1173657F35B5D4B36EE6C411EF570CF153426841820CBAF713C1C0A5FD043040A9F1C725B932D825C0CF8D6F5080672F2897415F30425A36005C93219A9281649D89058F1270AAEB5A708B89735225E1CCD2ECAB399E405E179B1DEA6B2390E51678D11471A03164435BC4869D7B6A505D5D1DFF13B5178A92DCACE5E38A73BE387DDAB0F7470EF1AF2159F5D8AF0A062CED27803E4CEDAFDE1DAF5FF5C56EBEBE644E02F8885B7A50DFBC781C6C25E48F009E05224DA20ED9EA62ACA546F2E123F555D2AFB44EF2A354BA87BB15106B7D79E968713F5E0B7455D28348797B6E8954DA9157065B961FAE923188790268CA2A434DB71D4D611BC231FEBDD3E38442218904B66FDF2EFDB6B5B569B68F29C85A5E5E9CF7E6B5B30F78110955D042EAAA7BA09FDDBE92F613401F2405F86EF29743FE9CB10D8B8BC5EAF5672212BE18348807A5E209E86DC326C33E6C0A04627DF549673C116BA842B4613BC460B304F4688BE287C7CB8A0CC8A109E2E9D759CB2F1A7E45C9BA5312A0165F20BFDF448AB0B4C58F55CD4EE958797979F0F97CC8CFCF47494989F407E6BCBCD4D0D080CD9B37A3AAAA0AEDEDEDF17CBF131DA387F83E3C7E4AF9BF8E1A5BF431C9DAB99F04FA27ED27800C27027E0AFC5CF237E4A595D5A7AFDADD7AF2ADC5EB677A83B500B1D0928A26A017146B1F4F3AE75C8ACC13B0C7A4BF2AC45A6B35D65C5934587428E03603BE7E5DD4EF6BB311C0BB21B83CE87605F07E530E3E6B70A1A1DB16DF579FD43C4A06C5C5C5714270B95C86720E4144B64344D5F62A4919E435AC492894580C8707DA167B426DF74D38E3FB6FEE7707FA3EED27800C2605FCC35F5F5175E992ED9DE73605C3E369FE2DA3EB71A0AB09B6B209B00D9D4C2C7F16777FB1B546067DCD4609F8F17C4E008E0F7CA6A90E8C9CD7C9FBC43E3A22101CB079FCE8CECAC7A2C65C2CAA71231861AE4F077E769D5DF6D8450CF54470D8881C1C38760CB20B4BE1CB09C015252E4A34A2B92FDAC2D051B90AAD9BBE905A17A2B12822DDDD88C5A22BC9253D38FB7F9D7F1FE8E7FA6D4EFB09204389CA7E61D9BFAEBB77CFD85F6C6C73C4F57C616121AE3A7A34C61712D0474386FD28E8633B5743ACD90474B6C879F17FE40543E08EA7022CFD7C0B054097A9DCB713ABEFCEC2FB1D65786D8F0F9D51C114E0FAF5619E28C6F8C318EB8F60A83388EC7013B955A56F81721E9BDB0767F12878464C86335092B833E6BEBA6AB6A169D50708D654B2F75249CA2D38FE7F5DFB89A00FD27E02C840EABC79E81CF2A23E08B7BFE291860958D19A858A8A0A4C9A3449F293C7F94218EB6C8A1380186C81B86BB5047C15F4C99246FEABC066F20CE0060C7101699B3ED847ACBE90E5C74E61089EDC11C08EA0DD12F86ADED44058FA1B9BD5819C4813B1E472C0915AF868384C7EA3A45C4C4B34CAB2DD97036FC53478474E23CB01439363A4BD094DAB3F40EB9695AC9B4288000BBEFBF27E22C864DA4F00BD4804F833C9CF02C86DF810DD7E7C36E44454171F2E015F4DF9CE288EF4D52356B58C58FA8DB2B5EF45B2043ED7CFD7F7E25388C046C1EFC3BB1D43F1E20E7F7CBFF87974E02F70C530BBB80BD3FC1DC88D344B569E4875C4C22105F0A229D1E84940B5FEAEA272890C7C840C34FD0E480A532258F53E2182AFD958C562C844F0E1403FFF6F43DA4F003D4804F8E5A0165F6ECA9392407C7BDB81B3B1CB558EAFDBDCF1B2B4296CCF9675B82AFC3A84963D3076D9E97962837E29FBF912F0A9E477014E0F1EAF198A4F1AE498448224B4D778407614B387B4638AB316B14848B2F232E8635A2B9F446DF04840CE9355012501FFB82360737934EE0E55048DC43568DDBA9239265E26FFDE70C22BDD5503FD3EECCD693F01A49908F8EF203F374069C317F247C036E1380839C4ED2716B5013958DAE24347470756AF5E8D9D3B77224C24F15307AC8540E53EB1987D91444B2260C048243FDC5E74BAF371F7863C6CB790FC05EE18AE286FC3585B1D91F89DC4E28720C6227120C774C7A72788F58204E8BE3667163C430F40EEA459B0FBF334D7D459B30D0D84083AAB2BD57D9BA9EB75E22BDD770EF47BB1B7A6FD04906252E4FED350DAF1E1C92516FF386D539E608318EEC6AF3EA8C5B66DDBA42CF5E5FDD9E83A8CC70E0804487D993480840E6CF4FA889B12CC1A82DFAE0F607B8779A06F4E5927CEC8DD4D40DF29597B31168E03D50AC8B1644A200921B004E2AF988ADCC9B3E02044C0B66EB46D598E86AF3F40A8BD45253D3A20E986935EEDDEEF16A499F613409244804FDBF41740B6FA52B28DFD8EF4C7261AD88B6DFA04B1FAADF8D5EE89D8D1E9D400EAC2616D38316B2B84EEF614CFDCF36490FEEA3291FC414F317EB3211F55CC65B0D739C227E2AA8A360C156B100DB6438C86B9D65A7FEC98617B064840398E7FE45404261F2B070C95FBA3C4D44848A069DD5296F0A85BB68010416A91D5FD693F015825BDD597E4FE9453A591776A923AEC547E45C0FFB1BC4E2CEC43F5E3B1BC391107A02FF7094541CCCBDDDC2F049038AF36E087AC6CFCDF9E61F8B0C6A1B936351D5D14C1BCA12DC8EA6E42B4B34D23F79391408CBB3D4542E0E4C574DB69D7E89C030E277F4C8C80FCD3D5B807359FFE97FC56ABAD1FB40D71EEC9AF757FDD7F6FCADE9BF613002719ACBEC32D5BFD91876ACAC5B67D29033F92E8B54A09E07F1D63F0CA1E9F065CE3B343F879C97A42001DC864203059929BFA6C88B9FC78A3B50CCF6C6306FBB0E02F0CE1FBA5BB10EBEE422C42484D13D54F4E02B194CA265305D62420CD71E07423FFE093903DFA204DAB47E3D7EFA39E2802A6FC82535E0BED8F0D2449FB09409708F8A742B6FA74020EBED56FD88EE8DAF788335A6BD89F12C0B258391EDA92ABCD272FE5331336F46920D02C51E9BFCD568A5BBFCE895F0B9B28F87F58B213B12E62F569845F03DC548277B02E9B941038F1832401454F5139F2A79F0C577E699C04BA1B7763D7E2E711A6B101F99C8B49F65C4204FB5D0293B49F009844C03F1FB21F29399B7A5F5F1A6D472C3E95FC664924F2B4DE558A9BD71A07C7FC71420D0AC37BFA3C10A849B4C92F2B17376F1886AA0E9B01FCC714C9E017BBDA25F0F3C1680DEC98460D242301BE654F351EA02784BC29B39037F9D8B8A6A2B181BA2FDF44F3E6956A8090B614CC3DF5F5D0FE002127ED27002511F03F457E2E9356E82C3BD3CF929BF69414ABDE88D8BA45C97BEE11C08964FFAB378E43309A001CFDBD7E4C1B0EB157F56F1C8058FF0F3A87E1B1CD3E03F8CB7D31DC317A173CDDCD86605F4C0F3A33806AF2CD7DFC98984CFEF79C309C79C5283AF24CB8F24AA1B683B66C598E9A2FDF96084139FE0DA7BD1EFA53BF55FC5E92F6790250FCFDC560253F05BF32602715ABAF4D0271037CB87BCF78AC6F9387CEAAC03B73681067F9FBA725404A848C3A1C01DCB261286ABBB48F9A5ED31FA6B5A13CBA076228C8B1E87C306A7C74431E8F04F8F2BE27F18018A72C90500AF993891A98321B2A09D000E1CEC5FF505C0229EB69420297F74FE5EF1D699F2600C5DF5F0C33C9DF5A83E8B2FFA6DC5F3FBE9FDB8FFFB68FC6CBBBBDBA406018BF28DBD06F8140D5FA3FBAC99BC853AEE7DC8A08CE2F20E027F72605FC184B6FF4E98D00D58291D33200C6EA278B016888C2BC93903579C8BF59C5E5440D9C05A73F20AD5305B0EB83E7D1413B0FC915B092FC3BEBB437C2FBE302D88709800EE0811CEC0B4851FE09C74BE3F4D544ADBEDAB4976EA204F055B41C7FDA9CADC9F7D863F8EBF8CDFD1308547CFF1FAE19863AC5FAABE02FCC12F1C769ADF0056B89C2091A40CA8FE88B4660834F02A906052DDD02CEF993C60E946BA0EAAD68C65CF8871D18A7D9DD9FBC84161A1790CB5312987BFA1BE17DBE1BF13E49004AB0EF696985CEA27BC445717F5F92FCABDEE8D5801D1A08AC7396E2A63545F23AA3021E9854D72F81407A0D6BA265B8E31BE3209F6BC7756176768DE48AE8ADBFC60530587D9EF54E331E9024BA6F452CD154BA1933E50BA6CC545C02B95CD3DA4F51F3E55B6AF96692358B90C03EDD5F609F2300A52FFF026925BB08F6E967C79BF87A2AF90D490904FE60FD18744412554C5FBCEF8FEAC04C775F0702E538C4237BCAF141B55D737E9F43C4B307EF262AA4952031A2E427B3CAC95B06ACE201A9BB026252F5C07705CCDD03EFB0F128997166BCF350CBE6E5440DFC572DD34CFE9975C69BFB2E09EC5304A089F453F053CBAF04FBE8D8FC186DDB8F64622A3A1980BFDD3D0EEB5AB581C0134BBA70695E1F07021502BA74C5304240D09CFFD461115C59B4431387507C63ADC4360D0A5A74D6E9812BC00BEC192D3BFF9C312608684512AE40312181B3E0A67D064899E09E6DD8F1C13FE4494B445909ECAB24B0CF10000B7EA178ACDCB947057F2FFC7DB344E3002FB58DC27F776AA7FF3A30278C5F0EDDD4A7814059FE97E257ABFD86A6BF3F1ED48E91A836B8203CE05BC503AC9A0993B90231D1C272732CBB6907A1240141368F3EEBE1275C2E751C525B08AA163E11270192356BCE3E4802FB0401046F1AFA942028E01F3A19F6A9A7C6B745BF7E439A9D27D38912C097D1117870A33F91A780F1F9295BFA76683039F73F1B87E39F950E4D3E0DFEFD65CA6ED3731BE478AAAE000B6CB63CE30E987615360BF265202018935674C1C1436937E283A5FCCEC6DDA87AFB4965FA3251520273DE8CEC5324F0AD27808E9BCA08F885CBE88DB2E0CF44B0CF2A512BDC91558CEFAF3406027F79401326D876F559209012C0ED5BCBB1A6D996C823E73FB6248A1F0FDD61A93EB8404CE20A98F9F871956001ECE41D84D2EF266C5401DA7D4B66CC450E2101BAAD4B4F02222181B7F61D12F8561340C78D6592E5270460007F74E9F3DCBEFC194B8A1F7EFDC651F16638E9DCE40D3C7B5817CEC9ADECA338801C7FB878550582116DF3DF75E3C338CEB7CBF2BC96C0376D15E8654090B5EC86BCCCAA00B53C0D0CCA2420CAEE00218188DC6B50520273F71112F8D61240FB8D657710DC2FB051F0139F9F46FB69EA17F04B4906E29FEB4663499D4BA300A6E787714BE996BE890310E269770670C9F232CD39E9F203D3835CFF5F9FF8AD028C254E59C2B3FB9883B57F54803E2E912001BAD6B67D2DB6BFFF82B451949B082B08097CEB3B0B7D2B09A0EDC6B2F9E4C69E96C09F9388F6F71FF8E544A5F89B1D1578B6521B08F4DA453C31695B9FC401A8EBF14DA414B7AF32F6FE7BF9883D299DD3E8C7737AE9A5A40278C01B1815A02E4357BEE4484202630E92EEBB79F372ECFA38DE4428F5183CF35B4E02DF3A0268BDA1740E91FC2FDBE81778E857740708FC345130560A65F8F99ABC449E02C67B2635A142CC7C87204A3ADF44CB70FB4A97E67C3400F8B749DB53561D7DAE0298E5A44D819954011CC2289D2193005D6F5CF329AABF78138AE7B09810C0B1FDF6C20C40FA561140CB0DA553C90D2D26963F607365C171ECD503067E292971802BBF198920F3A10DFA7BF5D82ECCCADA9EF138002580171B87E1C5AD764DFEC4400CBF1DB323E5F3250F02A6190B605B0438C74ED9258039E9A433290974C7A381C1DC31074BCBBB3E7E89A881154AFF083C78E6DB911BFBF7C5E9BFF4AD218096EB4B6977BE4A62F90376B7070EA57BEF80815F4A721CE0BEDDA3F155A3DC24A792C0CCA230AE29DE96F138002580171A86E19FDBB43D0027E589691180BC1FA7698FAB02AC5B0412042148B313C1E9922750D5EFA34A7455BA47A3CA4746220AA1F0FB0DA4DB3B904B28E4BFA1B32E847FF804E9DEB7BCFA303A1B6BD400E26567BD1DFD567E90E45B4300CDD797AC20967F1AF5FB9DD34E856DD814293FBAECA53E6BEA4B255140BED15E2EC501D8A0DC10770C8F4ED89EF138809E00D473CE2E8DE1FA613BD32300246B11102550C728A81D2E79D661538B2DE7090E27D6760720D89D1A60AABE3994F2746DB8BB1BCEEE16CD67C6A0211D41FA304938D48D68441DD3904C31981382CDE9C68813AF803BAF541A45B8E5D547E4998745B98F0021816F5DCBC0B782009A7E5CF21401FE65D4EF771C70341CE38E96F2FBAA934F3A89C601D6C6CA70E75A65BC0143028F1CD48CA248F2A87C5AE76308803DD7F923A3B868C8AEB45D8E8475266A8690AB682740874D92F1EAFD8804FC417B0EB674BA501B046A3B457484816DF45464DF6D6D903E32AAEF95A8AF0FFD3ABBEC758818E197014C7FE9FA701F906FEF4689D0A2F6E8939582440AA1B87248AA08902009FA5D828AD3AF81D39F27350F6E7EF55195902AC93FD308097CAB82827B3D0134FEA8643E792FA588BFA3741C9C879C237D82BB2FBAF7F628297180F35754185E761A0738D6939E2C4F966402181A8F01A8E7BC60542C4D02A051549B0C7845AEC788D56EB767636BD08DD58D226A086F51C07FD3941CDC5640D7E7F5E45894140AB2647218EB0B61A4BD495206AA5B41DD8908550A841CE867C8D998849E10DC79C544095C093B21EF86B59F60CFE76FC9658097CF7E3B7A66C61ED620487B350134FCA8440EFAD988DFEF0DC075CC951283C7E8873757BD31D097A724390EB0A06A14D6B668FDF299C5615C575295D138004B002C50921380027807F5CF95EB24CB5B423958D5ECC42A02F8ADADD4BA27AE9FBD17C375A408E6BE3C165508070444F2074CC9E946577BB34402B1480C111A1B52663E06C755C8193D0D65479D2D2D6F7FFF39B456AD535D951BCE5E18FDD64C2DB697134071DCEF7753F0E716036D3572D02F23A3FA3293A43840DB08FC7D9BFCAD8078D39C3B86C726EDCC681C809EEBF97A4A00364DFEA4BC18EE1EBB8B211B3EE0B712C07FD64000DF0062E57B67D9D3B1FAFD71AC830A051C902B62724E08D9916684E914E8514206A10419B02E41F1A127236FC20C391EF00A8D0734D37C291E4048E05B110FD86B09A0FEBAE2070441B881FAFDAE89DF8563D4611022E4417EF254EFC7F36738C9FD014AF113655A6E294F79411F9BDE9AD138809E00D4F3D056807BC6ED02E8874C1C4E19F404F035B16CAC6A7561690D05BC80F670CF00996CBBBA5E914DFDF7782613F863F655FE51B7AE6DB4067F3AD7A5AE0FF70B9851222B035FA819A1AEA0D645902F0FE5275E016FC94874546FC5B6B79E8877123A6761F4A08C3CB0014E7B2501D45D573C5369EF876348395C33E6812ED3883F6A072EE26F9A9438C0FCAF874BFDF3D917F2B251219C9693B938002580579ACBF0C446AD0B30291FF8DD0462D6C5A864E557B538F1DE2E410AD0C5F7EDA5351EA9809B9E8B226562BE0CA20A4F0859E156C4C2DD095FDBA4EF00AF9D9FAED30F8274BB72B1BDCB29E5AF23EAA42322A28A5C7F559BC80D32A64A52070D11302510C141DE46221CBBA47881DAB240CF3BF69C9BA40945F67CFE06EAD77EAAF62358404860AFFFF0C85E4500EDAFDE2D04DF7B2C17D13091FEA8B0BBB29035F37BB0F9F210DBBE12E286C510622122A7A5AE26037DB94C92E300F7EEACC017F5DA0E3A871644F0D3E1998A03C8E7591D2DC36D5F695D80220F7078A188A5B5404DB07796DD47403E2A47063A057DB12B8C72470B44FAE970511B6D076DAAA31F1B913E2B4E6536F339714E3F005E3BBF7476E993E64ED96D912F44398E00812899B03B07555D6EAC6F12B18EFCD16F1F064DD48CD93D7AC87D7D779880C30A42F0869A10EAEC945481B76C0C86CF9E8768772736D3A6C1B666F5494D3B672F7705F61A0220E0A70E744EE727CFDD2D44BABF479B9E5D071E0B67C521C4143462EBD2B74147FD95DB8869202F1B3711EB2744068620A8657EBD75389EDEEA4AE491978E36673D7BD0AECCC4016C0EA23472B03A5488DBBED48E40E42DA7BA8D827D723EFD1330CA1742115A21D22F06ABBDFDA86CA6D65D8AAEC74C87131B3AED70DAE28D1D8FCC96D53EFEE43EED3672EB722C43250E9BCB8DDDB15C6C6C7762791D510C4DB1A4F7CFE6CD28B5E194329908C29D41E44F391679E38F40BBEA0AC845171302D8ABBB0AEF1504402D3FF9297C71D9EE8B2B77ECFC23CD6BF10DC7ECD9B3110A85F0F6DB6FA3BD5D2BA12570D96318E18DA2C01545B9378203BD4194DB9B6482E86732A071806DA071806C03E8CC66E9492D259AEB40CED1EE08E095DD1EBCB829DA639F5D05FC14FA971B863F46747658B5EE0AD8A314CAB144AF400DB0531C1B0073E96F350D99B10D5FED92ACAA094A0A76D89558879D900155081B3ADC585E2B124288257519D4659908481D881D183AFB52D83C7EEC5EFA3AEAD77CAA96BBE1DC77627B6DABC0DE42007438DDE85BFEF3F5E2A66E0C713A9D38F1C413E1F7FBB16CD9326CD8B0215E36D94BEFB1C5303D2F84E9B9411CE2A9D791411F4ED5AD7E316875E2231DEAF59D5711C105F93BD27303E8F1D408BE12BD7F6557163EAF85340F603A56DFE794017F6431309500BED8D69650514ADD68016F65918DFE3D17CC718B6FAE16346303604E1606D2D1E409525DD9081908E4D74E7C7AA73F179FD6CBCA809241B2F786AE1F556AC799538B71C0774E23AE411BD6FFF3F7441974A8BD042B08090CAEC8738A69D0138022FD87DFF3CEE6BB36D5759C2FF56B9F340993274F464D4D0D162D5A142F9BAED4A5DD718F29ECC64943DAE00B37C9005466CACD7C92FDF387F78CC0077BB471800A7F0CF74F486DA8AE047C62ED05A7076DF66C2C6D72E3D52A1ACC4B4FF2533FFE0802F82387843123B7D50078BD32D2035B033206C4C9670ED6E7A71A07E08D06E40FF8311D1B409E814008D346C72210D544DD84567B004BEB1DF878770CF55DC95D842BCF9885393326A365C3526C7BFF7944C3F47D119F2604B0577E71685013802AFDBFAC6A3EE5F14FB73F1A8EC6BC3E9F0FA79F7E7A5CFA77747448657BE3E7523FFCA4E24E9C53B00784DE2144FB460DD038C0FBC1617864BDD3703DCFCD2024D4556BEE0630C0AF1673F0EAEE2C2CDA2DA0238D4097370EFA1066E4B4A6E50AF1ACB4D9B0607D20D07A1F18647C4A43794D55479221C2489C53909401B12F768128832C7CD51EC06BDB6D840844D377C5ED7663FE25F370F8886C843E7C1C4D55EBA59984A2D1E8B4F3DE89ED7501C1C14E00D4FA8FBAEB8D35CF6E6D0A4FA779D4EF2F2A2A92A4FFC68D1B53F67353F181CB7D51FCB0A20515B6863E5103F23C8145B8E433E367BA7F3A298C23DC9C9E7A0CF05775E66251AD1BEFEF16D226399A684BC0D34792FBEA6A8510EE52482E3597C328DFC5F4E605482510C81C27B53902ACE200FCE3F2148334485190DD03873B0B95B13C420476AC6F8A19EA90A651A3464946C8D5B60BF665FF447EB81E5DC1B62527FEE08E59FE336E1B4CCD4F49D3A02500C5FAE73CF9D9F60B966DABFFF3304F1863460CC521338E81AF7D17EABF7A135E84A4A8BF100D4BFD00A4BB21FE70873D07DB431EE9A31C554107F9B3635D8B431A93AF263362A0B3F55C52DE8159BE6A198C992401250E70D3DA5283643FB6348AEB87EE4CC40174C07FA1CA8D6F9A8494888CA6918463B6B51AB7DD3E2D8AA3BCD544E974219DE0278F00E2F100F00980A6E41F1AC95420904F40A97E3B40FE9FB808D435A04490E54165340F4F6F1450DF697C57CE39E71C0C1B360C0B172EC4A88E753836D008B72FFBCCC3E75CFE162181C1D30D35491AB4044013210157CBA2BFBE2F08C251B4C79F7FF6F761F306D0FDC933405B9D3426CD46E4BA8D3C18DA2C28F0BAB7AA89E4559107FA61A30F5F353A51DF6D8395153DB9A40BF38B76659804E438009DB0E39FDB1C9AF34933F64CA52D01EDC422D925E0BFDB14C08B952E43D09077BD6A30EF882260EEF030467943B8FC53AF3460872D4B837D7F98D44854407ACD8E29C9702B770046024848FE54827BE6138FA45C36E5390204D93D70B9E0CCF26279301F2F6E1635FD0AB2B3B371E59557A2A5A5054F3EF9240EC8B3E1E2F18E5527CD3D9F4E3EB9636F2181414D00DB7F30640EB9C097A5BEFEE553E039E80C44B67D81C8DAF7248B2FFF41FA156C82C5CDE88881FC7ED85688FFECF249444013CF8ACE2CECC63565992501B939B004372EF36AF3C9391F3CB41B23DD1D78AF9E90C436A7E693DE56E02F22E471E1181147E687901DA511FC4E493D3C575D847F6C325AF9DF1F12C114670D7103526F764CD70F377507D87D1905603A4B5046038166F1053372901581DB9F0DD13B04AFEF74E0DDED9178DD1F71C41138F2C8232515B066CD1A781D02AE3D7AF8FDE79F3CEBF76473DDDEE00E0C6E02F8FE906DB4C71F9DDE2BFB841F49C37CBB163D2A05AD54E0A74600BA5B66DACDFFD3508AFFEC484CDAA92782F9159D38359041774071032EFAAAC4306DF7C47C01B5C1587CC49DFE7AF479B427DEBC8A10267B5B0C013DD199851A47112EFBC818709C5C20E00F931B35DF074C96D22600B6C5C08C000006B07C8590CC6A279D258877DDF1F3269F24842E0876BB34CAD49995853A41760BB6B7C901C12BAEB802DDDDDD78E28927A47A2A0FB8EA5FBAED829964712B2180AEDEBF307D9B062D01547EBF60BE0DC2D314E059071E83ACF13311DEB804918D1F6B809F3E013089F69C73FB51290EC17D1B7350A73C2E3DE8EE98D88E89CE5A85047ADB3A40AE92B8010FEE1A263507A61AA464D78F1B0A5C544E27C2A03DF2D4560B5D145FF93CF87D5B0BF0DE4ED1406CBF3A18382ABB21E57BEA0D0118FD79FD72C25FB7B6D4E6CB315DD994E615E4C601CCAE93BC5F769B1C28F478B1A8310FAF6C8B1954004D571C33F6AE6B4F9FF130F60215307809E0AA0262FD05A9BF7FF609D749C37B3B89F5D74B7F9B14C195F3849EDC8D42021DAE7CDCB92E17956DDACD723321F0D8C1CDF075A6279B4DCFE7C9C1A2D6223CB4C6E87EB0E76513BD8633CA45CC29EB92647E02F8E6E0159D1E4905CC5FE2301C93C60B9E39260A3F6D7A4CE19E32410010ADFB02189A02610DFA642D01301C8B0DFE9A0502AD5482FC4B1541962F070DCE21788C60FE8C0B2F938EA9AA80A21CEFFAB76E3F97C60206BD0A189404B0EDAA82F8BCFE59630E8367F209E85EF93AA23B57659E0068624860C1DA1C54B51B836E871444F0B3F2DD6907CF12E7B0C7DD8E6FBAF2F17C951B6B1A4598597935D10E3BA7A7097CF69C54053CB3A700CF6D881ACE73E6281BAEAE684AC915E86F0248944D870092C51E5293FDE62A41CEA4BF0279675CFE6CF2800AF0956B328A0E3A5EEA97A2AA80CB8E9DFCF31F9F3AFD490C7215303809E07B051F1030CFA2A0CE39F13AE922838B1E63409F6102A04921815A5B016E5D952DCD69A7261594774E22AE806D777A2A8069CEDB1AC9C5E35BB2526ACEF349169FFC9575A60F7CF698E4BCED5945B874893D7E4FEC79EE984E5D81C6A4AE803178971E01C4E3014842009665D3F3EB7BD712C0BF2E30FBD00021ED40E4242E81EBC45BB0685313FEFDEF7F4BF535A13467F973379F750906B90A187404B0E57B053389305E4CC19C553E15DEE967A07BC56B88EC584D63773AF0CBA06789A0574921813591422C58ED33809436D5FD79E2CED4540003FC1AE4E085ED1EA9030F4DC9ACFE0563EDC4E277C21F69EE7DCF447A1DE49E3E692BC0AF971B839CD415786E9698D415308FC8270157BA0A40B7DDB22F00F758E66DFDD60460BE0DA2856AA02D05C425283DF83838A6CDC12FFFEF5FD85AB55DAAB37B2F3DF6F2EF4EAD78138358050C3E02B8B2E07F04CC73299673665F05DA02107CF751D9CADB8C563F1E04547E7B9D141FFD919D65585CAD9DC38FA66BC70631DBBBCB5A054844E24387338057F778F1DA76816B7DCDD67F711070A4AF2EAD287D2AF7B4606D1E3EAD8E19CE39A540C01FA7B5589E2FEDC0DEA0258014E4BEAE8C3901481BA55FBBC78F0917FE1C5B76ECC1CF9E780BC1888823C714BEF5D8D5A77D9F14DA4D08208641980615016CBEB2A05C903FEE01676139B28FBE145DC4FA4777AC52004F5BF0B4565F067F62391389CAE60E4F31AE5E966398C1A7C217C3FD079AC402183F7F5173019ED8EC8AF7D54F2BCA5F26E2A611E41C999C2C5471052E596CE34EFB75E64801D78E6C366DEED4833A9DEFF7F596004CE301BC6365A829102994D1BB0445071F8FA1879D8CA5AF3C8D479677221443F0C3BBE71F46366D19AC6EC0A022804D57E43F40407C03C5B17FFAE970958D47FB9BF76900AE97FD3221245441466E48099EBD585F827F551A23E8BF9EDC81490EE6BB7E8CDC5FDD1590FC7CB3A9B6D8F5D943217D21E7FD9D5AAB4C0727FDEB88FACC7E344471053E6ECDC39DCBF8D775CB540127151849207DEBCB6BA2B3DA2F0D02B03C6F0F0820ED96009624B4EB4E5F00079C7F2B9A567F88A6DDDB70DFCA180E3B60F8FDBFBC70F6A0ED1834D808A0898038402770C83BFD27E85EFF11421B96985AFB842B90A1402093641550841F7E95AB197147D3AC92287E5CB65D1A5023DA9D713FFFF1AD1E7C51A7ED62CC033F9DA0F3860343287674626BB70F3F5E6A24997BA6873099F6D6CBE4C7439518C7639501FC772B9F94FE728C0D639C5A12483F00673116007B3B0124D6F50440F3877DE72CF8868E41D55B8FC396538847D7BB3FFFD7CFCEA34D82BBF7138045DA7879FE1C02DE9729903D630E836FEA09687BE33EA9FD9FE7F75B11414692A2021EAF2EC11B3BB4B1001FB1D0CF1D520BDAF3AEC39E2DF9F9FFDC6A0D7C9A28F02F2CEFC6144F8B1CD5A7B3EBB8FCB86279A1619E3EDAE6FF83B23D19FF76A01A0FF8C19739D8D262744F68EBC3FD33B42490D487D6012379271C5DF06DB01380495320CF25F0959463E4C95761F3EB8F41EC0E2262F7A0AC6CE8F449C7CE59B19F002CD286CBF395E09F80BC93AE43B4BE0A9D2B5EE7825CAF04844C0702954455C036A10437AFF0CBEB0C507E3A451E4A4B67DFADEB8425F8695FFD0B2A42F86E5EB3AE394F1E1CF4D7DDA578A54ADBEF5F1ABA7B6843C6BF1DA8DE178D07CCFB00680F19496074C08E078E246E58582601917E62CB24A2AE360182D71C881E1080814C8CF1844C1100446DA010484212CA7AB2A0E0B8736E41CBF6B5A8FEEA1D6247686FCFD8CDE7BED97D7F461F6286D2A02080F597E5E512403753EC3A03C5081CFF7D747CF42CA20D55A6CD7D668A206371009A38C37755A0D09E7941C54D3603BFD4896778041795369836E7D1C1419F064BF0DB554EC3FE8F1C11C62821C36E807A5FC415D81CCEC34D9FC5E224C0DE032581076708F0111240579B4402EA366E208FDB04684606D604A0ED08641E5B489B0098F2CA29E26560757C3302D0EDA31E237FC291289E761CD6FCE32EF5382B2F7C4F1C94DF11182C04703D01EE8352F08F487F77D901687DE7114B6B1F073DB4FE7F26E3006ABFFD1738C37769B2B2FAB3CB447C6F94DC966F39B9884232E77D36241E9D578F35A702F8E1D0EACCBB01D279E578C0DBF5B9B877257FE28BD1011B1E20EE803FD404B18B288158244D10260729EB5BB3DD7735B23FE5D843CF0800C98ECFACF3FCFE84F597D71DFE00C69FFB1354BEF72C5AD44F8A01158404AA32FB107B9F060501ACBB2C6F0501ADF489AFFC937E84EE2D5F20B4F50B0DC893C9FEB8F5CFA41BA0F8CBDBC442DCF8B943B3C90CFCD4CFFFDEE82E8C76B6A6D87B4F7603FE58558A45BBB4C7A26EC0DF0F6BEC1337207E7F0C09F0062649EEC0518404BA551208A710D4B396EC2AE8D4D60115F4C9DD85812500E8CF013E01D0C5F2D9F3D0DDDE84DD4BDF5009E0064200836EF6E0012780B5F3F3CA095E2BE98538F38A9177FC0FD0B2F021A2AF5BB9B29F25023342C8881BC08C0F787C9B171FECE2035E5DA672FFCAB1611C9FD79876EF3DD90D28C66F561A49E6D12323186DABCDBC1BA0BBCF7BD6E760E10E6327219A46E5DAF0E05176F8428D320930318118C7778E316048809C91F4260AC0E022A4144FE81F0230F7FB596590580F8C39487203D6FDEB0F2A010C4A3760C00960CDFCC0F504AE0F5220674F3B01765F001D4BFFA3001C49FD7F799B520E19700398CE3C4BDBF3F1D07A77525FFFF411222E1C9182DCB73A277103CEF9245F9AD29B3DFEDC0AE2060CABE91B37207E7E9504B2F1F6763377802881197678C384043A290984ADFD7FA40AD814E309291FAFFF09009A7B91CBD1F903265E7C3B36BCFC103A1BAAD532818B1689836AFAF0C14000FF23709D4B415C70CA8FD0B96E09C2DB57C7816D25FBA55FF0DD801EA900A50B6FAD90873F6DF4624D93F554DB54A2DF363984518EA65EF6D957DC80CA12BCBB537B9E62728E678E68EE3B374073EF7EFC8E90C0C2ED4625A006061F204A807E2D47EC6C5362026980177A902175408303502E58536B0500921180F6DCE604206DE42A8211C7CD43FB9EADA88B7F4404971102F87BDF3DC4F4D38012C037970672C94F3305AF33AF08F944FE37BDF60769761B5B9C0074B21F3C25A0FB458208524A8CD57FB57E08FE59E98C5B629A78BE314D23B345FC69726D46FAECAB6EC0AF57D80DE77A6C46B46FDD80783D2824B0CE6FA904EE9F21BB03B14E263088342D34D224801EA8818126805CE206E48F3D189BDF7C5C3DDFD3840006D5F703069400565F1A88CFF9E71D7B18DC45E56893E4BFC0805F1FED37C603E2E5D00315C058FD8788D5FF2689D5D7AFBF368300B32B0383761437E0EC8FF3347DF5699A3B52C0D57DED0668EAC38FBB2909542514879E047E7D981D45B126C494264216186AF918073C71C099FAFF3D5403488F005490F6DE05900FC43B366D0D38F0DC5BF0F593BF50CB56120218D9B70F30BD34A004B0EA92DCA708882FA360CD9F7529BAABBE4688C87F9B025CAB38403C1FFC20605215A0F1F50BF0F07A17D7EAABCB54EED7761AB73D7E64178AA39968AB97DD80FBB615C7DD00F53CD40D78F6C896BE7703D4FBA524E0F21112A0EE40944B7E7EA7803F7EC78951764A02569D8552F0FFA1051F1B30549753066B1A04C023AD4C1200FD1D3BE75AEC5AFA3ADAAB2BD5F34C232430683E2032D004204DFB45415A7CEEAFD0F4D6431099E8BF26C06722F3F9F23F890A6086EB3EB4D187CFEBACADFE05A34569728EAB960806EB7CF7F42826D38141FA0F7AF4205137E0938E22C90DD05FC79FBF23F68F1B00E525A704E9A231017325E02324F093831D9891DD4CDC01450980077213FF1F3C5248C5CA4B5792F4F8B15408892903649E004A0F3F45FAAC78F58AF7550218547180012380AF2FCE959BFFE894DF85E5C839E84434BFF7374ED00F5C6B6F003F5254018AC4FD265480DFADC9E2CEFCA32E531FFFFA03BA30CAD52A4D27FEF3B505F8A6515BFE7787C630D99E190250DD80B33ECA2544A3BD263A7DD735C36BFBDC0DD0584585287F67A10468FAC9C14E1C9FDF2CC504A0890964C8FF8705192848E336476ACE333004E02BA940F1B4D9D84C3F292E57D7A08A030C2401CC8732EF9F7FE231A0937F0657BDCBB1EA30587B5E2B405215C048FE277616E2B59DD61D7B2E18C976E125687466E1671B871AA6F3BA90A8837985BB3343008A1BF087AD4578678776FE08EA063C37A3B54FDD00E38B0EE923259430FFB327078FAE4AB0A5BEBE4E1861C72DE38388116B178B7411351035052B57FEA38704C02303E53E6226604E7F3050E27ED32500BA36F5F2DF62258D03C887185471800123809517E73E454E7E994DF2FFE7A36BF3E708EDD9A8F5E7618C0398B70624E4BEBE4390CD4EC09EE597027DBF5BEB331DAB2F5B7D10ABDF2935ED25DAF465603EB0A30C8B7669DD858BC65002C8900280EC067CDD5D845B3E37BA250BA603DFF1F79D1B601AF916881220F5F7765D0E7EBF2CC4AD3B9A46E7DAF18719367843CD881A5A08ACFD7F16B8BD51036A7ECCEC981AC09B1014324B00A34FBA123B3F7F23D11F006260DE220C8AFE000346002BE6E5AC20409D26F9FF737F8AFA57EF350DEAE9DD00AE1A808E0C2841D8ED10E8D75FDD1E7CD131040F6F70594AFED3874771D5F07A6E9B3EB582FFA82BC30B5BB48382324D00AA1B70F1A739D267BDD86B3C61B80DB78EAEEB13378005967C7FBA179D7E518990C0967000377C14427B48AB50E23D22A5E0A00BE534381864FA0AA422FF0D655830F5AE0F00D01B026049D1782D8963F30980BA00DD6D4D68DCB442A96B711621800F33FA007B98069200440A58575E3172A79D84E625CF58B4F12369B49F05BE54864ED491E583E00DE0A92A3F5EDF6ED39C9F05566116B1FAE3BB31D9DD603E25964200CF6FD6E6679C0014B5F1D88E22FC778B56EAD3EEC6AFCC6ACBB81B60F62227D69517DE462EC02D93C03DCB23D8D29C1821A8AFDB1F4E76616E491BA2844C63E16E89087A25FFE365E42B4EBB0540B9514BC249810078E7072C0880ACE78C180F6FE928EC5EFAA652DFE20242007766EC01F6220D08012C9F9733539066FE15E0AD984248A0141D5FBF63F4EF756E80999FCF0E0396D689E41788B5AA770CC1BDEBBC9A8F7DE8ADFEE14522AE1F97BC1BAF4C00A58400B4D29C7E6CF3F7E3334900B21BB0395A841F7E6CBCEE9F4C054E0AD4F5FE0325EA71957FCC3BBD68C1204D94A2B4A0DCFE450C2B6BC3DAE331F57B649903B74CB5C1136A4224D8CEA801A3FCB7065DBA6DF8E64D804842000905644100EA36F001AF5FA713DB561C370F9BDF7C42A973F16542006766EC85E9451A1002587651CEF504A70FD2005EF6A463106DA94168F746ADAC3744F5F99D7D58F92F5B7E076C59D9581B2DC47D6B3DA66DFB743CFF956342290FDED113807AACBE2000D50D9847DC80EA0E6D8FBCA34AEDB86B526BCF3F50A2BF2FC38B9F02195012B013D78ABCD88F6DF212A5625402F13E0C3E3B6E3EC88149EE66443AD94E43463F1BA2B6FD3FB91A3093EFD64D8048765CFD7D9B6DD3ED079813C2B839D762C3CB8FCA6520AE2404302806060D14014801400AD821C7CE47EB57AF68DBFFC1F1F30113F9CF94B13961F3F8F1766B09FEBED5AD3927FB72564881BE2E8CB237A6FCD14F9600F4C37FEF3DB03AB304A0B8012FD517E1B1D54670BD7A92007F775DAF8381A6E0975692495F48444095D6C2FA5CFCDFAA90D44782379A90E65D3CDE898B8677109720885888BA04B194E47FDAFEBF722331F63A61BE8F9982506A21630430FAE42B2505A01E9710C0808FC3A169402EE2AB0BB33F20409E2505004FBB1EF56F3E6468B7B7192CBCCE1560CA0AC4EADB1D6ED8DC1EFC6557093EAC357E11575D3E569DA823DC0C5B28F5917B94009EAB2D8DC700580590790290DD806A5B21E6BD6FF4B16F3DD821BB01BD08061AC0CFDC93953F6B008FCD21C55AB646F270EFF2083637F19B0A691A956BC74D07D9516E6B46B4AB9D547D244DF92F5F4C3A01402B77C6BC17A0953B60AE22605167C507CD46DBEEAD68AFDEA656780579B6033E41C8401180A85A78AA001A173FA38BF89BB5F1C3D81988BC80F4A30C5D59F9B86B5DE2BB7EEAC350139D6AFBF2D1211C97DB28F9CF422C44FE62290F186209803D6E5F1180EA06DCB83C1B5FD76BDD80D1B9363C7E447B8F838106EBA7649ABFE4490021D889DBE597E2028FAD89E19DCA103730A8A679440D5C384C550321C474B18194E4BF4EF25B0500012349B0F7641D0034BF1E581080BEAEF2C61C844877275AB6AF530BCF220430E02D01FD4E005F5E98AD8C0004DC4515C8227F1D6B9768E53DCCFAFC231E0F8883DF9B8D9DC4523EB0C187FA2E23F8D57EFC3F9DD8850A418EF20B0434F1E3406695641521134009FEB1499BDF6704A0B8016F371711CB1A36289917BF6B47492C7D372015F06B25AE9491DC3AD26642A2C2046716DE6DF0E3B1AF43DC8FA2A8CBA302440D4C73A0DCD1866877506A298845633D92FFFAEB339B07205900B0B70410BF16180980F608F4958C42F58A452A01DC400860C06708EA7702F8E282EC9904788BE989BDC3C64B11D2AEAA55DCA1BC0942D00603E5CE3D4E09FCBB08F8EF5EEB93BEE0A356B89AE8F28480889F1ED8015F888ED90F12F047349D84D4E321C9C8411E01A8AD007F9850D3070420BB01EDEE429CFE967168EED9631CF8514543CA6E00FBC25A823F99DFAFB7BC7A32B0392435502BE462C117D4258818AE9D5DBF78A21773CA637077C941C2983E48988EFC57EEC7AA0B3080B409C054F2A74100749DBA012A0190FF175CFCFEC037050E0001F8E793D33E4D019F336916C2759508D76F37809C1B0C84A20288CFEF20E0FFB4AB048F6FF1C68FAD07FF2943C3985F5A0B10EB2244BB15CBCF023F413082F28F5985B004C09E2731634FE60940FD36C1EF36E4E0ED4A6D735BB157C03F8F09A6E406E85FD6449EEE6535BCCC7A9FD6CA32326505DA014BEE76FDDC761F9E5DDB6DBC26A60E694BC1F7273971483621802EE21A44885B108972E53F17A426F2DFF4FA444E13A2E97DA5007853B7497BAC31A75C894D746E0079FBD38400067C4C40BF13C0E717F8EF20305B4001974B08A07DCD879683780C2AC06187C39383CF08F89FD86A04BFFAFBC371DD98E523E0A7925F94BBF326C0CE270130EBFAA412C0731BB52473F138019714F71101D073383DF8A87D88D4E6AEBFD7BB0EB7E3687FBDF5577DE51D74408725F8A17FA16121FDAD40435D34A206E867D1FFB8228C2DCDC60145ECFD4C2E74E0AA890E8CA06E814404C4F58930230C7B20FF0123902D0380FAFD2C15920EF07A92D2D58B4E012C2604706C9FBC3469A47E2780A5E7FB9F2256FC320AC2C2D9F3D1F8C133863EFE9A60209809401CF485CAC61B6D43F1CAAE2CA5F2B580A4EDFBB74FEA44B950077419FD7D15DC3C1200CCE30294009EADA10A40DBD4D5D704A00603CF5FE295BE1EC49EFBA472076E3BB09DDB274023F9610E7EFD4B9D78798D52DF52FAC3C42A5235E094BF9BF83C5503EB126AC08C0C8EAF70E3AA0936B8BB5B11216E5B341496E7203491FF2C61C5003E5158B406201939B075A5B9D7249D8074755676F829D8F5F91BFB3C017C404E3A8B023077F24CA20096E822FEFC60A08D5A7E02FEBFD78FC0A70DAEF8C351135D1E4238E1E6F1418C401D446241F8FEBE190920EE02C4B733652901DCB9A9189F566B5FDA3E27002518F8706501FEB3C9D8EBEE8D539DC80E6983813C7F5F2EAF25849E829FF57393595A351F763B6CE43EEA6D01DCB7228AAF6B43867B6197E99882B9E33CD23C0CAEEE1629821EA55D8AA3BADE843AF9CF23A954D4403AEE80E6389AFBB426009D0268260490D7472F4D1A6F573F279600F20F9F83962F5F318EE5D7ADD3413D54F63FDB309C80DFCD8D2A97FB815F4C6C87A7AB419ABA5A063F03701D0980EB0E40130760CBD23EF03F595B8C550D7A17C0864B4BFA920010EF1370FE3BC680DACF0E75E394BC7A29189878E1CCADBE9A9F2AF835D691398E959F0DCD7A8280A40A75BA617379B1A8DE873FAFEA965A0A78CF534D9408E68CCD9288C0D1D984703011284C5DFE6BC169461460CAA51B0F80EE1C3C174A2500F55C840006BC3350BF5FC067E7F99BC87B10A0EF4260D22CB44931007D7F7E16FC0E38BDD904FC23F09909F8C7E7C670E3B8366475C91FAFA01FDDD4F8FBBC809F494C40D9922008A5960477366E595784D50DDA73DF71880D4779FB96005437E0CA4FBDD8D4AC9D9D674CC08E278FEA84106C9107DC20017C6959C94800D83CCFCAD2ABE73397C34A793DF039965590D400EDBB1190622AFFDBD869191BA089060A2F38C08999796D440D04896B10264410D65C1B4FFEF3027756FE7FCA80E7AA1D134580FD04104F9F9CE713ED0AE07227AB414023F0E5413D7602FE1CFCA3D11CFCDF290CE3CAD23D527F7E311252C0CF09F2252501651D266A20CB8F6B5615C7BFA8AB5EC37D33EC98EAEC630250DC80379B86E09E2FBB35F74FD313B39D186B276E4FB7DE0DD0BE806ABEDE32C9CBA9839F3D8E3938A001963EB0061B71FA881A10881A68801F7F5C1EC6AA3AF35E84EA7A91D786EB0F7263BC5B21827048EA516825FFCD409DB6FF9F64DF640440FB02D09E80FB3C01D814DF3EFB8023D0B1E973EE241E7687DCD4F77C53393EAB77C5F7675F8CA30A43B8A268973429655CF22BE306D003129077D3AB01FA0FB96202C0933E2E325CC77D47120270F53501C86E409B4B7603DA7463F1CF1EEBC48F2B1A019E1BA0FCC3BEC06A7EBAE08719A00DBE314CC9430F48D849DDDA5DA47EBD5813F4E36FDF84B0A549DB3D9B4706930B9DF8D15427F2C55644BA3A091174211A8972AE2DB91A48CDFF67D6939E83739F500860CFB63829EC9304F0F1B95401C840CB2A2E47B876BB76FA2E50F03B25D9BF2C5286BF57FAE2FB6AC03F2484CB29F8BBDB2044A35C80436952848104B49385C6974DD40095E00291E0277F9867B88E6766C5501AAD93140858D2C8504AF8CF729F80DFAEF369FA04D06BA133F4BEF15DA20C183740DE9638066BF5AD09215DF01B098427FD0D2053CFA16EA793B7D89DC435F0E2837A2FFEB13E8C9A0E63FF067D73EF9C711E9C3FDA06475723E1BF76253E903EE0816404D0BB00204D940022E43D51670622691A2181019D21B85F09E0A3737DE5E484951454DEA20A095CA1BAEDDA79FF1C0E49F62F27E07FA68A0FFE1904FC9715EE24929758DD685463D18D565E3095FCFA602000AE1AA01D5AB6A108D77E6A37DCD3C2635B80CE16C9F548542A9F092C7B1A9A6488EC16A707CBBB87E0868F2206ABF8D3831D38395F9ECD4813FCD3815C0F7E56A21A8287BCC06112BF9F2DCB0391B94C57B6D3C1454E4204A4CE1737F8F1FCFA904404C90285574ECEC2D179ED08777620ACB805664A857BED26656171AD9601401302A0F9ED7B2AD5F76BD6BC45E2808E07E86F0298497E1653B07B8A5502A84A8CFD2796DF452C7FA5BD047FDA9413AF583651F0CF1FB253FA2005F43DFB74E03658FB34E2009A2060563656474BF0B3A5C6CE380B8FA93774C7B51A6064D6D750345280721E6685F60CA49F12FF30CB304FC0B442071E3C2428919128F5093003BEF6E554CF61CC4B0FFC0605C01CC3CCA2EA5585E67AC9BDD2415EA1AC3CBCBA8D060A83861603FDFB41DD82CB273831CCDE8A90E41674C789A0D76AA097FE3F4DDE9272E9779F258025E7786712002C96140091FF1498A1DAAA783B3F057F9DAB147FDA9C83CEA8C005FF2543764873D04319C96768CA4B93040CEBE0A801B71F4BBB4B71D7321974EA754D291070EF845AC5FF4F1C2059A5EA094214ADCBC7378B64472291FF5D3B048F7C6D0C06BE78820BC5311A0C0C6AF64B143197FC3CDF95EBCFC6F3794D8830008A27FDF9FB1B9BF024D78B361B3AB31072E7E2AF6BC2786F5B17536F7C32B870A21FA78EA0CD86D42D68232231923EE0D3F4FFB575CA2700C1E5869DDE4B7BB3FA9EED7B0400AA0008023C840022CD3510693F7D814E2EE3851828C3C39543B0B3C308FEE1DE187E5E5E856887DCEB4DDBC4973A0900305F677B000A096B4D5B005EA82BC1F3BA5E809329011C584B644CBBA62205C40F9076658B86159D365006089DF6867184E039635DB87664A3D4090ACCCB1E3F8ACEEA1BAC96B2C1340FD08055DD9ED4EF3791FED0ADF3958308810E30A26E81D38BEDD16C3CFE4D08AB2C3A12D154E4B3E3470765619C8BA881CE20710BBA94F1057CF99FD4DFD7AF5BDE2FAF1EB5F52FBF77FB18017C2829003A12509014401791FF76419EC3CF9D1DC05FEA466163ABCDB0DF309F889B4737C3D1B61B313A7D97D28A00A5072184C4E02168C0CF0F0C6AB7C7E1AA7109D83C81B8007FDB5D8257B669A3EF7346DAF083A135F27803A646CD2A3559658BC9F2E982D227E0F7F4DB7DBA71F7D4177EFDF86E8841D50D30037E0F0841C9480A7E769F14A53F98B256837EA4FE030E9714285CD6E6C7E3ABBB50DDCE99C095A99333C67971EE681BEC540DB4A7A90674F7CC5DE75D33C7FF37218069F306F83361FD4B0067CB0A40EA10462C19FD8084DD4EFC7E5F363EE81A81B7AA3D9AF2B4623DB46FFF81ADC8E9AE55BE3C13B5B0FC3D23014D5320278F2A80DBD617637563E2BA689A37CE8679450A01A83B9B556C0AEE816858E0AE4224327265A810372E315AC19F4E77E2C4BC0688A1607C472B90ABFB1909422B6D7B027EF6D8A9497FE5FA2C9483B44247837AFC0867E5E1B54A11FF58D3AEB9177D9DC86AC0237DEB21445D8248447B2F69C97FDD35F2DC289E4BC021807DAE1970F1D98A02603AFAB809F8773ACAF0C8965C4D59B5126F9BD086D2702DA234E817E5F5F0E393801ED0A6E3003465126A201E1BA0FF797CB87E75B1F44111F605BBFD103B8EC8AAD62A00B562758490ACD2CDAC3FEBB7C7739466C90B3ECC424D501B979856E4C0FD07072176322A80F392C6CF6911EC53CBB02FBD360F5C4B68DE8A6021ADD9F25CCBAC039DDD264D0367777BB083B8054FA4E0169C36DA8D8BCA3B11EE0A22D2DD455EA72817F0A6AD01866DA9FBFF7A02A0EF1AB1FEFB1A017888021016CB1D7FA83BEB8340FCFEDF6C1C2205FDD4CA53D325E5411CEADC8D48176DEE8B24E9D463D1B5D78C04C06BFED38E0C94A2D1DE004E5F12885F977A8DF71CE9C0147BB5DC1C890471A45AB9F18146A27539C366FADE64F9F0526D011E59D96528FFC2896E14456AA5CF74B1318454AC3E9710D2003F2B83F5604F26FDB9EB00973CD47EFF921A703861CFF2E2ED1A2F5E58D765F86809FBCC46061CB8769A1B2562B31C20345303F17B4957FEF3EA30716F8967BF2F12C0599E7240FE20286DEFF7E4E4E11F4D23B1BAD9A15450A2860E2FE8C685793B1009B64913775A0DECE9090968FBFA1BD5403C8F76557515E1CA8FEC866BFCD77122BC9DC405A0730C72AAD34204A49E440E01D0E4CA424756114E7F5D3BD906BDBEB3C7B971ED68F27207E580A916F8F241ADC0AF550AC6FE02EA6FAA3E30FFD8A9018BD77F20C621133A498CCB938D6647000FADECC66A450DF0C618789D02AE98E4C191791D08757620124AF4224C47FEA772EFD0E5C5DF8D7D910068FAE02C8F48C19FE5CDC166FB503C55656CEF1FE68DE19A922A69F4577C3C3FF80047324250CB404B029A9E7E6C59368FFE91976A6DAC14BFF83C6678995E9FD922496DB55582AD551E21F43C697D7129297D02EE5DEFC7424E30F085135CF074D6C9B100806B99B8F9CA3FFA48B7D6C2A5097E13B0ABE74B3AAE5E471E66B3FED0DE840E870B0EAA066A7D78715DA7460DE89FDFEC0A0FE61FE8802DD8882E29401836A8166BF90FF58E350A22515EDD974B00CD8400F6BDE1C094009CE40139F286E2B79B0B11D405713D76113F1ADD8CA2CE9DD277D5D3B5FC489104006B35A06EA7F3DBBDD15286BFADD5764B9D942FE06EDA04D895E804A46FDF370B049A55BC68BA6292E5F460559806038D936CDC7AA8172704EAA429B620C6F8C057329249FE1E813F9ECF013FBB4F0AD23F99F5D71FCFA64C19D742D4C0C3440D7C536B3E4BF1A83C177109B250241212686B955B09ACAEDDE2FE3579302700C5ED5C4C08E0580C70EA7702587C4EB6E8C9C9C5C2CE519AF9FBA58AA2F275582766B888F45723FE40E64800D0953151034A4129044008E05F0DA578619336D87644B180DBC6D44AB30E6923FC4C4B4092DA653727090370E204A2140CB47903B8E84337AA75FDE64707ECF8CB115D8A1B10D1EC6F6EF595E3F2FC7D4D99F4C09F38968905E52805B3683B3BE4D74AAE4BB11BA79BA8010FFEB7D323A901F63D63977D4E1B2E9FE2C1E1D9ADE471B62AEE80D803F9AFBD26A8F5A27B7E82FC222F9EF75E6CDF2280F657EF1696BFF8C7A650CEB0DCDF6D1AA2D9462B736C76143F28AE4298F694A27E7F0AFE7D2AF3FBF1DAFBB54D7E4635A096B51117E0571B4BF04DA3B613D085636DB880360176259AA0CC8380BD0F0470F04FFE17A48F72BCDB5288DF7F11D4D4254DF71FEDC62467BDB91B103F0E730E9EBFCFE46B8ED10BF09BA901FD71B981BFF871ACF61795BE030EA999B91AF9F8DDE71DA8690F6BEA884DE78DF7E0F4A19D080583D2A01D4A0466D7DF4BF94FFF9EBEE8BDD8E5BD7C317A9DFA9B00B2D6BCF6B70F9FA82D3F6C4B7B62608D5A713F19D7848220EDE7DF698CF49B35E3A54102FAFD00ADD537AA0141FAD4D8D55F174BF3F1B1D77BC3543B8EF5530268534FC4ADCC3E0D04D2E4F222E829C4450B8DB3EB9C38D28D5B0EE8905500F56FB58734B5FA5692DF58A607E0075FBA27CA9B487FB000D4138AAE298FD99FF62474FAFC8879F2259760E94EE324AAEAF10E1F9A856BA6BA8160C225C8A4FC8FBF8382B08010C09DBD7C337A9DFA8D00A8F5273F85AFBCFEFABB4F6EF14C512B4C4D279785313BAB0AA1F6168BA8BFC5449E66DB98FDD8F67ECD3AB3AC1E4F3A0A79711CBE5C9CF9B1DC04C85EEF6F0F0526DA690B40C2F26A2CBED037952B6AFF91E7E1F7E6E20FEB7D58B8CDD822F0CA695E64056B742AC004F8B096FC6A3EEFE53603BF19219892885EFA2B176526FDD5EB48E6ABD35E84B41F3E0D10BE5BE3C113AB3A0CCF544D23032E2C38CA475EDA7A744A2E4144734DE0DE03FFBAD83A05E2F29FBE1B371002D8773E0CA210C0D005FFF9FC2F2B76B59FC2563C0DFCDD7E4023D0BC5B9AE5451E1E9C9EFC07D22781C436A63218E0DADD5EAC134B70FB5736C38BF2CA31AD92651598F1F7D64140C190A9AF7C9ECCD76FD19791642E510175CE42CC5B681C2873E9C42C5C5CDA287D8B2F21FF459643ACA53F925BB674C1AF1E87EFF71BCFC70BFCB1C7483E3F81BA2E4844E0266A604B380FF72C6D336D25A071813B8FCE4161B49190400BA3044CC8303DF94F17665DF46EF4430C70EA7702F8E54BCB1F5CB5A3F16C359F561CB5FEB3DC55E85606FAA89378B033059B8DF14F4602AC95B71CF36F500090A6205FD2598A875669036CF453637F39A84EEA9A2CD0C72B686CBFB6823358C3BC0E435296F489B45CDCB22C0B2B6BB5938594F86C78F698302252DD86AD81AF5FE7487E359F4708E983DF78ACB4A5BF85F537F3D3695CC0EDCF469BB300BFFFBC035B9BF8AD043E1725815C42020D8C12C888FCA77F1517BE1BADCADCDBD1B3D4EF04F0C4FBAB6F7B6555CDD56A854BD67F7C13624DBBA46FC4B100B71900AE0C02428A2420AF70027FE66A80250C1A00FC4F6309FEB9496B25261508F8CD38DAD38E370A109684D09B64540809805215F05ECB10FC61997198F02DD3DD383E508F58177F98B08114A07DA1793257DDDF3C86D07BF0D325AEF467AF2965EBAF3D0675EF5C8404629E3C3CAA8B0BE895C0AD4764A3DCDE24934038A29EC5C285B190FFCA2F91FFFDDE02C74BFD1E0378FAE34D97BFF465E53D6AFE4992F5AF949A5F78DD7DB5AE002710C85105809E04F8C14000FC3CE51F3A21C59D9B4AB046D70270C1383BCE2BA896E722646AD260FD352BBDAC6AB6E94ABF89FEA3A8804B96B80C4D82530A1DF8C3F42E5905A8EDDC3007BE765DDDAEB5663D027F7CBB5132F35C0A5ED45F736E8B663A33EBCF5EBF60B749730DB83C5EFC6DA3131F54759BF617B86E7A360EC96945675B0B33DB90B1CE5294FF2B89FC3FA8772F446652BFB702B456574D9BF7C2C6CFD4BCBB0E6C40B49958FFAEA0A955378F07E864BEA1BDDFF8C51FEE3800E51F36CF46DB917DB9B866451E6A83DA97E2C753EC98E9AD966625125806608E956A05278D0370923E34202A47B265F9F08F3DF978668D3116F0E7D91E9483B82D446571812F1736B5FA6A1916E4CC26833536E4B1C73400C6D8DD3899DF6F25FD13E5F8D65F4B206A5C20079FB764E3E1656D86BA53D3B584040ECD6E419018AB583862AA8A94ABB392FF2F13F97F660A8FBACF537F130075EF879EFBD03BDBBBA20226E5467051DE3674B7C99359EA014E170CF100F49E0412CB88AB03354FAD143AB824E42BC1258BB555445F8ABB0E050EB4D520160AEAACBCB1ED5FBFDDEA4198825F345BD5828B7E70A3CB5784B9AF1BE7D93F61A41B37D126C17679946032E0CB8B46ABAFCF4F891098E3A60C7E702CBD854B61D592A03E37BD8566D5058D0B64F9B2B1B435070F7FD56A7C044A618904881208B6B52A4A207DF94F9B0009010C7813A0743DFD7932350E30FFAF4B1636B4774DB8B0BC130746B6224C836922E2B29F17F0B3A94D73262400CE3E003F18083D312805D9ED74BCF90694E1575F683FC441D37F8F6E51826A518DC537542637BF2755CE91FF3C52509A2DFF2835091A55C0CBA7FBE0EAA8914609EA2D3BB36A61F5E5059EE45777E1BA12A6E03702D7087E05AC96C749D24497C47D50CF41E30259FE1CACEECCC5235FB5A1236C1CFF41D382A373516E6F566202614EFD59CA7FFA06CCBA7010B40048D7D59F275309E0A6E797FE756375EBC9BF26F23FD6449BFE3AE233FB98B5F7EB8382C69E7E72265F15300F21FE40F8965F656A4A000BDB4BF1D43AED4B50912DE0BE89B58876B69BFBFDA9BA00561B93F802A26E455DB7B93DA84411AE7E5F0E6A6986574FF4E042DA24186C87C8928A09F0B5DB746A207E5E7E445C7FDC543F461263B7A7085C91B78F89F457CFAB2D9F28232B811CD4D8F270C792666E33210D0C2E38261743628DE86C935B07589E4822FFE95AE0C277232D1804694008E0C13796DDB56D57CDFCCB875412F9DF2C7DF0D1D88BCF2C1E903A09C0B0CDE81218F2946BA58349FEB2BB041FECD4BE008715DB70EB288500D80A345101022F33C903B0C4BEC82FA3AE0B821CBBF8E9720F56EA26C8A0A304FF3D3B826847B3EC0658BCB496561F7C90EBF3796A2065F0738FA5F7FB4DA43F7B1C5EAB851521D03AB4D92525504B48E0571FB67095804A020511A59F40843F059BFC4C04E67D162A89F51F8941920682000A5FFE6CDD65EB376EFCFD71EE2D08073BA4B6749EC55765BE5A89A99080BE2CBB0EE61CFA767FAD1A108802F0E1AE2DC61680F3C7DA714E41758200CC9AFCD20804B265C414CA6ACA89C63CAA02DE6F29C07DCB8CA3046993E0AC9C86841B60027CF9C7DCEACBC734E69BAA01F41CFCBC3C0321802FFD594260C10F4E9EC61DB0CBEE40AD40488028810EDD2423F45CA3F2DDB8FD481F224DD5E80A76205E03D6F27FD00400A56BEBEF13121270939F618FFDFDC5CD87D87722DCDD61D1C987D3EC0763CB801509F0DAFA4D2DBF7A1CFA4D427F00177C1A3030FF6F0E77E000EC917BD6E92B90211AD30AEE698D8BC9B3D49759905A3002B8EC23A7A64990DECBE880030F1F1142B4BD59130C5476558E93C4BA2BFF68DD84DE819F2BD9D97CC3B9ADA3FEEAF9ADCE6D4622EAF104874C025FB464E3112630C8BE1323034EDC71B0888E56E25A45C2F17D13AF8426F847FF6EB8E09DC88077018E5FDF409C9492C0D267EF7D2F1A0E7D07F1093F14300AB0880740E31A9891807A63C63EFF26969FCD036D01F06097A314B77E6E6C0178F658C40369F10A34B3F61C4248A7F293A901D667D7961760270AE6B58602FCDF8A60FCDAD574EFD11E4C70D449F32D182CBEF690D6561F66A46004A79E20D4E3E89BFB78E037F3FB0D969EA70690247EC05331AC3B408C818792406BB61418E40505678EC8C2FC515DB22B108E689E9B4EFED3BF69840006742660360D0801D0F4D6E9AE07C8E96FD034E7990EF6494E02EACDA464F94DD480BA0F0D007ED25D86C7566BADA7D7013C7D446BDC7AB24D88F1CAD4D528B78253E8296878CD382F9EC8C960DD8090B71897BC1334CC9137A5D089DF4DEF4684DE47349A08085AC97DE6842CE8D84BD3FBE480169CFA7D53B1FC5C3560E2F7A71D0B30C414F8F10BAA043CBE1CBC51EDC33FD7F23F027BCDF46C4CF7B721D8D64C6C1AF399386DF0AFF9C27723033E0B109B068C00DE3CDD3587FA43DA1E79497AFDC18C0478A0E60707ADD4805ACAE1F5E3F9BA52BC59A50DFE4CCC17F0CBB1747A726616204D4D9AB80029D4325B24D53880DED74CEC2BCAC140E2C6FC6DAB0FFFDB68ECE6FACC893EE4856A64156061F1E57DB4D7653546405B4E5EE3A9814C805F3DA768762C8D75B70EFC99A908753B9D65C893938FA7B7B8F0FEB60EC3A3A0D3D7DFF19D5C04BA6BD1ADC40338D6FF6562FD078DFF4FD34012009D07BCD968B5F924606819D0ADDB94DB31EB1B00F63C00570DA8EB94007E270500B596F3BCB176CCCDDBA31000340462A84C1342E849E58B49B76999405DA4536637BA8A70E9C2A041BA7E776416AE1F1744A4435501891DCDE53E73460B52B0EA3E6C057EB50C6B9D7979A9F8FD9AFD7AE056688E25E509D22CD68E4031EEFCB41DDB9A8C938E56E43A71C72122822D8D52D3A02EF837E8FC7F9A068C00687AE334D70A5237D38CBEBEB60DBFA724C08F0B2865E2DB956D6A1760C2F44E7F2EE67D16D05CABFCD10D07A6D91301403DC0AD8703B319C95D80F879796BA25599C44B4DFD57872F80073778F00EA763D04BA767C3D95E4DEEA7D3D2E2B3FB1840C205B935F87996592D930EF84D09813D4732E9CFDE9B999A11D578800D59BE5C74660DC12D8B1AB82D03E71EE8C7C9254174B5B748AE80CE05A8B8E09D701506511A680278805CC00D3CC91E270115C4404A2440132F3808B63C74969F710B6800708FB3143FFB225135EACBF0D87780DCAEEA780010D0835E30A800B30AEE49C58B56F9060520FF4B55C0BA48216EFD88D33168920FE70D6D937A358A51CEBC813002C1741BF8FEB89A1FD30353593158E674C0CFECC7F5FB0DB102A3F4B70C2A1AEE4394A6B3A72D03559100EE58D294A82F36C83A3B0F79DD7508D1D19789585425B1FE237BF0D8FB340D3401CC84FAA520B04D26BC809E35E8F5A3FF6C6696DF4C0D28EB3400B85A1C8AFB5668BF494F03808F1FA674018E46E335677001AC0841B73D9DCA170D0BFA6D3AADA0ACAA2AE0B6E56E7CCDE918F4F71388ACA52A20DE2F40DD5F349CD71AF81CABAFFCD36BF03365B8E0678F67790E51B78F563198B911FA7B9348C097837FEFC8C29B9B8DE32E2A024EDC798880605B93E45E29EFDD8384006E4CE391F74B1A5002A0E9F5D35C4DE422027D43024C19E618ECF1C19E93FC397C7EBCDE5C867F6FD6B6004CCCB749B30047D44940C0C09B4306008F10B4D5DE2302306100D1621FBBCB832FBB86E0374B8DC1C09B0FCBC631FE3A725F4A47167DB32247EEB3C7B6B2FA7A7F5FDDCFAAE930B16F7A96D9CCEFD7E4A5E44698B83ABAE35112F0E6E4E18EAF80CA66ED242C349D37311BA7967649AE80188BD1976CDA050BC383A6F94F4D034F00A73A9F229573190B6CB39681944840D372A08D0BA837CC5303402200F8E88E527C59AB9D06FC940A3B2E2AAA96FAD1B3B5A75500462648EA02A4F20444EEA259114D86DAAB8D0E12FADEC70E54B76B89ADD867C7E34747A599984566AE002DA958CD1DA8258584ABC00BF6311657738EFE033F74D7627ABCA4710E419A47A0298BB8578B9A0D2AC0EBB4E1CF270F41A4B986BA0244FE87079DFC97EF6280132180F9E4E7E9A496DF84046028AB2306255FEF12E8D5809C25C04908E0DE6DC6168073C7D87146DE1E42001D7C8B2FF014808934E845C58B16992267ABFA32D3D8C687AD05B87F991C0C645FD89BA667E1E89C06443B3B0DE73093FBE656DF4CF2730274CA0A17ACCCB153057FBC14C7EF4F55FA6BAF977F8DEA3169C098AA80B76A7C787175B3A1CE8E1B958D2B0E881015D0FEF039AFB7FFB8878FBC4FD38013C06BA73A4D9A03D325018EBCD735FBF1D4004B0454D6B9FCB9B874A9B10560C1E14E8C8EED8E8F0100124A855B99960140C16C833171153F5F0798C509E82A55014EA2022E78DF66E818342AE0C0838785115283811CA96FE50A9859FD44360F40E825F813F9D6404F9CC700F414A57FFC3E354A8C16222AC0EB833350829F7CD08CBA8E884109FCE5D46294063CB3A79F74FE62FF19B79909B8014B034E0034BD46DD00E0B2F449C028F9016B9780264D5763A626E827CB6239A5F8DE12630BC0C3DF0172824C0B8001E089F35856AED0FB4A3703BA59B6FA4ED2014EFFAEC9C7736B8CDD83EF39C68703EC34C6C15301EA71CD62002958FDF8BAB65E0DAE00B39E1EF89192F44FAA26924A7F6D3EFDC4BD273B80656D7E3CFC454205A8E9A88A9CBA7FFDE6EA83C9E2AEFD0460925E3DC5398780E765E9820C6DF7C9DBF58D137E98BB04EA3968D2BB054E6F36B63986E2375F1A99FCB9235B240B09B69B27B360AC48232164BAC24DE301A2712B5DA3C1C04876092E5BD86EEC1E5CE4C26FA675275480C1DA69CF99DCEAA7E0EF5BE4F705F8ADFC7EFDF558497FE8F6B713E5E8CB2DC0ED5F440D01C1EF1E3CE699BFDF74CE2FB09F00AC132181260218497B1B827F3CCBAFEBFA6BECDACBE9F5C791FFAC5B40FDFF4AFB30FCFACBB0E6DA6813E0FF4DAB4338986801605D074D459ABBFDF15C2143B5CE037A7C9B6101F44D95DC80A72A7DF8DF860EE63872A17B8EF1639C8DA8802E5505A4007CE880C81CCFB8CD1AFC3C90671AFCDA32A9497FED7D685581FA5CB3C8BBB3219A8F7B3F6DD6ECFFE62FCFB97CDAF8316F92C5BAFD0460915E39C5C9740AEA190918E43FD72580A91AA004F0666B195EDAA28D944FC8B7E1A7A36A1009B6F301AE2303DEF6BEAA70D17485E30A90FF1C6E0F9AB34A70F9DB6DF1FB53D377477A70DDD8A0F47D06519D039F3D960EF896BEBE6EBB9935B502B9693E1810270B04C68FC303BFC9B9ACA43FB31E7FA6E425B2399CF0E7E6E3C68FC2A8ED900DC8941105CBDFBEFBAA4BC8E25602FE2E0CC2349808602AF95969D6C46746026C1E7FD00FB880E70D06721117E02D860054705002B87554B54C006C1BBE99B5E710826965A7FB0452F4FBE53CD1B841FA58662E1ED9E4C13B5BB5DFC8A3F7FBE449390874D520DCA5FD94184DF18F8C5BC87DF938EC3559587DFDB1FA02FCECFE1CA5C22A252BE9AF3F76FCF1A946C86693860DAFE8CCC3839FD64B79D79C76F8CF7F79C1B14F62905A7FE9BA07FA02D8F4CA298E15E492A659B7F3EBFB09C8B9BCE0A01EE07A72007B2CC804F0525329DEAAD42A8073C738706A608F4200D0900F34C7B7A8541352C854E2821DFC8020FD6476B3BB04572C6C8DDFA39AA80AB8765C27BADB55156061F19503A664F535DB7A067E2BD9CFD60117FC86E36642FA83E9E70FB8898274E695E2FBAFD7D0E860FDE6276E9E89416CFDA5EB1FE80B60D3CB273BE6930B7A3A595F7F53F9CFEBECA3DB8FAF06E415372180FBAB4AB0B651DB09E81C4A00B97BA45E80868AE390017BEC942B3A952721A6BF591439A51415F0E8262F5101415D795905E476D5C87DD9955D52017EE2C768F5D51F1E90D8413C66604C0E7EFE79530DFA81736D56813FE991E966FBB1D99DF005F2F0F83A624CF2CBEE7FF2C6B37F8F416CFDA56B1FE80BD02742024A30504F02BC1600AD1C379DE22BBEAC6C63D50012605509605D93B64B2C25805372790A4057891A9780E30224A96DABCDA9BC41A2C8DF931710A4DF3DD8182DC4CF3F6A67F6970BC455409BF2514CF081CF9E3313569F3D8E6806F234C1AF96EB29F879DBE46799007FC240D9888AF4A22696D376D209C71F533862EC3A027EED279B07591A8C047007F959A0B7E06680E68DEAD3B804B092FF4C3E496E5F361E6014809A7E38D981C39C7B10EA940367B6C419CDC940B762460ABCA4270A3165FBA1EB22247217E5A4A8805FAD746175ADF6E39874C6DB274FCA86ADB59A5101E9033FF163D6959817808339C87B0D7E6D1DE98FAD2E2703BFFC8C58E027DC00DA24E8F2F8EE396EFECD0B063BF8A5FB18E80BD0274200B9A4B22B056580102FB26F1CD0631E1C8CDF241B1B608FC7AC5002B86D7D11EA95D8980A8A5F1DE64245743742C136CDF168D29081E6FC1695DC8BFE01620A99A259111D3B5015B0294654C012ED3457F4BE2F9E9C8DB34BDBD1D54EA7B88A30DBF4E7107580410A56DF649B52A03FC09FB2DF0F1808582FFDE379122108CD4E977BE459AFB5197B050DC234E80880A6FF9DEC780AF19E81F265A61A088CDF54BA6A80FC39FD39F8E18A22699DB588B7530288EC220AC03813B0A0CB48851032F500C464F93AC0C774E56C36B9EBF31D4405ACD2AB00970D4F9C4054409BA2027A087C761F6BC9CF6C4366C0AF3D7E0F827EBAB2D2F3E24A7FC5B44859C282F3DE0EDDD98BC7DAAF697012C0498E72F253C96BCAE305F4ACE302F282293930EB4EA200AE5E596CE8054809A09C12405C0124506D450634D9CCAADAAC0931C5249AAE2432629C6C7D510751019B2515D0A62D2AA9801C9C55DAA6CC6E13891F8407FCC44F7A565F3D177B1BA6F30B9858E61E833F4DBF5F7A5E26D25FC9A7635A2A08010C8AAFFEA492062501D0F4DF93EC4F91EABD2C65125032525103DC7CF22FFD5EBCAA00D4445F1E8900A80BD0D166F0CF059D89E7CA7F935A362587949209C8754544EE5E8915E9CBB84405FCF0133B6A3BB4FD1F241570620ED05A2DCD1720EA8F9304F8F2B1986DBAEDC9ACBB29F80DC7E847F0C354FAD39FBDCAFA4BD73FD01760960801482AC0D8CF5FDBC6AFC9037472DF5A0DE8B7B97C394401F05D80E18400C29400981DF9BEBE3521E8CFDBEB6490E6DCCDCC8A712C218D057CD65E803F2D334E1E3A6F5236CE2A6B43675B4B62BE0013E0B3E74B6EF5B5D7622AF935FB660AFCE0120F7B45567EBF89F4273EBF40AC7FF75E63FDA5FB19E80BB04A5405408A05081A5CE90381EA8DB07181F8CDB1EDFECA3F5C350059015CA373016405E02604B00B1142002C72F5117F5342E0D474A62BDE3C38C81F3CCC82960E15A62AE09A4F6CA8D17D4988AA80C7E32A80E91D9806F035DB95424632481DFC5A35D133F0F3AED9CCEF97EA4867F53984B0D7597FE9FA07FA02AC122180788B805530CFAAA30F570D280B7A22704B3180840BA0BE44BF24043082100055009A8A332303CDF1AD2A3DB38100315951D17C77DA3B90A702D458C09965EDE86AA3B1803017D87259DD75A463F54D25BFB28FFE7CFD0C7E13ABAF2E5712F08FECE1531CD034A80980A6974EB4DF01B65F404A2460D2DCC78901B0DBDC92022832C8604A00C3230A015806FF0CD036D4747F54380FECC62C2DE0A80AF064E7E2EA4FECA869573AFF30B180C74FCC95544058F926426F809FC84B064A653FAECAE847F0C3D4EAABCB73CF7BABFB95BE799A7D9BF60602A03306AD247F15EC1460EAC55B02DEA2DBAFDE2D9008C0E79708804DF485FAE5E10C01301D87CC40CD2384A4952D98679BCB7BF324F27244FE6E6A9EC3EDC5D20EAA023A0C2478D1E46CCC2DED903EE71ED3CC1760EC69981AE88CD7949ABFCFEC6D209AF4C11FBF8324E0E7290025F8B798F8FDC7622F4D839E0068FACF89F639A09F11030B64635C203D35001D110870F9FDB8D6C405A004105214006BE7F57100B34AD5F201BFDAD3791862B2AD16C141917310BA48E7B8CB222AE09A8F056E2CE06F27112E6EA62305D54F616B8F933AE0D04362E0039C7D567D0F7E435EC5B96F7557A5F1E80655DA2B08802642021F909F59A9920090A21A886F23044014C0755FF35D80612A0100260A801F184CA59205D315932472179317E7EEA70587D3ED232A209FAB02E64DCE212AA01D9D8A0AE0035FFEC754EE9B809BDDCBD2DF4F1C8229DB87E007CCFC7EBAB28048FFBD2EF0A7B9D781BE805413218072D0CE41602DBBBCA06909600A18D40060410482D40A70E78622D4756A5F895F1C4A096027218076CD7E860AD4A9036E05F7516B809824C30CF03C15E0CE0EE03A4905B05D80551510202A401D23A0055E3AC04FB63D357F5F773F1900BFF44C2C257F7C3B0D4E4F23D67FAF6AF633DCEB405F403AE9DF272402824610A7A30678DBE418C023DB4BB0BE493B1CF8E2039D38CAB3472280F894603AB7825BA10605601124344B6AC1544CBDA198685C4AA21EE82D3BB3880A08E6E1A1AF3A34F540135501734A3BD04554803452500732F5189A73E881C8ACA462F579DB2DBF5CC43BA71EFCBA7DE2D56D26F98D0A601601FF87A93D95C19BF62A02A0E9DF27D8E4494334EDFFEAB28E04987FB4AA81470402B2FC0902605FFAB3C638717CF61E842505209A023BA54940058B6D16B9FC245AE788C94A6B81A196F8FFF6AE044E8EA2DC7F3DF7CEB5F764731242541002118480C8950B1495C30405DFFB192F1021213E7DCA13780282A23E218088823CC3EF0139448D3E594021C7031E92703EE450420E62B29BDD64CF99D9D96BFA55F531D3D555D55D3D3BB3BB33D3DFEF373BBD55D53DDDD5F5FDBFA3BEFA4A527C01480B784ECACD08E884570ADE87B400B9A74DC91AC462D2DC952C195FFBCB90FA8EEC7D537D2999DF50B70631FFA4DBE6AB102A47005052872937CF8CF4E36903B433D0782E0ECC0D45F0AE402DF056D728F19B17CFF5C1A2587B1E008C1D4731B401162C7AB790190182E482AA980942680C909414E92F28BE003A5FC0E78EAF854FB524152D20CBDA54D4422B307BF1C9F3D8F5562A3F51CF707E3A627E0011F51F8D3D0949FF4C59ABFEB9E79EE81B2884362EF57C17DDF88DCA0398027CCCDA005D479B057A298E03D870A8059EDD4FC6C49F31DD079726DA733E0073900FCF89C753F88B9515D88E98D9808001108C1903DD17B0F239A0B58080AA05647B705C80EA0B10637CF588627CED40B6626E0B7B1F20CFFC7C53843F3362EBF1274100DBFD936E8FBF42A92C0100D346C51480F9BC001FAE3660F843FB0062B02535157EF72EB92FC0D10D1E587544070C6A1A00C1D812DD89565E7D079101867BCB9358721086EDCF299059D55AA1A205A41BE0AE17D95AC027B12FA00F690123C3D4B56826B752F70DAD184C6AA5F233EBA164CCBF1A31FF9D226FA05CA89C01E008F4365F454F50976764B636400104B08000FB0062B01903C04E727387631ABCB0D20800DC59007EDA4FBBD9009B622EC90E2A65AB6666090B7A5C80AA05E09582E67C01F79D578FB4009C29C9302360C3F8C6EBDBAAF48C7B2A96BDAFF4B533E6DF8498FF2287AF67D253D90200A68D4B3C9F072589A8F161ECB501E383933E8018B405A7C30F760C5273E0F77CE8300CE28D414CE5929D8497AC3BB9142F40B6AB634C09509A80EE0BA809C30EEC0B7891CE1760D4024647464CD7E233BE9D875FBF3EEB9E8B61EF2B4F66C1FC0C1FC01EF467FEF2D6CAB0FB897E98E81B182B6D58E2F91568D98348C79FC902B70502D507D0169C013FD84E6671C683F117A7A281DEDBAD06C0984C88DCEF88CC02307EBB1424F30FF89A004363D0A30357695A80DE1F98742D6014C705E4B400078C9F2B33DF838DCA3FBECCDF83FE9C8D98BF62EC7EA22F26FA068A410804F2FE002B6D0068C79FB17DA02602BEFAA970F533F9341BFA60BFF6242FCC18C1033D45769C64FC35920A9B05108814B233EC856AD8FE04A3F4D66FC087B48017195A00A6CBE6612D2009038A2F60C482F189AB336D727BA99FBF694B7BDFFC08C6EE74C6FCF89F1588F91F840AA54A0100BC60680F40DE1F608ECA13010265BFF7DA7AB86A474C29370EC8D52786606EF6000C2AEB0164A2E368A71F1B1080F1DBE341568E4382E558DE79C8CF085CB743825DDDC354DFDCF7B14608A5F25A8073C637B5A16FC756EAE7DA30CECDF77B9EE905997F0D62FE8A98EFE75145000026040227C8DAD662B907A3989E9E98238040F240281A877BDF6BA662012E9AEB8785D176C51128198797D02C80F308405190104F19CE3002380C4F5F5BF505EC8526B8E17F7A29FFC8A23951F8D2DC8CAA05686B04C6C2F8C6FF9D4A7DD6B398995C90F9D722E6FF8278EF9627550C00605ABF44FA3C7AFB6B59F6BFF161F940204128128707DB13F0720769EF9E34C5072BA676682B02E5DCD96666677528B39325BA66AC2F43E695389E0D30B793152DA0066901B7BEE683D70FD23E92FB3EDE04A12402C8811438617CE24840EAE7CF37B4619C9BEB532693F3BE73CC8F05C9D9CB2AD0E947F5CF44DF40B169FD62E91AF4B5466546932A6E0EE0A18040523678DC926E814D3B870949372BE6816FCD3D0C99545F6E044AE68BB33A74ACB300BC060292DF763680D188A525E84F1B405AC07B52335CBF2D9FF25EEF23550B18445A40B7B646807D0F949D4FFC86A19CD1AE2095DFF65BCA817FB531BFFAD415480804949901F50959C93F7840A0C602ECF64E833B5F263775C103F7DE05696580633597A9F6332280F8D27FFC3ADF2CD9A93AD3118BA1F419819A781DFC40D302CCA6C0ED8BEBA161B043F105981394F118DF7C6B4EA53EEFD10A647E25AD77B530BFFAE4154AEB1008483A08007B5AD0DC01B80D9E09E8AD990A37ED20136260BAE9141FD465DAB4F057F2647B40C8170875BA9337E3581BA0C5BE6C778E212E006B01376CEBA6DA1F9708C2BFCDCF425A9B2EB552F5CDD71761FC5C3B8B7BE6D9FB14B3B3991F4BFE8A9CEEE351C50200A6759A26409A00D64080A55CA4AE01AEDE11A592635E7E4208E679DB603089A7C374C5982DCEB9BE006E8F4B022534399E0094F9E7F066178D2E38550BA887077606E1E95D49EA1A379F590733B29DDA74A9B5832F772C33F510B6D4B77806C7CC9F6F5795CCAFF6448513020125468078580B20C083A22612879FEF6B86B7BBCC8B82FC7049A253F50380CC6459934B0038FF32CE74D09847365E7D4E53AA5066B4C80B73D517301869812B9E384CB641FD64D402F49D85C7C2F86A9DB5D457EECA46E5A740C1657EB55B26FA064A4D08006AD180DA841338500FCD0202EC0788C5E1F19E29F0A7BD264760DC0BD71ED39F5371ED67002421C61E9788408B0A99D392372BA0C74B3CF04E0036EFA693867CFBD4387CC0DF05436953EE40289CF179CF423138F0999F515ED5CCAF74C144DFC078D1238B34738065B7134080670262B0CB3B1DEE7A7980B8061EE4F79C1D8091EEB65C4420752DE29A2C62F801C60901EC828159CE42767C80AE054C812B9FECA29C81CD610FDC7EBA0FD27D5D4A7460FEDA0E195F6B6827F51DDBFBEACB79156F3DB7AC75A06A995FEB89EA211D049407B70082404D1486632D70EDF3647E7C4CAB4FAC8139F201C8E4FC00E45663D4354D05F61DEE3C3640162861B69045AEA5959B4E507C01480B78AC2D0CEB5EEF35B453DBAC3CB9164E8E2761006F2F3E32CABC3E3B14D981D4070B95DF1A0494A41E88F9ABC6DBCFA3AA02004C4610503A8001048A8A5BD70837FF350A9D69322270E9EC009C5FDFA1F801246A04B3C1C07C7D5E45B15F066FAEDFA658ADE32044BE04016508AF9D6881AF3E71185243E436A589880FFE63611D0C77ABEB2778A9C3F2D7B5677CE557B9525FC8DEC7DF5BD1C1852EF3AB547500800981C0E7012F233676041112AC3A021F3D948067F793B9018E887BE1DBC7A420DDDB655819A89DC7FC356B50E09F573C128916B66778B2408F0B08E7B4003A38E8D2E3EBE0E32D69D3B4A0F9720E191F9C487B0A14D62EAB82F05E2754950080E9E1458041600D1A1675C6F25C4870340E6F66A7C22F5F57C35E8D66C08F4E0F80BF1F4B362D4D78EE64F237F89D6B0F0AA522D9462D902D0AE833705C4004FC7553E09B9B7BA0234566520AFB3DF0F38F35C270171922AC5ECBA19D0F60E9F0B3F20368A6DD6A24F52B2A9B4F31A86A01001302019C607413FACC36AFEEC77E8060E35458B96D883AEF2BC7D7C0B1A678009DEC9C7B621D6E1CF462CF225B712EEF1C9B42EB35037A5C801781652DBCD81F83BBB6F790ED509B8573A2F0C5B9C390D2B50041C6579FDD82E1EDA5BDFEDDA3A9FCDBC47AB2BAA8AA0100130201BC941883C0D97A191E364A40506D03FCF86F5178AF8F8C0738112F0C9A761806F47501FA40E4FC86A8C7BF142F437650691D202473DB7B7CA8AFE20DF0F56747723E13A32670EFC79B20D07F50D502182BFBA87E10627C00BED73F57F7AAC6FC7B4BD0B51541550F003A3DBC10BE0B38D3B061008523B5B02D350536ED64A4085B904152AD8BB92EC00E10724D1C5514480E3CFD64BD2C7C2E9E160C2253609FA709BEBBAD8BAA5F30A306AE3E6654D10272C141AC471755F7ADA47E1E0CD6A2C3D5CB1E739D7D56E402808110089C25AB9B902A7E8140380AFDE1A970D30BA41980C160E5FC001C251FA46C5BABC53F76A0C03DCD018938FCD8EDC5195EED03F27F5563AA87DB5E95E0AF1DF472E19BCFAA87E932CEAB98A2AE5A08E3D30C0F46951FCFEF97E576DDE34D2E0098E8A1857993000FEA685D03DCF47A040E0D90DB859D3133089F9DD69BB36D31F1EC757B69EF60915001C45AE26BDFD6546E798E1A0F81B580EE60337CF3A92EC379EA89B3EBFCF0BD055E65F6444F206AC7F8820C6FACDB8A0E5620A9EFAAFC82E402008710105C8306D68D359178DD13BD09787237B93C38EC97E047A70761A8AB2D371B60A68277062AF40487E2DF3E0EC0EA5CDA21A04F0BAEDD1980A777D1F903579E520727C7533090EC45A039AAF59138E3E7A22BE9322CF56F74BDFCCEC905000B7A64B17776301C7DA827D87CBAD10CD0A5DA574E08C371DEF69C335044C17732FD379697E3040B44D38AC91C2FA0D1000A862330144DC037FEDC05E961526B4A44FC70FBD24618EE3E985F2DC8637C51E9EF4AFD31910B003694FCC3F7433B5AD77D7DD5E6E4F5BD99D1B0D119784CA31FAE7E5F12523D7450904E4EACFE52C70638CB1F681D3EC8BB94EE0B686D0FC3BAFFEBA69CA7979DD0009F989681545F0FC83987A003C6374A7D49C24EBE074BDB6B954D2E00D8100200DC47CD6FBCD779DA6DBFDEF6CD1777757E54AFC383FBC76786C0D7D79E736E89ADFE9B5CDD6EC7EC9C7F392441281C057F430B5CF15827A486C8C42AE18017D69C9B80500A3B5007100FCBB9F368C607B60900D21A547CE3A75D0FFF9869728DC4494A080482E80B3B079BD66E7E6DE1DAA75FBBAABD3B7934AE3B6F4E0D7C32D14338038D24D91698AB4BF34A6411F675904F80BA6F83FA828383C2B13AD8DE1B81BB5E501D82464D60F1DC387CF9689C33A007B2D95106B3038FF15D75BFC8E4028020699A00068238FA34DDF19BAD97FED7B3EF7C15B2234D3FFA680886BA0E504B84AD48122E2C32151017C0BC5586BD428080DF0FD1783D7CE7F961D8D53548B5BD75510266495DEA5E02C6A5D37CC6BF1131BE1BCD57647201C0219981E0EAFB1EFFD209BEB6CB668CB4B7E800203B31B619340EB140CEEF89B9E6D99CF08474E829C141D008D76DEE20EF07F5CFBC961AF8F705416DA1D0A891D98DC77BB4601E774EBF44E4024081640002651BA1C77F71EB05438303D7A1D13D9BD57EACA030DE24C4F0CCB2BC2DAF4F0BDEF95A169EDF97A2FAE0EBA737C3690D19C824FB100864CD127F8DCBF8A5271700C6481A1040F453DF5146F7238B951D8B5780B6B6C09C09C74893011424CB6005B647823EC7BCBA31B7022F9739E84B9BFE413D7B24E8855F5D381D46FB3AB44CCBD2268DF15D557F9CC8058012D1BA255EBC55D96A34D25798EBAC4081474EC042723A9F28E5946F669D28089069D0D47FBC580B88D7C1EFF7F9E1A1570E51CFF29979F5C9E573461FCE2493B75DFCDFC93DCE6EDCA5B1920B002526040478F66085F6992FC2FCF925FB45D210AC18DCD4CE51521386FA4F8300F60584C15B3B0556B6B6C3C17ED521F8FEA9756FBF6FE694D61F2F3FF1A1A69947BD8934A8417069DCC9058071A4754B7C2720AE5E810E2F449FD9E6FAA233BE998480403236A5CAA964A70220E0F179952DD75EEA0D1F7CA92FFAE4F233E76DB9E0D40F6E47955825E875997FE2C8058009A2F54B3118285A81020676997A8A4B3C2637B591580344720A02784DFEA69A786DEB5997ADC2F3F77EF4C179D6F0E60A83BAEFC4A5892117002601AD5FEA3F02313E0682B341058471228E5437D63B0001AD06A705DAAA39F4B61A83767487292697F12707B900300969C3B9FEB3400503EC33C0DFF9BC85226CE338159964C402669DC43F678F9679672B3ADE5AED79F6CB8D5C002803DA706E006908CAF666FA67364282F9744BFB8404FC176EA50DE40A11A3EB0CAF48F957DDF4DAE54D2E0094316D3C4F0186D9A082429DF63102033A26B31E7324FD1EED031AB36FD5CB25AD6E596BC68DBFAF407201C02597AA985C0070C9A52A2617005C72A98AC90500975CAA627201A04C69E3798130FA8A983E51B556D2FFCF93D84C400A55EA490DBA513B9C0831A57EA49E65AD03C3E05245910B0065401BCE0B3403F6F0CB8A971F337642E84421A637D4DA0404694778717F8F0216E81B8142E744F78F4B85930B00938C369CEBC7925D6578F5BB1E971794B547B495551010D984774E07D610D077272AE85CF698AB29940BB900300968FD52FF5450985DD6197F1C48627D91F5CC3A49001014303880FE39A06FCDA58501E38FEC86014F1E7201600268FD521F5E103355FB3481BA40C676EBEEE25091170271F200187E096B036DD1FA86831FFDCC55181870E6D4ACFE71C16062C905807124C4F82D88C96721069FCA6B43704391F3012887D60DCDCDC93A5BE607769E40C903A1680C9EE90C8CB4BE9BE9BCE0D4A30F5EFBB98F6130C09B082A80E002C1C4900B0025A6754BBC35E86B0EFA20C6D724BDF247302988405B264914AB0AB5174F0822C8FCE8CB1B088127DA005F693D04A941759F809A807FF0F899756DD79CFFE1038B3F72520F0200FEB6C12E958C5C00281121C69F81BE6622D66D6431702169C14A4692C56E04CC3A362098F3024A4A42202F84623158B7CB07BF7F4B5D37644C0976D9BC5AB870F668C760B27FE7A71F1BA0F71677A9A4E402C018C9E8DCFAC3DD3778D1E8C68C3F1B7DB0E4B765F4894C0C6A97101480B5B1890820E8CCEF017FA8063AE438FCCB5387A9E74E44FD70FFF94D90EA3E0423433829903480CE7B0701C1FE09EB942A2317000A248DF13DE8E3EBD8FB4EE095A77EDB3298EA3F02B1B38F29F1278BB417202E30384A0B2E812F1080687D13DCF8BF29F8EBC10CD507379CD302C785FB21934AA2BAAC76B6F277001DEC44C7071118B8A64109C90500876464FCE7DEDA5773CB8667A65E3C3D396D867CC867DC19A8180C5F8C97532CD871BA3188E4F12A8EBFB732B570EBB6FCC6207ABFCC6B09C3CD67C420D9A54A7FC6E69FA0CC20202058F6D8C07B457A0C974CE40280201918DF8B3EC12BD63C3AF5B99D87A6D705C17BEBC959E857067246F87A92E38A225091B605536ED30C08A65D81FC8120441B1370D59F7BA12349C705FDE745B32034D0A1487FD0A43F694A10409041E5EF226DA0AD84BD5395E402800069CCEF439FE0AD8F3CD5F8E88EDDB306068703B8EEC2B9015858D70D03FDBD3935D64C926D81B9BAB8AFC5E9C6A08C7FADEFD73CE3E051B300B71E0CC3FAD77B296DE882636AE19F8FF64312DBFEC383AC2DC17840D08FCAFF8E80A0A7A81D54C5E402800DE9CCBFF1D9376BEFFAE3F63987FB07A27A1D1ED8DF5F00104891D2DFBC490E8B26CB16E196E050C06EC1180C7C811078E34D70D5537D901ECA83A2BA3DB8077E7E6E03C8E96E18C9A4F3E0C0D919D8B86578BE3BA54ECD5928AE72B9C4A4C9310A27312100F0BEF4E4AF8F5CFD54D78CC3033221CD4E9CE28715337B91F4EF465A6C96938CD359173BDDD447840A7147C836F602EF92D8F35F13AD8547F787E08F7FA7F703FCE28975704E631AA9FE7D6A9F814983100002837FE01FEE56E1632317002CE8A14552040DE6A3DB7D89C80F77E4858D3EA8579D188223B3ED3098EECFD58930BCE39DBB1CB42DC4A61701082B4030D660E99F0935C0AACD49AABF9A233EB867711CFABB3AF31A93C977C06074C21C60D427D1E1DF903620BE37BB4B39720180430F2D8459C8989D1589D7C1A31D8DF0CC3E72F39AB04F823B3E2243FFE14E4BE79FE554FB043E9F1DCFDB8182CC701A481E1CF25B0B3FFB9B1FB6EFCF98AE27C32D8B12A853BB6120A9F94B98D25EED194B203094E5FC039284171EED9AC02E2D4B7201C04488F1F172DCF7A14FD4170842BC3101DFF88B17D223A4FA7FC68C005CD2D20DE9FE1E832ACBBEA6DDBA1BE341B15F886C3E1233F9E93ACBF364458D0F84C2B077A4166E7E3EA59D933FE9D844086E5810843E053007C9BEE20041DE34603908B9DA00F60DA48BDC8D154B2E001808313F5E8E3B5B523DFE108CC420199906DF7D9E9666AB3E14823932A9FEEBC45B4B331626B73BA7D0E93C59FF2B5BD59BCA18853E7F10A20D4D70CBF62178A373D0D45E86DB9726A061E43073B624C7E80240C0D70C0890D8B3ACD59D3214211700103DBC5099DBC739F69B95026D40E1A9AC277AA7C09FF60C11D22CAFFE7728EABF15C35B75704963010A94F4F97A593C6E00AFF68BC4E1A5542DDCBDBD9BAA3EE7C8085CFE418F62FB0F0FF1F70165018118F31BCAF275DD5AECC068117AB362A9EA01E06155E53F12F5442E879E3284D0A0C6F6FF4F76D6C27B7DAAC4D2414055FFBB9034CBABFFAAF4E126D4B22910AA724CB2834AD9B6A9CC3D4791FEC8545AB539059DE951A2AFC23E0FFCF0AC288487BA60084FFB6565DBDF730C047C6D00DB1AEF2C734D022E5535003CBC0862E8EB28D0547E230363FB7F389280EB5EF410E7E081FDE5E302709CAF4351FF591D681707209CAA8B556A2866DBE562C6802C502173AB0D60A0ACF5479A524714D6BF419A43B8AF2E393606E727D23090EA856C7694BA387F3A51A28F2D01210F0C747B693732090E834B14552D0020E66F0075D51E25B9F1F8098663F066B6051E7863989ACBBEE33419B27D79EFBF15C3F33B58723C1D385612C938245B14C88C2A2CFD3DF12658F9741AD2235993A9E481BB1745505F1D42AABF611A9571D1C280C0421BA0B582C30804DC98011355250020E69F85864503D111262EC6F6FF6F0E25E0D9FDF938763CB867C53DF0AFEFEF838CAEFE1B635898BF26C6E8A57A1122FA80CAB3B2FDF926BE9534E9DF8AA4FF0683F4D741E08BF3E370667D1232DAB49FCCF4299008600B040C2D80AF0D5026411215EC5EE6FA0572547500F0C8226926FACA31BFC4606025963D560BB7BC5D876C5AD263BD747600CEAF3F8806351EF0B260B20CF2FA5695C57A2122E905EDA7FD647E7B1967FA09C240A811AE7D660052C3643F3587BD70F7C2B01227313C94615CDB7829E71A819536C06DA37E0FA0839D481BC8824BD5030088F1B1318F537329893A249EE4C6B1EC48AD1D8A34C3F52F29AE0142AD5D353F004711D37F6C86B748AB27487C87A20305DEBA95A0979FA92168D27FEDAE106CD94B4749AE3CA50E4E8AF4A9D2DF60FBCBD4758DBF4D02C198B4019E49A07EA31B92762110A8FAB5045501001AF31F893E212BC6D7FF0F86A3F04676AA62FFEBA40FEC35A76515FB7F74989ECE32FB02ACEC7FAA3DB3600CC4F5F2DBA8FA02B303B82B7C8AF46F80955B06281FC9B18920DC704A808892944D1C5D4C2070620A18BE47B57881AA06818A0780758B250F1A60B3D10B0F510F6D9ABAD325044E64F1784F0B3CB96788B8D6AC9807BEF5811E359805D9FF620C2F11BFC7A352BC08916940AB4939990306D8F60F22E97FCFDB01D8DE36A4B5CD37FEDED98D304BEA52A47F369B355DA30020B0300BB8121FF800A17E2B2F6C545241801F9C50E154D10080991FD4009F20F1B02CC6D7CBF16A3664FFDFBBB711DEEE22E7B4CF45F6FF27EA3B94956CCA686532BD3E108151634F224B89292A602DBFBDB79F61FFCBDA72DF5018F68CC4E1A6E707C836A84F8ED3A5BF71C10F438A170A044EB5011E4018CAB3A8646FB58240C50280C6FCD8E11722C3CED98CAF7FE1D56CD1C666B8F2393F21D5F0F1E5C787609EB70D0653AA03503F8B25E1791D2B595516DF054815CBA267703404AF3F0091FA66B865C708BCDE41F3CC4F963441D3C821C8F4F7A13E1B65CE2210CC6EB8A9626903A22060F8469A00EC5BD69AA93A10A86400C079F883CCD872C3D39BC12180ECFFBEF034B8F105D5FE3782C0CDA706A16EE0000CA69314237303823822DD51C7B31A3B08FE97AD4EE480021310B40D3EF6CA8D70DD163AAEE69CD961B8E2582997E5D7EC3C942D7EB3102070661298FC006C10F807028121A822AA480058BF58C231FD31F509C5185FAFC0037CB7773ADCF932BD00E8FE33B26870776829ACE9CE93CC3F421D991B97FE05584CF1B31D831680806747220DCDF03D2CFD19597E7FBA2802D1A11E18CEA4214B684F9C5F93CDDA00101CCF0382C2B5018E53300F02C81C8003D5040215070088F9F15E7B31B6838F7C68DA1C9094A9ADADE916D8B4938C003CBAC10B2BE77421D5B637BFFC97EA4156DA6CFB4E1E770720B081C10A1014C75F24066F0E37C0F79FCD2FF8D1FB68E1EC1AF8C29C01184CF6118E3F9A899D014131B4013B67A0090C3008EC47205015E9C82B0A0010F3E37C7D4D94D4B7657CC83906F1AAB607DB13F07207E9003C63BA0F3E93E8A0EC7FAA13390CCF9FF293ECDBDA90E5C49EE85C3FA382CCF4836DFF047C6DF30074A448DE88F825F8E1193510CE1CD6B42399BA260F08CCD38F76FE8171028121F4D58E40A0E283852A0600D62F9170804FB364644A4ACD36448BE925463B5E9372B7EF6E86BD7DE4BBBF68AE1F1646DB110060FBDF30D4180CCF6676CEDCBF0099038D0ACBF167FA4F64D18F61C14F3012851DA97AB8733B9DE5F7B3C746E11353FA95E8485D3B92CD92DE011038D5069CFA05444160796BA6DD794F97175504006C58E2C19B6E62BBDF937B28C901E3EBB1E2DA14E0CA57EAA941FE9D536A60DAD07E550390643ED30B30FB782E02B2CEE46338B20004AF66FBABD29FD48CB0F4BF675118A05F73FC997E400C0844CC82B169030582400A81009DE0A082A8EC0100313F7E066CF707ACD47D96035032FCA34E01E2956DCDB0FA8540EEFAFAE0FCB79303307DF8000CA59374C759ECAC5B784E40915723175CCB5E9863383249FFEDA90658F3428FE91A3292FE31F8644B1FB2FDFBB9B6BF08108CAB36C08909E080400F02818A4D385A0900500FFA5CBF44337EEE212D185FFF0E8463D0169806B7BD44EE648307FA03678E42BA4B9B01B090F2F6EB0224D6575149E61F30FED39F917D1D2CFDC30D4D70F5E60C1C44D2DF28AD15E9BF1049FFE421C2F667326EAE5CA67ED3B15930FE2070787985CE0C94350020E60F4B9AC7DFF83066A9CF4A2B4D3B09715AAB18BCEB9D0677BE32449900F77EB8575BD8428600533B6499FF1BC75900E108409E37DED84E564DA20096FEC97A58B3BDD7542FC3A5D8F66FE957A47FDEF6375CD1C080961A81855950A84950341050EB70D6D343CB2BD02958B600B07189072FD56BB092FA04E36B8534E3E7DD86C1680CB6A4A6C2EF76928B808EC153804774280E40752CF03A91CFF056B1003CE2550BF90005C383AD004191FEF5C8F6DF92516C7F5AFAD7809493FE7A7F997F4F6603814C82854C9419AFC59F5160990425048191E58F0F7689747D39515902C0C6A58ADD5F8B3E3E3BA9CF54F709C687DC14209E015000E0DD11530C800756190180E8417AEE9F3FE5C7FAB7D8AFC046DD17F4FE2BD23F1C85CD3DB570FF2B74B28F6B4EA98505B11E4DFA8F52D72381C0422318A33630CE209046205051F905CB15007022CF1A32C49321F5399E7FC9800846BF00D600361E6A8167F69B16011DE1830B1ADA614803004BA6971865ACB9FE12F7BC6CC1F932BB9828C7D25F8E36C1959B072039446ABE8988177E764E08D2DD9DA4E7DFC23627A43DEB370D40C0D6068AE0171000010BE6D7CB7A973F5E394142650700BF5EAAA8FE4A98AF9DD4E7AAFBCC3AEC0388C23DFB5AE0AD2E3263D4C5737DB028D60EC33A00983B8E116F903B2A7816C0D45070EEDFAE99CCE07EAA48F3FCFFE1601C1E7983DEE4034BFF53A3DDCA94A831D5170F0868F55D2E481BB03709640630181FAD282080F3C0F5211028201A63F251390200667E0FC1FC3986E6497D89011240828212061C859FBED7026F7793C92D2F9EEB87C5B1B63C005052DE9AE1AD4C02FE0B70EE01906D9AD97BFF55F6C331FF5945FA6768E91FF6C2BD0B439042D27F742863C16C503010108CEED82410700E16080286E3E14A3105CA0A0010F387D02D07582A3F25F54DEABE1918C8C4116A0D967A3A0060D207DAE5F302F0219F1E0320134C6F390BC09CEAB3320CC6463CEB5F44E5CFDF94A44C8772A5FFC9713815D9FE4348FA67F10E3F226A3F8721596641314C82E28200D30CC0FF627F40D99B026503008F9EEBC5BBF7D4186FDA9AF979EA3E471B407F03D1187CFB8D04A4868D6AA80CD79F12841923FB351F8005D3734C01674E41E724DB14B080811522A0CFFBCBD146F8EAE64142FAE37EC0B6FF2F34E94F78FED506D46FB18040B49E647A36488CD939C80001CB084165ECE48EE54B1E1F2CFB00A17202009CD2CBC352F9CDF63C53EA33CAF375EA8BC573DE57BF96A06200F200D04F779A64C3F00E027E9CBE0C1123D45EFAE79944D2A4FFEF15E99FA6FA014BFFD36279DB9F19F063C9748C7AED8FB03620E017280508704C023C3558D601426501009AF40FD8ABFCA4D4E7ABFB0C6D400380AB1000E8A433800E00C31A00180188E8441B6697588DADDA9A48CCEB44ABBFDCEB30A47FB8AE11FEE94F79E9AFF74113B2FDEF5F1C827457672EEA8FEB91574F247E82050456DA801393A0E420C0F20BE4CB061108946D8050B9004050CAF73FC1FCD6529FAFEEB37C02D807F0B55713C46F2B26C08220CCCC0100CDF4DCC01F92E3C53BDCAA91000AC8BC128EDDAB4A7F0FF8C35178BEBF1EEED8DE47B5597D722C67FB939B7C5800816CAA07B056FB854C82E28280C802220B0D001F672F79A27CB580490F00BF51A5BF97DAF4014C4CCE91FAF68C9FAFC3710018005826C04CA60660EA48C9F84BFCDE2E65A7B3A43BBB8864308F26FDAFDC3A026D49D5B7A5F703DEE4E3FE45417ADE1FA02020B0D206C8990286DACF3017B8CEC1628180B50680FF8C5C52A65A40390080CFB83083A5F20B497D46921033280422B19C066004010C00B3460D0060BA0766474AD69D4BCD0514EC00A09D6FDCE63CE7207A102CFDFFD2DF0077ECE8A792A1AE46B6FF47E2DD8A133497E893E3D0CBB193D9563734624A7CAB3A8649609E2A2C3508D84C0BC2254F0C95E58CC0A40680DF9EE7F580AEE03B607E4BA9CF607CBD2EA06800532806B8016B001A007099DECA14E05416ABF3656EA1CC05062393EAD2FF8AADC3D09E34ECE2839E1D4BFF5F22E9AFCEFB1BA5BF5C1810586A03D6268133E7200F04D8BF41DC95E999F8FE006276009B02626E9A4944931D002496B3CF68EF8BF8008CA6387F86006B0071B892A101E03CF733470FA80060EA3DB6292066F70BFA03F924EAEC230A4CA0A06542FE4BB2117EB2BD9F327F567E38066722E99FC1DA0FB6FDB5EB880101DB2C10D106B8B304DA714941C08953D0708CB40017005C72C9A5F2A1FF078B6DB882DFD892290000000049454E44AE426082)
SET IDENTITY_INSERT [dbo].[CAIDATTHUCDON] ON 

INSERT [dbo].[CAIDATTHUCDON] ([ID], [NhomTextFontSize], [NhomTextFontStyle], [NhomTextFontWeights], [NhomImages], [MonTextFontSize], [MonTextFontStyle], [MonTextFontWeights], [MonImages], [LoaiNhomTextFontSize], [LoaiNhomTextFontStyle], [LoaiNhomTextFontWeights], [LoaiNhomNuocImages], [LoaiNhomThucAnImages], [LoaiNhomThucTatCaImages]) VALUES (1, 16, 2, 10, NULL, 16, 2, 10, NULL, 16, 2, 10, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CAIDATTHUCDON] OFF
SET IDENTITY_INSERT [dbo].[CHITIETBANHANG] ON 

INSERT [dbo].[CHITIETBANHANG] ([ChiTietBanHangID], [BanHangID], [SoLuongBan], [KichThuocLoaiBan], [GiamGia], [GiaBan], [ThanhTien], [KichThuocMonID], [NhanVienID], [LoaiChiTietBanHang], [ChiTietBanHangID_Ref], [KichThuocMonID_Ref]) VALUES (1, 1, 5, 1, 0, CAST(100000.00 AS Decimal(18, 2)), CAST(500000.00 AS Decimal(18, 2)), 2, 1, 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CHITIETBANHANG] OFF
SET IDENTITY_INSERT [dbo].[CHITIETCHUYENKHO] ON 

INSERT [dbo].[CHITIETCHUYENKHO] ([ChiTietChuyenKhoID], [ChuyenKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (1, 1, 5, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[CHITIETCHUYENKHO] OFF
SET IDENTITY_INSERT [dbo].[CHITIETLICHSUBANHANG] ON 

INSERT [dbo].[CHITIETLICHSUBANHANG] ([ChiTietLichSuBanHangID], [LichSuBanHangID], [KichThuocMonID], [TonKhoID], [SoLuong], [KichThuocLoaiBan], [GiamGia], [GiaBan], [ThanhTien], [TrangThai], [LoaiChiTietBanHang], [ChiTietLichSuBanHangID_Ref], [KichThuocMonID_Ref]) VALUES (1, 1, 2, NULL, 5, 1, 0, CAST(100000.00 AS Decimal(18, 2)), CAST(500000.00 AS Decimal(18, 2)), 0, 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CHITIETLICHSUBANHANG] OFF
SET IDENTITY_INSERT [dbo].[CHITIETNHAPKHO] ON 

INSERT [dbo].[CHITIETNHAPKHO] ([ChiTietNhapKhoID], [NhapKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (1, 44, 1, 0, 0, 0)
INSERT [dbo].[CHITIETNHAPKHO] ([ChiTietNhapKhoID], [NhapKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (2, 45, 2, 0, 0, 0)
INSERT [dbo].[CHITIETNHAPKHO] ([ChiTietNhapKhoID], [NhapKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (3, 46, 3, 0, 0, 0)
INSERT [dbo].[CHITIETNHAPKHO] ([ChiTietNhapKhoID], [NhapKhoID], [TonKhoID], [Visual], [Deleted], [Edit]) VALUES (4, 47, 4, 0, 0, 0)
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
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (142, 5, 101, 1, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (143, 5, 102, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (144, 5, 103, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (145, 5, 104, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (146, 5, 105, 1, 1, 1, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (147, 5, 106, 1, 1, 1, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (148, 5, 107, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (149, 5, 201, 2, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (150, 5, 301, 3, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (151, 5, 302, 3, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (152, 5, 401, 4, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (153, 5, 501, 5, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (154, 5, 502, 5, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (155, 5, 601, 6, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (156, 5, 701, 7, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (157, 5, 702, 7, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (158, 5, 703, 7, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (159, 5, 704, 7, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (160, 5, 705, 7, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (161, 5, 706, 7, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (162, 5, 901, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (163, 5, 902, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (164, 5, 903, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (165, 5, 904, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (166, 5, 905, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (167, 5, 906, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (168, 5, 907, 9, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (169, 5, 1001, 10, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (170, 5, 1101, 11, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (171, 5, 1102, 11, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (172, 5, 1301, 13, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (173, 5, 1401, 14, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (174, 5, 1501, 15, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (175, 5, 108, 1, 0, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (176, 5, 109, 1, 1, 0, 0, 0, 0, 0, 1, 0)
INSERT [dbo].[CHITIETQUYEN] ([ChiTietQuyenID], [QuyenID], [ChucNangID], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Edit], [Visual], [Deleted]) VALUES (177, 5, 110, 1, 0, 0, 0, 0, 0, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[CHITIETQUYEN] OFF
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (101, N'Tính tiền', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (102, N'Lưu hóa đơn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (103, N'Tạm tính', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (104, N'Thay đổi giá', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (105, N'Xóa món', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (106, N'Xóa toàn bộ món', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (107, N'Chuyển bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (108, N'Tách bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (109, N'Đóng bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (110, N'Thay đổi số lượng', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (111, N'Chọn giá', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (112, N'Gộp bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (113, N'Giảm giá món', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (114, N'Hủy Bàn', 1, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (115, N'Tính giờ Karaoke', 1, 1, 1, 0, 0, 0, 1, 0, 0)
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
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (705, N'Danh sách giá', 7, 1, 1, 0, 0, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (706, N'Khuyễn mãi', 7, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (901, N'Tồn kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (902, N'Nhà kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (903, N'Nhập kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (904, N'Chuyển kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (905, N'Xử lý kho', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (906, N'Nhà cung cấp', 9, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1001, N'Định lượng', 10, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1101, N'Quản lý khu', 11, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1102, N'Quản lý bàn', 11, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1201, N'Báo cáo ngày', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1202, N'Báo cáo tồn kho', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1203, N'Báo cáo định lượng', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1204, N'Báo cáo lịch sử bán hàng', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1205, N'Báo cáo nhân viên', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1206, N'Báo cáo lịch sử đăng nhập', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1207, N'Báo cáo lịch sử in nhà bếp', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1208, N'Báo cáo thu chi', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1209, N'Lịch sử tồn kho', 12, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1301, N'Quản lý thẻ', 13, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1401, N'Cài đặt thông tin công ty, doanh nghiệp', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1402, N'Cài đặt giao diện bán hàng', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1404, N'Cài đặt bàn', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1405, N'Cài đặt máy in nhà bếp', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1406, N'Cài đặt máy in hóa đơn', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1407, N'Cài đặt thực đơn', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1408, N'Cài đặt bán hàng', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1409, N'Xuất nhập dữ liệu', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1410, N'Cài đặt giở karaoke', 14, 1, 1, 0, 0, 0, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1411, N'Quản lý loại nhóm', 4, 1, 1, 1, 1, 1, 1, 0, 0)
INSERT [dbo].[CHUCNANG] ([ChucNangID], [TenChucNang], [NhomChucNangID], [ChoPhep], [DangNhap], [Them], [Xoa], [Sua], [Visual], [Deleted], [Edit]) VALUES (1501, N'Thông tin phần mềm', 15, 1, 1, 0, 0, 0, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[CHUYENKHO] ON 

INSERT [dbo].[CHUYENKHO] ([ChuyenKhoID], [KhoDiID], [KhoDenID], [NgayChuyen], [NhanVienID], [Visual], [Deleted], [Edit]) VALUES (1, 1, 2, CAST(0x0000A43700362C62 AS DateTime), 1, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[CHUYENKHO] OFF
SET IDENTITY_INSERT [dbo].[DONVI] ON 

INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (1, N'Số lượng', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (2, N'Trọng lượng', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (3, N'Thể tích', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (4, N'Thời gian', 1, 0, 0)
INSERT [dbo].[DONVI] ([DonViID], [TenDonVi], [Visual], [Deleted], [Edit]) VALUES (5, N'Định lượng', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[DONVI] OFF
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (1, 101, N'Tính tiền', 0x89504E470D0A1A0A0000000D49484452000001000000010008060000005C72A866000020574944415478DAED9D099454D599C73F14947D934544BA0B22FBD2DD88DB4926142E718D76268973CE9CC9D8CEB82B828A44E3428931514069445C1213DBC99C3927C9E44834B845A5887A26CAD6D00DB22834CD161A689AA551A4A1E6FB5EBD6AABABDFAB7AB5DEFBDEFBFFCE79165D5D567DAFFADDDFBBF7BB5B070200F8960EAA030085E1B9CD674DE687608A9735F1517DD7F05DCB54C70B0A0304E061CC423F9D8FF234FF5711C1623E422C836DAACF03E40F08C08370C1EFC50F55947EC1B7A292A22238A8FABC40EE81003C0617FE127E08F3D13B876F5BCD47054B608DEAF303B90502F010792AFC31A459508A2681B780003C8259EDAFA32485BF6797B1D48B0F3B0E7EB98E0EF19104A90904D11CF00E1080476001BC46166DFE534FE94A67F5BE86CEEA7535753CB57BCAF769397184761D5C42DB1BFF60F712C9073CA6FA7C416E80003C8099ED0F273EDFF5B4008D1FFC589B822F05FCC8D775EDDEA33BBF36FE75478E6DA1CD7B16D1518BD732013405BC0104E0015800AFF04345FC73F185FFABE37B6857D3126A6CFE948EB5ECB57D9FD33BF6A7013DA7B4D6164416353B67594900B5008F00017800164024FE6729C8A543E619857867D31B4675FEC4C9A38EDF4F9A0D43FBDD48037B5E6CD4046A590209FF7F1D0B60A8EAF306D90301B81CABEAFFC8336752BFEE17D0A63D0B69EFE17046EF2B0CE97B3D15F5FD17AA6FFCBD554E00CD000F0001B81C16C0348A0ED63190BBFFA4C08BB465EF6F69F7C12559BFFF3903EEA433BA9D4F2BB6DD9E580B0862C8B0FB81005C0E0B60163F84623F07FA5550B7D387D2BA9DB372F2FED21C90E684E41012840201780008C0E5240AA064C85CDABAAF2A557F7E5AF4EF11A4BE5C0BD8F88F39F14F43001E00027039560258B3FDFE9C7F8EC5FB42001E00027039890290C45D92413C1923B980CF1B16C53F0501780008C0E5240A4086FBE6B2FA1FC3422C10800780005C4EA10460F1BE10800780005C4EA200246B9FCEA01FA758BC2F04E001200097932880020201780008C0E54000201B2000970301806C80005C0E0400B2010270391000C80608C04570612FE6870045D7F797A5BF4ACD9F030AC281003C0004A029E61A7F418A16F2D8633E16FBCC066323118A4E47AE93474C1176171080469873FB655DBF20450B7C5A485FBDCC046C39D16CB794572110298463079612D71B0840315CE8AFA368A197C3F11D5E46E6753B2DC0053E40A7771A40BDBB8C6BFD5DD397B5399B0E9CF899B2AAB0AC1E7CEC7843D2E5C5E288ED322447182B0AEB0504A000B32D1FDBB22B90EAF572679782172B80DD4F1F96F4F5F912406C85A018B105466588B08325C56318326011BC9AF30041DA400005249DBDFA64651F9983DFB7FBF96DEEEE76C8DA7D2D278F1A85F02BBE3B67B314981D8902B042E4D378E4534308299A21B19A41259A09EA80000A8059F0439462775EB9D34BA13FABF7D549EFF252C89A8F6DE5A3CE380AD5DE1729499343F20CB2EA7077FE77E74E036D5F2FAB11EF6FFE941A0E8553C52889C44AD40A0A0F0490479C167C294C52E865155E2BE4EEDED8BC3C9D6A76C170DA3C11193470ADA4E1D0D264B9833A8AAE6F58855C41618000F280D98527177245B2D749A1916AB555157FDF914F8C75FCE5C8C7ECBE7C11ABC5880C643151ABDD88E4DCF61E5E6A48CD06691E4C478D20FF400039C65CA5374429F6E8B32AF872A797EA7203170E3715FA64F4ED769E21042B1948ADA0BEF10FC9F2157514DD9518038EF204049023CCCC7E1525A9EE4B1BFA9C8177B52BF87B0E7D60548F75ABDEE71A595C54761E4A3C7F0722906461059A05B90702C801665F7E15D9DCF5631B742666D0A5E0CB325B0EFBD33D83887090E43C7A4C69532B10116C6E5864274269168804FEAC3A7E2F0101640917FEF914EDDAB344AAFBC307DCD9265BEED7829F88DDCEC59223A8DBF78ADDF75345D1FC006A03390002C81033D1574549FAF465938EC1BDBFDFFAB374DF6DDDFB8ACA61BA5A6225021964B4852560D32C906EC30A8C1FC81E082003CCC21F269BF1FA52C51D3568666B97588A8B1998C46F4A1A436A039F373C6795144593200740006992AAF0C76FCB2D24B980810DD26C1ACAB5A798402537F0D9EE397635A70A7417660E049006A90ABF64B9470C9C6AFC1B77FDEC896F42A5F83E21810C81001C924EE197FEFCCD7B16A1AD9F03A43630FACC99AD35AA245B9E4302190001388405F01AD924FCE20BBF24FA36EC7E0A55FE1C22B98171DCAC8A3509A41725619BB21890409A40000E48B6EE5E7CE14F7261821C20FB13C6128449BEEB52F40E380702488139A1276CF53B19E63A7AD003C6BF51F80B437C5EC0A63920BD03018C137006049004B3DD5F471623FCE2B3FD28FC8525BED6F5D9EE27AD2615C982233F501DA71B80009260D7EE8F6F93A2F0AB6150AFAB6958FFFF307A076A76CEB24AB8221FE00008C0866455FF585B345F4B6F0167C4FE0ED2EBB266FBFD89BF4653C00110800D2C80AD64B15E5FACDD2F8353AAB7CF40B65F3163B92626B30BEB1B7F6FCCAF4820C402784C758C3A030158C085FF068A8EF36F8354FD2715BF60B4FB57D7DFA74B3FBFDCE974DB2FA060C8DFA474C83C63B2D58ABADBAC2610F5462DC01E08C002BBBB7F2C03BD65EF6F69F7C1252A4394425F45DFAC3A1452198C6A64B0D0F8C1B3ED9A64A80524010248C0EEEE2F137C26055E54DDEE97822F85BE32765753B837A056C4E45CB3F3D1C4F5049AF8BBEAA33A3E5D810012B0BBFBC7124E36D5CC4210A66866BBCDD65B10409458F3AC890BFFC67FCC49FC7539660D5A0301C461AEECB338F1F9D8DDDF26D1540864018C053631AB124005451742497B0BB37C111B1F602169A931DDA33A3E1D8100E2B0EBF797BBBF2C6AB962DBED2AB2FE49FBB3556F0FCE9FFF0AA558FDB8909C5BFC3CED6A5A9298A3A9E658CB54C7A62310808939EAAF29F179C577FF948359540BC08CC1326FA202192034A067B0DDB8008E15D7BA05F8524CEC2E62B9A08AFA5EAFE2EEEF287BAD8300CC38B49080E4022E1CF63BFAFB969F24FEBD3049C80208C0C4AE2A2B554A59B2BBC0777FC755565D0460C6A28504469E39D3680224F40604B1BF407B200013ABECBF4CF8292B7A5A45E6DF71D65A270198F1C8C628950AE2694592819D3B0D48943604600104C02C8C6EEA5197F8BCECDED38D25B0A17DB7523EA99B3A7CD7D03462572680A936056AA1E2C4A0FCCD6457E544014C8500DA0101300B375977FFC98CBF5D4D7F49B6875D3EA89A3A62D78D69C4AE4E00236C04B029F9F2698540E49D2080528E173980042000B22F44DF19FE27FA68F30F0B1DCE74BE5017387DB18E0230E3925A95ACDFAF649E820C0F8ECF0170ACB8D62DC09742C6C5DAAEFF5F2E20D9B27BC3EE8256FF85A405CB22762D0560C656425109149C534FE946274E36C77EACE658310EC0020880E4421DBC941236F51CD4FB2AE37177D39B850E870BD6CE34043058A10052C7C9F1E9D03350C9B16224A00510001917E96A4A68AFCAC614B2557773E1A7FC56F0C5EA78251BDD0560C6A8BA6780DBFF3BD1FEB7000220E3028D243E376E70886A7786548413E28BD5F1F4553708C08C5355CF4098E39CA2E0735D0104C03C6B2180A2BE3FA6FAC63FAA08A7FAEE113B1DB7579F552880BBD3108019AB0A0994DE8DBBBF2D1000F3ECC6F602187EE61DB4F91FCFAB0A2970F7C89DDB9CBC906357278091E909C08CB7901208718C580C24091000590BA0E80CAE01EC57520310AAF8C2753416C06D0230632E84041C7F877E060220BD04208B8E9A038F4AF9024E597575A3000A10370ABF432000322EC676DD8032A5547A010A4D9C78EA282A81A40B5ABA550066EC3202B38A723B5808D5FE34800098051602E8784A576A51B0E47759D11C5A5D3F33F6A30CA2094E4B2281050A05302D4B01082C81E24834FE8A2CDFAAAA43B4F03BCA9D802810001985C876E7DF4253563497D6EF9A4BC75A1A624FB1043A944F1BB9C3F2C276BB00E2CE43860ECB1263F2770838FCDFC2149DC3B1781A0A7E464000CC820D676BB3B0E6E8C133E8C489A3B4A96D0F84AC54149A366A47BB39020A630F723C79995DB760E3D922830025D4CA4CC2F21F162266F6E50008808C4264391B5005037A4EA65183EEA2957533A8F958BB9B5A988F0A2E78ADBFF0A20040E1800098CA0D672B9BB49288E41E2E18B6885A4E36B30466DAE521AAF8084D6711542A14C07408C0F54000265C900E90265B6C159FF1630AF4BB9E0E7FB595D66C0F255B8BB0CA7CAC50102604E001200013168036894059D8B26448887A741E6A4860DDCEB9AA3623490604E001200093CACFCED661DA6A2BDD4E2FA6D2A290B11169CB892354B7EF8FB4F340C1A7262723387D3404E0762000131640AF88C5BE002AE91E2701E1C0D15ADAB8FB79FAEAB816B581E03D1080EB8100E298FFD910AD76B911A426306AD01D467320C6EE834BB946F0BF744CAD085800DB2100970301C4C102984C663FB36E14F7FB110DED777D9BE744043B1ADFB4EA2E2C0410800780001298BF7E48BBD58174A15BE7623A67C00DD4A7DBB8D6E70E34D7D29AFAD92AC209DE330602703B104002CFAC1FA2CDA0203B7A771D4301AE1188084400D58A04702F04E07A20000B5802ED2607E988884012853B0EBCA5E2E321000F000158C002D06664A0C684295A530AB308B0E4964B81006C787AFD106D2608B98026BE94C2644AE1BE31F59899E7122080243CBDAE48DB84A00A3A77EA4F2D279A9DAC935047E634DDFBC6D6A399A03110401258004AB7B7D28D40FF1FD1B0FE3FA6435F6DA5A6E6F5D47474BDF198420832B82A2603473B1E83C20101A48025807C80494C00898810F61D5E41FB0E2DA723C9C72440069A01013860DEBA22ADE609A8427A1D86B204FA761B6BFB9AA35F37183583BD87971B5248424C069533C6D62389A80808C021F36A21817844067DBA8DA17E3D2651CF2E432D5F73FCC411DA7B68851319480DAB4A8E19E3EA932E820A720B049006F36A8B21010B641193DE2C83FE2C83FE3D27512773F2523CDFC860453219C46A05A119E3B6A127A10040006932372A01D9E81289411BBA772EA641BDBFCB42388FBA9E36A0DDEFA599B0BB6999717C757C9FDDDB84F908DD3F6E1B7A11F2080490012C81128A1817282490825619F4B4964163F33AAADFFF16ED3B645B2B089388603C44900F20800C995B532C5D84525DC5380187C46470569FC9ED9A09522BD8CE22D87D60995DB7629820829C030164C99C9AE2F9145DCF1EA441B456308906F63CBFCDF3922B901A41FDBEB7922E883A733C7204B90002C8012C81EBB84950456812A44DE7D3FA53D1195772ADE0BB6D6A05DF88E06D63F4610232F4B872E6843A6C01962510408E98B336D08B1F2A239AAD28E4163A9DD2D5A8110C1BF8C336B90243042C812F1AFE64F5BF49F761C54F27D4611C4186400039E6A9B5015955A88A9C6F6F051290E6C1B71244203982753B5EA403CD9F59FD2FA19FA236901110409E6011A0BB304BAC44B0E7E072430416F981301FE52C020C244A0308208F3C25CD82084D8F44938410418688048AFB5DD19A23906641EDF617A9E1D0CAC497CA40A2E00325681238050228004FAE31F2031514154140753C6E44461B8E3CEBDFE9ECBE935B9FDBD118A68DBB7E67551BA86009BCAA3A66370001149827D70C95A64105B960C9311DE9D36D348D1B726B6BB3E0E09775B48E6B0387BFAA4F7CE9F4074AB62E48FB037C0604A0081641B1D13488183240F3200D3A9EDA959B05FF4C43FB5F65FC2C4D829AED2F51C3C1764D82AA074BB7DEA83A5E9D810034E097D546ADA09C34D99BD02D0CE8792E8D2FBAB53537B0B6FE05DA75E0C3C49755B204EE511DABAE40001AC12290E1C522810AC210634774EED48FCA86DE4BBDBA048C9FB7EE7D9336EEFAEFC49755B0049013B00002D0945F540F8BCA200219A4429A04A307FF5B6B827047E332AAA9FF55E2CBCA7F56B605AB10250001B8805FAC1E869A8103C617DDD22A81F53BFF8BB6ED7D27FED7D24558CA12C01C823820009761CA201841CEC092C17DFF894A8A6E33FEBDA6FE45DAD9D8262750FD50D99632D531EA0404E0729E58354CBB1D8D556348A0382A810F373C4887BF6CD345187A68E2160C1B3681005C0E0B001B985820CD8121674CA6E6630DF4F1C687A8E5449BC1420196009A020401B89E9FAFFA160460C384A29B0D09EC6E5A41ABB656C6FF2AFCF0C42FA6A88E4F07200097F3F39510801DD23B70E1F09F51AFAE015AF1C533B4E7E0AAF85F071F3EF70BDFAF2E0401B89CC72180A4F4EC524417B104BEE626C0871B1E8E6F0A841F3917B50008C0E54000A909F4BF9CC60DF9096DDCFD27DABCFBB536BF6209F83A170001B89CD92B2000275C34829B025C1B78BFF65E3AFE4D2DA0F2D1495FF87A983004E07266AF38070270803405268F79826AB7FF8EB636BC1B7BBAE9D1499FF7511D9B4A200097030138A7A4F8663AA3C728FAA0F6BEF8A7832C01DF2603210097F3D8726502905188BDCDCF0EA8FE1E9CD0E5B47E74D984F9F4F1C62768FFE10DB1A72B679DF7B96F9B011080CB51288020179C65660CAE59E464D2B7A6193D01D575BF8E3D15E6F3F06D6F00049021A14F87C7D6A6AA0B9DBF59592699E35026003EEF3655E7D0F2E1375044EF1AC199BD27D2B8A27FA5F7D6CEF826EEF337FBB61CF8F6C4D3810BD97514BDBBC961371B4F669BC93AF5B25DD8E24249412701681093232E9D308F3EDDFC2C1DFA668E40299F8B2F171285009230EBD3E152B50D516677B42A3EA63F76FEE6BC2E533D4BA1001EB311802035A4485486DA2D775636F426DA7F6803D5EFFFC8D1B9781908C082599F8C28218A5451F673EF650BABE063176CCADBDD65D6270A057041F242C372D27217E533FB4CA47E3D46516DFDFFC49E0AF1B9F872862004900017FE5C6FE8214D837296405EEE301CAF4201A43EA7A84CF59280CC11B860F8DDF4F18627634FB1003641007EE7D168E1AFCAC35B1B1B56CCCE434DE051850298ED506A1CE3348A4A551B44009F6C7E36F663683604E06F1EFDFB08C9EA87F3F8112281C0EC0B37E53427C071AB13C085CE6B351CE752D2A89B70E2B09B68D59697633F86F85C2000BFF2C8DF47F6E2367F1DE5BF9A1A7EFCC24D39ED737E44A1001E4F43008FE45FB069316A70396DD8B938F663E87108C0BF3CFC7F23658A58A1D6D70BFDFCA28D39BBD838766502E0F3482BAFC1B1AE264D16352DEEFF6DDAB6F7E3D88F39FD9BB809DF0B802F4A1577A652BEE072920F709900B4C905F4EB3992F61DDA18FB1102F02B7C51AA585433CC175C4E9A022E1380F408542B88B51D104014DF0BE0A18F471E20355D54154F7C7B63D6BBD570FCCA04C0F1A7DDB5C9F14614C4DA8E4E1DBBD2F196D67501427C2E1080DF78E8E3512A1353757C943EF1ED0D59F50AF0392814C0860C04304AABDE0093E97C2EBEDC49D8D702F8D947A354B74943BFF8CE86ACEE3C7C0ECA04C0B1A72D008E57470164742E5EC0EF02D061D24A295F7C1927045D28001DBEF39C9C8B17F0B5001EFC68B40E1763F52FBFF359C6DB55293C8720C79D76A1D1E43B6F039F876FCB816F4F5C78F0436D2EC6D02FFFE9B38C9A020ACF21C831A72F800F47EBB69559139F876FD705F4B5001ED0470042F0C90C0A94C273C8345EDD7200613E0FAC08E4471EF89B560290A9C38127BFBB3EAD5E0185E7107CF2BB1908E06FA3B5E8068C23C4E7E1CB2E40C1D702F8E9DFC6A8EE05484406C9049F4A43027C0ECA04C071A625008E355FB32DB3A19CCFE3CFAA835085BF05B06C8C5613544C163F3579FD0FD238077502989CA600968DD1ADFA2F25A0773AC2F51ABE16C0CC65637A51749AAE6E54CD99BCFE4687E7A04C0073D21000C729EB2A2E76FAFA0251CDE790710F8C17F0B50084FBC363B7929EABD856CD0DAE4B29018E5F9900383E4702E01845B475A4D1AA4026957C0EBEDD13408000C263E7F3C374D571D82077CC0ABE486DABA8BA0BC02CFC61D2641A7002A57C0EBE5C0D3886EF0530233C56C7AA693C92182C9F175C67B9CCF80C85029897420033F42EFC751CFF50D541A8C6F70210662C1DAB6A46A053A48BB07CDE94DA76058E6357278029F60298B1749CACB214263D0BBF50C9F1FBBAFA2F4000CC7D4BC7E9DC0C8847BA2C434F4FA96D6D1270ECCA04F0B48590CC98A47745CB3D0162F0851F60A12ADBD149172000E6BE0FC615533449E50624CED0D317D7BE6AC6AE4E0017B71500C7D2CB8C4577992EE6D81D77B57A1908C0E4DE0FC6E936463D1575F4CDAE4521059F1F7C264E00FCFD65B38B5241E960212FBF020198DCFBC1F8628AB8A616A003418A26282B287AC70FA80EC821E1672EA9F1EDD8FF44208038EE797FBCDB6A012A91C2AF6B822F19C1F997D4E0EE6F0201C4C102905A805CD8DA26AF40562C9E7F690DDAFE714000094C7F6F826E1384406E9021DFA59597AEF57DE63F1E08C00296807E935640B684B8F0FB76DAAF1D108005D3FE3A41BA05D114F00ED50B2E5BEBEB493F76400036B004741F220C9C6154FD5900A8FA5B000124E1EE774BDC324210D853FEECF7D6F876C18F5440002998FA6E09BA06DD4B68E1F7D6A0DD9F0408C00153DF29D166575BE098AA8597AF71B4A88A9F81001C30F59DD25E117DA7B582F6543D7779350ABF03208034B8F3ED523407F4A76AD11528FC4E8100D2842580C4A0BEA0F0A70904900177BE557643243A5A10E30434812FE4E98BAE5CEDCB1D7EB30102C8903BDE2A2BA1E81AF7C80BA845FAF92B9EBF7235BAFA320002C8029640AF48C4150B607895EA0E1DA89C0B3F06F964080490036E7F73A22C815545EE9913EF05422F5CB50A7DFC590201E490DB964C94E5B9A43680DC40FE08F351F1E2D5AB70D7CF0110408E61091447A24B6355A88EC563D4F1C51AE282FFAAEA40BC040490276EFDCBB932A330441041B648922FF4D2352B91E1CF0310409E1111A0469011C61D9F0B3EEEF87904022810B7488D20D2BA80267204F684F9AAACFCD5352BD1AD5700200005DCFCC6245942BB82B0EA508C3A8AF6A254FDFAFB2B90DC2B201080425804922728376B067E1B505447B2E04A07A3D0FB7A834E9540009A70D3EB860C822442883E7AAD9920C9BCB0792C7EF95ADCE9750002D0949B5E3F6F722462D40A82E44E2154C78E0E1D28FCF2B5CB7197D71008C025FCE79FCF931A4280A23208C4FD5B3552C86377F73A397E73DD726CBCE112200097C36250B639280ABAFB81005C0E0400B2010270391000C80608C0E54000201B2000970301806C80005C0E0400B2010270391000C80608C0E54000201B2000970301806C80005C0E0B601A4597282F3410800780005C0E0B4016240D2BF8E8000B00137A5C0E04E001580207A8B0938564BCFF50D5E70DB20702F0002C8042EF5918620160496E0F0001780005CD0054FF3D0204E0115802AF517431917C83BBBF8780003C020BA01745E7E3E7331750CD85BF4CF5B982DC0101780896806C581AA6FC484016FD2845D5DF5B40001E234F1290557FCA51F8BD0704E041CCE64015E5262720838CA4DD7F50F57981DC03017818B377A082D2EF2294EAFE628A167CDCF53D0C04E0134C19C82AC3C99A0652F0AB31C4D73F400000F8180800001F030100E06320008FC36DFFFEFC20137706F2D1CDC1FF22138B1AF8D8FA9BEB9637A98E1FE41708C0A39805FF7C7256E8ED1011544304DE0502F020E660A011397CCB752C81F5AACF0BE41E08C04370C1EFC40F17F1D13F0F6F2F6B00AC547D8E20B740001E820530911F8AF2F8115FB0046A549F27C81D108047E0C23F8C1FC617E0A33E6209EC577DBE203740001E800B7F477EB88C8F4E05F8B8A32C80F7549F33C80D108007600148C22F9749BF5448CFC00ED5E70DB20702F0002C80203F7429E047EE6101AC527DDE207B200097C3855F0AFEE4427F2E0BE06DD5E70EB2070270392C8001FCA06299AE4F590207549F3FC80E08C0E598D9FF610A3E7A2504E07E200097C3029071FEAA048021C22E07027039A60054ECD2B30A02703F1080CB610104F821A0E0A33149C80340002E870550CC0FC50A3E7A0D160A753F1080CB6101C8D8FF7C8EFFB7A30602703F1080CB61010C21750238A4FAFC417640002E870570363F0C51F0D1EB2000F70301B81C16C0607E385BC147AF67011C567DFE203B200097C105FE547EE86A1EF2EF3E94DDB25F99D24CD1F5030511410B0BE14BD5DF0F480F084063CCC2DE83A2855D1E65DC7F47D571A5E0A8797CCDC761D412F40602D0889B5E370A7C773E7A4422C66357D531E588A31D3AD0118AD6148EBC7CEDF213AA0302512000C5DCFCFAA4532344B29967ECF0032283837CF11DFCF5B52BBE561D8C9F81001471F31B93A4EDDE8B22BE29F4767CC9576123890CBEBFE2B8EA60FC060450406E79635227BEDBF7A368E2EE54D5F1688824161B590418625C2020800270CB5FCE95B6FC197CB7EFA93A1697709CAF4CE961D8FFAB6B569E541D8C978100F2C8AD5CF023D135FA5574D37981137C814AF360FF4B10415E8000F2C0AD4BF88E1F31AAFA5EC9E2AB460A7FA3E40A5EBA1A22C82510400EB96DC944E9A39725BA7AA88EC5A348F761C38B57AFC210E41C0101E4082EFC7DF9A13721B95708645CC19E17AE5AD5A23A10B7030164C9ED6F4E3C8DA277FDD354C7E233A4297080258029C959000164C1ED6F96C91DBF8FEA387C4E33D706F63D7FE56AE406320002C8803BDE2A3B85A277FDCEAA630106329A5024805185690201A4C99D6F9775A2080DE47F9EA23A16D086937C35EF5974C56A8C264C0308200DEE7CBB54BAF5A4DA8FC2AF27D20C685A7445F551D581B80508C02177BD53DA85EFFC7D55C7011CD0811A9FBBBC1A6B1338000270C0542EFC91E89D1FB804BEB0F72FBCBC1A39811440002998FA4E8924FAFC3E63CF8DB0B3A971E1E56B30562009104012EE7EB7A4235F45A8F6BB9793521378F67B6B22AA03D11508C0062EFC92E8933E7E7C47EEE6380B0083856CC0C56DC3B4BF4E906ABFEEEBEF01671C5D70D95A24052D80002CE0C22FEDFE2EAAE30039E5104B006B112600012430FDBD0952F5C76C3EEF71A2F2D2B5475407A11B104002D3DF1B2F8B7760469F3739567969CD31D541E8040410C73DEF8FEFC40FA7AB8E03E48DC8FC4B6A9A5507A11310401CF7BE3F1E2BF8382736C846A4E9A6EBA8E5994B6A3040C8C44D7FB8BC72EF07E325E3DF49751C692263DFA58F5B4593E5D83317D7185370F9BB93BC897C77AE9823C171A347C0040230B9EF837152F577CBF72105AFE5E98B6B4F72DC222E15DD955FCBE7C73FC1B1C444A0FBF728DF1D460892FE7FA882605EB86EE9F36F892F781CBBDCFD55D4008E731C9623EC4C29695D1BE0D8D10C2008C060C652A310E9FE5D44E64DA96DD78FCDB14B415351D84E703CB6436C392EF93E75EE4D491ABF5FD0FDA22F0833968ED5F942154ECE9BB2CEF262E5D8E56F587001703C8E06D568FCDDB250D7F97E19310880B93F3C56DBEF616E705DCABB948AF89DC4A532BE5C9F8357D1F20F0300280CFF0F95325AB506C169840000000049454E44AE426082, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (2, 102, N'Lưu hóa đơn', 0x89504E470D0A1A0A0000000D4948445200000080000000800806000000C33E61CB00001EE84944415478DAED5D09741CC599FEE73E75DFF74896B1ADDB9665A3D896650BC7ACC11836B0C9DB40966C2009813C0776F74112B26B428821810D09B0B00F129297CD0B47969870C478312660E3DBC6B66C1DB625599275DFA3B967BAB7FED6B4DCD3EA99E9EE19C992A54FAF5EB76ABABBBAEBFFEAFFFFFAABBA5A010B98D7505CED1B58C0D5C50201E639160830CFB14080798E0502CC732C10609E638100F31C0B0498E75820C03CC70201E639160830CFB14080798E0502CC732C10609E634608D0D4D4A4A769BA84EC9A158A05CE450BA44E7133B074E9D27AB9D7985669343434145314F528D9BD9524FDCC56CFBCC2006958BF552A954F11320C483971DA0870EEDCB9FF200C45E1ABB9F92A95EA2AD5D1B5079FCFC7CF1A2144B8B3A8A8E83DB1D79816029C3D7BF665B2B987FD5FA7D381D96C06BD5E0F0B26207A4002381C0E181F1F07AFD73B994FEAF81E42825F8BB946D4A5415AFE76D2F29FF5DF0824262682C16000B7DB0D4EA7133C1E0F10B370B5EB6ECE0335A956AB65EA96A87EB05AAD303636C6FEEC25796B972D5B7638DC75A24A0062F3D38970CF83DFD94B4D4D65F2474646C0E5725DED3ABB666132992036369669648383836CF6E7C5C5C5CBC39D1B550210D5FF1F64B303F793929298BCA1A121D65B5DC034023542727232D86C36C624204823AC25A6E06FA1CE8B36014E924D05AA2564E5C0802487740111024D016ADDBEBE3ED6CC3E4BB4C083A1CE8936013C64A346260E0F0F0B79A9D30AD4347345DBA0899C0E87181B9F46A361FD810F09013685BC8F68164E0840E343A13D1A1D1D8DFAC38502F632B0B731DB7B19FDFDFDF0C61B6FC0B66DDBA6ED7E131212980648504F08501AEAD8A8965E5F5F4FE343612B4487646640939E46125399085483B3194880071E7800AAAAAAE0B6DB6E63BAC6D1464C4C0CD32B20682B2929C90F756CD409805D9399133EB1376A35A4A4A4302D0955DF6C3701E817DD7FFFFD8C796449106D4DC091C1CC1300BDD199B4FD2C0150F8180C99ED04C06EDA238F3CC2C443F07E57AC58117512706430F30498B69A0BF1B0E8F962E5CD76E123B05BBC63C70E86002C092A2A2AA6CB27983F04982B40E76CE7CE9D8CE031B144282F2F879B6FBE39DA245820C06C0346459F79E6994902A0AA6649505A5A0A5BB66C892609AE3D0270D53C56143BD03457800478EEB9E718C1B30460C9808974DB60F3E6CDD122C1B5410056E8E8DD6262058FC00A9C4B43CC181F79F1C51799481D9F04EC76D9B265B069D3A6689060660970E6CC99281280261EBE6652D8DCCAC02DF6F73161A5CDA5D1458CD0BDFCF2CB93F78D5B6E6235C192254BA0AEAE2ED238411B312BB39F006C0817BB74F8C0D8CA71CB0675B8026749809587096DE75CD2004880575F7D75F2FE8588C06A83EBAEBB0E6A6B6B23D104B39F00ACC03186CD0A921538BB45B015C68FF7CB3101760F056FB5DA21D6A49BF21B45D19048BBA12637D0AFD875D10ACA20AD51ED72C09682D880BC43DD0EE8A3D453AFEF7143E7BB5708C04D5C32B02458BC7831D4D4D4C825C1EC26000E1AA1F0116C0B67058E42E60A3D18E410A0DFEE81A78FF683DDE599F29B4AA980B5797170FBE2B880FCA78EF441E78843F07AA5E966F866595240DE3BADE3B0E7FCA0E0F199978F40ACBD2FE019F944E0A6458B16C1BA75EBE49060F61200878BE3E2E20242B86204CE872C02D8DCB0FDFDA6A0BFD75812E0DB55D90179DBDF6B22C4110E712F4B31C38F6A03EBF9A5A39DF049DBB0E0F15ACA0D77987BE0D2A54B931A8D4B006C04A819B91AA1ACAC0C2C168B5412CC4E02E003A3F0B1FB861A00EDB8DC289E1C02F48DBBE0FEB783CFA4AE2D4882FBAB2D0179DFD9554F88233CABA9282D061EBBE1BA80BC170EB6C1C72D83100C6F7EB592992585317BB667130A389DAEA9A98999682361C06BA609705A240126866FE3E3E3273D79B99043805E42806FFEE944D0DF3716A6C0F6B5850179F792E391384228498F85276E2C0EC8FBE5FE0BF0D185FEA065BC7D77B5A47BC6C99FE7CE9D85B4B4745267523440D9CC11E0F469710440A0C79F969616710C5F0E0186882AFFEA1F0E06FDFDD6922CF856752001BEF1FA61E81A730A1E5F9199003B6F2A0BC87BF69326F8A0A947F0781579E677EFA99174CF4880B367CF327526450310D3313B098082CBC9C98938DA253710842470FB84E30789062D68D581953CEEF2C2B8DB2B78BC59AB06B32ED0E377787C30EAF4081E6FD0A8204EAF9174BFD71C01D0B9417B66341A232A73803874C9266D341F6356E29A2300AA7D143EBE37201517865C7072D00D36A50EE2D514DC9A77EDBF75364708704A9231C707C9C8C8945CCE7BA48F7D76C40B17BA86C06256C20FD65BA6DECBC55EA86FE9011F35FBE708708116313F2311D694E606E4071240BC135856563E730438754A1A0130DA959B9B2B791EDFE1CB5678EE603BA3459624EAE0DFEB1607FCEE24B6FACD7DF550989508C971D24C4C67FF18938A2C29106BD4893AE7E4F96E66BB7C7146C4756873BAE14C4B1FDCB87A31A4C49B26F39100F5F5F592354079F92C2600EB076050480AC6884376EF5B6780A229589664841F6F5E16F0FBB8C30D7FFEE41CAC595E088971D2868ACF5FEA81C6D61ED8545508E989E2CE7D8B9485F8FB9AA288EB90BD777EF9D72401B005E318008684A5E2A177CE40CBE03814A598E0A7BC2E185B89D51585901CBF408050075C55023037408C5E565696E4B27E7DB805FEF7740794A7C7C2CEAD81AFC02D106012334B80CF3FFF5C3201B01F9F9D9DCD0486A400FBD85DA376B0C41BC1A00BEC535FDB04C009B0E20950515131BB09807E007605F1650639100A045DCB04C0F98F5234C08C10E0CD86AFA9C7940DDB4B9D4F3DADA5A5F5EBD10FC0912FB9133BDD6E0F683481DA032B71D7A70D11126011A425883BF7CF9F3430DBDB6A96893A3E14D87BE797CF7603671D017ED3BC6ABD5DD1F912D95DBAD2FE2AE8E93459D7C1B0B018F87C14F48DD8A07BD00ABD43E34CBF79F3AAC06EE0020126317D04F8EF8BF9662FE5D94903F5009BB7D2FE1B590440A16666664E4E0EE16390D87A1478D7801506466D4C7047AF55436A8209725362C19219A875D84A2C2ECC8258B341D2BD5CEE198276922A97644162ACB808E3A7A72E31DB75E57972AB73120ED2C5DD7FFA922001AE3881E203411515CBA34F80972EE4957B69CF9FC86E61823609540A150CB8FAA0D2268F006806F08D627CAB958F53177AE0F4C51E50AB948CC0D12EA69264361AC0472B880FE18318DD541F00093097118C005235C0F2E55126C07F9DCFFE270AA897540AB53EDB98073A9501DA6D17C1E9734444006CFD191953236928488CE6552ECD068ADCAE97089DE6DCB682F641AC8E3772E727407E4602980DD246DD7A876DD0479294731BDB27267E2CCD4D12757C28B83D3E68EA189C9D0478E17CF6E3144D3D6A501BC1622E8451F730743B3A27C7F3E59A00047AF3F9F953EF75EFF18BE0A50056972D127E00CA4B34406085603875D7A78DF005C6079016653CDFD6030D6DBD70C34A1480B873B12CC4ADEB96CA7AF6807B47F2EE6F9C52BE5C1F206A0478A139FB17A4E57F2F4E930099A65CB86CBB04639E91806356DA7F1D0101284603F0E7C1D7B7F4C269926E5C5B0A4A81B9038204F057A22C279010A091A4D94800360E208D002B2227C00BCD3944F8BEEF25EA5220459F016DD66670515367C754DAE41300B508C602D8C5A558A003F8FEA1E6A0C29C6F0490AA0156AC88900044F80F9396FF64BC3611520D99D032D644ECB0F04C974ADB2B111100FD00EC0DF0F1DADE33909F9D024B2CE9531F608100A11019019E6FCED94CBA79EF9A35B1EA4C636E48E12322210002FD009CFACC7FC04F4FB5C198C3036B962F9E7A1212401BF81836A707DE964D806E42805EA8AB2C104D80B7F74F4C31DFB67689EC67E7DF3BBF7CB93E806C02BC783E3FD943BB1BB44A6D727ECC75D0626D020FE509752D428097414FC927004D53E401D326878759E7B29978C5471B3B193F40CD0BFBD23ECF945E00B6A2B70F34CD4D02F8EF5D880072C6022A2B2BE511E0574D596F92CDED85B14B89C3D70E0E9F3D5C611FAF19FF4B6D240F1FCC0FB0DA5D4CAB58555A0029893130346A83C191711818B6828A740AB1CB2454891804D2A8A54D1875901E849DA4F8183D68459E3B303A513752279F0801835CE8F7042380540D208B002F34E76DF6D1DEDD29FA7452BD340C387BC39614E32BAA2D733CF971A41580033B383AC807865B7D84201EAF8FE931B0C84B8B852F94044E9F4235FA97034D61CB9ACDA823724B8D8FDC04C822C02F9BB24E6A149A8A1C733E51FDCD620A3AB47DC9E5EAE3C78F453C016FC20FC89FF2909FD5B7434BD73098F45AC848323351C154A20DB06BA853F37D0037214033AC5F51402A519A0938D7DA0B675B7BA7082014B02CC42D6BAE13757C28B0E4DD484CF7541FA09E31915242C195952BA511E0F9E6BC9B7CB4EFDD0C630E0CBB06C1195EF583C967B9FB9EA2FDBF3B762C7202E0F030AEFAC51F1E6EEB1E81FD672EC1CD6B8B40ADD1106DE0BF7DE2049A79013B960091F8007C01844274093071EF420490630256AE9448805F3666FF55A550DD9861CC864EDB25318578E3BC15297797BC3B120D02B0D3C571D0839BE7707BE1ADBF9D83154516C84A8DBF72022180491D582CB6A2773E8B9C00A9F1E26CFA3B9F9D67B65BBFB058D4F1A1C0DE3BBF7CB9264012019E6FCA4F26DDBCEE647DAADAE61917E3F8218E7D6F696715B3130502E0CA20384D2C3777EAC8DABB079B896367848AA51C9B3F6D04B0883601D343004B547C00490478AE29EF1B44FDBF82EABFDBDE21B690570801EEC59DA3478F4665123E4E17CFCBCB635E1BE7E268EB49E8186D810D45B7804AE19FB23DAF0850EF5F13513C01AAAAAAC413E0D986EC3F2A15CAAF24E89261D0D927AA041D95BAE3BEE2138FE17EB408807E00CE14C621622EDE18AC010F6D059D220996E9B7438E761BF11A3D601420C0BB07CF4744800DCB2DA24D009685B8B93A3A04C0EBF1CB97AB012411E0170DD9AD319A388BCBE7043715EE0B1F782A8D811F4280E35125003B4D8C1D1E6603427F1CAC068D4AC9948BF798A6AE8165CA8721DD18389D8CAD443913423A7B06A1A367182A0AD3212146DC849083673B996D7571B6A8E343C1E9F2C2C1739D334F805F3558CCA4876DC598FF887B28EC95752A3D23043DA30158021C89EA7B5879799680FFF78EDD07FDDE1350145F06BDCE6EE873748306E26095F111A20DEA268F63093097214C00E9BD80AAAA55E208F06C435E094D536762B4716075875FEBDFA43183DD6BC3D6F9DB078B3ABE8E79478E448F00EC7471EECA196DAE0FE080F5070CF972CD05CCDDB75B5B1822666B36C24AC3C3A053C6330478EFD005C8488A018356DA74F361AB0386C79D92CE6DEF9BA8AFDCD43851C78782C7474107B95E6D455E5434C0AA552209F08B73B9B534D0FB4C6A33D8BCE361AFAC516A49D22009EA1F2AEA603E4A104D02A0DAC71544B8D3C4BCB40B760D6D05273D310327C5904ED47F26F4D8BBA0DFD1035A451C54191E81446A1D4380B5CBA54F08696A9D9810B261799E7827D0AF6DB646D107987102FC272100A9F67D06B5091CA4658B41B23E8D09139BA9829C6F96FCADF3C891C35124C0C452B0FC6962276DCFC139E7EF26FF9FD40604EDE313DA20156A60E0CC57A0BAB44CB213D84C9CC0264280F5E5B9A29DC0F70E5F64B637AD5E24EAF850B0A3F622D7E397CF2E11239D00AB4512E02C6A00D8A756AAC14B79C35F9A20D394035DB60ED0D2F13BBE5B72FAB1C387A3470004F6060A0A0A022B88EA855DC3DB80A2AFAC2B840F9162C880546306D1069761C0D14B746902941B7F08F9E63A49655E6D02A006783F0801E46880D5AB4512E099B3A801609F949B4DD4A780D3EB206660BC27C557BD7889E3216BC435C001FA013841045F2045B0BD818FC71E84CB9E03538E37A88C901B53003E420EF40DB02793ABDD0AA5C67F038D42DC9B47B20870C84F80EBE730019EAECF5D4AFE9334975AA95032EAB7CD7A017474E2D3AB6C2FFD6BC435C0C1C4F070EC94E1E12EF741F8C8BA3DE803A519B320559F0EDDF64EE82726CAA048850AD30F215D137E61A6490294E5408A4802BC7FB885D96E595D20EAF8504002FCF548CB94F2E59A80D5ABAF174D003496925B703AA96CEC0D8CB947BCA58E1FABE37C914F8BE2025F1A151A1E7EB37F1BB814DD41CFC399CB8C36A07C8C6FE0F6B9C0A2BB9D68830741AD082ED8E65642804BBD5043042056034C0701F8E5CBD500D75F2F9200889FD7E761FC57523403B5C0E2B865D032D60C0A9F112AEC3B8936887C7E3C0B0C0BA31F800FCD5D4EEE40DF2BD0AA7A25E4B90AF287835A498654E2ABB4C3A0B31F8C4AE22B10EDA1B409137574DC0E63A41B8823717AADB809219DFD13ED263B45DE0BAE01CF4BBA819707C6A1A61435C09520D684063837CD043893F767B2B955EA4D9B35B190411CC28BA30DA0F3A54389F3FBA0A75322AE0C043A82383268340676C92EF4B6C321E557C91378C25EC3A831435ECC22A687D0616D050FE506E5E04650F6DC0E0A6A762E30254C00391AA05A3C017E76266F3BC97856CE0DA792FE789C368121818A8A81EB9C0F4082AF54CEA50280AD1E5715C53902DC3C66E244E7F7814A3820EA3A8C3620244D228E2B4E711B22DA404BA54295F15148D5AC9C3CAEB9A39F99838861DDE4587161E40F4FB432DB1B42CFBF1405BBCB0B7BC9F5D69566434A5CE41AA0BA5A0A014EE795909C33726F3ECB6421DA20065A8939400F3CC3B3192CAE7F0035480BC6F0810F2CF4F6F03BA73E84D1EC1F49BA9651EDD706E4FE2E8D5D203D062F2CD6DF05C5C6EF30238CCDAD5DC407E89B228050D87DB48DD9DE586589E839111807D87DACEDEA1000F1B3D3160C6B15824C241BD219BB8B6F0E612B53D146C8F2DC0819DE3A8C17C8BAA6D78BAF8D154C79F0A34DDDD06C7C086883A8892B9C875640A6390F1275C9D0411CC411D7109855165869DE01839D490C01D696648926C007C726CADFBC32F2B78371097BBC1EBF7C244043031220452201D64823C053A7F21E0685E2C9481EC2C4B4B242E61D020C148D7BC640496B20DE5706C9DE5590E02D070D2DDE61423F0099CFFF38547BDF181CE8FD2DF8325F97759FE8BBE07DDABDE3C4376861269DC68C6F01E7A59B605DB165D6110035009A42290458B34622019E3C65492799D81B90368AC2BFB04201A9860CA64FEE26CE17F6C7475C834CB70C61A4B2C144E581C99707063A8DD8E344D0400CD9C6811202278278C00E3A130D06A2405CF428D8A97EB0FA3A61D8DD0E3D8E4600EDA09C5B6480BD982C531E24E89398E0116A03852B1DAA896F90632E11758D3DC7DB99ED172B73451D1F0AE803EC394E08509C09C9533440839F00E22785AE59B356FAAC60428257C9E6EE889F06B082558CE3956C4803BDCA0056A20D70B411B582C36B0F08E94A855AA92136DDC45C171FA5CFD125FB5A664D1CE4C52E029C0A87DA8022DAA048477C0392F01942010586F86265743400126A0D21408A20019225CD085ABB560601767E6E2924A5605430222DC007866AE374F18043CE26750C61B28AD10E2E9F8B74CD48F27980028A794308DF42425BAD51F93F294384A051AA49D23123913A958EA9082F39CE4988848243EF3E12A036C0A9F0B1E4FEDA4977115F7F8F572E82D58687214115DC2DFABF1313E56E5A111D0D80D75B53841AE04A171509D0D8D8C8CC949262026411004148F073F2735443BB7CE8557AD0A98D8C3051A83810A55668A6B438F4255053204170DFE37333913DECD77B697103575280DDD99C987C4653758EB7012E375CA9FF2E14EA6E113C7E8F9F005F8C0A013C84001D840019534C406363830C02AC9347809F7E9E8F1E1776092D51ADDD390295424DB48185D1562DA3CDC451B44391EB31D0BAA646102F768F31DB4519B1528B990287CB07EDFD56A829CD8278CE32F8AC06906A02D6AD934900C44F4FE6AF21877C0C51360573098C36882D80C6A1D340D93221A9E7C7D35EA6253D1E0A33CC011FC4C46F06C93101111100F1C4C9FC6F91C35E9AF6A79EC5C0E091591B037DF66EB833650F3153D2269A4A014639D96F0672811AA0A9490E016A225F21E48913053BC9E691697BEA39003DF155D0D9DC16F31AE815D23F721129E46A809A9A281000F19313050F93C3230A10CD751814C984007FB82A655BAD56686969F17F364E7C1CA0A6667DF45609FBC9F1822FD3A0C031D8B9F3BDF628A254F73528D6FDE35529FBFCF9F38C4F101383552F9E00EBD747910088C78F171493D3FE87EC565C959A1000DA6804D35DA47CD3D2354C5355C07AE313618342D1067E58B2A3A30346464618F5CF7F5D2E0CA24F00C4E3C716E1CB58FF424E7F14E68136C882B550307E17A92C55D06F1CA28A1E1E1E069BCDE6FF1AA88659F40A13CE6AC2D0F8C427F21420F54B79383B1AC741D8EB480021406DF409C0E2F1A38BD369058D0EE29D708D76158B755F8112ED5D53F2D12B1F1A1A623E078FC2C715CB753A3D232C1414AE74C20A2BC24F23C20469E47D3EBEB6761A09C0E2A9C3AB0BBD0AC7760A3C0F502266E8CC05606B5F6DDC0E05DA4DCCFFE885A31AC6343E8E2FCEE0E76E8C44E0D8C23593028F5CD8510521C08699FB60C4871FBF47F7AA0F438FFA33B02AA58DD1CF26A8157A58AB7F14B4D61C46ADA3C051AD1B0C7A668A3ADA611438DB1D8BF4EBA7D3889925C0BE7DFB260DA443D1077DEAA330A43A0B63AA0B57BB224443ED8E83CCAE3B41EB4E62D439AA75B4E3ACC0AFD8F23981B60D1B6694001F097A485EB0C388AA7922299BC1A6BC4C142825F5F2D30EB3370F168D7C1D8CAA44C68ECF81161E0E84001B678E001F7DF491A857C388AF4048D0C59809BBB287688B7E7090AD533108B4423E31703817BF25280749DE7258EABC9B587EFD5C16381F87366EDC18F23BF55126C0DE61B29137F1CF0F976298A411F028C699E4568C3184C17D1F5C59B4029986AD14D5B4931A862ECF094832A4C0A0A35F7299D99E8DB0C8F3255219D2BE603A07B06BE3C6BADB421D105502ECDDBB57D67B05F2303168929C9C0203BAE3B07FFC694824041892400005AD8442F71D90E5AD9D995B9E793C525757F754C83A8866697BF77EF865B2796DA69E0E63324EA703CEEB5E8721F331428064D11A4045EBA0D8FDCF90E41337EF6F0E02C3A1F975753774863A28AA04D8B3678F5AA5521E85190C136364EE906107A8742EC6B1B47BC2AF6DA0A563A1D4F56D88A5229FC3375B41EAE5A51B6ED8745FB8E3A2EEEDECDEBDBB9CD8E6FD3043216274200FE91F83F4982CE8B15E0E7BBC89CA8072F77740472788B8FA9C45A3DBEDAADAB2E5A6B04BBD4C8BBBFBC107BBD7907EF36E98011274AA3E8166ED9B904108D01D860089BE2550EABE9778FAE23E0B3F47D1E87038376CDDBAB547CCC15125C0EBAFBFAEC0BE338E57EB74FAA53A9DF66552C49AE97CDACFB5CF8355DB0AF1BA0418B0075FD53CC35B0D4B3C5F6642BCD72A88DAFF9DC3E178C8EBF50C53140D77DC7147D86EB92C02FCFEF7BF57F8CF9D4C7E28D97D9FCF87FB4A93C9B45EAFD7DD4ECC4225F99FBB8C9622C8BEE8FFBDE0541D303C9A9C644A8211E710336B580816CFDFF5E77B374F6BE5C344CF54CA6F7404FF4FEE1317A88BA8FB036EB7E735BBDD8E53F969A27D29860E34BEDE300180C9C81BEED377DD7517BBDCB678F8058F82C566A4F6A770FBDCAD2AC8FF2ACE75B9FF2B39F94A5E520C994F967527FFF5BEA0EA9F567AD387EA762559AB8E452058B1A0FD89F227F67FE0E5512292CF9FB8FB42C92BB0CFDD86DBA74513C02F7C141CCE55C6A52BF0955F9C1DA9F7279DFF37DC6AFCFB1A5E520BA4708450064B9D497FA91A8B69284C33674C2180DA6770670FDC7AC2ECB40CF8B3A633BC272468A1C427828FB7CF278090C085928793DCFE84FB2EFF3E6E1D24E1A7DEECFE84FF7BA41040E51738AAF16492703D779C1D8993E1CD7E52F0C9C0278154812B78FB0A4E1E3466FDCA623469343ECA0B36F7158757EB4DF4E6F67F6940EF49666DC24CC476B9828620FB42841022889046E01283DF9AB9040826747C790157B4C46560D159C2172AADA22A86D3FAF1955E5C98179791B19084DF714BF09382AB115802F05B7D3015CF15305FD86C02EEBE43D3A3BA90F1AA3123269BB4FE2BB10EA32B9BCAEBFF924B4D1969DE79D32D7CA1FD60BF85220680386204D30CAC06600980098323F8954FD486B8B012AE68812A73502A01B0B5230170B5061C65C2551C13831080350342C26709C06FE142C207A1FFFB630EABBBE3F769336373A06B6C6269FB78FB526FCEE02D5E4E4CFF6A8CEA8473F8C26908F67F2E0984FC8760E6814B00B6F52301709C0609806FD02201B0D50C483501A8E671B007D76BC1D68FAB41212962FCBF19FC49CB4B48002113C075FC84EC7C3013A0684F7C2765D874D6AC57EBC1E97542EAD8F5C319A3B53698DABBE01369BA042E24C460F9E14C8090B0855A3D6E3D10680658E1B304603500AE64C56A018C1160CC5C9C09F01340E11722B670935FE8668ED0759CC4153EDF07E013219C3FC025C724212EC77F5834603E5EA8A434EECCD1BA3349B6F20110361DEC795C524453F05CA152105AD0FC562DB507C0F5E0B98267B77C07909B58E78F25036EDD52BB81DC16CB6DD9421E3E372F58F730943608D91BF02AEDBA715D7BBAC9953DA0A1CC1E10361F7CED311D08D6820184852DC5D9A3FCC265F38275FBC225BE9660FFA7220904B186966FBFB995AEE2E589F92DD4F582F90AFCFF21C86FD30521754E87F98DDF650C459270F1031A02BB945490FDC9F2650582C210828542601B2C4FCCFF52CF8530BF4D07823976E1F2C4FC2FF65C08B665852D8419F792796409760F8279945F2BD24073266D29D9993C0AF63445E0E933F98CB4847C5AC2EF8279A1042B16D7CCE4373110205FC4888610AE26E615011630150B0498E75820C03CC70201E639160830CFF1FFFC9575F295514DBA0000000049454E44AE426082, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (3, 105, N'Xóa món', 0x89504E470D0A1A0A0000000D494844520000006400000064080600000070E29554000000097048597300000B1300000B1301009A9C1800000A4F6943435050686F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08801400407A8E42A600404601809D98265300A0040060CB6362E300502D0060277FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F821C14804128B2420C9881451224B91354831528A542055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC546000017AF4944415478DAEC9D797014D79DC77FBF77F4DCA35BE214022320181C6C448849E280153995C536AE60A72AF1890BDBD910C0D826F6FA620990DD0DC41808CE6E65D738F8C8A66CD6313EE204E4233E626C629BC31C1E40E21212BA6746333DDDAFDFDB3F460302A4991EDD22FA55BD9A2A69BAA7FB7DFAD7DFF77DAFFB3D544AC160F49F2083553008643006810C02198C4120834006A30782757507AF7E260100201C6C2C747BFDEB10C90C44F4DADD5E4AEB2321CC5F689AB3BCAF2BC330F452C6F8C384D0AFDBDD4629754229F9B79A93158BEE99333ED8551B815DDDC16B9FCB44C5BE4C08BDA60B95717D5F42310CBD54D39C5B3BBBBD94D68B73A66A7774B53EBB9C2118FFC8A4845EC3838D78F53F8D71B29620DADDFED05D8F98077FF2739351B6F0BACBE95B0AA0E3337238005C2E008F07C0EB05F0F900FC7E808C0C80CC4C80A62680E6668060102014020887015A5A00A25180582CD939E02B3B638B1100C63FF5381FFBDB55DCEEF1478714AAB7FE54112548AEEC4F1AD224A5F517D39FA502F73C66A6B361D10B1B180F3622A5ACEC8F9FE8F33A0DA3EDA7DF1FFFBFD71BFFBECB15DFBE837879476409A5ACD47DB2028B5ED890D645BA6BF9D346FCD625FFD62F8020C68B3063AB10012A6EBB4F848A274BDB29DA12C44B7FB99823021082B7E399A44B0F86EA2494F52F7CCC39E7B721025CBAFA5E2D9DEC3E39FB66D1307D96054A066AAA2A16F5AB5696C3E9DE2984F9DF0000FB96AE4D2B4B86BFFE3CCBD8FF29A19495BCF2497479A7606466760A4AD1B8CBD62021C5391FBF4DF3DF7D8DDA3D66E1F1AB7D0FAE3301002C69ADBFEBBAF1C17E952188004703BB1F0025030DD3675955B36F16E9EC67E2EAFB344400C6D8F5FFF3EA417FBA30A01350FEB82354C2399F8F083071F5129ECEF1EEFFD913A6C8C852528A6D734A9C9BFA8D0FC136A578E254534A6B3D02C0FE87D699C2E3B7DDE4C8FAF43D92FBF1DB9410523C74C4E8F569C348FC3D0D289C6B8F22008CDEFC04F305F6D8AE8BC62BBE254FDE304F8052BAA1479642B286485F1BC3EBA63A375996D866FAB3D4A11FA727F0931FBF5303002084DEF4CA5FEB4AD282912836A1BCF641D35C4A59190F36E2D8FF5C915676EC5EB9290600600973E3DC1959817EE5D4DBDEB21001DEDC6D294B182B11018EDE7E9FD08716DABE7A9CA78EE1E8E7D7314400AE698FA60523F11D1B50F0E449A48C2E440428FEED4A9E8E901FBEFB11531F315A4929765C57E25AD6EFBA4EB09DE274BA772A69BD8800B07745BC5968AF65E0804B9E5FCBB5703332CACADE78E1F3B9B661B4059702CAEB7F8F2EA7844ECB38B497146E7D86256B12B70D7D68A13AFCD39F9B0800528855AA1B6F553D9621895273B262112819689C3ECBAA9D79AD650706B85CC040E2D8177F1D6F0653B200DF7A0B6DC1383F9B3A80F287C79ECD639CDF8208307EF37F68767C4A22BE58F1B481086059E64BD74EF3F448AF428F752E0E2B1C1B14C2DC0C0070F0A1270DE1F5DB76E023DFDBCA5CF5D548299BFEFADF234B6CC170BB6D41F167E6AC41C482FC5DEFD3AC135F12BBE6F1D4B571CFA1A40C9CAE3ABAB0DFF6F67694218800B3A7BAD74A29CAF511A3D5F19B178A741CF8F83F3FA3210270CE6FFBCD8C1FF194305CAE9450DEB8755529E7FC464480F1DB9FD3EC9A47E1F5AB2F1F5E6722024865ADBF7D76F7788E5ED39044D9BED75252887508004716FEDCBC40E093346DF3AA0FD1ECAA439410523C66DC656B52C2D0B4A450C8BDF722636C3102C0257F7F933B51A05DF31878F00953F8B394B4C4B6EF4DE93ECFD1EB198208E0703ACB2DCB7C091160FFAA36026FC3678CFBA29CB79AC55B5EFFCA9CE2A430009242F9F32E7D1E63ACD4A50771C489DDCCAE796C9AFA2D79EAFBF30440DC73F48490F78A86B48D9AAAA30B958C0B7CDDCC6B2DBBA6CF8306195A778821A25373BA1E4B0A2311ED40F9AF3A2FA7842E020018736A0F671E17DA358FFB7F71D6735C3BBD7B3D479F640822C08851638396656E4604083CB2CE10B9F9CAAEE92B0A5570AE0472CEE7FE857EA534298C0EA05C32E1B2358492E26CB38916887A66D73C56FEF3A3A63E32EE39BE3BA5FB3D47AF6B48DBF2DD29EEB5D212E5B1E145EAE4CD3F15764D9FD3ADE148AB96210030C61693E1C331298CF3A0FCE9A4BB9851760B02C05859CDED9A477D74B1AABCFBE11EF51C3D334065D3E3BEB3DF52464C5FC7182B3D71D3DD62C8AEF798C38CA01DD337C219653560091D59E9F63DFA3CD0B4A76DFDA8A681D38DAB0941E7101E651ECA0848FF055F5370619FFFC105FF6620020861BE74CDACE1E5E070241DE41A70198200E07038CB2D616EB1BC7E75F88EA5865D074EBD6E2CF2191C018020DE4E08B17519BCB53736975156C609E025D982DB358FA7BF7D9D689E5872D673A4611E078486B42DA1E6FAFB01544DFDE5DFB49A274D93764D5F7E36633E2710C65849F99EF3C64CDA3B31429052B2001160541E72EA76A21DF368E515A8C373E69B88004A59EB7FF8C8CD41BBE6B19F64884AABE4E416D45AC2780E4141E0FAF9315B0EBC5533C6E4A386A0803376CBAB1F56E525CD8E3D91E58CD2E92EAE705826B0543E25710C4766DE685A4E979296B9EDEA49CE4DE90E07F77DB317D32F574F762FB3A4D8A1FBB3D5F1A965A62DD307007E17901C1F522458E0CFCA59D3D121FD61FB977ECAD8F58000C54388235993B82D9460E1385973C914A140E9BA1E59AAE6CD539D19A3EF5B51EFC436EF1F14CA88E9AB18655B4F8DB95CE4638839DC1ADAF119A3F3506B08AB2867FCC677F64636CF9CE4BEA0936FF888D1EB0921C5196EA47ED779175D92D6D9A1FC9218028010E6C66B5E5D1F808C8CD427D3CD42DFEB1A729E83DF62714D558E9C62D8327D00E0608085391877F09C5DD0C9B7FDF3A66242C9758800630B50B3E353C0E7831379C5664C732B29C58E5993DCCB6C8F3C0EE456D6F925D8587F3F2855D3E8CAB542BE3C69CBF401C0D04C649C0032CACADEDBAFCF0580F8B35700E072B957134467811F99832549E03650629E0C75C231F48CE7902FBFAC6C0F070FF45656DB929B3FA4D6B2CCE710010ED321313B30000028011CD19A259492058410847018DEDB1729658C95710A382A17530FCBB6423922B2CE8C735C153B509ED670F04035861DC55513DDCB3E38A87FD3A06C7A8DE511051AB3754C433290D5342B33866CFAFB07A2F33078E269C6331622C63388127BF2566F701112CA524A066AAA8E2E8411BE76BFA73AA9970342D4DB863C79527D18941B91C2F4AA2031733381DAADCC115EC18F34318320DEFEAE9E7FCCE562650C151638620C20F5FDDD92A08ED529130140496BFDF7AF28084224D2E1F77B034A9F6708B8DD3023876CD9714CDC6A212B3BDEA0CCA25CD4526E178D428E156635E81311A69528251722020C514D8CB648048494A27BBC4199960225A5D8F68D09AE4D52D753FE6C4F43E9F30C4968462CDAB4D4EDF17D541F0267AE1799D79944DFA25180701830188451E17AED807F9CAE71ED3B549A58D0748CA1F29FED09EC004A5807591F520294D263D1C85229A5EDCEC39E84D2F719D22AE0574DCE0CEC08E81B39D7EE3FD1208D09C38833150C686C046F4303F143060D65145843AA0E301AAD45501620405228957532D6DA79B8F1AAC999013B3EA537A0F47D86B4892BC7BB977D12885D1535E8B4DAA012797E64C960404303407D3D0CABFD901F9EF63D99BFF7230699FE738EAD3D28D54DCA34052869891D578E772F9352825DF3783E948B2F43DA0ABC94EA9343FA068A747375B332B3BD7856E03B80017575E0ADAB234535A735DA5C8D208C0B2E98B6500C01AABA59C51F58B0C4AA0E6F5536A15CD4400000A68D756EF9F488712B222BAB6A52E6C86CD492C180BA3A80DA5AC8387080424E4E87599CA8F5E321E799718EAF8D7397DBB99D0E2C203D7050313DB2D4EDF17DD4180667363398271626C960407D7DBCA438CE06CB215A0C87A5A40C549F38BA10C68CB3AD71FFB019020070E5C4CCC0A747E2027F3A04E6183DE84809A3B131B9E740AA4E69A3CE8C73CCBE6A9CFD67AB7A114ABFCC1000804307F6AE9870E994EB5B8017374551643634B0A4309A9B93EEEFD4D089A604A2A410DBA65EE2DA245B5AD2EB1CEC2528FD3243201A851F4C1B65EE6AB1D623920DA77CC34D7FD3A794D4D561873042A10E77D792334C36650D13A094AEC7224B5520A054389CD4A7F41594FE07A48D805F5E5CB06957857E3D325E763A7F8C39E48B3D5A87305A5A3ADC65D50F679DF11C5F3FF67100B2B353FA94BE82D2A7DDEF98C2F4A937DF54C23456220034144F1131E4B24318B158FC33148AFFBDB111A0BE1E9A8BBE224C5FA6B284F9F1E563DCCBA1BE3EAE458D8DF1DF0987CF74DDA70525319ED2EF8060D74A2AD3D7D2123CAA943C8D0860C5CC8E615856BB5032FEF20AD31A4E23E7FC6BBB2A22CBA0AE0EBA15CA459B212E1780D70BCAEF07C8CA02C8CE06C8C981ACAC9C5F5142F2FD15FBA9BBB996404E4EFCFF1919F131098F273EBE4D69FCD3E389FF3D2323FEBD9C1C18F6FAF30E0400CEF82D1F7FE74785909313DF7F5656FCF7BCDEF42BD730D28738E034A4B55212FD44BB7327963A389F4B8581F9073ED1202F2FF9F6EDC0809C1C704783C45F758486868F29F07A7DEB213BFB866E8191A4ABFEE211F5D6CAC18202DC773CF618224076FD71C6DD0E84DCDCE4DBB60303F2F20072736148C5E75A74E8481D392FFBA260D2DC89CED0962EC348B4D42E7A1FE272C1174723CB19A5D31CD220D9A29977D42D724E74000372738164F8312754CD6B33471A94D085A4A0E0FFD2E9726F174692A6F645E543761D6A2AF6787D0B1001F2B8AE415696BD0D3B8091D08C4C2E5808858831366DDFB1C8720078BC4B3082C17F8C0C71B73E39E2732173720751E0B7F73B4960243423D7A5B4AA16D039E30B761F6A7AF6B2B199814EC348D13B705164C89727F5B99C6B650401737CC801CF15FAF622327EB2E5FEF01D9A0A0678BDE07439885F2A16D2C1E976BB5703C00D9D8671B103218460A02AB6101120CB8B9C602B0357C75024D754EDB5B71A057AC4E18C0449321889FD64FB90470C65216765812A7D6EF130E7964EC1686ABAB89DFA97275A859C01F1BBCE1B2DECC0A704A77C5D288753355D7383690706000041C02C0F72040046D963AF6DDFC93B05A30780F49B0CD9577156C8B3BD44B3E35324A12A347C824004888D1C6DB54C9E2A3C4698D9317D3E17B2A801966E92E289974E5E03008BD3858117658618466B5DC785DCEB44E6E0498EAB4DA684F20B85A25C09C3D88E00D03CEEABA6CCCD53764D5F224B38E7F3BF3C1E2E491B460F6848DFF76545A350714A9FCB392BA30430D363E31150970BA4C7ABC2AE4C8108202C7383658972CBE152E1824261D7817306C4EF468608A069DAA384104C0B46BFCC902E022159596766E6F1BBDB08798A0881D35488CAB2C4B6F1C6E9ED528A7588006157A6B03C3E65D781FB5DC82901E49C95559C8ACE4B0B467FCC90AEC691AAC8724AE9348E16F112D396A659125458570200C0348D95CAEF874B22A7CA85696E9180AA593A8C342E28CC70581C008050BAE8CD0327B96D183D600CFB3443743D52A239B4FB1101328D60FCE91223755D86F4D6C778A4F5E2D8E1DE9D094D696A8ABFBFA89BCA3204D89B88D330C06D4698531994D25681B70BA307BA4EFA4CD447E430D45AA7D8F3369F665AB081402402A9A018026434A6040244A39196556D85FEABE387D55AA6F91C0240538B8CD98191D08C8C60CD1981AF9CF0B5525B307AA073B1CF32E4684D741EE7AC8C5A26FA8E07F899134C0125DC9A1DC2349E1A57D8A6DBA355338A86BA975996D82115A8B0AE4CBB0E9C35D6135F7565626E95C5E48E3B30258C24C3C6032A43F67CFE2967942E4200F0EFFE986343039E73A21D408999CA3285B294948103FBF6AE68EF78A4944A5A6215024034A68425DB79E2B383A6ADE7F07EC62261E48C951E3DD5B224258C1E18A0EA930C993869F21A4A49B1E3442575EEFD8C9DB95FA78012D655FC4D27616E2E9B59D2E1D55F58E02E17C2DCA200545857865D078E0DF5E8DBF16E7C9E2E8DDFF6D1AD3FF67776FAF2010344D723259A169F2BD7F7FA167EA60B220594484C995281B22CB1A37088676DAAE36A6A8C0BBC2194655AAD026FC3F439F67C461D958728A5A47864E1A80DBD09A39B6E59F6270D28C864A871FE288202F79B5B19FBF200C10490245064545751430A04055298ABEC0C2C5D5A3CAC5698F1090AC2512B968E03F73FFB5B0D4181C6D98D275E78A5B4B760F47A8654D545E671CECA4838849EE79EE60908A9A0442C6A028012C2DC323CDFFEE49323F23D67043EAA5BA65DD3472A8EA0E7F7BF4BBC7ABD180F1EC4DE80D1ABA2BEBB8D907BD7ACE2585D8D6D05B3232842486970A74080684C8FAEB0E353CE1178D12AF0A89932AA2BBBA6CFF5FB6719AD3A899CB1D2AADA96E5BD01A37B9CBA4D2213274D5E432829E67F7B8F3A5EFC5F764EC5248112CDCC3501010CD3786A14EA01BBE631A1194335516E0AF3254080883BC3B06BFAB0A61ABD0F2E71405CE06FD9BFF7505E6FF45CF44A86E8D14889C6F97C0400CF430F706869B9F0D6D10E14D3EDB5842FF36C33D7864F69AF35D5D450FF002855637A332C8154DA357DFCAF6F13C76B5B29412CC8CECEF9D5C00092423772FC1C354D7B1411C0B5612DA39F7F4A201A053B50A293AF48BC5CB379A66831ED9AC7F3057C7C734DAD10F1090AA2632718B61C78AB66B81F5CA291E646D4343EB7BA36543AE033A4BA2EBC843356469A1AD1F9EF2BE35DEBB118A482628E1A2394CFAF2C21760CCDF5AEB5E35392356D87E4789649CBFA4466664B6374B1B065FA623120C78FA173C3938929061FC11E7E55BD4733A4A2E2B05FD3E2ABD7B8EFB953C3509B49EF934051B198D267CF31E3A391EA39F9E493CA96794CD2B495CF3CA3A4B4362002C4667CCB54B198B26BFA9CBFFC05A7472B917336FD7443CBF2019B2185230B3750428AF9BB6F53FE463BABD77400C5F8F6D502DC6E6509B12D2FCBBDC9AE794CE53372D7AFDE6209B10D5C2E159B5566A663FADC77CF732000689CDF72ECC4E9C201D7CAD2637A29D7F88D8000CE1FCFEFF8A58AF3A0488F571973BE2F0001842536A879F3941DF368D7F499A6B11210C0987D9D902E97B26BFAE887EF13BEF5658A040BBC3EDFFA019521191E8EBC755A6FE7CF977172FC58F2FB6E1B28C69D7799E0F329619A5BF26F9A536ED73CDA357D0577DFB1535AF1A534F4A5FF62A4E3C09DF7CCD748532372C6CAEA1B5BE60E1820750DE1259CB1525A5989FCA95FDB7BB22516039593ABC48D3F884F77A14757D8F129E740B169FA8E55562E525206E4B4E9963569B2B46BFA301444C7CAE5AD8F0FD1853D21F0DD2EEA1547CE0AB963E99273853C15930D4F19F1B764E5AB43A75E16B06B1ECF40B169FA2EBB694ED0B2C4564480D8931B62E93870FE9B8D8CEEFA8C3046A7353475BFC077FB98FAC8C2C20D849062FACEDB94BE617F193AEB1BDF94D6CC5996943270B4B272915DF3780E14BBC3AEE13064677A96092176A85145CA7CE8E1B4D6CAD296DEA7417C7471C1A9EAFAE27E9B21B1985EAA69F1F5391CF7CC4FEBED48F1E8E3667C5637B175F2E40941BBE6F11C2876875D5B5A40391CCAB2C42A4400B1F85EA1FCF65794A31FBC4FF8E6671821E8747BDCABFBA586785C67855C5BBE8C632A216F9B1D3FBC59C899F1D56BF67DD13A1268C33C5E00250D070EB1186467F9CA2D21B6416696327FF9ABF4B2E467F7F384C03735779FC0775BB3B7B139BC8471568A472B91D915F2D63097FDAB09185F3173C68CE9A61DF3D82E9434602422128D2C55A074EB8E3B849C34C9F692B1100C225BB19C437CADAC45D04D02DF2D1972E4F061BFC6F96D0800DAFD4B3408DA1772EB270B041415294B881D193EF726BBE6B13D28E9C2000028C8CF0958423C870020D63C915696B0A73632FAD967843356120C459EEC37A25E5454B49E10524CDE799B92D7ED0B39F8FD4A3CB6CC6C1DBBD8D8E1921076A1A40923117BF7EC79404A199033675972B68D15E5DAB6BAEEBA3321F0F3EB1B9A4BFA85A81382331001F85DE909B9B5E0A702B2B39465896D7EBF678B5DF3D81194CE3E9070E58CE9A610F10567C4136B0D4843E071EF5EC2D6AD6D7D3E987FA3CBF5A954D7E645330C91090027A1B111C9AECFD3022C67CEB20000745DBFDE9FE1B337349B6CB9A42E3C908000D8D2127D8531D6E92EF64824F2EDCC4CFFCEBE06029665FD8E527A63BADB4A29038661DCEF743A7B6491C674A3B1B1B1D0EFF7AF2384CC4044DBB3245B96F5512C167B302B2B636757EBB3CB404C33BE3C6173737396C3E1F8AA10C296A033C6D4BE7DFB3EB8E28A2B4C18C0A169E7BE3DD1E74006A39F779D0CC6209041208331086410C8600C02190C00F8FF0100E3C40042AD0AD7F20000000049454E44AE426082, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (4, 106, N'Xóa toàn bộ món', 0x89504E470D0A1A0A0000000D494844520000006400000064080600000070E29554000000097048597300000B1300000B1301009A9C1800000A4F6943435050686F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08801400407A8E42A600404601809D98265300A0040060CB6362E300502D0060277FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2573CF12BAE10E72A00007899B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F821C14804128B2420C9881451224B91354831528A542055481DF23D720239875C46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704128145C0093604774220611E4148584C584ED848A8201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563ADE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553D0A7FB93199393FF040398F3FC63332DDB000000206348524D00007A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600001DE04944415478DAEC7D799C54D5B5EEB7F6D9E7D45C5D3DD18CCD204D2B824101498C3162A7F5191435E8BD2F712497685EBC68D0181335E11125BF249A287033BC9777A3316A92A76854CC55B11DA231A2441490A9917968E8B9C633EC73F6FDA3BA9A1E6A3855DDA07FB07EBFF36BE8AE3ADFA9F5EDB5D7FAF63A7536492971D23E3DC64EBAE0242127ED24212709396927093949C8493B0EC69FDFE00000E2D1CE5A7F30BC82889D434441B727701CFB1D21AC1F6B9AB7C9CDEBE79FA5F4FBFF13AFB70D1BAE69EA0D9CAB7731A67CD6ED79A49407A474FE71E4E0EE5B468D9B1C2DC58943C5BDE9B2FA68467ED0F31BECCC077C8631E5C25299354D7DBE1B522E3DB33F21CFFED31C165CD3D41B34CDFB5CA9E7711CFB49C6941B4A2163A8B897CDD46EE8D5836B36D858B3C18EACD960275E7AA32D6905C28E04A4DBA3F91B779B6B36D88967D71B7F01401240CEC3E3E97731C388CB9E5D6F3CB766839D68FEC6DD6631E7498EAC75D66CB013CFBF2FB6CB59B320EBEB21C78C818C44203D1EE4FB3C006838707B220652CADE1CD2E538F6CB56B85C36DFF403AB1886273CB18AABD14E5214DEF897F7F485395FE8F1003E5FBF5F5D72A6322CB8CFBC9BFAA3A2F006FFC1DD34E18955BC98F37CB8EC7766DA21CE3F100E03A110100C028140FA7A070CA2BEF6CCBAE49261C1ED9BD48900224058C6722260F775B78958DD74C775124A44E9F49FDDAA12018CD1F504504E320281417F1A0E5CAE285F06244EBFFFDB1A4F44C9ED390ECEBB5A74CC996B433ACD470EEDBE056565704BCACA27DE555555BD8E0843C7CD566579BCFEF54258FF0F00B6DCF16051A375CC0B8FF3B2ADEF3345E1B39E7D2FB52C2719C1C139FB8ACF8686841BDEB6C1C31425E83DB0DB33E28D358ADBF78A40586EB973850500B663AF5CD4F4EB282211B82565C294331E20C6EA2ADF7D4D190AEE372EAD8F668D1022606FF3C6EF403ACD1D73E6DA87E65D2D8A71CED4FB6FD38800CEF9FCFF7C7E7B382B19A150D6F70E09F781DB15224011A662F95D1769D8FADD5F58A2AC5C3A8E587BD92CEFC33243860B52FEB22E364B55D54544C0D4FB97A8C55CEF40DC413A84909E630840DDD49996E3D82B09C0D6EFADB04420EC7A29B8FCFD3759D5BBAF298CB1BA516327AECC4A46389CF5BD8BBF7A76C9B815EBDF40D5BA57618DAEC5963B1F72F59ECEB3BEE01CBC7CA18094BAA927EF701E79442212815B525455BB87004C7CF4173CD4BCC9B5961B882B7B6B833CC2F0D299DE876D5BACB5C2E572E7378B4BB4D37FF8750D001853AE7AF66F6DB30691515696BB1C1E12EEBF01008EFE8F7F45D76967157CFDC6FB1E3600C016D62FAFD03734F792E08294357FEF5AA028BC518D76D2E4DFDC5B5474F4C5FDCA39E5CD59957ADF298B087871A32D6D61DE4704ECBDFE36A18FAA753D5ABD87F7D1C4C757702240D5B47B06911189E4164A40E9B82DFB30FEC9DF8008F8F8C6BBF2BEF6E31BEFB6F4B113A5E3887597CEF22DEDBD3617A4D0C183A47065311150F7DBFBD46212F920DC5C4B277DA7ACCCE1F5FAD74BC77E92006CBE375D9EB9328F07A73CFEA0AAC5BB892BBCF1AF4F7CB0A01F1979220400E69F1D2A1977D21F57424D44D1F5F98BD0D27079D697E9A36AE5C7FFFE238B0038422C77D6AF97FD064C01525EF8676A99C294D9653B37B3DAE71EE1F94AE27CB8D9A6AA9C1192398E1CDC7D0BA4D3DC3967AEDD7AFE25B61BA7C0E7038743939FFC8F7419ACB09BE9D55729F3A1649E08C9D8107031E999DF8208D8FF3FBF95F5137F74EFEF4C22C0B6ADA7E6D1D6A6DEA9C805297FFEC11FAAB9AA5E4304D43FFA53CD8D4EC9867BC9EC4053498B8BA36B274785B01E0580EDDF7BC814C13C897640021FF7E673DCD7DE428AC2E7BCF0CFE4925E325C1072FDBCFAD271DF5E036FE751C4667C0E7BAEB9B5DF4B0F5F92AEFDA5E3341F3DB477712F197EBF2B52C291CA0788A866C4876F29E5077630B7E271106EA1D5DE5C114204CC9BE97FD07144933E76A2DC7FF562E1C629990F56FFD2231A11A0AAEA75BF3EE76B2A5C12020C0D774AD31320025A2EBB168E9216CF2218963BEE5A6111018EB4575E3719D15E327CBE82A4FCF5DAE50DAAAA5E4904D4BFF298E6563C0EC4BD7E5E7DB43021597248E67865B32D1D215610805D8B7F640D4AB4B94ADBB23254B7EC542A0EED5418637593A69CF1809B1CD237C1978A5B757417CA8FEC8631B11E3B6EFF2900A0F9CE5F58225C2E1D5BACBD7886F7E17E64685A5E52D8B7BF4D9CF35B09C029FF7C51F59220B7E27110AE9B7E48BE0821023C5E6F936D5B4F11015B97F749B4799C9271FE948F9AD41EB178CD0BA75D56E7961000B87866A064DCC9DBDF0411D07AF9B568B9F85F9DC35F5928801ECD71F0A0EC4706909794973ED41772CE1B7C7A94C61ED8C8DD8AC7AE995FE8879B2F9117DDA03A7268EF62E9A4136DDBF997D86E9C22231104C864A3DA767222F26A5EDF0F72094357B8732F95AE7199859ACEBD703C3E6CFDDFBF9199DA7FDED864F3203232968594FFD3165415A6DC0200930E6F5279C0476EC5E3D61F1FD31C97CCC9AE394A8A102260ECF8C951DBB61E25029AEF5E618AAA11B2905332F3EF84D86E55958254555DF0B2725A4331845C7B717D06576BBE7B0589EA1AB8C64DED87C209088515DBB6765C34C3B7342719394839E5D4331E600AABABB0BA941AD1CEDD8AC73DFFEB1E4B1F97D61C17CDC8AD398ACE217D8F8B66F81F746CD1648C99200F5EFDEFC28D53505606AF5FA371762B27009CF35B916D35388F2563DD6BA46D3BC6E8F13878CD62B8C5F5043C188B2E1000064A01C84FC60052FEEBA0BF8E2BFC1A0230D96951DD8A477D629DDC73E35DAE3447C9114204BCBED5968E2D56100107AEBA511813EA6421A7642E74AC37C57D8A4D9CF3865736E5E99964B17079C5CF1823C9083874E5221813EBE016778C37059F62DB5CE59F796593BEB020197D48F1FAFDF73346DE515A8A07029CB9158FDB97FCB457735C38774C935BF158748410008FC7DB640B6BB51D0CCB8F6FB8C374E314844250827E9A1032554A8F80EBDD4649D3C6D402AEF0468D33A752D3610743D875C377E1169707FD98103291C1658CB9C27D75B3B1802BBC5165A0532A84EA563C1EFDE2A5A27BEAAC639AA308F1587484648E5877FBED803CD27EE6B976F7B4D94E21A7644ACC11159C87BC609CF3594D9B06F44CB21801A428EC6622607C35A9936B185466A3E3CC73D03DFD6C1481AB1483CB18EB87ABF8BDE4463CDAD535F2E3CB1659448094F6CAAFDE7D75D4AD781C102112C51C955535ADB6301F234834CF5F64B8714A66EE9E3482348284CAF935CFBE75A03A9F027F755372195794393E55D2E808B8E6F76044C0014162E7FC7F43A9B8CFBF7DA83A6F740CC02DA45332D7B0EBFC2B2DDBEB938E6DADBD609AF7E162DBC1C7CADE62E6AC9EE382E9FEA5B623D6E9E10AB97F66A3E5C6290010F681558648214635E1F2CA077291F1A7E73F0C2B9CCF0701752359EFA7183F524340B56184CB71605623861517C09F5FD99115B71029D1DA29CE9153660809A9EB7AF20EB970A12CA61D5C720EC91C6F6D17D211623901383CE94C61548D94859C92B189D5A4110095AB57BEBA31DE904D818F193B71A5C2585DC44F4AD8774C2B1111C6552920105A26CD80513512A5E0BEBE3999B5FCCE855B88949D53CE35A847735CF8FCCA66B7E2715872C80005BFDA5635B967DC0CD38D5300C0C341B5959456F02A5F3C908CB5AFEEAA630ABB9408985C43834E501E5450EE7760AB1EECAD9D8121E3F6D82B1F74E5C5CD45CA81EA3ACBD0FCD271C4BAB9D3FC4B8BE93C0E5B84648E6867FBED90F248A7AFCA8E85AA9D424EC9D8A808719581B8C21BFFF65172415F05EEF3F9EF6744DE9A30710FCF5E8D4DAC6650994497AF0AB150354AC17D73ABBE000090CA4894C2B80349310265F28067D4B1FECA33CF48B7E23117292547081150356264AB6D5B8F11011F2B230D374E01008581C6F68C564561379361100201FCEDA5ED0D9CF34655018DAFA29CED514D65A80A491001BBF948948ACB1823C4E378734BD215EE40527689F25ECD719EB1ADC9AD78EC47CA701242049C37D5BFD471C43A138A3C6207845BF135B28CB8570571CEE7BCB52DB510C120B8CA1713A547B2C2F26B9571950A029A03030A5AEC004AC5A568B428DC8CB59BAA8809C596D2693E92E9AF14D10EEE2565E0FD6645AD6364BB37F5E041F976D4F92529987328CAACAA0814B71F6A6C50A8BBBAB8C988AE7FE3A977F7F914DEC849528DC7E0802FBF4E2142759864A20D7428CA501D011497F77FF4C3D547ECF3F9DCE3A6EFA782DCD7262D02201D7BE557CEAA892299CCD74E70BD5EC469A88CF8FD38A792AD5EB74F5C6B136FDCDF21AD09555478B8A652A8B4E3FC088544926BB3A47416130123651757120E819035A4FB5AC26496944271A482FD1DD23E51B8FB3BA4654B48C7116B3F7FAAEF6147D7DDF4785C9132E408C9CCDD46AAEB0E7F20F44E7B0CDEAA20F1A037CFD27E2A05C4E3A06814E3E3EDDAB6F0145D53B52F298E45355DFB38C9F0B115B91CCE89EB70DA635240220529657B0CDA89C595BA914ADEE1388EEBC54337A40C3D427AE6EEF3A6479AD735EBBF5455EDF6031D8E79EA68E62DE414747622D8D1C1C22853626535F6C843DBB8926A25481B04E475CE9E36C7C82C53D8B68D138D2B84F5CBF3A6479A07FA61A8A40C3D42FAD8E7EAFD4BDF6B36CE4B99CAECD6A814D561E2F99C828E0EA0BD1DA35BDF563F9E7DB13362F33B1C9170DFF5ACACCE69E9929625201D5BACFB5CBD7F29007C12B88EE3641D9C432165E811D237C13B8E7C6FA7BE4A21E5D1966E695504E95882CFE114B4B521D8D6C6261C39AA29DD2D04610E5C64ECE71C5340B674CBF48D03B6589E99323E29DC5C3346A9A40C2B2100307BB277F5FBBBCC6B8978E3A12E698DAB202D9F53D0D606B4B6A26CDB36059595B9567E7B9DB33FE6357BA68CA7CE9EE26FFAA471874ACA719DB23266E8C93BFC81D03B9D71782BB8C903469CE5730ADADBD347FEE57874D81E91303DB6749CE696037B1763D2944F05EE504839EE1102009F9B1A697E7F573AC11F8DC19AA4473D059DD2D999BFF627451ED6C6F7F61BE69D3725FA69C11D4E528E4B8400C0CE6D9BEF3DF5F419F31350EBBA5224221D1D3CAF53BABBF39EEFF0A8A99603261D21D6CE3CC5F7F0A0847AA2701389823A6528A41C9708412A857F993DDEFA3061AF2462AB0E87C658E1AEF715D6D646399D128BE5168095A39DAEF2D10252EABA91A7F63FCEB8B2B959CA783CAF4E192A29C34F489F447A665DCDC31FEED6E713571B8F8E98648DFC689396D3298944CE531EFAEADCDEDA7FCEA991E64F02F7B3FBDE6D464545419D32545286B4FC4E05C4977CF145292CF33E02D051374318A43A399D6218E99FB158FAF79D9D407B3BBA279C26AC5044DAC27AF7CC49FE656E44DF71C16D6F4FE7A2CECE344E3CDEBB745F1429039B5CC3BDDA5B487C2512D1BD523A478900DBB0723BC5B6B33AA7ECE567B9D6719454553DFBC3DDC9A585C8386EB86D6D382EA41CB708F1F9806010321C06CACB818A0AA0B212E5E5953F57181B11DEBD55F177B7325456A6FF5E56961E218140BA51A328E99F8140FAF76565E9D7555662F40B8F7B7ADAAFD7BCB7B5BD169F00EEBB5FFA5A2D2A2BD3E72F2F4FE30583C54D5B00609A691293C934A1C73587F45C5C46856EAC9ADAE051D5058A3069C4B6F7345457E77F7F16A7A0B212FE5494850FED52626326D50483A195002EFF44702B2A2E1F5632B21414C39FD47B2E926A6A68CB7EE307444045FB7EAEFA3D84AAAAFCEFCDE214545703555518B9FB032D356A9C4EAADAB865BFBE60EA38EFEA138DFB51CDB40553BDB1D5C34646347A827488CF878FF62697714599ED714C5621BAD55CCB13FD2C87535055055616A6CA588BDA1A19672A4C59CC187B7A50F97B22706B6A9E2E66C93D2F195934D071D1211FEEECAA0B0443371301D5AAAEA1BCDCDD1B73382533774754C1632484C1F9EC2DFB92CB00FCF0D3805B32195909390E01E2EFB98323E423EE553D4C22ECAE8599C72999B9BBCA27B54309E82A576FDEB8B3EB0F674C3EA64B3E29DC92C9E8EA3AFE11B2E3A0BE4055B54646A0CA10A9205FC11E40B27EBAED7FFB75A59053100CC2EBF3B0B023794C87D7EFF7DF9F49F09F14EE90C838DE8430C6A8F990B19808280F92CAA8C717BEDCCE71544DB65E72AD59A3273DDE6494E5734AE63C15215293A6B449E58DCD87F405F563FD4F7F12B875A307141645924159081956A5BEE3404F42E56061DF80AE5D0EBD109DF159213D5ED975E1E5961BA7F45C3495074825005CE13FD8BE3F79EF2781BBE695F5EA90C8389E497DCBEE6309B522C834373AC5618A8C8D39551001C6B8897662FA4C1130E3DC8DF80AF988A74CD84903533C9A7A3B08CE89C4D52D5637F5F4E90F00B8B564328E4B849866CF674E27D4A097B847CD73E7479F111B1B512BA4A24A619AAF1080EE299FB19CAA6AE9567CA547ABD4288DAB9E585C4055D5453BF6C767954CC6718990540ABBDB9D05AA964EA891808B5B317D3E381232CE344100846DAD623623F2F81AE235B522A439AA1BF1650A9B71450111702271550E16F6138FA5A4D034ED1EC6D8154E67A72C9A8C2CC270C88B8BACBCBCF70939617F9F845AC062F05A9248DAB6585B7FE1D9AF384EFAFB8B715F44D881902CE4142925E2BA043120EC27309703AB1FAE79B468DC8C857DA42A0CA4AABC71F7E1D4C292C8C8B27432E40729EF3A945CA628CA6C956C166496AB0741DA0E645C9702002CCBBC0FF1384EB9606693B0ACD50E48763B9E824F02EA4ED8B025830A0741E6EEF15A037165388C5392878BC2EDEDB513A8CC63AB00C014E59617B71D548B2623CBE2E2902244D793B3348F763B111031A3E9BB3CCCC29F29A6F7DC4EE3D84FD64DAE5E8F440288C7D1D595FEFEA26E49DB14C8F9404CC37290120C444099D98D5270278F09AECFE414B7B803AB29BF95E45E692A8AD293E08B25234B73ACE4A43EB69293D6F3A8BB60F751AE453B1892C982CE31059C94210501A95432B11C86917E4F2281195F9AD36A5BD66304A02BE118B9A6AA58CA411AB7155AB40325E1F649F49FA91F5D103757695B163DD29BE0F79C7A7643516464E9A5941C217B8FA416AA2A6F546C8B42FB9BD55EA002CE89F78C526199BF3A7542457AF9A10F291346F997DAB658E748C8B82E07CD4549C3812D1998B010DCD78C5270A7D4F659F6E8C91985707395B6BCB39D855AF6649EE9722BBBE106724D86610C4F846CFAE07D952BCA2D0420BCF15D953A3AA81F600EE71896B42D216DE938CDDBB66CBEB7FF1FD3A4C848443A76FAFB8B29430ADB39D6C296522265489004C29BDE0375B463C8B819E5EE3839710BE98CC0C75B394FC649E5BC61EFE1C49252C9283942A64E9BFE80A2B03ACF813D8A77F306DE3B6F16704E5C97E96F1C09EBD18B2E387BF028EC2165FC69639B84B0564B40C675D97B8268D286048376700FBC9BDE4729B88DE7CFCA39FA6B6BFC59710BE90CEA68A7D0BA37D2CF07D3D4EBDEB9F69BE152C8284987A452C9593E9F7F1100845E58ADC270D7534E4AD57224A46D8B75B523030FE67C61CFC57675B6DF5E3DA2E65C53A0C6B2C991D26196CD4024117AE169404F96849BEB7EAE8C0DC455153037A2CFB3678FE29954AF981327D78DAB1DBF0ADDDDD7174B46CF94E5FEA10135114E9AAADE4390F0BFF81CE73BB631CAAC5A6646449611EBA47499321D41907084B51C851EC862189876C629ADC24A3FA02096144632618120E17FF905F0ED5BE1121729D37132B86E1A4BA7D78DEEC58DA76CA318051EFEC36F358284A6F22B0F3CF16C43B164141D2187DA920B559537522C4681C77EA7424D8B632AE0E1A4276C81410A61AD1E3732E46A9F111806C68E082C3DDC9E3A5732F679C938583C06FFA3FF09A8DC2D2EC0C085B0FEFF98118126B79F33834BC4E7A474DBF22593AA1BD1C7BABA28F0C7DFABC9AF5D6F7195DF4ADBB7BF2A2311E9968CA292FAC63E893CF8C072955A5AA86FE2CA356285701C53F50A0252869EBAB798E95102D2D4F59F524F232DF0F39F805A0EC315AE69C3E41E10A4E2D876D48D4EE997E07B1E8C9022CD7252BA742BFA7C7FFC03570E1D2495F38643AD8965C5909156EA2E19993A6DFA034C6175EA3FDE543C4FFE89F7BBC03CCE4945AA2C10605AE6AFC693DE8C224DF37ABECC14E6A8EFFC1D9E3F3F0ED7B8C1084898B01DC7F2783D5FDEB6BFB5DA3529A689519A68B284F5140848FACB4CB7A28F8EB450F0CE251EA413FC355B37EFAC2EAAA7E4860F3D959CA5A9EA220210F8DE77D48CB22EE41CCB1FB4452872ACDCCCB25490CF0E1EE9CEE05A81EF7F07AE71BD01D88120D88E1DF0FDD70B0E23AAA9A8A8FCB92B45DF27677475B47F07521EB18265B620C5712BFAD4BFBDC63C6B9E537A718B22A440895B195649D3B47B8800DFAA07B9F2C1FB2C23E20A392735FDACCC975C1E3D5F24AC7C37360F5A2B02FAE22ACAFBEBE116573F6D1A0880F6A73F2070E7128D757792A6A90B8E08DE9097940109BCBEFB48AB10E90723A4269F6A16A3C0FD7D705B5A630DC316212D6DF1252AE78DACAB93BC3FB94F1DA8AC7339C71A3F49C85058DA42AC1B55157C30D772732E2B19B77602A43F08F6DE3BF0AD7C106CFF3EF2AE7A28F388C1BB597939652525473535B232B0D4B1EDF79C4885634EAC136E45DF405C72F955F5BC11B27BF7C7614D4BEF22E3BFE9EB1AC5FA3C7C3E8F73A461487DDE6556BA82938F390F3D2473DDF692CD366CDC562A2E8C2F5D0C2209ED8F8FF77AC0FBB31FABCADE3DA4AA7CCED18EC4B241E2314F69EB3CF288741C7B1511609CF3054B1A86742BFA06E10E35426AC7D5AE5218AB53DF784D51FF9A6517991CCE31BF788180DF2F6D21D65697FB1FEE97705D58A9B8D6B9E7033E2FD8CB2FC1F3D8EFFBDF9A74E3420F01D054F59AFD52ADED474A019D51B5F2FED5B6106BE1F349636EA3558C02EF8BBBEFC0D1DA92AB2CDDD01B544DBD120478BFB948CBABACFB38C70904A579D957040810B65825172E94FDAAA00276B43D562A2ECC2FCF4B5766FFF75783E607E5EDB798FADC330A31AA0986422BFB2DB3B8107D9665DE0702CC79970AC7E7936E45DF20DC5222A42CA092DAF3786DEF8F96AA6CFF3E2A24E232CE31BFFE0D0BA1901496B57AC45597350DAA820A24F25271ADEB6E000241B0A79F82F6C6EB595FEEBD6991C6BA3A49E5BCB163C4D805BDA4B8107D3537DEB0DEB1D35B69E8777CDF2C4681F7C56DEF4C2C289A90B68EF81295F30665CF1E527FF51FEEB683330CC8CA2A29AEFC97F46327F4D4BD59ABA03C563A6E25ACF957007A0ADE9F2CCF4D782C4A9EFB96F5DCC6A32C66F5F5544CDB75DF9E3DB748C7697666CFB1ED69D31DB7A26F206EBE043F28A9EFDE752C917BEE58D23FA116F2CDAA5F99E96FAB3ACF8F9A794673B62A28976DDAB4AD74DC5FAC4CF7F75F781ECAEE5DF96F50F8F52FB9F2E106C6B932BBA32BB1AC98B6EB19575D16B56DF11C11603CB4CA2846810FC2CD994306D8B8DADA558CB13AE5F5D714E5AFEEB783B33F7FAE639F3FD7761CA779EF9E3DB7E42C4D7358C9B85F380FF6F973811DDBE1FDCE1277EAFF8EDB34A4BB7C371F193BB1AE98B66B4524B05408B14E8E9F20ADEFDD55D45E597D715B5ADAEB0A468861E80D9A96DE27C373D3A2A2BECF2BEEF9A1957EBA9A786EFAF453A339F54216EBE88C0D0517A472B0575E0673B912A0FCFD2DA63EFA08678CBCFE80FFFE62DAAED2E391B62D961301E2D66F0B1976BFA3DC20DC7C3924E03B96C8B5654B552A9450FB8ED2AF5E2D9CF3D3BBC86CF9A8A723974B2FE449E425E19EF7455B4AE9B011356651A3F5BBB7AB99441BBDE2AA05C5B45D2BCA434DB6106B112997D6CF7E6E958ADBDD9D25C127750B49DD426777FCB6A46E2552DB9A93325CDC46C1A96DCDC9A46E25BA63C9AF67DB90584622E90D7FEBEB07E10F036E3296D0E349DD4AD8D3A6D9C5BCDFFAD6CD5652B712D178EA0D0024172E84BCE20AC80B2E40A18D8A5B8EB6D7255266FB70E066DAD3524A20A55BD8FCD1B67022697C90D2AD843DEF1251CCC9C5B76EB652BA9588C553AF22D76ED17D48E96BC385DB1D4DAC48E956C278F165BD987348401AFF783795D2AD4434965CE1968CCC118D258705771021F184FE4849270E871DFDF0D1644AB712DDD1C482425B770FDCA56DB870DF7E7B9D5A2AB1CEB469764AB71229DD4AB47774CF2A660BEF61C5CD10A21B16922963876E5809675C6D515386F8FE5DA66E58897822F597BC6420FB7EEAC389DB1D8DDFA61B56C2D85EFCD467FDF467866E5889583C796B31FBA90F2B6E0F2164185604C041747612FBF083A26E2D75CE9F6B0380AEEBF3C365EE5AB3D4ABE7861797004A2452CF72CE8BDAC5A7DF004926BF189936757D313DF061C38D84D70300198605DBB67FAF28CA95C59EC8719C66D3346FF77ABDAEFBD51E8FDAE742F461C5EDECECAC0D87C32B1863E71091EBADA36DDB7EC7308C3BFD7EFFFA521C3A54DCF2F2B2F552A6AB6732CD74D5D6DDDD5DEEF1783E238470557672CEE5962D5BFE7ED659671557F669FDBF35D0DADA7642703FAD96F1472F21997F9CB44F87B1932E3849C8493B49C849424EDA49424E1272D28E83FDF700D9783E7E1935E3B10000000049454E44AE426082, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (5, 107, N'Chuyển bàn', NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (6, 108, N'Tách bàn', NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (7, 104, N'Thay đổi giá', NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (8, 113, N'Giảm giá', NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (9, 103, N'Tạm tính', NULL, 1, 0, 0)
INSERT [dbo].[GIAODIENCHUCNANGBANHANG] ([ID], [ChucNangID], [HienThi], [Hinh], [Visual], [Deleted], [Edit]) VALUES (10, 109, N'Đóng bàn', 0x89504E470D0A1A0A0000000D494844520000006400000064080600000070E29554000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000097048597300000EC300000EC301C76FA8640000321549444154785EED7D59B31DD775DEDADD7DC63BCF1346020488812040901429D2A414CB65972D59AA8A94A4924A5E5CE572D989DFF3E4E807E4C14939B63354D9E54C2E9513DB72D9A61DCB1C24911241429C0010000162BE17D3C51DCFD0C3CEF7ADD3BBD9F7DCE11C5084C4072F7261EFDE678FEBDB6BD8DD7DCE957FA0CF169934FDCCD16F89785F393E558E6BC5FEA0D4182A5AE98DACDFEB8B54136B7B31F522EB79620B892F45B1B668ADD7305656596EBC24C6A74D23F1AA35B2EC27DEA22FF1BD30292D3CFAC8E545F32DC1E79F3DFACC00625F90E04A635BA19EAC169ACBD5C02B7BA5466C878DB5DB132F79C8B776D25A3B219E3786EAE300A0AFD552AA58462F5652356297AC953B2C34621AF86719EDEF209D4B12B96A3CB9E489B9D4F0ED5520BA5A8B8AD14A7D391E8F879AFFE3FCF9F09B98069A927F6AF49901E4474726766347EF135FF699447658313390CD38A6D84F61038012845C441ECA624B624D9036F5C558DF58C334B2D684AD629B1823B89690E05863EB28AC21BF8CCFEEA1DFEB10FD9538912B9E3167961BF553E1E49DDA175F96A8D5FEA7433F15404E1C3F5EE8F7172ACBCDE56DD8C1E39EE7F74B22FB617FF6430B7641D8D362CCB809827EAF5C29984A554CA104061E858298A000185A78181F7BDE8321F3C1B052364E2D119010A8858D22B161536CA32E497D5592DA6A626B2B0D9B24B78D313750ED06A47011ADCFA2F6759B78B3D644738530B97DF8D42D80F793A59F282010114CB7788F3CBAA31F329C8A92E817C4B34F63120FE3E3ED90EC884E89B3420553ED9160645C828919F1FB87C5EB1B10AFB71FDC27A6544125235E1120954A48A134103C856E609B088C5ED75624595A90F8EE6D896E5D97E8E60D3094039F29686AA0A07389A5669C44F60748BF1BC6E189270EDEFA48BEA535E0865A351F34FDC40039717CAA5AAEC9685CF49E82201EC7C847B0C2292C7314A6A6CFABF655FDFEC1923F3625FEE008843F28AA19E58A7810BE6A05991A42EDF03CCC1E0608A981766819046CA1255A86CF942CF63DFD7B188A6D36A02935B13568CACAB2C48BF312CE5E93680E7C7B36913899875ADD81B9BC05CD7DC71AF32E4CE0E9C4F3CE1E3F79E57AABC3074B0F1C90B37BF796567A96A690DD6D8CFF0800780E831E13CF1C30951EF1C0A6DA2B5EFFA002E18F4DA780F403000452102CCC8B0A5B05CE4ED33C3F23A9F00982034901F2A1642D5306D3A77996693DB449EA354916EF4978E38A44B357A135D72406482C8BEFDD95248A2E03C8F3E8ED5D8CFA06DCD4DB412400A57FF9F0A95350AF07430F1C1038EB719890AF62A49FC7CE23180870A4044105C1F63D52D8BE570A3BF688E98119A2D9A1ACD5176067D3ECD027D017E44051764400524054F814782A7C0F403840141432354CB58C9FB7EA6BFF3061CD2B17A57EE65D593DF99AD8E5A53809EB31828508737F0F83BCEA59FB7F4CD93B73F8F5AB77D3D13F757A2080D069970B737D493D3E1E5B791622FA3C44B81FBB744A86C702F805138C4E8A19484D53B50F3B1F9A0041DB26EC3E1DB103836529003A590A3F07C21AED485305244DB58CD78E5360080AC1C900F230FEEA8AC40B77E16B66D5D734AF5D92E6850F24AEADDE3551781513388389BEE619FBBDAA5F3DBBE7CD0B0B3AB14F913E7540E82BFC2819375EE11163935F82A0BF04FBBED394CB153A647F6AA704533B2498DC2E092255EEFCA4D1908440802D6C7D4230500E3BDEEA3427F43C0099C0535E932768ED650484F9368D6160E0B815C5F90A4AE3E239A9BDFD86C4046871DEDAD5E51051DB09F4FDA289EDDF5B937C70F49DB99BAD497E3A84157DBAF4EB63FDBBB1DBBE00B1FD3AB6F7B310C28CD7D3570C763E6C8A079F107F7A178E7103D08244A2E565891616B0D845899696245A85B305380C552505C5517EE728286400A6F994D6D561AAFFB6C8E51566F69D6A21C7CBB452C7B4F06D552920C028ED3D80086F10432526BE37EF49D81C315643F4511C7D1ABF3FBB748ADD7D5A949FEF8F453F78727AA4D88CF778C6FB12BA7D1E2B78027EA1DF1B1C2DF8D33BC51B9D82E31EA10C258626C4759E0BC08C7E288C54F8990630753B9ABBBB2DED3A8F7EB6FC9C69DE9C5153A835E572CB9CA13C9A47C80CE7DF387F1A26EC8C84972E8449125F8629FDBE6FBC6FA39FB74CBDEF0A9C3D0FA5A95A7F32FAB101C1E8E6C2F187FA17A3DA612CEFE7D0E35711D21CE5414E23266884BF6B9F58444C49AD2ED10AEC343421AE21FCCC019117920A8A826C03644D9D5480CE416B9D3CA540B8B619D0F9B28DF2E84B7D0C81C1F9C62730604C147E65566A70F8AB3F7C0521F302FC5DED3ACCEADB7162FE67D18B5F2D2CF5CE3E7CFE7C88913E56EDFBA41FDB64FD0B86B57EED2B388BFD1380F1CB90C4769C298AC18E7D023325DEF836F8040BB3B424E1FCBC9AA718A0A8BF8089A0E9D86857E44D910A37CD324FA6D00AFDFD521C1991D2F8B81487865470ACA726CF010DD2B6F93E409BE595A8C6AACA2D93A67304583E0FAA08C983F1691C36EFE12CB352C43AC6100E4C5AF1FBEAA5F8AA19AFD4FFFDDC4A7AFBE6FEE9C702E4DD43D3DB9BA5F059ACF5AB10E0B3D08C87FCE1B15230B943BCE9DD087007B1553C052184AF08E12768A6E8B8B9585D744A4E285B0A0A44A00844656646FA0E1C90EAAE5D52469EA0944647A50060D8AFFA0380CE3EB27E1C284835D17F5BE4F2599903259D23CBD5A4C1B7F803880C9117DF0B9246AD02C006248E7A3D9314967DBFF66B63D57BBF3BB712A7372BEF8B3E112018C55033E252F879EBC9AFA0E8794C70A729954DB0FB11F177EE43483B2A712394E63D1CBEEE22948403A7DFD05D9703224F7901295180A9F05C9E57D59D3BA5FFF061197AE699162013132D9E9E96F214CEA074D230894D68A40ABFBD9F34D5C4E55D392FD394B3D4488FDA96824320FCDE3E29CEEC141F67A77861DED87AAD6A1BB5317CFC08B4E5B6EF17AE2CF48CAFFC87BB771380725FF48900F9CAF187066CA1FE8B89B15F156B5E800D1FF246268360FF51312353927845444DCB2A106A067D064D945B9813820A2915CC464271006475603668AA869E7842FA1F7D5482DEDE96DDCF134D4B059B16E3D5AE5E6D0932A56CBCB45FEDDFF54D4ACB359BA64A2918BA9152E6B85E4F2F80D9016D8CE8137D84C565A058B589AD26DEEAE5D5EAD8EA6F2F2CDCD7DDE3FB06E4BD83DB86132F3C88D0EF1B38813F87987D973734167830533ECC54029589575BBB33F3178CA472369DB466E14E409AC5BF8E537239DEFE60143408407A1F7E783D1820B627201C7BF5C2051D37AF9159AFAE7FA41F8F04CA5DAF29272069AA5A837A5EB922C1F058AB8D4DBC78E15E11E0F4C187F524BEBF604BC9E2EFCC2DE9F3996E69FD8A3A50B318EDF112F912A6F7056BE461DEF0F3B7EF85CF7808FE02212234A371EB9634EFDC919080B8D096A62A158EA6042897BAFC46D75919C84555994037220A288DC29436EA8B790A369766F578CD79A6A9E6F939A342685E0473C83313D7C600A272F0A8F43CF5BCDE02C2E17718527DCC13FBCF43CF1E6F4DA07BEA5A43DE3B78B0F8AB53DE08CE19BF8815FF53F00E7F70B4E4EFC04E1D99C4A93B90E6C2A234E92F52203442E18240EDBBD0A5F9728698F40114668C03223FCB7FAE1A825094CE9CFE622B6ADEBC29CBE7CFB702080A330F20F225466718CB6D16CE738D7682F363E74D9BE6D275F15F6A2AC3646A8B5D5D31F1C25D2C20EAA5B9F8B58901EF57A77A6EFFFEECB23E5AEE44F7A1218BBDD678473183A73181A3A65CE9334363E24DEEC419A38C1D033345ADE0C99B66CA9DB8290CEE302E80696E17EAAEA3CD0710A5C949E981191A78EC312923DFDE2ECBB3BC0BA2A074C7E7DBB9145C181E96DE3D7BA4B27DBB14119DF9D56A4BF3D23A99A6B83C989F691E00F264CF35AA05E0E62955A5BCFF10F8B094B63F5434C5127696075925BF646CB0FB4747267A74621DA86B40623F19F38DF93AB6C7E3E2079E37322132342149B957C2951618AA1D88A6140CEE3AB79094DDA2F2D7DC590463E4677E46A6BFFE7599FCF2971518AD97ABABCCEBFB25D7075293A614746170507AF7EF9711446A83C78E4965DB3684B47CE8054AC753E1B37DCA2EAFEBA009CE83C273156C7869FF11A93EF9BC7855DED4B6BB51FD056322982E7FA6D5F9D6D41520EF1D9D3C889AF41B4F48509CF47AFAC51BDB86F8B33F8BA618DE329AA289700BD189A70B5BB74810C3D7E1A79F5610E8A8ABD8ADC1C040EB96856B93D665BAAE6C2B621D5737E54CB828D728099BC147A44633D9FBC823D27FE8905477EC503FA566ABAD0D390F8AAE8BA0000C0243D6C86BC76EA91C7D4A0A333B0BE86604C6EF99C4B307D2996D495B02C25771782B3DB1E618A6F773D8017B4CB9DA6F06474506C7E0370A7AC6D0888A873E4ECC99A974F2EDA03042F1E10778901B40E83AF2ECB332FAFCF3D2BB77AF047D7D2D7BCCC1D3856B449363BDEE865C1B8EDB963A4D513F013315E0A049207AF7ED932ACC989A30688BFA0DD4CB3611DBB9BC2B2763133A4D81A3137F644C2A8F7D4E8ADB1FE253CE0ACCF271ACEA289F0DF1815D3AC30D694B4070F82B14832BC38991C7ACB14FE0D053E1330C03BFC1B9318A6AB4992937495D30B98D3C08BC1787B9A95FFE6519FDE217A5EFE0C18FA3A1941448D71E9C81E2289FDF84082ADBB503BA695B08DFEFE951D335F4D4535245AAA0B0BE137C9ACF4071E5399FC23B1140594A3BF74861DB2E41E08330B4B01BF3F93C56FF95F4E9E9A6B425202B3DF55169149E87873C64FD604CFA0603D33B24B6DCA34E5C1D3840E1A9388B66C86EE139F6B0E0021CE7E0F1E332028D187CFC7175A83CDCA9796823274C27D03582ED96F26DC0591F6E8E6D446D2128A5B131A93EF490F4ECDEADB76968425D1FD9462110B932DD8C9001A343B512C59214B6EF96F2E1C73D9CE82BA8F410A4FD9C35660CAD3695FBA61FB05160641A837D1953DDEF05A5A23F346EA46700733112C277641195F31B9B80417621EDE8CFFEAC8C4033B8600563035A237CB003262BEF865CDDAD780352DF02935A817FA35F61C0A111183F4CDB65A0B83CD7ED9C7CEA4F084E617A87548E7D4EFCA111982E6C682BC7703A9A7EFFE0585507DB803603C45C7E7407250F23689FC164A688B8199D165BC42918FE42C180A9724EDC4D70CD44C9EC8C660A6787C9AF7D4DFAB0C8021C7727DACCE464655D107D45569F73CC5DAFD7C9B544FF41DFD207474F33A6A0A43E859C0191AE9D32D0279D04053221307C8F2C189D504DF147C67BD07C1B4079DE168A4FA0F586B2DFB010CEDC2C14C28762CF1EC62CA671E6A81A4456B6DA878D60D577F0CE6D76F84B2745720B758BA603E70DC0812347D44CD19933BAD992D83665ED970CCAAEEF93D6F5D54D1F901EE749075F06203C88527394DC7A1DBB6BA4CE74A996A08C6FD5141FDA2F85C9ED016AF4A1E347ADC4FB5F7AE13E0039F40D31B13547903D06EC03824167CED37858AB4BC81017A68AB711543BD209B945EBEE26231FC0260F3DF9A40C20D6E7C2F4614F075250D9574A4EA09950EF87D2366E4EEEBAAB7E000AFD0AC16004C6B5A89660BD59A49663ED9FA038070FF930EA2AED392845387840CC93E72ED4DE3976EBA087549BE4694340C66EC2CA58CB686046F8CE2CFC8685338FEB8D96B9CA45552AA856B3D6C472691187AF3E84911AB5C041DE0FE541709C2DBA1B72F5736D5590EEFA3E885120CD57056BA0C6B8BEDBD99931355FA93FA18C7C84F3C1187CD1D4360FC7864948F740ECCF7FEEED23137C717C0DAD03E4FB4F6FAB0CDF9D99C434761AE34DE290E409D4CE16ABFAD83526183C003292E02E49898252C6A434C54EAA20B61F8099EAC119431F1C75205D08CD2054DE092E13A0EB37CD774359DD94F3D78C0C1921EA3A3A10B5C4830FA186171181A9C94D3545997DA679B51834E3E857FD2B52FA127F64544A3BF6181C1C61B6EC2E849D4FA3EBF1D6081FD33A4082A504A7A204477DBB4FFC60DC947B3C29F036BF81995A6D3DDB8076A8C3447D15185332553C2DE37983CF2C46BFF4253D7D77439C7C047348C0B5DF1C73A24CBBA56C6E6C93A6F9EB08E7A7C6E5CBBA966E88A12FB5832171013B5EDF8A647F2908999347CABCF3256AD691FAFD4352DA7758DF4B464DA8990090A03320E5A219C23047D06AD8144A1E6F20F20505355704833B98BB8A1370C489E598B696F78918DA16B008BD15D1810874FDA38FE4EE5FFEA5D44E9D52819232B0D9375298D2ECB32D09F51CBB79E5AFC3D959597EFB6D593D7D5AEF0C77438C16A9E90C895B2F3EB484BFAEFF14A0CCC183D5B96F433BBE3A6BBC212CE271CFD851DE0D49BB575A07087C0600B18730FC80F0F57F3873EB05AAE24E3BDC4EC884A5ED309934CFC314EFDA72E21A2E62219B523AF1E68D1BB2F2EEBBB2F0BDEF2930F9BE75C12E4DF35D515A5F416CE3687E5EEA172EC8EA9933D2B872A575B8A5A9E940BCBD539A99693978AE0B7D6DC6EC4FCF68600D8147C6E14F06F8CA2CEFFCEE025CE3DFC099240FCA3A4959930CA0709F35B69FDFC1305538743E05C484134456C2F81A83AD111499E62ABDE61B20034F3FAD36B713A9BA03E4E537DF947B7FF7776A4A687FD90F05E934223F5637C4FA0E080A276BEFF2608EDBB87851EAE7CF4BE3FAF5D66D8F0EC4D097778A03B06E36F69332C7513F8254A33072AA255A064BE18F0294F42923683CF60B335F397E1CF6AF451920E8CAF09E3DD251A082935050954209CE1CFE8383D054513B308013CC1AE68048395986897A5B049AD289B85397DF7843CD54082DD13745D857DA5F3BDF2F656D737DAAE0C858174168C27CAD627C6E868E4E1E5AC147067C9EA2EB4BFB55278EBE6246A177EE48036BA1A6AF9C3D2BCB308BE4950F3F94A81EE270D632E1E8693AF1EC4E91EB994DCF00C141C5373618C2AE1AC7ACC7BC42A96400061B2711548F8030AE6E038494171E0F7E34559C707690DA84B8F8706E4E165F7D55EA98ACA5338790B4AF74A18E3951B21BB31B7273CACF4F05E8CAD27C0C206A1F7C20217C09038A4E4453C5F7C168B66835623E21E523885BB754D3EA972EC92AD6431096DE7947164F9ED474E5F4198996717E332DB11BB1D3508D5D91DFC8EEAE6680CC5CDBEB5B233310C7844E9DDF502A0110DA55460A04832A08728BA399D20E68AED2088BB719E8CCDBEFE0AE230883DAD1E0E431710A85ED9DE0C96E1C1D03F5F3C2EC44AE5E1E0CE6B5DFB6325D174C32E7D2B876AD35D616444078B6A04C18182CBEFEBACCBFF28ADCFDCE7734BDF7DA6BB2F8D65BB2F4FEFBB20C0DE1CB1675F4CB1705F5AB91C5D6B7BF12235348B6F72E57D703B238B0E21BDF4E6082239C29B5C330DC758E298DACB28590D36B273CA67C4E5D86B9EA0610869DF573E77477A9A942B1EB6BD37C0761E5C9B5D579BAB9BB7CBE8C2699DA0A33C3E88B36DF6DBE0D099B4F6FCD23F4E51D0B46690492A62F8496443059DC6C315F818209D3770C906AE08000890E5EBB111949AC996C16A3F53EA467B9E9C3F18C414B8679ADE68A3E844E89F611EC164872792E8A9DA8C0A8CA305945F8904E80D0C935E04CEBD8410663647D304D05952F7363B97C37B4A60D53705ECB94297832408820D088CE9DB785681936235A03386886BE011CBBF31FD958A9B570A93B2472630B00697D338C1F189E96C7CA5E91C2D212AE57A9D83B80B0D80CA38BD6292EE0EB36F0359C183ACC7C0706E1A14F07738C721E94024C5023101C04B70C755301704746E0CC6FE4D8B55E53C6B159D825656D73203880B91ECBC891F7E5E0C742686B037EA4F6DE7BB20A7BAFD15E07D2C7BF3B76A82F61BF3ABF54266B6484719D1CF59AD12BBF2F693C1E667A6D12F7BE77F0A03AF66C7DB55A936A33849DABA191218ADCE51B00D2CE9C84CFC883A12026A9CE1C659B11EFF170C1F41B16AA9C17D4469C7DE6040BEE44AE9EB6E106E02E459468B9FB614A128E0FF312C3DC1010323524C499A40E60686E3A11C35E3EE30960BED680914B55C00E10322D2EEF3172C37B5E807AE5C84BFA446EA91DCB00A95762E4ED202A00102C85084243DC77FDB8AB39885BA89B800E8E6B3E80E27D1EA69D8826A179F5AA24040382E224F29C8D91CF3B30B8B82E28DF9E73573068C769DF61962238F00861690400620041802CEFD3C1F687284F90EF4434598574CDB4081918ED168473E7BCB931C898956E78B522368813DBB7D203FFC03EF90FC98B711434520182AD581528F2FBDE59276015083A7120B0B1E6C1D4906217A12E89F6968E4F202427E4ACBF3CA35FA65A272D73F94EA487B114808402A76F60589B6AA58E9DD37A371ECBA93934679D480F895C3300717270F271EC40512DA11C99F2BA65B27069689960F4C2B526CB83BB47B532605189B2633D04110807066AE8200E145EBB729E42F9D64817F7AD1851D1761B084DFB41994E9C29385B0CF3E41430652EA81BC218344D16E39085268840F0ACC3880E60381094D335D1B7514BF410DC81F4E48DC3A1BEB694EBC3B1AE894C39324DE7CEBCFE1205CA216FDF4BA462575B825B0308960D7BD3FA951D0503AC8852204E28E84C074B07D76B96F31635B4846927D28803A1A07372BA1094EB42903AC167D116CB3916AFDD2EEB4404048215984702AF6DD37E32E6B8ED8CFEE967D46F76205D33B444BF71C5B669BF1C271B0BE5BA9E569314147C4E39B11E96693C538CFD58C3D20C10256B1169B5CAD8A1364092092B1DD40DE606CE06C720DAAE1351388E71B9865D5F609767B9CE8126869111CD104C8F3AC976425972FBB624303BAA0DCE473981314D3913A24B3916E7C47E55701D88F5B9E6B47D5E16591ED57C57A64D3EFE8C2BE6BF898596F0B547900ADF11A6B86616ACAEFFA51DE6593BCD2D48AFD3769DC8B5756D546029B7A6D9AAA3E3E4CBB86B01480CA71BE2FCA2A60542A70954465E9D323EA3D336303BD4B23520B04FF6CDEB5C9A95B10E180518716BD21A6C97B2EB5BFBCA95E53FCB289534131C186C5D5AC1D01A40A0AC38B9905B83A98038C9DC2E58C75C00EB7147C134B4A2880EC4BE60DEF2C270AC7DB20A58FB659E9F71D7B27F00D27CFD75A97FFBDBD2FCE10F25C2E13241C84A8E3EFC509A6FBC21F5BFFA2B89DE7AAB3567CECFF59D5E6FC9F40B086769863A913E1DE49CA8556EEE3976656B528C81044DA8858C5CA120266A548BA1DAC80C9084C6CA187832D3FA1D0F152C7617C100B73A6A75EA78CD20B4BD1096DE62E9402E005050780DCE84CF94FD32459F1A09D107D01193290098A4F8DC3969BEFAAA34FEE66FA4FE177FA1DC78F1452D8BA121F41F4E3099B0739CCD3B5747F398136FADF38E6E47C25A19C26B8080B6AE2F9D7F9A77FDEA35F364B64DCD222C55E2255EBD91041B0062A506D7DE0A2FF8AB3A443000182928AE6337583EAFB6BB5B678830D11F196901C23E50D60E8CEE3A00E2A13F9A9E0C105E832DFC48080D69FCF55F4BFD4FFE44997996F1331512169F713A4F27A035692ECF33059F7276F3768C06278CDC301F37C61AADCCF5AB9C5A9A162090534B43E2C4979AD11B683940C28297A031421F8154617ED800A07808CF74474385DD403A70CAAE8C510D9D2DCF189DC8C024043333FADAA60291EB87A68F2078D40A3201A0A6B01E17C57A69AACCB61B715A2F5F57F3E96719B75DF34E43B0638778985B27D2F09D911CE7E9C644DA9ED779108C341A53F9F2F7BA685560BB6C6C9613BFAA962903A4520F12A8C8024E870405A773000650D45C118C5C68970DCA1475F59ABB8531BF335BF4299B906A0876A10FD3C0856B3F04824CE1533352D672B471E33AC1E505DD0DAFAB9FF6E5D6A479A434A5853D7BC4EBE2E19A3E906234470D76F34B5397D76BF69D93A19AAA084108D6878A51E0C54B23BDB15AA60C90726599366A1E5515107556004551E5C1879C1F2C5D8063AAAD9E8C61B6F450B51520E88B0BF6C7C624E017FED91F854F7F4153E3806039FBA7D01CB32CCDEB42B7E0AC7EDA46E7EACADA3E73A93F302085FDFBC574F1A60CA33ADE0323206CEF6491CFEB35FB4F3544E781F525D010CB5F54003436F096FEE0E54B6B35A4B9EC27F02277D0058EB5A8163650152769F810DE16F1294476E606441D97770B6219CD1627B9E5ED6B12EA07BB7649C087599C2C8A38195D04C74959FB4EFBD7F1C9AC935E6FC5F9BEB279A6D7EEB3EC1AC2E206F1F9CA28DF94E9E443B06178BF2B4478CDF38EF6CD31D86F2E65DF949DCA908142C2674BAD0D0B79DFC651FDC62ACC8BFB91810C90C5FE12B6A7998364F46BBCB6095F005654090635C42D2037A89B88BBA60AF396FA8687B63CA16EC047BD340F6998A97DA4FD6BBFCCE7D35C792776EDD695BB31DCB52BC3F8C1EEDDBA416846B9EE4D893B1C9680FE430FA00C36F27307BB54C7A5FC78A20720DCE4DCEC143FFEBF0D8B740346920E7D2D20C57022329EBD860A37D5C6D571E06AD474A21A0D91B993D3C194D309E8E0695E6F635FBD8A813B445BA8EBF34588BD7B5B111776E46602CFFACF71FB753BBBBED6946FD2BF328456E08F111C3C08A96462D99068FBF5D6BDF31F34B1E83B2F878C794DD9292005B8027EF5CD053E96BFED78A3D12C64BB371BF9F89B6FC6CB05FF264CC76D5E2700836C001C3B5281A5A064824B07CD4F827756794AD6680B13DD9208F6D49414BFF005D516F5576DFDADB94EC7D4EBCDEA384EEB68FDF49A755CBD7C7D6E88C2A14312505B61B650984E7013827F8D2E5E94181B2F33DDB9FE741CE699425EFC0680DEA207E8FCD5545BE3AD7D1EFB64D633DE9542B89AEDDE0C10749C3CF3F357EF25D6DE817ECCC3E93469B6180DD0C6B343DAC0F6682B3F11320F647AAB1B87B78EB7B0D986C278EA29F1E1481979B9E0618DE052CEF26CD75EDE56B79DF36D5D7D8D202B9596A63EF184787C1760932F1165844DC6A0250620C9B56B991CD6F49BE6F51AF2A2EC5A37210BD8A83075ABAD672D3814DEB0BEB97C6BA5BA1E1092F9A6D0B1DF069FC4E5BCC0DE25AB8B2D2D61A7E45460ED13C8AEE13B084AF8DE7BFA34AE13D1797A7C13F0D831098E1F6FD96FF693E36C71B97C9E5DF9569FB7F7A3D7B4EDFC86144DD50B2FA833EF4434C5BC531D5FB820097CA5F6D92E039727E01C834F14B14E1EB2F57784C1EA1644AE996678F10B4F5DD24321690363E9CFA3EE6980B0C0D02CBA879D9EE0A0C69D44E74B2D7183A27636B8BB065B4C38FAD18F54533A9A2DF425EC130ED50720C1D1A32A24ED33B73815E246F994F1CFBA3265D4CD0BCCB5F5F8A8999AF1CC33E21F3922066722FE267027A2138F4F9FD654EF20A04CFB73FDE33ACB533B68AEF8868A0773DEE08D505A9D106703417896DCB8B35459906F4926A4758034ADBD0717F53EC2B1054603D13C7C7CDC6C69070F71543D22EF8482366E022EE5338888EF5A5DB9A28F453B465C20333E2E1E1CAAFFB9CFA9F9F2D2FB49F94042C774E3BAFC569CB6CBF24C39776E2CF82E0F7EC3FFFCE7C5DBB7AFB531506753C22ED5DB437CBFEA240C081FB03174459B3C186E4C9665DA01668C9B2CDF9304802471BC648D7C80C29B5FBC74A98E761A6191D63D4DFA37134349E0254BC83E03041FB6CD508AC338C0F50FB7048B104FC33C4E0695D6A8689A27CA7AC0E3C20920FC047F0EBC1369A8C98322C1E0D347689A71AFD7B0EFDC58CAB8CE84D1C6DA5F7B1953688679F861F1A019DE73CFE946A086F2B32D89A61807DFF0ADB7247CE9A5D6636094B9B148599EA9031E074C7F7818C78F9A346E5D9568E10EF2F56BA8F41A2A9DF8FDB945E43FA67580FCCAF68538280DD49328396EADDD8E41ABC1C0B0E18F75F1BE960923BDC94753C4E133ED7060B86B7CC6CFF5C40D1FC1C9E95B2C5B11FBA0AD655D0282BCF09AE50425175E3ACE76761BAFA94753C4FEF82B0DD0420F66D11C382006F35233C53E3A10353D865FE46DFD847793B9391D71CC94744E646A07EF467073611344CBF352BF06BF83080B7EE81CAAFC293AF9E0F7E656F420EE681D20FFF98624BFF3CC6273EE4EDF1E743E090732ED577A7CBF549142EF800A453524BDE9B711202E4FD325D8E18C62B8530C4C9E4EB6131104EC2AC35098DFBC2210BC1DC331D9773B3BB3C6D495311A2463F71BDE97E2091CD19C79F659313055EC5FE7D2CD7C785B08E7ABF0C517D57F08C0696FA5EB4D49E741138F357B83FCFA812FCDBB7352BF7C8EFE038B3027CBC5E4BFA1DB9B002473E8A40D1F80FFBB53626627287DCBDFE97814FB03707B521A9D44825D4E55E51D4EA6D4000A834240BAC68431E5CE5E5D1543C7B66D5B6BE2E46E080BE3FB1806F6DEE000495343C1D2AC09B58866905AC494DAC7323A670A9BBB9FF59F7C52E4E9A7C53CFEB8084EE1DAB61B1395A3E4FC79894F9C9004818AE5A36302C40FDAFAD02BAC5F8314060D18CBF456A50933D5BC755DC27BB718DE7EE0897DC52B857F7B78F7ADDA374F7DEC3F481B0302BE3D5AB1891740CFE5511B2765CF878B1A86E3452CEDF1452F9A2D02027680E481C9C0A1464153F48622637C084DFD49DB62D6113FE7E228700A9921297C910AD4099DF69F0001304D6192045A25D048E1974C71D0133AEC5DBB44F8934F1C9F26AAD3D88EB0463E5B49E0C41302C2A8111ABF4682B9BE58AE5A49478E39EA1DE3822FF51B1F49F3CEACC4F515FE84ECCB90CC4BA776CDBD7378833FBBB4E9CCD0B9397974FA195FECBFC5E5B1A07770A667EF21298F4C4B50A8AA0AF3BC41DBAA5A824A9B6A0AF3109E0FE1F85FFB9A78DCA99DFCC9468471B2D4E537232728A62E7F9F446DB0EFBE2BF1CB2F4B0C50F47B32648C9DA4A932F238502BABB6F26928D66BFBE03B92A6DC3BF9AA346FCF22BA8A7822FC264E727F76F047D7CE6356EB16B1A18690F86B9ABF39D95FC620558468DBD078867F41C0AFF64A71907FF203EBC444E84BF2AFEBACD310071027CB8889BE80F5B9E329287CDE35B1BE63B6DB8AF3753F09F12EEE3BEF48F21A82A1CB97F58EAEA37629EA35C651DFC1288EDA014D8EE0C0EB7397115D5DE76D289C92EDDBD67A7FBE5AAA9CDA7EED2E04B19E360584F4AFB7F79946280DDF33BBB00B76248D7A21A8F67AC57E84A6FCFE2141C9F9920C044ECEE5DD35EBF020E5C2459A2E6A09ED397DC56781B86978BB07873E6A86A5CF3873A6F582DD26440D21185C034D319FA3E8B3949EAAD4EFCECAEAB50F6DB4BC98C0999F41BD17FDC07EF7F889CB6B42DD3C6D298917AE2F35F71E18996D3462FEC0E114747204BBA0C053676160447C80A2EF4A91A12DAA2929007960B48C8C4E1414BE49C85DC75094FEA01B9FF29320AC4378A7FABBDF15FBE69B22172EB47C651BE567CAF571EEFA5244EAC899C63055B5D94BB27AF5438B20A0E119FB12F8BF14CAE1B5DFB9525BDF694A5B02F22D6C80DFBEB410FDC6445F0051F3AFA31D80F1ACDA2436853E1C78100AFBFC511A9A2E82C1340742BB09CB40613DEE449A3086C6D4103A5B02F3D3200A9DAF9ABEFFBE08B4C230BD7DBB353FACCB9928078433518E150C6A3C361743ECD824B272F543A9DFBC2AF1D262CD887D07C7CAEF14ABE14BB3853BB53FBCF4F1AD9276EACA56FCC6C8E08A04D00FB1476CD41C80FA957136119F7FD2817F90C501424D61EA0000E73585B65D4162A73C533084E42BA5FCCC81424AEB3E50C29C39073D2BF1B90635F68D37444E9D12999D6D9DB5D2AA9B91BE0D4D534530A8ED3C91079E3471D65B3EFF1EC3DD26B46E0E555FF4C57FE5D089B9B35B8141EA0A906F1C5C0C7B9B0331002960774027EDF6787545FD48796C2ABDDF04C1A780D016539C19300425078CCBE39FD6EEA4402804849899A6F0FECF83248E4BD3496D40482B3FFCA1089F741220B7C1B8964D280303DAA17E83DA01AEDDBE2E2B57CE4B03616E1236AF4316278CF1FFA85CAA9DFC8FD76A1B3AF23C75050851FD573B8228088B4BC6D83E38B2491B86384E1B3D30AAB6C07CA936A40BE1EE526DC8019001914B95281C980775A814086F4832E5357732B587F5C99F84285832FBE46B3B04FFE2451CD13E10C1A14FAE5C699928CE83E36D02848E8E393830F48E0235037E232915A5D9589595EB1764F5C6E524E6DF4AB4F1EB58E99F05BEFF83474ECC76F50BD75D0142FAAF40F7F7E696AEFDC64C7F09D31D161B8F27CD464FBCB2E8158746D574F1462227AD807097318FC93B60B81882A28030E5A2C8CC530804806F71506368CE182253408CC6F839F3EDECA8FD733A6832DF9EA1A0D3E849857FF66C4B33781B8465FC6C234A8151201C3930A8C50C71E9C479DE889BB272034EFCFA47D2B87BB301473387D5FE9989A33F9670F0EE7FBA756BDD217023EA1A1047BF3A3EB062BCE8B624DEA49104FE24EAE34F1131062F8DB77E955A350575D7B003C3A50E0CC7F9322E9A60D0BF7037F34C4073C2075E048A1A4466384A6153F0ACCF32F75D10EE78B62500E7CE89208CD594D7048175E94352A16F466BCC16E7C59338EF1E403378C7C00C0E48A3B6242B386F2C7D784AC2251C96E3F83A16FDBF13E37DE7FA6ACFF9BFF9E083E8658C94F6B22561F5F747FFEC91C55AB1515EF430339C4DAA187C0AB612077AEBB55E86E0F363982F08564148DB69DE81B1112079E6C2B9CB296C1EC8283CA6CE9C11080A9DE6872941A0FFA1A0C904C3E509A263D6651F048F203ADA0894362074DEF46FBC274730E03768A6C2543356AE4133781A0F9B3C81BF8AA3C1FFF5A3E2A9E7CE5C58E8160C9293D77DD1DFBF20C1D0FCC430A4FE8F71F99BE099A0D2D35B1A1C3543878E4BDFD44EF14238780A0EACA12D0F9010B29A2E0ADD8142739407235FD60E9C03D331FB22B71385E9386FC6C8CE946DC6D49AFC35DAA834319EA566F07E1800B13D3D525F5D94659C3516CEBE27F5DB37E05A75D03FC4CCFE97D78C5EFB247F4B17ABBC7FFA834B38C09647E3DE8AAD21169EC58167007319C4EE28C7F5551337EB52E81F804F29AB5FE162326DA1009D403712FA460091DBEBB9B27C3FEDEC0073ECC66F27A70D2E75C4BAE85B6F86F2AE336F160EF44B522EC932CE184B97CFC9D2A5B3122EDEE3338E3B40EE0456FAE75E31FADEA1C15B8BDFEC10E26E441BCCAE7BE28FD578B63461BDF0EB98FC3F42D131AF58EE2F8F8C97FBF71C94EAC8A494AA7DE237E163E0389DA6E84E2551687901931D207960F2F5F20227E7854D729A41E6384CD39D9EDFF59A3A6D68D70A32DBA580A803877624386F844928F5954559BA78465666AFD8C69D9BB135721960BC8B58FF1584FF7FFBD85B57E1B03E1961B44F4EBF3BB7124D1C5858BA511FBC909864C158999624EE8B6A2B7DF59BD7845F8E2F0C0E4BD0D70F4708DB4B1BEC044B72027665DD70BB39CB83D3CE0EAC3C6079A2D0F3298975D9967375260AFEC2C24C25C540966F5C91F9F74FC06F5C86035F20E20DB4F816ACC47F0FFDCA5F2CF45DBADEE9F0B7156D32D3EE89FBE8A59D3B4BBD23C94C10478FC230FD12CCD37358D89EF2F058A1323123BD33BBA532342E25FEBA291D35998ED5ED4C0AC409B15D43F29AE2007029B95DE0ECCB3135C16903D3764D68BF26B12FF6CFDB216468479C44D280562CC371D381D7E6AEC751A3764F92E81D1C4ABEE35BF3FD5AE09F7EE2ADCB08753F3918A41F1B10470ACC0B2FF883F7CE7E1980FC223AE61F989C082AD56ACFB6DDD20350AA93DB24289424E0774EF81D47070E05E3282F74723B20E43C28ED8090287C070805EDD23C3B305C5D32FBE37800C2A27FBEA41645A13417EFCA2A347EE1DCFBD2B877A7015F09A761DFC5B82FFAA1FC71A36CEF3CF1E68DAEFE604B27FAD400211194734FEDED5BADAF1CC169F05FA2E8799C491EE12D96A0DA2B858161E9DBB54F7AA67749757CBAE54FDCC12DAF2D4EC87910DA99C2739C07C4099782769C07C2B1FB8C6D5D3FD4089A2A70585B91FA9D3959BA701A1A714D1AF3B785C14A12C557C426278DB17F141979C37A33D7BFFDE69BFC1379E8ECC7A74F151047278E4F8D16633966AD790A233C6EC53EECF98569BF541E298D8C4B7974B2C52313C2672B854A15CB81109DB09C501D304E68ED40F03A5F87B4112079769FBBFE737D25369170750927ED5B52BF7523E559FA8A1A4C147CA4BD628DF901E2F79730CB13A5C6F08D4FFB6FABA7AB783074FAB1895D4DCF3F82B57F01EAF3048A0E60C4B25F2A950A3D0385FE7D87A567C75E29435BF4A532FE9C0784C3075F6B0447CA0BDE0991ECAE1DB9364EF879101CE5FAB200818F639324966879516AB35770E23E2DABD73EB2E1FCDD089695AFAA5F43CDF3D8336F799EFDBBC74ECEBED2EAE8D327CCEAC1D1C5177696EF2C377BBDD81BF24C7CC424E6692CF09831FE3E2F08B6F3A664A17F504AC3D09AC919F036292308E06D7DBE4C9109D1A514A24BC97950F2D4AE0979CAD5E57BBA0D98A53A4C52EDFA6569DCBC2ECD7B77255AE1EFDAD7221B8773E8E9247AF87F05B1DFAF7BF1DD20AEDE39F6F6A535EF527D9AD4B69207476F1EDB3E1D48B8D788B737B672143BEE49148FFB85D2B057E919280D8F1ABE21492E0C0C49D03BA0C0F0EFCF12383D64C2C6EBAFB139401C282E4F7220A4A0E84B097C69BC01FB5FE30F41F38F232F4B0C1F112D2F4973FE1640B929CDDB37255C980710B05949326BE10E71363F9578F61D9BD8B70AE1DCB943A7846F8DB421FCE952BA8A9F2C9D7C6CE290F1CCCF1B6B8EE1F21042C73DFCD11B5CC366C17A0D8E98D2D894298EE360C9BF698E1465FA9BB77E4FAF189F20E4B443F3E952F2DA41538480810044F7F8239537A00537A439775D53FA8AA4598FE1B7D483A12FF869BE046D7F00B3F9EDC02FFCE0C09ECB37CD06AFEB3C28FAA900F2FA53C3FDC566652230F100C4B71331E65138CC03D8CFD02033638A853EBF5429B56EBDA40C1F43EDD01F24EEED17FE954DCE5EDFF4F0F1194355D5049C6FA81939ADD034E41F5A414AAEB7D2386C344D925C831FB984795C40E4F43E36C587912757C5063786FBBDBBBB5EBEC483DF03D58A3CDD2F20AEFE46A9E33CB57F4E5A93FED6CCF0D0E1DEC2DE01DF3E5C30DE1EAC7D5BE09931887918A7DF5EC4513DBE3108C34CD9375244345408F89E3140D24EA025FA721A00A34F70BFE5AE7984A971A39E24511801A33AD460155B7D0570ADC06C82ED3D945D8A8D5C829E5CBC15374EBFBE10CEFEDE1CEFF1AC01C1E5819BD24600B1CC3169B3744B72C2E944AE1E6C83E6C9F93CE4A6D74C5D992357EEEABB94A4F97EA438109BC04A50C2C9F117FACBD38F568ABB274AFEEE01DFECAA7A6647D178E3006418DC8726E99DCA0E041420F088EFAD03919BB5582EAF24F6D27C147EF45123F9E8C462FDF2C5309EBF1E86CD26BFBEC1AFFFB584EE04EBD895F104EBCA482EE5E764F7B9ABBF515F5B5237CB621D0A14475865275C2758B2BBE66724D7AF4B5D5D52BE1D79CD35622BEF914AD0F370A5D4BBAD64FA8682A0AF3F90DE1E2F28C39D97A13DE58A91FE027FFD8E0D3C78120B1D31A600C14751D2FA6990846F8C595B6FD864B501CD6826B6B618D995F9285EBE1D474B571AC9D2072BF1CA0D8081A3297D44BBE03612669E49F994F55D3FCCBBF62C2313AC7640D71185D08958C781B115204CDB017194BFCEB771EDF27D6D4ABDF8BC5A28F8CFF7948627CBA68A15F3DD24BF54F002C661759B84F7E2449FC7C25035AE85F1EAD9E578E562C8DB015B92139013A413A64BF394BFCEB7CBD76FEFC3814176E51BD29602C891AB974FF342744C40986E44EDE5BCCE03BC59BB3C19AAC540590A055B0A126BBD12AEB13AFE0C1E7FC6C8920DBC73288D885F00E36B12E04D059023D621BBDDECAEDBA9BD8CD70E0052FE3A5F97F9F6B6EBA81B216C466C9B6FCF3C05DB2DB9FAF97EF2FD6D45AECD56F5B7DC896DE4EA39A1DD4F5B521E0C97DE4FFB7FA0CF2689FC7F8A0A2462C12A1A9E0000000049454E44AE426082, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHACHHANG] ON 

INSERT [dbo].[KHACHHANG] ([KhachHangID], [TenKhachHang], [LoaiKhachHangID], [DiaChi], [Mobile], [Phone], [Fax], [Email], [DuNo], [DuNoToiThieu], [Visual], [Deleted], [Edit]) VALUES (1, N'Tiến', 2, N'', N'', N'', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[KHACHHANG] ([KhachHangID], [TenKhachHang], [LoaiKhachHangID], [DiaChi], [Mobile], [Phone], [Fax], [Email], [DuNo], [DuNoToiThieu], [Visual], [Deleted], [Edit]) VALUES (2, N'Khoa', 1, N'fdsfgdgdf', N'43645645', N'6454545', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHACHHANG] OFF
SET IDENTITY_INSERT [dbo].[KHO] ON 

INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (1, N'Kho Chính', 1, 0, 0)
INSERT [dbo].[KHO] ([KhoID], [TenKho], [Visual], [Deleted], [Edit]) VALUES (2, N'Kho phụ', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHO] OFF
SET IDENTITY_INSERT [dbo].[KHU] ON 

INSERT [dbo].[KHU] ([KhuID], [TenKhu], [MacDinhSoDoBan], [Hinh], [Visual], [Deleted], [Edit]) VALUES (1, N'Khu A', 1, NULL, 1, 0, 0)
INSERT [dbo].[KHU] ([KhuID], [TenKhu], [MacDinhSoDoBan], [Hinh], [Visual], [Deleted], [Edit]) VALUES (2, N'Khu B', 0, NULL, 1, 0, 0)
INSERT [dbo].[KHU] ([KhuID], [TenKhu], [MacDinhSoDoBan], [Hinh], [Visual], [Deleted], [Edit]) VALUES (3, N'Khu C', 0, NULL, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[KHU] OFF
SET IDENTITY_INSERT [dbo].[LICHBIEUDINHKY] ON 

INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [KhuID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (3, N'Giải phóng miền nam 30/4', 2, 3, 1, N'Ngày 30 Tháng 4', CAST(0x0300000000000000 AS Time), CAST(0x0318582605000000 AS Time), 1, 30, 4, 1, 1, 1)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [KhuID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (11, N'Test', 14, 1, NULL, N'Chủ nhật - Thứ 7', CAST(0x0300000000000000 AS Time), CAST(0x0318582605000000 AS Time), 1, 0, 6, 1, 1, 0)
INSERT [dbo].[LICHBIEUDINHKY] ([LichBieuDinhKyID], [TenLichBieu], [LoaiGiaID], [TheLoaiID], [KhuID], [TenHienThi], [GioBatDau], [GioKetThuc], [UuTien], [GiaTriBatDau], [GiaTriKetThuc], [Visual], [Deleted], [Edit]) VALUES (12, N'Test1', 18, 1, NULL, N'Chủ nhật - Thứ 7', CAST(0x0300000000000000 AS Time), CAST(0x0318582605000000 AS Time), 1, 0, 6, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LICHBIEUDINHKY] OFF
SET IDENTITY_INSERT [dbo].[LICHBIEUKHONGDINHKY] ON 

INSERT [dbo].[LICHBIEUKHONGDINHKY] ([LichBieuKhongDinhKyID], [TenLichBieu], [NgayBatDau], [NgayKetThuc], [GioBatDau], [GioKetThuc], [LoaiGiaID], [KhuID], [Visual], [Deleted], [Edit]) VALUES (1, N'Khuyến mãi khai trương', CAST(0x35390B00 AS Date), CAST(0x4D390B00 AS Date), CAST(0x040037050F000000 AS Time), CAST(0x04F0707F33000000 AS Time), 3, 1, 1, 0, 0)
INSERT [dbo].[LICHBIEUKHONGDINHKY] ([LichBieuKhongDinhKyID], [TenLichBieu], [NgayBatDau], [NgayKetThuc], [GioBatDau], [GioKetThuc], [LoaiGiaID], [KhuID], [Visual], [Deleted], [Edit]) VALUES (2, N'aaaa', CAST(0x64390B00 AS Date), CAST(0x64390B00 AS Date), CAST(0x0400000000000000 AS Time), CAST(0x0400000000000000 AS Time), 14, NULL, 1, 1, 0)
SET IDENTITY_INSERT [dbo].[LICHBIEUKHONGDINHKY] OFF
SET IDENTITY_INSERT [dbo].[LICHSUBANHANG] ON 

INSERT [dbo].[LICHSUBANHANG] ([LichSuBanHangID], [BanHangID], [NhanVienID], [NgayBan], [InNhaBep]) VALUES (1, 1, 1, CAST(0x0000A432010BF156 AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[LICHSUBANHANG] OFF
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
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (289, 4, CAST(0x0000A3EE0170DDB7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (290, 1, CAST(0x0000A3EE0170EF9D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (291, 4, CAST(0x0000A3EE017117C4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (292, 4, CAST(0x0000A3EE01713004 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (293, 4, CAST(0x0000A3EE0171CFA8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (294, 4, CAST(0x0000A3EE01723F12 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (295, 4, CAST(0x0000A3EE01738D6A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (296, 1, CAST(0x0000A3EE0175A640 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (297, 1, CAST(0x0000A3EE017658A4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (298, 4, CAST(0x0000A3EE01766B64 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (299, 1, CAST(0x0000A3EE0176A3BE AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (300, 4, CAST(0x0000A3EE0177C5EC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (301, 4, CAST(0x0000A3EE017821B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (302, 1, CAST(0x0000A3EE01787C62 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (303, 4, CAST(0x0000A3EE0179671D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (304, 4, CAST(0x0000A3EE017B1F5D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (305, 11, CAST(0x0000A3EE017B8205 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (306, 11, CAST(0x0000A3EE017BFB57 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (307, 1, CAST(0x0000A3EE018092E2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (308, 1, CAST(0x0000A3EF001551DB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (309, 4, CAST(0x0000A3EF001581C1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (310, 1, CAST(0x0000A3EF0020410C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (311, 1, CAST(0x0000A3EF0020BA98 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (312, 1, CAST(0x0000A3EF0021012D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (313, 1, CAST(0x0000A3EF002132F9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (314, 1, CAST(0x0000A3EF0172147B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (315, 1, CAST(0x0000A3EF0172C99D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (316, 1, CAST(0x0000A3EF01741B10 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (317, 1, CAST(0x0000A3EF01749346 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (318, 1, CAST(0x0000A3EF0175C835 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (319, 1, CAST(0x0000A3EF01764DAC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (320, 1, CAST(0x0000A3EF0176E72D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (321, 1, CAST(0x0000A3EF017721A4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (322, 1, CAST(0x0000A3EF01776C08 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (323, 1, CAST(0x0000A3EF01784783 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (324, 1, CAST(0x0000A3EF017E64B8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (325, 1, CAST(0x0000A3EF0183617B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (326, 1, CAST(0x0000A3EF018450B6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (327, 1, CAST(0x0000A3EF0184DBAC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (328, 1, CAST(0x0000A3EF01854C7D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (329, 1, CAST(0x0000A3EF018607A0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (330, 1, CAST(0x0000A3EF01867574 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (331, 1, CAST(0x0000A3EF01882992 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (332, 1, CAST(0x0000A3EF0189595D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (333, 1, CAST(0x0000A3EF018A680A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (334, 1, CAST(0x0000A3F000006F95 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (335, 1, CAST(0x0000A3F000044D6A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (336, 1, CAST(0x0000A3F00004E606 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (337, 1, CAST(0x0000A3F000063086 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (338, 1, CAST(0x0000A3F0001362FF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (339, 1, CAST(0x0000A3F000142443 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (340, 1, CAST(0x0000A3F00018F45F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (341, 1, CAST(0x0000A3F0001919AD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (342, 1, CAST(0x0000A3F0001A87FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (343, 1, CAST(0x0000A3F0001D2DD2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (344, 1, CAST(0x0000A3F0001DB4C3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (345, 1, CAST(0x0000A3F0001DD6FA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (346, 1, CAST(0x0000A3F0001EC9C5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (347, 1, CAST(0x0000A3F0001F692B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (348, 1, CAST(0x0000A3F00020048E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (349, 1, CAST(0x0000A3F00020B3C8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (350, 1, CAST(0x0000A3F000214C5C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (351, 1, CAST(0x0000A3F0002187CE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (352, 1, CAST(0x0000A3F0003712F2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (353, 1, CAST(0x0000A3F000375FA8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (354, 1, CAST(0x0000A3F000378A5F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (355, 1, CAST(0x0000A3F00037DA43 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (356, 1, CAST(0x0000A3F0003858B4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (357, 1, CAST(0x0000A3F0003887D0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (358, 1, CAST(0x0000A3F0003928E3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (359, 1, CAST(0x0000A3F00039D3DA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (360, 1, CAST(0x0000A3F0003AF8B5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (361, 1, CAST(0x0000A3F0003B462A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (362, 1, CAST(0x0000A3F0003BBC0F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (363, 1, CAST(0x0000A3F0003C642E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (364, 1, CAST(0x0000A3F0003CC1E7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (365, 1, CAST(0x0000A3F0003D6B08 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (366, 1, CAST(0x0000A3F0003E90C7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (367, 1, CAST(0x0000A3F0003F3793 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (368, 1, CAST(0x0000A3F1017738A8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (369, 1, CAST(0x0000A3F101778BB8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (370, 1, CAST(0x0000A3F10177E0C8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (371, 1, CAST(0x0000A3F10179D31B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (372, 1, CAST(0x0000A3F1017A4EED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (373, 1, CAST(0x0000A3F1017BC7C0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (374, 1, CAST(0x0000A3F101809E20 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (375, 1, CAST(0x0000A3F10180E0B8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1374, 1, CAST(0x0000A3F1018964C0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1375, 1, CAST(0x0000A3F201144D58 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1376, 1, CAST(0x0000A3F20115FB33 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1377, 1, CAST(0x0000A3F2011696CB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1378, 1, CAST(0x0000A3F20116F474 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1379, 1, CAST(0x0000A3F2011A561C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1380, 1, CAST(0x0000A3F2011DEE20 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1381, 1, CAST(0x0000A3F2011E063E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1382, 1, CAST(0x0000A3F20120A30A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1383, 1, CAST(0x0000A3F201220695 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1384, 1, CAST(0x0000A3F20122456B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1385, 1, CAST(0x0000A3F201231655 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1386, 1, CAST(0x0000A3F201234BA3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1387, 1, CAST(0x0000A3F2015F0FF8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1388, 1, CAST(0x0000A3F20160710F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1389, 1, CAST(0x0000A3F201615F3D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1390, 1, CAST(0x0000A3F20161ED2F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1391, 1, CAST(0x0000A3F2016253B4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1392, 1, CAST(0x0000A3F201645033 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1393, 1, CAST(0x0000A3F201649594 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1394, 1, CAST(0x0000A3F2016501AC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1395, 1, CAST(0x0000A3F2016619A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1396, 1, CAST(0x0000A3F201664EAD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1397, 1, CAST(0x0000A3F201676ACA AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1398, 1, CAST(0x0000A3F20169829E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1399, 1, CAST(0x0000A3F2016BA1CF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1400, 1, CAST(0x0000A3F2016BC558 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1401, 1, CAST(0x0000A3F2016C9FA0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1402, 1, CAST(0x0000A3F2016DF9A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1403, 1, CAST(0x0000A3F2016F02D8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1404, 1, CAST(0x0000A3F2016F598D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1405, 1, CAST(0x0000A3F20170ABD5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1406, 1, CAST(0x0000A3F2017409F3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1407, 1, CAST(0x0000A3F201753132 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1408, 1, CAST(0x0000A3F20175F465 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1409, 1, CAST(0x0000A3F20176B4C4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1410, 1, CAST(0x0000A3F2017932EE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1411, 1, CAST(0x0000A3F2017A6CF2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1412, 1, CAST(0x0000A3F2017CAC4F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1413, 1, CAST(0x0000A3F2017DB31D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1414, 1, CAST(0x0000A3F2017E8BB2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1415, 1, CAST(0x0000A3F2017F858E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1416, 1, CAST(0x0000A3F201805709 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1417, 1, CAST(0x0000A3F20181B808 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1418, 1, CAST(0x0000A3F20185D03E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1419, 1, CAST(0x0000A3F20188321C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1420, 1, CAST(0x0000A3F20188504B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1421, 1, CAST(0x0000A3F30008F304 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1422, 1, CAST(0x0000A3F300096923 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1423, 1, CAST(0x0000A3F30009C2A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1424, 1, CAST(0x0000A3F3000B42A5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1425, 1, CAST(0x0000A3F3000BA9F4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1426, 1, CAST(0x0000A3F3000D4352 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1427, 1, CAST(0x0000A3F3000E5FCF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1428, 1, CAST(0x0000A3F3000EA045 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1429, 1, CAST(0x0000A3F3000F9834 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1430, 1, CAST(0x0000A3F3000FE62B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1431, 1, CAST(0x0000A3F30014BEB3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1432, 1, CAST(0x0000A3F30015F99E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1433, 1, CAST(0x0000A3F30016D00E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1434, 1, CAST(0x0000A3F3001959E8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1435, 1, CAST(0x0000A3F3001AA4C8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1436, 1, CAST(0x0000A3F3001CB6C0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1437, 1, CAST(0x0000A3F3001D3BCB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1438, 1, CAST(0x0000A3F3001E61CB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1439, 1, CAST(0x0000A3F3001EFCE3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1440, 1, CAST(0x0000A3F30020CA92 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1441, 1, CAST(0x0000A3F300215596 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1442, 1, CAST(0x0000A3F30021C772 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1443, 1, CAST(0x0000A3F3003B238A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1444, 1, CAST(0x0000A3F3003D0AF0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1445, 1, CAST(0x0000A3F3003D10F2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1446, 1, CAST(0x0000A3F3003DB8AC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1447, 1, CAST(0x0000A3F3003DE529 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1448, 11, CAST(0x0000A3F3003E1DCC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1449, 11, CAST(0x0000A3F3003E2A62 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1450, 11, CAST(0x0000A3F3003E4385 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1451, 1, CAST(0x0000A3F3003EADF9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1452, 1, CAST(0x0000A3F3003EB8E6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1453, 1, CAST(0x0000A3F3003ED4B6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1454, 1, CAST(0x0000A3F3003F3009 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1455, 1, CAST(0x0000A3F3003F4268 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1456, 1, CAST(0x0000A3F3003F772F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1457, 1, CAST(0x0000A3F3003FF531 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1458, 11, CAST(0x0000A3F3003FFD42 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1459, 1, CAST(0x0000A3F3004006C1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1460, 1, CAST(0x0000A3F300424C0D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1461, 11, CAST(0x0000A3F3004253E4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1462, 1, CAST(0x0000A3F30042AC5F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1463, 11, CAST(0x0000A3F30042B379 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1464, 1, CAST(0x0000A3F300437868 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1465, 11, CAST(0x0000A3F300437F01 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1466, 1, CAST(0x0000A3F3004384E6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1467, 1, CAST(0x0000A3F300D2F328 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1468, 1, CAST(0x0000A3F300D8BD25 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1469, 1, CAST(0x0000A3F300DDE1AA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1470, 1, CAST(0x0000A3F300E09768 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1471, 1, CAST(0x0000A3F30153F774 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1472, 1, CAST(0x0000A3F30156B1AA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1473, 1, CAST(0x0000A3F30157F4C3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1474, 1, CAST(0x0000A3F301582F04 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1475, 1, CAST(0x0000A3F301584CC0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1476, 1, CAST(0x0000A3F3015B8BFC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1477, 1, CAST(0x0000A3F30180C954 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1478, 1, CAST(0x0000A3F30181AE4D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1479, 1, CAST(0x0000A3F3018236F0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1480, 1, CAST(0x0000A3F301826631 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1481, 1, CAST(0x0000A3F301830958 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1482, 1, CAST(0x0000A3F30183769F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1483, 1, CAST(0x0000A3F30183D64D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1484, 1, CAST(0x0000A3F30184669B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1485, 1, CAST(0x0000A3F30185B03D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1486, 1, CAST(0x0000A3F3018786C0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1487, 1, CAST(0x0000A3F301886753 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1488, 1, CAST(0x0000A3F30188E3ED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1489, 1, CAST(0x0000A3F3018987D9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1490, 1, CAST(0x0000A3F400013A8C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1491, 1, CAST(0x0000A3F400019969 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1492, 1, CAST(0x0000A3F40001E54A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1493, 1, CAST(0x0000A3F40002482B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1494, 1, CAST(0x0000A3F4000312FA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1495, 1, CAST(0x0000A3F400035839 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1496, 1, CAST(0x0000A3F40003A3C7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1497, 1, CAST(0x0000A3F400040E4E AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1498, 1, CAST(0x0000A3F40005FDEF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1499, 1, CAST(0x0000A3F400062A58 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1500, 1, CAST(0x0000A3F400067FEC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1501, 1, CAST(0x0000A3F40006CF2B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1502, 1, CAST(0x0000A3F400085E9C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1503, 1, CAST(0x0000A3F4000952B4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1504, 1, CAST(0x0000A3F400099654 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1505, 1, CAST(0x0000A3F4000AC1B8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1506, 1, CAST(0x0000A3F4000AF237 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1507, 1, CAST(0x0000A3F4000B53EF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1508, 1, CAST(0x0000A3F4000BF982 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1509, 1, CAST(0x0000A3F4000C4376 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1510, 1, CAST(0x0000A3F4000CD6BF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1511, 1, CAST(0x0000A3F4000D06D4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1512, 1, CAST(0x0000A3F4000E0DBA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1513, 1, CAST(0x0000A3F4000ECF53 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1514, 1, CAST(0x0000A3F4000F22B2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1515, 1, CAST(0x0000A3F4000FFBA4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1516, 1, CAST(0x0000A3F400108A4E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1517, 1, CAST(0x0000A3F400111236 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1518, 1, CAST(0x0000A3F400115CE6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1519, 1, CAST(0x0000A3F4001194A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1520, 1, CAST(0x0000A3F40012428A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1521, 1, CAST(0x0000A3F4001929FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1522, 1, CAST(0x0000A3F4001ABC2A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1523, 1, CAST(0x0000A3F4001BC950 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1524, 1, CAST(0x0000A3F4001D2B5F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1525, 1, CAST(0x0000A3F4001D9C3B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1526, 1, CAST(0x0000A3F4001EFF87 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1527, 1, CAST(0x0000A3F4001F7FE0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1528, 1, CAST(0x0000A3F400201EFA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1529, 1, CAST(0x0000A3F4002161DC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1530, 1, CAST(0x0000A3F40021DCC4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1531, 1, CAST(0x0000A3F400220EA8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1532, 1, CAST(0x0000A3F400224B45 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1533, 1, CAST(0x0000A3F400238F97 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1534, 1, CAST(0x0000A3F40023EBDC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1535, 1, CAST(0x0000A3F400246299 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1536, 1, CAST(0x0000A3F40025949F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1537, 1, CAST(0x0000A3F400270439 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1538, 1, CAST(0x0000A3F4002774B5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1539, 1, CAST(0x0000A3F40027D471 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1540, 1, CAST(0x0000A3F400281441 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1541, 1, CAST(0x0000A3F40028881D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1542, 1, CAST(0x0000A3F40028E7CF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1543, 1, CAST(0x0000A3F4015F6E3F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1544, 1, CAST(0x0000A3F4016520CC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1545, 1, CAST(0x0000A3F401657880 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1546, 1, CAST(0x0000A3F401665BF0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1547, 1, CAST(0x0000A3F40166F120 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1548, 1, CAST(0x0000A3F401675BB6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1549, 1, CAST(0x0000A3F4016801EA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1550, 1, CAST(0x0000A3F401683555 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1551, 1, CAST(0x0000A3F40169973C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1552, 1, CAST(0x0000A3F4017057FF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1553, 1, CAST(0x0000A3F40170A819 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1554, 1, CAST(0x0000A3F4017142CA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1555, 1, CAST(0x0000A3F4017286FF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1556, 1, CAST(0x0000A3F40173A204 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1557, 1, CAST(0x0000A3F401753837 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1558, 1, CAST(0x0000A3F4017735CF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1559, 1, CAST(0x0000A3F40177A165 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1560, 1, CAST(0x0000A3F401780208 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1561, 1, CAST(0x0000A3F401784EDF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1562, 1, CAST(0x0000A3F40178F2B9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1563, 1, CAST(0x0000A3F4017986F6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1564, 1, CAST(0x0000A3F4017AF954 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1565, 1, CAST(0x0000A3F4017B47C4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1566, 1, CAST(0x0000A3F4017B760F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1567, 1, CAST(0x0000A3F4017BB494 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1568, 1, CAST(0x0000A3F4017C5AAB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1569, 1, CAST(0x0000A3F4017CAD3F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1570, 1, CAST(0x0000A3F50016BC86 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1571, 1, CAST(0x0000A3F5001809D2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1572, 1, CAST(0x0000A3F5001C9D9D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1573, 1, CAST(0x0000A3F5001D23EF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1574, 1, CAST(0x0000A3F5001FF483 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1575, 1, CAST(0x0000A3F5002035C2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1576, 1, CAST(0x0000A3F50020C577 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1577, 1, CAST(0x0000A3F50021AD67 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1578, 1, CAST(0x0000A3F500224F8E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1579, 1, CAST(0x0000A3F500231AC3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1580, 1, CAST(0x0000A3F5002368DC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1581, 1, CAST(0x0000A3F50023EDB6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1582, 1, CAST(0x0000A3F5002488FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1583, 1, CAST(0x0000A3F500264EE5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1584, 1, CAST(0x0000A3F5002811FB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1585, 1, CAST(0x0000A3F500288408 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1586, 1, CAST(0x0000A3F50028EB52 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1587, 1, CAST(0x0000A3F500296D3B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1588, 1, CAST(0x0000A3F50029C21D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1589, 1, CAST(0x0000A3F5002C37D6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1590, 1, CAST(0x0000A3F5002D4A18 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1591, 1, CAST(0x0000A3F50031030B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1592, 1, CAST(0x0000A3F500317DB9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1593, 1, CAST(0x0000A3F50031EFB1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1594, 1, CAST(0x0000A3F500325691 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1595, 1, CAST(0x0000A3F500330C85 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1596, 1, CAST(0x0000A3F50034E4D7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1597, 1, CAST(0x0000A3F500366F15 AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1598, 1, CAST(0x0000A3F50036D54C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1599, 1, CAST(0x0000A3F500373547 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1600, 1, CAST(0x0000A3F500377214 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1601, 1, CAST(0x0000A3F50037C518 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1602, 1, CAST(0x0000A3F5003ACA2A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1603, 1, CAST(0x0000A3F501723C1A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1604, 1, CAST(0x0000A3F6002165B9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1605, 1, CAST(0x0000A3F60021C8ED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1606, 1, CAST(0x0000A3F60022C83B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1607, 1, CAST(0x0000A3F60023478B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1608, 1, CAST(0x0000A3F600238D11 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1609, 1, CAST(0x0000A3F60024B269 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1610, 1, CAST(0x0000A3F60026A010 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1611, 1, CAST(0x0000A3F60028535B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1612, 1, CAST(0x0000A3F600287E04 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1613, 1, CAST(0x0000A3F600289E7F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1614, 1, CAST(0x0000A3F6002B2F11 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1615, 1, CAST(0x0000A3F6002C18B9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1616, 1, CAST(0x0000A3F6002CA427 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1617, 1, CAST(0x0000A3F6002D0846 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1618, 1, CAST(0x0000A3F6002DACCD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1619, 1, CAST(0x0000A3F6002DE813 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1620, 1, CAST(0x0000A3F6002F098F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1621, 1, CAST(0x0000A3F60031954D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1622, 1, CAST(0x0000A3F60031DD65 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1623, 1, CAST(0x0000A3F60032321F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1624, 1, CAST(0x0000A3F60032F591 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1625, 1, CAST(0x0000A3F60033E10C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1626, 1, CAST(0x0000A3F600345A16 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1627, 1, CAST(0x0000A3F60035B2A4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1628, 1, CAST(0x0000A3F6003C4DBB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1629, 1, CAST(0x0000A3F6003C8381 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1630, 1, CAST(0x0000A3F6003EA337 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1631, 1, CAST(0x0000A3F6003ECDD6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1632, 1, CAST(0x0000A3F6003F1C6C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1633, 1, CAST(0x0000A3F6003F95A6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1634, 1, CAST(0x0000A3F60040A8A3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1635, 1, CAST(0x0000A3F60099AF99 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1636, 1, CAST(0x0000A3F6009B75F2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1637, 1, CAST(0x0000A3F6009BBA21 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1638, 1, CAST(0x0000A3F6009C380E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1639, 1, CAST(0x0000A3F6009CB0A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1640, 1, CAST(0x0000A3F6009CE99F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1641, 1, CAST(0x0000A3F6009D7875 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1642, 1, CAST(0x0000A3F600A01C8C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1643, 1, CAST(0x0000A3F600B00F73 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1644, 1, CAST(0x0000A3F600B0E784 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1645, 1, CAST(0x0000A3F600B21011 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1646, 1, CAST(0x0000A3F600B37843 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1647, 1, CAST(0x0000A3F600B3A8CB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1648, 1, CAST(0x0000A3F60171847C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1649, 1, CAST(0x0000A3F601720256 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1650, 1, CAST(0x0000A3F601724D5E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1651, 1, CAST(0x0000A3F60172D636 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1652, 1, CAST(0x0000A3F60175C380 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1653, 1, CAST(0x0000A3F60176C4EC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1654, 1, CAST(0x0000A3F601781F04 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1655, 1, CAST(0x0000A3F60178A912 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1656, 1, CAST(0x0000A3F60179EF71 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1657, 1, CAST(0x0000A3F6017A8EB6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1658, 1, CAST(0x0000A3F6017BB10F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1659, 1, CAST(0x0000A3F6017C1D01 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1660, 1, CAST(0x0000A3F6017C97B1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1661, 1, CAST(0x0000A3F6017DB589 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1662, 1, CAST(0x0000A3F6017F6957 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1663, 1, CAST(0x0000A3F6017FC59C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1664, 1, CAST(0x0000A3F60180EFA0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1665, 1, CAST(0x0000A3F601818DB5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1666, 1, CAST(0x0000A3F601823764 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1667, 1, CAST(0x0000A3F6018281A6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1668, 1, CAST(0x0000A3F60182B4BF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1669, 1, CAST(0x0000A3F601879A55 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1670, 1, CAST(0x0000A3F60188047C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1671, 1, CAST(0x0000A3F60188AE61 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1672, 1, CAST(0x0000A3F70005B88B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1673, 1, CAST(0x0000A3F700061E71 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1674, 1, CAST(0x0000A3F70006A0EB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1675, 1, CAST(0x0000A3F700073576 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1676, 1, CAST(0x0000A3F700075909 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1677, 1, CAST(0x0000A3F700085FC8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1678, 1, CAST(0x0000A3F700090488 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1679, 1, CAST(0x0000A3F700099A36 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1680, 1, CAST(0x0000A3F7000F4F47 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1681, 1, CAST(0x0000A3F700104EA3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1682, 1, CAST(0x0000A3F70011F554 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1683, 1, CAST(0x0000A3F7001258E7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1684, 1, CAST(0x0000A3F70012BC38 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1685, 1, CAST(0x0000A3F70014B694 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1686, 1, CAST(0x0000A3F70014FC05 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1687, 1, CAST(0x0000A3F70024714D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1688, 1, CAST(0x0000A3F70028F1D8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1689, 1, CAST(0x0000A3F700298243 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1690, 1, CAST(0x0000A3F70029C804 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1691, 1, CAST(0x0000A3F7002A528E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1692, 1, CAST(0x0000A3F7002BED87 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1693, 1, CAST(0x0000A3F7002C2448 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1694, 1, CAST(0x0000A3F700308F82 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1695, 1, CAST(0x0000A3F7003361D2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1696, 1, CAST(0x0000A3F700338CCC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1697, 1, CAST(0x0000A3F70036AB9B AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1698, 1, CAST(0x0000A3F7003A0BE8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1699, 1, CAST(0x0000A3F7003AB3B5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1700, 1, CAST(0x0000A3F7003C9188 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1701, 1, CAST(0x0000A3F7010A12CE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1702, 1, CAST(0x0000A3F7010B9749 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1703, 1, CAST(0x0000A3F7010BDCDB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1704, 1, CAST(0x0000A3F7010C08FF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1705, 1, CAST(0x0000A3F7010E7FC1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1706, 1, CAST(0x0000A3F7010F0D31 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1707, 1, CAST(0x0000A3F701108230 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1708, 1, CAST(0x0000A3F70110B93E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1709, 1, CAST(0x0000A3F80090767D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1710, 1, CAST(0x0000A3F800DC7D44 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1711, 1, CAST(0x0000A3FA003DD07B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1712, 1, CAST(0x0000A3FA017FA008 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1713, 1, CAST(0x0000A3FA0180B225 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1714, 1, CAST(0x0000A3FB0000C6F2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1715, 1, CAST(0x0000A3FB00A3A1B7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1716, 1, CAST(0x0000A3FB00B8FB57 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1717, 1, CAST(0x0000A3FB00C478C5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1718, 1, CAST(0x0000A3FB010DD18E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1719, 1, CAST(0x0000A3FB0111E67A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1720, 1, CAST(0x0000A3FB0116B2F6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1721, 1, CAST(0x0000A3FB01836EAD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1722, 1, CAST(0x0000A3FB01855CE7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1723, 1, CAST(0x0000A40400DAC4EE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1724, 1, CAST(0x0000A40400DB50BC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1725, 1, CAST(0x0000A406001A657E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1726, 1, CAST(0x0000A406001AE0B4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1727, 1, CAST(0x0000A40600261DF3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1728, 1, CAST(0x0000A4060026975A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1729, 1, CAST(0x0000A4060027204A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1730, 1, CAST(0x0000A4060169A766 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1731, 1, CAST(0x0000A40601751A08 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1732, 1, CAST(0x0000A4060188811B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1733, 1, CAST(0x0000A407000BFCED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1734, 1, CAST(0x0000A407000E25EE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1735, 1, CAST(0x0000A407000FD10D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1736, 1, CAST(0x0000A40700112486 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1737, 1, CAST(0x0000A4070013BC66 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1738, 1, CAST(0x0000A4070014C33B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1739, 1, CAST(0x0000A4070015C8DA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1740, 1, CAST(0x0000A40700A4DDE6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1741, 1, CAST(0x0000A40700FFBB2A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1742, 1, CAST(0x0000A407011A9A8C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1743, 1, CAST(0x0000A4070123FCD7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1744, 1, CAST(0x0000A40701251E1B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1745, 1, CAST(0x0000A4070125E153 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1746, 1, CAST(0x0000A4070126C4F6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1747, 1, CAST(0x0000A4070127D9D0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1748, 1, CAST(0x0000A4070128728D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1749, 1, CAST(0x0000A40701291C70 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1750, 1, CAST(0x0000A4070129D190 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1751, 1, CAST(0x0000A407012B1860 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1752, 1, CAST(0x0000A407012BD1DB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1753, 1, CAST(0x0000A407012C7C4C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1754, 1, CAST(0x0000A4070133D75F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1755, 1, CAST(0x0000A4070136740C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1756, 1, CAST(0x0000A407013722ED AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1757, 1, CAST(0x0000A4070137674F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1758, 1, CAST(0x0000A4070137E969 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1759, 1, CAST(0x0000A407013A85D7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1760, 1, CAST(0x0000A407013B59A1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1761, 1, CAST(0x0000A407016BDFF7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1762, 1, CAST(0x0000A40701719595 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1763, 1, CAST(0x0000A40701736949 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1764, 1, CAST(0x0000A4070175E906 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1765, 1, CAST(0x0000A407017969AD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1766, 1, CAST(0x0000A4070179A2CB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1767, 1, CAST(0x0000A407017A5ED0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1768, 1, CAST(0x0000A407017AFB61 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1769, 1, CAST(0x0000A407017BAED0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1770, 1, CAST(0x0000A407017D7AC3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1771, 1, CAST(0x0000A4070181500E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1772, 1, CAST(0x0000A40701822BD4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1773, 1, CAST(0x0000A40701857CA2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1774, 1, CAST(0x0000A4070186E186 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1775, 1, CAST(0x0000A4070187637F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1776, 1, CAST(0x0000A4070188BD4D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1777, 1, CAST(0x0000A407018A080E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1778, 1, CAST(0x0000A407018AC059 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1779, 1, CAST(0x0000A40800028C50 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1780, 1, CAST(0x0000A4080005D659 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1781, 1, CAST(0x0000A40800084241 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1782, 1, CAST(0x0000A408000954B5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1783, 1, CAST(0x0000A4080079B9DD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1784, 1, CAST(0x0000A40800828C99 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1785, 1, CAST(0x0000A4080082B816 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1786, 1, CAST(0x0000A40800834A12 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1787, 1, CAST(0x0000A40800884C49 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1788, 1, CAST(0x0000A4080088C698 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1789, 1, CAST(0x0000A40801493F95 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1790, 1, CAST(0x0000A408014A7047 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1791, 1, CAST(0x0000A408014DB8B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1792, 1, CAST(0x0000A408014EE06C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1793, 1, CAST(0x0000A40801506F47 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1794, 1, CAST(0x0000A40801535C75 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1795, 1, CAST(0x0000A40801549A10 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1796, 1, CAST(0x0000A40801762F05 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1797, 1, CAST(0x0000A4080177640A AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1798, 1, CAST(0x0000A40801780FB6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1799, 1, CAST(0x0000A4080186A711 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1800, 1, CAST(0x0000A4080187CB15 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1801, 1, CAST(0x0000A4080188BE96 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1802, 1, CAST(0x0000A4090004F0C9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1803, 1, CAST(0x0000A4090007B574 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1804, 1, CAST(0x0000A409000A7EAB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1805, 1, CAST(0x0000A409000B029F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1806, 1, CAST(0x0000A409000E0357 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1807, 1, CAST(0x0000A409000E521B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1808, 1, CAST(0x0000A409000FC07A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1809, 1, CAST(0x0000A40900194699 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1810, 1, CAST(0x0000A4090094A106 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1811, 1, CAST(0x0000A40900992F54 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1812, 1, CAST(0x0000A4090099C01A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1813, 1, CAST(0x0000A4090099FEB8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1814, 1, CAST(0x0000A409009E21E8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1815, 1, CAST(0x0000A40900C268CE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1816, 1, CAST(0x0000A40900CD7092 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1817, 1, CAST(0x0000A40900CF9A89 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1818, 1, CAST(0x0000A40900D356B1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1819, 1, CAST(0x0000A40900D3E3BA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1820, 1, CAST(0x0000A40900D7A085 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1821, 1, CAST(0x0000A40900D81F3A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1822, 1, CAST(0x0000A40900D8AF7A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1823, 1, CAST(0x0000A40900E1CC89 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1824, 1, CAST(0x0000A40900E272A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1825, 1, CAST(0x0000A40900E2DF94 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1826, 1, CAST(0x0000A40900E359FF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1827, 1, CAST(0x0000A40900E99750 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1828, 1, CAST(0x0000A40900EB0E8F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1829, 1, CAST(0x0000A40900ECEFA3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1830, 1, CAST(0x0000A40900ED84F0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1831, 1, CAST(0x0000A40900EE044F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1832, 1, CAST(0x0000A40900F20917 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1833, 1, CAST(0x0000A40C00A8E234 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1834, 1, CAST(0x0000A40C011C9C30 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1835, 1, CAST(0x0000A4100161FD56 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1836, 1, CAST(0x0000A4100163F28F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1837, 1, CAST(0x0000A41001675E23 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1838, 1, CAST(0x0000A410016925AF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1839, 1, CAST(0x0000A410017A8366 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1840, 1, CAST(0x0000A410017E3CD9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1841, 1, CAST(0x0000A410017F388E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1842, 1, CAST(0x0000A41001832046 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1843, 1, CAST(0x0000A4100184B407 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1844, 1, CAST(0x0000A4100185EFD7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1845, 1, CAST(0x0000A4100186D748 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1846, 1, CAST(0x0000A41E01071073 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1847, 1, CAST(0x0000A42000EFBB20 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1848, 1, CAST(0x0000A42000F37DE1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1849, 1, CAST(0x0000A42000F7A6D3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1850, 1, CAST(0x0000A42000F99FC4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1851, 1, CAST(0x0000A42000FA1DCF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1852, 1, CAST(0x0000A42000FAE597 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1853, 1, CAST(0x0000A42000FD2D48 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1854, 1, CAST(0x0000A42000FD80B6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1855, 1, CAST(0x0000A42000FE36AE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1856, 1, CAST(0x0000A42001001BF7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1857, 1, CAST(0x0000A420010167A0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1858, 1, CAST(0x0000A420010774A4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1859, 1, CAST(0x0000A422011122A9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1860, 1, CAST(0x0000A42201115AC5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1861, 1, CAST(0x0000A42201146CD6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1862, 1, CAST(0x0000A42201159317 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1863, 1, CAST(0x0000A4220119614D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1864, 1, CAST(0x0000A422011AB587 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1865, 1, CAST(0x0000A422011B2292 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1866, 1, CAST(0x0000A422011CE6BD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1867, 1, CAST(0x0000A422011E58C2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1868, 1, CAST(0x0000A422011E75DA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1869, 1, CAST(0x0000A42300AE9246 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1870, 1, CAST(0x0000A42300B0DAC1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1871, 1, CAST(0x0000A42300B94DAC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1872, 1, CAST(0x0000A42300BACEE2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1873, 1, CAST(0x0000A42300BB8C4D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1874, 1, CAST(0x0000A42300BBF17E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1875, 1, CAST(0x0000A42300BC2E1A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1876, 1, CAST(0x0000A42300BC7BC3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1877, 1, CAST(0x0000A42300BCF257 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1878, 1, CAST(0x0000A42300D9FCFD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1879, 1, CAST(0x0000A42300DB18F8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1880, 1, CAST(0x0000A42300DB97FC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1881, 1, CAST(0x0000A42300DC36D6 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1882, 1, CAST(0x0000A42300E19A76 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1883, 1, CAST(0x0000A42300E27FDE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1884, 1, CAST(0x0000A42300F29B5D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1885, 1, CAST(0x0000A42300F53834 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1886, 1, CAST(0x0000A42300F5C7B5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1887, 1, CAST(0x0000A42300F66E39 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1888, 1, CAST(0x0000A42300F7AC25 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1889, 1, CAST(0x0000A42300F94FD3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1890, 1, CAST(0x0000A42300FEAF9C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1891, 1, CAST(0x0000A4230100B3E9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1892, 1, CAST(0x0000A423010267A8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1893, 1, CAST(0x0000A4230106721F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1894, 1, CAST(0x0000A42301070501 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1895, 1, CAST(0x0000A424008D78B9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1896, 1, CAST(0x0000A4240093DD9E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1897, 1, CAST(0x0000A4240094AB8E AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1898, 1, CAST(0x0000A424009580D5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1899, 1, CAST(0x0000A42400BB475A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1900, 1, CAST(0x0000A42400BBDB84 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1901, 1, CAST(0x0000A42400BD3EBF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1902, 1, CAST(0x0000A42400BDE9B9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1903, 1, CAST(0x0000A42400BED387 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1904, 1, CAST(0x0000A42400C083AC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1905, 1, CAST(0x0000A42400C12C75 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1906, 1, CAST(0x0000A42400C1EF49 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1907, 1, CAST(0x0000A42400C26F42 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1908, 1, CAST(0x0000A42400D0C47C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1909, 1, CAST(0x0000A42400D3D0A8 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1910, 1, CAST(0x0000A42400D4CF74 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1911, 1, CAST(0x0000A425010BBE84 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1912, 1, CAST(0x0000A425010D750E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1913, 1, CAST(0x0000A425010EA3CD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1914, 1, CAST(0x0000A425011186DE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1915, 1, CAST(0x0000A4250111C9D2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1916, 1, CAST(0x0000A4250112AF85 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1917, 1, CAST(0x0000A42501141C38 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1918, 1, CAST(0x0000A425011484E1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1919, 1, CAST(0x0000A42501163C06 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1920, 1, CAST(0x0000A4250118E3EE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1921, 1, CAST(0x0000A425011F35FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1922, 1, CAST(0x0000A424011F6861 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1923, 1, CAST(0x0000A425011F975F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1924, 11, CAST(0x0000A4250121A1FE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1925, 2, CAST(0x0000A4250121BD01 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1926, 1, CAST(0x0000A4250130F265 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1927, 1, CAST(0x0000A4250131DFFF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1928, 1, CAST(0x0000A425013354E7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1929, 1, CAST(0x0000A425013537D7 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1930, 1, CAST(0x0000A4250139F2F0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1931, 1, CAST(0x0000A426017D132F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1932, 1, CAST(0x0000A42601806F11 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1933, 1, CAST(0x0000A42601828DF9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1934, 1, CAST(0x0000A426018347B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1935, 1, CAST(0x0000A4260184DA62 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1936, 1, CAST(0x0000A42601857C50 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1937, 1, CAST(0x0000A4260185B429 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1938, 1, CAST(0x0000A4260186490F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1939, 1, CAST(0x0000A42601888143 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1940, 1, CAST(0x0000A426018A7D02 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1941, 1, CAST(0x0000A42700056EBB AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1942, 1, CAST(0x0000A4270007FCC0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1943, 1, CAST(0x0000A4270009C01B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1944, 1, CAST(0x0000A427000B9C86 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1945, 1, CAST(0x0000A4270014B383 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1946, 1, CAST(0x0000A4270014CB1B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1947, 1, CAST(0x0000A427001CBBB5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1948, 1, CAST(0x0000A427001D5C76 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1949, 1, CAST(0x0000A427001E4539 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1950, 1, CAST(0x0000A42700208844 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1951, 1, CAST(0x0000A42700211072 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1952, 1, CAST(0x0000A42700228302 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1953, 1, CAST(0x0000A427002329DD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1954, 1, CAST(0x0000A42700268D93 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1955, 1, CAST(0x0000A427002993B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1956, 1, CAST(0x0000A427002D01A3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1957, 1, CAST(0x0000A427003027AA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1958, 1, CAST(0x0000A4270031C706 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1959, 1, CAST(0x0000A42700328C32 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1960, 1, CAST(0x0000A4270033C800 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1961, 1, CAST(0x0000A427003E731D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1962, 1, CAST(0x0000A427003EFE8A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1963, 1, CAST(0x0000A42700423FA1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1964, 1, CAST(0x0000A4270048F944 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1965, 1, CAST(0x0000A427004A07BA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1966, 1, CAST(0x0000A427004BA0C0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1967, 1, CAST(0x0000A427004CFACD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1968, 1, CAST(0x0000A427004E9902 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1969, 1, CAST(0x0000A4270050F060 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1970, 1, CAST(0x0000A4270052F5EE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1971, 1, CAST(0x0000A4270053E56A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1972, 1, CAST(0x0000A4270054F3BF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1973, 1, CAST(0x0000A427014193F9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1974, 1, CAST(0x0000A4270141FFC3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1975, 1, CAST(0x0000A42701432A1A AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1976, 1, CAST(0x0000A427014397A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1977, 1, CAST(0x0000A42B01892AB5 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1978, 1, CAST(0x0000A42B018B4C34 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1979, 1, CAST(0x0000A42C0000DDB0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1980, 1, CAST(0x0000A42C0003710C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1981, 1, CAST(0x0000A42C00041E0C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1982, 1, CAST(0x0000A42C00048BEA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1983, 1, CAST(0x0000A42C00053ACC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1984, 1, CAST(0x0000A42C00094B0E AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1985, 1, CAST(0x0000A42C00098FA1 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1986, 1, CAST(0x0000A42C00B6BF23 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1987, 1, CAST(0x0000A42C00B71BBF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1988, 1, CAST(0x0000A42C00B770BC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1989, 1, CAST(0x0000A42C00BB70DF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1990, 1, CAST(0x0000A42C00BBB7CC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1991, 1, CAST(0x0000A42C00BBF23F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1992, 1, CAST(0x0000A42C00BCCABF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1993, 1, CAST(0x0000A42C00BD6774 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1994, 1, CAST(0x0000A42C00BEF472 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1995, 1, CAST(0x0000A42C00BFE591 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1996, 1, CAST(0x0000A42C00C0403C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1997, 1, CAST(0x0000A42C00C096D0 AS DateTime), 1, 0, 0)
GO
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1998, 1, CAST(0x0000A42C00C0DCEE AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (1999, 1, CAST(0x0000A42C00C1DD87 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2000, 1, CAST(0x0000A42C00C44B75 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2001, 1, CAST(0x0000A42C00C5E94D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2002, 1, CAST(0x0000A42C00C6408C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2003, 1, CAST(0x0000A42C00C6A69B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2004, 1, CAST(0x0000A42C00C71542 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2005, 1, CAST(0x0000A42C00C7DA50 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2006, 1, CAST(0x0000A42C00C87C3D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2007, 1, CAST(0x0000A42C00C8DCAA AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2008, 1, CAST(0x0000A42C00C98BCC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2009, 1, CAST(0x0000A42C00CA0D32 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2010, 1, CAST(0x0000A42C00E90DC0 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2011, 1, CAST(0x0000A42C00EC4C7F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2012, 1, CAST(0x0000A42C00ED90CC AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2013, 1, CAST(0x0000A42C011D0B19 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2014, 1, CAST(0x0000A42C011E850F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2015, 1, CAST(0x0000A42C01215E0F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2016, 1, CAST(0x0000A42D00FDD318 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2017, 1, CAST(0x0000A42D00FE4B4B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2018, 1, CAST(0x0000A42D00FEFC7C AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2019, 1, CAST(0x0000A42D00FF4634 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2020, 1, CAST(0x0000A42D00FFEC93 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2021, 1, CAST(0x0000A42D010072B3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2022, 1, CAST(0x0000A42D0100E239 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2023, 1, CAST(0x0000A432010BDFA9 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2024, 1, CAST(0x0000A432010EA77B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2025, 1, CAST(0x0000A4320112F390 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2026, 1, CAST(0x0000A4320114A5E2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2027, 1, CAST(0x0000A4320114EA59 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2028, 1, CAST(0x0000A436016C2B1B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2029, 1, CAST(0x0000A436016C97A2 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2030, 1, CAST(0x0000A436016D118B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2031, 1, CAST(0x0000A436016E3917 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2032, 1, CAST(0x0000A436016E975F AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2033, 1, CAST(0x0000A436016F8BFF AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2034, 1, CAST(0x0000A4360170DFCD AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2035, 1, CAST(0x0000A43601711CA3 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2036, 1, CAST(0x0000A436017249C4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2037, 1, CAST(0x0000A4360175E024 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2038, 1, CAST(0x0000A4360177EB1B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2039, 1, CAST(0x0000A43601783C0D AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2040, 1, CAST(0x0000A4370030A539 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2041, 1, CAST(0x0000A43700319840 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2042, 1, CAST(0x0000A43700322B6B AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2043, 1, CAST(0x0000A437003292E4 AS DateTime), 1, 0, 0)
INSERT [dbo].[LICHSUDANGNHAP] ([ID], [NhanVienID], [ThoiGian], [Visual], [Deleted], [Edit]) VALUES (2044, 1, CAST(0x0000A437003616F1 AS DateTime), 1, 0, 0)
SET IDENTITY_INSERT [dbo].[LICHSUDANGNHAP] OFF
SET IDENTITY_INSERT [dbo].[LICHSUTONKHO] ON 

INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (1, CAST(0x0000A43601662088 AS DateTime), 1, 2, 1, 0, CAST(0.00 AS Decimal(18, 2)), 10, CAST(30000.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (2, CAST(0x0000A43601664591 AS DateTime), 1, 2, 1, 0, CAST(0.00 AS Decimal(18, 2)), 10, CAST(30000.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 10, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (3, CAST(0x0000A43601664821 AS DateTime), 1, 2, 1, 10, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 3, CAST(78000.00 AS Decimal(18, 2)), 7, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (4, CAST(0x0000A43601798DD1 AS DateTime), 1, 2, 1, 7, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 3, CAST(78000.00 AS Decimal(18, 2)), 4, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (5, CAST(0x0000A43601799029 AS DateTime), 1, 2, 1, 4, CAST(0.00 AS Decimal(18, 2)), 10, CAST(30000.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 14, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (6, CAST(0x0000A436017992DB AS DateTime), 1, 2, 1, 14, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 3, CAST(78000.00 AS Decimal(18, 2)), 11, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (7, CAST(0x0000A436017994AB AS DateTime), 1, 2, 1, 11, CAST(0.00 AS Decimal(18, 2)), 10, CAST(30000.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 21, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (8, CAST(0x0000A4360179987F AS DateTime), 1, 2, 1, 21, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 3, CAST(78000.00 AS Decimal(18, 2)), 18, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (9, CAST(0x0000A43601799916 AS DateTime), 1, 2, 1, 18, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 3, CAST(78000.00 AS Decimal(18, 2)), 15, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (10, CAST(0x0000A4360179CF91 AS DateTime), 1, 2, 1, 15, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 5, CAST(78000.00 AS Decimal(18, 2)), 10, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (11, CAST(0x0000A4360179D027 AS DateTime), 1, 2, 1, 10, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 6, CAST(78000.00 AS Decimal(18, 2)), 4, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (12, CAST(0x0000A4360179D0C6 AS DateTime), 1, 2, 1, 4, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 0, CAST(78000.00 AS Decimal(18, 2)), 4, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (13, CAST(0x0000A4360179D13F AS DateTime), 1, 2, 1, 4, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 6, CAST(78000.00 AS Decimal(18, 2)), -2, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (14, CAST(0x0000A4360179D1C3 AS DateTime), 1, 2, 1, -2, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 2, CAST(78000.00 AS Decimal(18, 2)), -4, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (16, CAST(0x0000A4370032406C AS DateTime), 1, 2, 1, -4, CAST(0.00 AS Decimal(18, 2)), 18, CAST(30000.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 14, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (17, CAST(0x0000A4370032D308 AS DateTime), 1, 2, 1, 14, CAST(0.00 AS Decimal(18, 2)), 128, CAST(384000.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 142, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (18, CAST(0x0000A43700362CA8 AS DateTime), 1, 2, 1, 142, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 5, CAST(0.00 AS Decimal(18, 2)), 137, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[LICHSUTONKHO] ([ID], [NgayGhiNhan], [KhoID], [MonID], [DonViID], [DauKySoLuong], [DauKyThanhTien], [NhapSoLuong], [NhapThanhTien], [XuatSoLuong], [XuatThanhTien], [CuoiKySoLuong], [CuoiKyDonGia], [CuoiKyThanhTien]) VALUES (19, CAST(0x0000A43700362CA8 AS DateTime), 2, 2, 1, 0, CAST(0.00 AS Decimal(18, 2)), 5, CAST(0.00 AS Decimal(18, 2)), 0, CAST(0.00 AS Decimal(18, 2)), 5, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[LICHSUTONKHO] OFF
SET IDENTITY_INSERT [dbo].[LOAIBAN] ON 

INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (1, N'Cái', 1, 1, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (2, N'Gram', 1, 2, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (3, N'Kg', 1000, 2, 1, 0, 0)
INSERT [dbo].[LOAIBAN] ([LoaiBanID], [TenLoaiBan], [KichThuocBan], [DonViID], [Visual], [Deleted], [Edit]) VALUES (4, N'Millilit', 1, 3, 1, 0, 0)
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
INSERT [dbo].[LOAITHUCHI] ([LoaiThuChiID], [TenLoaiThuChi]) VALUES (1, N'Phiếu thu')
INSERT [dbo].[LOAITHUCHI] ([LoaiThuChiID], [TenLoaiThuChi]) VALUES (2, N'Phiếu chi')
SET IDENTITY_INSERT [dbo].[MAYIN] ON 

INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (21, N'Send To OneNote 2013', N'BẾP', 0, 1, 1, 0, 0, 0)
INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (22, N'Send To OneNote 2013', N'HÓA ĐƠN', 0, 1, 1, 0, 0, 1)
INSERT [dbo].[MAYIN] ([MayInID], [TenMayIn], [TieuDeIn], [HopDungTien], [SoLanIn], [Visual], [Deleted], [Edit], [MayInHoaDon]) VALUES (23, N'Send To OneNote 2013', N'BẾP 1', 0, 1, 1, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[MAYIN] OFF
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (1, 21, 0, 0, 0)
INSERT [dbo].[MENUITEMMAYIN] ([MonID], [MayInID], [Visual], [Deleted], [Edit]) VALUES (2, 21, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[MENUKICHTHUOCMON] ON 

INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonViID], [ChoPhepTonKho], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [SapXep], [Visual], [Deleted], [Edit]) VALUES (1, 1, N'', 6, 4, 1, CAST(100000.00 AS Decimal(18, 2)), 0, 3600, 1, 1, 1, 0, 0)
INSERT [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID], [MonID], [TenLoaiBan], [LoaiBanID], [DonViID], [ChoPhepTonKho], [GiaBanMacDinh], [ThoiGia], [KichThuocLoaiBan], [SoLuongBanBan], [SapXep], [Visual], [Deleted], [Edit]) VALUES (2, 2, N'', 1, 1, 1, CAST(100000.00 AS Decimal(18, 2)), 0, 1, 1, 1, 1, 0, 1)
SET IDENTITY_INSERT [dbo].[MENUKICHTHUOCMON] OFF
SET IDENTITY_INSERT [dbo].[MENULOAIGIA] ON 

INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (1, N'Tết nguyên đán', N'Tết nguyên đán', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (2, N'Sáng chủ nhật', N'Sáng chủ nhật', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (3, N'Tối chủ nhật', N'Tối chủ nhật', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (4, N'Sáng thứ 7', N'Sáng thứ 7', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (5, N'Tối thứ 7', N'Tối thứ 7', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (6, N'Sáng từ thứ 2 đến thứ 6', N'Sáng từ thứ 2 đến thứ 6', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (14, N'Lễ trong năm', N'Lễ trong năm', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (15, N'Sinh nhật', N'Sinh nhật', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (16, N'Tối từ thứ 2 đến thứ 6', N'Tối từ thứ 2 đến thứ 6', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (17, N'asasasa', N'', 1, 1, 0)
INSERT [dbo].[MENULOAIGIA] ([LoaiGiaID], [Ten], [DienGiai], [Visual], [Deleted], [Edit]) VALUES (18, N'Giá', N'', 1, 1, 0)
SET IDENTITY_INSERT [dbo].[MENULOAIGIA] OFF
SET IDENTITY_INSERT [dbo].[MENULOAINHOM] ON 

INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom], [Visual], [Deleted], [Edit]) VALUES (1, N'Nước', 2, 1, 0, 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom], [Visual], [Deleted], [Edit]) VALUES (2, N'Thức Ăn', 2, 1, 0, 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom], [Visual], [Deleted], [Edit]) VALUES (3, N'Nguyên Liệu', 2, 1, 0, 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom], [Visual], [Deleted], [Edit]) VALUES (4, N'Karaoke', 2, 1, 0, 0)
INSERT [dbo].[MENULOAINHOM] ([LoaiNhomID], [TenLoaiNhom], [SapXepNhom], [Visual], [Deleted], [Edit]) VALUES (5, N'Dịch Vụ', 2, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[MENULOAINHOM] OFF
SET IDENTITY_INSERT [dbo].[MENUMON] ON 

INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [DonViID], [MaVach], [TonKhoToiThieu], [TonKhoToiDa], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SLMonChoPhepTonKho], [SLMonKhongChoPhepTonKho], [Visual], [Deleted], [Edit]) VALUES (1, N'Giờ Karaoke', N'Giờ Karaoke', 38, CAST(100000.00 AS Decimal(18, 2)), 0, 4, N'', 0, 0, 2, 2, 0, NULL, 1, 0, 1, 0, 0)
INSERT [dbo].[MENUMON] ([MonID], [TenNgan], [TenDai], [NhomID], [Gia], [GST], [DonViID], [MaVach], [TonKhoToiThieu], [TonKhoToiDa], [SapXep], [SapXepKichThuocMon], [GiamGia], [Hinh], [SLMonChoPhepTonKho], [SLMonKhongChoPhepTonKho], [Visual], [Deleted], [Edit]) VALUES (2, N'Test', N'Test', 37, CAST(0.00 AS Decimal(18, 2)), 0, 1, N'G0000423', 0, 0, 2, 2, 0, NULL, 1, 0, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[MENUMON] OFF
SET IDENTITY_INSERT [dbo].[MENUNHOM] ON 

INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [SapXep], [SLMonChoPhepTonKho], [SLMonKhongChoPhepTonKho], [SapXepMon], [GiamGia], [Hinh], [Visual], [Deleted]) VALUES (37, N'Test', N'Test', 2, 1, 1, 0, 1, 0, NULL, 1, 0)
INSERT [dbo].[MENUNHOM] ([NhomID], [TenNgan], [TenDai], [LoaiNhomID], [SapXep], [SLMonChoPhepTonKho], [SLMonKhongChoPhepTonKho], [SapXepMon], [GiamGia], [Hinh], [Visual], [Deleted]) VALUES (38, N'Giờ Karaoke', N'Giờ Karaoke', 4, 1, 1, 0, 1, 0, NULL, 1, 0)
SET IDENTITY_INSERT [dbo].[MENUNHOM] OFF
SET IDENTITY_INSERT [dbo].[NHACUNGCAP] ON 

INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (1, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (3, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (4, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (5, N'45615121561', N'Trần Minh Tiến', N'123', N'0986954226', N'0986954226', N'1651513521', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (7, N'45615121561', N'Trần Minh Tiến', N'142 Võ Văn Tần', N'0986954226', N'0986954226', N'5345345643', N'minhtien05@gmail.com', 1, 1, 0)
INSERT [dbo].[NHACUNGCAP] ([NhaCungCapID], [MaSoThue], [TenNhaCungCap], [DiaChi], [Mobile], [Phone], [Fax], [Email], [Visual], [Deleted], [Edit]) VALUES (8, N'Không có', N'Nhà cung cấp chung', N'Không có', N'Không có', N'Không có', N'Không có', N'Không có', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[NHACUNGCAP] OFF
SET IDENTITY_INSERT [dbo].[NHANVIEN] ON 

INSERT [dbo].[NHANVIEN] ([NhanVienID], [TenDangNhap], [TenNhanVien], [MatKhau], [LoaiNhanVienID], [CapDo], [Edit], [Visual], [Deleted]) VALUES (1, N'1111', N'KAAAA', N'b59c67bf196a4758191e42f76670ceba', 1, 1, 0, 1, 0)
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

INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (39, 1, 1, 8, CAST(0x0000A3F6003C6C93 AS DateTime), CAST(0.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (40, 1, 1, 8, CAST(0x0000A3F601786481 AS DateTime), CAST(0.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (41, 1, 1, 8, CAST(0x0000A3F6017BE0BF AS DateTime), CAST(0.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (42, 1, 1, 8, CAST(0x0000A3F60181EDF7 AS DateTime), CAST(0.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (43, 1, 1, 8, CAST(0x0000A409001253F1 AS DateTime), CAST(0.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (44, 1, 1, 8, CAST(0x0000A4370030C7E6 AS DateTime), CAST(360000.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (45, 1, 1, 8, CAST(0x0000A4370031C2D5 AS DateTime), CAST(510000.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (46, 1, 1, 8, CAST(0x0000A43700324054 AS DateTime), CAST(540000.00 AS Decimal(18, 2)), 1, 0, 0)
INSERT [dbo].[NHAPKHO] ([NhapKhoID], [NhanVienID], [KhoID], [NhaCungCapID], [ThoiGian], [TongTien], [Visual], [Deleted], [Edit]) VALUES (47, 1, 1, 8, CAST(0x0000A4370032D2EC AS DateTime), CAST(384000.00 AS Decimal(18, 2)), 1, 0, 0)
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
INSERT [dbo].[THAMSO] ([BanHangKhongKho], [SoMay], [BanQuyen], [NgayBatDau], [XacNhanNgayBatDau], [NgayKetThuc], [XacNhanNgayKetThuc], [ThuTuMaHoaDon]) VALUES (NULL, 1, N'10A61FB220AC931', CAST(0x8D390B00 AS Date), N'32e677e5024072d5fa186f6c2837a71c', CAST(0x94390B00 AS Date), N'7615cc466ffb86f27a9060d97aa27076', 83)
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

INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (1, 1, 2, 1, 1, 1, NULL, 60, 55, CAST(0x0000A4370030BC63 AS DateTime), CAST(0x0000A4370030BC63 AS DateTime), CAST(100000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), 1, 0, 1, 0, 0)
INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (2, 1, 2, 1, 1, 1, NULL, 17, 17, CAST(0x0000A4370031A77A AS DateTime), CAST(0x0000A4370031A77A AS DateTime), CAST(100000.00 AS Decimal(18, 2)), CAST(30000.00 AS Decimal(18, 2)), 1, 0, 1, 0, 0)
INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (3, 1, 2, 1, 1, 1, NULL, 18, 18, CAST(0x0000A43700323791 AS DateTime), CAST(0x0000A43700323791 AS DateTime), CAST(100000.00 AS Decimal(18, 2)), CAST(30000.00 AS Decimal(18, 2)), 1, 0, 1, 0, 0)
INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (4, 1, 2, 1, 1, 1, NULL, 128, 128, CAST(0x0000A4370032C9DC AS DateTime), CAST(0x0000A4370032C9DC AS DateTime), CAST(100000.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), 1, 0, 1, 0, 0)
INSERT [dbo].[TONKHO] ([TonKhoID], [KhoID], [MonID], [LoaiBanID], [DonViID], [DonViTinh], [PhatSinhTuTonKhoID], [SoLuongNhap], [SoLuongTon], [NgaySanXuat], [NgayHetHan], [GiaBan], [GiaNhap], [LoaiPhatSinhID], [SoLuongPhatSinh], [Visual], [Deleted], [Edit]) VALUES (5, 2, 2, 1, 1, 1, 1, 5, 5, CAST(0x0000A4370030BC63 AS DateTime), CAST(0x0000A4370030BC63 AS DateTime), CAST(100000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), 2, 0, 1, 0, 0)
SET IDENTITY_INSERT [dbo].[TONKHO] OFF
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (1, N'Bàn đang lấy món', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (2, N'Bàn đang ra hóa đơn', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (3, N'Bàn đã tính tiền', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (4, N'Bàn đã hoàn thành', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (5, N'Bàn đã chuyển', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (6, N'Bàn đã gộp', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (7, N'Bàn đã tách', 1, 0, 0)
INSERT [dbo].[TRANGTHAI] ([TrangThaiID], [TenTrangThai], [Visual], [Deleted], [Edit]) VALUES (8, N'Bàn đã hủy', 1, 0, 0)
SET IDENTITY_INSERT [dbo].[XULYKHO] ON 

INSERT [dbo].[XULYKHO] ([ChinhKhoID], [NhanVienID], [KhoID], [LoaiID], [ThoiGian], [TongTien], [Deleted], [Edit], [Visual]) VALUES (1, 1, 1, 2, CAST(0x0000A4090012EF41 AS DateTime), CAST(0.00 AS Decimal(18, 2)), 0, 0, 1)
SET IDENTITY_INSERT [dbo].[XULYKHO] OFF
INSERT [dbo].[XULYKHOLOAI] ([ID], [Ten]) VALUES (1, N'Chỉnh kho')
INSERT [dbo].[XULYKHOLOAI] ([ID], [Ten]) VALUES (2, N'Mất kho')
INSERT [dbo].[XULYKHOLOAI] ([ID], [Ten]) VALUES (3, N'Hư kho')
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
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienGiam]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_PhiDichVu]  DEFAULT ((0)) FOR [PhiDichVu]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_ThueVAT]  DEFAULT ((0)) FOR [ThueVAT]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_SoPhut]  DEFAULT ((0)) FOR [SoPhut]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienMat]  DEFAULT ((0)) FOR [TienMat]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienThe]  DEFAULT ((0)) FOR [TienThe]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienTraLai]  DEFAULT ((0)) FOR [TienTraLai]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_ChietKhau]  DEFAULT ((0)) FOR [ChietKhau]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienBo]  DEFAULT ((0)) FOR [TienBo]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[BANHANG] ADD  CONSTRAINT [DF_BANHANG_TienKhacHang]  DEFAULT ((0)) FOR [TienKhacHang]
GO
ALTER TABLE [dbo].[CAIDATBAN] ADD  CONSTRAINT [DF_CAIDATBAN_TableWidth]  DEFAULT ((0)) FOR [TableWidth]
GO
ALTER TABLE [dbo].[CAIDATBAN] ADD  CONSTRAINT [DF_CAIDATBAN_TableHeight]  DEFAULT ((0)) FOR [TableHeight]
GO
ALTER TABLE [dbo].[CAIDATBAN] ADD  CONSTRAINT [DF_CAIDATBAN_TableFontSize]  DEFAULT ((12)) FOR [TableFontSize]
GO
ALTER TABLE [dbo].[CAIDATBAN] ADD  CONSTRAINT [DF_CAIDATBAN_TableFontStyle]  DEFAULT ((0)) FOR [TableFontStyle]
GO
ALTER TABLE [dbo].[CAIDATBAN] ADD  CONSTRAINT [DF_CAIDATBAN_TableFontWeights]  DEFAULT ((1)) FOR [TableFontWeights]
GO
ALTER TABLE [dbo].[CAIDATBANHANG] ADD  CONSTRAINT [DF_CAIDATBANHANG_PhiDichVu]  DEFAULT ((0)) FOR [PhiDichVu]
GO
ALTER TABLE [dbo].[CAIDATBANHANG] ADD  CONSTRAINT [DF_CAIDATBANHANG_ChoPhepPhiDichVu]  DEFAULT ((0)) FOR [ChoPhepPhiDichVu]
GO
ALTER TABLE [dbo].[CAIDATBANHANG] ADD  CONSTRAINT [DF_CAIDATBANHANG_ThueVAT]  DEFAULT ((0)) FOR [ThueVAT]
GO
ALTER TABLE [dbo].[CAIDATBANHANG] ADD  CONSTRAINT [DF_CAIDATBANHANG_ChoPhepThueVAT]  DEFAULT ((0)) FOR [ChoPhepThueVAT]
GO
ALTER TABLE [dbo].[CAIDATBANHANG] ADD  CONSTRAINT [DF_CAIDATBANHANG_KhoaSoDoBan]  DEFAULT ((0)) FOR [KhoaSoDoBan]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_TitleTextFontSize]  DEFAULT ((12)) FOR [TitleTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_TitleTextFontStyle]  DEFAULT ((0)) FOR [TitleTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_TitleTextFontWeights]  DEFAULT ((0)) FOR [TitleTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_InfoTextFontSize]  DEFAULT ((12)) FOR [InfoTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_InfoTextFontStyle]  DEFAULT ((0)) FOR [InfoTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_InfoTextFontWeights]  DEFAULT ((0)) FOR [InfoTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_ItemTextFontSize]  DEFAULT ((12)) FOR [ItemTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_ItemTextFontStyle]  DEFAULT ((0)) FOR [ItemTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_ItemTextFontWeights]  DEFAULT ((0)) FOR [ItemTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_SumTextFontSize]  DEFAULT ((12)) FOR [SumTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_SumTextFontStyle]  DEFAULT ((0)) FOR [SumTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINBEP] ADD  CONSTRAINT [DF_CAIDATMAYINBEP_SumTextFontWeights]  DEFAULT ((0)) FOR [SumTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontSize1]  DEFAULT ((12)) FOR [HeaderTextFontSize1]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontSize2]  DEFAULT ((12)) FOR [HeaderTextFontSize2]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontSize3]  DEFAULT ((12)) FOR [HeaderTextFontSize3]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontSize4]  DEFAULT ((12)) FOR [HeaderTextFontSize4]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontStyle1]  DEFAULT ((0)) FOR [HeaderTextFontStyle1]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontStyle2]  DEFAULT ((0)) FOR [HeaderTextFontStyle2]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontStyle3]  DEFAULT ((0)) FOR [HeaderTextFontStyle3]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontStyle4]  DEFAULT ((0)) FOR [HeaderTextFontStyle4]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontWeights1]  DEFAULT ((0)) FOR [HeaderTextFontWeights1]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontWeights2]  DEFAULT ((0)) FOR [HeaderTextFontWeights2]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontWeights3]  DEFAULT ((0)) FOR [HeaderTextFontWeights3]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_HeaderTextFontWeights4]  DEFAULT ((0)) FOR [HeaderTextFontWeights4]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontSize1]  DEFAULT ((12)) FOR [FooterTextFontSize1]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontSize2]  DEFAULT ((12)) FOR [FooterTextFontSize2]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontSize3]  DEFAULT ((12)) FOR [FooterTextFontSize3]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontSize4]  DEFAULT ((12)) FOR [FooterTextFontSize4]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontStyle1]  DEFAULT ((0)) FOR [FooterTextFontStyle1]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontStyle2]  DEFAULT ((0)) FOR [FooterTextFontStyle2]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontStyle3]  DEFAULT ((0)) FOR [FooterTextFontStyle3]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontStyle4]  DEFAULT ((0)) FOR [FooterTextFontStyle4]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontWeights1]  DEFAULT ((0)) FOR [FooterTextFontWeights1]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontWeights2]  DEFAULT ((0)) FOR [FooterTextFontWeights2]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontWeights3]  DEFAULT ((0)) FOR [FooterTextFontWeights3]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_FooterTextFontWeights4]  DEFAULT ((0)) FOR [FooterTextFontWeights4]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_SumanyFontSize]  DEFAULT ((12)) FOR [SumanyFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_SumanyFontStyle]  DEFAULT ((0)) FOR [SumanyFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_SumanyFontWeights]  DEFAULT ((0)) FOR [SumanyFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_SumanyFontSizeBig]  DEFAULT ((12)) FOR [SumanyFontSizeBig]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_SumanyFontStyleBig]  DEFAULT ((0)) FOR [SumanyFontStyleBig]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_SumanyFontWeightsBig]  DEFAULT ((0)) FOR [SumanyFontWeightsBig]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_TitleTextFontSize]  DEFAULT ((12)) FOR [TitleTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_TitleTextFontStyle]  DEFAULT ((0)) FOR [TitleTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_TitleTextFontWeights]  DEFAULT ((0)) FOR [TitleTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_InfoTextFontSize]  DEFAULT ((12)) FOR [InfoTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_InfoTextFontStyle]  DEFAULT ((0)) FOR [InfoTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_InfoTextFontWeights]  DEFAULT ((0)) FOR [InfoTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_ItemFontSize]  DEFAULT ((12)) FOR [ItemFontSize]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_ItemTextFontStyle]  DEFAULT ((0)) FOR [ItemTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_ItemTextFontWeights]  DEFAULT ((0)) FOR [ItemTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_LogoHeight]  DEFAULT ((0)) FOR [LogoHeight]
GO
ALTER TABLE [dbo].[CAIDATMAYINHOADON] ADD  CONSTRAINT [DF_CAIDATMAYINHOADON_LogoWidth]  DEFAULT ((0)) FOR [LogoWidth]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_NhomTextFontSize]  DEFAULT ((12)) FOR [NhomTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_NhomTextFontStyle]  DEFAULT ((0)) FOR [NhomTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_NhomTextFontWeights]  DEFAULT ((0)) FOR [NhomTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_MonTextFontSize]  DEFAULT ((12)) FOR [MonTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_MonTextFontStyle]  DEFAULT ((0)) FOR [MonTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_MonTextFontWeights]  DEFAULT ((0)) FOR [MonTextFontWeights]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_LoaiNhomTextFontSize]  DEFAULT ((12)) FOR [LoaiNhomTextFontSize]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_LoaiNhomTextFontStyle]  DEFAULT ((0)) FOR [LoaiNhomTextFontStyle]
GO
ALTER TABLE [dbo].[CAIDATTHUCDON] ADD  CONSTRAINT [DF_CAIDATTHUCDON_LoaiNhomTextFontWeights]  DEFAULT ((0)) FOR [LoaiNhomTextFontWeights]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_SoLuongBan]  DEFAULT ((0)) FOR [SoLuongBan]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_KichThuocLoaiBan]  DEFAULT ((1)) FOR [KichThuocLoaiBan]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_GiamGia]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_GiaBan]  DEFAULT ((0)) FOR [GiaBan]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_ThanhTien]  DEFAULT ((0)) FOR [ThanhTien]
GO
ALTER TABLE [dbo].[CHITIETBANHANG] ADD  CONSTRAINT [DF_CHITIETBANHANG_LoaiChiTietBanHang]  DEFAULT ((0)) FOR [LoaiChiTietBanHang]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] ADD  CONSTRAINT [DF_CHITIETCHUYENKHO_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] ADD  CONSTRAINT [DF_CHITIETCHUYENKHO_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[CHITIETCHUYENKHO] ADD  CONSTRAINT [DF_CHITIETCHUYENKHO_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_SoLuong]  DEFAULT ((0)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_KichThuocLoaiBan]  DEFAULT ((1)) FOR [KichThuocLoaiBan]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_GiamGia]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_GiaBan]  DEFAULT ((0)) FOR [GiaBan]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_ThanhTien]  DEFAULT ((0)) FOR [ThanhTien]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_TrangThai]  DEFAULT ((0)) FOR [TrangThai]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] ADD  CONSTRAINT [DF_CHITIETLICHSUBANHANG_LoaiChiTietBanHang]  DEFAULT ((0)) FOR [LoaiChiTietBanHang]
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
ALTER TABLE [dbo].[HOPDUNGTIEN] ADD  CONSTRAINT [DF__HOPDUNGTI__Visua__27F8EE98]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] ADD  CONSTRAINT [DF__HOPDUNGTI__Delet__28ED12D1]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[HOPDUNGTIEN] ADD  CONSTRAINT [DF__HOPDUNGTIE__Edit__29E1370A]  DEFAULT ((0)) FOR [Edit]
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
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_NgayGhiNhan]  DEFAULT (getdate()) FOR [NgayGhiNhan]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_DauKySoLuong]  DEFAULT ((0)) FOR [DauKySoLuong]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_DauKyThanhTien]  DEFAULT ((0)) FOR [DauKyThanhTien]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_NhapSoLuong]  DEFAULT ((0)) FOR [NhapSoLuong]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_NhapThanhTien]  DEFAULT ((0)) FOR [NhapThanhTien]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_XuatSoLuong]  DEFAULT ((0)) FOR [XuatSoLuong]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_XuatThanhTien]  DEFAULT ((0)) FOR [XuatThanhTien]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_CuoiKySoLuong]  DEFAULT ((0)) FOR [CuoiKySoLuong]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_CuoiKyDonGia]  DEFAULT ((0)) FOR [CuoiKyDonGia]
GO
ALTER TABLE [dbo].[LICHSUTONKHO] ADD  CONSTRAINT [DF_LICHSUTONKHO_CuoiKyThanhTien]  DEFAULT ((0)) FOR [CuoiKyThanhTien]
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
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_DonVi]  DEFAULT ((0)) FOR [DonViID]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_ChoPhepTonKho]  DEFAULT ((1)) FOR [ChoPhepTonKho]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_GiaBanMacDinh]  DEFAULT ((0)) FOR [GiaBanMacDinh]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_ThoiGia]  DEFAULT ((0)) FOR [ThoiGia]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_KichThuocLoaiBan]  DEFAULT ((0)) FOR [KichThuocLoaiBan]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_SoLuongBanBan]  DEFAULT ((1)) FOR [SoLuongBanBan]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_SapXep]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF_MENUKICHTHUOCMON_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] ADD  CONSTRAINT [DF__MENUKICHTH__Edit__69FBBC1F]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENULOAIGIA] ADD  CONSTRAINT [DF_MENULOAIGIA_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENULOAIGIA] ADD  CONSTRAINT [DF_MENULOAIGIA_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENULOAIGIA] ADD  CONSTRAINT [DF__MENULOAIGI__Edit__038683F8]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[MENULOAINHOM] ADD  CONSTRAINT [DF_MENULOAINHOM_SapXepNhom]  DEFAULT ((0)) FOR [SapXepNhom]
GO
ALTER TABLE [dbo].[MENULOAINHOM] ADD  CONSTRAINT [DF_MENULOAINHOM_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[MENULOAINHOM] ADD  CONSTRAINT [DF_MENULOAINHOM_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[MENULOAINHOM] ADD  CONSTRAINT [DF_MENULOAINHOM_Edit]  DEFAULT ((0)) FOR [Edit]
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
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_TonKhoToiThieu]  DEFAULT ((0)) FOR [TonKhoToiThieu]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_TonKhoToiDa]  DEFAULT ((0)) FOR [TonKhoToiDa]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Displa__45F365D3]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_SapXepKichThuocMon]  DEFAULT ((0)) FOR [SapXepKichThuocMon]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Discou__46E78A0C]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF__MENUITEM__Bitmap__47DBAE45]  DEFAULT ('') FOR [Hinh]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_SoLuongKichThuocMon]  DEFAULT ((0)) FOR [SLMonChoPhepTonKho]
GO
ALTER TABLE [dbo].[MENUMON] ADD  CONSTRAINT [DF_MENUMON_SLDonVi2]  DEFAULT ((0)) FOR [SLMonKhongChoPhepTonKho]
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
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Displ__33D4B598]  DEFAULT ((0)) FOR [SapXep]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF_MENUNHOM_SLDonVi2]  DEFAULT ((0)) FOR [SLMonChoPhepTonKho]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF_MENUNHOM_SapXepMon]  DEFAULT ((0)) FOR [SLMonKhongChoPhepTonKho]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF_MENUNHOM_SapXepMon_1]  DEFAULT ((0)) FOR [SapXepMon]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Disco__34C8D9D1]  DEFAULT ((0)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[MENUNHOM] ADD  CONSTRAINT [DF__MENUGROUP__Bitma__35BCFE0A]  DEFAULT ('') FOR [Hinh]
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
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF_TACHBAN_BanID]  DEFAULT ((0)) FOR [BanHangID]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF__TACHBAN__Visual__3335971A]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF__TACHBAN__Deleted__3429BB53]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[TACHBAN] ADD  CONSTRAINT [DF__TACHBAN__Edit__351DDF8C]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[THAMSO] ADD  CONSTRAINT [DF_THAMSO_SoMay]  DEFAULT ((0)) FOR [SoMay]
GO
ALTER TABLE [dbo].[THAMSO] ADD  CONSTRAINT [DF_THAMSO_ThuTuMaHoaDon]  DEFAULT ((1)) FOR [ThuTuMaHoaDon]
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
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[THUCHI] ADD  CONSTRAINT [DF_THUCHI_Edit]  DEFAULT ((0)) FOR [Edit]
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
ALTER TABLE [dbo].[TONKHOCHITIETBANHANG] ADD  CONSTRAINT [DF_TONKHOCHITIETBANHANG_MayID]  DEFAULT ((0)) FOR [MayID]
GO
ALTER TABLE [dbo].[TONKHOCHITIETBANHANG] ADD  CONSTRAINT [DF_TONKHOCHITIETBANHANG_SoLuong]  DEFAULT ((0)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongTon]  DEFAULT ((0)) FOR [SoLuongTon]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongBan]  DEFAULT ((0)) FOR [SoLuongBan]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongNhap]  DEFAULT ((0)) FOR [SoLuongNhap]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongChuyen]  DEFAULT ((0)) FOR [SoLuongChuyen]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongHu]  DEFAULT ((0)) FOR [SoLuongHu]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongDieuChinh]  DEFAULT ((0)) FOR [SoLuongDieuChinh]
GO
ALTER TABLE [dbo].[TONKHOTONG] ADD  CONSTRAINT [DF_TONKHOTONG_SoLuongMat]  DEFAULT ((0)) FOR [SoLuongMat]
GO
ALTER TABLE [dbo].[TONKHOTONGLOG] ADD  CONSTRAINT [DF_TONKHOTONGLOG_TrangThai]  DEFAULT ((0)) FOR [TrangThai]
GO
ALTER TABLE [dbo].[TRANGTHAI] ADD  CONSTRAINT [DF__TRANGTHAI__Visua__5772F790]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[TRANGTHAI] ADD  CONSTRAINT [DF__TRANGTHAI__Delet__58671BC9]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[TRANGTHAI] ADD  CONSTRAINT [DF__TRANGTHAI__Edit__595B4002]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[XULYKHO] ADD  CONSTRAINT [DF_CHINHKHO_TongTien]  DEFAULT ((0)) FOR [TongTien]
GO
ALTER TABLE [dbo].[XULYKHO] ADD  CONSTRAINT [DF_CHINHKHO_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[XULYKHO] ADD  CONSTRAINT [DF_CHINHKHO_Edit]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[XULYKHO] ADD  CONSTRAINT [DF_CHINHKHO_Visual]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[XULYKHOCHITIET] ADD  CONSTRAINT [DF__CHITIETCH__Visua__09A971A2]  DEFAULT ((1)) FOR [Visual]
GO
ALTER TABLE [dbo].[XULYKHOCHITIET] ADD  CONSTRAINT [DF__CHITIETCH__Delet__0A9D95DB]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[XULYKHOCHITIET] ADD  CONSTRAINT [DF__CHITIETCHI__Edit__0B91BA14]  DEFAULT ((0)) FOR [Edit]
GO
ALTER TABLE [dbo].[XULYKHOLOAI] ADD  CONSTRAINT [DF_XULYKHOLOAI_ID]  DEFAULT ((0)) FOR [ID]
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
ALTER TABLE [dbo].[CHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETBANHANG_BANHANG] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[CHITIETBANHANG] CHECK CONSTRAINT [FK_CHITIETBANHANG_BANHANG]
GO
ALTER TABLE [dbo].[CHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETBANHANG_CHITIETBANHANG] FOREIGN KEY([ChiTietBanHangID_Ref])
REFERENCES [dbo].[CHITIETBANHANG] ([ChiTietBanHangID])
GO
ALTER TABLE [dbo].[CHITIETBANHANG] CHECK CONSTRAINT [FK_CHITIETBANHANG_CHITIETBANHANG]
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
ALTER TABLE [dbo].[CHITIETGOPBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETGOPBAN_GOPBAN] FOREIGN KEY([BanHangID])
REFERENCES [dbo].[GOPBAN] ([GopBanID])
GO
ALTER TABLE [dbo].[CHITIETGOPBAN] CHECK CONSTRAINT [FK_CHITIETGOPBAN_GOPBAN]
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETLICHSUBANHANG_CHITIETLICHSUBANHANG] FOREIGN KEY([ChiTietLichSuBanHangID_Ref])
REFERENCES [dbo].[CHITIETLICHSUBANHANG] ([ChiTietLichSuBanHangID])
GO
ALTER TABLE [dbo].[CHITIETLICHSUBANHANG] CHECK CONSTRAINT [FK_CHITIETLICHSUBANHANG_CHITIETLICHSUBANHANG]
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
ALTER TABLE [dbo].[CHITIETTHUCHI]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETTHUCHI_THUCHI] FOREIGN KEY([ThuChiID])
REFERENCES [dbo].[THUCHI] ([ID])
GO
ALTER TABLE [dbo].[CHITIETTHUCHI] CHECK CONSTRAINT [FK_CHITIETTHUCHI_THUCHI]
GO
ALTER TABLE [dbo].[CHUCNANG]  WITH CHECK ADD  CONSTRAINT [FK_CHUCNANG_NHOMCHUCNANG] FOREIGN KEY([NhomChucNangID])
REFERENCES [dbo].[NHOMCHUCNANG] ([NhomChucNangID])
GO
ALTER TABLE [dbo].[CHUCNANG] CHECK CONSTRAINT [FK_CHUCNANG_NHOMCHUCNANG]
GO
ALTER TABLE [dbo].[CHUYENBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENBAN_BANHANG] FOREIGN KEY([TuBanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[CHUYENBAN] CHECK CONSTRAINT [FK_CHUYENBAN_BANHANG]
GO
ALTER TABLE [dbo].[CHUYENBAN]  WITH CHECK ADD  CONSTRAINT [FK_CHUYENBAN_BANHANG1] FOREIGN KEY([DenBanHangID])
REFERENCES [dbo].[BANHANG] ([BanHangID])
GO
ALTER TABLE [dbo].[CHUYENBAN] CHECK CONSTRAINT [FK_CHUYENBAN_BANHANG1]
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
ALTER TABLE [dbo].[LICHBIEUDINHKY]  WITH CHECK ADD  CONSTRAINT [FK_LICHBIEUDINHKY_KHU] FOREIGN KEY([KhuID])
REFERENCES [dbo].[KHU] ([KhuID])
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] CHECK CONSTRAINT [FK_LICHBIEUDINHKY_KHU]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY]  WITH CHECK ADD  CONSTRAINT [FK_LICHBIEUDINHKY_MENULOAIGIA] FOREIGN KEY([LoaiGiaID])
REFERENCES [dbo].[MENULOAIGIA] ([LoaiGiaID])
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] CHECK CONSTRAINT [FK_LICHBIEUDINHKY_MENULOAIGIA]
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY]  WITH CHECK ADD  CONSTRAINT [FK_LICHBIEUDINHKY_THELOAILICHBIEU] FOREIGN KEY([TheLoaiID])
REFERENCES [dbo].[THELOAILICHBIEU] ([TheLoaiID])
GO
ALTER TABLE [dbo].[LICHBIEUDINHKY] CHECK CONSTRAINT [FK_LICHBIEUDINHKY_THELOAILICHBIEU]
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY]  WITH CHECK ADD  CONSTRAINT [FK_LICHBIEUKHONGDINHKY_KHU] FOREIGN KEY([KhuID])
REFERENCES [dbo].[KHU] ([KhuID])
GO
ALTER TABLE [dbo].[LICHBIEUKHONGDINHKY] CHECK CONSTRAINT [FK_LICHBIEUKHONGDINHKY_KHU]
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
ALTER TABLE [dbo].[MENUGIA]  WITH CHECK ADD  CONSTRAINT [FK_MENUGIA_MENUKICHTHUOCMON] FOREIGN KEY([KichThuocMonID])
REFERENCES [dbo].[MENUKICHTHUOCMON] ([KichThuocMonID])
GO
ALTER TABLE [dbo].[MENUGIA] CHECK CONSTRAINT [FK_MENUGIA_MENUKICHTHUOCMON]
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
ALTER TABLE [dbo].[MENUKICHTHUOCMON]  WITH CHECK ADD  CONSTRAINT [FK_MENUKICHTHUOCMON_DONVI] FOREIGN KEY([DonViID])
REFERENCES [dbo].[DONVI] ([DonViID])
GO
ALTER TABLE [dbo].[MENUKICHTHUOCMON] CHECK CONSTRAINT [FK_MENUKICHTHUOCMON_DONVI]
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
ALTER TABLE [dbo].[MENUMON]  WITH CHECK ADD  CONSTRAINT [FK_MENUMON_DONVI] FOREIGN KEY([DonViID])
REFERENCES [dbo].[DONVI] ([DonViID])
GO
ALTER TABLE [dbo].[MENUMON] CHECK CONSTRAINT [FK_MENUMON_DONVI]
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
ALTER TABLE [dbo].[TONKHOCHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_TONKHOCHITIETBANHANG_CHITIETBANHANG] FOREIGN KEY([ChiTietBanHangID])
REFERENCES [dbo].[CHITIETBANHANG] ([ChiTietBanHangID])
GO
ALTER TABLE [dbo].[TONKHOCHITIETBANHANG] CHECK CONSTRAINT [FK_TONKHOCHITIETBANHANG_CHITIETBANHANG]
GO
ALTER TABLE [dbo].[TONKHOCHITIETBANHANG]  WITH CHECK ADD  CONSTRAINT [FK_TONKHOCHITIETBANHANG_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[TONKHOCHITIETBANHANG] CHECK CONSTRAINT [FK_TONKHOCHITIETBANHANG_TONKHO]
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
ALTER TABLE [dbo].[XULYKHO]  WITH CHECK ADD  CONSTRAINT [FK_CHINHKHO_KHO] FOREIGN KEY([KhoID])
REFERENCES [dbo].[KHO] ([KhoID])
GO
ALTER TABLE [dbo].[XULYKHO] CHECK CONSTRAINT [FK_CHINHKHO_KHO]
GO
ALTER TABLE [dbo].[XULYKHO]  WITH NOCHECK ADD  CONSTRAINT [FK_CHINHKHO_NHANVIEN] FOREIGN KEY([NhanVienID])
REFERENCES [dbo].[NHANVIEN] ([NhanVienID])
GO
ALTER TABLE [dbo].[XULYKHO] CHECK CONSTRAINT [FK_CHINHKHO_NHANVIEN]
GO
ALTER TABLE [dbo].[XULYKHO]  WITH CHECK ADD  CONSTRAINT [FK_XULYKHO_XULYKHOLOAI] FOREIGN KEY([LoaiID])
REFERENCES [dbo].[XULYKHOLOAI] ([ID])
GO
ALTER TABLE [dbo].[XULYKHO] CHECK CONSTRAINT [FK_XULYKHO_XULYKHOLOAI]
GO
ALTER TABLE [dbo].[XULYKHOCHITIET]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETCHINHKHO_CHINHKHO] FOREIGN KEY([ChinhKhoID])
REFERENCES [dbo].[XULYKHO] ([ChinhKhoID])
GO
ALTER TABLE [dbo].[XULYKHOCHITIET] CHECK CONSTRAINT [FK_CHITIETCHINHKHO_CHINHKHO]
GO
ALTER TABLE [dbo].[XULYKHOCHITIET]  WITH CHECK ADD  CONSTRAINT [FK_CHITIETCHINHKHO_TONKHO] FOREIGN KEY([TonKhoID])
REFERENCES [dbo].[TONKHO] ([TonKhoID])
GO
ALTER TABLE [dbo].[XULYKHOCHITIET] CHECK CONSTRAINT [FK_CHITIETCHINHKHO_TONKHO]
GO
/****** Object:  Trigger [dbo].[TR_INSERT_LICHSUTONKHO]    Script Date: 2/6/2015 3:27:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_INSERT_LICHSUTONKHO]
ON [dbo].[LICHSUTONKHO] AFTER INSERT
As
BEGIN
	Declare @ID int
	Declare @MonID int
	Declare @KhoID int
	SELECT Top 1 @ID = ID, @MonID = MonID, @KhoID = KhoID FROM INSERTED
	Declare @DauKySoLuong int
	Declare @DauKyThanhTien Decimal(18,2)
	Declare @Gia Decimal(18,2)
	SELECT Top 1 @Gia = Gia From MENUMON Where MonID = @MonID
	SET @DauKySoLuong = 0 
	Set @DauKyThanhTien = 0
	IF EXISTS(SELECT 1 From LICHSUTONKHO Where ID < @ID And MonID = @MonID And KhoID =@KhoID)
		SELECT Top 1 @DauKySoLuong = ISNULL(CuoiKySoLuong,0), @DauKyThanhTien = ISNULL(CuoiKyThanhTien,0) From LICHSUTONKHO Where ID < @ID And MonID = @MonID And KhoID =@KhoID Order By ID DESC	
	Update LICHSUTONKHO Set DauKySoLuong = @DauKySoLuong, DauKyThanhTien = @DauKyThanhTien, CuoiKySoLuong = @DauKySoLuong + NhapSoLuong - XuatSoLuong, CuoiKyDonGia = @Gia, CuoiKyThanhTien = @Gia * (@DauKySoLuong + NhapSoLuong - XuatSoLuong) Where ID = @ID And MonID = @MonID And KhoID =@KhoID
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 là trạng thái' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TONKHOTONGLOG', @level2type=N'COLUMN',@level2name=N'TrangThai'
GO
USE [master]
GO
ALTER DATABASE [Karaoke] SET  READ_WRITE 
GO
