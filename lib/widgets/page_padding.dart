import 'package:flutter/widgets.dart';

/// Padding for scrollable pages. Android 15 draws apps edge-to-edge, so the
/// bottom must clear the system navigation bar (its height varies by phone).
EdgeInsets pagePadding(BuildContext context, {double top = 16}) =>
    EdgeInsets.fromLTRB(16, top, 16, 32 + MediaQuery.paddingOf(context).bottom);
