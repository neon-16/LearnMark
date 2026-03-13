# Firebase Setup Guide for LearnMark

Complete this guide to integrate Firebase with the LearnMark app.

## Step 1: Create Firebase Project

1. Go to **[Firebase Console](https://console.firebase.google.com)**
2. Click **"Add project"**
3. Enter project name: **`LearnMark`**
4. Click **"Continue"**, then **"Create project"** (skip Google Analytics)
5. Wait for project creation to complete

---

## Step 2: Register Web App

1. In Firebase console, click the **web icon** `</>`
2. Enter app nickname: **`LearnMark Web`**
3. Click **"Register app"**
4. **Copy the Firebase config** - you'll see:
   ```javascript
   const firebaseConfig = {
     apiKey: "YOUR_API_KEY",
     authDomain: "YOUR_AUTH_DOMAIN",
     projectId: "YOUR_PROJECT_ID",
     storageBucket: "YOUR_STORAGE_BUCKET",
     messagingSenderId: "YOUR_SENDER_ID",
     appId: "YOUR_APP_ID",
     measurementId: "YOUR_MEASUREMENT_ID"
   };
   ```
5. **Update** `lib/firebase_options.dart` - Replace the `web` constant values with your copied config:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'YOUR_API_KEY',  // Copy from config
     appId: 'YOUR_APP_ID',
     messagingSenderId: 'YOUR_SENDER_ID',
     projectId: 'YOUR_PROJECT_ID',
     authDomain: 'YOUR_AUTH_DOMAIN',
     databaseURL: 'https://YOUR_PROJECT_ID.firebaseio.com',
     storageBucket: 'YOUR_STORAGE_BUCKET',
     measurementId: 'YOUR_MEASUREMENT_ID',
   );
   ```

---

## Step 3: Register Android App (Optional - for APK builds)

1. In Firebase console, click the **android icon**
2. Package name: **`com.learnmark.app`**
3. Download **`google-services.json`**
4. Place in: **`android/app/google-services.json`**
5. Click **"Next"** → **"Skip"** the next steps

---

## Step 4: Register iOS App (Optional - for iOS builds)

1. In Firebase console, click the **iOS icon**
2. iOS Bundle ID: **`com.learnmark.app`**
3. Download **`GoogleService-Info.plist`**
4. Place in: **`ios/Runner/GoogleService-Info.plist`**
5. Click **"Next"** → **"Skip"** the next steps

---

## Step 5: Enable Firestore Database

1. In Firebase console, go to **"Build"** → **"Firestore Database"**
2. Click **"Create database"**
3. Choose location (default is fine)
4. Select **"Start in test mode"** (for development)
5. Click **"Enable"**

**Test mode rules** (valid for 30 days - upgrade before production):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

---

## Step 6: Enable Authentication

1. In Firebase console, go to **"Build"** → **"Authentication"**
2. Click **"Get started"**
3. Enable **"Email/Password"** (click the enable toggle)
4. Leave other providers disabled for now
5. Click **"Save"**

---

## Step 7: Copy Firestore Rules (Security)

1. Download the provided **`firestore.rules`** file from the project
2. In Firebase console → **"Firestore Database"** → **"Rules"**
3. Copy the entire content of `firestore.rules`
4. Paste into Firebase console rules editor
5. Click **"Publish"**

---

## Step 8: Verify Configuration

Run the app to verify Firebase is connected:

```bash
cd c:\Users\LAB\Desktop\myapp\learnmark_app
flutter run -d chrome
```

Check browser console for Firebase initialization messages. If no errors appear, Firebase is working!

---

## Firebase Features Now Enabled

✅ **Firestore Database** - Cloud data storage  
✅ **Authentication** - User login system  
✅ **Real-time Sync** - Data syncs across devices  
✅ **Security Rules** - Data protection  

---

## Troubleshooting

### "Firebase initialization error"
- Verify API keys in `firebase_options.dart`
- Check all required fields are filled
- Restart app with `flutter run -d chrome`

### "Permission denied" errors in Firestore
- Ensure test mode is enabled
- Check firestore.rules are published

### "CORS errors" on web
- Firebase automatically handles CORS for web apps
- If issues persist, check browser console for details

---

## Next Steps

1. **Authentication Screen** - Add login/signup (tutorial in PROJECT_SUMMARY.md)
2. **Data Sync** - Enable syncing attendance records to Firestore
3. **Dashboard** - Show cloud-synced attendance data
4. **User Profiles** - Store student info in Firestore

---

## Firebase Console Links

- **Authentication**: `console.firebase.google.com` → Project → Build → Authentication
- **Firestore**: `console.firebase.google.com` → Project → Build → Firestore Database
- **Project Settings**: `console.firebase.google.com` → Project → Settings → Project Settings

---

**Date Created**: March 13, 2026  
**App Version**: 1.0.0  
**Status**: Firebase Ready
