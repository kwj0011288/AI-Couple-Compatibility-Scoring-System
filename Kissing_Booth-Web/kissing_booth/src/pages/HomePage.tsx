import React, { useEffect, useState } from "react";
import "../locales/i18n"; // i18n initialization
import { useTranslation } from "react-i18next";
import Title from "../components/Title";
import LanguageSwitcher from "../components/LanguageButton";
import welcomeImage from "../assets/illustrations/welcome.png";
import loadingHeart from "../assets/lottie/heart_loading.json";
import heartConnectioin from "../assets/lottie/connection.json";
import imageCompression from "browser-image-compression";
import Subtitle from "../components/subTitle";
import { AppFonts } from "../styles/fonts";
import CustomButton from "../components/customButton";
import { ApiService } from "../api/apiServies"; // Import the API service
import PolicyTerms from "../components/footer";
import Lottie from "react-lottie-player";
import Favorite from "@mui/icons-material/Favorite";
import { useNavigate } from "react-router-dom";
import RankingButton from "../components/RankingButton";
import { Helmet } from "react-helmet-async";
// import GoogleAd from "../ads/googleads";
// import PopupAd from "../ads/popupads";
// import BannerAd from "../ads/bannerAds";
import TotalRankingText from "../components/ResultPage/TotalUser";

const HomePage: React.FC = () => {
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();
  const randomWelcomeKey = `welcome_${Math.floor(Math.random() * 5) + 1}`;
  const randomWelcomeMessage = t(randomWelcomeKey, {
    defaultValue: "welcome_1",
  });

  const [myPhoto, setMyPhoto] = useState<File | null>(null);
  const [partnerPhoto, setPartnerPhoto] = useState<File | null>(null);
  const [loading, setLoading] = useState(false); // State for loading screen
  const [userId, setUserId] = useState<string>(""); // State for the generated UUID
  // const [isPopupVisible, setIsPopupVisible] = useState(false);
  const [isMobile, setIsMobile] = useState(false); // State for detecting mobile devices
  const [totalNoNickname, setTotalNoNickname] = useState<number | null>(null); // 닉네임이 있는 사용자

  useEffect(() => {
    const generateUUIDWithDate = () => {
      const uuid =
        typeof crypto !== "undefined" && typeof crypto.randomUUID === "function"
          ? crypto.randomUUID()
          : "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (c) => {
              const r = (Math.random() * 16) | 0;
              const v = c === "x" ? r : (r & 0x3) | 0x8;
              return v.toString(16);
            });
      const now = new Date();
      const formattedDate = now
        .toISOString()
        .replace(/T/, " ")
        .replace(/\..+/, "");
      return `${uuid}/${formattedDate}`.replace(/\s+/g, ""); // Remove all whitespace from final string
    };
    const setLanguageBasedOnDevice = () => {
      // 지원하는 언어 목록
      const supportedLanguages = ["en", "ko", "ja", "zh"];

      // navigator.languages 배열로부터 언어 우선순위 가져오기
      const browserLanguages = navigator.languages || [navigator.language];
      const primaryLanguage = browserLanguages[0]?.split("-")[0] || "en"; // 첫 번째 언어 추출

      // 지원되는 언어인지 확인하고 설정
      if (supportedLanguages.includes(primaryLanguage)) {
        i18n.changeLanguage(primaryLanguage);
      } else {
        i18n.changeLanguage("en"); // 기본값: 영어
      }

      console.log("Browser languages:", browserLanguages);
      console.log("Primary language:", primaryLanguage);
      console.log("i18n current language:", i18n.language);
    };

    const detectMobile = () => {
      const isMobileDevice = window.innerWidth <= 768;
      setIsMobile(isMobileDevice);
    };
    // UUID 생성 및 저장
    const generatedUserId = generateUUIDWithDate();
    setUserId(generatedUserId); // Save the UUID to state
    console.log("Generated User ID:", generatedUserId); // Log the generated UUID
    console.log("Generated User ID Length:", generatedUserId.length);

    // 언어 설정
    setLanguageBasedOnDevice();
    detectMobile();
    window.addEventListener("resize", detectMobile);

    return () => {
      window.removeEventListener("resize", detectMobile);
    };
  }, [i18n]);

  useEffect(() => {
    try {
      (window.adsbygoogle = window.adsbygoogle || []).push({});
    } catch (e) {
      console.error("Adsbygoogle error:", e);
    }
  }, []);

  // const handleRankingClick = () => {
  //   setIsPopupVisible(true);
  // };

  // const handleClosePopup = () => {
  //   setIsPopupVisible(false);
  //   navigate("/rankingTotal");
  // };

  const fetchTotalNickname = async () => {
    const data = await ApiService.getTotalUsers();
    setTotalNoNickname(data.total_no_nickname); // 닉네임이 있는 사용자 수만 가져옴
  };

  useEffect(() => {
    fetchTotalNickname();
  }, []);

  const handleFileSelect = async (
    e: React.ChangeEvent<HTMLInputElement>,
    setPhoto: React.Dispatch<React.SetStateAction<File | null>>
  ) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];

      try {
        // 압축 옵션 설정
        const options = {
          maxSizeMB: 1, // 최대 크기 1MB
          maxWidthOrHeight: 1024, // 최대 너비 또는 높이 1024px
          useWebWorker: true, // WebWorker 사용
        };

        console.log(
          "Original File Size:",
          (file.size / 1024 / 1024).toFixed(2),
          "MB"
        );

        // 이미지 압축
        const compressedFile = await imageCompression(file, options);

        const convertedFile = await convertToJpg(compressedFile);

        // 변환된 파일을 상태에 저장
        setPhoto(convertedFile);
      } catch (error) {
        console.error("Error compressing file:", error);
      }
    }
  };

  // 이미지 파일을 JPG로 변환하는 함수
