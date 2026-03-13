# Firebase Setup Checklist

Complete these steps in order to fully integrate Firebase with LearnMark.

---

## Phase 1: Firebase Project Creation

- [ ] Go to [Firebase Console](https://console.firebase.google.com)
- [ ] Click "Add project"
- [ ] Enter project name: `LearnMark`
- [ ] Disable "Enable Google Analytics" (optional)
- [ ] Create project and wait for completion

---

## Phase 2: Web App Registration

- [ ] In Firebase console, click web icon `</>`
- [ ] Enter app name: `LearnMark Web`
- [ ] Click "Register app"
- [ ] **Copy the Firebase config object**
- [ ] Open `lib/firebase_options.dart`
- [ ] **Replace values in the `web` constant:**
  - [ ] `apiKey` → Your API key
  - [ ] `appId` → Your app ID
  - [ ] `messagingSenderId` → Your messaging sender ID
  - [ ] `projectId` → Your project ID
  - [ ] `authDomain` → Your auth domain (format: `projectid.firebaseapp.com`)
  - [ ] `storageBucket` → Your storage bucket
  - [ ] `measurementId` → Your measurement ID (if exists)
- [ ] Save file

---

## Phase 3: Android (Optional - for Mobile APK)

- [ ] In Firebase console, click Android icon
- [ ] Package name: `com.learnmark.app`
- [ ] Download `google-services.json`
- [ ] Place in: `android/app/google-services.json`

---

## Phase 4: iOS (Optional - for iOS builds)

- [ ] In Firebase console, click iOS icon
- [ ] iOS Bundle ID: `com.learnmark.app`
- [ ] Download `GoogleService-Info.plist`
- [ ] Place in: `ios/Runner/GoogleService-Info.plist`

---

## Phase 5: Enable Firestore Database

- [ ] Go to Firebase console → Build → Firestore Database
- [ ] Click "Create database"
- [ ] Select location (default US is fine)
- [ ] Choose **"Start in test mode"**
- [ ] Click "Enable"
- [ ] Wait for database initialization

---

## Phase 6: Enable Authentication

- [ ] Go to Firebase console → Build → Authentication
- [ ] Click "Get started"
- [ ] Find "Email/Password" method
- [ ] Click "Enable" toggle
- [ ] Click "Save"

---

## Phase 7: Setup Firestore Rules

- [ ] Get `firestore.rules` from the LearnMark project
- [ ] In Firebase console → Firestore Database → Rules tab
- [ ] Select all existing text (Ctrl+A)
- [ ] Delete
- [ ] Copy entire content from `firestore.rules`
- [ ] Paste into Firebase rules editor
- [ ] Click "Publish"

---

## Phase 8: Verify Setup

- [ ] Open terminal in VS Code
- [ ] Run:
  ```bash
  cd c:\Users\LAB\Desktop\myapp\learnmark_app
  flutter run -d chrome
  ```
- [ ] App should launch in Chrome
- [ ] Check browser console (F12) for Firebase initialization
- [ ] Look for message: `Firebase initialized successfully` (or similar)
- [ ] No red errors should appear

---

## Phase 9: Test Authentication (Optional)

- [ ] Once app is running, create a test user by:
  - [ ] Going to Firebase Console → Authentication → Users
  - [ ] Click "Add user"
  - [ ] Enter test email: `test@learnmark.com`
  - [ ] Enter test password: `Test123!`
  - [ ] Click "Create user"
- [ ] In app, attempt to sign in with credentials
- [ ] Verify login works

---

## Phase 10: Enable Data Sync (Optional)

- [ ] In `lib/screens/checkin_screen.dart`, add after successful check-in:
  ```dart
  if (success) {
    final cloudService = CloudSyncService();
    if (cloudService.isAuthenticated) {
      await cloudService.uploadCheckIn(checkInRecord);
    }
  }
  ```
- [ ] Repeat for `lib/screens/finish_class_screen.dart`
- [ ] Test a check-in, then verify data appears in Firestore

---

## Phase 11: Test Firestore Data

- [ ] Make a check-in in the app
- [ ] Go to Firebase Console → Firestore Database
- [ ] Navigate to: `users/{userId}/checkins/`
- [ ] Verify check-in data is visible
- [ ] Check the data structure matches expectations

---

## Phase 12: Monitor & Maintain

- [ ] Check Firebase console daily for errors
- [ ] Monitor Firestore costs (free tier: 50k reads/day)
- [ ] Review authentication logs
- [ ] Backup important data

---

## Verification Checklist

At this point, verify:

- [ ] Firebase project created ✅
- [ ] Web app registered ✅
- [ ] Firebase config added to code ✅
- [ ] Firestore database created ✅
- [ ] Authentication enabled ✅
- [ ] Security rules published ✅
- [ ] App initializes Firebase without errors ✅
- [ ] Data can be uploaded to Firestore ✅

---

## Troubleshooting

### Issue: "Firebase initialization error"
**Solution:**
1. Check `firebase_options.dart` for correct values
2. Verify project ID and API key are correct
3. Restart app: `flutter run -d chrome`

### Issue: "Permission denied" in Firestore
**Solution:**
1. Go to Firebase → Firestore → Rules
2. Ensure test mode rules are published
3. Wait 60 seconds for rules to propagate

### Issue: "Authentication failed"
**Solution:**
1. Verify email/password provider is enabled in Firebase
2. Check user exists in Firebase Console
3. Verify email and password are correct

### Issue: "CORS errors" in browser console
**Solution:**
1. Firebase handles CORS automatically
2. If issue persists, check:
   - Correct project ID in `firebase_options.dart`
   - Firestore database is in test mode

### Issue: No data appearing in Firestore
**Solution:**
1. Verify user is authenticated first
2. Check CloudSyncService is being called
3. Check browser console for upload errors
4. Verify Firestore rules allow writes

---

## Rollback (If Needed)

If you need to disable Firebase:

1. Comment out Firebase init in `lib/main.dart`:
   ```dart
   // await Firebase.initializeApp(
   //   options: DefaultFirebaseOptions.currentPlatform,
   // );
   ```

2. App will continue to work with local SQLite storage only

3. To re-enable, uncomment and redeploy

---

## Resources

- [Firebase Console](https://console.firebase.google.com)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Guide](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/rules)

---

**Estimated Time**: 15-20 minutes  
**Difficulty**: Beginner  
**Date Created**: March 13, 2026  
**Version**: 1.0.0
