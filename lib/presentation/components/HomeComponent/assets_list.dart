import 'package:flutter/material.dart';
import '../../../data/dummy/home_data_dummy.dart';
import 'asset_card.dart';

class AssetsList extends StatelessWidget {
  const AssetsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: HomeDataDummy.cryptoAssets.map((asset) {
          return AssetCard(
            name: asset['name'] as String,
            symbol: asset['symbol'] as String,
            amount: asset['amount'] as double,
            usdValue: asset['usdValue'] as double,
            icon: asset['icon'] as String,
            color: asset['color'] as int,
          );
        }).toList(),
      ),
    );
  }
}