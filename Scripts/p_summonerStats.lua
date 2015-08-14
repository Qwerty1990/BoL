-- Developer: PvPSuite (http://forum.botoflegends.com/user/76516-pvpsuite/)

local sVersion = '1.3';
local rVersion = GetWebResult('raw.githubusercontent.com', '/pvpsuite/BoL/master/Versions/Scripts/p_summonerStats.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/pvpsuite/BoL/master/Scripts/p_summonerStats.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#00FF00">Script has been updated, please reload!</font>');
		end);
		return;
	end;
else
	print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Update Error</font>');
end;

local summonersData = {};
local platformIDs = {['BR1'] = 'BR', ['EUN1'] = 'EUNE', ['EUW1'] = 'EUW', ['KR'] = 'KR', ['LA1'] = 'LAN', ['LA2'] = 'LAS', ['NA1'] = 'NA', ['OC1'] = 'OCE', ['RU'] = 'RU', ['TR1'] = 'TR'};
local lastTick = 0;
local lastOption = 0;
local boxW = 250;
local boxH = 225;
local lTCP = nil;
local summonerName = nil;
local drawSummoner = nil;
local currentGameData = nil;
local loadingGameData = false;
local lSocket = require('socket');
local CRLF = '\r\n';
local tempGameData = '';

