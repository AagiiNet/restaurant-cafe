﻿using System.Windows;
using System.Windows.Controls;
using System;

namespace Report
{
    /// <summary>
    /// Interaction logic for UCTileReport.xaml
    /// </summary>
    public partial class UCTileReport : UserControl
    {
        private Microsoft.Reporting.WinForms.ReportViewer mReportViewer = null;

        private Data.Transit mTransit = null;

        public string Title { get; set; }

        public bool Landscape { get; set; }

        public DateTime GetDate { get { return dtpChonNgay.SelectedDate != null ? (DateTime)dtpChonNgay.SelectedDate : DateTime.Now; } }

        public UCTileReport()
        {
            InitializeComponent();
            Title = "";
        }
        public delegate void OnReload();
        public event OnReload _OnReload;
        public delegate void OnDong();
        public event OnDong _OnDong;

        public void SetInit(Data.Transit transit, Microsoft.Reporting.WinForms.ReportViewer reportViewer, string title, bool IsShowDate)
        {
            dtpChonNgay.Visibility = IsShowDate ? Visibility.Visible : System.Windows.Visibility.Collapsed;
            mReportViewer = reportViewer;
            Title = title;
            mTransit = transit;
        }
        private void btnBack_Click(object sender, RoutedEventArgs e)
        {
            if (mReportViewer.CurrentPage > 1)
            {
                mReportViewer.CurrentPage--;
                lbPage.Content = mReportViewer.CurrentPage + "/" + mReportViewer.GetTotalPages();
            }
        }

        private void btnDong_Click(object sender, RoutedEventArgs e)
        {
            if (_OnDong != null)
            {
                _OnDong();
            }
        }

        private void btnForward_Click(object sender, RoutedEventArgs e)
        {
            if (mReportViewer.CurrentPage < mReportViewer.GetTotalPages())
            {
                mReportViewer.CurrentPage++;
                lbPage.Content = mReportViewer.CurrentPage + "/" + mReportViewer.GetTotalPages();
            }
        }

        private void btnPDF_Click(object sender, RoutedEventArgs e)
        {
            mReportViewer.LocalReport.DisplayName = Title + " " + DateTime.Now.ToString("yyyy-MM-dd HHmmss");
            System.Drawing.Printing.PageSettings pg = mReportViewer.GetPageSettings();
            pg.Margins = new System.Drawing.Printing.Margins(0, 0, 0, 0);
            pg.PaperSize.RawKind = (int)System.Drawing.Printing.PaperKind.A4;
            pg.Landscape = Landscape;            
            //0: EXCEL, 1:IMAGE, 2:PDF, 3: WORD
            mReportViewer.ExportDialog(mReportViewer.LocalReport.ListRenderingExtensions()[2]);

        }

        private void btnPrint_Click(object sender, RoutedEventArgs e)
        {
            mReportViewer.LocalReport.DisplayName = Title + " " + DateTime.Now.ToString("yyyy-MM-dd HHmmss");
            mReportViewer.PrinterSettings.DefaultPageSettings.PaperSize.RawKind = (int)System.Drawing.Printing.PaperKind.A4;
            mReportViewer.PrinterSettings.DefaultPageSettings.Margins = new System.Drawing.Printing.Margins(50, 50, 50, 50);
            mReportViewer.PrinterSettings.DefaultPageSettings.Landscape = Landscape;
            mReportViewer.PrintDialog();
        }
        private void dtpChonNgay_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (_OnReload != null)
            {
                _OnReload();
            }
        }

        public void ReloadPage()
        {
            lbPage.Content = mReportViewer.CurrentPage + "/" + mReportViewer.GetTotalPages();
        }
    }
}