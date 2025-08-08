import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  // Option 1: EmailJS (replace these with your actual credentials from emailjs.com)
  static const String _serviceId = 'service_xxxxxxx'; // Your EmailJS service ID
  static const String _templateId =
      'template_xxxxxxx'; // Your EmailJS template ID
  static const String _publicKey = 'xxxxxxxxxxxxxxx'; // Your EmailJS public key

  // Option 2: Formspree (easier - just replace YOUR_FORM_ID)
  static const String _formspreeEndpoint =
      'https://formspree.io/f/YOUR_FORM_ID'; // Replace with your Formspree form ID

  // Option 3: Webhook.site (instant testing - no signup required)
  static const String _webhookUrl =
      'https://webhook.site/bde8700e-d680-4194-b1a1-fbc90678885f'; // Your webhook.site URL

  static Future<bool> sendContactEmail({
    required String name,
    required String email,
    required String phone,
    required String farmSize,
    required String contactReason,
    required String timePreference,
    required String message,
  }) async {
    try {
      // Choose your option by uncommenting one of these:

      // Option 1: EmailJS (requires credentials from emailjs.com)
      // return await _sendViaEmailJS(
      //   name: name,
      //   email: email,
      //   phone: phone,
      //   farmSize: farmSize,
      //   contactReason: contactReason,
      //   timePreference: timePreference,
      //   message: message,
      // );

      // Option 2: Formspree (requires form ID from formspree.io)
      // return await _sendViaFormspree(
      //   name: name,
      //   email: email,
      //   phone: phone,
      //   farmSize: farmSize,
      //   contactReason: contactReason,
      //   timePreference: timePreference,
      //   message: message,
      // );

      // Option 3: Webhook testing (works immediately - currently active)
      return await _sendViaWebhook(
        name: name,
        email: email,
        phone: phone,
        farmSize: farmSize,
        contactReason: contactReason,
        timePreference: timePreference,
        message: message,
      );
    } catch (e) {
      print('Error sending email: $e');
      print('Error type: ${e.runtimeType}');
      return false;
    }
  }

  static Future<bool> _sendViaEmailJS({
    required String name,
    required String email,
    required String phone,
    required String farmSize,
    required String contactReason,
    required String timePreference,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _publicKey,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'phone': phone,
          'farm_size': farmSize,
          'contact_reason': contactReason,
          'time_preference': timePreference,
          'message': message,
          'to_email': 'sirmakipkurui20@gmail.com',
        },
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> _sendViaFormspree({
    required String name,
    required String email,
    required String phone,
    required String farmSize,
    required String contactReason,
    required String timePreference,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(_formspreeEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'farm_size': farmSize,
        'contact_reason': contactReason,
        'time_preference': timePreference,
        'message': message,
        '_subject': 'New Contact Form: $contactReason',
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> _sendViaWebhook({
    required String name,
    required String email,
    required String phone,
    required String farmSize,
    required String contactReason,
    required String timePreference,
    required String message,
  }) async {
    try {
      print('🚀 Sending webhook to: $_webhookUrl');

      // Simple payload that webhook.site can easily handle
      final payload = {
        'name': name,
        'email': email,
        'phone': phone,
        'farm_size': farmSize,
        'contact_reason': contactReason,
        'time_preference': timePreference,
        'message': message,
        'notification_email': 'sirmakipkurui20@gmail.com',
        'timestamp': DateTime.now().toIso8601String(),
      };

      print('📦 Payload: ${jsonEncode(payload)}');

      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      print('✅ Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      // webhook.site returns 200 for successful requests
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('❌ Webhook error: $e');
      print('❌ Error type: ${e.runtimeType}');
      return false;
    }
  }
}
