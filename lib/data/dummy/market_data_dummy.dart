class MarketDataDummy {
  // Market Statistics
  static const Map<String, dynamic> marketStats = {
    'totalMarketCap': 2.1e12, // 2.1 Trillion
    'totalVolume24h': 89.5e9, // 89.5 Billion
    'btcDominance': 42.3,
    'activeCryptocurrencies': 13847,
  };

  // Top Cryptocurrencies
  static const List<Map<String, dynamic>> topCoins = [
    {
      'id': 'bitcoin',
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'icon': '₿',
      'color': 0xFFF7931A,
      'currentPrice': 42356.78,
      'priceChange24h': 2.5,
      'priceChangePercentage24h': 5.3,
      'marketCap': 831.2e9,
      'volume24h': 28.4e9,
      'circulatingSupply': 19.6e6,
      'totalSupply': 21e6,
      'rank': 1,
      'sparklineData': [40000, 41000, 40500, 42000, 41800, 42356],
    },
    {
      'id': 'ethereum',
      'name': 'Ethereum',
      'symbol': 'ETH',
      'icon': 'Ξ',
      'color': 0xFF627EEA,
      'currentPrice': 2567.89,
      'priceChange24h': -45.23,
      'priceChangePercentage24h': -1.8,
      'marketCap': 308.7e9,
      'volume24h': 15.2e9,
      'circulatingSupply': 120.3e6,
      'totalSupply': null,
      'rank': 2,
      'sparklineData': [2600, 2580, 2590, 2570, 2560, 2567],
    },
    {
      'id': 'tether',
      'name': 'Tether',
      'symbol': 'USDT',
      'icon': '₮',
      'color': 0xFF26A17B,
      'currentPrice': 1.0,
      'priceChange24h': 0.001,
      'priceChangePercentage24h': 0.1,
      'marketCap': 91.8e9,
      'volume24h': 45.6e9,
      'circulatingSupply': 91.8e9,
      'totalSupply': 91.8e9,
      'rank': 3,
      'sparklineData': [1.0, 1.001, 0.999, 1.0, 1.001, 1.0],
    },
    {
      'id': 'binancecoin',
      'name': 'BNB',
      'symbol': 'BNB',
      'icon': 'B',
      'color': 0xFFF3BA2F,
      'currentPrice': 315.67,
      'priceChange24h': 12.45,
      'priceChangePercentage24h': 4.1,
      'marketCap': 47.3e9,
      'volume24h': 1.8e9,
      'circulatingSupply': 149.5e6,
      'totalSupply': 200e6,
      'rank': 4,
      'sparklineData': [300, 305, 310, 312, 318, 315],
    },
    {
      'id': 'solana',
      'name': 'Solana',
      'symbol': 'SOL',
      'icon': 'S',
      'color': 0xFF9945FF,
      'currentPrice': 98.45,
      'priceChange24h': -3.21,
      'priceChangePercentage24h': -3.2,
      'marketCap': 43.2e9,
      'volume24h': 2.1e9,
      'circulatingSupply': 438.7e6,
      'totalSupply': 588.6e6,
      'rank': 5,
      'sparklineData': [102, 100, 99, 97, 96, 98],
    },
    {
      'id': 'cardano',
      'name': 'Cardano',
      'symbol': 'ADA',
      'icon': 'A',
      'color': 0xFF0033AD,
      'currentPrice': 0.4523,
      'priceChange24h': 0.0234,
      'priceChangePercentage24h': 5.5,
      'marketCap': 15.8e9,
      'volume24h': 456e6,
      'circulatingSupply': 35e9,
      'totalSupply': 45e9,
      'rank': 6,
      'sparklineData': [0.43, 0.44, 0.45, 0.46, 0.44, 0.45],
    },
    {
      'id': 'dogecoin',
      'name': 'Dogecoin',
      'symbol': 'DOGE',
      'icon': 'D',
      'color': 0xFFC2A633,
      'currentPrice': 0.0756,
      'priceChange24h': 0.0043,
      'priceChangePercentage24h': 6.0,
      'marketCap': 10.8e9,
      'volume24h': 789e6,
      'circulatingSupply': 142.8e9,
      'totalSupply': null,
      'rank': 7,
      'sparklineData': [0.071, 0.073, 0.074, 0.076, 0.075, 0.0756],
    },
    {
      'id': 'polygon',
      'name': 'Polygon',
      'symbol': 'MATIC',
      'icon': 'M',
      'color': 0xFF8247E5,
      'currentPrice': 0.8934,
      'priceChange24h': -0.0456,
      'priceChangePercentage24h': -4.9,
      'marketCap': 8.7e9,
      'volume24h': 234e6,
      'circulatingSupply': 9.7e9,
      'totalSupply': 10e9,
      'rank': 8,
      'sparklineData': [0.94, 0.92, 0.90, 0.88, 0.89, 0.893],
    },
  ];

  // Market Categories
  static const List<String> marketTabs = [
    'All',
    'Top Gainers',
    'Top Losers',
    'Trending',
    'New Listings',
  ];

  // Filter Options
  static const List<String> sortOptions = [
    'Market Cap',
    'Price',
    '24h Change',
    'Volume',
    'Name',
  ];

  // Get coins by category
  static List<Map<String, dynamic>> getCoinsByCategory(String category) {
    switch (category) {
      case 'Top Gainers':
        return topCoins
            .where((coin) => coin['priceChangePercentage24h'] > 0)
            .toList()
          ..sort((a, b) => b['priceChangePercentage24h']
              .compareTo(a['priceChangePercentage24h']));
      case 'Top Losers':
        return topCoins
            .where((coin) => coin['priceChangePercentage24h'] < 0)
            .toList()
          ..sort((a, b) => a['priceChangePercentage24h']
              .compareTo(b['priceChangePercentage24h']));
      case 'Trending':
        return topCoins.take(5).toList();
      case 'New Listings':
        return topCoins.skip(5).toList();
      default:
        return topCoins;
    }
  }

  // Search coins
  static List<Map<String, dynamic>> searchCoins(String query) {
    if (query.isEmpty) return topCoins;
    return topCoins
        .where((coin) =>
            coin['name'].toLowerCase().contains(query.toLowerCase()) ||
            coin['symbol'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}