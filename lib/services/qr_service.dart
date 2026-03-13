class QRService {
  static final QRService _instance = QRService._internal();

  factory QRService() {
    return _instance;
  }

  QRService._internal();

  // Validate QR code format
  bool isValidClassQRCode(String qrData) {
    // Expected format: CLASS:12345
    return qrData.startsWith('CLASS:') && qrData.length > 6;
  }

  // Extract class ID from QR code
  String? extractClassId(String qrData) {
    try {
      if (isValidClassQRCode(qrData)) {
        return qrData.split(':')[1];
      }
    } catch (e) {
      print('Error extracting class ID: $e');
    }
    return null;
  }

  // Generate QR code data for testing
  String generateTestQRCode(String classId) {
    return 'CLASS:$classId';
  }
}
