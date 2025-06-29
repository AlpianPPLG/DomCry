import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection names
  static const String _usersCollection = 'users';
  static const String _registerCollection = 'register';
  static const String _loginCollection = 'login';

  // Hash password for security
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Test Firestore connection
  Future<bool> testFirestoreConnection() async {
    try {
      debugPrint('🔍 Firebase Auth: Testing Firestore connection...');
      
      // Try to read from a collection to test permissions
      await _firestore
          .collection(_registerCollection)
          .limit(1)
          .get();
      
      debugPrint('✅ Firebase Auth: Firestore connection successful');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase Auth: Firestore connection failed - $e');
      
      if (e.toString().contains('permission-denied')) {
        debugPrint('🚨 Firebase Auth: PERMISSION DENIED - Please check Firestore Security Rules');
        debugPrint('📋 Required Rules:');
        debugPrint('   match /register/{document} { allow read, write: if true; }');
        debugPrint('   match /login/{document} { allow read, write: if true; }');
      }
      
      return false;
    }
  }

  // Check if email already exists with better error handling
  Future<Map<String, dynamic>> isEmailExists(String email) async {
    try {
      debugPrint('🔍 Firebase Auth: Checking if email exists - $email');
      
      // Test connection first
      if (!await testFirestoreConnection()) {
        return {
          'exists': false,
          'error': 'Firestore connection failed. Please check your internet connection and Firebase configuration.',
        };
      }
      
      final querySnapshot = await _firestore
          .collection(_registerCollection)
          .where('email', isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();
      
      final exists = querySnapshot.docs.isNotEmpty;
      debugPrint('📧 Firebase Auth: Email exists = $exists');
      
      return {
        'exists': exists,
        'error': null,
      };
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error checking email existence - $e');
      
      String errorMessage = 'Failed to check email availability.';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please check Firestore Security Rules.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      return {
        'exists': false,
        'error': errorMessage,
      };
    }
  }

  // Check if fullname already exists with better error handling
  Future<Map<String, dynamic>> isFullnameExists(String fullname) async {
    try {
      debugPrint('🔍 Firebase Auth: Checking if fullname exists - $fullname');
      
      // Test connection first
      if (!await testFirestoreConnection()) {
        return {
          'exists': false,
          'error': 'Firestore connection failed. Please check your internet connection and Firebase configuration.',
        };
      }
      
      final querySnapshot = await _firestore
          .collection(_registerCollection)
          .where('fullname', isEqualTo: fullname.trim())
          .limit(1)
          .get();
      
      final exists = querySnapshot.docs.isNotEmpty;
      debugPrint('👤 Firebase Auth: Fullname exists = $exists');
      
      return {
        'exists': exists,
        'error': null,
      };
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error checking fullname existence - $e');
      
      String errorMessage = 'Failed to check name availability.';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please check Firestore Security Rules.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      return {
        'exists': false,
        'error': errorMessage,
      };
    }
  }

  // Register new user with comprehensive error handling
  Future<Map<String, dynamic>> registerUser({
    required String fullname,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      debugPrint('🔄 Firebase Auth: Starting user registration...');
      
      // Test Firestore connection first
      if (!await testFirestoreConnection()) {
        return {
          'success': false,
          'message': 'Cannot connect to Firebase. Please check your internet connection and try again.',
        };
      }
      
      // Validate input
      if (fullname.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'All fields are required',
        };
      }

      if (password != confirmPassword) {
        return {
          'success': false,
          'message': 'Passwords do not match',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password must be at least 6 characters',
        };
      }

      // Email validation
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return {
          'success': false,
          'message': 'Please enter a valid email address',
        };
      }

      final cleanEmail = email.toLowerCase().trim();
      final cleanFullname = fullname.trim();

      // Check if email already exists
      final emailCheck = await isEmailExists(cleanEmail);
      if (emailCheck['error'] != null) {
        return {
          'success': false,
          'message': emailCheck['error'],
        };
      }
      if (emailCheck['exists'] == true) {
        return {
          'success': false,
          'message': 'Email already exists. Please use a different email.',
        };
      }

      // Check if fullname already exists
      final nameCheck = await isFullnameExists(cleanFullname);
      if (nameCheck['error'] != null) {
        return {
          'success': false,
          'message': nameCheck['error'],
        };
      }
      if (nameCheck['exists'] == true) {
        return {
          'success': false,
          'message': 'Full name already exists. Please use a different name.',
        };
      }

      // Hash password
      final hashedPassword = _hashPassword(password);
      final now = DateTime.now();

      // Prepare user data
      final userData = {
        'fullname': cleanFullname,
        'email': cleanEmail,
        'password': hashedPassword,
        'confirmpassword': hashedPassword, // Same as password after hashing
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'isActive': true,
        'registrationIP': 'mobile_app',
        'lastLoginAt': null,
        'deviceInfo': 'Flutter Mobile App',
        'version': '1.0.0',
      };

      debugPrint('💾 Firebase Auth: Saving user data to Firestore...');

      // Save to register collection
      final docRef = await _firestore
          .collection(_registerCollection)
          .add(userData);

      debugPrint('✅ Firebase Auth: User data saved to register collection');

      // Also save to login collection for authentication
      final loginData = {
        'email': cleanEmail,
        'password': hashedPassword,
        'userId': docRef.id,
        'fullname': cleanFullname,
        'createdAt': now.toIso8601String(),
        'isActive': true,
        'lastLoginAt': null,
        'deviceInfo': 'Flutter Mobile App',
      };

      await _firestore
          .collection(_loginCollection)
          .doc(docRef.id)
          .set(loginData);

      debugPrint('✅ Firebase Auth: User data saved to login collection');
      debugPrint('✅ Firebase Auth: User registered successfully');
      debugPrint('📧 Email: $cleanEmail');
      debugPrint('👤 Fullname: $cleanFullname');
      debugPrint('🆔 User ID: ${docRef.id}');

      return {
        'success': true,
        'message': 'Account created successfully! You can now login with your credentials.',
        'userId': docRef.id,
        'userData': {
          'fullname': cleanFullname,
          'email': cleanEmail,
          'userId': docRef.id,
        },
      };

    } catch (e) {
      debugPrint('❌ Firebase Auth: Registration error - $e');
      
      String errorMessage = 'Registration failed. Please try again.';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please contact support or try again later.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('unavailable')) {
        errorMessage = 'Service temporarily unavailable. Please try again later.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Login user with comprehensive error handling
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔄 Firebase Auth: Starting user login...');
      
      // Test Firestore connection first
      if (!await testFirestoreConnection()) {
        return {
          'success': false,
          'message': 'Cannot connect to Firebase. Please check your internet connection and try again.',
        };
      }
      
      // Validate input
      if (email.trim().isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email and password are required',
        };
      }

      final cleanEmail = email.toLowerCase().trim();
      final hashedPassword = _hashPassword(password);

      debugPrint('🔍 Firebase Auth: Querying login collection...');

      // Query login collection
      final querySnapshot = await _firestore
          .collection(_loginCollection)
          .where('email', isEqualTo: cleanEmail)
          .where('password', isEqualTo: hashedPassword)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('❌ Firebase Auth: Invalid credentials');
        return {
          'success': false,
          'message': 'Invalid email or password. Please check your credentials.',
        };
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      final userId = userDoc.id;

      debugPrint('✅ Firebase Auth: User found, updating login time...');

      // Update last login time
      final now = DateTime.now();
      await _firestore
          .collection(_loginCollection)
          .doc(userId)
          .update({
        'lastLoginAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });

      // Also update in register collection
      await _firestore
          .collection(_registerCollection)
          .doc(userId)
          .update({
        'lastLoginAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });

      debugPrint('✅ Firebase Auth: User logged in successfully');
      debugPrint('📧 Email: $cleanEmail');
      debugPrint('👤 Fullname: ${userData['fullname']}');
      debugPrint('🆔 User ID: $userId');

      return {
        'success': true,
        'message': 'Login successful! Welcome back!',
        'userId': userId,
        'userData': {
          'fullname': userData['fullname'] ?? '',
          'email': userData['email'] ?? cleanEmail,
          'userId': userId,
          'lastLoginAt': now.toIso8601String(),
        },
      };

    } catch (e) {
      debugPrint('❌ Firebase Auth: Login error - $e');
      
      String errorMessage = 'Login failed. Please try again.';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please contact support or try again later.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('unavailable')) {
        errorMessage = 'Service temporarily unavailable. Please try again later.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Get user data by ID with error handling
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      debugPrint('🔍 Firebase Auth: Getting user data for ID: $userId');
      
      final doc = await _firestore
          .collection(_registerCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        debugPrint('✅ Firebase Auth: User data retrieved successfully');
        return doc.data();
      } else {
        debugPrint('⚠️ Firebase Auth: User not found');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error getting user data - $e');
      return null;
    }
  }

  // Get all registered users (for admin purposes)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      debugPrint('🔍 Firebase Auth: Getting all users...');
      
      final querySnapshot = await _firestore
          .collection(_registerCollection)
          .orderBy('createdAt', descending: true)
          .get();

      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Remove sensitive data
        data.remove('password');
        data.remove('confirmpassword');
        return data;
      }).toList();

      debugPrint('✅ Firebase Auth: Retrieved ${users.length} users');
      return users;
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error getting all users - $e');
      return [];
    }
  }

  // Check if user exists by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      debugPrint('🔍 Firebase Auth: Getting user by email: $email');
      
      final querySnapshot = await _firestore
          .collection(_registerCollection)
          .where('email', isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        data['id'] = doc.id;
        // Remove sensitive data
        data.remove('password');
        data.remove('confirmpassword');
        debugPrint('✅ Firebase Auth: User found by email');
        return data;
      } else {
        debugPrint('⚠️ Firebase Auth: User not found by email');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error getting user by email - $e');
      return null;
    }
  }

  // Update user profile with error handling
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    String? fullname,
    String? email,
  }) async {
    try {
      debugPrint('🔄 Firebase Auth: Updating user profile for ID: $userId');
      
      final updateData = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (fullname != null && fullname.trim().isNotEmpty) {
        // Check if new fullname already exists
        final nameCheck = await isFullnameExists(fullname.trim());
        if (nameCheck['error'] != null) {
          return {
            'success': false,
            'message': nameCheck['error'],
          };
        }
        if (nameCheck['exists'] == true) {
          return {
            'success': false,
            'message': 'Full name already exists. Please use a different name.',
          };
        }
        updateData['fullname'] = fullname.trim();
      }

      if (email != null && email.trim().isNotEmpty) {
        final cleanEmail = email.toLowerCase().trim();
        // Check if new email already exists
        final emailCheck = await isEmailExists(cleanEmail);
        if (emailCheck['error'] != null) {
          return {
            'success': false,
            'message': emailCheck['error'],
          };
        }
        if (emailCheck['exists'] == true) {
          return {
            'success': false,
            'message': 'Email already exists. Please use a different email.',
          };
        }
        updateData['email'] = cleanEmail;
      }

      // Update register collection
      await _firestore
          .collection(_registerCollection)
          .doc(userId)
          .update(updateData);

      // Update login collection
      await _firestore
          .collection(_loginCollection)
          .doc(userId)
          .update(updateData);

      debugPrint('✅ Firebase Auth: User profile updated successfully');
      return {
        'success': true,
        'message': 'Profile updated successfully!',
      };
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error updating user profile - $e');
      
      String errorMessage = 'Failed to update profile. Please try again.';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please contact support.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Delete user account with error handling
  Future<Map<String, dynamic>> deleteUserAccount(String userId) async {
    try {
      debugPrint('🔄 Firebase Auth: Deleting user account for ID: $userId');
      
      // Delete from both collections
      await _firestore
          .collection(_registerCollection)
          .doc(userId)
          .delete();

      await _firestore
          .collection(_loginCollection)
          .doc(userId)
          .delete();

      debugPrint('✅ Firebase Auth: User account deleted successfully');
      return {
        'success': true,
        'message': 'Account deleted successfully.',
      };
    } catch (e) {
      debugPrint('❌ Firebase Auth: Error deleting user account - $e');
      
      String errorMessage = 'Failed to delete account. Please try again.';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please contact support.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Get Firebase connection status
  Future<Map<String, dynamic>> getConnectionStatus() async {
    try {
      final isConnected = await testFirestoreConnection();
      return {
        'connected': isConnected,
        'timestamp': DateTime.now().toIso8601String(),
        'message': isConnected 
            ? 'Firebase connection is working properly'
            : 'Firebase connection failed - check security rules and internet connection',
      };
    } catch (e) {
      return {
        'connected': false,
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'Connection test failed: $e',
      };
    }
  }
}