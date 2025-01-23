import React from "react";
import { useTranslation } from "react-i18next";
import { AppFonts } from "../../styles/fonts"; // Assuming this is the path for AppFonts

interface ResultTextProps {
  text: string;
}

const ResultText: React.FC<ResultTextProps> = ({ text }) => {
  const {i18n } = useTranslation();
  const [mainText] = text.split(" "); // Extract the first part of the text

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <p
        style={{
          ...AppFonts.score1(i18n.language), // Main text styling
          marginTop: "0",
        }}
      >
        {mainText}
      </p>
      <p
        style={{
          ...AppFonts.score2(i18n.language), // Secondary text styling
          marginTop: "10px",
          marginLeft: "5px",

        }}
      >
         / 10
      </p>
    </div>
  );
};

export default ResultText;
