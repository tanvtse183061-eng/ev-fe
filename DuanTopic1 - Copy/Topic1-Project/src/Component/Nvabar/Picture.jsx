import React from "react";
import anhnen from './anhnen.png';

export default function Picture() {
    return (
        <div className="anhnen">
            <img src={anhnen} alt="Background" />
            <div className="anhnen-content">
                <h1>LỰA CHỌN XE ĐIỆN THÔNG MINH</h1>
                <p>Tiết kiệm - Êm ái - Bảo vệ môi trường</p>
                <div className="learnMore">
                    <a href="#">Learn More</a>
                </div>
            </div>
        </div>
    );
}