import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../core/exceptions/app_exception.dart';
import '../../utils/validators.dart';
import '../../utils/date_helper.dart';
import '../../config/constants.dart';

class ApplyLeaveScreen extends StatefulWidget {
  final UserModel employee;
  const ApplyLeaveScreen({super.key, required this.employee});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Reset end date if it's before start date
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      _showError('Please select start date first');
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _applyLeave() async {
    FocusScope.of(context).unfocus();

    // Validate all fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLeaveType == null) {
      _showError('Please select leave type');
      return;
    }

    if (_startDate == null) {
      _showError('Please select start date');
      return;
    }

    if (_endDate == null) {
      _showError('Please select end date');
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await ApiService.applyLeave(
        employeeId: widget.employee.id,
        leaveType: _selectedLeaveType!,
        startDate: DateHelper.formatForApi(_startDate!),
        endDate: DateHelper.formatForApi(_endDate!),
        reason: _reasonController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Leave applied successfully!');
        _clearForm();
      } else {
        _showError(result['message'] ?? 'Failed to apply leave');
      }
    } on NetworkException catch (e) {
      if (!mounted) return;
      _showError(e.message);
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

  void _clearForm() {
    _reasonController.clear();
    setState(() {
      _selectedLeaveType = null;
      _startDate = null;
      _endDate = null;
    });
    _formKey.currentState?.reset();
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

  int? _getDuration() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final duration = _getDuration();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Leave Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedLeaveType,
                  decoration: InputDecoration(
                    labelText: 'Leave Type',
                    prefixIcon: const Icon(Icons.event_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  items: LeaveTypes.all.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: _loading ? null : (value) {
                    setState(() => _selectedLeaveType = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select leave type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Start Date
                InkWell(
                  onTap: _loading ? null : _selectStartDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    child: Text(
                      _startDate == null
                          ? 'Select start date'
                          : DateHelper.formatForDisplay(
                          DateHelper.formatForApi(_startDate!)),
                      style: TextStyle(
                        color: _startDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // End Date
                InkWell(
                  onTap: _loading ? null : _selectEndDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      prefixIcon: const Icon(Icons.event),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    child: Text(
                      _endDate == null
                          ? 'Select end date'
                          : DateHelper.formatForDisplay(
                          DateHelper.formatForApi(_endDate!)),
                      style: TextStyle(
                        color: _endDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),

                // Duration Display
                if (duration != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timelapse, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Duration: $duration ${duration == 1 ? 'day' : 'days'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Reason
                TextFormField(
                  controller: _reasonController,
                  maxLines: 5,
                  maxLength: ValidationRules.maxReasonLength,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.description),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: Validators.validateReason,
                  enabled: !_loading,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _applyLeave,
                    icon: _loading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.send),
                    label: Text(
                      _loading ? 'Submitting...' : 'Apply Leave',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}