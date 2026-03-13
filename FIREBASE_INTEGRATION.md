# Firebase Integration - Complete Setup

## What's Been Done

✅ **Firebase options file created** - `lib/firebase_options.dart`  
✅ **Firebase initialization enabled** - `lib/main.dart`  
✅ **Cloud Sync Service created** - `lib/services/cloud_sync_service.dart`  
✅ **Setup guide provided** - `FIREBASE_SETUP.md`  

---

## Quick Start

### 1. Update Your Firebase Credentials

Edit `lib/firebase_options.dart` and replace ALL `YOUR_*` values with your actual Firebase config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',              // From Firebase console
  appId: 'YOUR_APP_ID',                // From Firebase console
  messagingSenderId: 'YOUR_SENDER_ID', // From Firebase console
  projectId: 'YOUR_PROJECT_ID',        // From Firebase console
  authDomain: 'YOUR_AUTH_DOMAIN',      // From Firebase console
  databaseURL: 'YOUR_DATABASE_URL',    // Optional
  storageBucket: 'YOUR_STORAGE_BUCKET',// From Firebase console
  measurementId: 'YOUR_MEASUREMENT_ID',// Optional
);
```

### 2. Test Firebase Connection

Run the app:
```bash
flutter run -d chrome
```

Check the console for Firebase initialization messages.

---

## Available Firebase Features

### Authentication Service
```dart
final cloudService = CloudSyncService();

// Sign up
await cloudService.signUp('user@example.com', 'password123');

// Sign in
await cloudService.signIn('user@example.com', 'password123');

// Check if logged in
if (cloudService.isAuthenticated) {
  print('User is logged in: ${cloudService.currentUser?.email}');
}

// Sign out
await cloudService.signOut();
```

### Upload Data to Firestore
```dart
// Upload a check-in record
await cloudService.uploadCheckIn(checkInRecord);

// Upload a check-out record
await cloudService.uploadCheckOut(checkOutRecord);

// Sync all local data to cloud
await cloudService.syncLocalDataToCloud(allCheckIns, allCheckOuts);
```

### Real-time Sync
```dart
// Listen to check-in updates in real-time
cloudService.getCheckInsStream().listen((snapshot) {
  for (var doc in snapshot.docs) {
    print('Check-in: ${doc.data()}');
  }
});
```

### User Statistics
```dart
// Get user stats from Firestore
final stats = await cloudService.getUserStats();
print('Stats: $stats');
```

---

## Architecture

The app now uses a **hybrid approach**:

1. **Local Storage** (SQLite) - Primary storage, offline-first
2. **Cloud Storage** (Firestore) - Optional cloud backup
3. **Smart Sync** - Automatically syncs when user is authenticated

### Data Flow
```
Check-in Form
    ↓
Save to Local DB (SQLite)
    ↓
If authenticated: Upload to Firestore
    ↓
Display in History (Local + Cloud)
```

---

## Implementation Examples

### Example 1: Add Firebase Upload to Check-in

In `lib/screens/checkin_screen.dart`, after successful check-in:

```dart
// After local save succeeds
if (success) {
  // Try to upload to Firebase if user is authenticated
  final cloudService = CloudSyncService();
  if (cloudService.isAuthenticated) {
    await cloudService.uploadCheckIn(checkInRecord);
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Check-in saved!')),
  );
}
```

### Example 2: Sync All Data on App Start

In `lib/main.dart`, after Firebase initialization:

```dart
final cloudService = CloudSyncService();

// Auto-sync pending records if user is logged in
if (cloudService.isAuthenticated) {
  final allCheckIns = await _dbService.getAllCheckIns();
  final allCheckOuts = await _dbService.getAllCheckOuts();
  await cloudService.syncLocalDataToCloud(allCheckIns, allCheckOuts);
}
```

### Example 3: Implement Login Screen

Create `lib/screens/login_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/cloud_sync_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cloudService = CloudSyncService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    final success = await _cloudService.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Firestore Database Structure

Your data will be organized as:

```
users/
  {userId}/
    checkins/
      {checkInId}: { checkinTime, classId, preMood, ... }
    checkouts/
      {checkOutId}: { checkoutTime, whatLearned, postMood, ... }
    stats/
      totalCheckIns: number
      completedSessions: number
```

---

## Security Rules

Use the provided `firestore.rules` file. Key features:

✅ **User isolation** - Users can only see their own data  
✅ **Read/Write protection** - Only authenticated users can write  
✅ **Data validation** - Ensures correct data format  

---

## Next Steps

1. **Follow FIREBASE_SETUP.md** to configure Firebase console
2. **Update firebase_options.dart** with your credentials
3. **Add login screen** using CloudSyncService
4. **Enable auto-sync** in check-in screens
5. **Deploy to Firebase Hosting** for web app

---

## Troubleshooting

### Firebase not initializing
- Check `firebase_options.dart` has correct values
- Verify Firebase project exists in console
- Check browser console for CORS errors

### Data not syncing to Firestore
- Ensure user is authenticated first
- Check Firestore Database is in test mode (or rules allow writes)
- Verify internet connection

### Authentication errors
- Double-check email/password
- Ensure Email/Password provider is enabled in Firebase
- Check browser console for error details

---

## Files Modified/Created

```
lib/
  ├── firebase_options.dart          ✨ CREATED - Firebase config
  ├── services/
  │   └── cloud_sync_service.dart    ✨ CREATED - Cloud operations
  └── main.dart                        ✏️ MODIFIED - Firebase init

root/
  └── FIREBASE_SETUP.md              ✨ CREATED - Setup guide
  └── FIREBASE_INTEGRATION.md        ✨ CREATED - This file
```

---

**Status**: ✅ Firebase Integration Complete  
**Date**: March 13, 2026  
**Version**: 1.0.0
