import React, { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import happyMan from "../../assets/illustrations/man_happy.png";
import neutralMan from "../../assets/illustrations/man_neutral.png";
import madMan from "../../assets/illustrations/man_mad.png";
import happyWoman from "../../assets/illustrations/girl_happy.png";
import neutralWoman from "../../assets/illustrations/girl_neutral.png";
import madWoman from "../../assets/illustrations/girl_mad.png";
import { AppFonts } from "../../styles/fonts"; // Adjust the path

interface ChatBubbleProps {
  score: number; // Score to determine emotion and character
  color: string; // Background color for the chat bubble
  alignment: "left" | "right"; // Determines if it's the girl (right) or guy (left)
}

const ChatBubble: React.FC<ChatBubbleProps> = ({ score, color, alignment }) => {
  const { t, i18n } = useTranslation(); // For translations and current language
  const isGirl = alignment === "right"; // Determines if the bubble is for the girl

  // State to hold the chat text
  const [chatText, setChatText] = useState("");

  // Function to determine emotion and character image
  const getImageAsset = (score: number, isGirl: boolean) => {
    let emotion: string;

    if (score >= 7) {
      emotion = "happy";
    } else if (score >= 4) {
      emotion = "neutral";
    } else {
      emotion = "mad";
    }

    const characterImage = isGirl
      ? { happy: happyWoman, neutral: neutralWoman, mad: madWoman }[emotion]
      : { happy: happyMan, neutral: neutralMan, mad: madMan }[emotion];

    return characterImage;
  };

  // Function to generate random chat messages
  const getRandomChatMessages = (score: number) => {
    let category = Math.floor(score);

    // Treat 0 as category 1
    if (category === 0) category = 1;

    // Treat 10 as category 9
    if (category === 10) category = 9;

    // Generate a single random index
    const randomIndex = Math.floor(Math.random() * 5) + 1; // Random number between 1 and 5
    return {
      send: t(`${category}_${randomIndex}_send`),
      receive: t(`${category}_${randomIndex}_receive`),
    };
  };

  useEffect(() => {
    // Set chat text based on score and alignment
    const messages = getRandomChatMessages(score);
    setChatText(isGirl ? messages.send : messages.receive);
  }, [score, isGirl, t]);

  // Get the character image based on alignment
  const characterImage = getImageAsset(score, isGirl);

  return (
    <div className="flex flex-col gap-6">
      {/* Girl's Bubble */}
      {isGirl && (
        <div className="flex gap-4 flex-row-reverse items-center">
          {/* Profile Image */}
          <div
            className="w-14 h-14 rounded-full flex items-center justify-center"
            style={{ backgroundColor: "rgba(235, 227, 209, 1)" }}
          >
            <img
              className="w-12 h-12 rounded-full"
              src={characterImage}
              alt="Girl"
            />
          </div>

          {/* Chat Bubble */}
          <div
            className="flex flex-col max-w-[320px] leading-1.5 p-2 rounded-xl"
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
      )}

      {/* Man's Bubble */}
      {!isGirl && (
        <div className="flex items-center gap-4">
          {/* Profile Image */}
          <div
            className="w-14 h-14 rounded-full flex items-center justify-center"
            style={{ backgroundColor: "rgba(213, 195, 235, 1)" }}
          >
            <img
              className="w-12 h-12 rounded-full"
              src={characterImage}
              alt="Man"
            />
          </div>

          {/* Chat Bubble */}
          <div
            className="flex flex-col max-w-[320px] leading-1.5 p-2 rounded-xl"
            style={{ backgroundColor: color }}
          >
            <p
              style={{
                ...AppFonts.chat("black", i18n.language),
                textAlign: "left",
              }}
            >
              {chatText}
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default ChatBubble;
