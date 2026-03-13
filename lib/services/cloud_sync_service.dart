import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/attendance_model.dart';

class CloudSyncService {
  static final CloudSyncService _instance = CloudSyncService._internal();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory CloudSyncService() {
    return _instance;
  }

  CloudSyncService._internal();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Sign up
  Future<bool> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Upload check-in to Firestore
  Future<bool> uploadCheckIn(CheckInRecord record) async {
    try {
      if (!isAuthenticated) {
        print('User not authenticated');
        return false;
      }

      final userId = currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('checkins')
          .doc(record.checkinId)
          .set({
            'studentId': record.studentId,
            'classId': record.classId,
            'checkinTime': record.checkinTime.toIso8601String(),
            'gpsLatitude': record.gpsLatitude,
            'gpsLongitude': record.gpsLongitude,
            'previousTopic': record.previousTopic,
            'expectedTopic': record.expectedTopic,
            'preMood': record.preMood,
            'uploadedAt': DateTime.now().toIso8601String(),
          });
      return true;
    } catch (e) {
      print('Error uploading check-in: $e');
      return false;
    }
  }

  // Upload check-out to Firestore
  Future<bool> uploadCheckOut(CheckOutRecord record) async {
    try {
      if (!isAuthenticated) {
        print('User not authenticated');
        return false;
      }

      final userId = currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('checkouts')
          .doc(record.checkoutId)
          .set({
            'checkinId': record.checkinId,
            'checkoutTime': record.checkoutTime.toIso8601String(),
            'gpsLatitude': record.gpsLatitude,
            'gpsLongitude': record.gpsLongitude,
            'whatLearned': record.whatLearned,
            'classFeedback': record.classFeedback,
            'postMood': record.postMood,
            'uploadedAt': DateTime.now().toIso8601String(),
          });
      return true;
    } catch (e) {
      print('Error uploading check-out: $e');
      return false;
    }
  }

  // Fetch all sessions from Firestore
  Future<List<Map<String, dynamic>>> fetchAllSessions() async {
    try {
      if (!isAuthenticated) {
        print('User not authenticated');
        return [];
      }

      final userId = currentUser!.uid;
      final sessions = <Map<String, dynamic>>[];

      final checkinsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('checkins')
          .get();

      for (var doc in checkinsSnapshot.docs) {
        sessions.add({
          'type': 'checkin',
          'data': doc.data(),
        });
      }

      return sessions;
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
  }

  // Sync local data to Firestore (batch upload)
  Future<bool> syncLocalDataToCloud(
    List<CheckInRecord> checkIns,
    List<CheckOutRecord> checkOuts,
  ) async {
    try {
      if (!isAuthenticated) {
        print('User not authenticated - sync skipped');
        return false;
      }

      // Upload all check-ins
      for (final checkIn in checkIns) {
        await uploadCheckIn(checkIn);
      }

      // Upload all check-outs
      for (final checkOut in checkOuts) {
        await uploadCheckOut(checkOut);
      }

      return true;
    } catch (e) {
      print('Error syncing data: $e');
      return false;
    }
  }

  // Listen to real-time updates
  Stream<QuerySnapshot> getCheckInsStream() {
    if (!isAuthenticated) {
      return Stream.empty();
    }

    final userId = currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('checkins')
        .orderBy('checkinTime', descending: true)
        .snapshots();
  }

  // Get user statistics from Firestore
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      if (!isAuthenticated) {
        return {};
      }

      final userId = currentUser!.uid;
      final userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      print('Error fetching user stats: $e');
      return {};
    }
  }

  // Delete user data from Firestore
  Future<bool> deleteUserData() async {
    try {
      if (!isAuthenticated) {
        return false;
      }

      final userId = currentUser!.uid;
      await _firestore.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      print('Error deleting user data: $e');
      return false;
    }
  }
}
