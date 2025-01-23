import React, { useEffect } from "react";

const InRankingTile: React.FC = () => {
  const isDebugMode = import.meta.env.MODE === "development";

  useEffect(() => {
    if (!isDebugMode) {
      // Dynamically load the Google AdSense script
      const script = document.createElement("script");
      script.async = true;
      script.src =
        "https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-2674925873094012";
      script.crossOrigin = "anonymous";

      document.body.appendChild(script);

      script.onload = () => {
        try {
          (window.adsbygoogle = window.adsbygoogle || []).push({});
        } catch (e) {
          console.error("Adsbygoogle error:", e);
        }
      };

      script.onerror = () => {
        console.error("Failed to load Google AdSense script.");
      };

      return () => {
        document.body.removeChild(script);
      };
    }
  }, [isDebugMode]);

  if (isDebugMode) {
    // Placeholder for development mode
    return (
      <div
        style={{
          width: "100%",
          height: "100px",
          backgroundColor: "#f8f8f8",
          border: "1px dashed #ccc",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          margin: "10px 0",
        }}
      >
        <p style={{ color: "#555", fontSize: "14px" }}>
          [Debug Mode] Ad Placeholder
        </p>
      </div>
    );
  }

  // Render actual ad for production mode
  return (
    <div
      style={{
        width: "100%",
        height: "100px",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        margin: "10px 0",
      }}
    >
      <ins
        className="adsbygoogle"
        style={{ display: "block", width: "100%", height: "100px" }}
        data-ad-client="ca-pub-2674925873094012"
        data-ad-slot="6770874200"
        data-ad-format="fluid"
        data-ad-layout-key="-fb+5w+4e-db+86"
      ></ins>
    </div>
  );
};

export default InRankingTile;
