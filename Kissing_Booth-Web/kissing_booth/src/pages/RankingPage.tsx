import React, { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import Title from "../components/Title";
import { AppFonts } from "../styles/fonts";
import i18n from "../locales/i18n";
import TotalRate from "../components/RankingPage/ScoreBox";
import loadingHeart from "../assets/lottie/heart_loading.json";
import RankingButton from "../components/RankingButton";
import RankingBox from "../components/RankingPage/RankingBox";
import { Users } from "../types/users";
import { ApiService } from "../api/apiServies"; // ApiService import 추가
import { Helmet } from "react-helmet-async";
import Lottie from "react-lottie-player";
import { t } from "i18next";
// import GoogleAd from "../ads/googleads";
// import PopupAd from "../ads/popupads";
import NeutralFace from "../assets/illustrations/man_neutral.png";
import CustomButton from "../components/customButton";

const getRankingText = (rank: number): string => {
  const locale = i18n.language;

  let suffix = "";
  if (locale === "en") {
    if (rank % 10 === 1 && rank % 100 !== 11) {
      suffix = i18n.t("ranking_suffix_1");
    } else if (rank % 10 === 2 && rank % 100 !== 12) {
      suffix = i18n.t("ranking_suffix_2");
    } else if (rank % 10 === 3 && rank % 100 !== 13) {
      suffix = i18n.t("ranking_suffix_3");
    } else {
      suffix = i18n.t("ranking_suffix_4");
    }
  } else {
    suffix = i18n.t("ranking_suffix_1");
  }

  const prefix = i18n.t("ranking_prefix");
  return `${prefix}${rank}${suffix}`;
};

const RankingPage: React.FC = () => {
  const location = useLocation();
  const { nickname, ranking, score } = location.state || {}; // 전달받은 state에서 데이터 추출
  const navigate = useNavigate();

  const [sortedData, setSortedData] = useState<Users[]>([]); // 전체 랭킹 데이터
  const [loading, setLoading] = useState(true); // 로딩 상태
  const [error, setError] = useState<string | null>(null); // 에러 상태
  const [isMobile, setIsMobile] = useState(false);
  // const [isPopupVisible, setIsPopupVisible] = useState(false); // Track popup visibility
  // const [isPopupVisible2, setIsPopupVisible2] = useState(false);

  const [offset, setOffset] = useState(0);
  const [hasMore, setHasMore] = useState(true);
  const limit = 10;

  const [totalNickname, setTotalNickname] = useState<number | null>(null); // 닉네임이 있는 사용자


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

  // const handlePopupClose = () => {
  //   setIsPopupVisible(false);
  //   navigate("/", { replace: true });
  // };



  // const handlePopupClose2 = () => {
  //   setIsPopupVisible2(false);
  // };

  // 데이터 누락 시 홈으로 리다이렉트
  useEffect(() => {
    if (!nickname || ranking === undefined || score === undefined) {
      console.error("Missing required data. Redirecting to home.");
      navigate("/", { replace: true });
    }
  }, [nickname, ranking, score, navigate]);

  // 전체 랭킹 데이터 가져오기
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

    const fetchTotalNickname = async () => {
      try {
        const data = await ApiService.getTotalUsers();
        setTotalNickname(data.total_nickname); // 닉네임이 있는 사용자 수만 가져옴
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "Failed to fetch total users."
        );
      }
    };
  

  useEffect(() => {
    fetchRankings();
    fetchTotalNickname();
  }, [offset]);

  useEffect(() => {
    const handleScroll = () => {
      if (
        window.innerHeight + document.documentElement.scrollTop >=
          document.documentElement.offsetHeight - 50 &&
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

  // // Trigger the popup ad after 5 seconds
  // useEffect(() => {
  //   const timer = setTimeout(() => {
  //     setIsPopupVisible2(true);
  //   }, 5000);

  //   return () => clearTimeout(timer); // Clear timer on component unmount
  // }, []);

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
          <title>{i18n.t("title")}</title>
          <meta name="description" content={`...${i18n.t("our_ranking")}`} />
          <meta property="og:title" content={i18n.t("title")} />
          <meta
            property="og:description"
            content={`...${i18n.t("our_ranking")}`}
          />
          <meta
            property="og:url"
            content="https://kissing-booth-ai.com/ranking"
          />
          <meta property="og:type" content="website" />
          <meta name="twitter:card" content="title" />
          <meta name="twitter:title" content={i18n.t("title")} />
          <meta
            name="twitter:description"
            content={`...${i18n.t("our_ranking")}`}
          />{" "}
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
      {/* {isPopupVisible && <PopupAd onClose={handlePopupClose} />}
      {isPopupVisible2 && <PopupAd onClose={handlePopupClose2} />} */}
      <Helmet>
        <title>{i18n.t("title")}</title>
        <meta name="description" content={`...${i18n.t("our_ranking")}`} />
        <meta property="og:title" content={i18n.t("title")} />
        <meta
          property="og:description"
          content={`...${i18n.t("our_ranking")}`}
        />
        <meta
          property="og:url"
          content="https://kissing-booth-ai.com/ranking"
        />
        <meta property="og:type" content="website" />
        <meta name="twitter:card" content="title" />
        <meta name="twitter:title" content={i18n.t("title")} />
        <meta
          name="twitter:description"
          content={`...${i18n.t("our_ranking")}`}
        />{" "}
        <meta name="google-adsense-account" content="ca-pub-2674925873094012" />
      </Helmet>
      <main
        style={{
          width: "100%",
          maxWidth: "500px",
          padding: "20px",
          boxShadow: "0 4px 10px rgba(0, 0, 0, 0.1)",
          borderRadius: "10px",
          backgroundColor: "rgba(244, 244, 250, 1)",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          minHeight: "100vh",
          height: "auto",
        }}
      >
        {/* Title Section */}
        <div
          style={{
            textAlign: "center",
            marginBottom: "5px",
          }}
        >
          <div
            style={{
              display: "flex", // Flexbox layout
              flexDirection: "row", // Row direction
              flexWrap: "wrap", // Allow wrapping to next line if overflow occurs
              alignItems: "center", // Align items vertically in the center
              justifyContent: "center", // Center the content horizontally
              gap: "10px", // Space between elements
              marginBottom: "10px", // Optional margin for spacing
              textAlign: "center", // Center-align text when wrapping
            }}
          >
            <p
              style={{
                ...AppFonts.title(i18n.language),
                wordWrap: "break-word", // Break long words
                maxWidth: "100%", // Prevent overflow for long text
              }}
            >
              {nickname}
            </p>
            <Title textKey="our_ranking" />
          </div>
        </div>

        {/* Ranking Text and TotalRate */}
        <div
          style={{
            width: "100%",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          <p
            style={{
              ...AppFonts.rankingTotal2(i18n.language),
              marginBottom: "20px",
            }}
          >
            {getRankingText(ranking)}
          </p>
          <TotalRate
            currentRank={ranking}
            totalRank={totalNickname!} // 총 사용자 수 표시
            score={parseFloat((score * 10).toFixed(2))}
          />
          <RankingBox sortedData={sortedData} loading={loading} />
        </div>

        {/* Retry Button */}
        <div
          style={{
            position: "fixed",
            bottom: "20px",
            width: "100%",
            display: "flex",
            justifyContent: "center",
            zIndex: 100,
          }}
        >
          <RankingButton
            textKey="retry"
            buttonColor="rgba(0, 122, 255, 1)"
            textColor="white"
            language={i18n.language}
             // onClick={() => setIsPopupVisible(true)}
            onClick={() => navigate("/", { replace: true })}
          />
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
        </div>
      )} */}
    </div>
  );
};

export default RankingPage;
