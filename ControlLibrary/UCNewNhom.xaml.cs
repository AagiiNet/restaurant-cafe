﻿using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

namespace ControlLibrary
{
    /// <summary>
    /// Interaction logic for UCNewNhom.xaml
    /// </summary>
    public partial class UCNewNhom : UserControl
    {
        private int LoaiNhomID = 0;
        private Data.Transit mTransit = null;
        private BitmapImage mBitmapImage = null;

        public UCNewNhom(int loaiNhomID, Data.Transit transit)
        {
            InitializeComponent();
            LoaiNhomID = loaiNhomID;
            mTransit = transit;
            btnHinhAnh._OnBitmapImageChanged += new POSButtonImage.EventBitmapImage(btnHinhAnh__OnBitmapImageChanged);
        }

        private void btnHinhAnh__OnBitmapImageChanged(object sender)
        {
            mBitmapImage = btnHinhAnh.ImageBitmap;
        }

        public Data.MENUNHOM _Nhom { get; set; }

        public void CapNhat()
        {
            if (_Nhom != null)
            {
                GetData();
                Data.BOMenuNhom.CapNhat(_Nhom, mTransit);
            }
            else
            {
                GetData();
                Data.BOMenuNhom.Them(_Nhom, mTransit);
            }
        }

        public void GetData()
        {
            if (_Nhom == null)
            {
                _Nhom = new Data.MENUNHOM();
                _Nhom.Deleted = false;
                _Nhom.Visual = true;
                _Nhom.MayIn = 0;
                _Nhom.GiamGia = 0;
                _Nhom.LoaiNhomID = LoaiNhomID;
            }
            if (mBitmapImage != null)
            {
                _Nhom.Hinh = Utilities.ImageHandler.ImageToByte(btnHinhAnh.ImageBitmap);
            }
            _Nhom.TenDai = txtTenDai.Text;
            _Nhom.TenNgan = txtTenNgan.Text;
            if (txtSapXep.Text == "")
                _Nhom.SapXep = 0;
            else
                _Nhom.SapXep = Convert.ToInt32(txtSapXep.Text.Trim());
        }

        public void Xoa()
        {
            Data.BOMenuNhom.Xoa(_Nhom.NhomID, mTransit);
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            if (_Nhom != null)
            {
                txtTenDai.Text = _Nhom.TenDai;
                txtTenNgan.Text = _Nhom.TenNgan;
                txtSapXep.Text = _Nhom.SapXep.ToString();
                if (_Nhom.Hinh != null && _Nhom.Hinh.Length > 0)
                {
                    mBitmapImage = Utilities.ImageHandler.BitmapImageFromByteArray(_Nhom.Hinh);                    
                    btnHinhAnh.Image = mBitmapImage;
                }
            }
            else
            {
                txtTenDai.Text = "";
                txtTenNgan.Text = "";
                txtSapXep.Text = "";
            }
        }

        private void btnHinhAnh_Click(object sender, RoutedEventArgs e)
        {
            Stream checkStream = null;
            Microsoft.Win32.OpenFileDialog openFileDialog = new Microsoft.Win32.OpenFileDialog();
            openFileDialog.Multiselect = false;
            openFileDialog.InitialDirectory = "c:\\";
            openFileDialog.Filter = "All Image Files | *.*";
            if ((bool)openFileDialog.ShowDialog())
            {
                if ((checkStream = openFileDialog.OpenFile()) != null)
                {
                    Stream fs = File.OpenRead(openFileDialog.FileName);
                    mBitmapImage = new BitmapImage();
                    mBitmapImage.BeginInit();
                    mBitmapImage.CacheOption = BitmapCacheOption.OnLoad;
                    mBitmapImage.StreamSource = fs;
                    mBitmapImage.EndInit();
                }
            }
        }

        private void btnMauNen_Click(object sender, RoutedEventArgs e)
        {
        }
    }
}