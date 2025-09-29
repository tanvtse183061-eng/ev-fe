import React from "react";
import anhnen from './anhnen.png';

export default function Picture() {
    return (
        <div className="anhnen">
            <img src={anhnen} alt="Background" />
            <div className="anhnen-content">
                <h1>TRADE IN YOUR CAR</h1>
                <p>Instant hassle free appraisal</p>
                <div className="learnMore">
                    <a href="#">Learn More</a>
                </div>
            </div>
        </div>
    );
}