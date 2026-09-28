import 'package:flutter/material.dart';

import '../data/turkey_locations.dart';
import '../l10n/app_localizations.dart';

/// Searchable province + district dropdowns. The district resets when the
/// province changes. With [anyLabel] set, both lists start with an "any"
/// entry that maps to null (used by search filters).
class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
    required this.cityCode,
    required this.district,
    required this.onChanged,
    this.anyLabel,
  });

  final int? cityCode;
  final String? district;
  final void Function(int? cityCode, String? district) onChanged;
  final String? anyLabel;

  // Sentinels for the "any" entries; DropdownMenu can't tell a null value
  // apart from "nothing selected".
  static const _anyCity = 0;
  static const _anyDistrict = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final province = provinceByCode(cityCode);
    final any = anyLabel;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          DropdownMenu<int>(
            width: constraints.maxWidth,
            label: Text(l10n.cityLabel),
            initialSelection: cityCode ?? (any != null ? _anyCity : null),
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: 320,
            dropdownMenuEntries: [
              if (any != null) DropdownMenuEntry(value: _anyCity, label: any),
              for (final p in provincesSorted) DropdownMenuEntry(value: p.code, label: p.name),
            ],
            onSelected: (code) {
              final newCode = code == _anyCity ? null : code;
              if (newCode != cityCode) onChanged(newCode, null);
            },
          ),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            // Rebuild when the province changes so the old district is cleared.
            key: ValueKey(cityCode),
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
                for (final d in sortedDistricts(province)) DropdownMenuEntry(value: d, label: d),
            ],
            onSelected: (d) => onChanged(cityCode, d == _anyDistrict ? null : d),
          ),
        ],
      ),
    );
  }
}
