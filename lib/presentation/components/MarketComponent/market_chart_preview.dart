import 'package:flutter/material.dart';

class MarketChartPreview extends StatelessWidget {
  final List<dynamic> sparklineData; // Changed to dynamic to handle both int and double
  final bool isPositive;
  final double width;
  final double height;

  const MarketChartPreview({
    super.key,
    required this.sparklineData,
    required this.isPositive,
    this.width = 80,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    // Convert all data to double safely
    final List<double> convertedData = sparklineData
        .map((e) => _toDouble(e))
        .where((e) => e.isFinite) // Filter out any invalid numbers
        .toList();

    if (convertedData.isEmpty) {
      // Return empty container if no valid data
      return SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Icon(
              Icons.show_chart,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: SparklinePainter(
          data: convertedData,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  // Safe conversion method
  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Safe min/max calculation
    double minValue = data.first;
    double maxValue = data.first;
    
    for (final value in data) {
      if (value < minValue) minValue = value;
      if (value > maxValue) maxValue = value;
    }
    
    final range = maxValue - minValue;
    
    // Handle case where all values are the same
    if (range == 0 || !range.isFinite) {
      // Draw a straight line in the middle
      final y = size.height / 2;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    } else {
      // Draw the actual chart
      for (int i = 0; i < data.length; i++) {
        final x = (i / (data.length - 1)) * size.width;
        final normalizedValue = (data[i] - minValue) / range;
        final y = size.height - (normalizedValue * size.height);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(path, paint);

    // Add gradient fill under the line
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is SparklinePainter && 
           (oldDelegate.data != data || oldDelegate.color != color);
  }
}