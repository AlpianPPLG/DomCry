import 'package:flutter/material.dart';
import '../../../data/dummy/market_data_dummy.dart';

class MarketHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;

  const MarketHeader({
    super.key,
    this.onSearchTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C5CE7),
            Color(0xFF74B9FF),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Market',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: onSearchTap,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: onFilterTap,
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Market Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Market Cap',
                          '\$${_formatNumber(_toDouble(MarketDataDummy.marketStats['totalMarketCap']))}',
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          '24h Volume',
                          '\$${_formatNumber(_toDouble(MarketDataDummy.marketStats['totalVolume24h']))}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'BTC Dominance',
                          '${_toDouble(MarketDataDummy.marketStats['btcDominance']).toStringAsFixed(1)}%',
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Active Coins',
                          '${_toInt(MarketDataDummy.marketStats['activeCryptocurrencies'])}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  String _formatNumber(double number) {
    if (!number.isFinite || number.isNaN) return '0';
    
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(1)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(2);
  }
}