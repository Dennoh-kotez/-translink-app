// lib/screens/help_support_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FAQ Section
          Card(
            child: ExpansionTile(
              title: const Text('Frequently Asked Questions'),
              children: [
                ListTile(
                  title: const Text('How do I book a ride?'),
                  subtitle: const Text('Tap the "Book" button and follow the instructions...'),
                ),
                ListTile(
                  title: const Text('How do I update my profile?'),
                  subtitle: const Text('Go to Profile tab and tap the edit button...'),
                ),
                // Add more FAQ items
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Contact Support
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email Support'),
                    subtitle: const Text('support@translink.com'),
                    onTap: () => _launchUrl('mailto:support@translink.com'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone Support'),
                    subtitle: const Text('+1 (555) 123-4567'),
                    onTap: () => _launchUrl('tel:+15551234567'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('Live Chat'),
                    subtitle: const Text('Available 24/7'),
                    onTap: () {
                      // Implement live chat functionality
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Help Articles
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'Help Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Getting Started Guide'),
                  onTap: () {
                    // Navigate to article
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Safety Guidelines'),
                  onTap: () {
                    // Navigate to article
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment Information'),
                  onTap: () {
                    // Navigate to article
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Emergency Contact
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'For immediate assistance in case of emergency:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.emergency),
                    label: const Text('Emergency Hotline'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _launchUrl('tel:911'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}