const convertToJpg = async (file: File): Promise<File> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => {
      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement("canvas");
        const ctx = canvas.getContext("2d");
        if (!ctx) {
          reject(new Error("Failed to get canvas context"));
          return;
        }
        canvas.width = img.width;
        canvas.height = img.height;
        ctx.drawImage(img, 0, 0);

        canvas.toBlob(
          (blob) => {
            if (blob) {
              const jpgFile = new File([blob], file.name.replace(/\.\w+$/, ".jpg"), {
                type: "image/jpeg",
              });
              resolve(jpgFile);
            } else {
              reject(new Error("Failed to convert image to JPG"));
            }
          },
          "image/jpeg",
          0.95 // 이미지 품질 (0~1)
        );
      };
      img.src = reader.result as string;
    };
    reader.onerror = (err) => reject(err);
    reader.readAsDataURL(file);
  });
};

  const removePhoto = (
    setPhoto: React.Dispatch<React.SetStateAction<File | null>>
  ) => {
    setPhoto(null);
  };

  const handleNextClick = async () => {
    if (myPhoto && partnerPhoto) {
      try {
        setLoading(true);

        const result = await ApiService.getCoupleScore(
          userId,
          myPhoto,
          partnerPhoto
        );
        console.log("API Result:", result);
        navigate("/result", {
          state: {
            photo1_url: result.photo1_url,
            photo2_url: result.photo2_url,
            score: parseFloat(result.score.toFixed(6)),
            id: userId,
          },
        });
      } catch (error) {
        console.error("Error during API call:", error);
      } finally {
        setLoading(false);
      }
    } else {
      console.error("Both photos must be selected before proceeding.");
    }
  };

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
      <Helmet>
        <title>{t("title")}</title>
        <meta name="description" content={t("subtitle")} />
        <meta property="og:title" content={t("title")} />
        <meta property="og:description" content={t("subtitle")} />
        <meta property="og:image" content={welcomeImage} />
        <meta property="og:url" content="https://kissing-booth-ai.com" />

        <meta name="twitter:card" content={welcomeImage} />
        <meta name="twitter:title" content={t("title")} />
        <meta name="twitter:description" content={t("subtitle")} />
        <meta name="twitter:image" content={welcomeImage} />

        {/* <meta name="google-adsense-account" content="ca-pub-2674925873094012" /> */}
      </Helmet>
      {loading ? (
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
          {/* Lottie Animations */}
          <Lottie
            loop
            animationData={loadingHeart}
            play
            style={{ width: 400, height: 400 }} // Size of the animation
          />
          <p style={{ ...AppFonts.loading(i18n.language), marginTop: "10px" }}>
            {t("uploading")} {/* Optional loading message */}
          </p>
        </div>
      ) : (
        <main
          style={{
            width: isMobile ? "100%" : "70%",
            maxWidth: "500px",
            padding: "10px",
            boxShadow: "0 4px 10px rgba(0, 0, 0, 0.1)",
            borderRadius: "10px",
            backgroundColor: "rgba(244, 244, 248, 1)",
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            minHeight: "100vh", // Ensure at least full screen height
            height: "auto", // Allow height to grow with content
          }}
        >
          <div style={{ height: "15px" }}></div>
          <div
            style={{
              width: "100%",
              display: "flex",
              justifyContent: "center",

              gap: "5px",
            }}
          >
            <LanguageSwitcher />
          </div>
          <div style={{ height: "10px" }}></div>
          <div className="text-center w-full">
            <Title textKey="title" />
            <div style={{ height: "7px" }}></div>
            <Subtitle textKey="subtitle" />
            <div style={{ height: "10px" }}></div>
            <RankingButton
              textKey="ranking"
              buttonColor="rgba(204, 204, 204, 1)"
              textColor="black"
              language={i18n.language}
              // onClick={handleRankingClick}
              onClick={() => navigate("/rankingTotal")}
            />
            <div style={{ height: "15px" }}></div>
            {totalNoNickname === null ? (
              <div
                style={{
                  display: "flex",
                  flexDirection: "column",
                  justifyContent: "center",
                  alignItems: "center",
                  textAlign: "center",
                  margin: "20px 0",
                }}
              >
                <p
                  style={{
                    ...AppFonts.loading(i18n.language),
                    marginTop: "10px",
                  }}
                >
                  {" "}
                  {/* 로딩 메시지 */}
                </p>
              </div>
            ) : (
              <TotalRankingText
                textKey="total_users"
                count={totalNoNickname!}
              />
            )}
            <div
              style={{
                position: "relative", // 부모 컨테이너 기준
                width: "100%", // 전체 너비
                maxWidth: "500px", // 최대 너비 설정
              }}
            >
              {/* 첫 번째 DIV: Welcome Image와 Welcome Message */}
              <div
                style={{
                  position: "relative", // 텍스트와 이미지를 겹치기 위한 기준
                  width: "100%",
                  borderRadius: "10px",
                  overflow: "hidden",
                }}
              >
                {/* Welcome Image */}
                <img
                  src={welcomeImage}
                  alt="WelcomeImage"
                  style={{
                    display: "block",
                    width: "90%", // 컨테이너 너비에 맞춤
                    height: "auto", // 비율 유지
                    margin: "0 auto", // 중앙 정렬
                    borderRadius: "10px", // 모서리 둥글게
                  }}
                />

                {/* Welcome Message */}
                <p
                  style={{
                    ...AppFonts.subtitle3(i18n.language),
                    position: "absolute",
                    top: "15%", // 이미지의 상단 기준
                    left: "50%", // 이미지 가로 중앙
                    transform: "translate(-50%, -50%)", // 정확한 중앙 정렬
                    fontWeight: "bold",
                    textAlign: "center",
                    margin: "0",
                    padding: "20px",
                    width: "100%",
                    maxWidth: "500px",
                    borderRadius: "10px", // 모서리 둥글게
                  }}
                >
                  {randomWelcomeMessage}
                </p>
              </div>
              {(!myPhoto || !partnerPhoto) && (
                <div style={{ height: "15px" }}></div>
              )}

              {/* 두 번째 DIV: Lottie, Favorite, 그리고 Photos */}
              <div
                style={{
                  position: "absolute", // 첫 번째 DIV 위에 겹치도록 설정
                  top: "0", // 첫 번째 DIV의 상단에 위치
                  left: "0",
                  width: "100%", // 부모 컨테이너에 맞춤
                  height: "100%", // 첫 번째 DIV에 맞게 높이 설정
                  display: "flex",
                  flexDirection: "column",
                  justifyContent: "center",
                  alignItems: "center",
                }}
              >
                {/* Lottie Animation */}
                {myPhoto && partnerPhoto && (
                  <div
                    style={{
                      position: "relative", // Lottie와 Favorite의 기준 컨테이너
                      width: "70%",
                      maxWidth: "300px",
                      marginTop: isMobile ? "300px" : "350px",
                    }}
                  >
                    {/* Lottie Animation */}
                    <Lottie
                      loop
                      animationData={heartConnectioin}
                      play
                      style={{
                        width: "100%",
                        height: "auto",
                      }}
                    />

                    {/* Favorite Icon */}
                    <div
                      style={{
                        position: "absolute", // Lottie 중앙에 배치하기 위한 설정
                        top: "50%", // Lottie의 세로 중앙
                        left: "50%", // Lottie의 가로 중앙
                        transform: "translate(-50%, -50%)", // 정확한 중앙 정렬
                        zIndex: 1, // Lottie보다 위에 배치
                      }}
                    >
                      <Favorite
                        style={{
                          fontSize: 80,
                          color: "rgba(237, 102, 169, 1)",
                        }}
                      />
                    </div>
                  </div>
                )}

                {/* My Photo */}
                {myPhoto && (
                  <div
                    style={{
                      position: "absolute",
                      top: "100%",
                      left: "25%",
                      transform: "translate(-50%, -50%)",
                      width: "100px",
                      height: "100px",
                    }}
                  >
                    <img
                      src={URL.createObjectURL(myPhoto)}
                      alt="My Selected"
                      style={{
                        width: "100%",
                        height: "100%",
                        borderRadius: "20px",
                        objectFit: "cover",
                      }}
                    />
                    <button
                      onClick={() => removePhoto(setMyPhoto)}
                      style={{
                        position: "absolute",
                        top: "50%",
                        left: "50%",
                        transform: "translate(-50%, -50%)",
                        backgroundColor: "rgba(0, 0, 0, 0.7)",
                        color: "white",
                        border: "none",
                        borderRadius: "50%",
                        width: "35px",
                        height: "35px",
                        display: "flex",
                        justifyContent: "center",
                        alignItems: "center",
                        cursor: "pointer",
                        fontSize: "10px",
                        fontWeight: "bold",
                      }}
                    >
                      ━
                    </button>
                  </div>
                )}

                {/* Partner Photo */}
                {partnerPhoto && (
                  <div
                    style={{
                      position: "absolute",
                      top: "100%",
                      left: "75%",
                      transform: "translate(-50%, -50%)",
                      width: "100px",
                      height: "100px",
                    }}
                  >
                    <img
                      src={URL.createObjectURL(partnerPhoto)}
                      alt="Partner Selected"
                      style={{
                        width: "100%",
                        height: "100%",
                        borderRadius: "20px",
                        objectFit: "cover",
                      }}
                    />
                    <button
                      onClick={() => removePhoto(setPartnerPhoto)}
                      style={{
                        position: "absolute",
                        top: "50%",
                        left: "50%",
                        transform: "translate(-50%, -50%)",
                        backgroundColor: "rgba(0, 0, 0, 0.7)",
                        color: "white",
                        border: "none",
                        borderRadius: "50%",
                        width: "35px",
                        height: "35px",
                        display: "flex",
                        justifyContent: "center",
                        alignItems: "center",
                        cursor: "pointer",
                        fontSize: "10px",
                        fontWeight: "bold",
                      }}
                    >
                      ━
                    </button>
                  </div>
                )}
              </div>
            </div>
            {/* File Inputs */}{" "}
            <input
              type="file"
              accept="image/*"
              style={{ display: "none" }}
              id="myPhotoInput"
              onChange={(e) => handleFileSelect(e, setMyPhoto)}
            />
            <input
              type="file"
              accept="image/*"
              style={{ display: "none" }}
              id="partnerPhotoInput"
              onChange={(e) => handleFileSelect(e, setPartnerPhoto)}
            />
            {/* Conditional Buttons with Fade Animation */}
            <div
              style={{
                display: "flex",
                flexDirection: "column",
                gap: "10px",
                alignItems: "center",
              }}
            >
              <div
                className="fade-in"
                style={{
                  opacity: myPhoto ? 0 : 1,
                  visibility: myPhoto ? "hidden" : "visible",
                  transition: "opacity 0.5s, visibility 0.5s",
                  marginTop:
                    partnerPhoto && myPhoto
                      ? "40px"
                      : partnerPhoto
                      ? "55px"
                      : "0px",
                }}
              >
                <CustomButton
                  textKey="add_my_photo"
                  buttonColor="rgba(204, 204, 204, 1)"
                  textColor="black"
                  language={i18n.language}
                  onClick={() =>
                    document.getElementById("myPhotoInput")?.click()
                  }
                />
              </div>
              <div
                className="fade-in"
                style={{
                  opacity: partnerPhoto ? 0 : 1,
                  visibility: partnerPhoto ? "hidden" : "visible",
                  transition: "opacity 0.5s, visibility 0.5s",
                }}
              >
                <CustomButton
                  textKey="add_partner_photo"
                  buttonColor="rgba(204, 204, 204, 1)"
                  textColor="black"
                  language={i18n.language}
                  onClick={() =>
                    document.getElementById("partnerPhotoInput")?.click()
                  }
                />
              </div>

              {myPhoto && partnerPhoto && (
                <div
                  className="fade-in"
                  style={{
                    opacity: 1,
                    visibility: "visible",
                    transition: "opacity 0.5s, visibility 0.5s",
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                    position: "relative",
                    marginTop: isMobile ? "-95px" : "-105px",
                  }}
                >
                  <CustomButton
                    textKey="next"
                    buttonColor="rgba(0, 122, 255, 1)"
                    textColor="white"
                    language={i18n.language}
                    onClick={handleNextClick}
                  />
                </div>
              )}
            </div>
          </div>
          <div style={{ height: isMobile ? "20px" : "20px" }}></div>
          <div style={{ width: "100%" }}>
            <PolicyTerms language={i18n.language} color={"grey"} />

            {/* <div style={{ marginTop: isMobile ? "20px" : "20px" }}>
              <BannerAd
                adClient="ca-pub-2674925873094012"
                adSlot="5237165212"
              />
            </div> */}
          </div>
        </main>
      )}
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

export default HomePage;
