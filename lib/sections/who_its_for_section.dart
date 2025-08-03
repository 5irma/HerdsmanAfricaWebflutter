import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class WhoItsForSection extends StatefulWidget {
  const WhoItsForSection({super.key});

  @override
  State<WhoItsForSection> createState() => _WhoItsForSectionState();
}

class _WhoItsForSectionState extends State<WhoItsForSection>
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
      Future.delayed(Duration(milliseconds: i * 200), () {
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
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(context, isMobile),

          SizedBox(height: isMobile ? 40 : 60),

          // Target audience cards
          isMobile ? _buildMobileCards() : _buildDesktopCards(),

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
          'Who It\'s For',
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
          'Built for farmers of all sizes - from small family farms to large commercial operations',
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

  Widget _buildMobileCards() {
    return Column(
      children: [
        _buildTargetCard(0, true),
        const SizedBox(height: 20),
        _buildTargetCard(1, true),
        const SizedBox(height: 20),
        _buildTargetCard(2, true),
        const SizedBox(height: 20),
        _buildTargetCard(3, true),
      ],
    );
  }

  Widget _buildDesktopCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTargetCard(0, false)),
            const SizedBox(width: 20),
            Expanded(child: _buildTargetCard(1, false)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTargetCard(2, false)),
            const SizedBox(width: 20),
            Expanded(child: _buildTargetCard(3, false)),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetCard(int index, bool isMobile) {
    final targets = [
      {
        'title': 'Small Family Farms',
        'description':
            'Perfect for farmers managing 10-100 animals who want to digitize their record-keeping and improve efficiency.',
        'icon': Icons.home,
        'benefits': [
          'Easy to learn and use',
          'Affordable pricing',
          'Essential tracking features',
        ],
      },
      {
        'title': 'Growing Operations',
        'description':
            'Ideal for mid-size farms scaling up their operations and needing more advanced management tools.',
        'icon': Icons.trending_up,
        'benefits': [
          'Advanced analytics',
          'Multi-user access',
          'Breeding management',
        ],
      },
      {
        'title': 'Commercial Ranches',
        'description':
            'Built for large operations managing hundreds or thousands of animals across multiple locations.',
        'icon': Icons.business,
        'benefits': [
          'Multi-location support',
          'Custom integrations',
          'Dedicated support',
        ],
      },
      {
        'title': 'Agricultural Consultants',
        'description':
            'Tools for consultants and veterinarians who work with multiple farms and need comprehensive oversight.',
        'icon': Icons.people,
        'benefits': [
          'Multi-farm management',
          'Client reporting',
          'Professional tools',
        ],
      },
    ];

    final target = targets[index];

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
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          target['icon'] as IconData,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          target['title'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    target['description'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Benefits
                  Column(
                    children: (target['benefits'] as List<String>).map((
                      benefit,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
      padding: const EdgeInsets.all(32),
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
          Text(
            'Ready to Get Started?',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'No matter the size of your operation, we have the right solution for you',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: isMobile ? double.infinity : 250,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Handle get started
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Free Trial',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
