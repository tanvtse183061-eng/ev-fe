import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faUser, faBars } from '@fortawesome/free-solid-svg-icons';
import { Link } from "react-router-dom";

export default function Nvar() {
  return (
    <header className="nav-container">
      {/* Logo bên trái */}
      <div className="logo">LOGO</div>

      {/* Menu ở giữa */}
      <nav className="navbar">
        <ul>
          <li><Link to="/home">Home</Link></li>
          <li><a href="#">Services</a></li>
          <li><a href="#">Products</a></li>
        </ul>
      </nav>

      {/* Actions bên phải */}
      <div className="actions">
        <Link to="/login" className="sign">SIGN IN</Link>
        <FontAwesomeIcon icon={faUser} className="icon-nav" />
      </div>

      {/* Icon menu bar (chỉ hiện ở mobile) */}
      <div className="bar">
        <FontAwesomeIcon icon={faBars} size="2x" />
      </div>
    </header>
  );
}
