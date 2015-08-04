-- LoL Patch: 5.14
-- Developer: PvPSuite (http://forum.botoflegends.com/user/76516-pvpsuite/)

local sVersion = '1.1';
local rVersion = GetWebResult('raw.githubusercontent.com', '/pvpsuite/BoL/master/Versions/Scripts/p_skinChanger.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[p_skinChanger]</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/pvpsuite/BoL/master/Scripts/p_skinChanger.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[p_skinChanger]</b> </font><font color="#00FF00">Script successfully updated, please double-press F9 to reload!</font>');
		end);
		return;
	end;
else
	print('<font color="#FF1493"><b>[p_skinChanger]</b> </font><font color="#FF0000">Update Error</font>');
end;

if (not VIP_USER) then
	print('<font color="#FF1493"><b>[p_skinChanger]</b> </font><font color="#FF0000">Non-VIP Not Supported</font>');
	return;
end;

local skinNames = {
	['aatrox'] = {
		[1] = 'Aatrox',
		[2] = 'Justicar Aatrox',
		[3] = 'Mecha Aatrox',
		[4] = 'Sea Hunter Aatrox',
	},
	['ahri'] = {
		[1] = 'Ahri',
		[2] = 'Dynasty Ahri',
		[3] = 'Midnight Ahri',
		[4] = 'Foxfire Ahri',
		[5] = 'Popstar Ahri',
		[6] = 'Challenger Ahri',
	},
	['akali'] = {
		[1] = 'Akali',
		[2] = 'Stinger Akali',
		[3] = 'Crimson Akali',
		[4] = 'All-star Akali',
		[5] = 'Nurse Akali',
		[6] = 'Blood Moon Akali',
		[7] = 'Silverfang Akali',
		[8] = 'Headhunter Akali',
	},
	['alistar'] = {
		[1] = 'Alistar',
		[2] = 'Black Alistar',
		[3] = 'Golden Alistar',
		[4] = 'Matador Alistar',
		[5] = 'Longhorn Alistar',
		[6] = 'Unchained Alistar',
		[7] = 'Infernal Alistar',
		[8] = 'Sweeper Alistar',
	},
	['amumu'] = {
		[1] = 'Amumu',
		[2] = 'Pharaoh Amumu',
		[3] = 'Vancouver Amumu',
		[4] = 'Emumu',
		[5] = 'Re-Gifted Amumu',
		[6] = 'Almost-Prom King Amumu',
		[7] = 'Little Knight Amumu',
		[8] = 'Sad Robot Amumu',
		[9] = 'Surprise Party Amumu',
	},
	['anivia'] = {
		[1] = 'Anivia',
		[2] = 'Team Spirit Anivia',
		[3] = 'Bird of Prey Anivia',
		[4] = 'Noxus Hunter Anivia',
		[5] = 'Hextech Anivia',
		[6] = 'Blackfrost Anivia',
		[7] = 'Prehistoric Anivia',
	},
	['annie'] = {
		[1] = 'Annie',
		[2] = 'Goth Annie',
		[3] = 'Red Riding Annie',
		[4] = 'Annie in Wonderland',
		[5] = 'Prom Queen Annie',
		[6] = 'Frostfire Annie',
		[7] = 'Reverse Annie',
		[8] = 'FrankenTibbers Annie',
		[9] = 'Panda Annie',
		[10] = 'Sweetheart Annie',
	},
	['ashe'] = {
		[1] = 'Ashe',
		[2] = 'Freljord Ashe',
		[3] = 'Sherwood Forest Ashe',
		[4] = 'Woad Ashe',
		[5] = 'Queen Ashe',
		[6] = 'Amethyst Ashe',
		[7] = 'Heartseeker Ashe',
		[8] = 'Marauder Ashe',
	},
	['azir'] = {
		[1] = 'Azir',
		[2] = 'Galactic Azir',
	},
	['bard'] = {
		[1] = 'Bard',
		[2] = 'Elderwood Bard',
	},
	['blitzcrank'] = {
		[1] = 'Blitzcrank',
		[2] = 'Rusty Blitzcrank',
		[3] = 'Goalkeeper Blitzcrank',
		[4] = 'Boom Boom Blitzcrank',
		[5] = 'Piltover Customs Blitzcrank',
		[6] = 'Definitely Not Blitzcrank',
		[7] = 'iBlitzcrank',
		[8] = 'Riot Blitzcrank',
	},
	['brand'] = {
		[1] = 'Brand',
		[2] = 'Apocalyptic Brand',
		[3] = 'Vandal Brand',
		[4] = 'Cryocore Brand',
		[5] = 'Zombie Brand',
	},
	['braum'] = {
		[1] = 'Braum',
		[2] = 'Dragonslayer Braum',
		[3] = 'El Tigre Braum',
	},
	['caitlyn'] = {
		[1] = 'Caitlyn',
		[2] = 'Resistance Caitlyn',
		[3] = 'Sheriff Caitlyn',
		[4] = 'Safari Caitlyn',
		[5] = 'Arctic Warfare Caitlyn',
		[6] = 'Officer Caitlyn',
		[7] = 'Headhunter Caitlyn',
	},
	['cassiopeia'] = {
		[1] = 'Cassiopeia',
		[2] = 'Desperada Cassiopeia',
		[3] = 'Siren Cassiopeia',
		[4] = 'Mythic Cassiopeia',
		[5] = 'Jade Fang Cassiopeia',
	},
	['chogath'] = {
		[1] = 'Cho\'Gath',
		[2] = 'Nightmare Cho\'Gath',
		[3] = 'Gentleman Cho\'Gath',
		[4] = 'Loch Ness Cho\'Gath',
		[5] = 'Jurassic Cho\'Gath',
		[6] = 'Battlecast Prime Cho\'Gath',
		[7] = 'Prehistoric Cho\'Gath',
	},
	['corki'] = {
		[1] = 'Corki',
		[2] = 'UFO Corki',
		[3] = 'Ice Toboggan Corki',
		[4] = 'Red Baron Corki',
		[5] = 'Hot Rod Corki',
		[6] = 'Urfrider Corki',
		[7] = 'Dragonwing Corki',
		[8] = 'Fnatic Corki',
	},
	['darius'] = {
		[1] = 'Darius',
		[2] = 'Lord Darius',
		[3] = 'Bioforge Darius',
		[4] = 'Woad King Darius',
		[5] = 'Dunkmaster Darius',
	},
	['diana'] = {
		[1] = 'Diana',
		[2] = 'Dark Valkyrie Diana',
		[3] = 'Lunar Goddess Diana',
	},
	['draven'] = {
		[1] = 'Draven',
		[2] = 'Soul Reaver Draven',
		[3] = 'Gladiator Draven',
		[4] = 'Primetime Draven',
		[5] = 'Pool Party Draven',
	},
	['drmundo'] = {
		[1] = 'Dr. Mundo',
		[2] = 'Toxic Dr. Mundo',
		[3] = 'Mr. Mundoverse',
		[4] = 'Corporate Mundo',
		[5] = 'Mundo Mundo',
		[6] = 'Executioner Mundo',
		[7] = 'Rageborn Mundo',
		[8] = 'TPA Mundo',
		[9] = 'Pool Party Mundo',
	},
	['ekko'] = {
		[1] = 'Ekko',
		[2] = 'Sandstorm Ekko',
	},
	['elise'] = {
		[1] = 'Elise',
		[2] = 'Death Blossom Elise',
		[3] = 'Victorious Elise',
		[4] = 'Blood Moon Elise',
	},
	['evelynn'] = {
		[1] = 'Evelynn',
		[2] = 'Shadow Evelynn',
		[3] = 'Masquerade Evelynn',
		[4] = 'Tango Evelynn',
		[5] = 'Safecracker Evelynn',
	},
	['ezreal'] = {
		[1] = 'Ezreal',
		[2] = 'Nottingham Ezreal',
		[3] = 'Striker Ezreal',
		[4] = 'Frosted Ezreal',
		[5] = 'Explorer Ezreal',
		[6] = 'Pulsefire Ezreal',
		[7] = 'TPA Ezreal',
		[8] = 'Debonair Ezreal',
		[9] = 'Ace of Spades Ezreal',
	},
	['fiddlesticks'] = {
		[1] = 'Fiddlesticks',
		[2] = 'Spectral Fiddlesticks',
		[3] = 'Union Jack Fiddlesticks',
		[4] = 'Bandito Fiddlesticks',
		[5] = 'Pumpkinhead Fiddlesticks',
		[6] = 'Fiddle Me Timbers',
		[7] = 'Surprise Party Fiddlesticks',
		[8] = 'Dark Candy Fiddlesticks',
		[9] = 'Risen Fiddlesticks',
	},
	['fiora'] = {
		[1] = 'Fiora',
		[2] = 'Royal Guard Fiora',
		[3] = 'Nightraven Fiora',
		[4] = 'Headmistress Fiora',
	},
	['fizz'] = {
		[1] = 'Fizz',
		[2] = 'Atlantean Fizz',
		[3] = 'Tundra Fizz',
		[4] = 'Fisherman Fizz',
		[5] = 'Void Fizz',
	},
	['galio'] = {
		[1] = 'Galio',
		[2] = 'Enchanted Galio',
		[3] = 'Hextech Galio',
		[4] = 'Commando Galio',
		[5] = 'Gatekeeper Galio',
		[6] = 'Debonair Galio',
	},
	['gangplank'] = {
		[1] = 'Gangplank',
		[2] = 'Spooky Gangplank',
		[3] = 'Minuteman Gangplank',
		[4] = 'Sailor Gangplank',
		[5] = 'Toy Soldier Gangplank',
		[6] = 'Special Forces Gangplank',
		[7] = 'Sultan Gangplank',
	},
	['garen'] = {
		[1] = 'Garen',
		[2] = 'Sanguine Garen',
		[3] = 'Desert Trooper Garen',
		[4] = 'Commando Garen',
		[5] = 'Dreadknight Garen',
		[6] = 'Rugged Garen',
		[7] = 'Steel Legion Garen',
		[8] = 'Rogue Admiral Garen',
	},
	['gnar'] = {
		[1] = 'Gnar',
		[2] = 'Dino Gnar',
		[3] = 'Gentleman Gnar',
	},
	['gragas'] = {
		[1] = 'Gragas',
		[2] = 'Scuba Gragas',
		[3] = 'Hillbilly Gragas',
		[4] = 'Santa Gragas',
		[5] = 'Gragas, Esq.',
		[6] = 'Vandal Gragas',
		[7] = 'Oktoberfest Gragas',
		[8] = 'Superfan Gragas',
		[9] = 'Fnatic Gragas',
	},
	['graves'] = {
		[1] = 'Graves',
		[2] = 'Hired Gun Graves',
		[3] = 'Jailbreak Graves',
		[4] = 'Mafia Graves',
		[5] = 'Riot Graves',
		[6] = 'Pool Party Graves',
		[7] = 'Cutthroat Graves',
	},
	['hecarim'] = {
		[1] = 'Hecarim',
		[2] = 'Blood Knight Hecarim',
		[3] = 'Reaper Hecarim',
		[4] = 'Headless Hecarim',
		[5] = 'Arcade Hecarim',
	},
	['heimerdinger'] = {
		[1] = 'Heimerdinger',
		[2] = 'Alien Invader Heimerdinger',
		[3] = 'Blast Zone Heimerdinger',
		[4] = 'Piltover Customs Heimerdinger',
		[5] = 'Snowmerdinger',
		[6] = 'Hazmat Heimerdinger',
	},
	['irelia'] = {
		[1] = 'Irelia',
		[2] = 'Nightblade Irelia',
		[3] = 'Aviator Irelia',
		[4] = 'Infiltrator Irelia',
		[5] = 'Frostblade Irelia',
		[6] = 'Order of the Lotus Irelia',
	},
	['janna'] = {
		[1] = 'Janna',
		[2] = 'Tempest Janna',
		[3] = 'Hextech Janna',
		[4] = 'Frost Queen Janna',
		[5] = 'Victorious Janna',
		[6] = 'Forecast Janna',
		[7] = 'Fnatic Janna',
	},
	['jarvaniv'] = {
		[1] = 'Jarvan IV',
		[2] = 'Commando Jarvan IV',
		[3] = 'Dragonslayer Jarvan IV',
		[4] = 'Darkforge Jarvan IV',
		[5] = 'Victorious Jarvan IV',
		[6] = 'Warring Kingdoms Jarvan IV',
		[7] = 'Fnatic Jarvan IV',
	},
	['jax'] = {
		[1] = 'Jax',
		[2] = 'The Mighty Jax',
		[3] = 'Vandal Jax',
		[4] = 'Angler Jax',
		[5] = 'PAX Jax',
		[6] = 'Jaximus',
		[7] = 'Temple Jax',
		[8] = 'Nemesis Jax',
		[9] = 'SKT T1 Jax',
	},
	['jayce'] = {
		[1] = 'Jayce',
		[2] = 'Full Metal Jayce',
		[3] = 'Debonair Jayce',
		[4] = 'Forsaken Jayce',
	},
	['jinx'] = {
		[1] = 'Jinx',
		[2] = 'Mafia Jinx',
		[3] = 'Firecracker Jinx',
	},
	['kalista'] = {
		[1] = 'Kalista',
		[2] = 'Blood Moon Kalista',
	},
	['karma'] = {
		[1] = 'Karma',
		[2] = 'Sun Goddess Karma',
		[3] = 'Sakura Karma',
		[4] = 'Traditional Karma',
		[5] = 'Order of the Lotus Karma',
	},
	['karthus'] = {
		[1] = 'Karthus',
		[2] = 'Phantom Karthus',
		[3] = 'Statue of Karthus',
		[4] = 'Grim Reaper Karthus',
		[5] = 'Pentakill Karthus',
		[6] = 'Fnatic Karthus',
	},
	['kassadin'] = {
		[1] = 'Kassadin',
		[2] = 'Festival Kassadin',
		[3] = 'Deep One Kassadin',
		[4] = 'Pre-Void Kassadin',
		[5] = 'Harbinger Kassadin',
	},
	['katarina'] = {
		[1] = 'Katarina',
		[2] = 'Mercenary Katarina',
		[3] = 'Red Card Katarina',
		[4] = 'Bilgewater Katarina',
		[5] = 'Kitty Cat Katarina',
		[6] = 'High Command Katarina',
		[7] = 'Sandstorm Katarina',
		[8] = 'Slay Belle Katarina',
		[9] = 'Warring Kingdoms Katarina',
	},
	['kayle'] = {
		[1] = 'Kayle',
		[2] = 'Silver Kayle',
		[3] = 'Viridian Kayle',
		[4] = 'Unmasked Kayle',
		[5] = 'Battleborn Kayle',
		[6] = 'Judgment Kayle',
		[7] = 'Aether Wing Kayle',
		[8] = 'Riot Kayle',
	},
	['kennen'] = {
		[1] = 'Kennen',
		[2] = 'Deadly Kennen',
		[3] = 'Swamp Master Kennen',
		[4] = 'Karate Kennen',
		[5] = 'Kennen M.D.',
		[6] = 'Arctic Ops Kennen',
	},
	['khazix'] = {
		[1] = 'Kha\'Zix',
		[2] = 'Mecha Kha\'Zix',
		[3] = 'Guardian of the Sands Kha\'Zix',
	},
	['kogmaw'] = {
		[1] = 'Kog\'Maw',
		[2] = 'Caterpillar Kog\'Maw',
		[3] = 'Sonoran Kog\'Maw',
		[4] = 'Monarch Kog\'Maw',
		[5] = 'Reindeer Kog\'Maw',
		[6] = 'Lion Dance Kog\'Maw',
		[7] = 'Deep Sea Kog\'Maw',
		[8] = 'Jurassic Kog\'Maw',
		[9] = 'Battlecast Kog\'Maw',
	},
	['leblanc'] = {
		[1] = 'Leblanc',
		[2] = 'Wicked LeBlanc',
		[3] = 'Prestigious LeBlanc',
		[4] = 'Mistletoe LeBlanc',
		[5] = 'Ravenborn LeBlanc',
	},
	['leesin'] = {
		[1] = 'Lee Sin',
		[2] = 'Traditional Lee Sin',
		[3] = 'Acolyte Lee Sin',
		[4] = 'Dragon Fist Lee Sin',
		[5] = 'Muay Thai Lee Sin',
		[6] = 'Pool Party Lee Sin',
		[7] = 'SKT T1 Lee Sin',
		[8] = 'Knockout Lee Sin',
	},
	['leona'] = {
		[1] = 'Leona',
		[2] = 'Valkyrie Leona',
		[3] = 'Defender Leona',
		[4] = 'Iron Solari Leona',
		[5] = 'Pool Party Leona',
	},
	['lissandra'] = {
		[1] = 'Lissandra',
		[2] = 'Bloodstone Lissandra',
		[3] = 'Blade Queen Lissandra',
	},
	['lucian'] = {
		[1] = 'Lucian',
		[2] = 'Hired Gun Lucian',
		[3] = 'Striker Lucian',
	},
	['lulu'] = {
		[1] = 'Lulu',
		[2] = 'Bittersweet Lulu',
		[3] = 'Wicked Lulu',
		[4] = 'Dragon Trainer Lulu',
		[5] = 'Winter Wonder Lulu',
		[6] = 'Pool Party Lulu',
	},
	['lux'] = {
		[1] = 'Lux',
		[2] = 'Sorceress Lux',
		[3] = 'Spellthief Lux',
		[4] = 'Commando Lux',
		[5] = 'Imperial Lux',
		[6] = 'Steel Legion Lux',
		[7] = 'Star Guardian Lux',
	},
	['malphite'] = {
		[1] = 'Malphite',
		[2] = 'Shamrock Malphite',
		[3] = 'Coral Reef Malphite',
		[4] = 'Marble Malphite',
		[5] = 'Obsidian Malphite',
		[6] = 'Glacial Malphite',
		[7] = 'Mecha Malphite',
	},
	['malzahar'] = {
		[1] = 'Malzahar',
		[2] = 'Vizier Malzahar',
		[3] = 'Shadow Prince Malzahar',
		[4] = 'Djinn Malzahar',
		[5] = 'Overlord Malzahar',
		[6] = 'Snow Day Malzahar',
	},
	['maokai'] = {
		[1] = 'Maokai',
		[2] = 'Charred Maokai',
		[3] = 'Totemic Maokai',
		[4] = 'Festive Maokai',
		[5] = 'Haunted Maokai',
		[6] = 'Goalkeeper Maokai',
	},
	['masteryi'] = {
		[1] = 'Master Yi',
		[2] = 'Assassin Master Yi',
		[3] = 'Chosen Master Yi',
		[4] = 'Ionia Master Yi',
		[5] = 'Samurai Yi',
		[6] = 'Headhunter Master Yi',
	},
	['missfortune'] = {
		[1] = 'Miss Fortune',
		[2] = 'Cowgirl Miss Fortune',
		[3] = 'Waterloo Miss Fortune',
		[4] = 'Secret Agent Miss Fortune',
		[5] = 'Candy Cane Miss Fortune',
		[6] = 'Road Warrior Miss Fortune',
		[7] = 'Mafia Miss Fortune',
		[8] = 'Arcade Miss Fortune',
		[9] = 'Captain Fortune',
	},
	['monkeyking'] = {
		[1] = 'Wukong',
		[2] = 'Volcanic Wukong',
		[3] = 'General Wukong',
		[4] = 'Jade Dragon Wukong',
		[5] = 'Underworld Wukong',
	},
	['mordekaiser'] = {
		[1] = 'Mordekaiser',
		[2] = 'Dragon Knight Mordekaiser',
		[3] = 'Infernal Mordekaiser',
		[4] = 'Pentakill Mordekaiser',
		[5] = 'Lord Mordekaiser',
		[6] = 'King of Clubs Mordekaiser',
	},
	['morgana'] = {
		[1] = 'Morgana',
		[2] = 'Exiled Morgana',
		[3] = 'Sinful Succulence Morgana',
		[4] = 'Blade Mistress Morgana',
		[5] = 'Blackthorn Morgana',
		[6] = 'Ghost Bride Morgana',
		[7] = 'Victorious Morgana',
	},
	['nami'] = {
		[1] = 'Nami',
		[2] = 'Koi Nami',
		[3] = 'River Spirit Nami',
		[4] = 'Urf the Nami-tee',
	},
	['nasus'] = {
		[1] = 'Nasus',
		[2] = 'Galactic Nasus',
		[3] = 'Pharaoh Nasus',
		[4] = 'Dreadknight Nasus',
		[5] = 'Riot K-9 Nasus',
		[6] = 'Infernal Nasus',
		[7] = 'Archduke Nasus',
	},
	['nautilus'] = {
		[1] = 'Nautilus',
		[2] = 'Abyssal Nautilus',
		[3] = 'Subterranean Nautilus',
		[4] = 'AstroNautilus',
		[5] = 'Warden Nautilus',
	},
	['nidalee'] = {
		[1] = 'Nidalee',
		[2] = 'Snow Bunny Nidalee',
		[3] = 'Leopard Nidalee',
		[4] = 'French Maid Nidalee',
		[5] = 'Pharaoh Nidalee',
		[6] = 'Bewitching Nidalee',
		[7] = 'Headhunter Nidalee',
		[8] = 'Warring Kingdoms Nidalee',
	},
	['nocturne'] = {
		[1] = 'Nocturne',
		[2] = 'Frozen Terror Nocturne',
		[3] = 'Void Nocturne',
		[4] = 'Ravager Nocturne',
		[5] = 'Haunting Nocturne',
		[6] = 'Eternum Nocturne',
	},
	['nunu'] = {
		[1] = 'Nunu',
		[2] = 'Sasquatch Nunu',
		[3] = 'Workshop Nunu',
		[4] = 'Grungy Nunu',
		[5] = 'Nunu Bot',
		[6] = 'Demolisher Nunu',
		[7] = 'TPA Nunu',
	},
	['olaf'] = {
		[1] = 'Olaf',
		[2] = 'Forsaken Olaf',
		[3] = 'Glacial Olaf',
		[4] = 'Brolaf',
		[5] = 'Pentakill Olaf',
	},
	['orianna'] = {
		[1] = 'Orianna',
		[2] = 'Gothic Orianna',
		[3] = 'Sewn Chaos Orianna',
		[4] = 'Bladecraft Orianna',
		[5] = 'TPA Orianna',
		[6] = 'Winter Wonder Orianna',
	},
	['pantheon'] = {
		[1] = 'Pantheon',
		[2] = 'Myrmidon Pantheon',
		[3] = 'Ruthless Pantheon',
		[4] = 'Perseus Pantheon',
		[5] = 'Full Metal Pantheon',
		[6] = 'Glaive Warrior Pantheon',
		[7] = 'Dragonslayer Pantheon',
	},
	['poppy'] = {
		[1] = 'Poppy',
		[2] = 'Noxus Poppy',
		[3] = 'Lollipoppy',
		[4] = 'Blacksmith Poppy',
		[5] = 'Ragdoll Poppy',
		[6] = 'Battle Regalia Poppy',
		[7] = 'Scarlet Hammer Poppy',
	},
	['quinn'] = {
		[1] = 'Quinn',
		[2] = 'Phoenix Quinn',
		[3] = 'Woad Scout Quinn',
		[4] = 'Corsair Quinn',
	},
	['rammus'] = {
		[1] = 'Rammus',
		[2] = 'King Rammus',
		[3] = 'Chrome Rammus',
		[4] = 'Molten Rammus',
		[5] = 'Freljord Rammus',
		[6] = 'Ninja Rammus',
		[7] = 'Full Metal Rammus',
		[8] = 'Guardian of the Sands Rammus',
	},
	['reksai'] = {
		[1] = 'Rek\'Sai',
		[2] = 'Eternum Rek\'Sai',
		[3] = 'Pool Party Rek\'Sai',
	},
	['renekton'] = {
		[1] = 'Renekton',
		[2] = 'Galactic Renekton',
		[3] = 'Outback Renekton',
		[4] = 'Bloodfury Renekton',
		[5] = 'Rune Wars Renekton',
		[6] = 'Scorched Earth Renekton',
		[7] = 'Pool Party Renekton',
		[8] = 'Prehistoric Renekton',
	},
	['rengar'] = {
		[1] = 'Rengar',
		[2] = 'Headhunter Rengar',
		[3] = 'Night Hunter Rengar',
		[4] = 'SSW Rengar',
	},
	['riven'] = {
		[1] = 'Riven',
		[2] = 'Redeemed Riven',
		[3] = 'Crimson Elite Riven',
		[4] = 'Battle Bunny Riven',
		[5] = 'Championship Riven',
		[6] = 'Dragonblade Riven',
	},
	['rumble'] = {
		[1] = 'Rumble',
		[2] = 'Rumble in the Jungle',
		[3] = 'Bilgerat Rumble',
		[4] = 'Super Galaxy Rumble',
	},
	['ryze'] = {
		[1] = 'Ryze',
		[2] = 'Human Ryze',
		[3] = 'Tribal Ryze',
		[4] = 'Uncle Ryze',
		[5] = 'Triumphant Ryze',
		[6] = 'Professor Ryze',
		[7] = 'Zombie Ryze',
		[8] = 'Dark Crystal Ryze',
		[9] = 'Pirate Ryze',
	},
	['sejuani'] = {
		[1] = 'Sejuani',
		[2] = 'Sabretusk Sejuani',
		[3] = 'Darkrider Sejuani',
		[4] = 'Traditional Sejuani',
		[5] = 'Bear Cavalry Sejuani',
		[6] = 'Poro Rider Sejuani',
	},
	['shaco'] = {
		[1] = 'Shaco',
		[2] = 'Mad Hatter Shaco',
		[3] = 'Royal Shaco',
		[4] = 'Nutcracko',
		[5] = 'Workshop Shaco',
		[6] = 'Asylum Shaco',
		[7] = 'Masked Shaco',
		[8] = 'Wild Card Shaco',
	},
	['shen'] = {
		[1] = 'Shen',
		[2] = 'Frozen Shen',
		[3] = 'Yellow Jacket Shen',
		[4] = 'Surgeon Shen',
		[5] = 'Blood Moon Shen',
		[6] = 'Warlord Shen',
		[7] = 'TPA Shen',
	},
	['shyvana'] = {
		[1] = 'Shyvana',
		[2] = 'Ironscale Shyvana',
		[3] = 'Boneclaw Shyvana',
		[4] = 'Darkflame Shyvana',
		[5] = 'Ice Drake Shyvana',
		[6] = 'Championship Shyvana',
	},
	['singed'] = {
		[1] = 'Singed',
		[2] = 'Riot Squad Singed',
		[3] = 'Hextech Singed',
		[4] = 'Surfer Singed',
		[5] = 'Mad Scientist Singed',
		[6] = 'Augmented Singed',
		[7] = 'Snow Day Singed',
		[8] = 'SSW Singed',
	},
	['sion'] = {
		[1] = 'Sion',
		[2] = 'Hextech Sion',
		[3] = 'Barbarian Sion',
		[4] = 'Lumberjack Sion',
		[5] = 'Warmonger Sion',
	},
	['sivir'] = {
		[1] = 'Sivir',
		[2] = 'Warrior Princess Sivir',
		[3] = 'Spectacular Sivir',
		[4] = 'Huntress Sivir',
		[5] = 'Bandit Sivir',
		[6] = 'PAX Sivir',
		[7] = 'Snowstorm Sivir',
		[8] = 'Warden Sivir',
	},
	['skarner'] = {
		[1] = 'Skarner',
		[2] = 'Sandscourge Skarner',
		[3] = 'Earthrune Skarner',
		[4] = 'Battlecast Alpha Skarner',
		[5] = 'Guardian of the Sands Skarner',
	},
	['sona'] = {
		[1] = 'Sona',
		[2] = 'Muse Sona',
		[3] = 'Pentakill Sona',
		[4] = 'Silent Night Sona',
		[5] = 'Guqin Sona',
		[6] = 'Arcade Sona',
		[7] = 'DJ Sona',
	},
	['soraka'] = {
		[1] = 'Soraka',
		[2] = 'Dryad Soraka',
		[3] = 'Divine Soraka',
		[4] = 'Celestine Soraka',
		[5] = 'Reaper Soraka',
		[6] = 'Order of the Banana Soraka',
	},
	['swain'] = {
		[1] = 'Swain',
		[2] = 'Northern Front Swain',
		[3] = 'Bilgewater Swain',
		[4] = 'Tyrant Swain',
	},
	['syndra'] = {
		[1] = 'Syndra',
		[2] = 'Justicar Syndra',
		[3] = 'Atlantean Syndra',
		[4] = 'Queen of Diamonds Syndra',
	},
	['tahmkench'] = {
		[1] = 'Tahm Kench',
		[2] = 'Master Chef Tahm Kench',
	},
	['talon'] = {
		[1] = 'Talon',
		[2] = 'Renegade Talon',
		[3] = 'Crimson Elite Talon',
		[4] = 'Dragonblade Talon',
		[5] = 'SSW Talon',
	},
	['taric'] = {
		[1] = 'Taric',
		[2] = 'Emerald Taric',
		[3] = 'Armor of the Fifth Age Taric',
		[4] = 'Bloodstone Taric',
	},
	['teemo'] = {
		[1] = 'Teemo',
		[2] = 'Happy Elf Teemo',
		[3] = 'Recon Teemo',
		[4] = 'Badger Teemo',
		[5] = 'Astronaut Teemo',
		[6] = 'Cottontail Teemo',
		[7] = 'Super Teemo',
		[8] = 'Panda Teemo',
		[9] = 'Omega Squad Teemo',
	},
	['thresh'] = {
		[1] = 'Thresh',
		[2] = 'Deep Terror Thresh',
		[3] = 'Championship Thresh',
		[4] = 'Blood Moon Thresh',
		[5] = 'SSW Thresh',
	},
	['tristana'] = {
		[1] = 'Tristana',
		[2] = 'Riot Girl Tristana',
		[3] = 'Earnest Elf Tristana',
		[4] = 'Firefighter Tristana',
		[5] = 'Guerilla Tristana',
		[6] = 'Buccaneer Tristana',
		[7] = 'Rocket Girl Tristana',
	},
	['trundle'] = {
		[1] = 'Trundle',
		[2] = 'Lil\' Slugger Trundle',
		[3] = 'Junkyard Trundle',
		[4] = 'Traditional Trundle',
		[5] = 'Constable Trundle',
	},
	['tryndamere'] = {
		[1] = 'Tryndamere',
		[2] = 'Highland Tryndamere',
		[3] = 'King Tryndamere',
		[4] = 'Viking Tryndamere',
		[5] = 'Demonblade Tryndamere',
		[6] = 'Sultan Tryndamere',
		[7] = 'Warring Kingdoms Tryndamere',
		[8] = 'Nightmare Tryndamere',
	},
	['twistedfate'] = {
		[1] = 'Twisted Fate',
		[2] = 'PAX Twisted Fate',
		[3] = 'Jack of Hearts Twisted Fate',
		[4] = 'The Magnificent Twisted Fate',
		[5] = 'Tango Twisted Fate',
		[6] = 'High Noon Twisted Fate',
		[7] = 'Musketeer Twisted Fate',
		[8] = 'Underworld Twisted Fate',
		[9] = 'Red Card Twisted Fate',
		[10] = 'Cutpurse Twisted Fate',
	},
	['twitch'] = {
		[1] = 'Twitch',
		[2] = 'Kingpin Twitch',
		[3] = 'Whistler Village Twitch',
		[4] = 'Medieval Twitch',
		[5] = 'Gangster Twitch',
		[6] = 'Vandal Twitch',
		[7] = 'Pickpocket Twitch',
		[8] = 'SSW Twitch',
	},
	['udyr'] = {
		[1] = 'Udyr',
		[2] = 'Black Belt Udyr',
		[3] = 'Primal Udyr',
		[4] = 'Spirit Guard Udyr',
		[5] = 'Definitely Not Udyr',
	},
	['urgot'] = {
		[1] = 'Urgot',
		[2] = 'Giant Enemy Crabgot',
		[3] = 'Butcher Urgot',
		[4] = 'Battlecast Urgot',
	},
	['varus'] = {
		[1] = 'Varus',
		[2] = 'Blight Crystal Varus',
		[3] = 'Arclight Varus',
		[4] = 'Arctic Ops Varus',
		[5] = 'Heartseeker Varus',
	},
	['vayne'] = {
		[1] = 'Vayne',
		[2] = 'Vindicator Vayne',
		[3] = 'Aristocrat Vayne',
		[4] = 'Dragonslayer Vayne',
		[5] = 'Heartseeker Vayne',
		[6] = 'SKT T1 Vayne',
		[7] = 'Arclight Vayne',
	},
	['veigar'] = {
		[1] = 'Veigar',
		[2] = 'White Mage Veigar',
		[3] = 'Curling Veigar',
		[4] = 'Veigar Greybeard',
		[5] = 'Leprechaun Veigar',
		[6] = 'Baron Von Veigar',
		[7] = 'Superb Villain Veigar',
		[8] = 'Bad Santa Veigar',
		[9] = 'Final Boss Veigar',
	},
	['velkoz'] = {
		[1] = 'Vel\'Koz',
		[2] = 'Battlecast Vel\'Koz',
		[3] = 'Arclight Vel\'Koz',
	},
	['vi'] = {
		[1] = 'Vi',
		[2] = 'Neon Strike Vi',
		[3] = 'Officer Vi',
		[4] = 'Debonair Vi',
	},
	['viktor'] = {
		[1] = 'Viktor',
		[2] = 'Full Machine Viktor',
		[3] = 'Prototype Viktor',
		[4] = 'Creator Viktor',
	},
	['vladimir'] = {
		[1] = 'Vladimir',
		[2] = 'Count Vladimir',
		[3] = 'Marquis Vladimir',
		[4] = 'Nosferatu Vladimir',
		[5] = 'Vandal Vladimir',
		[6] = 'Blood Lord Vladimir',
		[7] = 'Soulstealer Vladimir',
	},
	['volibear'] = {
		[1] = 'Volibear',
		[2] = 'Thunder Lord Volibear',
		[3] = 'Northern Storm Volibear',
		[4] = 'Runeguard Volibear',
		[5] = 'Captain Volibear',
	},
	['warwick'] = {
		[1] = 'Warwick',
		[2] = 'Grey Warwick',
		[3] = 'Urf the Manatee',
		[4] = 'Big Bad Warwick',
		[5] = 'Tundra Hunter Warwick',
		[6] = 'Feral Warwick',
		[7] = 'Firefang Warwick',
		[8] = 'Hyena Warwick',
		[9] = 'Marauder Warwick',
	},
	['xerath'] = {
		[1] = 'Xerath',
		[2] = 'Runeborn Xerath',
		[3] = 'Battlecast Xerath',
		[4] = 'Scorched Earth Xerath',
		[5] = 'Guardian of the Sands Xerath',
	},
	['xinzhao'] = {
		[1] = 'Xin Zhao',
		[2] = 'Commando Xin Zhao',
		[3] = 'Imperial Xin Zhao',
		[4] = 'Viscero Xin Zhao',
		[5] = 'Winged Hussar Xin Zhao',
		[6] = 'Warring Kingdoms Xin Zhao',
		[7] = 'Secret Agent Xin Zhao',
	},
	['yasuo'] = {
		[1] = 'Yasuo',
		[2] = 'High Noon Yasuo',
		[3] = 'PROJECT: Yasuo',
	},
	['yorick'] = {
		[1] = 'Yorick',
		[2] = 'Undertaker Yorick',
		[3] = 'Pentakill Yorick',
	},
	['zac'] = {
		[1] = 'Zac',
		[2] = 'Special Weapon Zac',
		[3] = 'Pool Party Zac',
	},
	['zed'] = {
		[1] = 'Zed',
		[2] = 'Shockblade Zed',
		[3] = 'SKT T1 Zed',
	},
	['ziggs'] = {
		[1] = 'Ziggs',
		[2] = 'Mad Scientist Ziggs',
		[3] = 'Major Ziggs',
		[4] = 'Pool Party Ziggs',
		[5] = 'Snow Day Ziggs',
		[6] = 'Master Arcanist Ziggs',
	},
	['zilean'] = {
		[1] = 'Zilean',
		[2] = 'Old Saint Zilean',
		[3] = 'Groovy Zilean',
		[4] = 'Shurima Desert Zilean',
		[5] = 'Time Machine Zilean',
		[6] = 'Blood Moon Zilean',
	},
	['zyra'] = {
		[1] = 'Zyra',
		[2] = 'Wildfire Zyra',
		[3] = 'Haunted Zyra',
		[4] = 'SKT T1 Zyra',
	},
};
local skinsPB = {
	[1] = {0x00, 0x00, 0x00, 0x00},
	[2] = {0xB8, 0xBC, 0xBC, 0xBC},
	[3] = {0xBE, 0xBC, 0xBC, 0xBC},
	[4] = {0xBA, 0xBC, 0xBC, 0xBC},
	[5] = {0xBD, 0xBC, 0xBC, 0xBC},
	[6] = {0xB9, 0xBC, 0xBC, 0xBC},
	[7] = {0xBF, 0xBC, 0xBC, 0xBC},
	[8] = {0xBB, 0xBC, 0xBC, 0xBC},
	[9] = {0x3D, 0xBC, 0xBC, 0xBC},
	[10] = {0x39, 0xBC, 0xBC, 0xBC},
};

