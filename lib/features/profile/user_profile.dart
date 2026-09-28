/// A user's public profile, stored at `users/{uid}` in Firestore.
class UserProfile {
  const UserProfile({
    required this.nickname,
    required this.roles,
    required this.systems,
    required this.platforms,
    this.cityCode,
    this.district,
    this.bio = '',
  });

  final String nickname;
  final Set<String> roles;
  final Set<String> systems;
  final Set<String> platforms;
  final int? cityCode;
  final String? district;
  final String bio;

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        nickname: map['nickname'] as String? ?? '',
        roles: _stringSet(map['roles']),
        systems: _stringSet(map['systems']),
        platforms: _stringSet(map['platforms']),
        cityCode: map['cityCode'] as int?,
        district: map['district'] as String?,
        bio: map['bio'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'nickname': nickname,
        'roles': roles.toList(),
        'systems': systems.toList(),
        'platforms': platforms.toList(),
        'cityCode': cityCode,
        'district': district,
        'bio': bio,
      };

  static Set<String> _stringSet(Object? value) =>
      value is List ? value.whereType<String>().toSet() : <String>{};
}
