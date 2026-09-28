import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'admin');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    final success = auth.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = auth.errorMessage ?? 'Gagal masuk. Cek username/password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.warehouse_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'WAREHOUSE SYSTEM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'PBL UAS - Mobile Programming',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.greyLight.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: AppColors.greyDark,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.greyDark,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.greyLight.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: AppColors.greyDark,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.greyDark,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.greyDark,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Center(
                  child: SizedBox(
                    width: 140,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greyLight,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        side: const BorderSide(color: AppColors.border, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textPrimary,
                              ),
                            )
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                Center(
                  child: Text(
                    'Demo Akun: username: admin | password: apa saja',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.greyDark.withValues(alpha: 0.8),
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
