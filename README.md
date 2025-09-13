# AI Couple Compatibility Scoring System (Kissing Booth)

A comprehensive AI-powered platform that analyzes couple compatibility through facial recognition and machine learning algorithms. The system provides compatibility scores and rankings through multiple platform implementations.

## 📋 Table of Contents

- [🌟 Overview](#-overview)
- [📱 Screenshots](#-screenshots)
- [🌐 Language Support](#-language-support)
- [🏗️ Project Structure](#️-project-structure)
- [📱 Applications](#-applications)
- [🚀 Key Features](#-key-features)
- [🛠️ Technical Stack](#️-technical-stack)
- [📊 Application Flow](#-application-flow)
- [🌍 Supported Platforms](#-supported-platforms)
- [🔧 Backend API Functions](#-backend-api-functions)
- [📈 Features in Detail](#-features-in-detail)
- [🔒 Privacy & Security](#-privacy--security)
- [📱 App Store Information](#-app-store-information)

## 🌟 Overview

The Kissing Booth project is an innovative AI-driven application that evaluates romantic compatibility between couples using advanced facial recognition technology. Users can upload photos of themselves and their partners to receive an AI-generated compatibility score along with personalized feedback messages.

## 📱 Screenshots

<div align="center">
  <img src="Kissing-Booth Icon/screenshot1.png" alt="App Screenshot 1" width="250" style="margin: 10px;"/>
  <img src="Kissing-Booth Icon/screenshot2.png" alt="App Screenshot 2" width="250" style="margin: 10px;"/>
  <img src="Kissing-Booth Icon/screenshot3.png" alt="App Screenshot 3" width="250" style="margin: 10px;"/>
</div>

## 🌐 Language Support

The application supports multiple languages to provide a localized experience for users worldwide:

| Language | Code | Status |
|----------|------|--------|
| 🇺🇸 English | en-US | ✅ Supported |
| 🇰🇷 Korean | ko-KR | ✅ Supported |
| 🇯🇵 Japanese | ja-JP | ✅ Supported |
| 🇨🇳 Chinese | zh-CN | ✅ Supported |

- **Automatic Language Detection**: The app automatically detects the user's preferred language based on their device settings
- **Complete Localization**: All UI elements, messages, and compatibility results are fully translated
- **Cultural Adaptation**: Compatibility messages are culturally adapted for each language
- **Easy Language Switching**: Users can manually change languages within the app

## 🏗️ Project Structure

This repository contains three main components:

```
AI-Couple-Compatibility-Scoring-System/
├── Kissing_Booth-FE/          # Flutter Mobile Application
├── Kissing_Booth-Web/         # React Web Application  
├── Kissing_Booth-BE/          # Backend API (Django/Python)
└── Kissing-Booth Icon/        # App Icons and Assets
```

## 📱 Applications

### 1. Mobile App (Flutter)
- **Location**: `Kissing_Booth-FE/`
- **Framework**: Flutter (Dart)
- **Platforms**: iOS, Android, Web, macOS, Windows, Linux
- **Features**:
  - Cross-platform compatibility
  - Image compression and processing
  - Real-time AI analysis
  - Multilingual support (English, Korean, Japanese, Chinese)
  - Animated UI with Lottie animations
  - Google Mobile Ads integration
  - Ranking system with leaderboards

### 2. Web Application (React)
- **Location**: `Kissing_Booth-Web/`
- **Framework**: React with TypeScript
- **Features**:
  - Responsive web design
  - Modern UI with Material-UI and Tailwind CSS
  - Framer Motion animations
  - Multi-language support
  - Progressive Web App capabilities
  - SEO optimization with React Helmet

### 3. Backend API
- **Location**: `Kissing_Booth-BE/`
- **Framework**: Django (Python)
- **Features**:
  - RESTful API endpoints
  - AI/ML model integration
  - User data management
  - Ranking and statistics system
  - Image processing and storage

## 🚀 Key Features

### AI Compatibility Analysis
- Advanced facial recognition algorithms
- Machine learning-based compatibility scoring
- Real-time image processing and compression
- Personalized compatibility messages (10 different score ranges)

### Multi-Platform Support
- Native mobile apps for iOS and Android
- Responsive web application
- Desktop support (Windows, macOS, Linux)

### Internationalization
- Support for 4 languages: English, Korean, Japanese, Chinese
- Localized user interfaces and messages
- Cultural adaptation of content

### User Experience
- Intuitive photo upload interface
- Real-time loading animations
- Interactive heart animations and visual feedback
- Comprehensive ranking and leaderboard system
- Social sharing capabilities

### Monetization
- Google AdMob integration
- Strategic ad placement
- User engagement tracking

## 🛠️ Technical Stack

### Frontend Technologies
- **Mobile**: Flutter, Dart
- **Web**: React, TypeScript, Vite
- **UI Libraries**: Material-UI, Tailwind CSS, Styled Components
- **Animations**: Lottie, Framer Motion
- **State Management**: Provider (Flutter), React Context

### Backend Technologies
- **Framework**: Django, Django REST Framework
- **Database**: PostgreSQL/SQLite
- **Image Processing**: PIL/Pillow
- **AI/ML**: TensorFlow/PyTorch integration
- **Cloud Storage**: AWS S3 (implied from boto3)

### Development Tools
- **Mobile**: Android Studio, Xcode
- **Web**: VS Code, ESLint, TypeScript
- **Version Control**: Git
- **Package Management**: pub (Dart), npm (Node.js), pip (Python)

## 📊 Application Flow

1. **Photo Upload**: Users upload photos of themselves and their partner
2. **Image Processing**: Photos are compressed and optimized for AI analysis
3. **AI Analysis**: Facial recognition and compatibility algorithms process the images
4. **Score Generation**: AI generates a compatibility score (0-10 scale)
5. **Results Display**: Users receive their score with personalized messages
6. **Ranking System**: Scores are added to global leaderboards
7. **Social Sharing**: Users can share their results

## 🌍 Supported Platforms

### Mobile Platforms
- iOS (iPhone, iPad)
- Android (Phones, Tablets)

### Web Platforms
- Chrome, Firefox, Safari, Edge
- Progressive Web App (PWA) support

### Desktop Platforms
- Windows
- macOS
- Linux

## 🔧 Backend API Functions
### Core Endpoints

| Endpoint | Method | Description | Parameters |
|----------|--------|-------------|------------|
| `/matches/` | POST | **AI Compatibility Analysis** - Processes couple photos and returns compatibility score | `user_id`, `photo1`, `photo2` |
| `/matches/register-nickname/` | POST | **User Registration** - Registers user nickname and returns ranking | `user_id`, `nickname` |
| `/matches/rankings/` | GET | **Leaderboard Data** - Retrieves paginated ranking list | `offset`, `limit` |
| `/matches/total-users/` | GET | **User Statistics** - Returns total user counts | None |

### API Function Details

#### 🤖 AI Compatibility Analysis
- **Purpose**: Core AI function that analyzes facial features and calculates compatibility
- **Process**: 
  - Receives two photos via multipart form data
  - Applies facial recognition algorithms
  - Generates compatibility score (0.0-10.0)
  - Returns processed photo URLs and score
- **Response**: `{ photo1_url, photo2_url, score }`

#### 👤 User Registration & Ranking
- **Purpose**: Manages user nicknames and calculates rankings
- **Process**:
  - Associates user ID with chosen nickname
  - Calculates user's ranking position
  - Validates nickname availability
- **Response**: User ranking data and position

#### 🏆 Leaderboard Management
- **Purpose**: Provides paginated access to global rankings
- **Features**:
  - Supports pagination with offset/limit
  - UTF-8 encoding for international nicknames
  - Real-time ranking updates
- **Response**: Paginated list of top-scoring users

#### 📊 User Statistics
- **Purpose**: Tracks platform engagement metrics
- **Metrics**:
  - `total_nickname`: Users with registered nicknames
  - `total_no_nickname`: Anonymous users
- **Usage**: Displays active user count on homepage

### Technical Implementation
- **Framework**: Django REST Framework
- **Authentication**: User ID-based tracking
- **File Handling**: Multipart form data for image uploads
- **Encoding**: UTF-8 support for international characters
- **Error Handling**: Comprehensive HTTP status codes and error messages

## 📈 Features in Detail

### Compatibility Scoring System
- **Range**: 0.0 - 10.0 scoring system
- **Categories**: 10 different compatibility levels with unique messages
- **Personalization**: Culturally adapted responses based on user language

### Ranking & Leaderboard
- Global user rankings
- Real-time user count display
- Nickname-based identification system
- Privacy-focused data handling

### Image Processing
- Automatic image compression
- JPG conversion for optimization
- Face detection and validation
- Secure image handling (not stored on servers)

### Monetization Strategy
- Google AdMob integration
- Non-intrusive ad placement
- User engagement optimization

## 🔒 Privacy & Security

- Images are processed but not permanently stored
- User data anonymization
- GDPR compliance considerations
- Secure API communications

## 📱 App Store Information

- **App Name**: AI Couple Match / Kissing Booth
- **Category**: Entertainment / Lifestyle
- **Target Audience**: Couples, Dating app users
- **Age Rating**: 12+ (Teen)

<!-- ## 🤝 Contributing

This appears to be a commercial application. For contribution guidelines, please refer to the project maintainers.

## 📄 License

Please refer to the project's license file for usage rights and restrictions.

## 📞 Support

For technical support or business inquiries, please contact the development team through the appropriate channels. -->

---

*This AI-powered compatibility system represents a modern approach to relationship analysis, combining advanced machine learning with user-friendly interfaces across multiple platforms.*