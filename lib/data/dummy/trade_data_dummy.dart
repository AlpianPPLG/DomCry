class TradeDataDummy {
  // Trading Pairs
  static const List<Map<String, dynamic>> tradingPairs = [
    {
      'symbol': 'BTC/USDT',
      'baseAsset': 'BTC',
      'quoteAsset': 'USDT',
      'price': 42356.78,
      'changePercent': 2.45,
      'isPositive': true,
      'volume24h': 28.4e9,
      'high24h': 43200.0,
      'low24h': 41800.0,
    },
    {
      'symbol': 'ETH/USDT',
      'baseAsset': 'ETH',
      'quoteAsset': 'USDT',
      'price': 2634.50,
      'changePercent': -1.23,
      'isPositive': false,
      'volume24h': 15.2e9,
      'high24h': 2680.0,
      'low24h': 2590.0,
    },
    {
      'symbol': 'BNB/USDT',
      'baseAsset': 'BNB',
      'quoteAsset': 'USDT',
      'price': 315.67,
      'changePercent': 3.21,
      'isPositive': true,
      'volume24h': 2.1e9,
      'high24h': 320.0,
      'low24h': 305.0,
    },
    {
      'symbol': 'ADA/USDT',
      'baseAsset': 'ADA',
      'quoteAsset': 'USDT',
      'price': 0.4523,
      'changePercent': 5.67,
      'isPositive': true,
      'volume24h': 890e6,
      'high24h': 0.46,
      'low24h': 0.42,
    },
    {
      'symbol': 'SOL/USDT',
      'baseAsset': 'SOL',
      'quoteAsset': 'USDT',
      'price': 98.45,
      'changePercent': -2.34,
      'isPositive': false,
      'volume24h': 1.8e9,
      'high24h': 102.0,
      'low24h': 96.0,
    },
  ];

  // User Balances
  static const Map<String, double> userBalances = {
    'BTC': 0.4528,
    'ETH': 2.89,
    'USDT': 5000.0,
    'BNB': 15.67,
    'ADA': 1250.0,
    'SOL': 8.45,
  };

  // Chart Data for Trading Pairs - LENGKAP DENGAN DATA YANG HILANG
  static const Map<String, Map<String, List<double>>> tradingChartData = {
    'BTC/USDT': {
      '1H': [42000.0, 42100.0, 41950.0, 42200.0, 42150.0, 42300.0, 42250.0, 42356.0],
      '4H': [41800.0, 42000.0, 41900.0, 42100.0, 42050.0, 42200.0, 42300.0, 42356.0],
      '1D': [41500.0, 41800.0, 42000.0, 41900.0, 42100.0, 42200.0, 42300.0, 42356.0],
      '1W': [40000.0, 40500.0, 41000.0, 41500.0, 41800.0, 42000.0, 42200.0, 42356.0],
    },
    'ETH/USDT': {
      '1H': [2620.0, 2630.0, 2615.0, 2640.0, 2625.0, 2635.0, 2630.0, 2634.0],
      '4H': [2600.0, 2620.0, 2610.0, 2630.0, 2625.0, 2635.0, 2640.0, 2634.0],
      '1D': [2580.0, 2600.0, 2620.0, 2610.0, 2630.0, 2635.0, 2640.0, 2634.0],
      '1W': [2500.0, 2520.0, 2550.0, 2580.0, 2600.0, 2620.0, 2630.0, 2634.0],
    },
    // DATA BARU UNTUK BNB/USDT
    'BNB/USDT': {
      '1H': [310.0, 312.5, 308.0, 314.0, 311.5, 316.0, 313.2, 315.67],
      '4H': [305.0, 308.0, 306.5, 312.0, 310.0, 314.5, 316.0, 315.67],
      '1D': [300.0, 305.0, 308.0, 306.0, 312.0, 314.0, 316.5, 315.67],
      '1W': [285.0, 290.0, 295.0, 300.0, 305.0, 310.0, 314.0, 315.67],
    },
    // DATA BARU UNTUK ADA/USDT
    'ADA/USDT': {
      '1H': [0.440, 0.445, 0.438, 0.448, 0.442, 0.450, 0.447, 0.4523],
      '4H': [0.425, 0.430, 0.428, 0.435, 0.432, 0.445, 0.448, 0.4523],
      '1D': [0.420, 0.425, 0.430, 0.428, 0.435, 0.440, 0.445, 0.4523],
      '1W': [0.380, 0.390, 0.400, 0.410, 0.420, 0.430, 0.440, 0.4523],
    },
    // DATA BARU UNTUK SOL/USDT
    'SOL/USDT': {
      '1H': [100.5, 99.8, 101.2, 98.9, 99.5, 97.8, 98.2, 98.45],
      '4H': [102.0, 101.0, 100.5, 99.8, 99.2, 98.5, 98.8, 98.45],
      '1D': [105.0, 103.5, 102.0, 100.8, 99.5, 98.8, 99.2, 98.45],
      '1W': [110.0, 108.0, 106.0, 104.0, 102.0, 100.0, 99.0, 98.45],
    },
  };

  // Order Book Data (Dummy) - DIPERLUAS UNTUK SEMUA PAIRS
  static const Map<String, Map<String, dynamic>> orderBooks = {
    'BTC/USDT': {
      'bids': [
        {'price': 42350.0, 'amount': 0.5234},
        {'price': 42345.0, 'amount': 1.2456},
        {'price': 42340.0, 'amount': 0.8901},
        {'price': 42335.0, 'amount': 2.1234},
        {'price': 42330.0, 'amount': 0.6789},
      ],
      'asks': [
        {'price': 42360.0, 'amount': 0.7890},
        {'price': 42365.0, 'amount': 1.4567},
        {'price': 42370.0, 'amount': 0.9876},
        {'price': 42375.0, 'amount': 2.3456},
        {'price': 42380.0, 'amount': 0.5432},
      ],
    },
    'BNB/USDT': {
      'bids': [
        {'price': 315.50, 'amount': 12.5},
        {'price': 315.45, 'amount': 25.8},
        {'price': 315.40, 'amount': 18.3},
        {'price': 315.35, 'amount': 32.1},
        {'price': 315.30, 'amount': 15.7},
      ],
      'asks': [
        {'price': 315.70, 'amount': 20.4},
        {'price': 315.75, 'amount': 28.9},
        {'price': 315.80, 'amount': 16.2},
        {'price': 315.85, 'amount': 35.6},
        {'price': 315.90, 'amount': 22.1},
      ],
    },
    'ADA/USDT': {
      'bids': [
        {'price': 0.4520, 'amount': 2500.0},
        {'price': 0.4518, 'amount': 3200.0},
        {'price': 0.4515, 'amount': 1800.0},
        {'price': 0.4512, 'amount': 4100.0},
        {'price': 0.4510, 'amount': 2900.0},
      ],
      'asks': [
        {'price': 0.4525, 'amount': 2800.0},
        {'price': 0.4528, 'amount': 3500.0},
        {'price': 0.4530, 'amount': 2100.0},
        {'price': 0.4533, 'amount': 3900.0},
        {'price': 0.4535, 'amount': 2600.0},
      ],
    },
    'SOL/USDT': {
      'bids': [
        {'price': 98.40, 'amount': 45.2},
        {'price': 98.35, 'amount': 62.8},
        {'price': 98.30, 'amount': 38.5},
        {'price': 98.25, 'amount': 71.3},
        {'price': 98.20, 'amount': 29.7},
      ],
      'asks': [
        {'price': 98.50, 'amount': 52.1},
        {'price': 98.55, 'amount': 68.4},
        {'price': 98.60, 'amount': 41.9},
        {'price': 98.65, 'amount': 76.2},
        {'price': 98.70, 'amount': 33.8},
      ],
    },
  };

  // Recent Trades - DIPERLUAS UNTUK SEMUA PAIRS
  static const Map<String, List<Map<String, dynamic>>> recentTradesData = {
    'BTC/USDT': [
      {'price': 42356.78, 'amount': 0.1234, 'time': '14:32:15', 'side': 'buy'},
      {'price': 42354.50, 'amount': 0.5678, 'time': '14:32:10', 'side': 'sell'},
      {'price': 42358.90, 'amount': 0.2345, 'time': '14:32:05', 'side': 'buy'},
      {'price': 42352.10, 'amount': 0.8901, 'time': '14:32:00', 'side': 'sell'},
    ],
    'BNB/USDT': [
      {'price': 315.67, 'amount': 8.45, 'time': '14:32:18', 'side': 'buy'},
      {'price': 315.62, 'amount': 12.78, 'time': '14:32:12', 'side': 'sell'},
      {'price': 315.70, 'amount': 6.23, 'time': '14:32:08', 'side': 'buy'},
      {'price': 315.58, 'amount': 15.91, 'time': '14:32:03', 'side': 'sell'},
    ],
    'ADA/USDT': [
      {'price': 0.4523, 'amount': 2250.0, 'time': '14:32:20', 'side': 'buy'},
      {'price': 0.4521, 'amount': 1890.0, 'time': '14:32:14', 'side': 'sell'},
      {'price': 0.4525, 'amount': 3100.0, 'time': '14:32:09', 'side': 'buy'},
      {'price': 0.4519, 'amount': 2750.0, 'time': '14:32:04', 'side': 'sell'},
    ],
    'SOL/USDT': [
      {'price': 98.45, 'amount': 15.67, 'time': '14:32:22', 'side': 'sell'},
      {'price': 98.48, 'amount': 22.34, 'time': '14:32:16', 'side': 'buy'},
      {'price': 98.42, 'amount': 18.91, 'time': '14:32:11', 'side': 'sell'},
      {'price': 98.50, 'amount': 25.78, 'time': '14:32:06', 'side': 'buy'},
    ],
  };

  // Trading Fees
  static const Map<String, double> tradingFees = {
    'maker': 0.001, // 0.1%
    'taker': 0.001, // 0.1%
  };

  // Amount Slider Percentages
  static const List<int> amountPercentages = [25, 50, 75, 100];

  // Helper Methods
  static Map<String, dynamic>? getTradingPair(String symbol) {
    try {
      return tradingPairs.firstWhere((pair) => pair['symbol'] == symbol);
    } catch (e) {
      return null;
    }
  }

  static double getUserBalance(String asset) {
    return userBalances[asset] ?? 0.0;
  }

  static List<double> getChartData(String symbol, String timeframe) {
    return tradingChartData[symbol]?[timeframe] ?? [];
  }

  // METODE BARU UNTUK ORDER BOOK
  static Map<String, dynamic> getOrderBook(String symbol) {
    return orderBooks[symbol] ?? {
      'bids': [],
      'asks': [],
    };
  }

  // METODE BARU UNTUK RECENT TRADES
  static List<Map<String, dynamic>> getRecentTrades(String symbol) {
    return recentTradesData[symbol] ?? [];
  }

  static String formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else if (price >= 1) {
      return price.toStringAsFixed(4);
    } else {
      return price.toStringAsFixed(6);
    }
  }

  static String formatAmount(double amount) {
    if (amount >= 1000) {
      return amount.toStringAsFixed(0);
    } else if (amount >= 1) {
      return amount.toStringAsFixed(4);
    } else {
      return amount.toStringAsFixed(8);
    }
  }

  static String formatPercentage(double percent) {
    return '${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(2)}%';
  }

  static double calculateTotal(double price, double amount) {
    return price * amount;
  }

  static double calculateFee(double total, String feeType) {
    final feeRate = tradingFees[feeType] ?? 0.001;
    return total * feeRate;
  }

  static double calculateAmountFromPercentage(String asset, int percentage) {
    final balance = getUserBalance(asset);
    return balance * (percentage / 100.0);
  }

  static double calculateTotalFromPercentage(String quoteAsset, int percentage) {
    final balance = getUserBalance(quoteAsset);
    return balance * (percentage / 100.0);
  }

  // METODE BARU UNTUK VALIDASI DATA
  static bool hasChartData(String symbol) {
    return tradingChartData.containsKey(symbol) && 
           tradingChartData[symbol]!.isNotEmpty;
  }

  // METODE UNTUK MENDAPATKAN SEMUA TIMEFRAMES YANG TERSEDIA
  static List<String> getAvailableTimeframes(String symbol) {
    if (tradingChartData.containsKey(symbol)) {
      return tradingChartData[symbol]!.keys.toList();
    }
    return ['1H', '4H', '1D', '1W']; // default timeframes
  }
}