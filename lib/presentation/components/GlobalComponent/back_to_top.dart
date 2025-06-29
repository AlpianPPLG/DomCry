import 'package:flutter/material.dart';

class BackToTop extends StatefulWidget {
  final ScrollController scrollController;
  final double showOffset;
  final Duration animationDuration;
  final Color? backgroundColor;
  final Color? iconColor;

  const BackToTop({
    super.key,
    required this.scrollController,
    this.showOffset = 200.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.iconColor,
  });

  @override
  State<BackToTop> createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.offset > widget.showOffset && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
    } else if (widget.scrollController.offset <= widget.showOffset && _isVisible) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 20,
      bottom: 100, // Position above bottom navigation bar
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? const Color(0xFF6C5CE7),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: _scrollToTop,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: widget.iconColor ?? Colors.white,
                      size: 28,
                    ),
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