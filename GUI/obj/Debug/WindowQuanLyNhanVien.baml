   M S B A M L   `   `   `  ����I  EControlLibrary, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullG4clr-namespace:ControlLibrary;assembly=ControlLibraryControlLibrary  5   	    GUI   GUI.WindowQuanLyNhanVien   ;my4clr-namespace:ControlLibrary;assembly=ControlLibrary  W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   -   5          � Title$  WindowQuanLyNhanVien��5   	   $	��768��6&   $
��1024��63   .��5      �  � ColumnDefinitions 5   
   �� 5      $	��10* �6   �� 5      $	��20* �6   �� 5	      $	��10* �6    � RowDefinitions 5   
   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $��40 �6   �� 5      $	��40* �6   �� 5      $��40 �6   .+�5   
   �� $��0��6   $��0��6!   $��Tên nhân viên��61   $��Stretch=�6F   $��Center=�6d   $��	10,0,10,0q�6   $��18(�6�   $
��Wrap=�6�   �� 5   
   -   5         ��Name$ txtTenNhanVien��5   0   $��0��6   $��1��6   $��Stretch=�6H   $��Stretch=�6f   $��5q�6�   $��18(�6�   �� 5   
   $��1��6   $��0��6!   $��Loại nhân viên��61   $��Stretch=�6G   $��Center=�6e   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   �� 5   
   -   5         ��Name$ cbbLoaiNhanVien��5   0   $��1��6   $��1��6     �� DisplayMemberPath$ TenLoaiNhanVien��6I    �� SelectedValuePath$ LoaiNhanVienID��6m   $��Stretch=�6�   $��Stretch=�6�   $��5q�6�   $��18(�6�   �� 5   
   $��2��6   $��0��6!   $��Tên đang nhập��61   $��Stretch=�6F   $��Center=�6d   $��	10,0,10,0q�6   $��18(�6�   $
��Wrap=�6�   �� 5   
   -   5        $ txtTenDangNhap��5   0   $��2��6   $��1��6   $��Stretch=�6H   $��Stretch=�6f   $��5q�6�   $��18(�6�   �� 5   
   $��3��6   $��0��6!   $��Mật khẩu��61   $��Stretch=�6A   $��Center=�6_   $��	10,0,10,0q�6z   $��18(�6�   $
��Wrap=�6�   G� 5   
   -   5         G�Name$ 
txtMatKhau��5   4   $��3��6   $��1��6#   $��Stretch=�6H   $��Stretch=�6f   $��5q�6�   $��18(�6�   �� 5   
   -   5        $��lbStatus��5   M   $��4��6   $��0��6!   $��2��61   $�� ��6E   $��Center=�6]   $��Center=�6z   $��	10,0,10,0q�6�   $��18(�6�   $
��Wrap=�6�   
���  ��6�   ,   &ControlLibrary.POSButtonIconHorizontal  5   
   -   5        $��btnMoi��5   B   $��0��6%   $��2��62   $��Tạo mới��6P   $��Stretch=�6b   $��Stretch=�6�   $��2,2,2,2q�6�   $��18(�6�   6�     5   
   -   5        $��btnThem��5   B   $��1��6%   $��2��62   $��Thêm mới��6Q   $��Stretch=�6d   $��Stretch=�6�   $��2,2,2,2q�6�   $��18(�6�      Image$' !/GUI;component/Images/Add%202.png��6�     5    
   -	   5        $��btnXoa��5    B   $��2��6%   $��2��62   $
��Xóa��6P   $��Stretch=�6^   $��Stretch=�6|   $��2,2,2,2q�6�   $��18(�6�   $&  /GUI;component/Images/Delete.png��6�   �� 5"   
   -
   5        $��
lvNhanVien��5"   D   $��5��6   $��0��6    $��3��60   	 �� View	 5#      �� 5$      
 �� AllowsColumnReorder
 .  �� ColumnHeaderToolTip$ Employee Information��66   .P�5%      ��  �� Width$	 200��6W   $��Tên nhân viên��6c    �� DisplayMemberBinding 6%   ��  �� Path$ TenNhanVien�6c   �� 5&      $	 200��6h   $��Loại nhân viên��6t    6%   �� $" LOAINHANVIEN.TenLoaiNhanVien�6t   �� 5'      $	 200��6W   $��Tên đăng nhập��6c    6%   �� $ TenDangNhap�6c   5(      5*        5+   
   -   5        $��btnThoat��5+   2   $��6��6%   $��Trở lại��6B   $
��Left=�6T   $��Stretch=�6o   $��2,2,2,2q�6�   $	��150��6�   $��18(�6�      POSButtonTroVe#��[  6�   5-      5.      