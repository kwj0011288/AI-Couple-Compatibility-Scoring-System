import React, { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import CouplePhotos from "../components/ResultPage/CouplePhotos";
import ResultText from "../components/ResultPage/ResultText";
import ChatBubble from "../components/ResultPage/chatBubble";
import ResultChatBubble from "../components/ResultPage/resultChatBubble.tsx";
import MadFace from "../assets/illustrations/man_mad.png";
import { t } from "i18next";
import { AppFonts } from "../styles/fonts";
import i18n from "../locales/i18n";
import CustomButton from "../components/customButton";
import { Helmet } from "react-helmet-async";
import PopupAd from "../ads/popupads.tsx";
//import GoogleAd from "../ads/googleads.tsx";

const ResultPage: React.FC = () => {
  const location = useLocation();
  const { state } = location;
  const navigate = useNavigate();

  // Destructure the passed state
  const {
    score = 0.44444,
    photo1_url: photo1 = 'https://kissing-booth-bucket.s3.us-east-1.amazonaws.com/photos/2/8205ecd41849420a914b620ed69e7db2.jpg',
    photo2_url: photo2 = 'https://kissing-booth-bucket.s3.us-east-1.amazonaws.com/photos/1/1a97208bb60e4c938d901156c1c38459.jpg',
    id: userId = `${Math.floor(Date.now() / 1000)}`,
  } = state || {};


  const [isMobile, setIsMobile] = useState(false); // State for detecting mobile devices
  const [isPopupVisible, setIsPopupVisible] = useState(false); // Track popup visibility



  const handlePopupClose = () => {
    setIsPopupVisible(false);
    navigate("/", { replace: true });
  };

  useEffect(() => {
    try {
      (window.adsbygoogle = window.adsbygoogle || []).push({});
    } catch (e) {
      console.error("Adsbygoogle error:", e);
    }

    detectMobile();
    window.addEventListener("resize", detectMobile);

    return () => {
      window.removeEventListener("resize", detectMobile);
    };
  }, []);

  const detectMobile = () => {
    const isMobileDevice = window.innerWidth <= 768;
    setIsMobile(isMobileDevice);
  };


  // Log the state and userId for debugging
  useEffect(() => {
    // console.log("ResultPage state:", state); // 전체 state 값 출력
    // console.log("ResultPage userId:", userId); // userId 값 출력

    if (!state) {
      console.warn("No state passed to ResultPage. Redirecting to home.");
    }
  }, [state, userId]);

  // if (!state) {
  //   navigate("/", { replace: true });
  //   return null; // Avoid rendering anything if no state is passed
  // }
  if (score === -1.0) {
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
         {isPopupVisible && <PopupAd onClose={handlePopupClose} />}
        <Helmet>
          <title>{i18n.t("title")}</title>
          <meta name="description" content={i18n.t("subtitle")} />
          <meta property="og:title" content={i18n.t("title")} />
          <meta property="og:description" content={i18n.t("subtitle")} />
          <meta
            property="og:url"
            content="https://kissing-booth-ai.com/result"
          />
          <meta property="og:type" content="website" />
          <meta name="twitter:card" content="title" />
          <meta name="twitter:title" content={i18n.t("title")} />
          <meta name="twitter:description" content={i18n.t("subtitle")} />
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
            src={MadFace}
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
            {t("noface")}
          </h2>

          {/* 버튼 */}
          <CustomButton
            textKey="retry"
            buttonColor="black"
            textColor="white"
            language={i18n.language}
            onClick={() => setIsPopupVisible(true)} 
          />
        </main>
      </div>
    );
  }

  return (
    <div
      style={{
        width: "100vw",
        height: "100vh",
        backgroundColor: "rgba(244, 244, 250, 1)",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
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
      {/* {isPopupVisible && <PopupAd onClose={handlePopupClose} />} */}
      <Helmet>
        <title>{i18n.t("title")}</title>
        <meta name="description" content={i18n.t("subtitle")} />
        <meta property="og:title" content={i18n.t("title")} />
        <meta property="og:description" content={i18n.t("subtitle")} />
        <meta property="og:url" content="https://kissing-booth-ai.com/result" />
        <meta property="og:type" content="website" />
        <meta name="twitter:card" content="title" />
        <meta name="twitter:title" content={i18n.t("title")} />
        <meta name="twitter:description" content={i18n.t("subtitle")} />
        <meta name="google-adsense-account" content="ca-pub-2674925873094012" />
      </Helmet>
      <main
        style={{
          width: "100%", // Full width for mobile responsiveness
          maxWidth: "500px", // Limit the maximum width to 500px
          padding: "20px",
          boxShadow: "0 4px 10px rgba(0, 0, 0, 0.1)",
          borderRadius: "10px",
          backgroundColor: "rgba(244, 244, 248, 1)",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center", // Center the content
          alignItems: "center",
          minHeight: "100vh", // Ensure at least full screen height
          height: "auto", // Allow height to grow with content
        }}
      >
        <div style={{ height: "50px" }}></div>
        {/* Page Title */}
        <h1
          style={{
            ...AppFonts.title(i18n.language),
          }}
        >
          {t("title")}
        </h1>
        <div style={{ height: "10px" }}></div>
        <div
          style={{
            width: "100%",
            display: "flex",
            justifyContent: "center",
            gap: "10px",
          }}
        >
          <div className="text-center w-full">
            <div style={{ height: "5px" }}></div>
            <CouplePhotos photo1={photo1} photo2={photo2} score={score * 10} />
            <div style={{ height: "5px" }}></div>
            <ResultText text={`${(score * 10).toFixed(2)}`} />
            <ChatBubble
              score={parseFloat((score * 10).toFixed(2))}
              color="rgba(0, 122, 255, 1)"
              alignment="right" // Displays woman's image on the right
            />
            <div style={{ height: "5px" }}></div>
            <ChatBubble
             score={parseFloat((score * 10).toFixed(2))}
              color="rgba(220, 220, 220, 1)"
              alignment="left" // Displays man's image on the left
            />
            <div style={{ height: "3px" }}></div>
            <hr
              style={{
                width: "100%",
                border: "1px solid #ddd",
                margin: "20px 0",
              }}
            />
            <div style={{ height: "3px" }}></div>
            <ResultChatBubble   score={parseFloat((score * 10).toFixed(2))} color="rgba(52, 199, 89, 1)" />
            <div style={{ height: "15px" }}></div>
            <div
              style={{
                ...AppFonts.caution(i18n.language),
                textAlign: "center",
              }}
            >
              {t("caution")}
            </div>
            <div style={{ height: "20px" }}></div>
            <CustomButton
              textKey="retry"
              buttonColor="black"
              textColor="white"
              language={i18n.language}
              onClick={() => setIsPopupVisible(true)} 
            />

            <div style={{ height: "10px" }}></div>
            <CustomButton
              textKey="share"
              buttonColor="rgba(204, 204, 204, 1)"
              textColor="black"
              language={i18n.language}
              onClick={() => {
                if (navigator.share) {
                  navigator
                    .share({
                      title: "Kissing Booth AI",
                      text: "!",
                      url: "https://kissing-booth-ai.com",
                    })
                    .then(() => console.log("Sharing successful"))
                    .catch((error) => console.error("Error sharing", error));
                } else {
                  console.error(
                    "Web Share API is not supported in this browser."
                  );
                }
              }}
            />
            <div style={{ height: "10px" }}></div>
            <CustomButton
              textKey="ranking"
              buttonColor="rgba(204, 204, 204, 1)"
              textColor="black"
              language={i18n.language}
              onClick={() => {
                navigate("/nickname", { state: { userId } });
              }}
            />
          </div>
        </div>
      </main>
      {!isMobile && <div style={{ width: "30px" }}></div>}
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

export default ResultPage;
