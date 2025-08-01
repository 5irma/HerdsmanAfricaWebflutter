import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isMobile ? 600 : 700),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20), // Dark green
            Color(0xFF2E7D32), // Primary green
            Color(0xFF388E3C), // Lighter green
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: isMobile ? 40 : 60,
        ),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeroContent(isMobile: true),
        const SizedBox(height: 40),
        _buildProductPreview(isMobile: true),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 6, child: _buildHeroContent(isMobile: false)),
        const SizedBox(width: 60),
        Expanded(flex: 5, child: _buildProductPreview(isMobile: false)),
      ],
    );
  }

  Widget _buildHeroContent({required bool isMobile}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                // Pain point headline
                Text(
                  'Track your entire herd from your phone',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),

                const SizedBox(height: 20),

                // Supporting message
                Text(
                  'Stop losing animals. Stop guessing health issues. Get real-time alerts and manage your livestock like the pros do.',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),

                const SizedBox(height: 16),

                // Social proof
                Row(
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    _buildStarRating(),
                    const SizedBox(width: 12),
                    Text(
                      'Trusted by 2,500+ farmers',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // CTA buttons
                Column(
                  children: [
                    _buildPrimaryCTA(isMobile),
                    const SizedBox(height: 12),
                    _buildSecondaryCTA(isMobile),
                  ],
                ),

                const SizedBox(height: 20),

                // Trust indicators
                Text(
                  '✓ Free 14-day trial  ✓ No credit card required  ✓ Setup in 5 minutes',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductPreview({required bool isMobile}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: BoxConstraints(maxHeight: isMobile ? 300 : 500),
            child: Stack(
              children: [
                // Phone mockup background
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: isMobile ? 250 : 300,
                      height: isMobile ? 300 : 500,
                      color: Colors.white,
                      child: _buildAppInterface(isMobile),
                    ),
                  ),
                ),

                // Floating elements for credibility
                if (!isMobile) ...[
                  Positioned(
                    top: 20,
                    right: -20,
                    child: _buildFloatingCard('124 Cattle', Icons.pets),
                  ),
                  Positioned(
                    bottom: 60,
                    left: -30,
                    child: _buildFloatingCard(
                      'Health Alert',
                      Icons.warning_amber,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppInterface(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // App header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Herdsman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Dashboard preview
          Expanded(
            child: Column(
              children: [
                _buildDashboardCard('Total Animals', '124', Icons.pets),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  'Health Alerts',
                  '3',
                  Icons.health_and_safety,
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  'Due for Vaccination',
                  '8',
                  Icons.medical_services,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(Icons.star, color: Colors.amber[300], size: 16);
      }),
    );
  }

  Widget _buildPrimaryCTA(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 200,
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
    );
  }

  Widget _buildSecondaryCTA(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 200,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          // Handle see demo
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 20),
            SizedBox(width: 8),
            Text(
              'See Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
