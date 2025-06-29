import 'package:flutter/material.dart';
import '../pages/HomePage/home_page.dart';
import '../pages/MarketPage/market_page.dart';
import '../pages/TradePage/trade_page.dart';
import '../pages/SettingsPage/settings_page.dart';
import '../pages/LoginPage/login_page.dart';
import '../pages/RegisterPage/register_page.dart';
import '../widgets/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String market = '/market';
  static const String trade = '/trade';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: splash),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: const RouteSettings(name: register),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: const RouteSettings(name: login),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: const RouteSettings(name: home),
        );
      case market:
        return MaterialPageRoute(
          builder: (_) => const MarketPage(),
          settings: const RouteSettings(name: market),
        );
      case trade:
        return MaterialPageRoute(
          builder: (_) => const TradePage(),
          settings: const RouteSettings(name: trade),
        );
      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: const RouteSettings(name: settings),
        );
      
      // DEFAULT CASE: Always redirect to splash if route not found
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: splash),
        );
    }
  }

  // Helper method to get initial route - ALWAYS SPLASH
  static String getInitialRoute() {
    return splash;
  }

  // Helper method to check if user should be logged in
  static Future<bool> isUserLoggedIn() async {
    // Here you would check SharedPreferences or other storage
    // For now, we'll always return false to force registration
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getBool('isLoggedIn') ?? false;
    return false;
  }

  // Helper method to clear user session
  static Future<void> clearUserSession() async {
    // Clear all user data and session
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    print('User session cleared');
  }

  // Helper method for navigation with custom transitions
  static Route<T> createRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Helper method for fade transition
  static Route<T> createFadeRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Helper method to navigate and clear all previous routes
  static void navigateAndClearAll(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  // Helper method to check if current route is splash
  static bool isSplashRoute(String? routeName) {
    return routeName == splash;
  }

  // Helper method to check if current route is register
  static bool isRegisterRoute(String? routeName) {
    return routeName == register;
  }

  // Helper method to check if current route is login
  static bool isLoginRoute(String? routeName) {
    return routeName == login;
  }
}