import 'package:flutter/material.dart';
import 'market_chart_preview.dart';

class MarketCoinTile extends StatelessWidget {
  final Map<String, dynamic> coin;
  final VoidCallback? onTap;

  const MarketCoinTile({
    super.key,
    required this.coin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Safe conversion for price change percentage
    final priceChangePercentage = _toDouble(coin['priceChangePercentage24h']);
    final isPositive = priceChangePercentage >= 0;
    final currentPrice = _toDouble(coin['currentPrice']);
    final rank = _toInt(coin['rank']);
    final color = _toInt(coin['color']);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#$rank',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  coin['icon']?.toString() ?? '?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(color),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin['name']?.toString() ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    coin['symbol']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Chart Preview with safe data conversion
            MarketChartPreview(
              sparklineData: _getSparklineData(coin['sparklineData']),
              isPositive: isPositive,
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${_formatPrice(currentPrice)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isPositive 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${isPositive ? '+' : ''}${priceChangePercentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Safe conversion methods
  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  List<dynamic> _getSparklineData(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    return [];
  }

  String _formatPrice(double price) {
    if (!price.isFinite || price.isNaN) return '0.00';
    
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(2)}M';
    } else if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else if (price >= 1) {
      return price.toStringAsFixed(4);
    } else if (price >= 0.01) {
      return price.toStringAsFixed(6);
    } else {
      return price.toStringAsFixed(8);
    }
  }
}