function GetSummoners()
	local tSummoners = {};
	
	for I = 1, heroManager.iCount do
		local theHero = heroManager:GetHero(I);
		if (theHero.networkID ~= myHero.networkID) then
			tSummoners[#tSummoners + 1] = theHero;
		end;
	end;
	
	return tSummoners;
end;

local gSummoners = GetSummoners();

if (#gSummoners <= 0) then
	print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">No Summoners Found</font>');
	return;
elseif (#gSummoners > 9) then
	print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Too Many Summoners Found</font>');
	return;
end;

function OnLoad()
	summonerName = gSummoners[1].name;
	
	InitMenu();

	ResetOptions(nil);
	lTCP = lSocket.tcp();
	lTCP:settimeout(0, 'b');
	lTCP:connect('bol.pvpsuite.net', 80);
	lastTick = GetTickCount() + 500;
	loadingGameData = true;
	
	print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FFFF00">Loading Game Data</font>');
end;

function OnTick()
	if ((GetTickCount() - lastTick) > 250) then
		lastTick = GetTickCount();
		if ((theMenu.One) or (theMenu.Two) or (theMenu.Three) or (theMenu.Four) or (theMenu.Five) or (theMenu.Six) or (theMenu.Seven) or (theMenu.Eight) or (theMenu.Nine) or (theMenu.Ten)) then
			local toCheck = 0;
			
			if ((theMenu.One) and (lastOption ~= 1)) then
				toCheck = 1;
			elseif ((theMenu.Two) and (lastOption ~= 2)) then
					toCheck = 2;
			elseif ((theMenu.Three) and (lastOption ~= 3)) then
					toCheck = 3;
			elseif ((theMenu.Four) and (lastOption ~= 4)) then
					toCheck = 4;
			elseif ((theMenu.Five) and (lastOption ~= 5)) then
					toCheck = 5;
			elseif ((theMenu.Six) and (lastOption ~= 6)) then
					toCheck = 6;
			elseif ((theMenu.Seven) and (lastOption ~= 7)) then
					toCheck = 7;
			elseif ((theMenu.Eight) and (lastOption ~= 8)) then
					toCheck = 8;
			elseif ((theMenu.Nine) and (lastOption ~= 9)) then
					toCheck = 9;
			end;
			
			if (currentGameData == nil) then
				if (loadingGameData == true) then
					print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FFFF00">Please Wait</font>');
				else
					ResetOptions(nil);
					lTCP = lSocket.tcp();
					lTCP:settimeout(0, 'b');
					lTCP:connect('bol.pvpsuite.net', 80);
					lastTick = GetTickCount() + 500;
					tempGameData = '';
					loadingGameData = true;
					
					print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FFFF00">Loading Game Data</font>');
				end;
			elseif ((toCheck ~= 0) and (lastOption ~= toCheck)) then
					ShowSummonerData(toCheck);
			end;
				
			if ((toCheck ~= 0) and (lastOption ~= toCheck)) then
				ResetOptions(toCheck);
			end;
		elseif (lastOption ~= 0) then
				lastOption = 0;
				drawSummoner = nil;
		end;
		
		if (loadingGameData) then
			if (platformIDs[GetGameRegion():upper()] == nil) then
				print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Could Not Read Game Region</font>');
				loadingGameData = false;
				lTCP:close();
			else
				local fString, cStatus, pString = lTCP:receive(1024);
				
				if (cStatus == 'timeout') then
					lTCP:send('GET /game.php?name=' .. encodeForURL(summonerName) .. '&server=' .. platformIDs[GetGameRegion():upper()]:lower() .. ' HTTP/1.1' .. CRLF .. 'Host: bol.pvpsuite.net' .. CRLF .. 'User-Agent: Bot of Legends 1.0' .. CRLF .. CRLF);
				end;
				
				if ((fString) or (#pString > 0)) then
					tempGameData = tempGameData .. (fString or pString);
				end;
				
				if (tempGameData:find('<script>.+</script>') ~= nil) then
					currentGameData = tempGameData:match('<script>(.+)</script>');
					if (not currentGameData) then
						print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Could Not Read Game Data</font>');
					else
						currentGameData = JSON:decode(currentGameData);
						
						if ((currentGameData['error'] ~= nil) and (currentGameData['message'] ~= nil)) then
							print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Error ' .. currentGameData['error'] .. ' (' .. currentGameData['message']:lower() .. ')</font>');
							currentGameData = nil;
							loadingGameData = false;
							lTCP:close();
						else
							for _, summonerData in pairs(currentGameData) do
								if ((summonerData ~= nil) and (summonerData['summoner_name'] ~= nil)) then
									summonersData[summonerData['summoner_name']] = summonerData;
								end;
							end;
							
							print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#00EE00">Game Data Loaded</font>');
						end;
						
					end;
					
					loadingGameData = false;
					lTCP:close();
				end;
			end;
		end;
	end;
end;

function OnDraw()
	if (drawSummoner ~= nil) then
		DrawRectangle(theMenu.drawW, theMenu.drawH, boxW, boxH, RGB(20, 32, 33));
		
		DrawText(drawSummoner['summoner_name'], 22, (theMenu.drawW + (boxW / 2) - (GetTextArea(drawSummoner['summoner_name'], 22).x / 2)), theMenu.drawH + 6, RGB(175, 160, 124));
		
		DrawLine(theMenu.drawW, theMenu.drawH + 35, theMenu.drawW + boxW, theMenu.drawH + 35, 1, RGB(175, 160, 124));
		
		if (drawSummoner['summoner_level'] == 30) then
			if (drawSummoner['ranked_tier'] ~= 'Unranked') then
				DrawText(drawSummoner['ranked_tier'] .. ' ' .. drawSummoner['ranked_division'] .. ' - ' .. drawSummoner['ranked_lp'] .. ' LP', 18, (theMenu.drawW + (boxW / 2) - (GetTextArea(drawSummoner['ranked_tier'] .. ' ' .. drawSummoner['ranked_division'] .. ' - ' .. drawSummoner['ranked_lp'] .. ' LP', 18).x / 2)), theMenu.drawH + 45, RGB(220, 220, 220));
			else
				DrawText(drawSummoner['ranked_tier'], 18, (theMenu.drawW + (boxW / 2) - (GetTextArea(drawSummoner['ranked_tier'], 18).x / 2)), theMenu.drawH + 45, RGB(220, 220, 220));
			end;
		else
			DrawText('Level ' .. drawSummoner['summoner_level'], 18, (theMenu.drawW + (boxW / 2) - (GetTextArea('Level ' .. drawSummoner['summoner_level'], 18).x / 2)), theMenu.drawH + 45, RGB(220, 220, 220));
		end;
		
		DrawLine(theMenu.drawW, theMenu.drawH + 70, theMenu.drawW + boxW, theMenu.drawH + 70, 1, RGB(44, 62, 63));
		
		DrawText(drawSummoner['ranked_wins'] .. ' Wins / ' .. drawSummoner['ranked_losses'] .. ' Losses', 18, (theMenu.drawW + (boxW / 2) - (GetTextArea(drawSummoner['ranked_wins'] .. ' Wins / ' .. drawSummoner['ranked_losses'] .. ' Losses', 18).x / 2)), theMenu.drawH + 80, RGB(220, 220, 220));
		
		DrawLine(theMenu.drawW, theMenu.drawH + 105, theMenu.drawW + boxW, theMenu.drawH + 105, 1, RGB(44, 62, 63));
		
		DrawText(drawSummoner['champion_games'] .. ' Champion Games', 18, (theMenu.drawW + (boxW / 2) - (GetTextArea(drawSummoner['champion_games'] .. ' Champion Games', 18).x / 2)), theMenu.drawH + 115, RGB(220, 220, 220));
		
		DrawText('KDA: ' .. drawSummoner['champion_avg_kills'] .. ' / ' .. drawSummoner['champion_avg_deaths'] .. ' / ' .. drawSummoner['champion_avg_assists'], 18, (theMenu.drawW + (boxW / 2) - (GetTextArea('KDA: ' .. drawSummoner['champion_avg_kills'] .. ' / ' .. drawSummoner['champion_avg_deaths'] .. ' / ' .. drawSummoner['champion_avg_assists'], 18).x / 2)), theMenu.drawH + 140, RGB(220, 220, 220));
		
		DrawLine(theMenu.drawW, theMenu.drawH + 165, theMenu.drawW + boxW, theMenu.drawH + 165, 1, RGB(44, 62, 63));
		
		DrawText('Current Masteries', 18, (theMenu.drawW + (boxW / 2) - (GetTextArea('Current Masteries', 18).x / 2)), theMenu.drawH + 175, RGB(220, 220, 220));
		
		DrawText(drawSummoner['summoner_masteries']['offense'] .. ' / ' .. drawSummoner['summoner_masteries']['defense'] .. ' / ' .. drawSummoner['summoner_masteries']['utility'], 18, (theMenu.drawW + (boxW / 2) - (GetTextArea(drawSummoner['summoner_masteries']['offense'] .. ' / ' .. drawSummoner['summoner_masteries']['defense'] .. ' / ' .. drawSummoner['summoner_masteries']['utility'], 18).x / 2)), theMenu.drawH + 200, RGB(220, 220, 220));
		
		DrawRectangleOutline(theMenu.drawW, theMenu.drawH, boxW, boxH, RGB(175, 160, 124), 2);
	end;
end;

function InitMenu()
	theMenu = scriptConfig('p_summonerStats', 'p_summonerStats');
	
	theMenu:addParam('drawH', 'Screen H Position', SCRIPT_PARAM_SLICE, ((WINDOW_H - boxH) / 2), 0, (WINDOW_H - boxH), 0);
	theMenu:addParam('drawW', 'Screen W Position', SCRIPT_PARAM_SLICE, ((WINDOW_W - boxW) / 2), 0, (WINDOW_W - boxW), 0);
	
	for _, checkSummoner in ipairs(gSummoners) do
		if (checkSummoner.team == myHero.team) then
			theMenu:addParam(GetWordFromNumber(_), 'Draw Ally ' .. GetChampionFriendlyName(gSummoners[_].charName) .. ' Stats', SCRIPT_PARAM_ONOFF, false);
		else
			theMenu:addParam(GetWordFromNumber(_), 'Draw Enemy ' .. GetChampionFriendlyName(gSummoners[_].charName) .. ' Stats', SCRIPT_PARAM_ONOFF, false);
		end;
	end;
end;

function encodeForURL(tString)
	if (tString) then
		tString = string.gsub(tString, '\n', '\r\n');
		tString = string.gsub(tString, '([^%w %-%_%.%~])', function (vS) return string.format('%%%02X', string.byte(vS)) end);
		tString = string.gsub(tString, ' ', '+');
	end;
	
	return tString;
end;

function ShowSummonerData(summonerToCheck)
	if (not gSummoners[summonerToCheck]) then
		print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Could Not Read Index ' .. summonerToCheck .. ' Data</font>');
	elseif (not summonersData[gSummoners[summonerToCheck].name]) then
		print('<font color="#FF1493"><b>[p_summonerStats]</b> </font><font color="#FF0000">Could Not Read ' .. GetChampionFriendlyName(gSummoners[summonerToCheck].charName) .. ' Data</font>');
	else
		local summonerData = summonersData[gSummoners[summonerToCheck].name];
		drawSummoner = summonerData;
	end;
end;

function ResetOptions(toCheck)
	if (toCheck ~= 1) then
		theMenu.One = false;
	end;
	
	if (toCheck ~= 2) then
		theMenu.Two = false;
	end;
	
	if (toCheck ~= 3) then
		theMenu.Three = false;
	end;
		
	if (toCheck ~= 4) then
		theMenu.Four = false;
	end;
		
	if (toCheck ~= 5) then
		theMenu.Five = false;
	end;
		
	if (toCheck ~= 6) then
		theMenu.Six = false;
	end;
		
	if (toCheck ~= 7) then
		theMenu.Seven = false;
	end;
		
	if (toCheck ~= 8) then
		theMenu.Eight = false;
	end;
		
	if (toCheck ~= 9) then
		theMenu.Nine = false;
	end;
	
	lastOption = toCheck;
end;

function GetWordFromNumber(theNumber)
	local numbersTable = {
		[1] = 'One',
		[2] = 'Two',
		[3] = 'Three',
		[4] = 'Four',
		[5] = 'Five',
		[6] = 'Six',
		[7] = 'Seven',
		[8] = 'Eight',
		[9] = 'Nine',
	};
	
	return ((numbersTable[theNumber]) and (numbersTable[theNumber]) or ('Unknown'));
end;

function GetChampionFriendlyName(rName)
	local friendlyNames = {
		['chogath'] = 'Cho\'Gath',
		['drmundo'] = 'Dr. Mundo',
		['fiddlesticks'] = 'Fiddlesticks',
		['jarvaniv'] = 'Jarvan IV',
		['khazix'] = 'Kha\'Zix',
		['kogmaw'] = 'Kog\'Maw',
		['leesin'] = 'Lee Sin',
		['masteryi'] = 'Master Yi',
		['missfortune'] = 'Miss Fortune',
		['monkeyking'] = 'Wukong',
		['reksai'] = 'Rek\'Sai',
		['tahmkench'] = 'Tahm Kench',
		['twistedfate'] = 'Twisted Fate',
		['velkoz'] = 'Vel\'Koz',
		['xinzhao'] = 'Xin Zhao',
	};
	
	return ((friendlyNames[rName:lower()]) and (friendlyNames[rName:lower()]) or (rName));
end;