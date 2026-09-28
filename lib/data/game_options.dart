// Fixed option lists. The IDs are stored in Firestore — never rename them;
// only the display names may change.

const roleIds = ['player', 'dm'];

const platformIds = ['in_person', 'discord', 'roll20', 'foundry', 'zoom', 'other'];

/// Platform brand names; 'in_person' and 'other' are localized in the UI.
const platformBrandNames = {
  'discord': 'Discord',
  'roll20': 'Roll20',
  'foundry': 'Foundry VTT',
  'zoom': 'Zoom',
};

/// Game systems (id -> display name), in display order: D&D family newest
/// first, then the rest alphabetically. 'other' is localized in the UI.
const gameSystems = {
  'dnd5e_2024': 'D&D 5e (2024)',
  'dnd5e_2014': 'D&D 5e (2014)',
  'dnd4e': 'D&D 4e',
  'dnd35': 'D&D 3.5',
  'dnd3e': 'D&D 3e',
  'add2e': 'AD&D 2e',
  'add1e': 'AD&D 1e',
  'dnd_basic': 'D&D Basic / BECMI',
  'odnd': 'OD&D (1974)',
  'blades': 'Blades in the Dark',
  'coc': 'Call of Cthulhu',
  'cyberpunk_red': 'Cyberpunk RED',
  'daggerheart': 'Daggerheart',
  'fallout': 'Fallout: The Roleplaying Game',
  'fate_condensed': 'Fate Condensed',
  'fate_core': 'Fate Core',
  'gurps': 'GURPS',
  'kult': 'KULT: Divinity Lost',
  'mordheim': 'Mordheim',
  'mork_borg': 'Mörk Borg',
  'osr': 'OSR',
  'pathfinder1e': 'Pathfinder 1e',
  'pathfinder2e': 'Pathfinder 2e',
  'savage_worlds': 'Savage Worlds',
  'shadowrun': 'Shadowrun',
  'starfinder': 'Starfinder',
  'vtm': 'Vampire: The Masquerade',
  'wfrp': 'Warhammer Fantasy Roleplay',
  'wow_rpg': 'World of Warcraft RPG',
  'other': 'other',
};
