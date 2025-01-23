import { AppFonts } from "../../styles/fonts";
import { useTranslation } from "react-i18next";

interface SubtitleProps {
    textKey: string; // 번역 키를 받도록 수정
    count?: number; // 추가된 count prop
}

export default function Subtitle({ textKey, count }: SubtitleProps) {
    const { t, i18n } = useTranslation(); // useTranslation 훅 사용
    const language = i18n.language; // 현재 언어 가져오기 ('en', 'ko', 등)
    const translatedText = t(textKey); // 번역된 텍스트

    // 디버깅 로그 추가
    // console.log(
    //   `[DEBUG] language: ${language}, textKey: ${textKey}, translatedText: ${translatedText}`
    // );

    return (
        <h2
            className="text-center"
            style={AppFonts.TotalUser(language)} // AppFonts.title 스타일 적용
        >
            <span style={{ display: 'inline-block', width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#34C759', marginRight: '8px' }}></span>
            {`${translatedText} ${count || ''}`} {/* textKey와 count를 결합하여 렌더링 */}
        </h2>
    );
}
