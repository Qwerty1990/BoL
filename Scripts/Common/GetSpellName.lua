-- LoL Patch: 5.14
-- Developer: PvPSuite (http://forum.botoflegends.com/user/76516-pvpsuite/)

local sVersion = '1.1';
local rVersion = GetWebResult('raw.githubusercontent.com', '/pvpsuite/BoL/master/Versions/Scripts/Common/GetSpellName.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[GetSpellName]</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/pvpsuite/BoL/master/Scripts/Common/GetSpellName.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[GetSpellName]</b> </font><font color="#00FF00">Script successfully updated, please double-press F9 to reload!</font>');
		end);
		return;
	end;
else
	print('<font color="#FF1493"><b>[GetSpellName]</b> </font><font color="#FF0000">Update Error</font>');
end;


local spellNames = {
	['aatrox'] = {
		['p'] = 'Blood Well',
		['q'] = 'Dark Flight',
		['w'] = 'Blood Thirst',
		['e'] = 'Blades of Torment',
		['r'] = 'Massacre',
		['w2'] = 'Blood Price',
	},
	['ahri'] = {
		['p'] = 'Essence Theft',
		['q'] = 'Orb of Deception',
		['w'] = 'Fox-Fire',
		['e'] = 'Charm',
		['r'] = 'Spirit Rush',
	},
	['akali'] = {
		['p'] = 'Twin Disciplines',
		['q'] = 'Mark of the Assassin',
		['w'] = 'Twilight Shroud',
		['e'] = 'Crescent Slash',
		['r'] = 'Shadow Dance',
	},
	['alistar'] = {
		['p'] = 'Trample',
		['q'] = 'Pulverize',
		['w'] = 'Headbutt',
		['e'] = 'Triumphant Roar',
		['r'] = 'Unbreakable Will',
	},
	['amumu'] = {
		['p'] = 'Cursed Touch',
		['q'] = 'Bandage Toss',
		['w'] = 'Despair',
		['e'] = 'Tantrum',
		['r'] = 'Curse of the Sad Mummy',
	},
	['anivia'] = {
		['p'] = 'Rebirth',
		['q'] = 'Flash Frost',
		['w'] = 'Crystallize',
		['e'] = 'Frostbite',
		['r'] = 'Glacial Storm',
	},
	['annie'] = {
		['p'] = 'Pyromania',
		['q'] = 'Disintegrate',
		['w'] = 'Incinerate',
		['e'] = 'Molten Shield',
		['r'] = 'Summon: Tibbers',
	},
	['ashe'] = {
		['p'] = 'Frost Shot',
		['q'] = 'Ranger\'s Focus',
		['w'] = 'Volley',
		['e'] = 'Hawkshot',
		['r'] = 'Enchanted Crystal Arrow',
	},
	['azir'] = {
		['p'] = 'Shurima\'s Legacy',
		['q'] = 'Conquering Sands',
		['w'] = 'Arise!',
		['e'] = 'Shifting Sands',
		['r'] = 'Emperor\'s Divide',
	},
	['bard'] = {
		['p'] = 'Traveler\'s Call',
		['q'] = 'Cosmic Binding',
		['w'] = 'Caretaker\'s Shrine',
		['e'] = 'Magical Journey',
		['r'] = 'Tempered Fate',
	},
	['blitzcrank'] = {
		['p'] = 'Mana Barrier',
		['q'] = 'Rocket Grab',
		['w'] = 'Overdrive',
		['e'] = 'Power Fist',
		['r'] = 'Static Field',
	},
	['brand'] = {
		['p'] = 'Blaze',
		['q'] = 'Sear',
		['w'] = 'Pillar of Flame',
		['e'] = 'Conflagration',
		['r'] = 'Pyroclasm',
	},
	['braum'] = {
		['p'] = 'Concussive Blows',
		['q'] = 'Winter\'s Bite',
		['w'] = 'Stand Behind Me',
		['e'] = 'Unbreakable',
		['r'] = 'Glacial Fissure',
	},
	['caitlyn'] = {
		['p'] = 'Headshot',
		['q'] = 'Piltover Peacemaker',
		['w'] = 'Yordle Snap Trap',
		['e'] = '90 Caliber Net',
		['r'] = 'Ace in the Hole',
	},
	['cassiopeia'] = {
		['p'] = 'Aspect of the Serpent',
		['q'] = 'Noxious Blast',
		['w'] = 'Miasma',
		['e'] = 'Twin Fang',
		['r'] = 'Petrifying Gaze',
	},
	['chogath'] = {
		['p'] = 'Carnivore',
		['q'] = 'Rupture',
		['w'] = 'Feral Scream',
		['e'] = 'Vorpal Spikes',
		['r'] = 'Feast',
	},
	['corki'] = {
		['p'] = 'Hextech Shrapnel Shells',
		['q'] = 'Phosphorus Bomb',
		['w'] = 'Valkyrie',
		['e'] = 'Gatling Gun',
		['r'] = 'Missile Barrage',
	},
	['darius'] = {
		['p'] = 'Hemorrhage',
		['q'] = 'Decimate',
		['w'] = 'Crippling Strike',
		['e'] = 'Apprehend',
		['r'] = 'Noxian Guillotine',
	},
	['diana'] = {
		['p'] = 'Moonsilver Blade',
		['q'] = 'Crescent Strike',
		['w'] = 'Pale Cascade',
		['e'] = 'Moonfall',
		['r'] = 'Lunar Rush',
	},
	['draven'] = {
		['p'] = 'League of Draven',
		['q'] = 'Spinning Axe',
		['w'] = 'Blood Rush',
		['e'] = 'Stand Aside',
		['r'] = 'Whirling Death',
	},
	['drmundo'] = {
		['p'] = 'Adrenaline Rush',
		['q'] = 'Infected Cleaver',
		['w'] = 'Burning Agony',
		['e'] = 'Masochism',
		['r'] = 'Sadism',
	},
	['ekko'] = {
		['p'] = 'Z-Drive Resonance',
		['q'] = 'Timewinder',
		['w'] = 'Parallel Convergence',
		['e'] = 'Phase Dive',
		['r'] = 'Chronobreak',
	},
	['elise'] = {
		['p'] = 'Spider Queen',
		['q'] = 'Neurotoxin',
		['w'] = 'Volatile Spiderling',
		['e'] = 'Cocoon',
		['r'] = 'Spider Form',
		['q2'] = 'Venomous Bite',
		['w2'] = 'Skittering Frenzy',
		['e2'] = 'Rappel',
	},
	['evelynn'] = {
		['p'] = 'Shadow Walk',
		['q'] = 'Hate Spike',
		['w'] = 'Dark Frenzy',
		['e'] = 'Ravage',
		['r'] = 'Agony\'s Embrace',
	},
	['ezreal'] = {
		['p'] = 'Rising Spell Force',
		['q'] = 'Mystic Shot',
		['w'] = 'Essence Flux',
		['e'] = 'Arcane Shift',
		['r'] = 'Trueshot Barrage',
	},
	['fiddlesticks'] = {
		['p'] = 'Dread',
		['q'] = 'Terrify',
		['w'] = 'Drain',
		['e'] = 'Dark Wind',
		['r'] = 'Crowstorm',
	},
	['fiora'] = {
		['p'] = 'Duelist',
		['q'] = 'Lunge',
		['w'] = 'Riposte',
		['e'] = 'Burst of Speed',
		['r'] = 'Blade Waltz',
	},
	['fizz'] = {
		['p'] = 'Nimble Fighter',
		['q'] = 'Urchin Strike',
		['w'] = 'Seastone Trident',
		['e'] = 'Playful',
		['r'] = 'Chum the Waters',
		['e2'] = 'Trickster',
	},
	['galio'] = {
		['p'] = 'Runic Skin',
		['q'] = 'Resolute Smite',
		['w'] = 'Bulwark',
		['e'] = 'Righteous Gust',
		['r'] = 'Idol of Durand',
	},
	['gangplank'] = {
		['p'] = 'Trial by Fire',
		['q'] = 'Parrrley',
		['w'] = 'Remove Scurvy',
		['e'] = 'Powder Keg',
		['r'] = 'Cannon Barrage',
	},
	['garen'] = {
		['p'] = 'Perseverance',
		['q'] = 'Decisive Strike',
		['w'] = 'Courage',
		['e'] = 'Judgment',
		['r'] = 'Demacian Justice',
	},
	['gnar'] = {
		['p'] = 'Rage Gene',
		['q'] = 'Boomerang Throw',
		['w'] = 'Hyper',
		['e'] = 'Hop',
		['r'] = 'GNAR!',
		['q2'] = 'Boulder Toss',
		['w2'] = 'Wallop',
		['e2'] = 'Crunch',
	},
	['gragas'] = {
		['p'] = 'Happy Hour',
		['q'] = 'Barrel Roll',
		['w'] = 'Drunken Rage',
		['e'] = 'Body Slam',
		['r'] = 'Explosive Cask',
	},
	['graves'] = {
		['p'] = 'True Grit',
		['q'] = 'Buckshot',
		['w'] = 'Smoke Screen',
		['e'] = 'Quickdraw',
		['r'] = 'Collateral Damage',
	},
	['hecarim'] = {
		['p'] = 'Warpath',
		['q'] = 'Rampage',
		['w'] = 'Spirit of Dread',
		['e'] = 'Devastating Charge',
		['r'] = 'Onslaught of Shadows',
	},
	['heimerdinger'] = {
		['p'] = 'Techmaturgical Repair Bots',
		['q'] = 'H-28G Evolution Turret',
		['w'] = 'Hextech Micro-Rockets',
		['e'] = 'CH-2 Electron Storm Grenade',
		['r'] = 'UPGRADE!!!',
	},
	['irelia'] = {
		['p'] = 'Ionian Fervor',
		['q'] = 'Bladesurge',
		['w'] = 'Hiten Style',
		['e'] = 'Equilibrium Strike',
		['r'] = 'Transcendent Blades',
	},
	['janna'] = {
		['p'] = 'Tailwind',
		['q'] = 'Howling Gale',
		['w'] = 'Zephyr',
		['e'] = 'Eye Of The Storm',
		['r'] = 'Monsoon',
	},
	['jarvaniv'] = {
		['p'] = 'Martial Cadence',
		['q'] = 'Dragon Strike',
		['w'] = 'Golden Aegis',
		['e'] = 'Demacian Standard',
		['r'] = 'Cataclysm',
	},
	['jax'] = {
		['p'] = 'Relentless Assault',
		['q'] = 'Leap Strike',
		['w'] = 'Empower',
		['e'] = 'Counter Strike',
		['r'] = 'Grandmaster\'s Might',
	},
	['jayce'] = {
		['p'] = 'Hextech Capacitor',
		['q'] = 'To the Skies!',
		['w'] = 'Lightning Field',
		['e'] = 'Thundering Blow',
		['r'] = 'Mercury Cannon',
		['q2'] = 'Shock Blast',
		['w2'] = 'Hyper Charge',
		['e2'] = 'Acceleration Gate',
		['r2'] = 'Mercury Hammer',
	},
	['jinx'] = {
		['p'] = 'Get Excited!',
		['q'] = 'Switcheroo!',
		['w'] = 'Zap!',
		['e'] = 'Flame Chompers!',
		['r'] = 'Super Mega Death Rocket!',
	},
	['kalista'] = {
		['p'] = 'Martial Poise',
		['q'] = 'Pierce',
		['w'] = 'Sentinel',
		['e'] = 'Rend',
		['r'] = 'Fate\'s Call',
	},
	['karma'] = {
		['p'] = 'Gathering Fire',
		['q'] = 'Inner Flame',
		['w'] = 'Focused Resolve',
		['e'] = 'Inspire',
		['r'] = 'Mantra',
	},
	['karthus'] = {
		['p'] = 'Death Defied',
		['q'] = 'Lay Waste',
		['w'] = 'Wall of Pain',
		['e'] = 'Defile',
		['r'] = 'Requiem',
	},
	['kassadin'] = {
		['p'] = 'Void Stone',
		['q'] = 'Null Sphere',
		['w'] = 'Nether Blade',
		['e'] = 'Force Pulse',
		['r'] = 'Riftwalk',
	},
	['katarina'] = {
		['p'] = 'Voracity',
		['q'] = 'Bouncing Blades',
		['w'] = 'Sinister Steel',
		['e'] = 'Shunpo',
		['r'] = 'Death Lotus',
	},
	['kayle'] = {
		['p'] = 'Holy Fervor',
		['q'] = 'Reckoning',
		['w'] = 'Divine Blessing',
		['e'] = 'Righteous Fury',
		['r'] = 'Intervention',
	},
	['kennen'] = {
		['p'] = 'Mark of the Storm',
		['q'] = 'Thundering Shuriken',
		['w'] = 'Electrical Surge',
		['e'] = 'Lightning Rush',
		['r'] = 'Slicing Maelstrom',
	},
	['khazix'] = {
		['p'] = 'Unseen Threat',
		['q'] = 'Taste Their Fear',
		['w'] = 'Void Spike',
		['e'] = 'Leap',
		['r'] = 'Void Assault',
	},
	['kogmaw'] = {
		['p'] = 'Icathian Surprise',
		['q'] = 'Caustic Spittle',
		['w'] = 'Bio-Arcane Barrage',
		['e'] = 'Void Ooze',
		['r'] = 'Living Artillery',
	},
	['leblanc'] = {
		['p'] = 'Mirror Image',
		['q'] = 'Sigil of Malice',
		['w'] = 'Distortion',
		['e'] = 'Ethereal Chains',
		['r'] = 'Mimic',
	},
	['leesin'] = {
		['p'] = 'Flurry',
		['q'] = 'Sonic Wave',
		['w'] = 'Safeguard',
		['e'] = 'Tempest',
		['r'] = 'Dragon\'s Rage',
		['q2'] = 'Resonating Strike',
		['w2'] = 'Iron Will',
		['e2'] = 'Cripple',
	},
	['leona'] = {
		['p'] = 'Sunlight',
		['q'] = 'Shield of Daybreak',
		['w'] = 'Eclipse',
		['e'] = 'Zenith Blade',
		['r'] = 'Solar Flare',
	},
	['lissandra'] = {
		['p'] = 'Iceborn',
		['q'] = 'Ice Shard',
		['w'] = 'Ring of Frost',
		['e'] = 'Glacial Path',
		['r'] = 'Frozen Tomb',
	},
	['lucian'] = {
		['p'] = 'Lightslinger',
		['q'] = 'Piercing Light',
		['w'] = 'Ardent Blaze',
		['e'] = 'Relentless Pursuit',
		['r'] = 'The Culling',
	},
	['lulu'] = {
		['p'] = 'Pix, Faerie Companion',
		['q'] = 'Glitterlance',
		['w'] = 'Whimsy',
		['e'] = 'Help, Pix!',
		['r'] = 'Wild Growth',
	},
	['lux'] = {
		['p'] = 'Illumination',
		['q'] = 'Light Binding',
		['w'] = 'Prismatic Barrier',
		['e'] = 'Lucent Singularity',
		['r'] = 'Final Spark',
	},
	['malphite'] = {
		['p'] = 'Granite Shield',
		['q'] = 'Seismic Shard',
		['w'] = 'Brutal Strikes',
		['e'] = 'Ground Slam',
		['r'] = 'Unstoppable Force',
	},
	['malzahar'] = {
		['p'] = 'Summon Voidling',
		['q'] = 'Call of the Void',
		['w'] = 'Null Zone',
		['e'] = 'Malefic Visions',
		['r'] = 'Nether Grasp',
	},
	['maokai'] = {
		['p'] = 'Sap Magic',
		['q'] = 'Arcane Smash',
		['w'] = 'Twisted Advance',
		['e'] = 'Sapling Toss',
		['r'] = 'Vengeful Maelstrom',
	},
	['masteryi'] = {
		['p'] = 'Double Strike',
		['q'] = 'Alpha Strike',
		['w'] = 'Meditate',
		['e'] = 'Wuju Style',
		['r'] = 'Highlander',
	},
	['missfortune'] = {
		['p'] = 'Strut',
		['q'] = 'Double Up',
		['w'] = 'Impure Shots',
		['e'] = 'Make It Rain',
		['r'] = 'Bullet Time',
	},
	['monkeyking'] = {
		['p'] = 'Stone Skin',
		['q'] = 'Crushing Blow',
		['w'] = 'Decoy',
		['e'] = 'Nimbus Strike',
		['r'] = 'Cyclone',
	},
	['mordekaiser'] = {
		['p'] = 'Iron Man',
		['q'] = 'Mace of Spades',
		['w'] = 'Creeping Death',
		['e'] = 'Siphon of Destruction',
		['r'] = 'Children of the Grave',
	},
	['morgana'] = {
		['p'] = 'Soul Siphon',
		['q'] = 'Dark Binding',
		['w'] = 'Tormented Soil',
		['e'] = 'Black Shield',
		['r'] = 'Soul Shackles',
	},
	['nami'] = {
		['p'] = 'Surging Tides',
		['q'] = 'Aqua Prison',
		['w'] = 'Ebb and Flow',
		['e'] = 'Tidecaller\'s Blessing',
		['r'] = 'Tidal Wave',
	},
	['nasus'] = {
		['p'] = 'Soul Eater',
		['q'] = 'Siphoning Strike',
		['w'] = 'Wither',
		['e'] = 'Spirit Fire',
		['r'] = 'Fury of the Sands',
	},
	['nautilus'] = {
		['p'] = 'Staggering Blow',
		['q'] = 'Dredge Line',
		['w'] = 'Titan\'s Wrath',
		['e'] = 'Riptide',
		['r'] = 'Depth Charge',
	},
	['nidalee'] = {
		['p'] = 'Prowl',
		['q'] = 'Javelin Toss',
		['w'] = 'Bushwhack',
		['e'] = 'Primal Surge',
		['r'] = 'Aspect Of The Cougar',
		['q2'] = 'Takedown',
		['w2'] = 'Pounce',
		['e2'] = 'Swipe',
	},
	['nocturne'] = {
		['p'] = 'Umbra Blades',
		['q'] = 'Duskbringer',
		['w'] = 'Shroud of Darkness',
		['e'] = 'Unspeakable Horror',
		['r'] = 'Paranoia',
	},
	['nunu'] = {
		['p'] = 'Visionary',
		['q'] = 'Consume',
		['w'] = 'Blood Boil',
		['e'] = 'Ice Blast',
		['r'] = 'Absolute Zero',
	},
	['olaf'] = {
		['p'] = 'Berserker Rage',
		['q'] = 'Undertow',
		['w'] = 'Vicious Strikes',
		['e'] = 'Reckless Swing',
		['r'] = 'Ragnarok',
	},
	['orianna'] = {
		['p'] = 'Clockwork Windup',
		['q'] = 'Command: Attack',
		['w'] = 'Command: Dissonance',
		['e'] = 'Command: Protect',
		['r'] = 'Command: Shockwave',
	},
	['pantheon'] = {
		['p'] = 'Aegis Protection',
		['q'] = 'Spear Shot',
		['w'] = 'Aegis of Zeonia',
		['e'] = 'Heartseeker Strike',
		['r'] = 'Grand Skyfall',
	},
	['poppy'] = {
		['p'] = 'Valiant Fighter',
		['q'] = 'Devastating Blow',
		['w'] = 'Paragon of Demacia',
		['e'] = 'Heroic Charge',
		['r'] = 'Diplomatic Immunity',
	},
	['quinn'] = {
		['p'] = 'Harrier',
		['q'] = 'Blinding Assault',
		['w'] = 'Heightened Senses',
		['e'] = 'Vault',
		['r'] = 'Tag Team',
	},
	['rammus'] = {
		['p'] = 'Spiked Shell',
		['q'] = 'Powerball',
		['w'] = 'Defensive Ball Curl',
		['e'] = 'Puncturing Taunt',
		['r'] = 'Tremors',
	},
	['reksai'] = {
		['p'] = 'Fury of the Xer\'Sai',
		['q'] = 'Queen\'s Wrath',
		['w'] = 'Burrow',
		['e'] = 'Furious Bite',
		['r'] = 'Void Rush',
		['q2'] = 'Prey Seeker',
		['w2'] = 'Un-burrow',
		['e2'] = 'Tunnel',
	},
	['renekton'] = {
		['p'] = 'Reign of Anger',
		['q'] = 'Cull the Meek',
		['w'] = 'Ruthless Predator',
		['e'] = 'Slice and Dice',
		['r'] = 'Dominus',
	},
	['rengar'] = {
		['p'] = 'Unseen Predator',
		['q'] = 'Savagery',
		['w'] = 'Battle Roar',
		['e'] = 'Bola Strike',
		['r'] = 'Thrill of the Hunt',
	},
	['riven'] = {
		['p'] = 'Runic Blade',
		['q'] = 'Broken Wings',
		['w'] = 'Ki Burst',
		['e'] = 'Valor',
		['r'] = 'Blade of the Exile',
	},
	['rumble'] = {
		['p'] = 'Junkyard Titan',
		['q'] = 'Flamespitter',
		['w'] = 'Scrap Shield',
		['e'] = 'Electro Harpoon',
		['r'] = 'The Equalizer',
	},
	['ryze'] = {
		['p'] = 'Arcane Mastery',
		['q'] = 'Overload',
		['w'] = 'Rune Prison',
		['e'] = 'Spell Flux',
		['r'] = 'Desperate Power',
	},
	['sejuani'] = {
		['p'] = 'Frost',
		['q'] = 'Arctic Assault',
		['w'] = 'Flail of the Northern Winds',
		['e'] = 'Permafrost',
		['r'] = 'Glacial Prison',
	},
	['shaco'] = {
		['p'] = 'Backstab',
		['q'] = 'Deceive',
		['w'] = 'Jack In The Box',
		['e'] = 'Two-Shiv Poison',
		['r'] = 'Hallucinate',
	},
	['shen'] = {
		['p'] = 'Ki Strike',
		['q'] = 'Vorpal Blade',
		['w'] = 'Feint',
		['e'] = 'Shadow Dash',
		['r'] = 'Stand United',
	},
	['shyvana'] = {
		['p'] = 'Dragonborn',
		['q'] = 'Twin Bite',
		['w'] = 'Burnout',
		['e'] = 'Flame Breath',
		['r'] = 'Dragon\'s Descent',
	},
	['singed'] = {
		['p'] = 'Empowered Bulwark',
		['q'] = 'Poison Trail',
		['w'] = 'Mega Adhesive',
		['e'] = 'Fling',
		['r'] = 'Insanity Potion',
	},
	['sion'] = {
		['p'] = 'Glory in Death',
		['q'] = 'Decimating Smash',
		['w'] = 'Soul Furnace',
		['e'] = 'Roar of the Slayer',
		['r'] = 'Unstoppable Onslaught',
	},
	['sivir'] = {
		['p'] = 'Fleet of Foot',
		['q'] = 'Boomerang Blade',
		['w'] = 'Ricochet',
		['e'] = 'Spell Shield',
		['r'] = 'On The Hunt',
	},
	['skarner'] = {
		['p'] = 'Crystallizing Sting',
		['q'] = 'Crystal Slash',
		['w'] = 'Crystalline Exoskeleton',
		['e'] = 'Fracture',
		['r'] = 'Impale',
	},
	['sona'] = {
		['p'] = 'Power Chord',
		['q'] = 'Hymn of Valor',
		['w'] = 'Aria of Perseverance',
		['e'] = 'Song of Celerity',
		['r'] = 'Crescendo',
	},
	['soraka'] = {
		['p'] = 'Salvation',
		['q'] = 'Starcall',
		['w'] = 'Astral Infusion',
		['e'] = 'Equinox',
		['r'] = 'Wish',
	},
	['swain'] = {
		['p'] = 'Carrion Renewal',
		['q'] = 'Decrepify',
		['w'] = 'Nevermove',
		['e'] = 'Torment',
		['r'] = 'Ravenous Flock',
	},
	['syndra'] = {
		['p'] = 'Transcendent',
		['q'] = 'Dark Sphere',
		['w'] = 'Force of Will',
		['e'] = 'Scatter the Weak',
		['r'] = 'Unleashed Power',
	},
	['tahmkench'] = {
		['p'] = 'An Acquired Taste',
		['q'] = 'Tongue Lash',
		['w'] = 'Devour',
		['e'] = 'Thick Skin',
		['r'] = 'Abyssal Voyage',
	},
	['talon'] = {
		['p'] = 'Mercy',
		['q'] = 'Noxian Diplomacy',
		['w'] = 'Rake',
		['e'] = 'Cutthroat',
		['r'] = 'Shadow Assault',
	},
	['taric'] = {
		['p'] = 'Gemcraft',
		['q'] = 'Imbue',
		['w'] = 'Shatter',
		['e'] = 'Dazzle',
		['r'] = 'Radiance',
	},
	['teemo'] = {
		['p'] = 'Camouflage',
		['q'] = 'Blinding Dart',
		['w'] = 'Move Quick',
		['e'] = 'Toxic Shot',
		['r'] = 'Noxious Trap',
	},
	['thresh'] = {
		['p'] = 'Damnation',
		['q'] = 'Death Sentence',
		['w'] = 'Dark Passage',
		['e'] = 'Flay',
		['r'] = 'The Box',
	},
	['tristana'] = {
		['p'] = 'Draw a Bead',
		['q'] = 'Rapid Fire',
		['w'] = 'Rocket Jump',
		['e'] = 'Explosive Charge',
		['r'] = 'Buster Shot',
	},
	['trundle'] = {
		['p'] = 'King\'s Tribute',
		['q'] = 'Chomp',
		['w'] = 'Frozen Domain',
		['e'] = 'Pillar of Ice',
		['r'] = 'Subjugate',
	},
	['tryndamere'] = {
		['p'] = 'Battle Fury',
		['q'] = 'Bloodlust',
		['w'] = 'Mocking Shout',
		['e'] = 'Spinning Slash',
		['r'] = 'Undying Rage',
	},
	['twistedfate'] = {
		['p'] = 'Loaded Dice',
		['q'] = 'Wild Cards',
		['w'] = 'Pick A Card',
		['e'] = 'Stacked Deck',
		['r'] = 'Destiny',
	},
	['twitch'] = {
		['p'] = 'Deadly Venom',
		['q'] = 'Ambush',
		['w'] = 'Venom Cask',
		['e'] = 'Contaminate',
		['r'] = 'Rat-Ta-Tat-Tat',
	},
	['udyr'] = {
		['p'] = 'Monkey\'s Agility',
		['q'] = 'Tiger Stance',
		['w'] = 'Turtle Stance',
		['e'] = 'Bear Stance',
		['r'] = 'Phoenix Stance',
	},
	['urgot'] = {
		['p'] = 'Zaun-Touched Bolt Augmenter',
		['q'] = 'Acid Hunter',
		['w'] = 'Terror Capacitor',
		['e'] = 'Noxian Corrosive Charge',
		['r'] = 'Hyper-Kinetic Position Reverser',
	},
	['varus'] = {
		['p'] = 'Living Vengeance',
		['q'] = 'Piercing Arrow',
		['w'] = 'Blighted Quiver',
		['e'] = 'Hail of Arrows',
		['r'] = 'Chain of Corruption',
	},
	['vayne'] = {
		['p'] = 'Night Hunter',
		['q'] = 'Tumble',
		['w'] = 'Silver Bolts',
		['e'] = 'Condemn',
		['r'] = 'Final Hour',
	},
	['veigar'] = {
		['p'] = 'Equilibrium',
		['q'] = 'Baleful Strike',
		['w'] = 'Dark Matter',
		['e'] = 'Event Horizon',
		['r'] = 'Primordial Burst',
	},
	['velkoz'] = {
		['p'] = 'Organic Deconstruction',
		['q'] = 'Plasma Fission',
		['w'] = 'Void Rift',
		['e'] = 'Tectonic Disruption',
		['r'] = 'Life Form Disintegration Ray',
	},
	['vi'] = {
		['p'] = 'Blast Shield',
		['q'] = 'Vault Breaker',
		['w'] = 'Denting Blows',
		['e'] = 'Excessive Force',
		['r'] = 'Assault and Battery',
	},
	['viktor'] = {
		['p'] = 'Glorious Evolution',
		['q'] = 'Siphon Power',
		['w'] = 'Gravity Field',
		['e'] = 'Death Ray',
		['r'] = 'Chaos Storm',
	},
	['vladimir'] = {
		['p'] = 'Crimson Pact',
		['q'] = 'Transfusion',
		['w'] = 'Sanguine Pool',
		['e'] = 'Tides of Blood',
		['r'] = 'Hemoplague',
	},
	['volibear'] = {
		['p'] = 'Chosen of the Storm',
		['q'] = 'Rolling Thunder',
		['w'] = 'Frenzy',
		['e'] = 'Majestic Roar',
		['r'] = 'Thunder Claws',
	},
	['warwick'] = {
		['p'] = 'Eternal Thirst',
		['q'] = 'Hungering Strike',
		['w'] = 'Hunters Call',
		['e'] = 'Blood Scent',
		['r'] = 'Infinite Duress',
	},
	['xerath'] = {
		['p'] = 'Mana Surge',
		['q'] = 'Arcanopulse',
		['w'] = 'Eye of Destruction',
		['e'] = 'Shocking Orb',
		['r'] = 'Rite of the Arcane',
	},
	['xinzhao'] = {
		['p'] = 'Challenge',
		['q'] = 'Three Talon Strike',
		['w'] = 'Battle Cry',
		['e'] = 'Audacious Charge',
		['r'] = 'Crescent Sweep',
	},
	['yasuo'] = {
		['p'] = 'Way of the Wanderer',
		['q'] = 'Steel Tempest',
		['w'] = 'Wind Wall',
		['e'] = 'Sweeping Blade',
		['r'] = 'Last Breath',
	},
	['yorick'] = {
		['p'] = 'Unholy Covenant',
		['q'] = 'Omen of War',
		['w'] = 'Omen of Pestilence',
		['e'] = 'Omen of Famine',
		['r'] = 'Omen of Death',
	},
	['zac'] = {
		['p'] = 'Cell Division',
		['q'] = 'Stretching Strike',
		['w'] = 'Unstable Matter',
		['e'] = 'Elastic Slingshot',
		['r'] = 'Let\'s Bounce!',
	},
	['zed'] = {
		['p'] = 'Contempt for the Weak',
		['q'] = 'Razor Shuriken',
		['w'] = 'Living Shadow',
		['e'] = 'Shadow Slash',
		['r'] = 'Death Mark',
	},
	['ziggs'] = {
		['p'] = 'Short Fuse',
		['q'] = 'Bouncing Bomb',
		['w'] = 'Satchel Charge',
		['e'] = 'Hexplosive Minefield',
		['r'] = 'Mega Inferno Bomb',
	},
	['zilean'] = {
		['p'] = 'Heightened Learning',
		['q'] = 'Time Bomb',
		['w'] = 'Rewind',
		['e'] = 'Time Warp',
		['r'] = 'Chronoshift',
	},
	['zyra'] = {
		['p'] = 'Rise of the Thorns',
		['q'] = 'Deadly Bloom',
		['w'] = 'Rampant Growth',
		['e'] = 'Grasping Roots',
		['r'] = 'Stranglethorns',
	},
};

function GetSpellName(charName, whatSpell)
	if (spellNames[charName:lower()] == nil) then
		print('[GetSpellName] Champion Not Found (' .. charName:lower() .. ')');
	elseif (spellNames[charName:lower()][whatSpell:lower()] == nil) then
		print('[GetSpellName] Spell Not Found (' .. whatSpell:lower() .. ', ' .. charName:lower() .. ')');
	else
		return spellNames[charName:lower()][whatSpell:lower()];
	end;
	
	return nil;
end;
