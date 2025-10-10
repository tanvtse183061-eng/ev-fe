import anhnenherio from '../../assets/cars/herio.png';
import anhnenlimo from '../../assets/cars/limo.png';
import anhnenvf6_xanh_duong from '../../assets/cars/vf6_xanh_duong.png';
import anhnenminio from '../../assets/cars/minio.png';
import vf3_vang from '../../assets/cars/vf3_vang.png';
import vf7_xam from '../../assets/cars/vf7_xam.png';
import Macanxanh from '../../assets/cars/Macanxanh.png';
import Macantim4 from '../../assets/cars/Macantim4.png';
import './CarSection.css';

export default function CarSection() {
    return (
        <div className="body">
            <div className='te'>
                <a>CÁC DÒNG XE HOT TẠI EVM CAR</a>
            </div>
            
            <div className='car-body'> 
                <div className='herio'>
                    <img src={anhnenherio} alt="Herio Green" />  
                    <p className='name-car'>Herio Green</p>
                    <p className='price-car'>GIÁ TỪ 499,000,000 ₫</p>
                </div>
                <div className='limo'>
                    <img src={anhnenlimo} alt="Limo Green" />
                    <p className='name-car'>Limo Green</p>
                    <p className='price-car'>GIÁ TỪ 749,000,000 ₫</p>
                </div>
                <div className='vf6'>
                    <img src={anhnenvf6_xanh_duong} alt="VinFast VF 6" />
                    <p className='name-car'>VinFast VF 6</p>
                    <p className='price-car'>GIÁ TỪ 689,000,000 ₫</p>
                </div>
            </div>
            
            <div className='car-body2'>
                <div className='minio'>
                    <img src={anhnenminio} alt="Minio Green" />
                    <p className='name-car'>Minio Green</p>
                    <p className='price-car'>GIÁ TỪ 269,000,000 ₫</p>
                </div>
                <div className='vf7'>
                    <img src={vf7_xam} alt="VinFast VF 7" />
                    <p className='name-car'>VinFast VF 7</p>
                    <p className='price-car'>GIÁ TỪ 799,000,000 ₫</p>
                </div> 
                <div className='vf3'>
                    <img src={vf3_vang} alt="VinFast VF 3" />
                    <p className='name-car'>VinFast VF 3</p>
                    <p className='price-car'>GIÁ TỪ 269,000,000 ₫</p>
                </div>     
            </div>
            
            <div className='car-body3'>
                <div className='macanxanh'>
                    <img src={Macanxanh} alt="Macan thuần điện" />
                    <p className='name-car'>Macan thuần điện</p>
                    <p className='price-car'>3.590.000.000 ₫</p>
                </div>
                <div className='macantim4'>
                    <img src={Macantim4} alt="Macan 4 thuần điện" />
                    <p className='name-car'>Macan 4 thuần điện</p>
                    <p className='price-car'>3.740.000.000 ₫</p>
                </div>
            </div>
        </div>
    );
}