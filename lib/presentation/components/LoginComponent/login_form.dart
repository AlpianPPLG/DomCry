import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/session_manager.dart';
import '../../routes/app_routes.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSignUp;

  const LoginForm({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onSignUp,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize session manager and clear any existing session
    _initializeAndClearSession();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  void _initializeAndClearSession() async {
    try {
      debugPrint('🔄 Login Form: Initializing and clearing session...');
      
      // Force logout to clear any existing session
      await SessionManager().forceLogout();
      
      // Load any saved preferences (like remember me)
      await _loadSavedPreferences();
      
      debugPrint('✅ Login Form: Session cleared and preferences loaded');
    } catch (e) {
      debugPrint('❌ Login Form: Error during initialization - $e');
    }
  }

  Future<void> _loadSavedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load remember me preference
      final savedRememberMe = prefs.getBool('rememberMe') ?? false;
      
      // If remember me was enabled, load saved email
      if (savedRememberMe) {
        final savedEmail = prefs.getString('savedEmail') ?? '';
        if (savedEmail.isNotEmpty) {
          setState(() {
            _emailController.text = savedEmail;
            _rememberMe = true;
          });
          debugPrint('📧 Login Form: Loaded saved email for remember me');
        }
      }
    } catch (e) {
      debugPrint('❌ Login Form: Error loading saved preferences - $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),
                
                // Firebase Info
                _buildFirebaseInfo(),
                const SizedBox(height: 20),
                
                // Email Field
                _buildEmailField(),
                const SizedBox(height: 20),
                
                // Password Field
                _buildPasswordField(),
                const SizedBox(height: 16),
                
                // Remember Me & Forgot Password
                _buildRememberAndForgot(),
                const SizedBox(height: 32),
                
                // Login Button
                _buildLoginButton(),
                const SizedBox(height: 20),
                
                // Biometric Login
                _buildBiometricLogin(),
                const SizedBox(height: 24),
                
                // Divider
                _buildDivider(),
                const SizedBox(height: 24),
                
                // Sign Up Link
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: Color(0xFF6C5CE7),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to your DomCry account',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFirebaseInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_done,
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Firebase Authentication',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Login with your registered Firebase account. Use the email and password you created during registration.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter your registered email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleLogin(),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: const Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: widget.onForgotPassword ?? _showForgotPasswordDialog,
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6C5CE7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildBiometricLogin() {
    return Column(
      children: [
        Text(
          'Or sign in with',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleBiometricLogin,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fingerprint,
                      color: Color(0xFF6C5CE7),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Use Biometric',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'New to DomCry?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: widget.onSignUp ?? _navigateToRegister,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: RichText(
        text: const TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF2D3748),
          ),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Color(0xFF6C5CE7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      debugPrint('🔄 Login Form: Starting Firebase login process...');
      
      // Use SessionManager for Firebase login
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final loginSuccess = await SessionManager().login(
        email, 
        password, 
        rememberMe: _rememberMe,
      );

      if (loginSuccess) {
        // Save remember me preference
        await _saveRememberMePreference();
        
        // Show success message
        _showSuccessMessage();
        
        // Small delay for UX
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Navigate to home
        if (mounted) {
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!();
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context, 
              AppRoutes.home, 
              (route) => false,
            );
          }
        }
      } else {
        // Invalid credentials
        _showErrorMessage('Invalid email or password. Please check your credentials or register a new account.');
      }
    } catch (e) {
      debugPrint('❌ Login Form: Login error - $e');
      _showErrorMessage('Login failed. Please check your internet connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveRememberMePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_rememberMe) {
        await prefs.setBool('rememberMe', true);
        await prefs.setString('savedEmail', _emailController.text.trim());
        debugPrint('💾 Login Form: Remember me preference saved');
      } else {
        await prefs.remove('rememberMe');
        await prefs.remove('savedEmail');
        debugPrint('🗑️ Login Form: Remember me preference cleared');
      }
    } catch (e) {
      debugPrint('❌ Login Form: Error saving remember me preference - $e');
    }
  }

  void _handleBiometricLogin() {
    HapticFeedback.lightImpact();
    _showComingSoonDialog('Biometric Login');
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'Login successful! Welcome back!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.help_outline,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Forgot Password'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password recovery feature is coming soon. For now, please make sure you remember your password or create a new account.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tip: Use the "Remember me" option to save your login credentials.',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.construction,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Coming Soon'),
          ],
        ),
        content: Text(
          '$feature feature is coming soon! We\'re working hard to bring you the best experience.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}