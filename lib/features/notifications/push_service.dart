import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../chat/chat_screen.dart';
import '../games/game_detail_screen.dart';
import '../profile/user_profile.dart';

/// Global keys so notifications can navigate and show snack bars from
/// outside the widget tree.
final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Registers this device for push notifications and routes taps.
///
/// Tokens live in `users/{uid}/tokens/{token}` (private to the owner) with the
/// app language, which Cloud Functions use to pick the notification text.
/// Payload `data`: {type: chat|application|accepted|rejected|removed|left|invite,
/// chatId?, gameId?}.
class PushService {
  PushService._();
  static final instance = PushService._();

  final _messaging = FirebaseMessaging.instance;
  String? _uid;
  UserProfile? _profile;
  String? _token;
  final _subs = <StreamSubscription<dynamic>>[];

  DocumentReference<Map<String, dynamic>> _tokenRef(String uid, String token) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('tokens').doc(token);

  /// Called whenever the home screen is shown; cheap to call repeatedly.
  Future<void> start(String uid, UserProfile profile, String languageCode) async {
    _profile = profile;
    if (_uid == uid) return;
    _uid = uid;
    try {
      await _messaging.requestPermission();
      final token = await _messaging.getToken();
      if (token != null) await _saveToken(uid, token, languageCode);
      _subs.add(_messaging.onTokenRefresh.listen((t) => _saveToken(uid, t, languageCode)));
      _subs.add(FirebaseMessaging.onMessage.listen(_showInApp));
      _subs.add(FirebaseMessaging.onMessageOpenedApp.listen((m) => _open(m.data)));
      final initial = await _messaging.getInitialMessage();
      if (initial != null) _open(initial.data);
    } catch (e) {
      debugPrint('Push setup error: $e');
    }
  }

  Future<void> _saveToken(String uid, String token, String languageCode) async {
    _token = token;
    await _tokenRef(uid, token).set({
      'lang': languageCode == 'en' ? 'en' : 'tr',
      'platform': 'android',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Unregisters this device; call while still signed in.
  Future<void> stop() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    final uid = _uid, token = _token;
    _uid = null;
    _token = null;
    _profile = null;
    try {
      if (uid != null && token != null) await _tokenRef(uid, token).delete();
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('Push stop error: $e');
    }
  }

  /// Android doesn't show notifications while the app is in the foreground,
  /// so show a snack bar instead.
  void _showInApp(RemoteMessage m) {
    final n = m.notification;
    final context = navigatorKey.currentContext;
    if (n == null || context == null) return;
    final l10n = AppLocalizations.of(context);
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text([n.title, n.body].whereType<String>().join('\n')),
      action: SnackBarAction(label: l10n.open, onPressed: () => _open(m.data)),
    ));
  }

  void _open(Map<String, dynamic> data) {
    final uid = _uid, profile = _profile, nav = navigatorKey.currentState;
    if (uid == null || profile == null || nav == null) return;
    final chatId = data['chatId'] as String?;
    final gameId = data['gameId'] as String?;
    if (data['type'] == 'chat' && chatId != null) {
      nav.push(MaterialPageRoute(builder: (_) => ChatScreen(chatId: chatId, uid: uid)));
    } else if (gameId != null) {
      nav.push(MaterialPageRoute(builder: (_) => GameDetailScreen(gameId: gameId, uid: uid, profile: profile)));
    }
  }
}
