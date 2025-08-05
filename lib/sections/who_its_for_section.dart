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
        'title': 'Meat Producers',
        'description': '',
        'icon': Icons.home,
        'benefits': [
          'Weight Tracking',
          'Select for Better Meat Quality',
          'Meat Traceability',
          'Breeding for Best Meat Traits',
        ],
      },
      {
        'title': 'Dairy Farmers',
        'description': '',
        'icon': Icons.trending_up,
        'benefits': [
          'Track Milk Yields Per Animal',
          'Breed for High Milk Productivity',
          'Manage Lactation Cycles',
          'Dairy Traceability',
        ],
      },
      {
        'title': 'Breeders',
        'description': '',
        'icon': Icons.business,
        'benefits': [
          'Precision Breeding Records',
          'Data-Driven Decisions',
          'Optimize Genetic Selection',
          'Seamless Record Transfer to Buyers',
        ],
      },
      {
        'title': 'Powering Breeding Associations & Milk Cooperatives',
        'description': '',
        'icon': Icons.people,
        'benefits': [
          'Centralized Animal Records',
          'Standardize Breeding Practices',
          'Aggregate Milk & Weight Data',
          'Financial Integration & Credit Access',
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
                  Column(children: _buildBenefitsList(target, index)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBenefitsList(Map<String, dynamic> target, int index) {
    // Special handling for Meat Producers section (index 0) with detailed descriptions
    if (index == 0) {
      final meatProducerBenefits = [
        {
          'title': 'Weight Tracking',
          'description':
              'Know optimal time to sell animals before they start eating into your profits.',
        },
        {
          'title': 'Select for Better Meat Quality',
          'description':
              'Use breeding and growth data to prioritize animals with superior meat traits—fast growers, low fat, strong muscle tone.',
        },
        {
          'title': 'Meat Traceability',
          'description':
              'Provide processors and consumers with transparent, verified traceability that meets regulatory and export standards.',
        },
        {
          'title': 'Breeding for Best Meat Traits',
          'description':
              'Use data to selectively breed animals with desirable characteristics like faster growth, better feed efficiency, higher carcass yield, and leaner meat.',
        },
      ];

      return meatProducerBenefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  benefit['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    // Special handling for Dairy Farmers section (index 1) with detailed descriptions
    if (index == 1) {
      final dairyFarmerBenefits = [
        {
          'title': 'Track Milk Yields Per Animal',
          'description':
              'Record daily, weekly, or monthly milk output per cow, goat, or camel. Spot top performers and address low yielders early.',
        },
        {
          'title': 'Breed for High Milk Productivity',
          'description':
              'Select animals with proven genetics for higher milk yield, longer lactation cycles, and disease resistance—generation after generation.',
        },
        {
          'title': 'Manage Lactation Cycles',
          'description':
              'Monitor lactation phases, drying-off dates, and breeding windows to maintain consistent milk flow year-round.',
        },
        {
          'title': 'Dairy Traceability',
          'description':
              'Maintain complete records from birth to milk production, including treatments and performance—crucial for milk quality assurance, buyer confidence, and regulatory compliance.',
        },
      ];

      return dairyFarmerBenefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  benefit['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    // Special handling for Breeders section (index 2) with detailed descriptions
    if (index == 2) {
      final breedingBenefits = [
        {
          'title': 'Precision Breeding Records',
          'description':
              'Track every animal\'s pedigree, birth history, and lineage with ease. Eliminate guesswork and breed with confidence.',
        },
        {
          'title': 'Data-Driven Decisions',
          'description':
              'Access clear dashboards showing breeding performance, fertility trends, and calving intervals across your herd.',
        },
        {
          'title': 'Optimize Genetic Selection',
          'description':
              'Use historical data to choose breeding pairs that enhance milk yield, growth rate, disease resistance, and more.',
        },
        {
          'title': 'Seamless Record Transfer to Buyers',
          'description':
              'When selling an animal, instantly transfer its full digital record to the new owner—lineage, health, and performance—all in one click. Build trust and reputation as a transparent, professional breeder.',
        },
      ];

      return breedingBenefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  benefit['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    // Special handling for Breeding Associations & Milk Cooperatives section (index 3) with detailed descriptions
    if (index == 3) {
      final cooperativeBenefits = [
        {
          'title': 'Centralized Animal Records',
          'description':
              'Access structured, real-time data on every member\'s livestock—breed, health, productivity, and ownership—across the entire group.',
        },
        {
          'title': 'Standardize Breeding Practices',
          'description':
              'Ensure members follow consistent, data-driven breeding protocols. Monitor lineage, control inbreeding, and preserve high-value genetics.',
        },
        {
          'title': 'Aggregate Milk & Weight Data',
          'description':
              'View milk yields and weight gains across herds and regions. Benchmark performance, identify top-performing farms, and support lagging ones.',
        },
        {
          'title': 'Financial Integration & Credit Access',
          'description':
              'Use verified herd data to support member loan applications, insurance, or subsidy programs with full animal records as collateral.',
        },
      ];

      return cooperativeBenefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  benefit['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    // Default benefits for other sections
    return (target['benefits'] as List<String>).map((benefit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 16),
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
    }).toList();
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
