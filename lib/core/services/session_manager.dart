import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'firebase_auth_service.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // Firebase Auth Service
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  // Session state
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userId;
  String? _fullname;
  DateTime? _loginTime;
  Map<String, dynamic> _userData = {};

  // SharedPreferences keys
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserId = 'userId';
  static const String _keyFullname = 'fullname';
  static const String _keyLoginTime = 'loginTime';
  static const String _keyUserData = 'userData';
  static const String _keySessionId = 'sessionId';
  static const String _keyRememberMe = 'rememberMe';

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get fullname => _fullname;
  DateTime? get loginTime => _loginTime;
  Map<String, dynamic> get userData => Map.from(_userData);

  // Initialize session manager
  Future<void> initialize() async {
    try {
      await loadSessionData();
      debugPrint('✅ Session Manager: Initialized successfully');
    } catch (e) {
      debugPrint('❌ Session Manager: Initialization error - $e');
      await logout();
    }
  }

  // Register method with Firebase
  Future<Map<String, dynamic>> register({
    required String fullname,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      debugPrint('🔄 Session Manager: Starting registration process...');
      
      final result = await _firebaseAuth.registerUser(
        fullname: fullname,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result['success'] == true) {
        debugPrint('✅ Session Manager: Registration successful');
        
        // Don't auto-login after registration, redirect to login
        return {
          'success': true,
          'message': result['message'],
          'userData': result['userData'],
        };
      } else {
        debugPrint('❌ Session Manager: Registration failed - ${result['message']}');
        return result;
      }
    } catch (e) {
      debugPrint('❌ Session Manager: Registration error - $e');
      return {
        'success': false,
        'message': 'Registration failed. Please try again.',
      };
    }
  }

  // Login method with Firebase
  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    try {
      debugPrint('🔄 Session Manager: Starting login process...');
      
      final result = await _firebaseAuth.loginUser(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final now = DateTime.now();
        final sessionId = now.millisecondsSinceEpoch.toString();
        final userData = result['userData'] as Map<String, dynamic>;
        
        // Update local state
        _isLoggedIn = true;
        _userEmail = userData['email'];
        _userId = userData['userId'];
        _fullname = userData['fullname'];
        _loginTime = now;
        _userData = {
          'email': userData['email'],
          'userId': userData['userId'],
          'fullname': userData['fullname'],
          'loginTime': now.toIso8601String(),
          'sessionId': sessionId,
          'rememberMe': rememberMe,
          'lastLoginAt': userData['lastLoginAt'],
        };
        
        // Save to SharedPreferences
        await prefs.setBool(_keyIsLoggedIn, true);
        await prefs.setString(_keyUserEmail, userData['email']);
        await prefs.setString(_keyUserId, userData['userId']);
        await prefs.setString(_keyFullname, userData['fullname']);
        await prefs.setString(_keyLoginTime, now.toIso8601String());
        await prefs.setString(_keyUserData, jsonEncode(_userData));
        await prefs.setString(_keySessionId, sessionId);
        await prefs.setBool(_keyRememberMe, rememberMe);
        
        debugPrint('✅ Session Manager: User logged in successfully');
        debugPrint('📧 Email: ${userData['email']}');
        debugPrint('👤 Fullname: ${userData['fullname']}');
        debugPrint('🆔 User ID: ${userData['userId']}');
        debugPrint('⏰ Login Time: $now');
        debugPrint('🔑 Session ID: $sessionId');
        debugPrint('💾 Remember Me: $rememberMe');
        debugPrint('💾 Data saved to SharedPreferences');
        
        return true;
      } else {
        debugPrint('❌ Session Manager: Login failed - ${result['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Session Manager: Login error - $e');
      return false;
    }
  }

  // Logout method with complete SharedPreferences clearing
  Future<void> logout() async {
    try {
      debugPrint('🔄 Session Manager: Starting logout process...');
      
      final prefs = await SharedPreferences.getInstance();
      
      // Clear local state first
      _isLoggedIn = false;
      _userEmail = null;
      _userId = null;
      _fullname = null;
      _loginTime = null;
      _userData.clear();
      
      // Clear ALL SharedPreferences data
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyFullname);
      await prefs.remove(_keyLoginTime);
      await prefs.remove(_keyUserData);
      await prefs.remove(_keySessionId);
      await prefs.remove(_keyRememberMe);
      
      // Verify clearing
      final isCleared = !prefs.containsKey(_keyIsLoggedIn) && 
                       !prefs.containsKey(_keyUserEmail) &&
                       !prefs.containsKey(_keyUserId);
      
      debugPrint('✅ Session Manager: Logout completed successfully');
      debugPrint('🗑️ All session data cleared from memory');
      debugPrint('🗑️ All SharedPreferences data cleared');
      debugPrint('✅ Verification: Data cleared = $isCleared');
      
    } catch (e) {
      debugPrint('❌ Session Manager: Logout error - $e');
      // Even if there's an error, clear local state
      _isLoggedIn = false;
      _userEmail = null;
      _userId = null;
      _fullname = null;
      _loginTime = null;
      _userData.clear();
      rethrow;
    }
  }

  // Check if session is valid
  bool isSessionValid() {
    if (!_isLoggedIn || _loginTime == null || _userId == null) {
      debugPrint('⚠️ Session Manager: No active session');
      return false;
    }
    
    // Check if session is not older than 24 hours (optional)
    final now = DateTime.now();
    final sessionAge = now.difference(_loginTime!);
    
    if (sessionAge.inHours > 24) {
      debugPrint('⚠️ Session Manager: Session expired (older than 24 hours)');
      logout();
      return false;
    }
    
    debugPrint('✅ Session Manager: Session is valid');
    return true;
  }

  // Load session data from SharedPreferences
  Future<void> loadSessionData() async {
    try {
      debugPrint('🔄 Session Manager: Loading session data...');
      
      final prefs = await SharedPreferences.getInstance();
      
      // Load session data
      _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      _userEmail = prefs.getString(_keyUserEmail);
      _userId = prefs.getString(_keyUserId);
      _fullname = prefs.getString(_keyFullname);
      
      final loginTimeString = prefs.getString(_keyLoginTime);
      if (loginTimeString != null) {
        _loginTime = DateTime.parse(loginTimeString);
      }
      
      final userDataString = prefs.getString(_keyUserData);
      if (userDataString != null) {
        _userData = Map<String, dynamic>.from(jsonDecode(userDataString));
      }
      
      debugPrint('📂 Session Manager: Session data loaded from SharedPreferences');
      debugPrint('🔐 Is Logged In: $_isLoggedIn');
      debugPrint('📧 Email: $_userEmail');
      debugPrint('👤 Fullname: $_fullname');
      debugPrint('🆔 User ID: $_userId');
      debugPrint('⏰ Login Time: $_loginTime');
      
      // Validate loaded session
      if (_isLoggedIn && !isSessionValid()) {
        debugPrint('⚠️ Session Manager: Loaded session is invalid, clearing...');
        await logout();
      }
      
    } catch (e) {
      debugPrint('❌ Session Manager: Error loading session data - $e');
      await logout();
    }
  }

  // Check if user should stay logged in (remember me)
  Future<bool> shouldRememberUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyRememberMe) ?? false;
    } catch (e) {
      debugPrint('❌ Session Manager: Error checking remember me - $e');
      return false;
    }
  }

  // Get current user data from Firebase
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    if (_userId == null) return null;
    
    try {
      return await _firebaseAuth.getUserData(_userId!);
    } catch (e) {
      debugPrint('❌ Session Manager: Error getting current user data - $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateProfile({String? fullname, String? email}) async {
    if (_userId == null) return false;
    
    try {
      final result = await _firebaseAuth.updateUserProfile(
        userId: _userId!,
        fullname: fullname,
        email: email,
      );
      
      final bool success = result['success'] ?? false;

      if (success) {
        // Update local data
        if (fullname != null) _fullname = fullname;
        if (email != null) _userEmail = email;
        
        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (fullname != null) await prefs.setString(_keyFullname, fullname);
        if (email != null) await prefs.setString(_keyUserEmail, email);
        
        _userData.addAll({
          if (fullname != null) 'fullname': fullname,
          if (email != null) 'email': email,
          'updatedAt': DateTime.now().toIso8601String(),
        });
        
        await prefs.setString(_keyUserData, jsonEncode(_userData));
      }
      
      return success;
    } catch (e) {
      debugPrint('❌ Session Manager: Error updating profile - $e');
      return false;
    }
  }

  // Get session info for debugging
  Map<String, dynamic> getSessionInfo() {
    return {
      'isLoggedIn': _isLoggedIn,
      'userEmail': _userEmail,
      'userId': _userId,
      'fullname': _fullname,
      'loginTime': _loginTime?.toIso8601String(),
      'sessionAge': _loginTime != null 
          ? DateTime.now().difference(_loginTime!).toString()
          : null,
      'userData': _userData,
    };
  }

  // Force clear all data (emergency method)
  Future<void> forceLogout() async {
    try {
      debugPrint('🚨 Session Manager: Force logout initiated');
      
      final prefs = await SharedPreferences.getInstance();
      
      // Clear everything
      await prefs.clear();
      
      // Reset local state
      _isLoggedIn = false;
      _userEmail = null;
      _userId = null;
      _fullname = null;
      _loginTime = null;
      _userData.clear();
      
      debugPrint('✅ Session Manager: Force logout completed - all data cleared');
      
    } catch (e) {
      debugPrint('❌ Session Manager: Force logout error - $e');
    }
  }
}