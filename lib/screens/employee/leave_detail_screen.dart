import 'package:flutter/material.dart';
import '../../models/leave_model.dart';
import '../../utils/date_helper.dart';

class LeaveDetailScreen extends StatelessWidget {
  final LeaveModel leave;
  const LeaveDetailScreen({super.key, required this.leave});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = DateHelper.daysBetween(leave.startDate, leave.endDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getStatusColor(leave.status).withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getStatusColor(leave.status),
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    leave.isApproved
                        ? Icons.check_circle
                        : leave.isRejected
                        ? Icons.cancel
                        : Icons.access_time,
                    size: 60,
                    color: _getStatusColor(leave.status),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    leave.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(leave.status),
                    ),
                  ),
                  if (leave.isPending) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Your leave request is under review',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Info
                  _DetailCard(
                    title: 'Leave Information',
                    children: [
                      _DetailRow(
                        icon: Icons.event_note,
                        label: 'Leave Type',
                        value: leave.leaveType,
                      ),
                      _DetailRow(
                        icon: Icons.calendar_today,
                        label: 'Start Date',
                        value: DateHelper.formatForDisplay(leave.startDate),
                      ),
                      _DetailRow(
                        icon: Icons.event,
                        label: 'End Date',
                        value: DateHelper.formatForDisplay(leave.endDate),
                      ),
                      _DetailRow(
                        icon: Icons.timelapse,
                        label: 'Duration',
                        value: '$days ${days == 1 ? 'day' : 'days'}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Reason
                  _DetailCard(
                    title: 'Reason',
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          leave.reason,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}