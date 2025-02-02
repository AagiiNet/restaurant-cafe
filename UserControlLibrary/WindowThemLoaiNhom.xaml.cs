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

namespace UserControlLibrary
{
    /// <summary>
    /// Interaction logic for WindowThemLoaiNhom.xaml
    /// </summary>
    public partial class WindowThemLoaiNhom : Window
    {
        private Data.Transit mTransit;

        public Data.MENULOAINHOM _Item { get; set; }

        public WindowThemLoaiNhom(Data.Transit transit)
        {
            InitializeComponent();
            mTransit = transit;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
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
                    _Item = new Data.MENULOAINHOM();
                    _Item.Visual = true;
                    _Item.Deleted = false;
                    _Item.Edit = false;

                }
                GetValues();
                DialogResult = true;
            }
        }

        private void SetValues()
        {
            if (_Item == null)
            {
                txtTenLoaiNhom.Text = "";
                btnLuu.Content = mTransit.StringButton.Them;
                lbTieuDe.Text = "Thêm loại nhóm";
            }
            else
            {
                txtTenLoaiNhom.Text = _Item.TenLoaiNhom;
                btnLuu.Content = mTransit.StringButton.Luu;
                lbTieuDe.Text = "Sửa loại nhóm";
            }
        }

        private void GetValues()
        {
            _Item.TenLoaiNhom = txtTenLoaiNhom.Text;
        }

        private bool CheckValues()
        {
            lbStatus.Text = "";
            if (txtTenLoaiNhom.Text == "")
            {
                lbStatus.Text = "Tên loại nhóm không được bỏ trống";
                return false;
            }
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

        private void txt_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            if (Char.IsNumber(e.Text, e.Text.Length - 1))
                e.Handled = false;
            else
                e.Handled = true;
        }
    }
}
