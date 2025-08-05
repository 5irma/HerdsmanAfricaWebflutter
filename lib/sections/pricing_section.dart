import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PricingSection extends StatefulWidget {
  const PricingSection({super.key});

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _showAnnual = true;
  final TextEditingController _animalCountController = TextEditingController(
    text: '50',
  );

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
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
    _animalCountController.dispose();
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

          SizedBox(height: isMobile ? 30 : 40),

          // Billing toggle
          _buildBillingToggle(isMobile),

          SizedBox(height: isMobile ? 40 : 60),

          // Pricing cards
          isMobile ? _buildMobilePricing() : _buildDesktopPricing(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Simple, Honest Pricing',
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
          'No hidden fees. No surprises. Just fair pricing that grows with your farm.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pay as you scale model',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingToggle(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('Monthly', !_showAnnual),
          _buildToggleButton('Annual (Save 20%)', _showAnnual),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAnnual = text.contains('Annual');
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMobilePricing() {
    return _buildSinglePricingCard(true);
  }

  Widget _buildDesktopPricing() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: _buildSinglePricingCard(false),
      ),
    );
  }

  Widget _buildSinglePricingCard(bool isMobile) {
    // Price calculator: 10 KSh per animal per month
    final pricePerAnimal = 10; // KSh per month
    final usdRate = 130; // 1 USD = 130 KSh (approximate)
    final annualDiscount = 0.20; // 20% discount for annual billing

    int animalCount = int.tryParse(_animalCountController.text) ?? 0;
    int monthlyPriceKsh = animalCount * pricePerAnimal;
    int annualPriceKsh = _showAnnual
        ? (monthlyPriceKsh * 12 * (1 - annualDiscount)).round()
        : monthlyPriceKsh * 12;

    int displayPriceKsh = _showAnnual ? annualPriceKsh : monthlyPriceKsh;
    double displayPriceUsd = displayPriceKsh / usdRate;

    final features = [
      'Complete cattle records',
      'Pasture maps and records',
      'Equipment inventory and maintenance',
      'Income & Expense log',
      'Calendar and Tasks',
      'Unlimited Users',
    ];

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Features section
          Text(
            'Top Features',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Features list
          Column(
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Price Calculator
          Text(
            'Price Calculator',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'Enter the number of animals in your farm:',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Animal count input field
          TextFormField(
            controller: _animalCountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Enter number of animals',
              hintStyle: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onChanged: (value) {
              setState(() {
                // Trigger rebuild to update price
              });
            },
          ),

          const SizedBox(height: 16),

          // Rate display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Rate: KSh 10 per animal per month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),

          // Pricing section
          Text(
            'Pricing per account:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Price display
          if (animalCount > 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KSh $displayPriceKsh',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _showAnnual ? '/year' : '/month',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '(\$${displayPriceUsd.toStringAsFixed(2)} USD)',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (_showAnnual && animalCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Save KSh ${(monthlyPriceKsh * 12 - annualPriceKsh)} per year (20% off)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Text(
              'Enter number of animals to see pricing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 32),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Handle plan selection
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
              child: Text(
                animalCount > 0 ? 'Start Free Trial' : 'Enter Animal Count',
                style: const TextStyle(
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

  Widget _buildPricingCard(int index, bool isMobile) {
    final plans = [
      {
        'name': 'Small Farm',
        'subtitle': 'Perfect for getting started',
        'monthlyPrice': 29,
        'annualPrice': 279, // 20% discount
        'perHead': 0.58,
        'maxAnimals': 50,
        'popular': false,
        'features': [
          'Up to 50 animals',
          'Health tracking & alerts',
          'Vaccination reminders',
          'Basic reports',
          'Phone & email support',
          'Mobile app access',
        ],
        'savings': 'Save \$1,200/year vs paper records',
      },
      {
        'name': 'Growing Farm',
        'subtitle': 'Most popular choice',
        'monthlyPrice': 79,
        'annualPrice': 759, // 20% discount
        'perHead': 0.32,
        'maxAnimals': 250,
        'popular': true,
        'features': [
          'Up to 250 animals',
          'Advanced health analytics',
          'Breeding management',
          'Financial tracking',
          'Custom reports',
          'Priority support',
          'Bulk operations',
          'Data export',
        ],
        'savings': 'Save \$3,500/year vs spreadsheets',
      },
      {
        'name': 'Large Operation',
        'subtitle': 'For serious ranchers',
        'monthlyPrice': 149,
        'annualPrice': 1429, // 20% discount
        'perHead': 0.24,
        'maxAnimals': 600,
        'popular': false,
        'features': [
          'Up to 600+ animals',
          'Multi-location support',
          'Advanced analytics',
          'Custom integrations',
          'Dedicated account manager',
          'Training & onboarding',
          'API access',
          'White-label options',
        ],
        'savings': 'Save \$8,000/year vs multiple systems',
      },
    ];

    final plan = plans[index];
    final isPopular = plan['popular'] as bool;
    final price = _showAnnual
        ? plan['annualPrice'] as int
        : plan['monthlyPrice'] as int;
    final period = _showAnnual ? 'per year' : 'per month';

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _animations[index].value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isPopular
                  ? Border.all(color: AppColors.primary, width: 3)
                  : Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: isPopular
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isPopular ? 20 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (isPopular)
                  Positioned(
                    top: -1,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'MOST POPULAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(isPopular ? 32 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPopular) const SizedBox(height: 20),

                      // Plan name and subtitle
                      Text(
                        plan['name'] as String,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        plan['subtitle'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$$price',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              period,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Per head cost
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Just \$${(plan['perHead'] as double).toStringAsFixed(2)} per animal per month',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Coffee comparison
                      Text(
                        'Less than half a cup of coffee per animal',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Features
                      Column(
                        children: (plan['features'] as List<String>).map((
                          feature,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Savings highlight
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.savings,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                plan['savings'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle plan selection
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPopular
                                ? AppColors.primary
                                : Colors.white,
                            foregroundColor: isPopular
                                ? Colors.white
                                : AppColors.primary,
                            side: isPopular
                                ? null
                                : const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                            elevation: isPopular ? 4 : 0,
                            shadowColor: AppColors.primary.withValues(
                              alpha: 0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValueComparison(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Compare the Real Cost',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          isMobile ? _buildMobileComparison() : _buildDesktopComparison(),
        ],
      ),
    );
  }

  Widget _buildMobileComparison() {
    return Column(
      children: [
        _buildComparisonItem(
          'Losing ONE animal due to poor records',
          '\$1,500 - \$3,000',
          Colors.red,
          Icons.warning,
        ),
        const SizedBox(height: 16),
        _buildComparisonItem(
          'Herdsman for an ENTIRE YEAR',
          '\$279 - \$1,429',
          AppColors.success,
          Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildDesktopComparison() {
    return Row(
      children: [
        Expanded(
          child: _buildComparisonItem(
            'Losing ONE animal due to poor records',
            '\$1,500 - \$3,000',
            Colors.red,
            Icons.warning,
          ),
        ),
        const SizedBox(width: 40),
        Text(
          'VS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildComparisonItem(
            'Herdsman for an ENTIRE YEAR',
            '\$279 - \$1,429',
            AppColors.success,
            Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonItem(
    String title,
    String cost,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            cost,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGuarantees(bool isMobile) {
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
            'Our Promise to You',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          isMobile ? _buildMobileGuarantees() : _buildDesktopGuarantees(),

          const SizedBox(height: 32),

          SizedBox(
            width: isMobile ? double.infinity : 300,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Handle start trial
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
                'Get Started',
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

  Widget _buildMobileGuarantees() {
    return Column(
      children: [
        _buildGuaranteeItem(Icons.shield, '30-Day Money-Back Guarantee'),
        const SizedBox(height: 16),
        _buildGuaranteeItem(Icons.lock, 'No Hidden Fees Ever'),
        const SizedBox(height: 16),
        _buildGuaranteeItem(Icons.support_agent, '24/7 Farmer Support'),
        const SizedBox(height: 16),
        _buildGuaranteeItem(Icons.cancel, 'Cancel Anytime'),
      ],
    );
  }

  Widget _buildDesktopGuarantees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGuaranteeItem(Icons.shield, '30-Day Money-Back\nGuarantee'),
        _buildGuaranteeItem(Icons.lock, 'No Hidden\nFees Ever'),
        _buildGuaranteeItem(Icons.support_agent, '24/7 Farmer\nSupport'),
        _buildGuaranteeItem(Icons.cancel, 'Cancel\nAnytime'),
      ],
    );
  }

  Widget _buildGuaranteeItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
