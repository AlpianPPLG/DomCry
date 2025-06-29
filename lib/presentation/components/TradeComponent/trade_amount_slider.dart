import 'package:flutter/material.dart';
import '../../../data/dummy/trade_data_dummy.dart';

class TradeAmountSlider extends StatefulWidget {
  final String tradingPair;
  final String orderType; // 'buy' or 'sell'
  final Function(int) onPercentageChanged;

  const TradeAmountSlider({
    super.key,
    required this.tradingPair,
    required this.orderType,
    required this.onPercentageChanged,
  });

  @override
  State<TradeAmountSlider> createState() => _TradeAmountSliderState();
}

class _TradeAmountSliderState extends State<TradeAmountSlider> {
  int selectedPercentage = 0;

  @override
  Widget build(BuildContext context) {
    final pairData = TradeDataDummy.getTradingPair(widget.tradingPair);
    final baseAsset = pairData?['baseAsset'] ?? '';
    final quoteAsset = pairData?['quoteAsset'] ?? '';
    final isBuy = widget.orderType == 'buy';
    final asset = isBuy ? quoteAsset : baseAsset;
    final balance = TradeDataDummy.getUserBalance(asset);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount Selector',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Balance: ${TradeDataDummy.formatAmount(balance)} $asset',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Percentage Buttons
          Row(
            children: TradeDataDummy.amountPercentages.map((percentage) {
              final isSelected = selectedPercentage == percentage;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPercentage = percentage;
                    });
                    // Use post frame callback to avoid setState during build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onPercentageChanged(percentage);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF6C5CE7)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF6C5CE7)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      '$percentage%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Amount Preview
          if (selectedPercentage > 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Amount:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '$selectedPercentage% of balance',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBuy ? 'Total to spend:' : 'Amount to sell:',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${TradeDataDummy.formatAmount(_calculateSelectedAmount())} $asset',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  if (isBuy && pairData != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Est. $baseAsset received:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${TradeDataDummy.formatAmount(_calculateSelectedAmount() / pairData['price'])} $baseAsset',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Custom Slider
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF6C5CE7),
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: const Color(0xFF6C5CE7),
                  overlayColor: const Color(0xFF6C5CE7).withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: selectedPercentage.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      selectedPercentage = value.round();
                    });
                    // Use post frame callback to avoid setState during build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onPercentageChanged(selectedPercentage);
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '100%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateSelectedAmount() {
    final pairData = TradeDataDummy.getTradingPair(widget.tradingPair);
    final baseAsset = pairData?['baseAsset'] ?? '';
    final quoteAsset = pairData?['quoteAsset'] ?? '';
    final isBuy = widget.orderType == 'buy';
    final asset = isBuy ? quoteAsset : baseAsset;
    
    if (isBuy) {
      return TradeDataDummy.calculateTotalFromPercentage(asset, selectedPercentage);
    } else {
      return TradeDataDummy.calculateAmountFromPercentage(asset, selectedPercentage);
    }
  }
}