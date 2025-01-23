import i18n from "i18next";
import { initReactI18next } from "react-i18next";

import en from "../locales/en/translation.json";
import ko from "../locales/ko/translation.json";
import ja from "../locales/ja/translation.json";
import zh from "../locales/zh/translation.json";

i18n.use(initReactI18next).init({
  resources: {
    en: { translation: en },
    ko: { translation: ko },
    ja: { translation: ja },
    zh: { translation: zh },
  },
  lng: navigator.language.split("-")[0] || "en", // 브라우저 언어 감지, 기본값은 영어
  fallbackLng: "en", // 설정된 언어가 없을 경우 사용할 언어
  interpolation: {
    escapeValue: false, // React에서 XSS 방지를 위한 escaping이 필요 없음
  },
  debug: false,
});

//console.log("[DEBUG] i18n initialized with resources:", i18n.options.resources);

export default i18n;
