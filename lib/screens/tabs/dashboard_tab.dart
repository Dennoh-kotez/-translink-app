// lib/screens/tabs/dashboard_tab.dart
import 'package:flutter/material.dart';
import 'package:translink/widgets/service_card.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Our Services',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                ServiceCard(
                  title: 'Personal Transport',
                  icon: Icons.directions_car,
                  description: 'Book a ride for personal travel',
                ),
                ServiceCard(
                  title: 'Goods Delivery',
                  icon: Icons.local_shipping,
                  description: 'Send packages and cargo',
                ),
                ServiceCard(
                  title: 'Business Transport',
                  icon: Icons.business,
                  description: 'Corporate transportation solutions',
                ),
                ServiceCard(
                  title: 'Track Shipment',
                  icon: Icons.location_on,
                  description: 'Track your ongoing deliveries',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}