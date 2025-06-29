import 'package:flutter/material.dart';
import '../../../data/dummy/trade_data_dummy.dart';

class TradeChartPreview extends StatefulWidget {
  final String tradingPair;

  const TradeChartPreview({
    super.key,
    required this.tradingPair,
  });

  @override
  State<TradeChartPreview> createState() => _TradeChartPreviewState();
}

class _TradeChartPreviewState extends State<TradeChartPreview> {
  String selectedTimeframe = '1H';
  final List<String> timeframes = ['1H', '4H', '1D', '1W'];

  @override
  Widget build(BuildContext context) {
    final chartData = TradeDataDummy.getChartData(widget.tradingPair, selectedTimeframe);
    final pairData = TradeDataDummy.getTradingPair(widget.tradingPair);
    final hasData = TradeDataDummy.hasChartData(widget.tradingPair);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timeframe Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Chart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: timeframes.map((timeframe) {
                  final isSelected = timeframe == selectedTimeframe;
                  final isAvailable = hasData && chartData.isNotEmpty;
                  
                  return GestureDetector(
                    onTap: isAvailable ? () {
                      setState(() {
                        selectedTimeframe = timeframe;
                      });
                    } : null,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected && isAvailable 
                            ? const Color(0xFF6C5CE7) 
                            : isAvailable 
                                ? Colors.grey.shade100
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        timeframe,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected && isAvailable 
                              ? Colors.white 
                              : isAvailable 
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Chart Area
          SizedBox(
            height: 200,
            child: hasData && chartData.isNotEmpty
                ? CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: ChartPainter(
                      data: chartData,
                      isPositive: pairData?['isPositive'] ?? true,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hasData ? 'Loading chart data...' : 'Chart data not available',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                        if (!hasData) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Please try again later',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
          
          const SizedBox(height: 16),
          
          // Chart Stats
          if (pairData != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartStat('Current', '\$${TradeDataDummy.formatPrice(pairData['price'])}'),
                _buildChartStat(
                  'Change', 
                  TradeDataDummy.formatPercentage(pairData['changePercent']), 
                  color: pairData['isPositive'] ? Colors.green : Colors.red
                ),
                _buildChartStat(
                  'Volume', 
                  _formatVolume(pairData['volume24h'])
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildChartStat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1e9) {
      return '${(volume / 1e9).toStringAsFixed(1)}B';
    } else if (volume >= 1e6) {
      return '${(volume / 1e6).toStringAsFixed(0)}M';
    } else if (volume >= 1e3) {
      return '${(volume / 1e3).toStringAsFixed(0)}K';
    } else {
      return volume.toStringAsFixed(0);
    }
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final bool isPositive;

  ChartPainter({required this.data, required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double stepX = size.width / (data.length - 1);
    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double rangeY = maxY - minY;

    // Handle case where all values are the same
    if (rangeY == 0) {
      final y = size.height / 2;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    } else {
      for (int i = 0; i < data.length; i++) {
        final double x = i * stepX;
        final double y = size.height - ((data[i] - minY) / rangeY) * size.height;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(path, paint);

    // Draw gradient fill
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          (isPositive ? Colors.green : Colors.red).withOpacity(0.2),
          (isPositive ? Colors.green : Colors.red).withOpacity(0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, gradientPaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    if (rangeY != 0) {
      for (int i = 0; i < data.length; i++) {
        final double x = i * stepX;
        final double y = size.height - ((data[i] - minY) / rangeY) * size.height;
        
        // Draw small circles at data points
        canvas.drawCircle(Offset(x, y), 2.0, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}