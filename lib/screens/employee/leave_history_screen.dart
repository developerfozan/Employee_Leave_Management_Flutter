import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/leave_model.dart';
import '../../services/api_service.dart';
import '../../core/exceptions/app_exception.dart';
import '../../utils/date_helper.dart';
import 'leave_detail_screen.dart';

class LeaveHistoryScreen extends StatefulWidget {
  final UserModel employee;
  const LeaveHistoryScreen({super.key, required this.employee});

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {
  List<LeaveModel> _leaves = [];
  List<LeaveModel> _filteredLeaves = [];
  bool _loading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fetchLeaves();
  }

  Future<void> _fetchLeaves() async {
    setState(() => _loading = true);

    try {
      final leaves = await ApiService.getLeaves(employeeId: widget.employee.id);
      if (mounted) {
        setState(() {
          _leaves = leaves;
          _applyFilter();
          _loading = false;
        });
      }
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showError(e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showError('Failed to load leave history');
      }
    }
  }

  void _applyFilter() {
    if (_selectedFilter == 'all') {
      _filteredLeaves = _leaves;
    } else {
      _filteredLeaves = _leaves.where((leave) => leave.status == _selectedFilter).toList();
    }
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave History'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _fetchLeaves,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == 'all',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'all';
                        _applyFilter();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: _selectedFilter == 'pending',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'pending';
                        _applyFilter();
                      });
                    },
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Approved',
                    isSelected: _selectedFilter == 'approved',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'approved';
                        _applyFilter();
                      });
                    },
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Rejected',
                    isSelected: _selectedFilter == 'rejected',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'rejected';
                        _applyFilter();
                      });
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // Leaves List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredLeaves.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No leave applications found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your leave history will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _fetchLeaves,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredLeaves.length,
                itemBuilder: (context, index) {
                  final leave = _filteredLeaves[index];
                  final days = DateHelper.daysBetween(leave.startDate, leave.endDate);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeaveDetailScreen(leave: leave),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    leave.leaveType,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(leave.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getStatusIcon(leave.status),
                                        size: 16,
                                        color: _getStatusColor(leave.status),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        leave.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(leave.status),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  '${DateHelper.formatForDisplay(leave.startDate)} - ${DateHelper.formatForDisplay(leave.endDate)}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.timelapse, size: 16, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  '$days ${days == 1 ? 'day' : 'days'}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}