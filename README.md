# 🚀 SpendWise - Smart Expense Tracker

A comprehensive Flutter expense tracking application with AI-powered insights, gamified achievements, and cross-platform support.

## 🌟 Features

### 📊 **Core Features**
- **Smart Dashboard** - Real-time financial overview
- **Transaction Management** - Add, edit, categorize expenses
- **Interactive Charts** - Visual spending analysis
- **AI Insights** - Personalized financial recommendations
- **Savings Goals** - Track and achieve financial targets
- **Gamification** - Badges and achievements system

### 📱 **Advanced Features**
- **Data Export** - CSV, PDF, and summary reports
- **Profile Management** - Customizable user profiles
- **Security Settings** - 2FA and privacy controls
- **Cross-Platform Sync** - Web, mobile, and desktop
- **Dark/Light Mode** - Beautiful UI themes

### 🎯 **Technical Features**
- **Responsive Design** - Works on all screen sizes
- **Offline Support** - Local data storage
- **Real-time Updates** - Live data synchronization
- **Performance Optimized** - Fast and smooth experience

## 🚀 Live Demo

**🌐 Web App**: [https://shiny-medovik-28bc07.netlify.app](https://shiny-medovik-28bc07.netlify.app)

## 📱 Screenshots

### Dashboard
![Dashboard](screenshots/dashboard.png)

### Charts & Analytics
![Charts](screenshots/charts.png)

### Profile & Settings
![Profile](screenshots/profile.png)

## 🛠️ Technology Stack

- **Framework**: Flutter 3.32.8
- **Language**: Dart
- **State Management**: Provider
- **Charts**: fl_chart
- **File Operations**: path_provider, file_picker
- **PDF Generation**: pdf package
- **UI Components**: Material Design 3
- **Deployment**: Netlify

## 📦 Installation

### Prerequisites
- Flutter SDK (3.32.8 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/spendwise-app.git
cd spendwise-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

4. **Build for production**
```bash
# Web
flutter build web --release

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/
│   └── expense_provider.dart # State management
├── screens/
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── profile_screen.dart
│   └── export_screen.dart
├── widgets/
│   ├── charts/
│   ├── forms/
│   └── common/
└── utils/
    ├── constants.dart
    └── helpers.dart
```

## 🚀 Deployment

### Web Deployment
```bash
# Build for web
flutter build web --release

# Deploy to Netlify
netlify deploy --prod --dir=build/web
```

### Mobile Deployment
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

## 📊 Key Features Explained

### 1. **Smart Dashboard**
- Real-time financial overview
- Income vs expense tracking
- Monthly/yearly comparisons
- Quick action buttons

### 2. **Interactive Charts**
- Line charts for trends
- Pie charts for categories
- Bar charts for comparisons
- Real-time data updates

### 3. **AI-Powered Insights**
- Spending pattern analysis
- Budget recommendations
- Savings suggestions
- Financial tips

### 4. **Gamification System**
- Achievement badges
- Progress tracking
- Milestone celebrations
- Motivation system

### 5. **Data Export**
- CSV export for spreadsheets
- PDF reports for sharing
- Summary reports
- Custom date ranges

## 🔧 Configuration

### Environment Setup
```bash
# Set up environment variables
cp .env.example .env
# Edit .env with your configuration
```

### Firebase Setup (Optional)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase init hosting
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI components
- Netlify for hosting
- All contributors and supporters

## 📞 Support

- **Email**: your.email@example.com
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/spendwise-app/issues)
- **Documentation**: [Wiki](https://github.com/yourusername/spendwise-app/wiki)

## 🎯 Roadmap

- [ ] Cloud sync functionality
- [ ] Multi-currency support
- [ ] Advanced analytics
- [ ] Social features
- [ ] Mobile apps (iOS/Android)
- [ ] Desktop apps (Windows/macOS/Linux)

---

**⭐ Star this repository if you find it helpful!**

**🚀 Built with ❤️ using Flutter**
