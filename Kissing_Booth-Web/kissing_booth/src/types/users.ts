export interface RankingsResponse {
    offset: number;
    limit: number;
    total_entries: number;
    next_offset: number | null;
    results: Users[];
  }
  
  export interface Users {
    photo1_url: string;
    photo2_url: string;
    user_id: string;
    nickname: string;
    ranking: number;
    score: number;
  }
  