import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/screens/home_screen.dart';
import 'package:weather/models/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve theme preference before app starts
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: MyApp(isDarkMode: isDarkMode),
    )
  );
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });

    // Save theme preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF008CFF), // Sky Blue
          onPrimary: Colors.white,
          secondary: Color(0xFF555555), // Medium Gray
          onSecondary: Colors.white, // Dark Gray
          surface: Color(0xFFF9F9F9), // Same as background
          onSurface: Color(0xFF555555), // Medium Gray
          error: Color(0xFFFF4500), // Orange-Red for hot temperature
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF008CFF), // Sky Blue
          onPrimary: Colors.white,
          secondary: Color(0xFFA9A9A9), // Dark Gray
          onSecondary: Colors.white, // Light Gray
          surface: Color(0xFF1E1E1E), // Same as background
          onSurface: Color(0xFFA9A9A9), // Dark Gray
          error: Color(0xFFFF6347), // Tomato for hot temperature
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}
