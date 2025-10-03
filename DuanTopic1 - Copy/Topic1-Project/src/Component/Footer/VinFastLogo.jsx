import React from 'react';

const VinFastLogo = ({ className = "", style = {} }) => {
  return (
    <div className={`vinfast-logo ${className}`} style={style}>
      <svg width="60" height="40" viewBox="0 0 60 40" fill="none">
        <text x="30" y="25" textAnchor="middle" fill="white" fontSize="14" fontWeight="bold" fontFamily="Inter, sans-serif">
          VinFast
        </text>
        <path d="M10 5 L20 25 L30 5 L40 25 L50 5" stroke="white" strokeWidth="2" fill="none"/>
      </svg>
    </div>
  );
};

export default VinFastLogo;