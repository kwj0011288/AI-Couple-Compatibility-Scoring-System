import { AppFonts } from "../styles/fonts";
import { useTranslation } from "react-i18next";

interface TitleProps {
  textKey: string; // 번역 키를 받도록 수정
}

export default function Title({ textKey }: TitleProps) {
  const { t, i18n } = useTranslation(); // useTranslation 훅 사용
  const language = i18n.language; // 현재 언어 가져오기 ('en', 'ko', 등)
  const translatedText = t(textKey); // 번역된 텍스트

  // 디버깅 로그 추가
  //console.log(`[DEBUG] language: ${language}, textKey: ${textKey}, translatedText: ${translatedText}`);

  return (
    <h1
      className="text-center"
      style={AppFonts.title(language)} // AppFonts.title 스타일 적용
    >
      {translatedText} {/* 번역 키를 이용해 텍스트 렌더링 */}
    </h1>
  );
}
