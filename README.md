# LearnMark - Smart Class Check-in & Learning Reflection App

A Flutter-based mobile application that allows students to check in to class, record their learning expectations and reflections, and track attendance with GPS location verification and QR code scanning.

## Features

✅ **Class Check-in** - Check in before class with GPS location and QR code verification
✅ **Pre-Class Form** - Record previous topics, expected topics, and mood (1-5 scale)
✅ **Class Completion** - Check out after class with reflection data
✅ **Post-Class Reflection** - Submit what was learned and provide feedback
✅ **Attendance History** - View all check-in/check-out sessions
✅ **Local Data Storage** - SQLite database for offline persistence
✅ **GPS Integration** - Verify physical presence in classroom
✅ **QR Code Support** - Scan QR codes for class verification

## Project Structure

```
learnmark_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/
│   │   ├── home_screen.dart      # Home screen with main actions
│   │   ├── checkin_screen.dart   # Check-in form screen
│   │   ├── finish_class_screen.dart # Check-out form screen
│   │   └── history_screen.dart   # Attendance history view
│   ├── models/
│   │   └── attendance_model.dart # Data models
│   ├── services/
│   │   ├── location_service.dart # GPS location service
│   │   ├── database_service.dart # SQLite database operations
│   │   └── qr_service.dart       # QR code processing
│   └── widgets/
│       └── (custom widgets)
├── pubspec.yaml                  # Dependencies configuration
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
└── web/                          # Web-specific files
```

## Tech Stack

| Component | Technology |
|-----------|-----------|
| **Frontend Framework** | Flutter 3.0+ |
| **State Management** | Provider |
| **Local Database** | SQLite (sqflite) |
| **Location Services** | geolocator |
| **QR Code Scanning** | mobile_scanner |
| **Backend/Database** | Firebase Firestore |
| **Authentication** | Firebase Auth |
| **Deployment** | Firebase Hosting |

## Dependencies

```yaml
flutter: sdk
cupertino_icons: ^1.0.2
geolocator: ^9.0.2              # GPS location
mobile_scanner: ^3.5.0          # QR code scanning
sqflite: ^2.3.0                 # SQLite database
path: ^1.8.3
firebase_core: ^2.24.0          # Firebase
cloud_firestore: ^4.13.0
firebase_auth: ^4.10.0
provider: ^6.0.0                # State management
intl: ^0.19.0                   # Internationalization
uuid: ^4.0.0                    # UUID generation
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- Android Studio / Xcode (for mobile development)
- Firebase account

### Installation

1. **Clone the project**
   ```bash
   cd learnmark_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (Optional for MVP)
   - Create a Firebase project in [Firebase Console](https://console.firebase.google.com)
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. **Request permissions** (Android/iOS)
   - Update `AndroidManifest.xml` for location and camera permissions
   - Update `Info.plist` for iOS permissions

## Running the App

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome
```

## Data Models

### CheckInRecord
```dart
- checkinId: String (UUID)
- studentId: String
- classId: String
- checkinTime: DateTime
- gpsLatitude: double
- gpsLongitude: double
- previousTopic: String
- expectedTopic: String
- preMood: int (1-5)
```

### CheckOutRecord
```dart
- checkoutId: String (UUID)
- checkinId: String (FK)
- checkoutTime: DateTime
- gpsLatitude: double
- gpsLongitude: double
- whatLearned: String
- classFeedback: String
- postMood: int? (1-5, optional)
```

## QR Code Format

Expected QR code format: `CLASS:12345`

Example:
- Scan generates: `CLASS:CS101`
- System extracts class ID: `CS101`

For testing, use the QR code generator at [qr-code-generator.com](https://www.qr-code-generator.com/)

## GPS Location

The app requests location permissions and captures:
- Latitude and Longitude at check-in and check-out
- Accuracy radius (up to 50 meters)
- Timestamp for verification

## Database Schema

### checkin_records table
```sql
CREATE TABLE checkin_records (
  checkinId TEXT PRIMARY KEY,
  studentId TEXT NOT NULL,
  classId TEXT NOT NULL,
  checkinTime TEXT NOT NULL,
  gpsLatitude REAL NOT NULL,
  gpsLongitude REAL NOT NULL,
  previousTopic TEXT NOT NULL,
  expectedTopic TEXT NOT NULL,
  preMood INTEGER NOT NULL
);
```

### checkout_records table
```sql
CREATE TABLE checkout_records (
  checkoutId TEXT PRIMARY KEY,
  checkinId TEXT NOT NULL,
  checkoutTime TEXT NOT NULL,
  gpsLatitude REAL NOT NULL,
  gpsLongitude REAL NOT NULL,
  whatLearned TEXT NOT NULL,
  classFeedback TEXT NOT NULL,
  postMood INTEGER,
  FOREIGN KEY (checkinId) REFERENCES checkin_records(checkinId)
);
```

## Firebase Configuration

### Firestore Collections (optional)

**students/**
```
{
  "studentId": "STUDENT_001",
  "name": "John Doe",
  "email": "john@example.com"
}
```

**sessions/**
```
{
  "sessionId": "uuid",
  "studentId": "STUDENT_001",
  "classId": "CS101",
  "checkInData": {...},
  "checkOutData": {...}
}
```

## Development Notes

### State Management
The app uses Provider for state management (ready for implementation).

### Offline Support
- All data is stored locally in SQLite
- Firebase sync can be added in Phase 2

### Error Handling
- Location permission errors
- Database operation failures
- QR code validation errors
- Network timeout handling

## Known Limitations (MVP)

- ❌ No biometric authentication
- ❌ No multi-language support
- ❌ No Firebase real-time sync (local only)
- ❌ No instructor dashboard
- ❌ No attendance analytics

## Future Enhancements

1. **Phase 2 - Firebase Integration**
   - Real-time data synchronization
   - Cloud backup and restoration
   - Cross-device access

2. **Phase 3 - Advanced Features**
   - Biometric authentication (fingerprint/face)
   - Instructor dashboard
   - Attendance analytics
   - SMS/Email notifications
   - Course management system integration

3. **Phase 4 - UI/UX Improvements**
   - Dark mode support
   - Multi-language localization
   - Accessibility improvements
   - Animations and transitions

## Testing

### Manual Testing Checklist

- [ ] Location permission flow
- [ ] QR code validation
- [ ] Form submission and validation
- [ ] Data persistence in SQLite
- [ ] Navigation between screens
- [ ] History view display
- [ ] Offline functionality

### Test QR Codes

Generate using: `CLASS:CS101`, `CLASS:CS102`, `CLASS:MATH101`

## Firebase Deployment

### Deploy Flutter Web Version

```bash
# Build web version
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## Troubleshooting

### Location Permission Issues
- Check Android manifest permissions
- Check iOS Info.plist configuration
- Ensure device location is enabled

### Database Errors
- Check sqflite initialization
- Verify database path permissions
- Clear app cache if tables don't exist

### QR Code Not Scanning
- Check camera permission
- Ensure QR code is in focus
- Verify QR code format matches `CLASS:ID`

## Contributing

This is an exam project. For improvements:
1. Test thoroughly before committing
2. Document any new features
3. Update this README

## Author

Created as part of Mobile Application Development Course (1305216)

## License

This project is for educational purposes.

---

**Version:** 1.0.0  
**Last Updated:** March 13, 2026  
**Status:** MVP - Ready for Testing
