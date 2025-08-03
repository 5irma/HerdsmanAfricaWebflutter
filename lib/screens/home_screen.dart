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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            HowItWorksSection(),
            WhoItsForSection(),
            SolutionsSection(),
            TestimonialsSection(),
            PricingSection(),
            DownloadAppSection(),
            FaqSection(),
            ContactSection(),
          ],
        ),
      ),
    );
  }
}
