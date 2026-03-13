# LearnMark Flutter App - Test Instructions

## Pre-Testing Checklist

- [ ] Flutter SDK installed and updated
- [ ] Android Studio/Xcode installed (for mobile)
- [ ] Device or emulator ready
- [ ] Location enabled on device/emulator
- [ ] Camera permission available

## Test Execution Steps

### Test 1: App Launch & Navigation

**Steps:**
1. Run `flutter run`
2. Verify Home Screen appears with:
   - Welcome message
   - Statistics cards (Check-ins, Completed)
   - Three action buttons

**Expected Result:** ✅ App launches and navigates correctly

**Test Data:**
- No data expected on first run
- Check-ins counter should be 0
- Completed counter should be 0

---

### Test 2: Location Permission Flow

**Steps:**
1. From Home Screen, tap "Check-in to Class"
2. On Check-in Screen, tap "Get Location"
3. If prompted, grant location permission

**Expected Result:** ✅ Location coordinates appear in the form

**Verification:**
- Latitude and longitude display correctly
- Format: Lat: X.XXXX, Lng: X.XXXX
- Checkmark appears next to GPS Location

**Test Data:**
- Android Emulator: Use Extended Controls → Location
- iOS Simulator: Debug → Location → Freeway Drive
- Real Device: Your actual location

---

### Test 3: Check-in Form Submission

**Steps:**
1. From Check-in Screen, ensure location is obtained
2. Enter QR Code: `CLASS:CS101`
3. Previous Topic: "Introduction to Variables"
4. Expected Topic: "Data Types and Operations"
5. Select Mood: Click on 😊 (Positive) or 😄 (Very Positive)
6. Tap "Submit Check-in"

**Expected Result:** ✅ Success message displays, form submits

**Test Data:**
```
QR Code: CLASS:CS101
Previous Topic: Introduction to Variables
Expected Topic: Data Types and Operations
Mood: 4 (Positive)
```

**Verification:**
- "Check-in saved successfully!" message appears
- Home screen reappears after 2 seconds
- No errors in console

---

### Test 4: Form Validation

**Test 4a: Empty QR Code**
1. Leave QR Code field empty
2. Fill other fields
3. Tap "Submit Check-in"

**Expected Result:** ❌ Error: "Please fill all fields"

**Test 4b: Invalid QR Code Format**
1. Enter: `CS101` (missing "CLASS:" prefix)
2. Tap "Submit Check-in"

**Expected Result:** ❌ Error: "Invalid QR code format. Expected: CLASS:ID"

**Test 4c: Missing Location**
1. Don't tap "Get Location"
2. Fill all form fields
3. Tap "Submit Check-in"

**Expected Result:** ❌ Error: "Please fill all fields and obtain location"

---

### Test 5: Check-out/Finish Class

**Prerequisites:**
- Must have completed Test 3 (Check-in)

**Steps:**
1. From Home Screen, tap "Finish Class"
2. Verify check-in session appears in dropdown
3. Tap "Get Location"
4. Enter QR Code: `CLASS:CS101` (same as check-in)
5. What Learned: "Learned about int, float, and string types"
6. Feedback: "Great class, instructor was clear"
7. Post-class Mood: Click 😊 (Positive) - optional
8. Tap "Submit Check-out"

**Expected Result:** ✅ Success message displays

**Test Data:**
```
QR Code: CLASS:CS101
What Learned: Learned about int, float, and string types
Feedback: Great class, instructor was clear
Post-mood: 4 (Positive)
```

**Verification:**
- "Check-out saved successfully!" message appears
- Home screen reappears
- Session is now marked as "Completed"

---

### Test 6: View Attendance History

**Prerequisites:**
- Must have completed Test 3 and Test 5

**Steps:**
1. From Home Screen, tap "View History"
2. Verify session appears in list with:
   - Date and time
   - Class ID
   - "Completed" status badge
3. Tap to expand the session card

**Expected Result:** ✅ History displays with complete check-in and check-out data

**Verification - Check-in Details:**
- Time: Matches check-in timestamp
- Location: Lat/Lng coordinates
- Previous Topic: "Introduction to Variables"
- Expected Topic: "Data Types and Operations"
- Pre-class Mood: 😄 Very Positive (emoji display)

**Verification - Check-out Details:**
- Time: Matches check-out timestamp
- Location: Lat/Lng coordinates
- What Learned: "Learned about int, float, and string types"
- Feedback: "Great class, instructor was clear"
- Post-class Mood: 😊 Positive (emoji display)

---

### Test 7: Multiple Sessions

**Steps:**
1. Create 3 different check-in/check-out sessions:

