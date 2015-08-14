-- Developer: PvPSuite (http://forum.botoflegends.com/user/76516-pvpsuite/)

local sVersion = '1.1';
local rVersion = GetWebResult('raw.githubusercontent.com', '/pvpsuite/BoL/master/Versions/Scripts/p_VLC.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/pvpsuite/BoL/master/Scripts/p_VLC.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#00FF00">Script has been updated, please reload!</font>');
		end);
		return;
	end;
else
	print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FF0000">Update Error</font>');
end;

if (not FileExist(BOL_PATH .. 'p_VLCHelper.exe')) then
	print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FF0000">VLC Helper Not Found</font>');
	return;
elseif (not FileExist(BOL_PATH .. 'p_VLCHelper\\currentSong.txt')) then
		print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FF0000">Current Song Not Found</font>');
		return;
elseif (not FileExist(BOL_PATH .. 'p_VLCHelper\\lastAction.txt')) then
		print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FF0000">Last Action Not Found</font>');
		return;
end;

local playSprite = nil;
local pauseSprite = nil;
local nextSprite = nil;
local previousSprite = nil;
local volumeUpSprite = nil;
local volumeDownSprite = nil;
local backgroundSprite = nil;
local lastPlayedSong = nil;
local theMenu = nil;
local isPaused = false;
local commandProcessing = false;
local readyToShow = false;
local readingSong = false;
local suspendPlayer = false;
local lastTimeActionCalled = 0;
local lastTimePlayerReload = 0;
local sleepDelay = 200;
local backgroundW = 280;
local backgroundH = 80;
local buttonW = 32;
local buttonH = 32;
local buttonSpacingW = 40;
local buttonMarginTop = 74;

function OnLoad()
	playSprite = createSprite('p_VLC\\play.png');
	pauseSprite = createSprite('p_VLC\\pause.png');
	nextSprite = createSprite('p_VLC\\next.png');
	previousSprite = createSprite('p_VLC\\previous.png');
	volumeUpSprite = createSprite('p_VLC\\volumeup.png');
	volumeDownSprite = createSprite('p_VLC\\volumedown.png');
	backgroundSprite = createSprite('p_VLC\\background.png');
	
	InitMenu();
	
	sendVLCCommand('stop');
	
	sleepDelay = 200;
	lastTimeActionCalled = GetTickCount();
	readCurrentSong();
	isPaused = ((isPaused) or (lastPlayedSong == 'VLC media player') or (lastPlayedSong == ''));
	commandProcessing = false;
	
	print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#00EE00">Loaded Successfully</font>');
	
	readyToShow = true;
end;

function OnUnload()
	sendVLCCommand('stop');
end;

function OnTick()
	if (not suspendPlayer) then
		if ((GetTickCount() - lastTimeActionCalled) > sleepDelay) then
			sleepDelay = 200;
			lastTimeActionCalled = GetTickCount();
			readCurrentSong();
			isPaused = ((isPaused) or (lastPlayedSong == 'VLC media player') or (lastPlayedSong == ''));
			commandProcessing = false;
			if ((readingSong) and (isPaused)) then
				suspendPlayer = true;
				print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FF0000">Could Not Read Song</font>');
			end;
			
			if (not readyToShow) then
				readyToShow = true;
				print('<font color="#FF1493"><b>[p_VLC]</b> </font><font color="#FFA500">VLC Player Reloaded</font>');
			end;
		end;
		
		if (theMenu.reloadPlayer) then
			if ((GetTickCount() - lastTimePlayerReload) > 1500) then
				lastTimePlayerReload = GetTickCount();
				reloadPlayer();
			end;
		end;
	end;
end;

