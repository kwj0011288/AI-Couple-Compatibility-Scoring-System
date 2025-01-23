import React from "react";
import fullHeart from "../../assets/heart/full_heart.png";
import halfHeart from "../../assets/heart/half_heart.png";
import brokenHeart from "../../assets/heart/broken_heart.png";
import MadFace from "../../assets/illustrations/man_mad.png";

interface CouplePhotosProps {
  photo1: string | null; // Allow null for handling empty network URLs
  photo2: string | null;
  score: number;
}

const CouplePhotos: React.FC<CouplePhotosProps> = ({ photo1, photo2, score }) => {
  const getImageAsset = (score: number) => {
    if (score >= 7) {
      return fullHeart;
    } else if (score >= 4) {
      return halfHeart;
    } else {
      return brokenHeart;
    }
  };

  // Get the heart image based on the score
  const heartImage = getImageAsset(score);

  // Helper function to check if a network image is valid
  const renderImage = (src: string | null) => {
    return (
      <img
        src={src || MadFace} // Fallback to NeutralFace if src is null or invalid
        alt="Photo"
        style={{
          width: 110,
          height: 140,
          border: "0.5px solid #fff",
          borderRadius: "10px",
          objectFit: "cover",
        }}
        onError={(e) => {
          (e.target as HTMLImageElement).src = MadFace; // Fallback on load error
        }}
      />
    );
  };

  return (
    <div
      style={{
        position: "relative",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        textAlign: "center",
      }}
    >
      {/* Heart Image */}
      <div
        style={{
          position: "absolute",
          zIndex: 2,
          top: "50%", // Adjust to position the heart correctly
          transform: "translateY(-50%)",
        }}
      >
        <img
          src={heartImage}
          alt="Heart"
          style={{
            width: 80,
            height: 80,
          }}
        />
      </div>

      {/* Photos Container */}
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          gap: "20px",
          zIndex: 1,
        }}
      >
        {renderImage(photo1)}
        {renderImage(photo2)}
      </div>
    </div>
  );
};

export default CouplePhotos;
