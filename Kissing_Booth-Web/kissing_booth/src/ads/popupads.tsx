import React, { useEffect, useState } from "react";

interface PopupAdProps {
  onClose: () => void;
}

const PopupAd: React.FC<PopupAdProps> = ({ onClose }) => {
  const isDev = import.meta.env.MODE === "development"; // 개발 환경 확인
  const [adLoaded, setAdLoaded] = useState(false); // 광고 로드 상태 관리

  useEffect(() => {
    if (!isDev) {
      try {
        (window.adsbygoogle = window.adsbygoogle || []).push({
          params: {
            onAdLoaded: () => setAdLoaded(true), // 광고 로드 완료 시 상태 업데이트
            onAdFailedToLoad: () => setAdLoaded(false), // 광고 로드 실패 시 상태 업데이트
          },
        });
      } catch (e) {
        console.error("Adsbygoogle error:", e);
      }
    }
  }, [isDev]);

  return (
    <div
      style={{
        position: "fixed",
        top: 0,
        left: 0,
        width: "100vw",
        height: "100vh",
        backgroundColor: "rgba(0, 0, 0, 0.7)", // 배경
        zIndex: 9999, // 최상단
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <div
        style={{
          backgroundColor: "white",
          border: "1px solid #ccc",
          boxShadow: "0 4px 10px rgba(0, 0, 0, 0.2)",
          padding: "20px",
          borderRadius: "10px",
          width: "320px",
          height: "480px",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        {isDev || !adLoaded ? (
          <div
            style={{
              width: "100%",
              height: "100%",
              backgroundColor: "#ddd",
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              color: "#555",
              fontWeight: "bold",
            }}
          >
            [Popup Ad Placeholder]
          </div>
        ) : (
          <ins
            className="adsbygoogle"
            style={{ display: "inline-block", width: "320px", height: "480px" }}
            data-ad-client="ca-pub-2674925873094012"
            data-ad-slot="2294203451"
          ></ins>
        )}

        {/* 닫기 버튼 (광고가 로드되지 않은 경우만 표시) */}
        {!adLoaded && (
          <button
            onClick={onClose}
            style={{
              marginTop: "20px",
              padding: "10px 20px",
              backgroundColor: "#f44336",
              color: "white",
              border: "none",
              borderRadius: "5px",
              cursor: "pointer",
            }}
          >
            닫기
          </button>
        )}
      </div>
    </div>
  );
};

export default PopupAd;
