import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/auth_service.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_edit_screen.dart';
import 'features/profile/profile_repository.dart';
import 'features/profile/user_profile.dart';
import 'features/safety/block_repository.dart';
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

const _loading = Scaffold(body: Center(child: CircularProgressIndicator()));

/// Signed out -> sign-in screen; no profile yet -> profile setup; else home.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _loading;
        final user = snapshot.data;
        if (user == null) {
          BlockRepository.instance.stop();
          return const SignInScreen();
        }
        BlockRepository.instance.start(user.uid);
        return _ProfileGate(key: ValueKey(user.uid), user: user);
      },
    );
  }
}

class _ProfileGate extends StatelessWidget {
  const _ProfileGate({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ProfileRepository.instance.watch(user.uid),
      builder: (context, snapshot) {
        final doc = snapshot.data;
        // A missing doc from the local cache may just mean "not synced yet".
        if (doc == null || (!doc.exists && doc.metadata.isFromCache)) return _loading;
        if (!doc.exists) return ProfileEditScreen(user: user);
        return HomeScreen(user: user, profile: UserProfile.fromMap(doc.data()!));
      },
    );
  }
}
