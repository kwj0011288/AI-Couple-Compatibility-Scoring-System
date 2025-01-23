import { Users } from "../types/users";
import firstImage from "../assets/illustrations/first.png";
import secondImage from "../assets/illustrations/second.png";
import thirdImage from "../assets/illustrations/third.png";
import { AppFonts } from "../styles/fonts"; // AppFonts 가져오기
import MadFace from "../assets/illustrations/man_mad.png";

interface RankingTileProps {
  users: Users;
}

export default function RankingTile({ users }: RankingTileProps) {
  const language = "en"; // 언어 설정 ('ja' 또는 'en')

  const getRankingImage = (ranking: number) => {
    switch (ranking) {
      case 1:
        return firstImage;
      case 2:
        return secondImage;
      case 3:
        return thirdImage;
      default:
        return null;
    }
  };

  const getImageStyle = (ranking: number) => {
    switch (ranking) {
      case 1:
      case 2:
      case 3:
        return "w-[40px] h-[40px]"; // 1~3위는 동일한 크기
      default:
        return "w-[30px] h-[30px]"; // 기본 크기
    }
  };

  const renderUserImage = (url: string | null) => (
    <img
      src={url || MadFace}
      alt="user"
      className="w-[40px] h-[40px] rounded-lg"
      onError={(e) => {
        (e.target as HTMLImageElement).src = MadFace; // Fallback to MadFace on error
      }}
    />
  );

  return (
    <>
      <div className="flex flex-row items-center rgba(244, 244, 250, 1) ml-1 mr-1 mb-4 mt-4 rounded-lg w-full">
        {/* 랭킹 이미지 */}
        <div className="flex items-center justify-center w-[15%] h-auto">
          {getRankingImage(users.ranking) ? (
            <img
              src={getRankingImage(users.ranking) || ""}
              alt={`rank${users.ranking}`}
              className={`${getImageStyle(users.ranking)} rounded-full`}
            />
          ) : (
            <p
              style={AppFonts.ranking(language)}
              className="text-center text-lg font-bold"
            >
              {users.ranking}
            </p>
          )}
        </div>

        {/* 사용자 이미지 */}
        <div className="flex flex-row items-center gap-2 ml-4 w-[33%]">
          {renderUserImage(users.photo1_url)}
          {renderUserImage(users.photo2_url)}
        </div>

        {/* 사용자 닉네임 */}
        <p
          className="ml-1 text-left truncate"
          style={{
            ...AppFonts.ranking(language),
            fontSize: "14px",
            maxWidth: "30%",
          }}
        >
          {users.nickname}
        </p>

        {/* 사용자 점수 */}
        <p
          className="ml-auto text-right"
          style={{
            ...AppFonts.ranking(language),
            fontSize: "14px",
            marginRight: "8px",
          }}
        >
          {users.score !== undefined ? (users.score * 10).toFixed(2) : "0.00"}
        </p>
      </div>

      {/* 숨겨진 Attribution Links */}
      <div hidden>
        <a href="https://www.flaticon.com/free-icons/medal" title="medal icons">
          Medal icons created by Freepik - Flaticon
        </a>
        <a
          href="https://www.flaticon.com/free-icons/second-place"
          title="second place icons"
        >
          Second place icons created by Freepik - Flaticon
        </a>
        <a
          href="https://www.flaticon.com/free-icons/third-place"
          title="third place icons"
        >
          Third place icons created by Freepik - Flaticon
        </a>
      </div>
    </>
  );
}
