import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/auth_service.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/home/home_screen.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // On Android, options come from android/app/google-services.json.
  await Firebase.initializeApp();
  runApp(const TableFinderApp());
}

class TableFinderApp extends StatelessWidget {
  const TableFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF8E2A2A)),
      darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF8E2A2A), brightness: Brightness.dark),
      // Unsupported device languages fall back to English (the template locale).
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthGate(),
    );
  }
}

/// Shows the sign-in screen or the home screen depending on auth state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        return user == null ? const SignInScreen() : HomeScreen(user: user);
      },
    );
  }
}
