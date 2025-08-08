# 🚀 SpendWise Flutter App Deployment Guide

## 📋 **Prerequisites**
- Flutter SDK installed and configured
- Git repository set up (optional but recommended)
- Node.js installed (for some deployment options)

## 🌐 **Web Deployment Options**

### **Option 1: Firebase Hosting (Recommended - Free)**

#### **Step 1: Install Firebase CLI**
```bash
npm install -g firebase-tools
```

#### **Step 2: Login to Firebase**
```bash
firebase login
```

#### **Step 3: Initialize Firebase in your project**
```bash
firebase init hosting
```
- Select your project or create a new one
- Set public directory as: `build/web`
- Configure as single-page app: `Yes`
- Don't overwrite index.html: `No`

#### **Step 4: Deploy**
```bash
firebase deploy
```

**Result**: Your app will be live at `https://your-project-id.web.app`

---

### **Option 2: Netlify (Free)**

#### **Step 1: Create netlify.toml**
Create a file named `netlify.toml` in your project root:
```toml
[build]
  publish = "build/web"
  command = "flutter build web --release"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

#### **Step 2: Deploy via Netlify CLI**
```bash
npm install -g netlify-cli
netlify login
netlify deploy --prod
```

#### **Step 3: Or Deploy via Netlify UI**
1. Go to [netlify.com](https://netlify.com)
2. Drag and drop your `build/web` folder
3. Your site will be live instantly

---

### **Option 3: Vercel (Free)**

#### **Step 1: Create vercel.json**
Create a file named `vercel.json` in your project root:
```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "framework": null,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

#### **Step 2: Deploy**
```bash
npm install -g vercel
vercel login
vercel --prod
```

---

### **Option 4: GitHub Pages (Free)**

#### **Step 1: Create GitHub Actions Workflow**
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter build web --release
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

#### **Step 2: Enable GitHub Pages**
1. Go to your repository settings
2. Navigate to Pages section
3. Select "GitHub Actions" as source

---

## 📱 **Mobile App Deployment**

### **Android APK/AAB**

#### **Step 1: Build APK**
```bash
flutter build apk --release
```

#### **Step 2: Build App Bundle (Recommended for Play Store)**
```bash
flutter build appbundle --release
```

#### **Step 3: Find your files**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

#### **Step 4: Upload to Google Play Console**
1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app
3. Upload your AAB file
4. Fill in app details, screenshots, and description
5. Submit for review

---

### **iOS App Store**

#### **Step 1: Build for iOS**
```bash
flutter build ios --release
```

#### **Step 2: Open in Xcode**
```bash
open ios/Runner.xcworkspace
```

#### **Step 3: Archive and Upload**
1. In Xcode, select "Any iOS Device" as target
2. Go to Product → Archive
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Follow the upload process

---

## 🖥️ **Desktop Deployment**

### **Windows**

#### **Step 1: Build Windows App**
```bash
flutter build windows --release
```

#### **Step 2: Create Installer**
Use tools like:
- **Inno Setup**: Create professional installers
- **NSIS**: Advanced installer creation
- **Microsoft Store**: Package for Windows Store

#### **Step 3: Distribution**
- Direct download from your website
- Microsoft Store (requires developer account)
- Enterprise distribution

---

### **macOS**

#### **Step 1: Build macOS App**
```bash
flutter build macos --release
```

#### **Step 2: Create DMG**
```bash
# Install create-dmg
brew install create-dmg

# Create DMG file
create-dmg \
  --volname "SpendWise" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "SpendWise.app" 200 190 \
  --hide-extension "SpendWise.app" \
  --app-drop-link 600 185 \
  "SpendWise.dmg" \
  "build/macos/Build/Products/Release/"
```

#### **Step 3: Distribution**
- Direct download
- Mac App Store (requires Apple Developer account)
- Homebrew cask

---

### **Linux**

#### **Step 1: Build Linux App**
```bash
flutter build linux --release
```

#### **Step 2: Create AppImage**
```bash
# Install appimagetool
wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool-x86_64.AppImage

# Create AppImage
./appimagetool-x86_64.AppImage build/linux/x64/release/bundle/ SpendWise.AppImage
```

#### **Step 3: Distribution**
- Direct download
- Snap Store
- Flathub
- Package managers (deb, rpm)

---

## 🔧 **Advanced Configuration**

### **Environment Variables**
Create `.env` file for different environments:
```env
# Production
API_URL=https://api.spendwise.com
ENVIRONMENT=production

# Development
API_URL=http://localhost:3000
ENVIRONMENT=development
```

### **Build Configuration**
Update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

### **Performance Optimization**
```bash
# Enable web optimizations
flutter build web --release --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false

# Enable tree shaking
flutter build web --release --tree-shake-icons
```

---

## 📊 **Analytics & Monitoring**

### **Firebase Analytics**
Add to your app for tracking:
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

// Initialize in main.dart
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
```

### **Crashlytics**
For crash reporting:
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Initialize in main.dart
FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
```

---

## 🔒 **Security Considerations**

### **API Keys**
- Never commit API keys to version control
- Use environment variables
- Implement proper authentication

### **HTTPS**
- Always use HTTPS in production
- Configure SSL certificates
- Enable HSTS headers

### **Data Protection**
- Implement proper data encryption
- Follow GDPR/CCPA compliance
- Regular security audits

---

## 📈 **Post-Deployment Checklist**

- [ ] Test all features on deployed version
- [ ] Verify mobile responsiveness
- [ ] Check loading times and performance
- [ ] Test on different devices/browsers
- [ ] Set up monitoring and analytics
- [ ] Configure error tracking
- [ ] Set up backup and recovery
- [ ] Document deployment process
- [ ] Train team on deployment procedures

---

## 🆘 **Troubleshooting**

### **Common Issues**

#### **Build Failures**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release
```

#### **Web Performance Issues**
```bash
# Enable web optimizations
flutter build web --release --web-renderer html
```

#### **Mobile Build Issues**
```bash
# Check platform support
flutter doctor
flutter devices

# Rebuild with verbose output
flutter build apk --release --verbose
```

---

## 📞 **Support Resources**

- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Netlify Documentation](https://docs.netlify.com)
- [Vercel Documentation](https://vercel.com/docs)
- [Google Play Console](https://play.google.com/console)
- [Apple Developer](https://developer.apple.com)

---

**🎉 Congratulations! Your SpendWise app is now ready for deployment!**

Choose the deployment option that best fits your needs and follow the step-by-step instructions above.
