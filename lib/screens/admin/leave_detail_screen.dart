import 'package:flutter/material.dart';
import '../../models/leave_model.dart';
import '../../services/api_service.dart';
import '../../core/exceptions/app_exception.dart';
import '../../utils/date_helper.dart';

class LeaveDetailScreen extends StatefulWidget {
  final LeaveModel leave;
  const LeaveDetailScreen({super.key, required this.leave});

  @override
  State<LeaveDetailScreen> createState() => _LeaveDetailScreenState();
}

class _LeaveDetailScreenState extends State<LeaveDetailScreen> {
  bool _loading = false;

  Future<void> _updateStatus(String status) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${status == 'approved' ? 'Approve' : 'Reject'} Leave'),
        content: Text(
          'Are you sure you want to ${status} this leave request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'approved' ? Colors.green : Colors.red,
            ),
            child: Text(status == 'approved' ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loading = true);

    try {
      final result = await ApiService.updateLeaveStatus(
        leaveId: widget.leave.id,
        status: status,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Status updated successfully!');
        // Return to previous screen
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        _showError(result['message'] ?? 'Failed to update status');
      }
    } on AppException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
    final leave = widget.leave;
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
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Info
                  _DetailCard(
                    title: 'Employee Information',
                    children: [
                      _DetailRow(
                        icon: Icons.person,
                        label: 'Name',
                        value: leave.employeeName ?? 'N/A',
                      ),
                      _DetailRow(
                        icon: Icons.business,
                        label: 'Department',
                        value: leave.department ?? 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 24),

                  // Action Buttons (only for pending leaves)
                  if (leave.isPending) ...[
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _loading ? null : () => _updateStatus('approved'),
                              icon: const Icon(Icons.check),
                              label: const Text(
                                'Approve',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _loading ? null : () => _updateStatus('rejected'),
                              icon: const Icon(Icons.close),
                              label: const Text(
                                'Reject',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_loading) ...[
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
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