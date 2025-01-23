import React from "react";
import ProgressBar from "./ProgressBar";
import { AppFonts } from "../../styles/fonts";
import i18n from "../../locales/i18n";

interface TotalRateProps {
  currentRank: number;
  totalRank: number;
  score: number;
}


const TotalRate: React.FC<TotalRateProps> = ({
  currentRank,
  totalRank,
  score,
}) => {
  return (
    <div
      style={{
      padding: "20px",
      margin: "20px auto",
      borderRadius: "10px",
      backgroundColor: "rgba(244, 244, 250, 1)",
      boxShadow: "0 8px 16px rgba(0, 0, 0, 0.2)", // Increased shadow for more depth
      width: "100%",
      maxWidth: "900px", // Make the box wider
      }}
    >
      {/* Title */}
      <div style={{ marginBottom: "10px", textAlign: "left" }}>
      <p style={{ ...AppFonts.rankingTitle(i18n.language), margin: 0 }}>
        {i18n.t("total_rate")}
      </p>
      </div>

      {/* Rank and Score Row */}
      <div
      style={{
        display: "flex",
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        marginBottom: "10px",
      }}
      >
      {/* Rank */}
      <div style={{ display: "flex", flexDirection: "row", alignItems: "center" }}>
        <p style={{ ...AppFonts.rankingRate(i18n.language), margin: 0 }}>
        {Math.floor(currentRank)}
        </p>
        <p style={{ ...AppFonts.rankingTotal(i18n.language), margin: "0 0 0 5px",  paddingTop: "5px"}}>
        {" "}
        / {totalRank}
        </p>
      </div>

      {/* Score */}
      <div style={{ display: "flex", flexDirection: "row", alignItems: "center" }}>
        <p style={{ ...AppFonts.rankingRate(i18n.language), margin: 0 }}>
        {score}
        </p>
        <p style={{ ...AppFonts.rankingTotal(i18n.language), margin: "0 0 0 10px", paddingTop: "5px" }}>
        {" "}
        / 10
        </p>
      </div>
      </div>

      {/* Progress Bar */}
      <ProgressBar currentRank={currentRank} totalRank={totalRank} />

      <div style={{ height: "10px" }}></div>
    </div>
  );
};

export default TotalRate;
