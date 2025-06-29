import 'package:flutter/material.dart';
import 'market_coin_tile.dart';

class MarketCoinList extends StatelessWidget {
  final List<Map<String, dynamic>> coins;
  final bool isLoading;

  const MarketCoinList({
    super.key,
    required this.coins,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CircularProgressIndicator(
                color: Color(0xFF6C5CE7),
              ),
              SizedBox(height: 16),
              Text(
                'Loading market data...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (coins.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No cryptocurrencies found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filter criteria',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coins.length,
      itemBuilder: (context, index) {
        final coin = coins[index];
        
        // Validate coin data before passing to tile
        if (coin == null || !_isValidCoinData(coin)) {
          return const SizedBox.shrink(); // Skip invalid data
        }
        
        return MarketCoinTile(
          coin: coin,
          onTap: () {
            _handleCoinTap(context, coin);
          },
        );
      },
    );
  }

  bool _isValidCoinData(Map<String, dynamic> coin) {
    // Check if essential fields exist
    return coin.containsKey('name') && 
           coin.containsKey('symbol') && 
           coin.containsKey('currentPrice') &&
           coin.containsKey('priceChangePercentage24h');
  }

  void _handleCoinTap(BuildContext context, Map<String, dynamic> coin) {
    try {
      final coinName = coin['name']?.toString() ?? 'Unknown';
      final coinSymbol = coin['symbol']?.toString() ?? '';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tapped on $coinName ($coinSymbol)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
    } catch (e) {
      debugPrint('Error handling coin tap: $e');
    }
  }
}