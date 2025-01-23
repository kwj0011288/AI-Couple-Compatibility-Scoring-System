import React from "react";
import { AppFonts } from "../../styles/fonts";
import i18n from "../../locales/i18n";
import RankingTile from "../../components/RankingTile";
import { Users } from "../../types/users";
// import InRankingTile from "../../ads/InRankingAds";
import Lottie from "react-lottie-player";
import loadingHeart from "../../assets/lottie/heart_loading.json";

interface RankingBoxProps {
  sortedData: Users[]; // Props로 전달받을 데이터 타입 정의
  loading: boolean; // 로딩 상태를 Props로 받음
}

const RankingBox: React.FC<RankingBoxProps> = ({ sortedData, loading }) => {
  return (
    <div
      style={{
        padding: "20px",
        margin: "20px auto",
        borderRadius: "10px",
        backgroundColor: "rgba(244, 244, 250, 1)",
        boxShadow: "0 8px 16px rgba(0, 0, 0, 0.2)",
        width: "100%",
        maxWidth: "900px",
      }}
    >
      {/* Title */}
      <div style={{ marginBottom: "10px", textAlign: "left" }}>
        <p style={{ ...AppFonts.rankingTitle(i18n.language), margin: 0 }}>
          {i18n.t("total_rate")}
        </p>
      </div>

      {/* Rankings List */}
      <div className="w-full">
        {/* {sortedData.map((user, index) => (
          <React.Fragment key={`${user.user_id}-${index}`}>
            <RankingTile users={user} />
            {(index + 1) % 5 === 0 && <InRankingTile />}
          </React.Fragment>
        ))} */}
        {sortedData.map((user, index) => (
          <RankingTile key={`${user.user_id}-${index}`} users={user} />
        ))}
        

        {/* 로딩 상태일 때 로딩 표시 */}
        {loading && (
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              margin: "20px 0",
            }}
          >
            <Lottie
              loop
              animationData={loadingHeart}
              play
              style={{ width: 100, height: 100 }}
            />
          </div>
        )}
      </div>
    </div>
  );
};

export default RankingBox;
