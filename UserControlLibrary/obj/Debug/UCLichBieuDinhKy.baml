   M S B A M L   `   `   `  ����I  EControlLibrary, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullG4clr-namespace:ControlLibrary;assembly=ControlLibraryControlLibrary  5       UserControlLibrary)   #UserControlLibrary.UCLichBieuDinhKy   ;my4clr-namespace:ControlLibrary;assembly=ControlLibrary  W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5      R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      -   5        .��5      �   � RowDefinitions  5	   
   �� 5
      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $	��40* �6    � ColumnDefinitions 5   
   �� 5      $	��10* �6   �� 5      $	��10* �6   �� 5      $	��10* �6   .+�5   
   �� $��0��6   $��0��6!   $��Tên lịch biểu��61   $��Stretch=�6F   $��Center=�6d   $��	10,0,10,0q�6   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��1��6   $��0��6!   $��Loại giá��61   $��Stretch=�6A   $��Center=�6_   $��	10,0,10,0q�6z   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��2��6   $��0��6!   $��Giờ bắt đầu��61   $��Stretch=�6D   $��Center=�6b   $��	10,0,10,0q�6}   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��3��6   $��0��6!   $��Giờ kết thúc��61   $��Stretch=�6E   $��Center=�6c   $��	10,0,10,0q�6~   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��4��6   $��0��6!   $��	Ưu tiên��61   $��Stretch=�6@   $��Center=�6^   $��	10,0,10,0q�6y   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��5��6   $��0��6!   $'��!Loại lịch biểu bắt đầu��61   $��Stretch=�6O   $��Center=�6m   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��6��6   $��0��6!   $&�� Loại lịch biểu kết thúc��61   $��Stretch=�6P   $��Center=�6n   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   �� 5!   
   -   5         ��Name$ txtTenLichBieu��5!   /   $��0��6   $��1��6   $��Stretch=�6G   $��Stretch=�6e   $��5q�6�   $��18(�6�   �� 5"   
   -   5         ��Name$ 
cbbLoaiGia��5"   0   $��1��6   $��1��6     �� DisplayMemberPath$ TenLoaiNhanVien��6D    �� SelectedValuePath$ LoaiNhanVienID��6h   $��Stretch=�6�   $��Stretch=�6�   $��5q�6�   $��18(�6�   �� 5#   
   -   5        $ txtGioBatDau��5#   /   $��2��6   $��1��6   $��Stretch=�6E   $��Stretch=�6c   $��5q�6   $��18(�6�   �� 5$   
   -   5        $ txtGioKetThuc��5$   /   $��3��6   $��1��6   $��Stretch=�6F   $��Stretch=�6d   $��5q�6�   $��18(�6�   �� 5%   
   -   5        $ 	txtUuTien��5%   /   $��4��6   $��1��6   $��Stretch=�6B   $��Stretch=�6`   $��5q�6|   $��18(�6�   �� 5&   
   -   5        $ cbbLoaiLichBieuBatDau��5&   0   $��1��6   $��1��6    $ TenLoaiNhanVien��6O   $ LoaiNhanVienID��6s   $��Stretch=�6�   $��Stretch=�6�   $��5q�6�   $��18(�6�   �� 5'   
   -   5        $ cbbLoaiLichBieuKetThuc��5'   0   $��1��6   $��1��6    $ TenLoaiNhanVien��6P   $ LoaiNhanVienID��6t   $��Stretch=�6�   $��Stretch=�6�   $��5q�6�   $��18(�6�   �� 5)   
   -	   5        $��lbStatus��5)   M   $��7��6   $��0��6!   $��2��61   $�� ��6E   $��Center=�6]   $��Center=�6z   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   
���  ��6�   ,   &ControlLibrary.POSButtonIconHorizontal  5+   
   -
   5          Name$ btnMoi��5+   B   $��0��6%   $��2��62   $��Tạo mới��6R   $��Stretch=�6d   $��Stretch=�6�   $��2,2,2,2q�6�   $��18(�6�   6�     5,   
   -   5        $ btnThem��5,   B   $��1��6%   $��2��62   $��Thêm mới��6S   $��Stretch=�6f   $��Stretch=�6�   $��2,2,2,2q�6�   $��18(�6�      Image$' !/GUI;component/Images/Add%202.png��6�     5-   
   -   5        $ btnXoa��5-   B   $��2��6%   $��2��62   $
��Xóa��6R   $��Stretch=�6`   $��Stretch=�6~   $��2,2,2,2q�6�   $��18(�6�   $&  /GUI;component/Images/Delete.png��6�   �� 50   
   -   5        $��lvData��50   D   $��8��6   $��0��6    $��3��60    �� View 51      �� 52      	 �� AllowsColumnReorder	 . 
 �� ColumnHeaderToolTip$
 Employee Information��66   .P�53      ��  �� Width$
 Auto��6O   $��Tên lịch biểu��6\    �� DisplayMemberBinding 6%   ��  �� Path$	 Ten�6\   �� 54      $
 Auto��6T   $��Loại giá��6a    6%   �� $ DienGiai�6a   �� 55      $
 Auto��6T   $��Giờ bắt đầu��6a    6%   �� $ DienGiai�6a   �� 56      $
 Auto��6T   $��Giờ kết thúc��6a    6%   �� $ DienGiai�6a   �� 57      $
 Auto��6T   $��	Ưu tiên��6a    6%   �� $ DienGiai�6a   �� 58      $
 Auto��6T   $'��!Loại lịch biểu bắt đầu��6a    6%   �� $ DienGiai�6a   �� 59      $
 Auto��6T   $&�� Loại lịch biểu kết thúc��6a    6%   �� $ DienGiai�6a   5:      5<      5=      5>      