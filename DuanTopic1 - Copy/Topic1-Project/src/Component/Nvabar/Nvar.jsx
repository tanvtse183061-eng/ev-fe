import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faUser } from '@fortawesome/free-solid-svg-icons'
import { faBars } from '@fortawesome/free-solid-svg-icons';
import { Link } from "react-router-dom";
export default function Nvar() {
    return (
        
        <div className="nav-container">
              
           <nav className="navbar">
              
            <ul>
                <li><Link to="/home">Home</Link></li>
                <li><a herf="#">Services</a></li>
                <li><a herf="#">Products</a></li>
            </ul>
                <Link to="/login">
                <button className='sign'>
                    SIGN IN
                </button>
                </Link>
                <div className="Icon-nav">
                    <FontAwesomeIcon icon={faUser} />
                </div>
                   
           </nav>
             <div className='bar'> <FontAwesomeIcon icon={faBars} size="2x" /></div>
        </div>
        
    )
}