if (skinNames[string.lower(myHero.charName)] == nil) then
	print('<font color="#FF1493"><b>[p_skinChanger]</b> </font><font color="#FF0000">Champion Not Supported</font>');
	return;
else
	skinNames = skinNames[string.lower(myHero.charName)];
end;

local theMenu = nil;
local lastTimeTickCalled = 0;
local lastSkin = 0;

function OnLoad()
	InitMenu();
	
	if (not theMenu['save' .. myHero.charName .. 'Skin']) then
		theMenu['change' .. myHero.charName .. 'Skin'] = false;
		theMenu['selected' .. myHero.charName .. 'Skin'] = 1;
	elseif (theMenu['change' .. myHero.charName .. 'Skin']) then
			SendSkinPacket(myHero.charName, skinsPB[theMenu['selected' .. myHero.charName .. 'Skin']]);
	end;
	
	print('<font color="#FF1493"><b>[p_skinChanger]</b> </font><font color="#00EE00">Loaded Successfully</font>');
end;

function OnUnload()
	if (theMenu['change' .. myHero.charName .. 'Skin']) then
		SendSkinPacket(myHero.charName, nil);
	end;
end;

function OnTick()
	if ((GetTickCount() - lastTimeTickCalled) > 200) then
		lastTimeTickCalled = GetTickCount();
		if (theMenu['change' .. myHero.charName .. 'Skin']) then
			if (theMenu['selected' .. myHero.charName .. 'Skin'] ~= lastSkin) then
				lastSkin = theMenu['selected' .. myHero.charName .. 'Skin'];
				SendSkinPacket(myHero.charName, skinsPB[theMenu['selected' .. myHero.charName .. 'Skin']]);
			end;
		elseif (lastSkin ~= 0) then
			lastSkin = 0;
			SendSkinPacket(myHero.charName, nil);
		end;
	end;
