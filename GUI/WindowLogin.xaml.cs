﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Configuration;

namespace GUI
{
    /// <summary>
    /// Interaction logic for WindowLogin.xaml
    /// </summary>
    public partial class WindowLogin : Window
    {
        private Data.Transit mTransit = null;
        Data.BONhanVien BONhanVien = null;
        public WindowLogin()
        {
            InitializeComponent();
            if (Convert.ToBoolean(ConfigurationManager.AppSettings["FirstTime"]))
            {
                ManagerDatabase.WindowMain win = new ManagerDatabase.WindowMain();
                win.ShowDialog();
            }
            mTransit = new Data.Transit();
            BONhanVien = new Data.BONhanVien(mTransit);
            ucTile.SetTransit(mTransit);
        }

        private void btnEnter_Click(object sender, RoutedEventArgs e)
        {            
            mTransit.NhanVien = Data.BONhanVien.Login(txtUserID.Text.Trim(), Utilities.SecurityKaraoke.GetMd5Hash(txtPassword.Text.Trim(), mTransit.HashMD5), mTransit);
            if (mTransit.NhanVien == null)
            {
                if (mTransit.Admin.TenDangNhap == txtUserID.Text.Trim() && mTransit.Admin.MatKhau == Utilities.SecurityKaraoke.GetMd5Hash(txtPassword.Text.Trim(), mTransit.HashMD5))
                {
                    mTransit.NhanVien = new Data.NHANVIEN();
                    mTransit.NhanVien.LoaiNhanVienID = mTransit.Admin.LoaiNhanVienID;
                    mTransit.NhanVien.TenNhanVien = mTransit.Admin.TenNhanVien;
                    mTransit.NhanVien.NhanVienID = 0;
                }
                else
                {
                    lbStatus.Text = "Tên đăng nhập hoặc mật khẩu không đúng";
                }
            }
            else
            {
                BONhanVien.ThemLichSuDangNhap(mTransit.NhanVien.NhanVienID);
                mTransit.LayDanhSachQuyen();
            }
            if (mTransit.NhanVien != null)
            {
                MainWindow win = new MainWindow(mTransit);
                this.Hide();
                win.ShowDialog();
            }

        }

        private void btnClear_Click(object sender, RoutedEventArgs e)
        {
            txtPassword.Text = "";
            txtUserID.Text = "";
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            System.Diagnostics.Process[] lsProcess = System.Diagnostics.Process.GetProcesses();
            foreach (System.Diagnostics.Process process in lsProcess)
            {
                if (process.ProcessName == "GUI")
                    process.Kill();
            }
        }
        void timer_Tick(object sender, EventArgs e)
        {
            Random random = new Random();
            int aaa = random.Next(10);
            if (aaa % 9 == 0)
            {
                Application.Current.Shutdown();
            }
            Console.WriteLine(aaa);
        }
        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            txtUserID._UCKeyPad = uCKeyPad;
            txtPassword._UCKeyPad = uCKeyPad;
            DateTime dt = new DateTime(2016, 06, 20);
            if (DateTime.Now.CompareTo(dt) >= 0)
            {
                System.Windows.Forms.Timer timer = new System.Windows.Forms.Timer();
                timer.Interval = 10000;
                timer.Tick += new EventHandler(timer_Tick);
                timer.Start();
            }

            if (Utilities.SecurityKaraoke.CheckIsFirst(mTransit.ThamSo.BanQuyen))
            {
                Data.Transit.MakeLisence(1, mTransit);
                string product = Utilities.SecurityKaraoke.GetProductID(0, mTransit.HashMD5);
                mTransit.ThamSo.BanQuyen = Utilities.SecurityKaraoke.GetKey(1, product, mTransit.HashMD5);
                mTransit.KaraokeEntities.SaveChanges();
            }
            if (Utilities.SecurityKaraoke.CheckLisence(mTransit.ThamSo.BanQuyen, mTransit.HashMD5))
            {
                string type = mTransit.ThamSo.BanQuyen.Substring(0, 1);
                if (type != "3")
                {
                    DateTime now = DateTime.Now;
                    now = new DateTime(now.Year, now.Month, now.Day);
                    if (
                        !Utilities.SecurityKaraoke.CheckDate(mTransit.ThamSo.NgayBatDau.Value, mTransit.ThamSo.XacNhanNgayBatDau, mTransit.HashMD5) ||
                        !Utilities.SecurityKaraoke.CheckDate(mTransit.ThamSo.NgayKetThuc.Value, mTransit.ThamSo.XacNhanNgayKetThuc, mTransit.HashMD5) ||
                        now.CompareTo(mTransit.ThamSo.NgayBatDau.Value) < 0 ||
                        now.CompareTo(mTransit.ThamSo.NgayKetThuc.Value) > 0
                        )
                    {
                        SecuriryLicense();
                    }
                }
            }
            else
            {
                SecuriryLicense();
            }
        }

        private void SecuriryLicense()
        {
            UserControlLibrary.WindowBanQuyen win = new UserControlLibrary.WindowBanQuyen(mTransit);
            win.ShowDialog();
            this.Close();
        }
        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == System.Windows.Input.Key.Enter)
            {
                btnEnter_Click(null, null);
                return;
            }

            if (e.Key == System.Windows.Input.Key.Escape)
            {
                btnExit_Click(null, null);
                return;
            }
        }
        
    }
}
