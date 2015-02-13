﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Data
{
    public class BOLichSuTonKho
    {
        KaraokeEntities mKaraokeEntities = null;
        public BOLichSuTonKho()
        {
            mKaraokeEntities = new KaraokeEntities();

        }

        public IQueryable<CAIDATTHONGTINCONGTY> GetCaiDatThongTinCongTy()
        {
            return mKaraokeEntities.CAIDATTHONGTINCONGTies;
        }

        public static System.Data.Objects.ObjectResult<BAOCAOLICHSUTONKHO> GetLichSuTonKho(KaraokeEntities kara, int KhoID, DateTime dtFrom, DateTime dtTo)
        {
            var Parameter_KhoID = new System.Data.SqlClient.SqlParameter("@KhoID", System.Data.SqlDbType.Int);
            Parameter_KhoID.Value = KhoID;
            var Parameter_DateFrom = new System.Data.SqlClient.SqlParameter("@DateFrom", System.Data.SqlDbType.DateTime);
            Parameter_DateFrom.Value = dtFrom;
            var Parameter_DateTo = new System.Data.SqlClient.SqlParameter("@DateTo", System.Data.SqlDbType.DateTime);
            Parameter_DateTo.Value = dtTo;
            return kara.ExecuteStoreQuery<BAOCAOLICHSUTONKHO>("SP_BAOCAOLICHSUTONKHO @KhoID, @DateFrom, @DateTo", Parameter_KhoID, Parameter_DateFrom, Parameter_DateTo);
        }
        public System.Data.Objects.ObjectResult<BAOCAOLICHSUTONKHO> GetLichSuTonKho(int KhoID, DateTime dtFrom, DateTime dtTo)
        {
            return GetLichSuTonKho(mKaraokeEntities, KhoID, dtFrom, dtTo);
        }

        public static void NhapKho(int SoLuong, decimal ThanhTien)
        {
            //Data.LICHSUTONKHO item = new LICHSUTONKHO();
            //item.NhapSoLuong = SoLuong;
            //item.NhapThanhTien = ThanhTien;
        }
        public static void NhapKho(KaraokeEntities kara, BOChiTietNhapKho chitiet,BONhapKho nhapKho)
        {
            LICHSUTONKHO lichSuDauKy = (from a in kara.LICHSUTONKHOes
                                        where a.KichThuocMonID == chitiet.ChiTietNhapKho.KichThuocMonID
                                        orderby a.ID descending
                                        select a).FirstOrDefault();
            LICHSUTONKHO lichSu = new LICHSUTONKHO();
            if (lichSuDauKy == null)
            {
                lichSu.DauKySoLuong = 0;
                lichSu.DauKyDonGia = 0;
            }
            else
            {
                lichSu.DauKySoLuong = lichSuDauKy.CuoiKySoLuong;
                lichSu.DauKyDonGia = lichSuDauKy.CuoiKyDonGia;
            }
            lichSu.NhapSoLuong = chitiet.ChiTietNhapKho.SoLuongNhap;
            lichSu.NhapDonGia = chitiet.ChiTietNhapKho.GiaNhap;
            lichSu.CuoiKySoLuong = lichSu.DauKySoLuong + lichSu.NhapSoLuong;
            lichSu.CuoiKyDonGia = lichSu.CuoiKyDonGia;
            lichSu.NgayGhiNhan = DateTime.Now;
            lichSu.KichThuocMonID = chitiet.ChiTietNhapKho.KichThuocMonID;
            lichSu.KhoID = nhapKho.NhapKho.KhoID;
            lichSu.LoaiPhatSinhID = 1;
            kara.LICHSUTONKHOes.AddObject(lichSu);
        }
    }
}
