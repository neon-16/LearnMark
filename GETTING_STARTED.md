# LearnMark Flutter App - Getting Started

## Quick Start

### 1. Install Dependencies
```bash
cd learnmark_app
flutter pub get
```

### 2. Run the App

**On Android Emulator:**
```bash
flutter run
```

**On iOS Simulator:**
```bash
flutter run -d ios
```

**On Web:**
```bash
flutter run -d chrome
```

## Testing the App

### Test QR Codes
Generate these using any QR code generator:
- `CLASS:CS101`
- `CLASS:CS102`
- `CLASS:MATH101`

Or use the format: **CLASS:[any class code]**

### Test Location
The app will use your device's actual GPS location. If using an emulator:
- Android Emulator: Set a mock location in Extended Controls
- iOS Simulator: Debug → Location → Freeway Drive (or custom)

### Test Data Flow

1. **Home Screen**: Tap "Check-in to Class"
2. **Check-in Screen**:
   - Tap "Get Location"
   - Enter QR code (e.g., `CLASS:CS101`)
   - Fill in previous topic and expected topic
   - Select a mood (1-5)
   - Tap "Submit Check-in"

3. **Return to Home**: Tap "Finish Class"
4. **Finish Class Screen**:
   - Tap "Get Location"
   - Scan the same QR code
   - Fill in what you learned
   - Provide feedback
   - Optionally select post-class mood
   - Tap "Submit Check-out"

5. **View History**: From Home, tap "View History"

## Project Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App initialization & routing |
| `lib/screens/` | All UI screens |
| `lib/models/attendance_model.dart` | Data structures |
| `lib/services/` | Business logic (Location, Database, QR) |

## Building APK (Android)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## Building for Web

```bash
flutter build web --release
# Output: build/web/
```

## Deploying to Firebase Hosting

```bash
# Build web version
flutter build web

# Deploy to Firebase
firebase deploy --only hosting
```

## Troubleshooting

### 1. Location Permission Not Granted
- Make sure location is enabled on your device
- Grant permission when prompted
- On Android, allow "While using the app" or "Always"

### 2. Database Error
- Clear app data: `adb shell pm clear com.learnmark.app`
- Or delete the app and reinstall

### 3. QR Code Not Working
- Use format: `CLASS:ID`
- Make sure QR code is clear and in focus
- Check camera permission is granted

### 4. Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Next Steps

1. ✅ Test basic functionality
2. ✅ Verify data storage in SQLite
3. ⏳ Configure Firebase (optional)
4. ⏳ Implement authentication
5. ⏳ Add Firebase sync
6. ⏳ Deploy to Firebase Hosting

## Documentation

- [PRD](../PRD-smart_class_checkin_&_reflection.md) - Product requirements
- [AI Usage Report](./AI_USAGE_REPORT.md) - AI implementation details
- [README](./README.md) - Full project documentation

---

**Happy Testing!** 🚀
