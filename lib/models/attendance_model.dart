class CheckInRecord {
  final String checkinId;
  final String studentId;
  final String classId;
  final DateTime checkinTime;
  final double gpsLatitude;
  final double gpsLongitude;
  final String previousTopic;
  final String expectedTopic;
  final int preMood; // 1-5 scale

  CheckInRecord({
    required this.checkinId,
    required this.studentId,
    required this.classId,
    required this.checkinTime,
    required this.gpsLatitude,
    required this.gpsLongitude,
    required this.previousTopic,
    required this.expectedTopic,
    required this.preMood,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'checkinId': checkinId,
      'studentId': studentId,
      'classId': classId,
      'checkinTime': checkinTime.toIso8601String(),
      'gpsLatitude': gpsLatitude,
      'gpsLongitude': gpsLongitude,
      'previousTopic': previousTopic,
      'expectedTopic': expectedTopic,
      'preMood': preMood,
    };
  }

  // Create from Map
  factory CheckInRecord.fromMap(Map<String, dynamic> map) {
    return CheckInRecord(
      checkinId: map['checkinId'],
      studentId: map['studentId'],
      classId: map['classId'],
      checkinTime: DateTime.parse(map['checkinTime']),
      gpsLatitude: map['gpsLatitude'],
      gpsLongitude: map['gpsLongitude'],
      previousTopic: map['previousTopic'],
      expectedTopic: map['expectedTopic'],
      preMood: map['preMood'],
    );
  }
}

class CheckOutRecord {
  final String checkoutId;
  final String checkinId;
  final DateTime checkoutTime;
  final double gpsLatitude;
  final double gpsLongitude;
  final String whatLearned;
  final String classFeedback;
  final int? postMood; // Optional

  CheckOutRecord({
    required this.checkoutId,
    required this.checkinId,
    required this.checkoutTime,
    required this.gpsLatitude,
    required this.gpsLongitude,
    required this.whatLearned,
    required this.classFeedback,
    this.postMood,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'checkoutId': checkoutId,
      'checkinId': checkinId,
      'checkoutTime': checkoutTime.toIso8601String(),
      'gpsLatitude': gpsLatitude,
      'gpsLongitude': gpsLongitude,
      'whatLearned': whatLearned,
      'classFeedback': classFeedback,
      'postMood': postMood,
    };
  }

  // Create from Map
  factory CheckOutRecord.fromMap(Map<String, dynamic> map) {
    return CheckOutRecord(
      checkoutId: map['checkoutId'],
      checkinId: map['checkinId'],
      checkoutTime: DateTime.parse(map['checkoutTime']),
      gpsLatitude: map['gpsLatitude'],
      gpsLongitude: map['gpsLongitude'],
      whatLearned: map['whatLearned'],
      classFeedback: map['classFeedback'],
      postMood: map['postMood'],
    );
  }
}

class AttendanceSession {
  final CheckInRecord checkIn;
  final CheckOutRecord? checkOut;

  AttendanceSession({
    required this.checkIn,
    this.checkOut,
  });

  bool get isCompleted => checkOut != null;
}
