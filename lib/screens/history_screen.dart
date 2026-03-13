import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_model.dart';
import '../services/database_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<AttendanceSession>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = _dbService.getAllSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: FutureBuilder<List<AttendanceSession>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No attendance records yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return _buildSessionCard(session);
            },
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(AttendanceSession session) {
    final checkIn = session.checkIn;
    final checkOut = session.checkOut;
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              session.isCompleted
                  ? Icons.check_circle
                  : Icons.schedule,
              color: session.isCompleted
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(checkIn.checkinTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Class ${checkIn.classId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: session.isCompleted
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                session.isCompleted ? 'Completed' : 'Pending',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: session.isCompleted
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check-in Details
                _buildDetailSection(
                  'Check-in Details',
                  [
                    _buildDetailRow(
                      'Time',
                      timeFormatter.format(checkIn.checkinTime),
                    ),
                    _buildDetailRow(
                      'Location',
                      '${checkIn.gpsLatitude.toStringAsFixed(4)}, ${checkIn.gpsLongitude.toStringAsFixed(4)}',
                    ),
                    _buildDetailRow(
                      'Previous Topic',
                      checkIn.previousTopic,
                    ),
                    _buildDetailRow(
                      'Expected Topic',
                      checkIn.expectedTopic,
                    ),
                    _buildDetailRow(
                      'Pre-class Mood',
                      _getMoodEmoji(checkIn.preMood),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Check-out Details (if available)
                if (checkOut != null)
                  _buildDetailSection(
                    'Check-out Details',
                    [
                      _buildDetailRow(
                        'Time',
                        timeFormatter.format(checkOut.checkoutTime),
                      ),
                      _buildDetailRow(
                        'Location',
                        '${checkOut.gpsLatitude.toStringAsFixed(4)}, ${checkOut.gpsLongitude.toStringAsFixed(4)}',
                      ),
                      _buildDetailRow(
                        'What Learned',
                        checkOut.whatLearned,
                      ),
                      _buildDetailRow(
                        'Feedback',
                        checkOut.classFeedback,
                      ),
                      if (checkOut.postMood != null)
                        _buildDetailRow(
                          'Post-class Mood',
                          _getMoodEmoji(checkOut.postMood!),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😡 Very Negative';
      case 2:
        return '🙁 Negative';
      case 3:
        return '😐 Neutral';
      case 4:
        return '🙂 Positive';
      case 5:
        return '😄 Very Positive';
      default:
        return 'N/A';
    }
  }
}
