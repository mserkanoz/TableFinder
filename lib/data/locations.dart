import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import 'bulgaria_locations.dart';
import 'turkey_locations.dart';

/// Supported countries. Documents without a `country` field are Turkish
/// (they predate multi-country support).
const countryIds = ['TR', 'BG'];
const defaultCountry = 'TR';

String countryOrDefault(Object? value) => value is String && countryIds.contains(value) ? value : defaultCountry;

String countryLabel(AppLocalizations l10n, String id) => id == 'BG' ? l10n.countryBulgaria : l10n.countryTurkey;

/// Default country for a new profile, from the device language.
String countryForLanguage(String languageCode) => languageCode == 'bg' ? 'BG' : defaultCountry;

List<Province> provincesOf(String country) => country == 'BG' ? bulgarianProvinces : provinces;

Province? provinceOf(String country, int? code) {
  final list = provincesOf(country);
  if (code == null || code < 1 || code > list.length) return null;
  return list[code - 1];
}

/// Bulgarian place names are shown in Cyrillic in the Bulgarian UI.
bool _useLocal(String uiLanguage) => uiLanguage == 'bg';

String provinceName(Province p, String uiLanguage) =>
    _useLocal(uiLanguage) ? (p.localName ?? p.name) : p.name;

String districtName(Province p, String district, String uiLanguage) =>
    _useLocal(uiLanguage) ? (p.localDistricts?[district] ?? district) : district;

List<Province> provincesSortedOf(String country, String uiLanguage) =>
    [...provincesOf(country)]..sort((a, b) => compareTurkish(provinceName(a, uiLanguage), provinceName(b, uiLanguage)));

List<String> districtsSortedOf(Province p, String uiLanguage) =>
    [...p.districts]..sort((a, b) => compareTurkish(districtName(p, a, uiLanguage), districtName(p, b, uiLanguage)));

/// "Kadıköy, İstanbul" / "Младост, София (столица), България".
String placeLabel(AppLocalizations l10n, String uiLanguage, String country, int? cityCode, String? district) {
  final p = provinceOf(country, cityCode);
  if (p == null) return '';
  return [
    if (district != null) districtName(p, district, uiLanguage),
    provinceName(p, uiLanguage),
    if (country != defaultCountry) countryLabel(l10n, country),
  ].join(', ');
}

// Prices: Turkey in lira; Bulgaria in euro (since 1 Jan 2026) with the lev
// equivalent at the fixed conversion rate for people still thinking in leva.
const bgnPerEur = 1.95583;

String currencyFor(String country) => country == 'BG' ? 'EUR' : 'TRY';

String currencySymbol(String currency) => currency == 'EUR' ? '€' : '₺';

String formatPrice(int price, String currency, String locale) {
  if (currency != 'EUR') return '₺$price';
  final leva = NumberFormat('#,##0.00', locale).format(price * bgnPerEur);
  return '€$price (≈$leva лв)';
}
