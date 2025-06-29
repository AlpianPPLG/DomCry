import 'package:flutter/material.dart';
import '../../../data/dummy/home_data_dummy.dart';
import 'crypto_chart.dart';

class CryptoList extends StatefulWidget {
  const CryptoList({super.key});

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  String selectedPeriod = '1M';

  @override
  Widget build(BuildContext context) {
    final bitcoinData = HomeDataDummy.bitcoinPrice;
    final chartData = HomeDataDummy.getBitcoinChartData(selectedPeriod);
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with time period selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${bitcoinData['name']} (${bitcoinData['symbol']})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: HomeDataDummy.timePeriods.map((period) {
                  final isSelected = period == selectedPeriod;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPeriod = period;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF6C5CE7) 
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Price and change
          Row(
            children: [
              Text(
                HomeDataDummy.formatPrice(bitcoinData['price']),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bitcoinData['isPositive'] 
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  HomeDataDummy.formatPercentage(bitcoinData['changePercent']),
                  style: TextStyle(
                    color: bitcoinData['isPositive'] ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Chart
          CryptoChart(
            chartData: chartData,
            isPositive: bitcoinData['isPositive'],
            height: 120,
            lineColor: const Color(0xFF6C5CE7),
            strokeWidth: 3,
            showGradient: true,
          ),
          
          const SizedBox(height: 16),
          
          // Additional info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                'Market Cap',
                '\$${_formatLargeNumber(bitcoinData['marketCap'])}',
              ),
              _buildInfoItem(
                '24h Volume',
                '\$${_formatLargeNumber(bitcoinData['volume24h'])}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatLargeNumber(double number) {
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