import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import '../sections/hero_section.dart';
import '../sections/how_it_works_section.dart';
import '../sections/who_its_for_section.dart';
import '../sections/solutions_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/pricing_section.dart';
import '../sections/download_app_section.dart';
import '../sections/faq_section.dart';
import '../sections/contact_section.dart';

class HomeScreen extends StatefulWidget {
  final String? scrollToSection;

  const HomeScreen({super.key, this.scrollToSection});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'hero': GlobalKey(),
    'how-it-works': GlobalKey(),
    'who-its-for': GlobalKey(),
    'solutions': GlobalKey(),
    'testimonials': GlobalKey(),
    'pricing': GlobalKey(),
    'download': GlobalKey(),
    'faqs': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    // Scroll to section after the widget is built
    if (widget.scrollToSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection(widget.scrollToSection!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionName) {
    final key = _sectionKeys[sectionName];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(key: _sectionKeys['hero'], child: const HeroSection()),
            Container(
              key: _sectionKeys['how-it-works'],
              child: const HowItWorksSection(),
            ),
            Container(
              key: _sectionKeys['who-its-for'],
              child: const WhoItsForSection(),
            ),
            Container(
              key: _sectionKeys['solutions'],
              child: const SolutionsSection(),
            ),
            Container(
              key: _sectionKeys['testimonials'],
              child: const TestimonialsSection(),
            ),
            Container(
              key: _sectionKeys['pricing'],
              child: const PricingSection(),
            ),
            Container(
              key: _sectionKeys['download'],
              child: const DownloadAppSection(),
            ),
            Container(key: _sectionKeys['faqs'], child: const FaqSection()),
            Container(
              key: _sectionKeys['contact'],
              child: const ContactSection(),
            ),
          ],
        ),
      ),
    );
  }
}
