import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';
import '../../core/services/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Background animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startSplashSequence() async {
    try {
      // Set status bar style for splash
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );

      // Start background animation immediately
      _backgroundController.forward();

      // Start logo animation after a short delay
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _logoController.forward();
        
        // Add haptic feedback
        HapticFeedback.lightImpact();
      }

      // Start text animation
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _textController.forward();
      }

      // Start progress animation
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _progressController.forward();
      }

      // Initialize app services during splash
      await _initializeAppServices();

      // Wait for animations to complete
      await Future.delayed(const Duration(milliseconds: 1000));

      // Navigate to next screen
      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      debugPrint('❌ Splash Screen: Error during splash sequence - $e');
      // Navigate anyway if there's an error
      if (mounted) {
        _navigateToRegister();
      }
    }
  }

  Future<void> _initializeAppServices() async {
    try {
      debugPrint('🔄 Splash Screen: Initializing app services...');
      
      // Initialize session manager
      await SessionManager().initialize();
      
      // Add any other initialization here
      // await SomeOtherService().initialize();
      
      debugPrint('✅ Splash Screen: App services initialized successfully');
    } catch (e) {
      debugPrint('❌ Splash Screen: Error initializing services - $e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    try {
      // Check if user is already logged in
      final sessionManager = SessionManager();
      
      if (sessionManager.isLoggedIn && sessionManager.isSessionValid()) {
        // User is logged in, go to home
        debugPrint('🏠 Splash Screen: User logged in, navigating to home');
        _navigateToHome();
      } else {
        // User not logged in, go to register
        debugPrint('📝 Splash Screen: User not logged in, navigating to register');
        _navigateToRegister();
      }
    } catch (e) {
      debugPrint('❌ Splash Screen: Error checking session - $e');
      _navigateToRegister();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _navigateToRegister() {
    Navigator.pushReplacementNamed(context, AppRoutes.register);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF6C5CE7),
                    const Color(0xFF5A4FCF),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF5A4FCF),
                    const Color(0xFF4834D4),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF4834D4),
                    const Color(0xFF3742FA),
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Main content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo section
                          _buildLogoSection(),
                          const SizedBox(height: 40),
                          
                          // Text section
                          _buildTextSection(),
                          const SizedBox(height: 60),
                          
                          // Progress section
                          _buildProgressSection(),
                        ],
                      ),
                    ),
                  ),
                  
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextSection() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textOpacityAnimation,
            child: Column(
              children: [
                // App name
                const Text(
                  'DomCry',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Tagline
                Text(
                  'Your Gateway to Cryptocurrency',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Secure • Fast • Reliable',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Column(
          children: [
            // Loading text
            Text(
              'Initializing...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            
            // Progress bar
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Progress percentage
            Text(
              '${(_progressAnimation.value * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          // Version
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          
          // Copyright
          Text(
            '© 2024 DomCry. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}