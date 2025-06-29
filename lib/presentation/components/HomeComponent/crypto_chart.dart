import 'package:flutter/material.dart';

class CryptoChart extends StatelessWidget {
  final List<double> chartData;
  final bool isPositive;
  final double width;
  final double height;
  final Color? lineColor;
  final double strokeWidth;
  final bool showGradient;

  const CryptoChart({
    super.key,
    required this.chartData,
    required this.isPositive,
    this.width = double.infinity,
    this.height = 100,
    this.lineColor,
    this.strokeWidth = 2.5,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No chart data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: showGradient
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (lineColor ?? (isPositive ? Colors.green : Colors.red))
                      .withOpacity(0.1),
                  (lineColor ?? (isPositive ? Colors.green : Colors.red))
                      .withOpacity(0.02),
                ],
              )
            : null,
      ),
      child: CustomPaint(
        painter: CryptoChartPainter(
          data: chartData,
          color: lineColor ?? (isPositive ? Colors.green : Colors.red),
          strokeWidth: strokeWidth,
          showGradient: showGradient,
        ),
      ),
    );
  }
}

class CryptoChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double strokeWidth;
  final bool showGradient;

  CryptoChartPainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.showGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final gradientPath = Path();
    
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    
    if (range == 0) return;

    // Create points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minValue) / range) * size.height;
      points.add(Offset(x, y));
    }

    // Create smooth curve
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      gradientPath.moveTo(points[0].dx, points[0].dy);
      
      for (int i = 1; i < points.length; i++) {
        final cp1x = points[i - 1].dx + (points[i].dx - points[i - 1].dx) / 3;
        final cp1y = points[i - 1].dy;
        final cp2x = points[i].dx - (points[i].dx - points[i - 1].dx) / 3;
        final cp2y = points[i].dy;
        
        path.cubicTo(cp1x, cp1y, cp2x, cp2y, points[i].dx, points[i].dy);
        gradientPath.cubicTo(cp1x, cp1y, cp2x, cp2y, points[i].dx, points[i].dy);
      }
    }

    // Draw gradient fill if enabled
    if (showGradient && points.isNotEmpty) {
      gradientPath.lineTo(points.last.dx, size.height);
      gradientPath.lineTo(points.first.dx, size.height);
      gradientPath.close();

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(gradientPath, gradientPaint);
    }

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, strokeWidth / 2, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}