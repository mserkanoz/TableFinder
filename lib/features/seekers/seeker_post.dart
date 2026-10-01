import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/locations.dart';

/// A player's "looking for group" post, stored at `seekers/{uid}_{1..3}`.
/// The fixed slot IDs cap each player at three posts.
class SeekerPost {
  const SeekerPost({
    this.id,
    required this.ownerUid,
    required this.ownerNickname,
    required this.systems,
    required this.platforms,
    this.country = defaultCountry,
    this.cityCode,
    this.district,
    required this.gameTypes,
    required this.languages,
    required this.experience,
    required this.availability,
    required this.openToPaid,
    required this.description,
    this.status = 'open',
    this.createdAt,
  });

  final String? id;
  final String ownerUid;
  final String ownerNickname;
  final Set<String> systems;
  final Set<String> platforms;
  final String country; // TR | BG
  final int? cityCode;
  final String? district;
  final Set<String> gameTypes;
  final Set<String> languages;
  final String experience; // new | some | veteran
  final String availability;
  final bool openToPaid;
  final String description;
  final String status; // open | closed
  final DateTime? createdAt;

  factory SeekerPost.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    Set<String> set(Object? v) => v is List ? v.whereType<String>().toSet() : <String>{};
    return SeekerPost(
      id: doc.id,
      ownerUid: m['ownerUid'] as String,
      ownerNickname: m['ownerNickname'] as String? ?? '',
      systems: set(m['systems']),
      platforms: set(m['platforms']),
      country: countryOrDefault(m['country']),
      cityCode: m['cityCode'] as int?,
      district: m['district'] as String?,
      gameTypes: set(m['gameTypes']),
      languages: set(m['languages']),
      experience: m['experience'] as String? ?? 'new',
      availability: m['availability'] as String? ?? '',
      openToPaid: m['openToPaid'] as bool? ?? false,
      description: m['description'] as String? ?? '',
      status: m['status'] as String? ?? 'open',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'ownerUid': ownerUid,
        'ownerNickname': ownerNickname,
        'systems': systems.toList(),
        'platforms': platforms.toList(),
        'country': country,
        'cityCode': cityCode,
        'district': district,
        'gameTypes': gameTypes.toList(),
        'languages': languages.toList(),
        'experience': experience,
        'availability': availability,
        'openToPaid': openToPaid,
        'description': description,
        'status': status,
      };
}
