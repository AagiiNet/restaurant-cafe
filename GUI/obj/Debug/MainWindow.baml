   M S B A M L   `   `   `  ����I  EControlLibrary, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullG4clr-namespace:ControlLibrary;assembly=ControlLibraryControlLibrary  5   	    GUI   GUI.MainWindow   ;my4clr-namespace:ControlLibrary;assembly=ControlLibrary  W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	     � Title$  
MainWindow��5   	   $	��768��6   $
��1024��6)    � Icon$ /GUI;component/Micro.ico��66   .��5      �  � RowDefinitions 5   
   �� 5      $��30 �6   �� 5      $	��10* �6   �� 5	      $	��10* �6   �� 5
      $	��10* �6   �� 5      $	��10* �6    � ColumnDefinitions 5   
   �� 5      $	��10* �6   �� 5      $	��10* �6   �� 5      $	��10* �6   �� 5      $	��10* �6   .+�5   
      ControlLibrary.UCTile  $��0��6   $��0��6!   $��4��61   *   $ControlLibrary.POSButtonIconVertical  5   
   -   5        $��
btnBanHang��5   6   $��
Bán Hàng��6#   $��0��6H   $��1��6X   $��Stretch=�6e   $��Stretch=�6�      Image$% /GUI;component/Images/Tests.png��6�   $��24(�6�   $��10q�6�      ImageHeight$ 64Q�6�      
ImageWidth$ 64Q�6�   
�������6    5   
   -   5        $��btnQuanLyNhanVien��5   ?   $��Quản Lý Nhân Viên��6#   $��1��6X   $��1��6h   $��Stretch=�6u   $��Stretch=�6�   $# /GUI;component/Images/man.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6   
�������6#    5   
   -   5        $��btnQuanLyMayIn��5   <   $��Quản Lý Máy In��6#   $��2��6R   $��1��6b   $��Stretch=�6o   $��Stretch=�6�   $/ )/GUI;component/Images/printer%20green.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6)    5   
   -   5        $��btnQuanLyThucDon��5   >   $��Quản Lý Thực Đơn��6#   $��3��6V   $��1��6f   $��Stretch=�6s   $��Stretch=�6�   $' !/GUI;component/Images/Catalog.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6%    5   
   -   5        $��btnQuanLyKhachHang��5   @   $��Quản Lý Khách Hàng��6#   $��0��6Z   $��2��6j   $��Stretch=�6w   $��Stretch=�6�   $&  /GUI;component/Images/Family.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6(    5   
   -   5        $��btnQuanLyThuChi��5   =   $��Quản Lý Thu Chi��6#   $��1��6T   $��2��6d   $��Stretch=�6q   $��Stretch=�6�   $+ %/GUI;component/Images/us%20dollar.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6'    5   
   -   5        $��btnQuanLyGiaKhuyenMai��5   E   $$��Quản Lý Giá, Khuyến Mãi��6#   $��2��6b   $��2��6r   $��Stretch=�6   $��Stretch=�6�   $. (/GUI;component/Images/Sales%20report.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6  $ 64Q�6  
�������68    5   
   -   5        $��btnQuanLyPhanQuyen��5   @   $��Quản Lý Phân Quyền��6#   $��3��6Z   $��2��6j   $��Stretch=�6w   $��Stretch=�6�   $&  /GUI;component/Images/Themes.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6(    5   
   -	   5        $��btnQuanLyKhoHang��5   >   $��Quản Lý Kho Hàng��6#   $��0��6V   $��3��6f   $��Stretch=�6s   $��Stretch=�6�   $* $/GUI;component/Images/uncompress.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6(    5   
   -
   5        $��btnQuanLyDinhLuong��5   @   $!��Quản Lý Định Lượng��6#   $��1��6Z   $��3��6j   $��Stretch=�6w   $��Stretch=�6�   $- '/GUI;component/Images/Binary%20tree.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6/    5   
   -   5        $��btnQuanSoDoBan��5   ?   $��Quản Lý Sơ Đồ Bàn��6#   $��2��6U   $��3��6e   $��Stretch=�6r   $��Stretch=�6�   $? 9/GUI;component/Images/question%20type%20one%20correct.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6  $ 64Q�6  
�������6<    5   
   -   5        $��btnBaoCaoThongKe��5   >   $��Báo Cáo Thống Kê��6#   $��3��6V   $��3��6f   $��Stretch=�6s   $��Stretch=�6�   $&  /GUI;component/Images/Report.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6$    5    
   -   5        $��btnThongTinCongTy��5    ?   $��Thông Tin Công Ty��6#   $��0��6X   $��4��6h   $��Stretch=�6u   $��Stretch=�6�   $$ /GUI;component/Images/Info.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6$    5!   
   -   5        $��btnThongTinPhanMem��5!   @   $��Thông Tin Phần Mềm��6#   $��3��6Z   $��4��6j   $��Stretch=�6w   $��Stretch=�6�   $$ /GUI;component/Images/Unit.png��6�   $��24(�6�   $��10q�6�   $ 64Q�6�   $ 64Q�6  
�������6&  5"      5#      