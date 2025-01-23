import React, { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import resultImage from "../../assets/illustrations/result.png";
import { AppFonts } from "../../styles/fonts";

// Define the props type
interface ResultChatBubbleProps {
  score: number; // Score must be a number
  color: string; // Background color for the chat bubble
}

const ResultChatBubble: React.FC<ResultChatBubbleProps> = ({ score, color }) => {
  const { t, i18n } = useTranslation(); // i18next hook for translations
  const [chatText, setChatText] = useState<string>(""); // State for chat text

  // Function to get random chat message key based on score
  const getRandomResultMessage = (score: number): string => {
    let category = Math.floor(score);

    // Treat 0 as category 1
    if (category === 0) category = 1;

    // Treat 10 as category 9
    if (category === 10) category = 9;

    // Generate a single random index
    const randomIndex = Math.floor(Math.random() * 5) + 1; // Random number between 1 and 5
    return `result${category}_${randomIndex}`;
  };

  useEffect(() => {
    // Fetch a random localized message from the translation file
    const resultKey = getRandomResultMessage(score);
    const translatedText = t(resultKey); // Use i18n translation function
    setChatText(translatedText);
  }, [score, t]);

  return (
    <div className="flex items-center gap-4 flex-row-reverse">
      {/* Profile Image */}
      <div
        className="w-14 h-14 rounded-full flex items-center justify-center"
        style={{ backgroundColor: "rgba(243, 226, 180, 1)" }}
      >
        <img
          className="w-12 h-12 rounded-full"
          src={resultImage}
          alt="Result"
        />
      </div>

      {/* Chat Bubble */}
      <div
        className="flex flex-col max-w-[320px] leading-1.5 p-2 border border-gray-200 rounded-xl"
        style={{ backgroundColor: color }}
      >
        <p
          style={{
            ...AppFonts.chat("white", i18n.language),
            textAlign: "left",
          }}
        >
          {chatText}
        </p>
      </div>
    </div>
  );
};

export default ResultChatBubble;
