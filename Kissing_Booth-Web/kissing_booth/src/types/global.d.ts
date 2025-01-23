declare global {
    interface Window {
      adsbygoogle: unknown[];
    }
  }
  export {};
  

  declare namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: "development" | "production" | "test";
      // 필요한 환경 변수를 여기에 추가
    }
  }
  