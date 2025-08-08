import 'package:flutter/material.dart';

class LazySection extends StatefulWidget {
  final Widget Function() builder;
  final String sectionName;
  final double threshold;

  const LazySection({
    super.key,
    required this.builder,
    required this.sectionName,
    this.threshold = 300.0,
  });

  @override
  State<LazySection> createState() => _LazySectionState();
}

class _LazySectionState extends State<LazySection> {
  bool _isLoaded = false;
  Widget? _cachedWidget;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!_isLoaded) {
          _checkVisibility();
        }
        return false;
      },
      child: _isLoaded
          ? (_cachedWidget ??= widget.builder())
          : Container(
              height: _getEstimatedHeight(),
              alignment: Alignment.center,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: (value * 0.3).clamp(0.1, 0.3),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Transform.rotate(
                        angle: value * 6.28, // 2π radians
                        child: const Icon(
                          Icons.agriculture,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _checkVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      // Load when section is within threshold distance from viewport
      if (position.dy < screenHeight + widget.threshold) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  double _getEstimatedHeight() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    // Responsive estimated heights to prevent layout jumps
    switch (widget.sectionName) {
      case 'hero':
        return isMobile ? 600.0 : 700.0;
      case 'how-it-works':
        return isMobile ? 800.0 : 900.0;
      case 'who-its-for':
        return isMobile ? 1200.0 : 1000.0;
      case 'solutions':
        return isMobile ? 900.0 : 800.0;
      case 'testimonials':
        return isMobile ? 700.0 : 600.0;
      case 'pricing':
        return isMobile ? 1000.0 : 800.0;
      case 'download':
        return isMobile ? 800.0 : 700.0;
      case 'faqs':
        return isMobile ? 700.0 : 600.0;
      case 'contact':
        return isMobile ? 900.0 : 800.0;
      default:
        return isMobile ? 700.0 : 600.0;
    }
  }
}