**Session 1:**
- Class: `CLASS:CS101`
- Pre-mood: 😡 (Very Negative)
- Post-mood: 🙂 (Positive)

**Session 2:**
- Class: `CLASS:MATH101`
- Pre-mood: 😐 (Neutral)
- Post-mood: 😄 (Very Positive)

**Session 3:**
- Class: `CLASS:ENG201`
- Pre-mood: 🙂 (Positive)
- No post-mood selected

2. View History and verify all 3 sessions display

**Expected Result:** ✅ All sessions appear in history list

---

### Test 8: Data Persistence

**Steps:**
1. Complete a check-in/check-out session
2. View History to confirm it appears
3. Close the app completely
4. Reopen the app
5. Go to View History

**Expected Result:** ✅ Data still appears after app restart

**Verification:**
- Session data is not lost
- All form fields intact
- Timestamps preserved

---

### Test 9: Navigation Flow

**Steps:**
1. Test back navigation:
   - From Check-in Screen → tap Android back button
   - Verify return to Home Screen
   
2. Test route transitions:
   - Home → Check-in → Home → Finish → Home → History → Home

**Expected Result:** ✅ All navigation transitions work smoothly

---

### Test 10: UI/UX Features

**Test 10a: Mood Selector**
- [ ] All 5 mood buttons are clickable
- [ ] Selected mood shows border highlight
- [ ] Emoji display correctly (😡 🙁 😐 🙂 😄)
- [ ] Color changes on selection

**Test 10b: Status Messages**
- [ ] "Getting your location..." appears while fetching
- [ ] Success message displays after submission
- [ ] Error messages appear for validation failures
- [ ] Loading spinner shows during submission

**Test 10c: Form Fields**
- [ ] Text fields accept input correctly
- [ ] Multi-line fields show 2-3 lines properly
- [ ] Keyboard dismisses after submission
- [ ] Focus management works

**Test 10d: Buttons & States**
- [ ] "Get Location" button disables during loading
- [ ] "Submit" button is enabled/disabled correctly
- [ ] Buttons have proper padding and alignment
- [ ] Touch feedback works

---

## Error Handling Tests

### Test 11: Network/Permission Errors

**Test 11a: Location Permission Denied**
1. Deny location permission when prompted
2. Tap "Get Location"

**Expected:** Error message: "Failed to get location. Please try again."

**Test 11b: Missing Database Initialization**
1. Delete app data
2. Run app
3. Attempt check-in

**Expected:** App creates tables automatically, no errors

---

## Performance Tests

### Test 12: Response Times

Measure these operations:
- [ ] Location capture: < 5 seconds
- [ ] Form submission: < 2 seconds
- [ ] History load: < 1 second
- [ ] Screen transition: < 500ms

---

## Device/Platform Tests

### Test 13: Different Devices

**Test on:**
- [ ] Android Phone (if available)
- [ ] Android Tablet
- [ ] iOS Device (if available)
- [ ] Chrome (web)
- [ ] Emulators/Simulators

**Verify:**
- [ ] UI responsive on different screen sizes
- [ ] Location works on all platforms
- [ ] Database works on all platforms

---

## Test Results Summary

| Test # | Test Name | Status | Notes |
|--------|-----------|--------|-------|
| 1 | App Launch & Navigation | ✅ / ❌ | |
| 2 | Location Permission | ✅ / ❌ | |
| 3 | Check-in Form | ✅ / ❌ | |
| 4 | Form Validation | ✅ / ❌ | |
| 5 | Check-out Form | ✅ / ❌ | |
| 6 | View History | ✅ / ❌ | |
| 7 | Multiple Sessions | ✅ / ❌ | |
| 8 | Data Persistence | ✅ / ❌ | |
| 9 | Navigation Flow | ✅ / ❌ | |
| 10 | UI/UX Features | ✅ / ❌ | |
| 11 | Error Handling | ✅ / ❌ | |
| 12 | Performance | ✅ / ❌ | |
| 13 | Multi-Platform | ✅ / ❌ | |

---

## Debugging Tips

### Common Issues & Solutions

**Issue: "Location permission denied"**
- Solution: Check app settings and grant location permission

**Issue: "SQLite database error"**
- Solution: Run `flutter clean` and `flutter pub get`

**Issue: "QR code not working"**
- Solution: Use format `CLASS:ID`, ensure camera permission

**Issue: "Widget not rendering"**
- Solution: Hot reload may not work; try hot restart

**Enable Debug Logging:**
```bash
flutter run -v
```

---

## Sign-Off

**Tested By:** [Your Name]  
**Date:** [Date]  
**Overall Status:** ✅ PASSED / ❌ FAILED  
**Notes:** 

---

**All tests must pass for MVP submission!**
