import 'package:flutter/material.dart';

import '../data/game_options.dart';
import '../data/option_labels.dart';
import '../l10n/app_localizations.dart';

/// Compact multi-select for game systems: a few popular systems plus
/// "not sure yet" as chips, and the full searchable list in a bottom sheet.
/// "Not sure yet" and real systems are mutually exclusive.
class SystemsPicker extends StatelessWidget {
  const SystemsPicker({super.key, required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  static Set<String> _toggle(Set<String> current, String id, bool on) {
    if (!on) return {...current}..remove(id);
    if (id == undecidedSystem) return {undecidedSystem};
    return {...current}
      ..remove(undecidedSystem)
      ..add(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Featured chips, then any other selected systems so choices stay visible.
    final chips = [
      ...featuredSystems,
      ...selected.where((id) => !featuredSystems.contains(id) && id != undecidedSystem),
      undecidedSystem,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final id in chips)
          FilterChip(
            label: Text(systemLabel(l10n, id)),
            selected: selected.contains(id),
            onSelected: (on) => onChanged(_toggle(selected, id, on)),
          ),
        ActionChip(
          avatar: const Icon(Icons.add, size: 18),
          label: Text(l10n.allSystems(gameSystems.length)),
          onPressed: () async {
            final result = await showModalBottomSheet<Set<String>>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => _AllSystemsSheet(initial: selected),
            );
            if (result != null) onChanged(result);
          },
        ),
      ],
    );
  }
}

class _AllSystemsSheet extends StatefulWidget {
  const _AllSystemsSheet({required this.initial});

  final Set<String> initial;

  @override
  State<_AllSystemsSheet> createState() => _AllSystemsSheetState();
}

class _AllSystemsSheetState extends State<_AllSystemsSheet> {
  late Set<String> _selected = {...widget.initial};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ids = gameSystems.keys
        .where((id) => systemLabel(l10n, id).toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchSystemsHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scroll,
              children: [
                for (final id in ids)
                  CheckboxListTile(
                    title: Text(systemLabel(l10n, id)),
                    value: _selected.contains(id),
                    onChanged: (on) => setState(() => _selected = SystemsPicker._toggle(_selected, id, on ?? false)),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: Text(l10n.done),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
