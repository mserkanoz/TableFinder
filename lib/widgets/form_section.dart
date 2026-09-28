import 'package:flutter/material.dart';

/// A titled form block with optional helper and error text.
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.child, this.helper, this.error});

  final String title;
  final String? helper;
  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          if (helper != null)
            Text(helper!, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          child,
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(error!, style: TextStyle(color: theme.colorScheme.error)),
            ),
        ],
      ),
    );
  }
}
