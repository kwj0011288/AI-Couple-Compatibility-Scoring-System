import { RankingsResponse } from "../types/users";

const BASE_URL = "https://api.kissing-booth-ai.com";

export const ApiService = {
  async getCoupleScore(userId: string, photo1File: File, photo2File: File) {
    const apiUrl = `${BASE_URL}/matches/`;
    const formData = new FormData();

    formData.append("user_id", userId);
    formData.append("photo1", photo1File);
    formData.append("photo2", photo2File);

    try {
      const response = await fetch(apiUrl, {
        method: "POST",
        body: formData,
      });

      if (response.ok) {
        const data = await response.json();
        return {
          photo1_url: data.photo1_url,
          photo2_url: data.photo2_url,
          score: data.score,
        };
      } else {
        const errorText = await response.text();
        throw new Error(
          `Failed to upload photos: ${response.status} ${errorText}`
        );
      }
    } catch (error) {
      console.error("Error uploading photos:", error);
      throw error;
    }
  },

  async getUserRanking(userId: string, nickname: string) {
    const apiUrl = `${BASE_URL}/matches/register-nickname/`;

    const requestBody = {
      user_id: userId,
      nickname: nickname,
    };

    try {
      const response = await fetch(apiUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(requestBody),
      });

      if (response.ok) {
        const data = await response.json();
        return data;
      } else {
        const errorText = await response.text();
        throw new Error(
          `Failed to fetch user ranking: ${response.status} ${errorText}`
        );
      }
    } catch (error) {
      console.error("Error fetching user ranking:", error);
      throw error;
    }
  },
  async getTotalRankings(
    offset: number = 0,
    limit: number = 10
  ): Promise<RankingsResponse> {
    const apiUrl = `${BASE_URL}/matches/rankings/?offset=${offset}&limit=${limit}`;

    try {
      const response = await fetch(apiUrl, { method: "GET" });

      if (response.ok) {
        const data = await response.json();
        console.log("API Response:", data);

        // 응답이 RankingsResponse 타입인지 확인
        if (
          !data ||
          typeof data.next_offset === "undefined" ||
          !Array.isArray(data.results)
        ) {
          throw new Error("Invalid response format.");
        }

        return data as RankingsResponse;
      } else {
        throw new Error(`Failed to load rankings: ${response.status}`);
      }
    } catch (error) {
      console.error("Error loading rankings:", error);
      throw error;
    }
  },
  async getTotalUsers() {
    const apiUrl = `${BASE_URL}/matches/total-users/`;

    try {
      const response = await fetch(apiUrl, {
        method: "GET",
      });

      if (response.ok) {
        const data = await response.json();
        return {
          total_nickname: data.total_nickname,
          total_no_nickname: data.total_no_nickname,
        };
      } else {
        const errorText = await response.text();
        throw new Error(
          `Failed to fetch total users: ${response.status} ${errorText}`
        );
      }
    } catch (error) {
      console.error("Error fetching total users:", error);
      throw error;
    }
  },
};
