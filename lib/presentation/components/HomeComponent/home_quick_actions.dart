import 'package:flutter/material.dart';
import '../../../data/dummy/home_data_dummy.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'qr_code_scanner':
        return Icons.qr_code_scanner;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'trending_up':
        return Icons.trending_up;
      case 'show_chart':
        return Icons.show_chart;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: HomeDataDummy.quickActions.map((action) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(action['color']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconData(action['icon']),
                      color: Color(action['color']),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}