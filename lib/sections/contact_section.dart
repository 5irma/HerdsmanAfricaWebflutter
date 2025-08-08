import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../services/email_service.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _messageController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _selectedContactReason = 'General Question';
  String _selectedTimePreference = 'Morning (8 AM - 12 PM)';

  final List<String> _contactReasons = [
    'General Question',
    'Technical Support',
    'Schedule Demo',
    'Pricing Information',
    'Emergency Support',
    'Feature Request',
  ];

  final List<String> _timePreferences = [
    'Early Morning (5 AM - 8 AM)',
    'Morning (8 AM - 12 PM)',
    'Afternoon (12 PM - 5 PM)',
    'Evening (5 PM - 8 PM)',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _farmSizeController.dispose();
    _messageController.dispose();
    _animationController.dispose();
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
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Section header
                _buildSectionHeader(context, isMobile),

                SizedBox(height: isMobile ? 40 : 60),

                // Contact options
                _buildContactOptions(isMobile),

                SizedBox(height: isMobile ? 40 : 60),

                // Main content
                isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ],
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
          'We\'re Here to Help',
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
          'Real farmers helping real farmers. Choose how you\'d like to connect with us.',
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

  Widget _buildContactOptions(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Choose Your Preferred Contact Method',
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isMobile ? 20 : 24),

          isMobile
              ? _buildMobileContactOptions()
              : _buildDesktopContactOptions(),
        ],
      ),
    );
  }

  Widget _buildMobileContactOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildContactOption(
                Icons.phone,
                'Call Us',
                '+254 757 439 886',
                'phone',
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactOption(
                Icons.message,
                'Text/SMS',
                '+254 757 439 886',
                'phone',
                AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildContactOption(
                Icons.email,
                'Email',
                'sirmakipkurui20@gmail.com',
                'email',
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactOption(
                Icons.chat,
                'WhatsApp',
                '+254 757 439 886',
                'whatsapp',
                AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopContactOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildContactOption(
            Icons.phone,
            'Call Us',
            '+254 757 439 886',
            'phone',
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildContactOption(
            Icons.message,
            'Text/SMS',
            '+254 757 439 886',
            'phone',
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildContactOption(
            Icons.email,
            'Email',
            'sirmakipkurui20@gmail.com',
            'email',
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildContactOption(
            Icons.chat,
            'WhatsApp',
            '+254 757 439 886',
            'whatsapp',
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String contact,
    String actionType,
    Color color,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          switch (actionType) {
            case 'phone':
              _copyToClipboard(contact, 'Phone number');
              break;
            case 'email':
              _copyToClipboard(contact, 'Email address');
              break;
            case 'whatsapp':
              _openWhatsApp(contact);
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                contact,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _buildContactForm(true),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: _buildContactForm(false),
      ),
    );
  }

  Widget _buildBusinessInfo(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            'Our Farm Office',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),

          const SizedBox(height: 24),

          // Business hours
          _buildInfoSection(
            'Farmer-Friendly Hours',
            [
              'Monday - Friday: 5:00 AM - 8:00 PM',
              'Saturday: 6:00 AM - 6:00 PM',
              'Sunday: 8:00 AM - 4:00 PM',
              '',
              'We know you start early!',
            ],
            Icons.schedule,
            isMobile,
          ),

          const SizedBox(height: 24),

          // Physical address
          _buildInfoSection(
            'Visit Our Farm',
            [
              'Herdsman Agriculture Center',
              '2847 Ranch Road 12',
              'Dripping Springs, TX 78620',
              '',
              'Open for farm tours by appointment',
            ],
            Icons.location_on,
            isMobile,
          ),

          const SizedBox(height: 24),

          // Response times
          _buildInfoSection(
            'Response Time Promise',
            [
              'Phone calls: Answered within 3 rings',
              'Text messages: Within 15 minutes',
              'Emails: Within 2 hours',
              'WhatsApp: Within 30 minutes',
              'Emergency: Immediate response',
            ],
            Icons.timer,
            isMobile,
          ),

          const SizedBox(height: 32),

          // Schedule demo button
          SizedBox(
            width: isMobile ? double.infinity : 250,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Handle demo scheduling
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_call, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Schedule Demo Call',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    List<String> items,
    IconData icon,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: item.isEmpty
                      ? Colors.transparent
                      : AppColors.textSecondary,
                  fontWeight: item.contains('!')
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactForm(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Us a Message',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'We\'ll get back to you within 2 hours during business hours',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: isMobile ? 20 : 24),

            // Contact reason dropdown
            _buildDropdownField(
              'What can we help you with?',
              _selectedContactReason,
              _contactReasons,
              (value) => setState(() => _selectedContactReason = value!),
            ),

            const SizedBox(height: 20),

            // Name and phone row
            isMobile ? _buildMobileNamePhone() : _buildDesktopNamePhone(),

            const SizedBox(height: 20),

            // Email and farm size row
            isMobile ? _buildMobileEmailFarm() : _buildDesktopEmailFarm(),

            const SizedBox(height: 20),

            // Best time to contact
            _buildDropdownField(
              'Best time to contact you',
              _selectedTimePreference,
              _timePreferences,
              (value) => setState(() => _selectedTimePreference = value!),
            ),

            const SizedBox(height: 20),

            // Message field
            _buildLargeTextField(
              'Tell us about your farm and what you need help with',
              _messageController,
              isMobile ? 3 : 4,
            ),

            SizedBox(height: isMobile ? 24 : 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _submitForm();
                  }
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
                  'Send Message',
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
    );
  }

  Widget _buildMobileNamePhone() {
    return Column(
      children: [
        _buildTextField('Your Name', _nameController),
        const SizedBox(height: 20),
        _buildTextField(
          'Phone Number',
          _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildDesktopNamePhone() {
    return Row(
      children: [
        Expanded(child: _buildTextField('Your Name', _nameController)),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            'Phone Number',
            _phoneController,
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileEmailFarm() {
    return Column(
      children: [
        _buildTextField(
          'Email Address',
          _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          'Farm Size (number of animals)',
          _farmSizeController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildDesktopEmailFarm() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            'Email Address',
            _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            'Farm Size (number of animals)',
            _farmSizeController,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label.contains('Email') && !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildLargeTextField(
    String label,
    TextEditingController controller,
    int maxLines,
  ) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please tell us how we can help you';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option, style: const TextStyle(fontSize: 16)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildEmergencySupport(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emergency, color: Colors.red[600], size: 24),
              const SizedBox(width: 12),
              Text(
                'Emergency Support',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Animal health emergency or system down? Call our emergency line for immediate assistance.',
            style: TextStyle(fontSize: 14, color: Colors.red[700], height: 1.5),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Emergency: +1 (555) 911-FARM',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Available 24/7 for existing customers',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for contact actions
  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type copied to clipboard!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openWhatsApp(String phoneNumber) async {
    final whatsappUrl =
        'https://wa.me/${phoneNumber.replaceAll(RegExp(r'[^\d+]'), '')}';
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Sending message...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      // Send email using EmailService
      final success = await EmailService.sendContactEmail(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        farmSize: _farmSizeController.text,
        contactReason: _selectedContactReason,
        timePreference: _selectedTimePreference,
        message: _messageController.text,
      );

      // Clear the loading snackbar
      ScaffoldMessenger.of(context).clearSnackBars();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent! We\'ll respond within 2 hours.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
          ),
        );
        _clearForm();
      } else {
        throw Exception('Failed to send email');
      }
    } catch (e) {
      // Clear the loading snackbar
      ScaffoldMessenger.of(context).clearSnackBars();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _farmSizeController.clear();
    _messageController.clear();
    setState(() {
      _selectedContactReason = 'General Question';
      _selectedTimePreference = 'Morning (8 AM - 12 PM)';
    });
  }
}
