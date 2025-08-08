@echo off
title SpendWise Deployment Tool
color 0A

echo.
echo ========================================
echo    🚀 SpendWise Deployment Tool
echo ========================================
echo.

:menu
echo Choose an option:
echo.
echo [1] Build Flutter Web App
echo [2] Deploy Demo Website (GitHub Pages)
echo [3] Deploy Demo Website (Netlify)
echo [4] Deploy Demo Website (Vercel)
echo [5] Deploy Flutter App (Firebase)
echo [6] Deploy Flutter App (Netlify)
echo [7] Run Both Apps Locally
echo [8] Build Android APK
echo [9] Build iOS App
echo [0] Exit
echo.
set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" goto build_web
if "%choice%"=="2" goto deploy_demo_github
if "%choice%"=="3" goto deploy_demo_netlify
if "%choice%"=="4" goto deploy_demo_vercel
if "%choice%"=="5" goto deploy_flutter_firebase
if "%choice%"=="6" goto deploy_flutter_netlify
if "%choice%"=="7" goto run_local
if "%choice%"=="8" goto build_android
if "%choice%"=="9" goto build_ios
if "%choice%"=="0" goto exit
goto menu

:build_web
echo.
echo 🔨 Building Flutter Web App...
flutter clean
flutter pub get
flutter build web --release
echo.
echo ✅ Flutter web app built successfully!
echo 📁 Build files are in: build/web/
echo.
pause
goto menu

:deploy_demo_github
echo.
echo 🌐 Deploying Demo Website to GitHub Pages...
echo.
echo Please ensure you have:
echo 1. GitHub repository set up
echo 2. GitHub Pages enabled in repository settings
echo 3. GitHub Actions workflow configured
echo.
echo Manual steps:
echo 1. Push demo-website folder to GitHub
echo 2. Enable GitHub Pages in repository settings
echo 3. Select GitHub Actions as source
echo.
pause
goto menu

:deploy_demo_netlify
echo.
echo 🌐 Deploying Demo Website to Netlify...
echo.
echo Please ensure you have:
echo 1. Netlify account created
echo 2. netlify-cli installed: npm install -g netlify-cli
echo.
echo Running deployment...
cd demo-website
netlify deploy --prod --dir=.
cd ..
echo.
echo ✅ Demo website deployed to Netlify!
echo.
pause
goto menu

:deploy_demo_vercel
echo.
echo 🌐 Deploying Demo Website to Vercel...
echo.
echo Please ensure you have:
echo 1. Vercel account created
echo 2. vercel-cli installed: npm install -g vercel
echo.
echo Running deployment...
cd demo-website
vercel --prod
cd ..
echo.
echo ✅ Demo website deployed to Vercel!
echo.
pause
goto menu

:deploy_flutter_firebase
echo.
echo 🔥 Deploying Flutter App to Firebase...
echo.
echo Please ensure you have:
echo 1. Firebase account created
echo 2. firebase-tools installed: npm install -g firebase-tools
echo 3. Firebase project initialized
echo.
echo Running deployment...
flutter build web --release
firebase deploy
echo.
echo ✅ Flutter app deployed to Firebase!
echo.
pause
goto menu

:deploy_flutter_netlify
echo.
echo 🌐 Deploying Flutter App to Netlify...
echo.
echo Please ensure you have:
echo 1. Netlify account created
echo 2. netlify-cli installed: npm install -g netlify-cli
echo.
echo Running deployment...
flutter build web --release
netlify deploy --prod --dir=build/web
echo.
echo ✅ Flutter app deployed to Netlify!
echo.
pause
goto menu

:run_local
echo.
echo 🏃 Running Both Apps Locally...
echo.
echo Starting Flutter app on port 8080...
start "Flutter App" cmd /k "flutter run -d chrome --web-port 8080"
echo.
echo Starting Demo website on port 8000...
start "Demo Website" cmd /k "cd demo-website && python -m http.server 8000"
echo.
echo 🌐 Flutter App: http://localhost:8080
echo 🌐 Demo Website: http://localhost:8000
echo.
echo Press any key to continue...
pause >nul
goto menu

:build_android
echo.
echo 🤖 Building Android APK...
flutter build apk --release
echo.
echo ✅ Android APK built successfully!
echo 📁 APK location: build/app/outputs/flutter-apk/app-release.apk
echo.
echo To build App Bundle (recommended for Play Store):
echo flutter build appbundle --release
echo.
pause
goto menu

:build_ios
echo.
echo 🍎 Building iOS App...
flutter build ios --release
echo.
echo ✅ iOS app built successfully!
echo 📁 Build location: build/ios/archive/
echo.
echo Next steps:
echo 1. Open ios/Runner.xcworkspace in Xcode
echo 2. Select "Any iOS Device" as target
echo 3. Go to Product → Archive
echo 4. Distribute to App Store Connect
echo.
pause
goto menu

:exit
echo.
echo 👋 Thank you for using SpendWise Deployment Tool!
echo.
exit
