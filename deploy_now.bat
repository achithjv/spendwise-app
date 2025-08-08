@echo off
title SpendWise Quick Deploy
color 0A

echo.
echo ========================================
echo    🚀 SPENDWISE QUICK DEPLOY
echo ========================================
echo.

echo Building Flutter app...
flutter build web --release

echo.
echo ✅ Build completed!
echo.

echo Deploying to Netlify...
netlify deploy --prod --dir=build/web

echo.
echo 🎉 Deployment completed!
echo.
pause
