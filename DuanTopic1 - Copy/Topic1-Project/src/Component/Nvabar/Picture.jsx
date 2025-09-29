import React from "react";
import anhnen from './anhnen.png';

export default function Picture() {
    return (
        <div className="anhnen">
            <div className="anhnen-content">
            <h1>TRADE IN YOUR CAR</h1>
            <p>Instant hassle free appraisal</p>
           </div>
           <img src={anhnen} alt="Background" />
           <button className="learnMore"><a>Learn More</a></button>
        </div>
    );
}