import 'package:flutter/material.dart';

import '../data/locations.dart';
import '../l10n/app_localizations.dart';

/// Country + searchable province + district dropdowns. Changing the country
/// clears the province, changing the province clears the district. With
/// [anyLabel] set, the province and district lists start with an "any" entry
/// that maps to null (used by search filters).
class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
    required this.country,
    required this.cityCode,
    required this.district,
    required this.onChanged,
    this.anyLabel,
  });

  final String country;
  final int? cityCode;
  final String? district;
  final void Function(String country, int? cityCode, String? district) onChanged;
  final String? anyLabel;

  // Sentinels for the "any" entries; DropdownMenu can't tell a null value
  // apart from "nothing selected".
  static const _anyCity = 0;
  static const _anyDistrict = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final province = provinceOf(country, cityCode);
    final any = anyLabel;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: [
                for (final id in countryIds) ButtonSegment(value: id, label: Text(countryLabel(l10n, id))),
              ],
              selected: {country},
              onSelectionChanged: (s) {
                if (s.first != country) onChanged(s.first, null, null);
              },
            ),
          ),
          const SizedBox(height: 12),
          DropdownMenu<int>(
            // Rebuild when the country changes so the old province is cleared.
            key: ValueKey('city-$country'),
            width: constraints.maxWidth,
            label: Text(l10n.cityLabel),
            initialSelection: cityCode ?? (any != null ? _anyCity : null),
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: 320,
            dropdownMenuEntries: [
              if (any != null) DropdownMenuEntry(value: _anyCity, label: any),
              for (final p in provincesSortedOf(country, lang))
                DropdownMenuEntry(value: p.code, label: provinceName(p, lang)),
            ],
            onSelected: (code) {
              final newCode = code == _anyCity ? null : code;
              if (newCode != cityCode) onChanged(country, newCode, null);
            },
          ),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            // Rebuild when the province changes so the old district is cleared.
            key: ValueKey('district-$country-$cityCode'),
            width: constraints.maxWidth,
            label: Text(l10n.districtLabel),
            enabled: province != null,
            initialSelection: district ?? (any != null && province != null ? _anyDistrict : null),
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: 320,
            dropdownMenuEntries: [
              if (any != null && province != null) DropdownMenuEntry(value: _anyDistrict, label: any),
              if (province != null)
                for (final d in districtsSortedOf(province, lang))
                  DropdownMenuEntry(value: d, label: districtName(province, d, lang)),
            ],
            onSelected: (d) => onChanged(country, cityCode, d == _anyDistrict ? null : d),
          ),
        ],
      ),
    );
  }
}
