import 'package:flutter/material.dart';
import '../../../data/dummy/trade_data_dummy.dart';

class TradePairSelector extends StatelessWidget {
  final String selectedPair;
  final Function(String) onPairChanged;

  const TradePairSelector({
    super.key,
    required this.selectedPair,
    required this.onPairChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentPair = TradeDataDummy.getTradingPair(selectedPair);
    
    return Container(
      margin: const EdgeInsets.all(20),
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
          // Current Pair Info
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showPairSelector(context),
                  child: Row(
                    children: [
                      Text(
                        selectedPair,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF6C5CE7),
                      ),
                    ],
                  ),
                ),
              ),
              if (currentPair != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${TradeDataDummy.formatPrice(currentPair['price'])}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: currentPair['isPositive']
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        TradeDataDummy.formatPercentage(currentPair['changePercent']),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: currentPair['isPositive'] ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          
          if (currentPair != null) ...[
            const SizedBox(height: 16),
            // 24h Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('24h High', '\$${TradeDataDummy.formatPrice(currentPair['high24h'])}'),
                _buildStatItem('24h Low', '\$${TradeDataDummy.formatPrice(currentPair['low24h'])}'),
                _buildStatItem('24h Volume', '${(currentPair['volume24h'] / 1e9).toStringAsFixed(1)}B'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showPairSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Trading Pair',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: TradeDataDummy.tradingPairs.length,
                itemBuilder: (context, index) {
                  final pair = TradeDataDummy.tradingPairs[index];
                  final isSelected = pair['symbol'] == selectedPair;
                  
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          pair['baseAsset'][0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      pair['symbol'],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF6C5CE7) : null,
                      ),
                    ),
                    subtitle: Text(
                      '\$${TradeDataDummy.formatPrice(pair['price'])}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: pair['isPositive']
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        TradeDataDummy.formatPercentage(pair['changePercent']),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: pair['isPositive'] ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      onPairChanged(pair['symbol']);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}