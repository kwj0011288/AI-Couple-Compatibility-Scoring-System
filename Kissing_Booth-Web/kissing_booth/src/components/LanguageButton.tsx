import { useTranslation } from "react-i18next";

export default function LanguageSwitcher() {
  const { i18n } = useTranslation();

  // Language change function
  const changeLanguage = (lang: string) => {
    console.log(`[DEBUG] Changing language to: ${lang}`);
    i18n.changeLanguage(lang).then(() => {
      console.log(`[DEBUG] Current language after change: ${i18n.language}`);
    });
  };

  // Get the current selected language
  const currentLanguage = i18n.language;

  // Define the color for non-selected buttons
  const nonSelectedButtonColor = "bg-gray-100 text-gray-500 hover:bg-gray-200";

  return (
    <div className="inline-flex rounded-lg border border-gray-150 bg-gray-100 p-0.5">
      {/* Language Buttons */}
      <div className="p-0.5">
        <button
          className={`inline-block rounded-md px-3 py-1 text-xs transition-all duration-300 ${
            currentLanguage === "en"
              ? "bg-black text-white scale-105"
              : nonSelectedButtonColor
          } focus:relative`}
          onClick={() => changeLanguage("en")}
        >
          EN
        </button>
      </div>
      <div className="p-0.5">
        <button
          className={`inline-block rounded-md px-3 py-1 text-xs transition-all duration-300 ${
            currentLanguage === "ko"
              ? "bg-black text-white scale-105"
              : nonSelectedButtonColor
          } focus:relative`}
          onClick={() => changeLanguage("ko")}
        >
          한국어
        </button>
      </div>
      <div className="p-0.5">
        <button
          className={`inline-block rounded-md px-3 py-1 text-xs transition-all duration-300 ${
            currentLanguage === "ja"
              ? "bg-black text-white scale-105"
              : nonSelectedButtonColor
          } focus:relative`}
          onClick={() => changeLanguage("ja")}
        >
          日本語
        </button>
      </div>
      <div className="p-0.5">
        <button
          className={`inline-block rounded-md px-3 py-1 text-xs transition-all duration-300 ${
            currentLanguage === "zh"
              ? "bg-black text-white scale-105"
              : nonSelectedButtonColor
          } focus:relative`}
          onClick={() => changeLanguage("zh")}
        >
          中文
        </button>
      </div>
    </div>
  );
}
