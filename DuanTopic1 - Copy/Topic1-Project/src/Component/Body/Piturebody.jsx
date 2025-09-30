import anhnenherio from './herio.png';
import anhnenlimo from './limo.png';
import anhnenvf6_xanh_duong from  './vf6_xanh_duong.png';

export default function body(){
    return(
        <div className="body">
            <div className='te'>
                <a> CÁC DÒNG XE HOT TẠI EVM CAR</a>
            </div>
            <div className='car-body'> 
                <div className='herio'>
              <img src={anhnenherio} />  
              <p className='name-car'>Herio Green</p>
                    <p className='price-car'>GIÁ TỪ 499,000,000 ₫ </p>
            </div>
            <div className='limo'>
                  <img src={anhnenlimo}/>
                     <p className='name-car'>Limo Green</p>
                    <p className='price-car'>GIÁ TỪ 749,000,000 ₫ </p>
            </div>
                 <div className='vf6'>
                    <img src={anhnenvf6_xanh_duong}/>
                    <p className='name-car'>VinFast VF 6</p>
                    <p className='price-car'>GIÁ TỪ 689,000,000 ₫ </p>
                      </div>
            </div>
            
            
            
        </div>
    )
}