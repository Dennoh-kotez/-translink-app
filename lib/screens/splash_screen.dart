// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:translink/screens/home_screen.dart';
import 'package:translink/screens/login_screen.dart';
import 'package:translink/services/appwrite_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppwriteService _authService = AppwriteService();

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

 _navigateToNext() async {
  await Future.delayed(const Duration(seconds: 4));
  
  // Check if the user is authenticated
  bool isLoggedIn = await _authService.isLoggedIn();

  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => isLoggedIn ? const HomeScreen() : LoginScreen(authService: _authService),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 90,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'TransLink',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Your Reliable Transport Partner',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
