import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/favorite_screen.dart';
import 'screens/home_page.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'providers/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    final theme = base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: base.colorScheme.copyWith(primary: Colors.pink.shade300),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      scaffoldBackgroundColor: const Color(0xFFFCF8F9),
    );

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          title: 'SushiOrder',
          debugShowCheckedModeBanner: false,
          theme: theme,

          /// ✅ halaman utama tergantung login
          home: auth.isLoggedIn ? const HomePage() : const LoginScreen(),

          /// ✅ routes HARUS di sini (di dalam MaterialApp)
          routes: {
            '/profile': (_) => const ProfileScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/edit-profile': (_) => const EditProfileScreen(),
            '/favorite': (context) => const FavoriteScreen(),
          },
        );
      },
    );
  }
}
