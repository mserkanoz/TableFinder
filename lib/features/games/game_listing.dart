import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/locations.dart';

/// A DM's game listing, stored at `games/{id}`. Everything here is public to
/// signed-in users; the contact note lives in `games/{id}/private/contact`.
class GameListing {
  const GameListing({
    this.id,
    required this.ownerUid,
    required this.ownerNickname,
    required this.title,
    required this.system,
    required this.platform,
    this.country = defaultCountry,
    this.cityCode,
    this.district,
    required this.gameType,
    this.campaignStage,
    this.frequency,
    this.sessionAt,
    required this.seatsTotal,
    required this.seatsOpen,
    required this.language,
    required this.beginnerFriendly,
    required this.paid,
    this.price,
    required this.description,
    this.status = 'open',
    this.createdAt,
  });

  final String? id;
  final String ownerUid;
  final String ownerNickname;
  final String title;
  final String system;
  final String platform;
  final String country; // TR | BG
  final int? cityCode;
  final String? district;
  final String gameType; // one_shot | campaign
  final String? campaignStage; // new | ongoing (campaigns only)
  final String? frequency; // campaigns only
  final DateTime? sessionAt; // first session, or next session if ongoing
  final int seatsTotal;
  final int seatsOpen;
  final String language;
  final bool beginnerFriendly;
  final bool paid;
  final int? price; // per player per session in [currency], when paid
  final String description;
  final String status; // open | full | closed
  final DateTime? createdAt;

  String get currency => currencyFor(country);

  bool get isOngoing => gameType == 'campaign' && campaignStage == 'ongoing';

  /// One-shots whose session time has passed no longer show up in search.
  bool get isExpired =>
      gameType == 'one_shot' && sessionAt != null && sessionAt!.isBefore(DateTime.now());

  factory GameListing.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    return GameListing(
      id: doc.id,
      ownerUid: m['ownerUid'] as String,
      ownerNickname: m['ownerNickname'] as String? ?? '',
      title: m['title'] as String? ?? '',
      system: m['system'] as String? ?? 'other',
      platform: m['platform'] as String? ?? 'other',
      country: countryOrDefault(m['country']),
      cityCode: m['cityCode'] as int?,
      district: m['district'] as String?,
      gameType: m['gameType'] as String? ?? 'one_shot',
      campaignStage: m['campaignStage'] as String?,
      frequency: m['frequency'] as String?,
      sessionAt: (m['sessionAt'] as Timestamp?)?.toDate(),
      seatsTotal: m['seatsTotal'] as int? ?? 1,
      seatsOpen: m['seatsOpen'] as int? ?? 0,
      language: m['language'] as String? ?? 'tr',
      beginnerFriendly: m['beginnerFriendly'] as bool? ?? false,
      paid: m['paid'] as bool? ?? false,
      price: m['price'] as int?,
      description: m['description'] as String? ?? '',
      status: m['status'] as String? ?? 'open',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Fields written by the client (timestamps are added by the repository).
  Map<String, dynamic> toMap() => {
        'ownerUid': ownerUid,
        'ownerNickname': ownerNickname,
        'title': title,
        'system': system,
        'platform': platform,
        'country': country,
        'cityCode': cityCode,
        'district': district,
        'gameType': gameType,
        'campaignStage': campaignStage,
        'frequency': frequency,
        'sessionAt': sessionAt == null ? null : Timestamp.fromDate(sessionAt!),
        'seatsTotal': seatsTotal,
        'seatsOpen': seatsOpen,
        'language': language,
        'beginnerFriendly': beginnerFriendly,
        'paid': paid,
        'price': price,
        'currency': currency,
        'description': description,
        'status': status,
      };
}
