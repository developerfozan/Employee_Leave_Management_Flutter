import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/employee/employee_dashboard.dart';
import '../core/exceptions/app_exception.dart';
import '../utils/validators.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  final String userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final UserModel user = result['user'];

        // Check if user type matches
        if (widget.userType == 'admin' && user.isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AdminDashboard(admin: user),
            ),
          );
        } else if (widget.userType == 'employee' && !user.isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeDashboard(employee: user),
            ),
          );
        } else {
          _showError(
            widget.userType == 'admin'
                ? 'You are not authorized as admin'
                : 'Admins cannot login here. Please use Admin Login.',
          );
        }
      } else {
        _showError(result['message'] ?? 'Login failed');
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.userType == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text('${isAdmin ? 'Admin' : 'Employee'} Login'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Icon
                Icon(
                  isAdmin ? Icons.admin_panel_settings : Icons.person,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: Validators.validateEmail,
                  enabled: !_loading,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: Validators.validatePassword,
                  enabled: !_loading,
                ),
                const SizedBox(height: 32),

                // Login Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _loading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Back Button
                TextButton(
                  onPressed: _loading ? null : () => Navigator.pop(context),
                  child: const Text('Back to Selection'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}