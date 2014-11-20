﻿using System.Collections.Generic;
using System.Windows;

namespace GUI
{
    /// <summary>
    /// Interaction logic for WindowQuanLyNhanVien.xaml
    /// </summary>
    public partial class WindowQuanLyNhanVien : Window
    {
        private Data.BONhanVien mItem = null;
        private Data.Transit mTransit = null;
        private Data.BONhanVien BONhanVien = null;
        private List<Data.BONhanVien> lsArrayDeleted = null;

        public WindowQuanLyNhanVien(Data.Transit transit)
        {
            InitializeComponent();
            mTransit = transit;
            BONhanVien = new Data.BONhanVien(transit);
            uCTile.TenChucNang = "Quản lý nhân viên";
            uCTile.OnEventExit += new ControlLibrary.UCTile.OnExit(uCTile_OnEventExit);
            PhanQuyen();
        }

        private void PhanQuyen()
        {
            if (!mTransit.MenuGiaoDien.NhanVien.QuanLyNhanVien)
            {
                btnNhanVien.Visibility = System.Windows.Visibility.Collapsed;
            }
        }

        private UserControlLibrary.UCNhanVien ucNhanVien = null;

        private void uCTile_OnEventExit()
        {
            this.Close();
        }

        private void btnNhanVien_Click(object sender, RoutedEventArgs e)
        {
            if (ucNhanVien == null)
            {
                ucNhanVien = new UserControlLibrary.UCNhanVien(mTransit);
            }
            spNoiDung.Children.Clear();
            spNoiDung.Children.Add(ucNhanVien);
        }

        private void Window_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (spNoiDung.Children[0] is UserControlLibrary.UCQuyen)
                ucNhanVien.Window_KeyDown(sender, e);
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            btnNhanVien_Click(null, null);
        }
    }
}