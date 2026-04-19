import 'package:flutter/material.dart';
import 'package:limit_kuota/src/features/monitoring/home_page.dart';
import 'package:limit_kuota/src/features/monitoring/network_page.dart';
import 'package:limit_kuota/src/features/monitoring/setting_page.dart';
import 'package:limit_kuota/src/features/splash_screen.dart';

final ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kuota Monitor',
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          // ☀️ LIGHT THEME
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              backgroundColor: Colors.white,
              elevation: 12,
            ),
          ),

          // 🌙 DARK THEME
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF12121F),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(0xFF1E1E2E),
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 3,
              color: const Color(0xFF2A2A3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              backgroundColor: Color(0xFF1E1E2E),
              elevation: 12,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
            ),
          ),

          home: const SplashScreen(),
          routes: {
            '/home': (context) => const HomePage(),
            '/network': (context) => const Network(),
            '/setting': (context) => SettingPage(onSave: () {}),
          },
        );
      },
    );
  }
}
