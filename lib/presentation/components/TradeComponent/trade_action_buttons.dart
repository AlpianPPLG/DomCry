import 'package:flutter/material.dart';

class TradeActionButtons extends StatelessWidget {
  final String selectedOrderType;
  final Function(String) onOrderTypeChanged;
  final Map<String, dynamic>? orderData;
  final VoidCallback onExecuteTrade;
  final bool isLoading;

  const TradeActionButtons({
    super.key,
    required this.selectedOrderType,
    required this.onOrderTypeChanged,
    required this.orderData,
    required this.onExecuteTrade,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final canExecute = _canExecuteTrade();
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Buy/Sell Toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onOrderTypeChanged('buy'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selectedOrderType == 'buy' 
                            ? Colors.green 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'BUY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOrderType == 'buy' 
                              ? Colors.white 
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onOrderTypeChanged('sell'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selectedOrderType == 'sell' 
                            ? Colors.red 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'SELL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOrderType == 'sell' 
                              ? Colors.white 
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Execute Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: canExecute && !isLoading ? onExecuteTrade : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOrderType == 'buy' 
                    ? Colors.green 
                    : Colors.red,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Disclaimer
          Text(
            'By placing this order, you agree to our Terms of Service',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  bool _canExecuteTrade() {
    if (orderData == null) return false;
    
    final amount = orderData!['amount'] as double? ?? 0;
    final price = orderData!['price'] as double? ?? 0;
    final total = orderData!['total'] as double? ?? 0;
    
    return amount > 0 && price > 0 && total > 0;
  }

  String _getButtonText() {
    if (!_canExecuteTrade()) {
      return 'Enter Amount';
    }
    
    final orderType = selectedOrderType.toUpperCase();
    final orderMode = orderData?['orderMode']?.toString().toUpperCase() ?? 'LIMIT';
    
    return '$orderType ($orderMode)';
  }
}