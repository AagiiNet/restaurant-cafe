   M S B A M L   `   `   `  ����I  EControlLibrary, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullG4clr-namespace:ControlLibrary;assembly=ControlLibraryControlLibrary  5       UserControlLibrary(   "UserControlLibrary.UCLoaiKhachHang   ;my4clr-namespace:ControlLibrary;assembly=ControlLibrary  W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5      R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      -   5        .��5      �   � RowDefinitions  5	   
   �� 5
      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $	��40* �6    � ColumnDefinitions 5   
   �� 5      $	��10* �6   �� 5      $	��10* �6   �� 5      $	��10* �6   .+�5   
   �� $��0��6   $��0��6!   $��Loại khách hàng��61   $��Stretch=�6H   $��Center=�6f   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   �� 5   
   $��1��6   $��0��6!   $��Phần trăm giảm��61   $��Stretch=�6G   $��Center=�6e   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   �� 5   
   -   5         ��Name$ txtLoaiKhachHang��5   /   $��0��6   $��1��6   $��Stretch=�6I   $��Stretch=�6g   $��5q�6�   $��18(�6�   �� 5   
   -   5        $ txtPhanTramGiam��5   /   $��1��6   $��1��6   $��Stretch=�6H   $��Stretch=�6f   $��5q�6�   $��18(�6�   �� 5   
   -   5        $��lbStatus��5   M   $��3��6   $��0��6!   $��2��61   $�� ��6E   $��Center=�6]   $��Center=�6z   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   
���  ��6�   ,   &ControlLibrary.POSButtonIconHorizontal  5   
   -   5        $��btnMoi��5   B   $��0��6%   $��2��62   $��Tạo mới��6P   $��Stretch=�6b   $��Stretch=�6�   $��2,2,2,2q�6�   $��18(�6�   6�     5   
   -   5        $��btnThem��5   B   $��1��6%   $��2��62   $��Thêm mới��6Q   $��Stretch=�6d   $��Stretch=�6�   $��2,2,2,2q�6�   $��18(�6�      Image$' !/GUI;component/Images/Add%202.png��6�     5   
   -   5        $��btnXoa��5   B   $��2��6%   $��2��62   $
��Xóa��6P   $��Stretch=�6^   $��Stretch=�6|   $��2,2,2,2q�6�   $��18(�6�   $&  /GUI;component/Images/Delete.png��6�   �� 5"   
   -   5        $��lvData��5"   D   $��4��6   $��0��6    $��3��60    �� View 5#      �� 5$       �� AllowsColumnReorder .  �� ColumnHeaderToolTip$ Employee Information��66   .P�5%      ��  �� Width$	 200��6O   $��Loại khách hàng��6[    �� DisplayMemberBinding 6%   �� 	 �� Path$		 Ten�6[   �� 5&      $	 500��6T   $��Phần trăm giảm��6`    6%   �� $	 DienGiai�6`   5'      5)      5*      5+      