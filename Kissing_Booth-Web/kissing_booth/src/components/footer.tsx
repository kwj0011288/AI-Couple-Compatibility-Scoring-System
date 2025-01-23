import React from "react";
import { AppFonts } from "../styles/fonts";
import { useTranslation } from "react-i18next";

interface PolicyTermsProps {
  language: string; // Language for font and translation
  color: string; // Text color
}

const PolicyTerms: React.FC<PolicyTermsProps> = ({ language, color }) => {
  const { t } = useTranslation();

  // Handler for opening Privacy Policy
  const handlePrivacyPolicy = () => {
    const url =
      "https://numerous-lunaria-be1.notion.site/Privacy-Policy-17516184b3088029855dfe46d87643ea?pvs=74";
    window.open(url, "_blank", "noopener,noreferrer");
  };

  // Handler for opening Terms of Use
  const handleTermsOfUse = () => {
    const url =
      "https://numerous-lunaria-be1.notion.site/Terms-Conditions-17516184b30880509dbef38b674476a2?pvs=4";
    window.open(url, "_blank", "noopener,noreferrer");
  };

  return (
    <div style={{ textAlign: "center", ...AppFonts.privacy(color, language) }}>
      <span style={AppFonts.privacy(color, language)}>{t("privacy_1")}</span>
      <span
        style={AppFonts.privacyUnderline(color, language)}
        onClick={handleTermsOfUse}
      >
        {t("privacy_2")}
      </span>
      <span style={AppFonts.privacy(color, language)}>{t("privacy_3")}</span>
      <span
        style={AppFonts.privacyUnderline(color, language)}
        onClick={handlePrivacyPolicy}
      >
        {t("privacy_4")}
      </span>
      <span style={AppFonts.privacy(color, language)}>{t("privacy_5")}</span>
    </div>
  );
};

export default PolicyTerms;