function OnDraw()
	if ((theMenu.showPlayer) and (readyToShow)) then
		if (backgroundSprite ~= nil) then
			backgroundSprite:Draw(theMenu.drawW, theMenu.drawH, theMenu.playerOpacity);
		end;
		
		if (volumeUpSprite ~= nil) then
			volumeUpSprite:Draw((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) + (buttonSpacingW * 2)), (theMenu.drawH + buttonMarginTop- buttonH), theMenu.playerOpacity);
		end;
		
		if (nextSprite ~= nil) then
			nextSprite:Draw((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) + buttonSpacingW), (theMenu.drawH + buttonMarginTop - buttonH), theMenu.playerOpacity);
		end;
		
		if (isPaused) then
			if (playSprite ~= nil) then
				playSprite:Draw((theMenu.drawW + (backgroundW / 2) - (buttonW / 2)), (theMenu.drawH + buttonMarginTop - buttonH), theMenu.playerOpacity);
			end;
		else
			if (pauseSprite ~= nil) then
				pauseSprite:Draw((theMenu.drawW + (backgroundW / 2) - (buttonW / 2)), (theMenu.drawH + buttonMarginTop - buttonH), theMenu.playerOpacity);
			end;
		end;
		
		if (previousSprite ~= nil) then
			previousSprite:Draw((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) - buttonSpacingW), (theMenu.drawH + buttonMarginTop- buttonH), theMenu.playerOpacity);
		end;
		
		if (volumeDownSprite ~= nil) then
			volumeDownSprite:Draw((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) - (buttonSpacingW * 2)), (theMenu.drawH + buttonMarginTop- buttonH), theMenu.playerOpacity);
		end;
		
		local theSong = 'No Song Playing';
		local theArtist = 'Made with <3 by PvPSuite';
		if (not isPaused) then
			if ((lastPlayedSong ~= nil) and (lastPlayedSong ~= 'VLC media player') and (lastPlayedSong ~= '')) then
				theArtist = '';
				theSong = splitTable(lastPlayedSong, '-');
				if ((theSong[1] ~= nil) and (#theSong > 1)) then
					theArtist = theSong[1];
					theSong = lastPlayedSong:gsub(theArtist .. '%-', '');
					theSong = theSong:gsub('^[^a-zA-Z]+', '');
					theArtist = theArtist:gsub('^%s*(.-)%s*$', '%1');
					readingSong = false;
				else
					theSong = lastPlayedSong;
					readingSong = false;
				end;
				if ((theSong == 'vlc') or (theArtist == 'vlc') or (theSong == 'N/A') or (theArtist == 'N/A')) then
					theSong = 'No Song Playing';
					theArtist = 'Made with <3 by PvPSuite';
					readingSong = false;
					isPaused = true;
				end;
			else
				theSong = 'Reading Song...';
				readingSong = true;
			end;
		end;
		local theSongA = GetTextArea(theSong, 12);
		local theArtistA = GetTextArea(theArtist, 14);
		DrawText(theSong, 12, (theMenu.drawW + (backgroundW / 2) - (theSongA.x / 2)), theMenu.drawH + 5, RGBA(30, 30, 30, theMenu.playerOpacity));
		DrawText(theArtist, 14, (theMenu.drawW + (backgroundW / 2) - (theArtistA.x / 2)), theMenu.drawH + 20, RGBA(30, 30, 30, theMenu.playerOpacity));
	end;
end;

function OnWndMsg(kS, wParam)
	if ((theMenu.showPlayer) and (readyToShow)) then
		if ((kS == WM_LBUTTONUP) and (wParam == 0)) then
			if (not commandProcessing) then
				if (CursorIsUnder((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) + buttonSpacingW), (theMenu.drawH + buttonMarginTop - buttonH), buttonW, buttonH)) then
					if (not suspendPlayer) then
						nextTrack();
					end;
				elseif (CursorIsUnder((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) - buttonSpacingW), (theMenu.drawH + buttonMarginTop- buttonH), buttonW, buttonH)) then
						if (not suspendPlayer) then
							previousTrack();
						end;
				elseif (CursorIsUnder((theMenu.drawW + (backgroundW / 2) - (buttonW / 2)), (theMenu.drawH + buttonMarginTop - buttonH), buttonW, buttonH)) then
						if (isPaused) then
							playSong();
						else
							pauseSong();
						end;
				elseif (CursorIsUnder((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) + (buttonSpacingW * 2)), (theMenu.drawH + buttonMarginTop- buttonH), buttonW, buttonH)) then
						if (not suspendPlayer) then
							volumeUp();
						end;
				elseif (CursorIsUnder((theMenu.drawW + (backgroundW / 2) - (buttonW / 2) - (buttonSpacingW * 2)), (theMenu.drawH + buttonMarginTop- buttonH), buttonW, buttonH)) then
						if (not suspendPlayer) then
							volumeDown();
						end;
				end;
			end;
		end;
	end;
