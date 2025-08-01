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

          // Time estimate and CTA
          _buildBottomCTA(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Simple as 1-2-3',
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
          'Start tracking your herd in minutes, not hours',
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
        'title': 'Tag Your Animal',
        'description':
            'Scan ear tag or enter ID number. Takes 10 seconds per animal.',
        'example': 'Example: Cow #247 gets a new ear tag',
        'icon': Icons.qr_code_scanner,
        'time': '10 sec',
      },
      {
        'number': '2',
        'title': 'Record What Happened',
        'description':
            'Log vaccination, breeding, health check - whatever you just did.',
        'example': 'Example: "Gave vaccine to cow #247"',
        'icon': Icons.edit_note,
        'time': '30 sec',
      },
      {
        'number': '3',
        'title': 'Get Alerts',
        'description':
            'We remind you when it\'s time for next vaccination or check-up.',
        'example': 'Example: "Cow #247 due for booster in 2 weeks"',
        'icon': Icons.notifications_active,
        'time': 'Automatic',
      },
      {
        'number': '4',
        'title': 'Track Health',
        'description':
            'See which animals need attention and when. No more guessing.',
        'example': 'Example: Dashboard shows 3 cows need check-ups',
        'icon': Icons.health_and_safety,
        'time': 'Real-time',
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
                  // Step number and icon
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
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                step['icon'] as IconData,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    step['number'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            step['time'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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

                  const SizedBox(height: 16),

                  // Example
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            step['example'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isMobile) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        step['time'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Complete setup in 15 minutes',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'Most farmers are tracking their first animal within 15 minutes of signing up',
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
                // Handle start tracking
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
                'Start Tracking Now',
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
