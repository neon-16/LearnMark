import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import '../models/attendance_model.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';
import '../services/qr_service.dart';
import '../widgets/qr_scanner_page.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final LocationService _locationService = LocationService();
  final DatabaseService _dbService = DatabaseService();
  final QRService _qrService = QRService();

  // Form controllers
  final TextEditingController _previousTopicController = TextEditingController();
  final TextEditingController _expectedTopicController = TextEditingController();
  final TextEditingController _classIdController = TextEditingController();

  int _selectedMood = 3; // Default neutral
  Position? _currentPosition;
  bool _isLoading = false;
  String _statusMessage = '';
  bool _locationObtained = false;

  Future<void> _scanQRCode() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const QRScannerPage(title: 'Scan Class QR'),
      ),
    );

    if (!mounted) return;

    if (scannedValue != null && scannedValue.isNotEmpty) {
      setState(() {
        _classIdController.text = scannedValue;
        _statusMessage = 'QR code captured';
      });
    }
  }

  @override
  void dispose() {
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    _classIdController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Getting your location...';
    });

    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _locationObtained = true;
        _statusMessage = 'Location obtained: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });
    } else {
      setState(() {
        _statusMessage = 'Failed to get location. Please try again.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitCheckIn() async {
    if (_previousTopicController.text.isEmpty ||
        _expectedTopicController.text.isEmpty ||
        _classIdController.text.isEmpty ||
        _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and obtain location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate QR code format
    if (!_qrService.isValidClassQRCode(_classIdController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR code format. Expected: CLASS:ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Submitting check-in...';
    });

    try {
      final checkInRecord = CheckInRecord(
        checkinId: const Uuid().v4(),
        studentId: 'STUDENT_001', // Should come from auth
        classId: _qrService.extractClassId(_classIdController.text) ?? '',
        checkinTime: DateTime.now(),
        gpsLatitude: _currentPosition!.latitude,
        gpsLongitude: _currentPosition!.longitude,
        previousTopic: _previousTopicController.text,
        expectedTopic: _expectedTopicController.text,
        preMood: _selectedMood,
      );

      final success = await _dbService.insertCheckIn(checkInRecord);

      if (success) {
        setState(() {
          _statusMessage = 'Check-in successful!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check-in saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        setState(() {
          _statusMessage = 'Error saving check-in';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in to Class'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'GPS Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _locationObtained
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_currentPosition != null)
                      Text(
                        'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}\nLng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      )
                    else
                      Text(
                        'No location obtained yet',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _getLocation,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Get Location'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // QR Code Section
            Text(
              'Scan QR Code',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _scanQRCode,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Open Scanner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'or enter manually',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _classIdController,
              decoration: InputDecoration(
                hintText: 'CLASS:12345 or scan QR code',
                prefixIcon: const Icon(Icons.qr_code_2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 20),

            // Previous Topic
            Text(
              'What topic was covered in the previous class?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _previousTopicController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter topic...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 20),

            // Expected Topic
            Text(
              'What topic do you expect to learn today?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _expectedTopicController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter topic...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 20),

            // Mood Selection
            Text(
              'How is your mood before class?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodButton(1, '😡', 'Very\nNegative'),
                _buildMoodButton(2, '🙁', 'Negative'),
                _buildMoodButton(3, '😐', 'Neutral'),
                _buildMoodButton(4, '🙂', 'Positive'),
                _buildMoodButton(5, '😄', 'Very\nPositive'),
              ],
            ),
            const SizedBox(height: 30),

            // Status Message
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    border: Border.all(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(color: Color(0xFF0F172A)),
                  ),
                ),
              ),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitCheckIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Check-in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(int mood, String emoji, String label) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
              : Colors.white,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
