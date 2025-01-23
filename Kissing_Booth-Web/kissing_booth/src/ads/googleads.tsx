import React, { useEffect } from "react";

interface GoogleAdProps {
  adClient: string;
  adSlot: string;
  style?: React.CSSProperties;
}

const GoogleAd: React.FC<GoogleAdProps> = ({ adClient, adSlot, style }) => {
    const isDev = import.meta.env.MODE === "development"; // Vite 환경 변수

  
    useEffect(() => {
      if (!isDev) {
        try {
          (window.adsbygoogle = window.adsbygoogle || []).push({});
        } catch (e) {
          console.error("Adsbygoogle error:", e);
        }
      }
    }, [isDev]);
  
    return isDev ? (
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          backgroundColor: "#ddd",
          color: "#555",
          fontSize: "14px",
          fontWeight: "bold",
          ...(style || {}),
        }}
      >
        [Google Ad Placeholder]
      </div>
    ) : (
      <ins
        className="adsbygoogle"
        style={{
          display: "block",
          ...(style || {}),
        }}
        data-ad-client={adClient}
        data-ad-slot={adSlot}
        data-ad-format="auto"
        data-full-width-responsive="true"
      ></ins>
    );
  };
  

export default GoogleAd;
