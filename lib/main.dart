import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translink/screens/splash_screen.dart';
import 'package:translink/services/currency_service.dart';
import 'package:translink/services/language_service.dart';
import 'package:translink/services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService(prefs)),
        ChangeNotifierProvider(create: (_) => LanguageService(prefs)),
        ChangeNotifierProvider(create: (_) => CurrencyService(prefs)),
      ],
      child: const TransLinkApp(),
    ),
  );
}

class TransLinkApp extends StatelessWidget {
  const TransLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransLink',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}