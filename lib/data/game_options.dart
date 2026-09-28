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

/// Game systems (id -> display name). 'other' is localized in the UI.
const gameSystems = {
  'dnd5e_2014': 'D&D 5e (2014)',
  'dnd5e_2024': 'D&D 5e (2024)',
  'pathfinder2e': 'Pathfinder 2e',
  'pathfinder1e': 'Pathfinder 1e',
  'starfinder': 'Starfinder',
  'coc': 'Call of Cthulhu',
  'vtm': 'Vampire: The Masquerade',
  'wfrp': 'Warhammer Fantasy Roleplay',
  'cyberpunk_red': 'Cyberpunk RED',
  'shadowrun': 'Shadowrun',
  'daggerheart': 'Daggerheart',
  'blades': 'Blades in the Dark',
  'savage_worlds': 'Savage Worlds',
  'gurps': 'GURPS',
  'osr': 'OSR',
  'mork_borg': 'Mörk Borg',
  'other': 'other',
};
