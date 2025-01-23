import React from "react";
import { AppFonts } from "../../styles/fonts";
import i18n from "../../locales/i18n";

interface ProgressBarProps {
  currentRank: number; // 현재 등수
  totalRank: number; // 총 등수
}

const ProgressBar: React.FC<ProgressBarProps> = ({ currentRank, totalRank }) => {
  const colors = ["#FF0000", "#FFFF00", "#90EE90", "#008000"]; // Red, Yellow, Light Green, Green
  const thresholds = [0.25, 0.5, 0.75, 1.0]; // Thresholds for color segments

  // 유효성 검사: currentRank와 totalRank가 0보다 크지 않으면 기본값 설정
  const validCurrentRank = currentRank > 0 ? currentRank : 1; // 최소값 1
  const validTotalRank = totalRank > 0 ? totalRank : 1; // 최소값 1

  // 현재 등수에 따른 반전 비율 (낮은 등수가 높음)
  const rate = 1.0 - validCurrentRank / validTotalRank; // 1등 = 1.0, 꼴등 = 0.0

 
  return (
    <div style={{ width: "100%", marginTop: "10px" }}>
      <div
        style={{
          position: "relative",
          height: "12px",
          width: "100%",
          maxWidth: "500px",
          margin: "0 auto",
        }}
      >
        {/* Background segments */}
        <div style={{ display: "flex", width: "100%", height: "12px" }}>
          {thresholds.map((threshold, index) => {
            const segmentWidth =
              (threshold - (index === 0 ? 0 : thresholds[index - 1])) * 100 +
              "%";

            return (
              <div
                key={index}
                style={{
                  width: segmentWidth,
                  height: "100%",
                  backgroundColor: colors[index],
                  borderRadius: `${
                    index === 0
                      ? "6px 0 0 6px"
                      : index === thresholds.length - 1
                      ? "0 6px 6px 0"
                      : "0"
                  }`,
                }}
              />
            );
          })}
        </div>

        {/* Indicator */}
        <div
          style={{
            position: "absolute",
            left: `calc(${rate * 100}% - 8px)`, // Indicator position based on reversed rate
            top: "-4px",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          {/* Indicator bar */}
          <div
            style={{
              width: "3px",
              height: "20px",
              backgroundColor: "black", // Dynamic color
              borderRadius: "6px",
            }}
          ></div>
          {/* Percentage text */}
          <span
            style={{
              marginTop: "4px",
              fontSize: AppFonts.myScoreRate(i18n.language).fontSize,
              fontFamily: AppFonts.myScoreRate(i18n.language).fontFamily,
              color: "black", // Match text color to the indicator
            }}
          >
            {(rate * 100).toFixed(0)}% {/* Current percentage */}
          </span>
        </div>
      </div>
    </div>
  );
};

export default ProgressBar;
