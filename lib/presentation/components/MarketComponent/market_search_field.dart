import 'package:flutter/material.dart';

class MarketSearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onClear;

  const MarketSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<MarketSearchField> createState() => _MarketSearchFieldState();
}

class _MarketSearchFieldState extends State<MarketSearchField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _hasFocus 
              ? const Color(0xFF6C5CE7) 
              : Colors.grey.shade300,
          width: _hasFocus ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _hasFocus = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: 'Search cryptocurrencies...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: _hasFocus 
                  ? const Color(0xFF6C5CE7) 
                  : Colors.grey.shade500,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      widget.onChanged('');
                      if (widget.onClear != null) {
                        widget.onClear!();
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey.shade500,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}