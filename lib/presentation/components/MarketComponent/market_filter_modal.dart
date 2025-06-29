import 'package:flutter/material.dart';
import '../../../data/dummy/market_data_dummy.dart';

class MarketFilterModal extends StatefulWidget {
  final String currentSortBy;
  final bool isAscending;
  final Function(String, bool) onApplyFilter;

  const MarketFilterModal({
    super.key,
    required this.currentSortBy,
    required this.isAscending,
    required this.onApplyFilter,
  });

  static void show(
    BuildContext context, {
    required String currentSortBy,
    required bool isAscending,
    required Function(String, bool) onApplyFilter,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MarketFilterModal(
        currentSortBy: currentSortBy,
        isAscending: isAscending,
        onApplyFilter: onApplyFilter,
      ),
    );
  }

  @override
  State<MarketFilterModal> createState() => _MarketFilterModalState();
}

class _MarketFilterModalState extends State<MarketFilterModal> {
  late String selectedSortBy;
  late bool isAscending;

  @override
  void initState() {
    super.initState();
    selectedSortBy = widget.currentSortBy;
    isAscending = widget.isAscending;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter & Sort',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Sort Options
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...MarketDataDummy.sortOptions.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedSortBy,
                    onChanged: (value) {
                      setState(() {
                        selectedSortBy = value!;
                      });
                    },
                    activeColor: const Color(0xFF6C5CE7),
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
                const SizedBox(height: 20),
                const Text(
                  'Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAscending = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isAscending 
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isAscending 
                                  ? const Color(0xFF6C5CE7)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: isAscending ? Colors.white : Colors.grey.shade600,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ascending',
                                style: TextStyle(
                                  color: isAscending ? Colors.white : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAscending = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isAscending 
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !isAscending 
                                  ? const Color(0xFF6C5CE7)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: !isAscending ? Colors.white : Colors.grey.shade600,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Descending',
                                style: TextStyle(
                                  color: !isAscending ? Colors.white : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilter(selectedSortBy, isAscending);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}