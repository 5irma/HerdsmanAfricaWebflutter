import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomNavbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomNavbarState extends State<CustomNavbar> {
  String? hoveredItem;

  final List<NavItem> navItems = [
    NavItem('Home', () {}),
    NavItem('Solutions', () {}),
    NavItem('How it works', () {}),
    NavItem('Testimonials', () {}),
    NavItem('Pricing', () {}),
    NavItem('Download Mobile App', () {}),
    NavItem('FAQs', () {}),
    NavItem('Contacts', () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Logo section
            _buildLogo(context),

            const SizedBox(width: 20),

            // Navigation items
            _buildNavigationItems(context),

            const SizedBox(width: 16),

            // CTA buttons
            _buildCTAButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to home
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.agriculture,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Herdsman',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: navItems.map((item) {
            final isHovered = hoveredItem == item.title;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => hoveredItem = item.title),
              onExit: (_) => setState(() => hoveredItem = null),
              child: TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                tween: ColorTween(
                  begin: Colors.transparent,
                  end: isHovered ? AppColors.hover : Colors.transparent,
                ),
                builder: (context, backgroundColor, child) {
                  return TweenAnimationBuilder<Color?>(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: ColorTween(
                      begin: AppColors.textPrimary,
                      end: isHovered
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    builder: (context, textColor, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: GestureDetector(
                          onTap: item.onTap,
                          child: Text(
                            item.title,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCTAButtons(BuildContext context) {
    return Row(
      children: [
        // Login button
        _buildButton(
          context: context,
          text: 'Login',
          onPressed: () {
            // Handle login
          },
          isOutlined: true,
        ),

        const SizedBox(width: 12),

        // Get Started button
        _buildButton(
          context: context,
          text: 'Get Started',
          onPressed: () {
            // Handle sign up
          },
          isOutlined: false,
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutlined
                ? Colors.transparent
                : AppColors.primary,
            foregroundColor: isOutlined ? AppColors.primary : Colors.white,
            side: isOutlined
                ? const BorderSide(color: AppColors.primary, width: 1.5)
                : null,
            elevation: isOutlined ? 0 : 2,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String title;
  final VoidCallback onTap;

  NavItem(this.title, this.onTap);
}
