export const AppFonts = {
    fontFamilyBold: (language: string): string => {
      return language === 'ja' ? 'SandBox_Bold' : 'SandBox_Bold';
    },
  
    fontFamilyMedium: (language: string): string => {
      return language === 'ja' ? 'SandBox_Medium' : 'SandBox_Medium';
    },
  
    fontFamilyLow: (language: string): string => {
      return language === 'ja' ? 'SandBox_Low' : 'SandBox_Low';
    },
  
    // Main Titles
    title: (language: string) => ({
      fontSize: '25px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),
    title2: (language: string) => ({
      fontSize: '20px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),
    title3: (language: string) => ({
      fontSize: '32px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#007bff',
    }),
    title4: (language: string) => ({
      fontSize: '45px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),
    title5: (language: string) => ({
      fontSize: '30px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),


    // Text input
    TextInput: (language: string) => ({
      fontSize: '25px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),

  
    // Subtitles
    subtitle: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: 'rgba(51, 51, 51, 0.5)',
    }),
    subtitle2: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: 'rgba(51, 51, 51, 0.5)',
    }),
    subtitle3: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyLow(language),
      letterspacing: '10px',
      color: '#333',
    }),
  
    // Buttons
    button: (color: string, language: string) => ({
      fontSize: '14px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: color,
    }),
    button2: (color: string, language: string) => ({
      fontSize: '13px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: color,
    }),
    cancelButton: (language: string) => ({
      fontSize: '20px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#ff4d4f',
    }),

    loading: (language: string) => ({
      fontSize: '20px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),
  
    // Warning and Alerts
    warningBox: (language: string) => ({
      fontSize: '10px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: '#333',
    }),
    warning: (language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: '#ff0000',
    }),
    contentWarning: (language: string) => ({
      fontSize: '14px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: '#333',
    }),
  
    // Ranking
    ranking: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#888',
    }),
    rankingTitle: (language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),
    rankingRate: (language: string) => ({
      fontSize: '25px',
      fontFamily: AppFonts.fontFamilyBold(language),
      color: '#333',
    }),
    rankingTotal: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),

    rankingTotal2: (language: string) => ({
      fontSize: '35px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),




  
    // Score
    score1: (language: string) => ({
      fontSize: '50px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#000',
    }),
    score2: (language: string) => ({
      fontSize: '30px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: 'rgba(51, 51, 51, 0.5)',
    }),
    currentMyScore: (language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),

    myScore: (language: string) => ({
      fontSize: '35px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),

    myScoreTotal: (language: string) => ({
      fontSize: '20px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),

    myScoreRate: (language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),



    //chat
    chat: (color: string, language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: color,
    }),  
    // Popups
    popupTitle: (language: string) => ({
      fontSize: '20px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#333',
    }),
    popupSubtitle: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#007bff',
    }),
    rankingCancel: (language: string) => ({
      fontSize: '15px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#007bff',
    }),
    retryRankingButton: (language: string) => ({
      fontSize: '20px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#fff',
    }),

    // Caution
    caution: (language: string) => ({
      fontSize: '10px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: 'black',
    }),
  
    // Privacy
    privacy: (color: string, language: string) => ({
      fontSize: '8px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: color,
    }),
    privacyUnderline: (color: string, language: string) => ({
      fontSize: '8px',
      fontFamily: AppFonts.fontFamilyLow(language),
      color: color,
      textDecoration: 'underline',
    }),

    TotalUser: (language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: '#34C759', 
    }),

    NicknameError: (language: string) => ({
      fontSize: '12px',
      fontFamily: AppFonts.fontFamilyMedium(language),
      color: 'red', 
    }),


  };
  