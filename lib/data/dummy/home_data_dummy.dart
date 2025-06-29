class HomeDataDummy {
  // User Balance Data
  static const double totalBalance = 12845.39;
  static const String userName = "John Doe";
  
  // Wallet Holdings - Perbaikan tipe data
  static const List<Map<String, dynamic>> walletHoldings = [
    {
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'amount': 0.4528,
      'usdValue': 25432.50,
      'changePercent': 2.5,
      'isPositive': true,
    },
    {
      'symbol': 'ETH',
      'name': 'Ethereum', 
      'amount': 2.89,
      'usdValue': 1823.70,
      'changePercent': -1.2,
      'isPositive': false,
    },
    {
      'symbol': 'USDT',
      'name': 'Tether',
      'amount': 5000.0,
      'usdValue': 5000.00,
      'changePercent': 0.0,
      'isPositive': true,
    },
  ];

  // Bitcoin Price Data dengan chart data
  static const Map<String, dynamic> bitcoinPrice = {
    'price': 42356.78,
    'changePercent': 5.3,
    'isPositive': true,
    'symbol': 'BTC',
    'name': 'Bitcoin',
    'chartData': {
      '24H': [40000.0, 40500.0, 39800.0, 41200.0, 40800.0, 41500.0, 42000.0, 41800.0, 42356.0],
      '1W': [38000.0, 39000.0, 40000.0, 39500.0, 41000.0, 40500.0, 42000.0, 41500.0, 42356.0],
      '1M': [35000.0, 37000.0, 38500.0, 40000.0, 39000.0, 41000.0, 40500.0, 42000.0, 42356.0],
      '1Y': [25000.0, 30000.0, 35000.0, 32000.0, 38000.0, 40000.0, 42000.0, 39000.0, 42356.0],
    },
    'volume24h': 28.4e9,
    'marketCap': 831.2e9,
  };

  // Portfolio Chart Data
  static const Map<String, List<double>> portfolioChartData = {
    '24H': [12500.0, 12600.0, 12400.0, 12700.0, 12650.0, 12800.0, 12750.0, 12820.0, 12845.0],
    '1W': [12000.0, 12200.0, 12400.0, 12300.0, 12600.0, 12500.0, 12700.0, 12800.0, 12845.0],
    '1M': [11000.0, 11500.0, 12000.0, 11800.0, 12200.0, 12400.0, 12600.0, 12700.0, 12845.0],
    '1Y': [8000.0, 9000.0, 10000.0, 9500.0, 11000.0, 11500.0, 12000.0, 12500.0, 12845.0],
  };

  // Individual Crypto Chart Data
  static const Map<String, Map<String, List<double>>> cryptoChartsData = {
    'BTC': {
      '24H': [25000.0, 25200.0, 24800.0, 25400.0, 25100.0, 25600.0, 25300.0, 25400.0, 25432.0],
      '1W': [24000.0, 24500.0, 25000.0, 24700.0, 25200.0, 25000.0, 25300.0, 25400.0, 25432.0],
      '1M': [22000.0, 23000.0, 24000.0, 23500.0, 24500.0, 25000.0, 25200.0, 25300.0, 25432.0],
      '1Y': [18000.0, 20000.0, 22000.0, 21000.0, 23000.0, 24000.0, 25000.0, 25200.0, 25432.0],
    },
    'ETH': {
      '24H': [1800.0, 1820.0, 1790.0, 1830.0, 1810.0, 1840.0, 1820.0, 1825.0, 1823.0],
      '1W': [1750.0, 1780.0, 1800.0, 1770.0, 1820.0, 1800.0, 1830.0, 1820.0, 1823.0],
      '1M': [1600.0, 1700.0, 1750.0, 1720.0, 1780.0, 1800.0, 1820.0, 1810.0, 1823.0],
      '1Y': [1200.0, 1400.0, 1600.0, 1500.0, 1700.0, 1750.0, 1800.0, 1820.0, 1823.0],
    },
    'USDT': {
      '24H': [1.0, 1.001, 0.999, 1.0, 1.001, 1.0, 0.999, 1.001, 1.0],
      '1W': [1.0, 1.001, 0.999, 1.0, 1.001, 1.0, 0.999, 1.001, 1.0],
      '1M': [1.0, 1.001, 0.999, 1.0, 1.001, 1.0, 0.999, 1.001, 1.0],
      '1Y': [1.0, 1.001, 0.999, 1.0, 1.001, 1.0, 0.999, 1.001, 1.0],
    },
  };

  // Recent Transactions - Struktur data yang diperbaiki
  static const List<Map<String, dynamic>> recentTransactions = [
    {
      'type': 'Received',
      'description': 'Received from Coinbase',
      'amount': 0.0025,
      'symbol': 'BTC',
      'date': '2024-01-15',
      'status': 'completed',
      'from': '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
      'isPositive': true,
    },
    {
      'type': 'Sent',
      'description': 'Sent to Binance',
      'amount': 0.5,
      'symbol': 'ETH', 
      'date': '2024-01-14',
      'status': 'completed',
      'to': '0x742d35Cc6634C0532925a3b8D4C0C8b3C2e1e3e3',
      'isPositive': false,
    },
    {
      'type': 'Bought',
      'description': 'Bought with Credit Card',
      'amount': 1000.0,
      'symbol': 'USDT',
      'date': '2024-01-13',
      'status': 'completed',
      'method': 'Credit Card',
      'isPositive': true,
    },
    {
      'type': 'Received',
      'description': 'Staking Rewards',
      'amount': 0.15,
      'symbol': 'ETH',
      'date': '2024-01-12',
      'status': 'completed',
      'from': 'Staking Pool',
      'isPositive': true,
    },
    {
      'type': 'Sent',
      'description': 'Payment to Merchant',
      'amount': 50.0,
      'symbol': 'USDT',
      'date': '2024-01-11',
      'status': 'completed',
      'to': 'Merchant Wallet',
      'isPositive': false,
    },
  ];

  // Crypto Assets List
  static const List<Map<String, dynamic>> cryptoAssets = [
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'amount': 0.4528,
      'usdValue': 19178.42,
      'icon': '₿',
      'color': 0xFFF7931A,
      'changePercent': 2.5,
      'isPositive': true,
    },
    {
      'name': 'Ethereum', 
      'symbol': 'ETH',
      'amount': 2.89,
      'usdValue': 6842.73,
      'icon': 'Ξ',
      'color': 0xFF627EEA,
      'changePercent': -1.2,
      'isPositive': false,
    },
    {
      'name': 'Tether',
      'symbol': 'USDT',
      'amount': 5000.0,
      'usdValue': 5000.00,
      'icon': '₮',
      'color': 0xFF26A17B,
      'changePercent': 0.1,
      'isPositive': true,
    },
  ];

  // Quick Actions
  static const List<Map<String, dynamic>> quickActions = [
    {
      'title': 'Scan',
      'icon': 'qr_code_scanner',
      'color': 0xFF9C27B0,
    },
    {
      'title': 'Swap',
      'icon': 'swap_horiz',
      'color': 0xFF2196F3,
    },
    {
      'title': 'Earn',
      'icon': 'trending_up',
      'color': 0xFF4CAF50,
    },
    {
      'title': 'Trade',
      'icon': 'show_chart',
      'color': 0xFFFF9800,
    },
  ];

  // Time periods untuk chart
  static const List<String> timePeriods = ['24H', '1W', '1M', '1Y'];

  // Helper methods
  static List<double> getBitcoinChartData(String period) {
    final data = bitcoinPrice['chartData'][period];
    if (data is List) {
      return data.cast<double>();
    }
    return [];
  }

  static List<double> getPortfolioChartData(String period) {
    final data = portfolioChartData[period];
    return data ?? [];
  }

  static List<double> getCryptoChartData(String symbol, String period) {
    final data = cryptoChartsData[symbol]?[period];
    return data ?? [];
  }

  // Format price
  static String formatPrice(double price) {
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsFixed(6)}';
    }
  }

  // Format percentage
  static String formatPercentage(double percent) {
    return '${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(1)}%';
  }

  // Format amount
  static String formatAmount(double amount, String symbol) {
    if (symbol == 'USDT' || amount >= 1000) {
      return amount.toStringAsFixed(0);
    } else if (amount >= 1) {
      return amount.toStringAsFixed(2);
    } else {
      return amount.toStringAsFixed(4);
    }
  }

  // Format transaction amount
  static String formatTransactionAmount(double amount, String symbol, bool isPositive) {
    final prefix = isPositive ? '+' : '-';
    final formattedAmount = formatAmount(amount, symbol);
    return '$prefix$formattedAmount $symbol';
  }

  // Format date
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}