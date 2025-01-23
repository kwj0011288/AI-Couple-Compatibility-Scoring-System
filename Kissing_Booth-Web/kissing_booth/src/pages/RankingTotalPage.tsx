import React, { useEffect, useState } from "react";
import BackButton from "../components/BackButton";
import Title from "../components/Title";
import { ApiService } from "../api/apiServies";
import RankingTile from "../components/RankingTile";
import loadingHeart from "../assets/lottie/heart_loading.json";
import { Users } from "../types/users";
import i18n from "../locales/i18n";
import { Helmet } from "react-helmet-async";
import { t } from "i18next";
import Lottie from "react-lottie-player";
import { AppFonts } from "../styles/fonts";
// import InRankingTile from "../ads/InRankingAds";
//import GoogleAd from "../ads/googleads";
import CustomButton from "../components/customButton";
import NeutralFace from "../assets/illustrations/man_neutral.png";

const RankingTotalPage: React.FC = () => {
  const [sortedData, setSortedData] = useState<Users[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isMobile, setIsMobile] = useState(false);

  const [offset, setOffset] = useState(0);
  const [hasMore, setHasMore] = useState(true);
  const limit = 10;


  useEffect(() => {
    const detectMobile = () => {
      setIsMobile(window.innerWidth <= 768);
    };
    detectMobile();
    window.addEventListener("resize", detectMobile);

    return () => {
      window.removeEventListener("resize", detectMobile);
    };
  }, []);

  const fetchRankings = async () => {
    try {
      setLoading(true);

      // 1초 지연
      await new Promise((resolve) => setTimeout(resolve, 1000));

      const data = await ApiService.getTotalRankings(offset, limit);
      setSortedData((prevData) => [...prevData, ...data.results]);
      setHasMore(data.next_offset !== null); // 마지막 페이지인지 확인
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "Failed to fetch rankings."
      );
    } finally {
      setLoading(false);
    }
  };

  

  useEffect(() => {
    fetchRankings();
  }, [offset]);

  useEffect(() => {
    const handleScroll = () => {
      if (
        window.innerHeight + document.documentElement.scrollTop >=
          document.documentElement.offsetHeight - 300 &&
        !loading &&
        hasMore
      ) {
        setOffset((prevOffset) => prevOffset + limit); // 다음 offset 설정
      }
    };

    window.addEventListener("scroll", handleScroll);

    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, [loading, hasMore]);

  if (loading && sortedData.length === 0) {
    return (
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          textAlign: "center",
          height: "100vh",
        }}
      >
        <Lottie
          loop
          animationData={loadingHeart}
          play
          style={{ width: 400, height: 400 }}
        />
        <p style={{ ...AppFonts.loading(i18n.language), marginTop: "10px" }}>
          {t("uploading")}
        </p>
      </div>
    );
  }

  if (error) {
    return (
      <div
        style={{
          width: "100vw",
          height: "100vh",
          backgroundColor: "rgba(244, 244, 250, 1)",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          padding: "20px", // 화면의 양 옆에 여유 공간 추가
          boxSizing: "border-box", // padding 포함한 크기 계산
        }}
      >
        <Helmet>
          <title>{i18n.t("ranking_title")}</title>
          <meta name="description" content={i18n.t("ranking_title")} />
          <meta property="og:title" content={i18n.t("ranking_title")} />
          <meta property="og:description" content={i18n.t("ranking_title")} />
          <meta
            property="og:url"
            content="https://kissing-booth-ai.com/rankingTotal"
          />
          <meta property="og:type" content="website" />
          <meta name="twitter:card" content="ranking_title" />
          <meta name="twitter:title" content={i18n.t("ranking_title")} />
          <meta name="twitter:description" content={i18n.t("ranking_title")} />
          <meta
            name="google-adsense-account"
            content="ca-pub-2674925873094012"
          />
        </Helmet>
        <main
          style={{
            width: "100%",
            maxWidth: "500px",
            padding: "30px",
            boxShadow: "0 4px 10px rgba(0, 0, 0, 0.1)",
            borderRadius: "10px",
            backgroundColor: "rgba(244, 244, 248, 1)",
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            gap: "20px", // 각 요소 간의 간격
          }}
        >
          {/* 제목 */}
          <h1
            style={{
              ...AppFonts.title(i18n.language),
              textAlign: "center", // 텍스트 중앙 정렬
            }}
          >
            {t("title")}
          </h1>

          {/* 화난 얼굴 이미지 */}
          <img
            src={NeutralFace}
            alt="MadFace"
            style={{
              width: "70%", // 컨테이너 너비 대비 70%
              height: "auto",
              borderRadius: "10px",
            }}
          />

          {/* 안내 메시지 */}
          <h2
            style={{
              ...AppFonts.title2(i18n.language),
              textAlign: "center",
            }}
          >
            {t("error")}
          </h2>

          {/* 버튼 */}
          <CustomButton
            textKey="retry"
            buttonColor="black"
            textColor="white"
            language={i18n.language}
            onClick={() => window.history.back()}
          />
        </main>
      </div>
    );
  }

  return (
    <div
      style={{
        width: "100vw",
        height: "100%",
        backgroundColor: "rgba(244, 244, 250, 1)",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <Helmet>
        <title>{i18n.t("ranking_title")}</title>
        <meta name="description" content={i18n.t("ranking_title")} />
        <meta property="og:title" content={i18n.t("ranking_title")} />
        <meta property="og:description" content={i18n.t("ranking_title")} />
        <meta
          property="og:url"
          content="https://kissing-booth-ai.com/rankingTotal"
        />
        <meta property="og:type" content="website" />
        <meta name="twitter:card" content="ranking_title" />
        <meta name="twitter:title" content={i18n.t("ranking_title")} />
        <meta name="twitter:description" content={i18n.t("ranking_title")} />
        <meta name="google-adsense-account" content="ca-pub-2674925873094012" />
      </Helmet>
      {/* Left Ad for Non-Mobile */}
      {/* {!isMobile && (
        <div
          style={{
            width: "15%",
            height: "100%",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <GoogleAd
            adClient="ca-pub-2674925873094012"
            adSlot="7673716745"
            style={{ width: "100%", height: "300px" }}
          />
        </div>
      )} */}
      {!isMobile && <div style={{ width: "30px" }}></div>}

      {/* Main Content */}
      <main
        style={{
          width: "100%",
          maxWidth: "500px",
          padding: "20px",
          boxShadow: "0 4px 10px rgba(0, 0, 0, 0.1)",
          borderRadius: "10px",
          backgroundColor: "rgba(244, 244, 248, 1)",
          display: "flex",
          flexDirection: "column",
          justifyContent: "flex-start",
          alignItems: "center",
          minHeight: "100vh",
        }}
      >
        {/* Header with Back Button and Title */}
        <div className="text-center w-full">
          <div
            style={{
              position: "relative",
              display: "flex",
              alignItems: "center",
              height: "60px",
              marginBottom: "20px",
            }}
          >
            <BackButton onClick={() => window.history.back()} />
            <div
              style={{
                position: "relative",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                height: "60px",
                marginTop: "5px",
              }}
            >
              <Title textKey="ranking_title" />
            </div>
          </div>

          {/* Rankings List */}
          <div>
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
      </main>

      {!isMobile && <div style={{ width: "30px" }}></div>}

      {/* Right Ad for Non-Mobile */}
      {/* {!isMobile && (
        <div
          style={{
            width: "15%",
            height: "100%",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <GoogleAd
            adClient="ca-pub-2674925873094012"
            adSlot="7673716745"
            style={{ width: "100%", height: "300px" }}
          />
        </div> */}
      {/* )} */}
    </div>
  );
};

export default RankingTotalPage;