end;

function InitMenu()
	theMenu = scriptConfig('p_skinChanger', 'p_skinChanger');
	theMenu:addParam('save' .. myHero.charName .. 'Skin', 'Save Skin', SCRIPT_PARAM_ONOFF, false);
	theMenu:addParam('change' .. myHero.charName .. 'Skin', 'Change Skin', SCRIPT_PARAM_ONOFF, false);
	theMenu:addParam('selected' .. myHero.charName .. 'Skin', 'Selected Skin', SCRIPT_PARAM_LIST, 1, skinNames);
end;

function SendSkinPacket(mObject, skinPB)
	local mP = CLoLPacket(0x55);
	
	mP.vTable = 0xEFD958;
	
	mP:EncodeF(myHero.networkID);
	if (skinPB == nil) then
		mP:Encode1(0xE3);
		mP:Encode1(0xE3);
		mP:Encode1(0xE3);
		mP:Encode1(0xE3);
	else
		for _, pH in ipairs(skinPB) do
			mP:Encode1(pH);
		end;
	end;
	
	mP:Encode1(0x72);

	for I = 1, string.len(mObject) do
		mP:Encode1(string.byte(string.sub(mObject, I, I)));
	end;

	for I = 1, (16 - string.len(mObject)) do
		mP:Encode1(0x00);
	end;

	mP:Encode1(0x0B);
	
	for I = 1, 3 do
		mP:Encode1(0x00);
	end;
	
	mP:Encode1(0x0F);
	
	for I = 1, 3 do
		mP:Encode1(0x00);
	end;
	
	mP:Hide();
	RecvPacket(mP);
end;
