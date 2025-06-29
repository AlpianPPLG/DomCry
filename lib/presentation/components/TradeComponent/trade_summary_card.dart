import 'package:flutter/material.dart';
import '../../../data/dummy/trade_data_dummy.dart';

class TradeSummaryCard extends StatelessWidget {
  final Map<String, dynamic>? orderData;

  const TradeSummaryCard({
    super.key,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return const SizedBox.shrink();
    }

    final tradingPair = orderData!['tradingPair'] as String;
    final orderType = orderData!['orderType'] as String;
    final orderMode = orderData!['orderMode'] as String;
    final price = orderData!['price'] as double;
    final amount = orderData!['amount'] as double;
    final total = orderData!['total'] as double;
    final fee = orderData!['fee'] as double;

    final pairData = TradeDataDummy.getTradingPair(tradingPair);
    final baseAsset = pairData?['baseAsset'] ?? '';
    final quoteAsset = pairData?['quoteAsset'] ?? '';
    final isBuy = orderType == 'buy';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBuy ? Colors.green.shade200 : Colors.red.shade200,
          width: 1,
        ),
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isBuy ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${orderType.toUpperCase()} ORDER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isBuy ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  orderMode.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                tradingPair,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Order Details
          _buildDetailRow('Side', orderType.toUpperCase(), 
              color: isBuy ? Colors.green : Colors.red),
          
          if (orderMode == 'limit')
            _buildDetailRow('Price', '${TradeDataDummy.formatPrice(price)} $quoteAsset'),
          
          _buildDetailRow('Amount', '${TradeDataDummy.formatAmount(amount)} $baseAsset'),
          
          _buildDetailRow('Total', '${TradeDataDummy.formatPrice(total)} $quoteAsset'),
          
          const Divider(height: 24),
          
          // Fee Breakdown
          _buildDetailRow('Trading Fee', '${TradeDataDummy.formatPrice(fee)} $quoteAsset',
              isSubtle: true),
          
          _buildDetailRow('Net Total', 
              '${TradeDataDummy.formatPrice(isBuy ? total + fee : total - fee)} $quoteAsset',
              isBold: true),
          
          const SizedBox(height: 16),
          
          // Estimated Execution
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    orderMode == 'market' 
                        ? 'Market order will execute immediately at current market price'
                        : 'Limit order will execute when market price reaches your specified price',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Balance Check
          _buildBalanceCheck(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {
    Color? color,
    bool isSubtle = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSubtle ? 12 : 14,
              color: isSubtle ? Colors.grey.shade600 : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isSubtle ? 12 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCheck() {
    if (orderData == null) return const SizedBox.shrink();
    
    final tradingPair = orderData!['tradingPair'] as String;
    final orderType = orderData!['orderType'] as String;
    final amount = orderData!['amount'] as double;
    final total = orderData!['total'] as double;
    final fee = orderData!['fee'] as double;

    final pairData = TradeDataDummy.getTradingPair(tradingPair);
    final baseAsset = pairData?['baseAsset'] ?? '';
    final quoteAsset = pairData?['quoteAsset'] ?? '';
    final isBuy = orderType == 'buy';

    final requiredAsset = isBuy ? quoteAsset : baseAsset;
    final requiredAmount = isBuy ? total + fee : amount;
    final availableBalance = TradeDataDummy.getUserBalance(requiredAsset);
    final hasEnoughBalance = availableBalance >= requiredAmount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasEnoughBalance ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            hasEnoughBalance ? Icons.check_circle_outline : Icons.error_outline,
            size: 16,
            color: hasEnoughBalance ? Colors.green.shade600 : Colors.red.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasEnoughBalance ? 'Sufficient Balance' : 'Insufficient Balance',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasEnoughBalance ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
                Text(
                  'Required: ${TradeDataDummy.formatAmount(requiredAmount)} $requiredAsset | '
                  'Available: ${TradeDataDummy.formatAmount(availableBalance)} $requiredAsset',
                  style: TextStyle(
                    fontSize: 11,
                    color: hasEnoughBalance ? Colors.green.shade600 : Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}