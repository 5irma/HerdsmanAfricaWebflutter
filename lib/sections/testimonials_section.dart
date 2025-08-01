import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();

    // Auto-scroll testimonials
    Future.delayed(const Duration(seconds: 5), _autoScroll);
  }

  void _autoScroll() {
    if (mounted) {
      final nextIndex = (_currentIndex + 1) % testimonials.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 5), _autoScroll);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> testimonials = [
    {
      'quote':
          'Cut my calf mortality by 15% in the first year. The health alerts caught problems I would have missed completely. Worth every penny.',
      'name': 'Tom Rodriguez',
      'title': 'Beef Cattle Rancher',
      'location': 'Texas',
      'farmSize': '450 head',
      'farmType': 'Beef Cattle',
      'result': '15% reduction in calf mortality',
      'avatar': Icons.person,
      'hasVideo': true,
    },
    {
      'quote':
          'My 70-year-old father picked it up in a day. Now he tracks our 200 dairy cows from his phone while sitting on the porch. Game changer.',
      'name': 'Maria Santos',
      'title': 'Third-Generation Dairy Farmer',
      'location': 'Wisconsin',
      'farmSize': '200 cows',
      'farmType': 'Dairy',
      'result': 'Saved 3 hours daily on paperwork',
      'avatar': Icons.person_2,
      'hasVideo': false,
    },
    {
      'quote':
          'Breeding success rate went from 65% to 82%. The app reminds me exactly when each cow is ready. No more guessing games.',
      'name': 'Jake Thompson',
      'title': 'Mixed Operation Owner',
      'location': 'Nebraska',
      'farmSize': '320 head',
      'farmType': 'Beef & Dairy',
      'result': '17% increase in breeding success',
      'avatar': Icons.person_3,
      'hasVideo': true,
    },
    {
      'quote':
          'Inspector came last month - had all records ready in 10 minutes. He said it was the cleanest paperwork he\'d seen all year.',
      'name': 'Sarah Chen',
      'title': 'Organic Beef Producer',
      'location': 'California',
      'farmSize': '180 head',
      'farmType': 'Organic Beef',
      'result': 'Passed inspection in 10 minutes',
      'avatar': Icons.person_4,
      'hasVideo': false,
    },
    {
      'quote':
          'Started with 50 goats, now managing 300. The app scaled with us perfectly. Couldn\'t imagine running this operation without it.',
      'name': 'David Kim',
      'title': 'Goat Farmer',
      'location': 'North Carolina',
      'farmSize': '300 goats',
      'farmType': 'Meat Goats',
      'result': '6x farm growth in 2 years',
      'avatar': Icons.person,
      'hasVideo': true,
    },
    {
      'quote':
          'Saved \$4,200 last year just on vet bills. Catching health issues early makes all the difference. My animals are healthier than ever.',
      'name': 'Linda Johnson',
      'title': 'Sheep & Cattle Rancher',
      'location': 'Montana',
      'farmSize': '150 sheep, 80 cattle',
      'farmType': 'Mixed Livestock',
      'result': 'Saved \$4,200 on vet bills',
      'avatar': Icons.person_2,
      'hasVideo': false,
    },
  ];

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

          // Main testimonial carousel
          SizedBox(
            height: isMobile ? 400 : 450,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: testimonials.length,
              itemBuilder: (context, index) {
                return _buildMainTestimonial(testimonials[index], isMobile);
              },
            ),
          ),

          const SizedBox(height: 24),

          // Page indicators
          _buildPageIndicators(),

          SizedBox(height: isMobile ? 40 : 60),

          // Secondary testimonials grid
          _buildSecondaryTestimonials(isMobile),

          SizedBox(height: isMobile ? 40 : 60),

          // Trust indicators
          _buildTrustIndicators(isMobile),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Real Farmers, Real Results',
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
          'See how farmers across America are saving time and money',
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

  Widget _buildMainTestimonial(
    Map<String, dynamic> testimonial,
    bool isMobile,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
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
        children: [
          // Quote
          Icon(
            Icons.format_quote,
            size: 40,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),

          const SizedBox(height: 20),

          Text(
            testimonial['quote'] as String,
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              color: AppColors.textPrimary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Farmer info
          Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  testimonial['avatar'] as IconData,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          testimonial['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (testimonial['hasVideo'] as bool) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VIDEO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      testimonial['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${testimonial['farmSize']} • ${testimonial['location']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Result badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      testimonial['result'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(testimonials.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildSecondaryTestimonials(bool isMobile) {
    return Column(
      children: [
        Text(
          'More Success Stories',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isMobile ? 3 : 1.2,
          ),
          itemCount: 3,
          itemBuilder: (context, index) {
            final testimonial = testimonials[index + 3];
            return _buildSecondaryTestimonialCard(testimonial);
          },
        ),
      ],
    );
  }

  Widget _buildSecondaryTestimonialCard(Map<String, dynamic> testimonial) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  testimonial['avatar'] as IconData,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${testimonial['farmType']} • ${testimonial['location']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            testimonial['quote'] as String,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              testimonial['result'] as String,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicators(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Trusted by farmers in all 50 states',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrustStat('2,500+', 'Active Farmers'),
              _buildTrustStat('4.8/5', 'App Store Rating'),
              _buildTrustStat('98%', 'Would Recommend'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
