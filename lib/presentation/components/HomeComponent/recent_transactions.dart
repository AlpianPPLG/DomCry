import 'package:flutter/material.dart';
import '../../../data/dummy/home_data_dummy.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'Sent':
        return Icons.arrow_upward;
      case 'Received':
        return Icons.arrow_downward;
      case 'Bought':
        return Icons.add;
      case 'Sold':
        return Icons.remove;
      case 'Swapped':
        return Icons.swap_horiz;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'Sent':
      case 'Sold':
        return Colors.red;
      case 'Received':
      case 'Bought':
        return Colors.green;
      case 'Swapped':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 400;
    
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 16 : 20),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
          _buildHeader(context, isSmallScreen),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildTransactionsList(context, isSmallScreen, isMediumScreen),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.list, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('View All Transactions'),
                  ],
                ),
                backgroundColor: const Color(0xFF6C5CE7),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 4 : 8,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View All',
            style: TextStyle(
              color: const Color(0xFF6C5CE7),
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(BuildContext context, bool isSmallScreen, bool isMediumScreen) {
    return Column(
      children: HomeDataDummy.recentTransactions.take(4).map((transaction) {
        final type = transaction['type'] as String? ?? '';
        final description = transaction['description'] as String? ?? '';
        final amount = transaction['amount'] as double? ?? 0.0;
        final symbol = transaction['symbol'] as String? ?? '';
        final date = transaction['date'] as String? ?? '';
        final status = transaction['status'] as String? ?? '';
        final isPositive = transaction['isPositive'] as bool? ?? true;

        return _buildTransactionItem(
          context,
          type,
          description,
          amount,
          symbol,
          date,
          status,
          isPositive,
          isSmallScreen,
          isMediumScreen,
        );
      }).toList(),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String type,
    String description,
    double amount,
    String symbol,
    String date,
    String status,
    bool isPositive,
    bool isSmallScreen,
    bool isMediumScreen,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildTransactionIcon(type, isSmallScreen),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              flex: 3,
              child: _buildTransactionDetails(
                description,
                date,
                status,
                isSmallScreen,
                isMediumScreen,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              flex: 2,
              child: _buildTransactionAmount(
                amount,
                symbol,
                type,
                isPositive,
                isSmallScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionIcon(String type, bool isSmallScreen) {
    final iconSize = isSmallScreen ? 36.0 : 44.0;
    final iconInnerSize = isSmallScreen ? 16.0 : 20.0;
    
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: _getTransactionColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(iconSize / 2),
      ),
      child: Icon(
        _getTransactionIcon(type),
        color: _getTransactionColor(type),
        size: iconInnerSize,
      ),
    );
  }

  Widget _buildTransactionDetails(
    String description,
    String date,
    String status,
    bool isSmallScreen,
    bool isMediumScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: isMediumScreen ? 1 : 2,
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              HomeDataDummy.formatDate(date),
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                color: Colors.grey.shade600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 4 : 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: status == 'completed'
                    ? Colors.green.shade100
                    : status == 'pending'
                        ? Colors.orange.shade100
                        : Colors.red.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: isSmallScreen ? 8 : 10,
                  fontWeight: FontWeight.w600,
                  color: status == 'completed'
                      ? Colors.green.shade700
                      : status == 'pending'
                          ? Colors.orange.shade700
                          : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionAmount(
    double amount,
    String symbol,
    String type,
    bool isPositive,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            HomeDataDummy.formatTransactionAmount(amount, symbol, isPositive),
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: _getTransactionColor(type),
            ),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),
        Text(
          type,
          style: TextStyle(
            fontSize: isSmallScreen ? 10 : 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}