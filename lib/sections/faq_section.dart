import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I get started with Herdsman?',
      'answer':
          'Simply download the app, create an account, and start adding your livestock. Our onboarding process will guide you through the setup.',
    },
    {
      'question': 'Can I track multiple types of animals?',
      'answer':
          'Yes! Herdsman supports cattle, sheep, goats, pigs, and many other livestock types with customizable tracking features.',
    },
    {
      'question': 'Is my data secure?',
      'answer':
          'Absolutely. We use enterprise-grade encryption and security measures to protect your data. Your information is never shared with third parties.',
    },
    {
      'question': 'Can I export my data?',
      'answer':
          'Yes, you can export your data in various formats including CSV and PDF for record-keeping and reporting purposes.',
    },
    {
      'question': 'Do you offer customer support?',
      'answer':
          'We provide comprehensive support through email, chat, and phone. Premium users get priority support with faster response times.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(
                  bottom: AppConstants.smallPadding,
                ),
                child: ExpansionTile(
                  title: Text(
                    faqs[index]['question']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      child: Text(
                        faqs[index]['answer']!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
