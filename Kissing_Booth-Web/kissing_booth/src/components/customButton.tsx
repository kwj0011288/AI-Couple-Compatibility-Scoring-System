import React from "react";
import { AppFonts } from "../styles/fonts";
import { useTranslation } from "react-i18next";

interface CustomButtonProps {
  textKey: string; // Translation key for the button text
  buttonColor: string; // Button background color
  textColor: string; // Button text color
  language: string; // Language for font and translation
  onClick: () => void; // Callback function for button click
}

const CustomButton: React.FC<CustomButtonProps> = ({
  textKey,
  buttonColor,
  textColor,
  language,
  onClick,
}) => {
  const { t } = useTranslation(); // useTranslation hook for translations
  const translatedText = t(textKey); // Translated button text

  // Debugging log
  console.log(`[DEBUG] language: ${language}, textKey: ${textKey}, translatedText: ${translatedText}`);

  return (
    <button
      onClick={onClick}
      style={{
        backgroundColor: buttonColor, // Button background color
        ...AppFonts.button(textColor, language), // Dynamic font style from AppFonts
        padding: "15px 20px", // 상하, 좌우 패딩
        border: "none", // 테두리 없음
        borderRadius: "50px", // 둥근 모서리
        cursor: "pointer", // 클릭 시 포인터 표시
        transition: "background-color 0.3s ease", // 부드러운 전환 효과
        display: "inline-block", // 텍스트 길이에 따라 버튼이 늘어나도록 설정
        textAlign: "center", // 텍스트 중앙 정렬
        minWidth: "300px", // 최소 너비
        maxWidth: "100%", // 최대 너비 (부모 요소의 100%)
        height: "60px", // 고정 높이
        whiteSpace: "nowrap", // 텍스트 줄바꿈 방지
        overflow: "hidden", // 텍스트가 넘칠 경우 숨김
        textOverflow: "ellipsis", // 넘치는 텍스트는 말줄임표 처리
        boxShadow: "0px 4px 6px rgba(0, 0, 0, 0.1)", // Slight shadow for better visibility
      }}
      className="hover:opacity-90 focus:ring-2 focus:ring-offset-2 focus:outline-none"
    >
      {translatedText}
    </button>
  );
};

export default CustomButton;
