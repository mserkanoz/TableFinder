import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _ageConfirmed = false;
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      await AuthService.instance.signInWithGoogle();
    } catch (e) {
      debugPrint('Sign-in error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).signInFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.casino_outlined, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(l10n.appTitle, style: theme.textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(l10n.tagline, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
                const SizedBox(height: 40),
                CheckboxListTile(
                  value: _ageConfirmed,
                  onChanged: _busy ? null : (v) => setState(() => _ageConfirmed = v ?? false),
                  title: Text(l10n.ageConfirmation),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _ageConfirmed && !_busy ? _signIn : null,
                    icon: _busy
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.login),
                    label: Text(l10n.signInWithGoogle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
