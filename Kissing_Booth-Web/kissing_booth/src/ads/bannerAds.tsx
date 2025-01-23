import React, { useEffect } from "react";

interface BannerAdProps {
  adClient: string;
  adSlot: string;
}

const BannerAd: React.FC<BannerAdProps> = ({ adClient, adSlot }) => {
  // Check if the app is running in debug mode (development environment)
  const isDebugMode = import.meta.env.MODE === "development";

  useEffect(() => {
    if (!isDebugMode) {
      try {
        (window.adsbygoogle = window.adsbygoogle || []).push({});
      } catch (e) {
        console.error("Adsbygoogle error:", e);
      }
    }
  }, [isDebugMode]);

  if (isDebugMode) {
    return (
      <div
        style={{
          width: "100%",
          textAlign: "center",
          padding: "10px",
          backgroundColor: "#f8f8f8",
          border: "1px dashed #ccc",
        }}
      >
        <p style={{ color: "#555", fontSize: "14px" }}>
          [Debug Mode] Ad Placeholder (Ad Client: {adClient}, Ad Slot: {adSlot})
        </p>
      </div>
    );
  }

  return (
    <div style={{ width: "100%", margin: "20px auto" }}>
      <ins
        className="adsbygoogle"
        style={{ display: "block" }}
        data-ad-client={adClient}
        data-ad-slot={adSlot}
        data-ad-format="auto"
        data-full-width-responsive="true"
      ></ins>
    </div>
  );
};

export default BannerAd;
