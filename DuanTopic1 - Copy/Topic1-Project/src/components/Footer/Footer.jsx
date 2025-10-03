import React from 'react';
import './Footer.css';
import VinFastLogo from './VinFastLogo';

const Footer = () => {
  return (
    <footer className="footer">
      <div className="footer-container">
        {/* Cột 1: Các dòng sản phẩm */}
        <div className="footer-column">
          <h3>CÁC DÒNG SẢN PHẨM</h3>
          <ul>
            <li><a href="#">VinFast VF e34</a></li>
            <li><a href="#">Minio Green</a></li>
            <li><a href="#">VinFast VF 3</a></li>
            <li><a href="#">Herio Green</a></li>
            <li><a href="#">VinFast VF 5</a></li>
            <li><a href="#">Norio Green</a></li>
            <li><a href="#">VinFast VF 6</a></li>
            <li><a href="#">Limo Green</a></li>
            <li><a href="#">VinFast VF 7</a></li>
            <li><a href="#">VinFast VF 8</a></li>
            <li><a href="#">VinFast VF 9</a></li>
          </ul>
        </div>

        {/* Cột 2: Hỗ trợ mua xe */}
        <div className="footer-column">
          <h3>HỖ TRỢ MUA XE</h3>
          <ul>
            <li><a href="#">Bảng giá</a></li>
            <li><a href="#">Dự toán</a></li>
            <li><a href="#">Lái thử</a></li>
            <li><a href="#">Khuyến mãi</a></li>
          </ul>
        </div>

        {/* Cột 3: Dịch vụ khách hàng */}
        <div className="footer-column">
          <h3>DỊCH VỤ KHÁCH HÀNG</h3>
          <ul>
            <li><a href="#">Chính sách bảo hành</a></li>
            <li><a href="#">Bảo dường định kỳ</a></li>
            <li><a href="#">Dịch vụ sửa chữa</a></li>
          </ul>
        </div>

        {/* Cột 4: Thông tin liên hệ */}
        <div className="footer-column">
          <h3>VINFAST HỒ CHÍ MINH</h3>
          <div className="contact-info">
            <p>Địa chỉ: Tầng L1, TTTM Vincom Mega Mall Thảo Điền, 159 Võ Nguyên Giáp, Thảo Điền, Thủ Đức, Hồ Chí Minh</p>
            <p>Điện thoại: 089 996 4545</p>
            <p>Hotline: 089 996 4545</p>
            <p>Email: vinfast.auto.hcm@gmail.com</p>
          </div>
        </div>
      </div>

      {/* Logo và thông tin bản quyền */}
      <div className="footer-bottom">
        <div className="footer-logo">
          <VinFastLogo />
        </div>
        <div className="footer-info">
          <p>© 2025 vinfasthochiminhcity.com Powered by Oto360.net</p>
          <div className="stats">
            <span>Tổng truy cập: 85167</span>
            <span>30 ngày qua: 5776</span>
            <span>7 ngày qua: 1796</span>
            <span>Hôm qua: 343</span>
            <span>Hôm nay: 134</span>
          </div>
        </div>
        
        {/* Nút cuộc gọi */}
        <div className="call-button">
          <a href="tel:0899964545">
            📞 089 996 4545
          </a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;