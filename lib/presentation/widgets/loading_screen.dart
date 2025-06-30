import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A modern and professional loading screen widget designed to be used as an overlay.
/// It features a semi-transparent background, a custom spinning animation, and a customizable message.
class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({
    Key? key,
    this.message = 'Loading, please wait...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent modal barrier to prevent user interaction with the UI below.
        const ModalBarrier(dismissible: false, color: Colors.black54),
        
        // Centered content with a modern card-like design.
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // A custom, more visually appealing loading indicator.
                const _SpinningIconIndicator(),
                const SizedBox(height: 24.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A private helper widget that creates a smooth, infinitely spinning icon animation.
class _SpinningIconIndicator extends StatefulWidget {
  const _SpinningIconIndicator({Key? key}) : super(key: key);

  @override
  __SpinningIconIndicatorState createState() => __SpinningIconIndicatorState();
}

class __SpinningIconIndicatorState extends State<_SpinningIconIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Icon(
        Icons.settings,
        size: 50.0,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}


  class MyPage extends StatefulWidget {
    @override
    _MyPageState createState() => _MyPageState();
  }

  class _MyPageState extends State<MyPage> {
    bool _isLoading = false;

    void _toggleLoading() {
      setState(() {
        _isLoading = !_isLoading;
      });

      if (_isLoading) {
        // Simulate a network request or long-running task
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) { // Check if the widget is still in the tree
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Screen Example'),
        ),
        body: Stack(
          children: [
            // Your main page content goes here
            Center(
              child: ElevatedButton(
                onPressed: _toggleLoading,
                child: const Text('Show Loading Screen'),
              ),
            ),

            // Conditionally display the loading screen overlay
            if (_isLoading)
              const LoadingScreen(message: 'Processing your request...'),
          ],
        ),
      );
    }
  }
