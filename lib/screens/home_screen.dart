import 'package:flutter/material.dart';
import 'package:translink/services/profile_service.dart';
import 'package:translink/widgets/custom_bottom_nav.dart';
import 'package:translink/screens/tabs/dashboard_tab.dart';
import 'package:translink/screens/tabs/bookings_tab.dart';
import 'package:translink/screens/tabs/tracking_tab.dart';
import 'package:translink/screens/tabs/profile_tab.dart';
import 'package:translink/services/appwrite_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  int _currentIndex = 0;

  // Create an instance of AppwriteService
  final AppwriteService authService = AppwriteService();
  // Create an instance of ProfileService with authService as a positional argument
  final ProfileService profileService;

  _HomeScreenState() : profileService = ProfileService(AppwriteService());

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    // Initialize the tabs with the authService and profileService instances
    _tabs = [
      const DashboardTab(),
      const BookingsTab(),
      const TrackingTab(),
      ProfileTab(authService: authService, profileService: profileService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
