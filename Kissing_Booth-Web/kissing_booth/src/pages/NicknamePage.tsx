import React, { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import BackButton from "../components/BackButton";
import Title from "../components/Title";
import Subtitle from "../components/subTitle";
import CustomButton from "../components/customButton";
import i18n from "../locales/i18n";
import { AppFonts } from "../styles/fonts";
import { ApiService } from "../api/apiServies";
import { Helmet } from "react-helmet-async";
// import GoogleAd from "../ads/googleads";
// import BannerAd from "../ads/bannerAds";

const NicknamePage: React.FC = () => {
  const location = useLocation();
  const { userId } = location.state || {};
  const navigate = useNavigate();

  const [nickname, setNickname] = useState(""); // Nickname state
  const [errorMessage, setErrorMessage] = useState(""); // Error message state
  const [isMobile, setIsMobile] = useState(false); // State for detecting mobile devices

  useEffect(() => {
    const detectMobile = () => {
      setIsMobile(window.innerWidth <= 768);
    };
    detectMobile();
    window.addEventListener("resize", detectMobile);

    window.scrollTo(0, 0);
    return () => {
      window.removeEventListener("resize", detectMobile);
    };
  }, []);

  

  const handleRankingNavigation = async () => {
    setErrorMessage("");

    if (!nickname.trim()) {
      setErrorMessage("Nickname is required.");
      return;
    }

    if (!userId) {
      setErrorMessage("User ID is missing. Please try again.");
      return;
    }

    try {
      const response = await ApiService.getUserRanking(userId, nickname);
      navigate("/ranking", {
        state: {
          userId: response.user_id,
          nickname: response.nickname,
          ranking: response.ranking,
          score: parseFloat(response.score),
        },
      });
    } catch (error: unknown) {
      console.error("Error during API call:", error);
      const translatedText = i18n.t("nickname_error");
      setErrorMessage(translatedText);
    }
  };

  return (
    <div
      style={{
        width: "100vw",
        height: "100vh",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "rgba(244, 244, 250, 1)",
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

      {/* Main Content */}
      <div
        style={{
          width: "100%",
          maxWidth: "500px",
          height: isMobile ? "100%" : "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          boxShadow: "0 4px 10px rgba(0, 0, 0, 0.1)",
          borderRadius: "10px",
          backgroundColor: "rgba(244, 244, 248, 1)",
          position: "relative", // To position the banner ad correctly
        }}
      >
        <Helmet>
          <title>{i18n.t("enter_nickname_placeholder")}</title>
          <meta
            name="description"
            content={i18n.t("enter_nickname_description")}
          />
          <meta
            property="og:title"
            content={i18n.t("enter_nickname_placeholder")}
          />
          <meta
            property="og:description"
            content={i18n.t("enter_nickname_description")}
          />
          <meta
            property="og:url"
            content="https://kissing-booth-ai.com/nickname"
          />
          <meta property="og:type" content="website" />
          <meta name="twitter:card" content="title" />
          <meta name="twitter:title" content={i18n.t("title")} />
          <meta
            name="twitter:description"
            content={i18n.t("enter_nickname_description")}
          />
          <meta
            name="google-adsense-account"
            content="ca-pub-2674925873094012"
          />
        </Helmet>

        {/* Page Content */}
        <div
          style={{
            flex: 1,
            width: "100%",
            textAlign: "center",
            padding: "20px",
          }}
        >
          <BackButton onClick={() => window.history.back()} />
          <Title textKey="enter_nickname_placeholder" />
          <div style={{ height: "10px" }}></div>
          <Subtitle textKey="enter_nickname_description" />
          <input
            type="text"
            placeholder="Type Nickname"
            maxLength={13}
            value={nickname}
            onChange={(e) => setNickname(e.target.value)}
            style={{
              ...AppFonts.TextInput(i18n.language),
              width: "100%",
              height: "60px",
              padding: "16px",
              borderRadius: "12px",
              marginTop: "10px",
              outline: "none",
              textAlign: "center",
              backgroundColor: "rgba(244, 244, 250, 1)",
              caretColor: "#000",
              border: errorMessage ? "1px solid red" : "1px solid transparent",
            }}
          />
            {errorMessage && (
            <p
              style={{
              ...AppFonts.NicknameError(i18n.language),
              marginTop: "8px",
              textAlign: "center",
              }}
            >
              {errorMessage}
            </p>
            )}
          <div style={{ height: "20px" }}></div>
          <CustomButton
            textKey="ranking"
            onClick={handleRankingNavigation}
            buttonColor="rgba(0, 122, 255, 1)"
            textColor="white"
            language={i18n.language}
          />
        </div>
        {/* Banner Ad */}
        <div
          style={{
            width: "100%",
            padding: "10px 0",
            marginTop: isMobile ? "20px" : "auto",
          }}
        >
          {/* <BannerAd adClient="ca-pub-2674925873094012" adSlot="5237165212" /> */}
        </div>
        {isMobile && <div style={{ height: "105px" }}></div>}
      </div>
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

export default NicknamePage;
