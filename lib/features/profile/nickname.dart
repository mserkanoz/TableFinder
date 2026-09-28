// Nickname rules. Keep in sync with nickKey()/validNickname() in firestore.rules.

const nicknameMinLength = 3;
const nicknameMaxLength = 24;

/// English letters/digits; single space, '_' or '.' only between them.
final _nicknamePattern = RegExp(r'^[A-Za-z0-9]+([ ._][A-Za-z0-9]+)*$');

bool isValidNickname(String nickname) =>
    nickname.length >= nicknameMinLength &&
    nickname.length <= nicknameMaxLength &&
    _nicknamePattern.hasMatch(nickname) &&
    nicknameKey(nickname).length >= nicknameMinLength;

/// Uniqueness key: case and separators are ignored, so "Ranger Leshanna",
/// "ranger_leshanna" and "RangerLeshanna" all count as the same nickname.
String nicknameKey(String nickname) =>
    nickname.toLowerCase().replaceAll(RegExp(r'[ ._]'), '');
