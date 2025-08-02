import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SolutionsSection extends StatefulWidget {
  const SolutionsSection({super.key});

  @override
  State<SolutionsSection> createState() => _SolutionsSectionState();
}

class _SolutionsSectionState extends State<SolutionsSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
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

          // Solutions list
          Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 32 : 40),
                child: _buildSolutionCard(index, isMobile),
              );
            }),
          ),

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
          'Stop the Daily Headaches',
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
          'We solve the 5 biggest problems that waste your time and money every day',
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

  Widget _buildSolutionCard(int index, bool isMobile) {
    final solutions = [
      {
        'problem': 'Lost Paperwork & Forgotten Records',
        'solution': 'Farm data stored in cloud',
        'description':
            'No more digging through filing cabinets or trying to remember when you last vaccinated cow #247.',
        'benefits': [
          'World-wide live data access',
          'No loss of records',
          'Trend analytics with use of infographics',
        ],
        'savings': 'Save \$3,200/year',
        'icon': Icons.description,
        'problemIcon': Icons.folder_off,
      },
      {
        'problem': 'Missing Vaccination Deadlines',
        'solution': 'Automatic Reminders',
        'description':
            'Get alerts before vaccines expire. Never scramble to meet deadlines or pay late fees again.',
        'benefits': [
          'Prevent \$500+ fines per missed deadline',
          'Automatic calendar reminders',
          'Bulk vaccination scheduling',
        ],
        'savings': 'Avoid \$2,000/year in fines',
        'icon': Icons.schedule,
        'problemIcon': Icons.warning,
      },
      {
        'problem': 'Can\'t Find Sick Animals Fast',
        'solution': 'Health Alerts & Tracking',
        'description':
            'Spot health issues early with tracking. Know exactly which animals need attention today.',
        'benefits': [
          'Catch illness 3-5 days earlier',
          'Reduce vet bills by 40%',
          'GPS location tracking for large herds',
        ],
        'savings': 'Save \$1,800/year on vet bills',
        'icon': Icons.health_and_safety,
        'problemIcon': Icons.sick,
      },
      {
        'problem': 'Breeding Records Are a Mess',
        'solution': 'Smart Breeding Calendar',
        'description':
            'Track breeding cycles, pregnancy status, and calving dates. Maximize your breeding success rate.',
        'benefits': [
          'Increase conception rates by 15%',
          'Never miss optimal breeding windows',
          'Track genetics and lineage easily',
        ],
        'savings': 'Earn \$4,500/year more',
        'icon': Icons.pets,
        'problemIcon': Icons.event_busy,
      },
      {
        'problem': 'Inspector Visits Are Stressful',
        'solution': 'Compliance Made Easy',
        'description':
            'Generate inspection reports instantly. All your records organized exactly how inspectors want them.',
        'benefits': [
          'Pass inspections in 15 minutes',
          'Automatic compliance reports',
          'USDA and state regulation ready',
        ],
        'savings': 'Avoid \$5,000+ penalties',
        'icon': Icons.verified,
        'problemIcon': Icons.gavel,
      },
    ];

    final solution = solutions[index];

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _animations[index].value)),
          child: Opacity(
            opacity: _animations[index].value,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: index % 2 == 0 ? AppColors.background : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: isMobile
                  ? _buildMobileSolutionContent(solution)
                  : _buildDesktopSolutionContent(solution),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileSolutionContent(Map<String, dynamic> solution) {
    return Column(
      children: [
        _buildProblemSection(solution, true),
        const SizedBox(height: 24),
        _buildSolutionSection(solution, true),
      ],
    );
  }

  Widget _buildDesktopSolutionContent(Map<String, dynamic> solution) {
    return Row(
      children: [
        Expanded(flex: 5, child: _buildProblemSection(solution, false)),
        const SizedBox(width: 40),
        Container(
          width: 2,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(flex: 6, child: _buildSolutionSection(solution, false)),
      ],
    );
  }

  Widget _buildProblemSection(Map<String, dynamic> solution, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                solution['problemIcon'] as IconData,
                color: Colors.red[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'PROBLEM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          solution['problem'] as String,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 12),

        Text(
          solution['description'] as String,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildSolutionSection(Map<String, dynamic> solution, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                solution['icon'] as IconData,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'SOLUTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          solution['solution'] as String,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            height: 1.2,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 16),

        // Benefits list
        Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: (solution['benefits'] as List<String>).map((benefit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: isMobile
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      benefit,
                      style: const TextStyle(
                        fontSize: 15,
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
    );
  }

  Widget _buildBottomCTA(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Stop the Headaches?',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'Join 2,500+ farmers who save 2+ hours daily and thousands in costs',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
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
                // Handle start free trial
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.2),
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
