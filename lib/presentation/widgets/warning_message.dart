import 'package:flutter/material.dart';

class WarningMessageWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final String confirmButtonText;

  const WarningMessageWidget({
    Key? key,
    this.title = 'Warning',
    required this.message,
    this.onConfirm,
    this.confirmButtonText = 'OK',
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
          border: Border.all(color: Colors.amber.shade200, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber.shade600,
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
            if (onConfirm != null) ...[
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: onConfirm,
                child: Text(
                  confirmButtonText,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.amber.withOpacity(0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
