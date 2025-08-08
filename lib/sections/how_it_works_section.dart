import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 600 + (index * 200)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    }).toList();

    // Start animations with stagger
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(context, isMobile),

          SizedBox(height: isMobile ? 40 : 60),

          // Steps
          isMobile ? _buildMobileSteps() : _buildDesktopSteps(),

          SizedBox(height: isMobile ? 40 : 60),

          // Bottom CTA
          _buildBottomCTA(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Complete Livestock Management',
          style: TextStyle(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'From EID tagging to marketplace trading - everything you need in one platform',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMobileSteps() {
    return Column(
      children: [
        _buildStep(0, true),
        const SizedBox(height: 40),
        _buildStep(1, true),
        const SizedBox(height: 40),
        _buildStep(2, true),
        const SizedBox(height: 40),
        _buildStep(3, true),
      ],
    );
  }

  Widget _buildDesktopSteps() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStep(0, false)),
            const SizedBox(width: 40),
            Expanded(child: _buildStep(1, false)),
          ],
        ),
        const SizedBox(height: 60),
        Row(
          children: [
            Expanded(child: _buildStep(2, false)),
            const SizedBox(width: 40),
            Expanded(child: _buildStep(3, false)),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(int index, bool isMobile) {
    final steps = [
      {
        'number': '1',
        'title': 'EID Tagging & Registration',
        'description':
            'Tag animals by injecting microchip, scan and register on the app.',
        'example':
            'Example: Scan EID 982000123456789 to instantly access complete animal history',
        'icon': Icons.nfc,
        'badge': 'EID Compatible',
      },
      {
        'number': '2',
        'title': 'Simple Data Entry',
        'description':
            'Record health treatments, breeding events, weight records, and daily observations with our friendly interphase.',
        'example':
            'Example: Log vaccination batch #V2024 for 50 cattle with automatic reminder scheduling',
        'icon': Icons.edit_note,
        'badge': 'Quick Entry',
      },
      {
        'number': '3',
        'title': 'Production Monitoring',
        'description':
            'Keep track of milk production, weight over time and analyze trends with visual charts.',
        'example':
            'Example: "Average daily gain increased 12% this quarter, reproductive rate at 94%"',
        'icon': Icons.analytics,
        'badge': 'AI Insights',
      },
      {
        'number': '4',
        'title': 'Marketplace Trading',
        'description':
            'Buy and sell livestock directly through our integrated marketplace. All animals are verified and uniquely identified with Electronic ID hence transparent.',
        'example':
            'Example: List 20 steers for sale with complete health records and performance data',
        'icon': Icons.storefront,
        'badge': 'Secure Trading',
      },
    ];

    final step = steps[index];

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _animations[index].value,
          child: Opacity(
            opacity: _animations[index].value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  // Icon only
                  Row(
                    mainAxisAlignment: isMobile
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(
                            step['icon'] as IconData,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    step['title'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    step['description'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomCTA(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          isMobile
              ? Column(
                  children: [
                    Icon(Icons.trending_up, color: AppColors.primary, size: 24),
                    const SizedBox(height: 12),
                    Text(
                      'A data driven farm maximizes every animals potential',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.trending_up, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'A data driven farm maximizes every animals potential',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

          const SizedBox(height: 16),

          Text(
            'Sirma Kipkurui - CEO Herdsman Africa',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
