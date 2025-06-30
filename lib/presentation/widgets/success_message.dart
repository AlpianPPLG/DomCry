import 'package:flutter/material.dart';

class SuccessMessageWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onContinue;

  const SuccessMessageWidget({
    Key? key,
    this.title = 'Success!',
    required this.message,
    this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.green.shade100, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green.shade400,
              size: 64.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey.shade600,
              ),
            ),
            if (onContinue != null) ...[
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                label: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.green.withOpacity(0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
