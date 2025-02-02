﻿using System.Windows;
using System.Windows.Input;
using System;

namespace UserControlLibrary
{
    /// <summary>
    /// Interaction logic for WindowThemMayIn.xaml
    /// </summary>
    public partial class WindowThemMayIn : Window
    {
        private Data.Transit mTransit;

        public Data.MAYIN _Item { get; set; }

        public WindowThemMayIn(Data.Transit transit)
        {
            InitializeComponent();
            mTransit = transit;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            LoadPrinter();
            SetValues();
        }

        private void btnHuy_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
        }

        private void btnLuu_Click(object sender, RoutedEventArgs e)
        {
            if (CheckValues())
            {
                if (_Item == null)
                {
                    _Item = new Data.MAYIN();
                    _Item.Visual = true;
                    _Item.Deleted = false;
                    _Item.Edit = false;
                    _Item.MayInHoaDon = false;
                }
                GetValues();
                DialogResult = true;
            }
        }

        private void SetValues()
        {
            if (_Item == null)
            {
                txtTieuDeMayIn.Text = "";
                txtSoLanIn.Text = "1";
                ckHopDungTien.IsChecked = false;
                ckChoPhepIn.IsChecked = true;
                ckMayInHoaDon.IsChecked = false;
                if (cbbTenMayIn.Items.Count > 0)
                {
                    cbbTenMayIn.SelectedIndex = 0;
                }
                btnLuu.Content = mTransit.StringButton.Them;
                lbTieuDe.Text = "Thêm Máy In";
            }
            else
            {
                txtSoLanIn.Text = _Item.SoLanIn.ToString();
                txtTieuDeMayIn.Text = _Item.TieuDeIn;
                ckHopDungTien.IsChecked = _Item.HopDungTien;
                cbbTenMayIn.SelectedItem = _Item.TenMayIn;
                ckChoPhepIn.IsChecked = _Item.Visual;
                ckMayInHoaDon.IsChecked = _Item.MayInHoaDon;
                btnLuu.Content = mTransit.StringButton.Luu;
                lbTieuDe.Text = "Sửa Máy In";
            }
        }

        private void GetValues()
        {
            _Item.TieuDeIn = txtTieuDeMayIn.Text;
            _Item.SoLanIn = System.Convert.ToInt32(txtSoLanIn.Text);
            _Item.HopDungTien = (bool)ckHopDungTien.IsChecked;
            _Item.TenMayIn = cbbTenMayIn.SelectedItem.ToString();
            _Item.Visual = (bool)ckChoPhepIn.IsChecked;
            _Item.MayInHoaDon = (bool)ckMayInHoaDon.IsChecked;
        }

        private bool CheckValues()
        {
            lbStatus.Text = "";
            if (txtTieuDeMayIn.Text == "")
            {
                lbStatus.Text = "Tiêu đề máy in không được bỏ trống";
                return false;
            }

            if (txtSoLanIn.Text == "")
                txtSoLanIn.Text = "1";
            return true;
        }

        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == System.Windows.Input.Key.Enter)
            {
                btnLuu_Click(null, null);
                return;
            }

            if (e.Key == System.Windows.Input.Key.Escape)
            {
                btnHuy_Click(null, null);
                return;
            }
        }

        private void LoadPrinter()
        {
            foreach (string s in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
            {
                cbbTenMayIn.Items.Add(s);
            }
            if (cbbTenMayIn.Items.Count > 0)
            {
                cbbTenMayIn.SelectedIndex = 0;
            }
        }

        private void txt_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            if (Char.IsNumber(e.Text, e.Text.Length - 1))
                e.Handled = false;
            else
                e.Handled = true;
        }

    }
}