import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/dummy/trade_data_dummy.dart';

class TradeOrderForm extends StatefulWidget {
  final String tradingPair;
  final String orderType; // 'buy' or 'sell'
  final Function(Map<String, dynamic>) onOrderChanged;

  const TradeOrderForm({
    super.key,
    required this.tradingPair,
    required this.orderType,
    required this.onOrderChanged,
  });

  @override
  State<TradeOrderForm> createState() => _TradeOrderFormState();
}

class _TradeOrderFormState extends State<TradeOrderForm> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  
  String _orderMode = 'limit'; // 'limit' or 'market'
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  void _initializeForm() {
    final pairData = TradeDataDummy.getTradingPair(widget.tradingPair);
    if (pairData != null && mounted) {
      _priceController.text = TradeDataDummy.formatPrice(pairData['price']);
      _updateOrder();
    }
  }

  @override
  void didUpdateWidget(TradeOrderForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tradingPair != widget.tradingPair) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeForm();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pairData = TradeDataDummy.getTradingPair(widget.tradingPair);
    final baseAsset = pairData?['baseAsset'] ?? '';
    final quoteAsset = pairData?['quoteAsset'] ?? '';
    final isBuy = widget.orderType == 'buy';

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
          // Order Type Header
          Row(
            children: [
              Text(
                '${isBuy ? 'Buy' : 'Sell'} $baseAsset',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isBuy ? Colors.green : Colors.red,
                ),
              ),
              const Spacer(),
              // Order Mode Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModeButton('Limit', 'limit'),
                    _buildModeButton('Market', 'market'),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Available Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${TradeDataDummy.formatAmount(TradeDataDummy.getUserBalance(isBuy ? quoteAsset : baseAsset))} ${isBuy ? quoteAsset : baseAsset}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Price Input (only for limit orders)
          if (_orderMode == 'limit') ...[
            _buildInputField(
              label: 'Price ($quoteAsset)',
              controller: _priceController,
              onChanged: _onPriceChanged,
            ),
            const SizedBox(height: 12),
          ],
          
          // Amount Input
          _buildInputField(
            label: 'Amount ($baseAsset)',
            controller: _amountController,
            onChanged: _onAmountChanged,
          ),
          
          const SizedBox(height: 12),
          
          // Total Input
          _buildInputField(
            label: 'Total ($quoteAsset)',
            controller: _totalController,
            onChanged: _onTotalChanged,
            enabled: _orderMode == 'limit',
          ),
          
          const SizedBox(height: 16),
          
          // Order Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Order Type', _orderMode.toUpperCase()),
                _buildSummaryRow('Side', widget.orderType.toUpperCase()),
                if (_orderMode == 'limit')
                  _buildSummaryRow('Price', '${_priceController.text} $quoteAsset'),
                _buildSummaryRow('Amount', '${_amountController.text} $baseAsset'),
                _buildSummaryRow('Total', '${_totalController.text} $quoteAsset'),
                const Divider(),
                _buildSummaryRow(
                  'Est. Fee',
                  '${_calculateFee()} $quoteAsset',
                  isHighlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, String mode) {
    final isSelected = _orderMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _orderMode = mode;
          if (mode == 'market') {
            final pairData = TradeDataDummy.getTradingPair(widget.tradingPair);
            if (pairData != null) {
              _priceController.text = TradeDataDummy.formatPrice(pairData['price']);
            }
          }
        });
        // Use post frame callback for order update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateOrder();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: '0.00',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? const Color(0xFF6C5CE7) : null,
            ),
          ),
        ],
      ),
    );
  }

  void _onPriceChanged(String value) {
    if (!_isCalculating && _amountController.text.isNotEmpty) {
      _isCalculating = true;
      _calculateTotal();
      _isCalculating = false;
    }
    // Use post frame callback for order update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOrder();
    });
  }

  void _onAmountChanged(String value) {
    if (!_isCalculating && _priceController.text.isNotEmpty) {
      _isCalculating = true;
      _calculateTotal();
      _isCalculating = false;
    }
    // Use post frame callback for order update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOrder();
    });
  }

  void _onTotalChanged(String value) {
    if (!_isCalculating && _priceController.text.isNotEmpty) {
      _isCalculating = true;
      _calculateAmount();
      _isCalculating = false;
    }
    // Use post frame callback for order update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOrder();
    });
  }

  void _calculateTotal() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final amount = double.tryParse(_amountController.text) ?? 0;
    final total = price * amount;
    _totalController.text = total > 0 ? TradeDataDummy.formatPrice(total) : '';
  }

  void _calculateAmount() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final total = double.tryParse(_totalController.text) ?? 0;
    if (price > 0) {
      final amount = total / price;
      _amountController.text = amount > 0 ? TradeDataDummy.formatAmount(amount) : '';
    }
  }

  String _calculateFee() {
    final total = double.tryParse(_totalController.text) ?? 0;
    final fee = TradeDataDummy.calculateFee(total, 'taker');
    return TradeDataDummy.formatPrice(fee);
  }

  void _updateOrder() {
    if (!mounted) return;
    
    final orderData = {
      'tradingPair': widget.tradingPair,
      'orderType': widget.orderType,
      'orderMode': _orderMode,
      'price': double.tryParse(_priceController.text) ?? 0,
      'amount': double.tryParse(_amountController.text) ?? 0,
      'total': double.tryParse(_totalController.text) ?? 0,
      'fee': double.tryParse(_calculateFee()) ?? 0,
    };
    widget.onOrderChanged(orderData);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    _totalController.dispose();
    super.dispose();
  }
}