import 'package:flutter/material.dart';
import '../../../data/dummy/home_data_dummy.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children: [
          // Crypto Holdings Row  
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: HomeDataDummy.walletHoldings.map((holding) {
              final isPositive = holding['isPositive'] as bool;
              final changePercent = holding['changePercent'] as double;
              final usdValue = holding['usdValue'] as double;
              
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      holding['symbol'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      HomeDataDummy.formatPrice(usdValue),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPositive 
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        HomeDataDummy.formatPercentage(changePercent),
                        style: TextStyle(
                          fontSize: 10,
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          
          // Action Buttons Row
          Row(
            children: [
              // Send Button
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF5A4FCF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                    label: const Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Receive Button
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 18),
                    label: const Text(
                      'Get',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Buy Button
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6C5CE7), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Color(0xFF6C5CE7), size: 18),
                  label: const Text(
                    'Buy',
                    style: TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}