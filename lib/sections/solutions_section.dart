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
          _buildSectionHeader(context, isMobile),
          SizedBox(height: isMobile ? 40 : 60),
          Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 32 : 40),
                child: _buildSolutionCard(index, isMobile),
              );
            }),
          ),
          SizedBox(height: isMobile ? 40 : 60),
          _buildBottomCTA(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Built for Livestock Farmers',
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
          'Herdsman solves the top problems that slow down your livestock operation.',
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
        'problem': 'Scattered Animal Records',
        'solution': 'Centralized Digital Profiles',
        'description':
            'Stop flipping through notebooks. All animal data is stored safely in the cloud with instant access from any device.',
        'benefits': [
          'Access records anywhere, anytime',
          'Secure cloud backup',
          'No lost or damaged paper logs',
        ],
        'savings': 'Save 10+ hours/month on recordkeeping',
        'icon': Icons.description,
        'problemIcon': Icons.folder_off,
      },
      {
        'problem': 'Missed Vaccinations & Treatments',
        'solution': 'Smart Notifications & Schedules',
        'description':
            'Herdsman reminds you when animals are due for vaccines or medications so you never fall behind.',
        'benefits': [
          'Automated reminders',
          'Vet history tracking',
          'Fewer missed treatments = healthier herds',
        ],
        'savings': 'Reduce disease outbreaks by 70%',
        'icon': Icons.schedule,
        'problemIcon': Icons.warning,
      },
      {
        'problem': 'Blind Spots in Production Tracking',
        'solution': 'Real-Time Production Monitoring',
        'description':
            'Stop guessing. Track livestock output like milk, weight gain, and reproduction trends with precision.',
        'benefits': [
          'Visual dashboards for key metrics',
          'Improve feed-to-output efficiency',
          'Identify underperforming animals early',
        ],
        'savings': 'Maximize yields and reduce wastage by 30%',
        'icon': Icons.health_and_safety,
        'problemIcon': Icons.sick,
      },
      {
        'problem': 'Disorganized Breeding Info',
        'solution': 'Automated Breeding Tracker',
        'description':
            'Know exactly when to breed, expected delivery dates, and keep genetic records—all in one place.',
        'benefits': [
          'Optimize breeding windows',
          'Track pregnancy stages',
          'Monitor sire and dam lineage',
        ],
        'savings': 'Boost conception rates by 20%',
        'icon': Icons.pets,
        'problemIcon': Icons.event_busy,
      },
      {
        'problem': 'Untrusted Marketplace Transactions',
        'solution': 'EID-Verified Fraud-Proof Marketplace',
        'description':
            'Every animal has a verified identity. Buyers and sellers transact confidently via the Herdsman marketplace.',
        'benefits': [
          'Electronic Identification and verification of animals',
          'No fake listings',
          'Trustworthy farm-to-farm sales',
        ],
        'savings': 'Prevent losses from fraud and boost trade confidence',
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
                  color: AppColors.primary.withOpacity(0.1),
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
                AppColors.primary.withOpacity(0.3),
                AppColors.primary,
                AppColors.primary.withOpacity(0.3),
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
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
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
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 12),
        Text(
          solution['description'] as String,
          style: TextStyle(
            fontSize: 15,
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
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
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
            'Ready to Take Control of Your Farm?',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join farmers across Africa using Herdsman to save time, reduce losses, and boost profits.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
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
                shadowColor: Colors.black.withOpacity(0.2),
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