end;

function InitMenu()
	theMenu = scriptConfig('p_VLC', 'p_VLC');
	theMenu:addParam('showPlayer', 'Show VLC Player', SCRIPT_PARAM_ONOFF, true);
	theMenu:addParam('reloadPlayer', 'Reload VLC Player', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('T'));
	theMenu:addParam('playerOpacity', 'VLC Player Opacity', SCRIPT_PARAM_SLICE, 255, 80, 255, 0);
	theMenu:addParam('drawH', 'Screen H Position', SCRIPT_PARAM_SLICE, ((WINDOW_H - backgroundH) / 2), 0, (WINDOW_H - backgroundH), 0);
	theMenu:addParam('drawW', 'Screen W Position', SCRIPT_PARAM_SLICE, ((WINDOW_W - backgroundW) / 2), 0, (WINDOW_W - backgroundW), 0);
end;

function reloadPlayer()
	readyToShow = false;
	playSprite:Release();
	pauseSprite:Release();
	nextSprite:Release();
	previousSprite:Release();
	volumeUpSprite:Release();
	volumeDownSprite:Release();
	backgroundSprite:Release();
	playSprite = createSprite('p_VLC\\play.png');
	pauseSprite = createSprite('p_VLC\\pause.png');
	nextSprite = createSprite('p_VLC\\next.png');
	previousSprite = createSprite('p_VLC\\previous.png');
	volumeUpSprite = createSprite('p_VLC\\volumeup.png');
	volumeDownSprite = createSprite('p_VLC\\volumedown.png');
	backgroundSprite = createSprite('p_VLC\\background.png');
	
	sleepDelay = 200;
	lastTimeActionCalled = GetTickCount();
end;

function nextTrack()
	commandProcessing = true;
	sleepDelay = 250;
	lastTimeActionCalled = GetTickCount();
	sendVLCCommand('next');
end;

function previousTrack()
	commandProcessing = true;
	sleepDelay = 250;
	lastTimeActionCalled = GetTickCount();
	sendVLCCommand('previous');
end;

function volumeUp()
	commandProcessing = true;
	sleepDelay = 350;
	lastTimeActionCalled = GetTickCount();
	sendVLCCommand('volumeup');
end;

function volumeDown()
	commandProcessing = true;
	sleepDelay = 350;
	lastTimeActionCalled = GetTickCount();
	sendVLCCommand('volumedown');
end;

function pauseSong()
	isPaused = (not isPaused);
	commandProcessing = true;
	sleepDelay = 5000;
	lastTimeActionCalled = GetTickCount();
	sendVLCCommand('pause');
	suspendPlayer = false;
end;

function playSong()
	isPaused = (not isPaused);
	commandProcessing = true;
	sleepDelay = 5000;
	lastTimeActionCalled = GetTickCount();
	sendVLCCommand('play');
	suspendPlayer = false;
end;

function sendVLCCommand(theCommand)
	local tF = io.open(BOL_PATH .. 'p_VLCHelper\\lastAction.txt', 'w+');
	if (tF ~= nil) then
		tF:write(theCommand);
		tF:close();
	end;
end;

function setCurrentSong(theSong)
	local tF = io.open(BOL_PATH .. 'p_VLCHelper\\currentSong.txt', 'w+');
	if (tF ~= nil) then
		tF:write(theSong);
		tF:close();
	end;
end;

function readCurrentSong()
	local tF = io.open(BOL_PATH .. 'p_VLCHelper\\currentSong.txt', 'rb');
	if (tF ~= nil) then
		lastPlayedSong = tF:read('*a');
		tF:close();
	end;
end;

function splitTable(theInput, theSeparator)
	if (theSeparator == nil) then
		theSeparator = "%s";
	end;
	
	local theTable = {};
	local I = 1;
	
	for theString in string.gmatch(theInput, '([^' .. theSeparator .. ']+)') do
		theTable[I] = theString;
		I = I + 1;
	end;
	
	return theTable;
end;
