import 'package:flutter/material.dart';
import '../../../data/dummy/market_data_dummy.dart';

class MarketTabBar extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const MarketTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: MarketDataDummy.marketTabs.length,
        itemBuilder: (context, index) {
          final tab = MarketDataDummy.marketTabs[index];
          final isSelected = tab == selectedTab;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFF6C5CE7) 
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected 
                        ? const Color(0xFF6C5CE7) 
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}