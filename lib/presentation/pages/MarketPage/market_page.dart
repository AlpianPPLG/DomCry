import 'package:flutter/material.dart';
import '../../components/GlobalComponent/bottom_nav_bar.dart';
import '../../components/GlobalComponent/back_to_top.dart';
import '../../components/MarketComponent/market_header.dart';
import '../../components/MarketComponent/market_tab_bar.dart';
import '../../components/MarketComponent/market_search_field.dart';
import '../../components/MarketComponent/market_coin_list.dart';
import '../../components/MarketComponent/market_filter_modal.dart';
import '../../routes/app_routes.dart';
import '../../../data/dummy/market_data_dummy.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedTab = 'All';
  String _searchQuery = '';
  String _sortBy = 'Market Cap';
  bool _isAscending = false;
  bool _isSearchVisible = false;
  List<Map<String, dynamic>> _filteredCoins = [];

  @override
  void initState() {
    super.initState();
    _updateCoinList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateCoinList() {
    List<Map<String, dynamic>> coins;
    
    if (_searchQuery.isNotEmpty) {
      coins = MarketDataDummy.searchCoins(_searchQuery);
    } else {
      coins = MarketDataDummy.getCoinsByCategory(_selectedTab);
    }
    
    // Apply sorting
    coins = _sortCoins(coins);
    
    setState(() {
      _filteredCoins = coins;
    });
  }

  List<Map<String, dynamic>> _sortCoins(List<Map<String, dynamic>> coins) {
    List<Map<String, dynamic>> sortedCoins = List.from(coins);
    
    switch (_sortBy) {
      case 'Market Cap':
        sortedCoins.sort((a, b) => _isAscending 
            ? a['marketCap'].compareTo(b['marketCap'])
            : b['marketCap'].compareTo(a['marketCap']));
        break;
      case 'Price':
        sortedCoins.sort((a, b) => _isAscending 
            ? a['currentPrice'].compareTo(b['currentPrice'])
            : b['currentPrice'].compareTo(a['currentPrice']));
        break;
      case '24h Change':
        sortedCoins.sort((a, b) => _isAscending 
            ? a['priceChangePercentage24h'].compareTo(b['priceChangePercentage24h'])
            : b['priceChangePercentage24h'].compareTo(a['priceChangePercentage24h']));
        break;
      case 'Volume':
        sortedCoins.sort((a, b) => _isAscending 
            ? a['volume24h'].compareTo(b['volume24h'])
            : b['volume24h'].compareTo(a['volume24h']));
        break;
      case 'Name':
        sortedCoins.sort((a, b) => _isAscending 
            ? a['name'].compareTo(b['name'])
            : b['name'].compareTo(a['name']));
        break;
    }
    
    return sortedCoins;
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
      _searchQuery = '';
      _searchController.clear();
    });
    _updateCoinList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _updateCoinList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _searchQuery = '';
        _updateCoinList();
      }
    });
  }

  void _showFilterModal() {
    MarketFilterModal.show(
      context,
      currentSortBy: _sortBy,
      isAscending: _isAscending,
      onApplyFilter: (sortBy, isAscending) {
        setState(() {
          _sortBy = sortBy;
          _isAscending = isAscending;
        });
        _updateCoinList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                MarketHeader(
                  onSearchTap: _toggleSearch,
                  onFilterTap: _showFilterModal,
                ),
                if (_isSearchVisible)
                  MarketSearchField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onClear: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
                if (!_isSearchVisible)
                  MarketTabBar(
                    selectedTab: _selectedTab,
                    onTabSelected: _onTabSelected,
                  ),
                const SizedBox(height: 8),
                MarketCoinList(coins: _filteredCoins),
                const SizedBox(height: 20),
              ],
            ),
          ),
          BackToTop(
            scrollController: _scrollController,
            showOffset: 300.0,
            backgroundColor: const Color(0xFF6C5CE7),
            iconColor: Colors.white,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.market);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.trade);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.settings);
              break;
          }
        },
      ),
    );
  }
}