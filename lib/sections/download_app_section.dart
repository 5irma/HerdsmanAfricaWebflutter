import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DownloadAppSection extends StatefulWidget {
  const DownloadAppSection({super.key});

  @override
  State<DownloadAppSection> createState() => _DownloadAppSectionState();
}

class _DownloadAppSectionState extends State<DownloadAppSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Section header
                  _buildSectionHeader(context, isMobile),

                  SizedBox(height: isMobile ? 40 : 60),

                  // Main content
                  isMobile ? _buildMobileLayout() : _buildDesktopLayout(),

                  SizedBox(height: isMobile ? 40 : 60),

                  // Download buttons
                  _buildDownloadButtons(isMobile),

                  const SizedBox(height: 32),

                  // App rating and compatibility
                  _buildAppCredibility(isMobile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Take Your Farm in Your Pocket',
          style: TextStyle(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Essential for field work. Track animals, take photos, and sync instantly with your desktop.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildPhoneMockup(true),
        const SizedBox(height: 40),
        _buildMobileFeatures(true),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 5, child: _buildMobileFeatures(false)),
        const SizedBox(width: 60),
        Expanded(flex: 4, child: _buildPhoneMockup(false)),
      ],
    );
  }

  Widget _buildPhoneMockup(bool isMobile) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isMobile ? 400 : 600,
        maxWidth: isMobile ? 250 : 300,
      ),
      child: Stack(
        children: [
          // Phone frame
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    color: Colors.white,
                    child: _buildAppScreen(isMobile),
                  ),
                ),
              ),
            ),
          ),

          // Sync indicator
          if (!isMobile)
            Positioned(top: -10, right: -10, child: _buildSyncIndicator()),
        ],
      ),
    );
  }

  Widget _buildAppScreen(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Status bar
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_4_bar,
                      size: 12,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.wifi, size: 12, color: AppColors.textPrimary),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.battery_full,
                      size: 12,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // App header
          Row(
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
              const Spacer(),
              Icon(Icons.sync, color: AppColors.success, size: 20),
            ],
          ),

          const SizedBox(height: 24),

          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAction(Icons.camera_alt, 'Photo'),
              _buildQuickAction(Icons.qr_code_scanner, 'Scan'),
              _buildQuickAction(Icons.add_circle, 'Add'),
            ],
          ),

          const SizedBox(height: 24),

          // Recent activity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildActivityItem('Cow #247 - Health check', '2 min ago'),
                _buildActivityItem('Photo uploaded', '5 min ago'),
                _buildActivityItem('Vaccination recorded', '1 hour ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sync, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          const Text(
            'Synced',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFeatures(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Built for the Field',
          style: TextStyle(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 24),

        // Key features
        Column(
          children: [
            _buildFeatureItem(
              Icons.camera_alt,
              'Instant Photo Capture',
              'Take photos of injuries, ear tags, or conditions. Auto-sync to your records.',
              isMobile,
            ),
            _buildFeatureItem(
              Icons.qr_code_scanner,
              'Quick Animal Scanning',
              'Scan ear tags or QR codes to instantly pull up animal records.',
              isMobile,
            ),
            _buildFeatureItem(
              Icons.cloud_sync,
              'Real-Time Sync',
              'Changes sync instantly between your phone and desktop. No data loss.',
              isMobile,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String description,
    bool isMobile,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButtons(bool isMobile) {
    return Column(
      children: [
        Text(
          'Download Now - It\'s Free',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        isMobile
            ? _buildMobileDownloadButtons()
            : _buildDesktopDownloadButtons(),
      ],
    );
  }

  Widget _buildMobileDownloadButtons() {
    return Column(
      children: [
        _buildAppStoreButton('Download on the', 'App Store', Icons.apple, () {
          // Handle iOS download
        }),
        const SizedBox(height: 16),
        _buildAppStoreButton('Get it on', 'Google Play', Icons.android, () {
          // Handle Android download
        }),
      ],
    );
  }

  Widget _buildDesktopDownloadButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAppStoreButton('Download on the', 'App Store', Icons.apple, () {
          // Handle iOS download
        }),
        const SizedBox(width: 20),
        _buildAppStoreButton('Get it on', 'Google Play', Icons.android, () {
          // Handle Android download
        }),
      ],
    );
  }

  Widget _buildAppStoreButton(
    String topText,
    String bottomText,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topText,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    bottomText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppCredibility(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Download or visit website to view demo account and access market place. Contact us to register as a farmer for animal field verification.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
