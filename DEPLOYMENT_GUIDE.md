# 🚀 SpendWise Deployment Guide

## 📋 Overview

This guide covers deploying both the **Flutter Expense Tracker App** and the **Demo Website** to various hosting platforms.

### **Current Project Structure:**
```
flutter_expense_tracker/
├── lib/                    # Flutter app source code
├── build/web/             # Built Flutter web app (after build)
├── demo-website/          # Demo website files
│   ├── index.html
│   ├── styles.css
│   ├── script.js
│   ├── README.md
│   ├── netlify.toml
│   └── vercel.json
└── deploy.bat            # Deployment script
```

---

## 🎯 Quick Start

### **Option 1: Use the Deployment Script**
```bash
# Run the deployment script
deploy.bat
```

### **Option 2: Manual Deployment**
Follow the detailed steps below for each platform.

---

## 🌐 Demo Website Deployment

### **A. GitHub Pages (Free)**

**Steps:**
1. Create a new GitHub repository
2. Upload contents of `demo-website/` folder
3. Go to Settings → Pages
4. Select source branch (main/master)
5. Your site: `https://username.github.io/repo-name`

**Files to upload:**
- `index.html`
- `styles.css`
- `script.js`
- `README.md`
- `netlify.toml`
- `vercel.json`

### **B. Netlify (Free)**

**Method 1: Drag & Drop**
1. Go to [netlify.com](https://netlify.com)
2. Drag `demo-website/` folder to the deploy area
3. Get instant URL
4. Optional: Add custom domain

**Method 2: GitHub Integration**
1. Connect GitHub account
2. Select repository
3. Automatic deployments on push

### **C. Vercel (Free)**

**Steps:**
1. Go to [vercel.com](https://vercel.com)
2. Connect GitHub account
3. Import repository with `demo-website/`
4. Automatic deployment with preview URLs

---

## 📱 Flutter App Deployment

### **A. Firebase Hosting (Free)**

**Prerequisites:**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase project
firebase init hosting
```

**Deploy:**
```bash
# Build Flutter app
flutter build web --release

# Deploy to Firebase
firebase deploy
```

### **B. Netlify (Free)**

**Steps:**
1. Build Flutter app: `flutter build web --release`
2. Go to [netlify.com](https://netlify.com)
3. Upload `build/web/` folder
4. Configure build settings if needed

### **C. Vercel (Free)**

**Steps:**
1. Build Flutter app: `flutter build web --release`
2. Go to [vercel.com](https://vercel.com)
3. Upload `build/web/` folder
4. Automatic deployment

---

## 📱 Mobile App Deployment

### **Android App Store**

**Build APK:**
```bash
flutter build apk --release
```

**Deploy:**
1. Create Google Play Console account
2. Upload APK from `build/app/outputs/flutter-apk/app-release.apk`
3. Add app metadata, screenshots, description
4. Submit for review

### **iOS App Store**

**Build iOS:**
```bash
flutter build ios --release
```

**Deploy:**
1. Create Apple Developer account
2. Open `ios/Runner.xcworkspace` in Xcode
3. Archive and upload to App Store Connect
4. Submit for review

---

## 🌍 Domain Strategy

### **Recommended Setup:**

**Option 1: Subdomains**
```
Main Domain: yourdomain.com
├── Demo Website: demo.yourdomain.com
└── Flutter App: app.yourdomain.com
```

**Option 2: Separate Domains**
```
Demo Website: spendwise-demo.com
Flutter App: spendwise-app.com
```

**Option 3: Path-based**
```
Main Domain: yourdomain.com
├── Demo Website: yourdomain.com
└── Flutter App: yourdomain.com/app
```

---

## 🔧 Configuration Files

### **Demo Website - netlify.toml**
```toml
[build]
  publish = "."
  command = ""

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
```

### **Demo Website - vercel.json**
```json
{
  "src": "*.html",
  "use": "@vercel/static",
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

### **Flutter App - netlify.toml**
```toml
[build]
  publish = "build/web"
  command = "flutter build web --release"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### **Flutter App - vercel.json**
```json
{
  "src": "build/web/**",
  "use": "@vercel/static",
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/build/web/index.html"
    }
  ],
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web"
}
```

---

## 🚀 Performance Optimization

### **Demo Website:**
- ✅ Minified CSS and JS
- ✅ Optimized images
- ✅ CDN for fonts and icons
- ✅ Lazy loading for sections

### **Flutter App:**
- ✅ Release build optimization
- ✅ Tree shaking enabled
- ✅ Compressed assets
- ✅ Service worker for caching

---

## 🔒 Security Considerations

### **HTTPS:**
- All modern hosting platforms provide HTTPS
- Custom domains should use SSL certificates

### **Headers:**
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block
- X-Content-Type-Options: nosniff

### **CORS:**
- Configure CORS headers if needed
- Restrict access to authorized domains

---

## 📊 Analytics & Monitoring

### **Google Analytics:**
```html
<!-- Add to both apps -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### **Error Monitoring:**
- Sentry for error tracking
- Firebase Crashlytics for mobile apps

---

## 🔄 Continuous Deployment

### **GitHub Actions:**
```yaml
name: Deploy to Netlify
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Netlify
        uses: nwtgck/actions-netlify@v1.2
        with:
          publish-dir: './demo-website'
          production-branch: main
          github-token: ${{ secrets.GITHUB_TOKEN }}
          deploy-message: "Deploy from GitHub Actions"
```

---

## 🆘 Troubleshooting

### **Common Issues:**

**1. Flutter Build Errors:**
```bash
flutter clean
flutter pub get
flutter build web --release
```

**2. Deployment Failures:**
- Check file paths
- Verify configuration files
- Ensure all dependencies are included

**3. CORS Issues:**
- Configure CORS headers
- Check domain settings

**4. Performance Issues:**
- Optimize images
- Minify CSS/JS
- Enable compression

---

## 📞 Support

### **Resources:**
- [Flutter Web Deployment](https://flutter.dev/docs/deployment/web)
- [Netlify Documentation](https://docs.netlify.com/)
- [Vercel Documentation](https://vercel.com/docs)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

### **Contact:**
For deployment issues, check the platform-specific documentation or community forums.

---

## ✅ Checklist

### **Before Deployment:**
- [ ] Test both apps locally
- [ ] Build Flutter app for web
- [ ] Check all links and functionality
- [ ] Optimize images and assets
- [ ] Set up analytics (optional)

### **After Deployment:**
- [ ] Test all features on live site
- [ ] Check mobile responsiveness
- [ ] Verify HTTPS is working
- [ ] Test performance
- [ ] Set up monitoring (optional)

---

**🎉 Congratulations! Your SpendWise apps are now live!**
