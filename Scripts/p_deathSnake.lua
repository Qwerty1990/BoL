-- Developer: PvPSuite (http://forum.botoflegends.com/user/76516-pvpsuite/)

local sVersion = '1.1';
local rVersion = GetWebResult('raw.githubusercontent.com', '/pvpsuite/BoL/master/Versions/Scripts/p_deathSnake.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[p_deathSnake]</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/pvpsuite/BoL/master/Scripts/p_deathSnake.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[p_deathSnake]</b> </font><font color="#00FF00">Script has been updated, please reload!</font>');
		end);
		return;
	end;
else
	print('<font color="#FF1493"><b>[p_deathSnake]</b> </font><font color="#FF0000">Update Error</font>');
end;

local theMenu = nil;
local specialFood = nil;
local snakeOK = false;
local snakeVisible = false;
local snakePaused = true;
local showSnake = true;
local fullSnake = {};
local snakeDirections = {RIGHT = 1, LEFT = 2, UP = 3, DOWN = 4};
local initialPos = {X = 0, Y = 0};
local randomFood = {X = 0, Y = 0};
local initialParts = 3;
local snakeSizes = {[1] = 14, [2] = 28};
local snakeSize = snakeSizes[2];
local snakeSpeeds = {[1] = 150, [2] = 70, [3] = 50};
local tickDelay = snakeSpeeds[2];
local lastPauseTick = 0;
local lastShowTick = 0;
local lastTimeTick = 0;
local totalScore = 0;
local lastScore = 0;
local currentDirection = 0;

function OnLoad()
	print('<font color="#FF1493"><b>[p_deathSnake]</b> </font><font color="#00EE00">Loaded Successfully</font>'); 
	InitMenu();
	reloadSnake();
end;

function OnTick()
	if (showSnake) then
		if (snakeVisible) then
			if ((GetTickCount() - lastPauseTick) > tickDelay) then
				lastPauseTick = GetTickCount();
				if (theMenu.pauseResume) then
					snakePaused = not snakePaused;
					lastPauseTick = GetTickCount() + 200;
				end;
			end;
			
			if ((GetTickCount() - lastTimeTick) > tickDelay) then
				lastTimeTick = GetTickCount();
				if (not snakePaused) then
					moveSnake();
					
					if (snakeCollides()) then
						reloadSnake();
					end;
					
					if (theMenu.snakeRight) then
						if ((currentDirection ~= snakeDirections.LEFT) and (currentDirection ~= snakeDirections.RIGHT)) then
							currentDirection = snakeDirections.RIGHT;
							lastTimeTick = 0;
						end;
					elseif (theMenu.snakeLeft) then
							if ((currentDirection ~= snakeDirections.RIGHT) and (currentDirection ~= snakeDirections.LEFT)) then
								currentDirection = snakeDirections.LEFT;
								lastTimeTick = 0;
							end;
					elseif (theMenu.snakeUp) then
							if ((currentDirection ~= snakeDirections.DOWN) and (currentDirection ~= snakeDirections.UP)) then
								currentDirection = snakeDirections.UP;
								lastTimeTick = 0;
							end;
					elseif (theMenu.snakeDown) then
							if ((currentDirection ~= snakeDirections.UP) and (currentDirection ~= snakeDirections.DOWN)) then
								currentDirection = snakeDirections.DOWN;
								lastTimeTick = 0;
							end;
					end;
				end;
			end;
			
			if (not myHero.dead) then
				snakeVisible = false;
				snakePaused = true;
			end;
		elseif (not snakeVisible) then
				if (myHero.dead) then
					snakeVisible = true;
				end;
		end;
	end;
	
	if (myHero.dead) then
		if ((GetTickCount() - lastShowTick) > tickDelay) then
			lastShowTick = GetTickCount();
			if (theMenu.showHideSnake) then
				showSnake = not showSnake;
				snakePaused = true;
				lastShowTick = GetTickCount() + 200;
			end;
		end;
	end;
end;

function OnDraw()
	if ((showSnake) and (snakeOK) and (snakeVisible)) then
		DrawRectangle(0, 0, WINDOW_W, WINDOW_H, RGBA(0, 0, 0, 200));
		local drawText = 'Score: ' .. totalScore;
		if (lastScore ~= 0) then
			drawText = drawText .. ' (Last Score: ' .. lastScore .. ')';
		end;
		
		if (snakePaused) then
			drawText = drawText .. ' - PAUSED';
		end;
		
		DrawText(drawText, 40, 20, 20, RGB(255, 255, 255));
		
		local fColor = RGB(255, 69, 0);
		if (snakePaused) then
			fColor = RGB(150, 150, 150);
		end;
		
		for I = 1, #fullSnake do
			local sColor = RGB(0, 255 - (((I * 10) >= 230) and 230 or (I * 10)), 0);
			if (snakePaused) then
				sColor = RGB(255 - (((I * 10) >= 230) and 230 or (I * 10)), 255 - (((I * 10) >= 230) and 230 or (I * 10)), 255 - (((I * 10) >= 230) and 230 or (I * 10)));
			end;
			
			DrawRectangle(fullSnake[I].X, fullSnake[I].Y, snakeSize, snakeSize, sColor);
		end;
		
		if (specialFood ~= nil) then
			local sFColor = RGB(199, 21, 133);
			
			if (snakePaused) then
				sFColor = RGB(120, 120, 120);
			end;
			
			DrawRectangle(specialFood.X, specialFood.Y, (snakeSize / 2), (snakeSize / 2), sFColor);
		end;
		
		DrawRectangle(randomFood.X, randomFood.Y, (snakeSize / 2), (snakeSize / 2), fColor);
	end;
end;

function InitMenu()
	theMenu = scriptConfig('p_deathSnake', 'p_deathSnake');
	theMenu:addParam('showHideSnake', 'Show / Hide Snake', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('T'));
	theMenu:addParam('snakeUp', 'Snake Up', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('W'));
	theMenu:addParam('snakeDown', 'Snake Down', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('S'));
	theMenu:addParam('snakeLeft', 'Snake Left', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('A'));
	theMenu:addParam('snakeRight', 'Snake Right', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('D'));
	theMenu:addParam('pauseResume', 'Pause / Resume Snake', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('B'));
	theMenu:addParam('snakeSpeed', 'Snake Speed', SCRIPT_PARAM_LIST, 2, {[1] = 'Slow', [2] = 'Normal', [3] = 'Fast'});
	theMenu:addParam('snakeSize', 'Snake Size', SCRIPT_PARAM_LIST, 2, {[1] = 'Small', [2] = 'Big'});
end;

function reloadSnake()
	tickDelay = snakeSpeeds[theMenu.snakeSpeed];
	snakeSize = snakeSizes[theMenu.snakeSize];
	snakePaused = true;
	snakeOK = false;
	
	math.randomseed(os.clock());
	
	fullSnake = {};
	lastScore = totalScore;
	totalScore = 0;
	currentDirection = snakeDirections.RIGHT;
	initialPos = {X = -5 - (initialParts * snakeSize), Y = 80};
	randomFood = getRandomFood(false);
	specialFood = nil;
	
	for I = 1, initialParts do
		fullSnake[#fullSnake + 1] = {X = initialPos.X + (I * snakeSize), Y = initialPos.Y};
	end;
	
	fullSnake = reverseTable(fullSnake);
	
	for I = 1, #fullSnake do
		moveSnake();
	end;
	
	snakeOK = true;
end;

function moveSnake()
	local tX = fullSnake[1].X;
	local tY = fullSnake[1].Y;

	if (currentDirection == snakeDirections.RIGHT) then
		 tX = tX + snakeSize + 1;
	elseif (currentDirection == snakeDirections.LEFT) then
			tX = tX - snakeSize - 1;
	elseif (currentDirection == snakeDirections.UP) then
			tY = tY - snakeSize - 1;
	elseif (currentDirection == snakeDirections.DOWN) then
			tY = tY + snakeSize + 1;
	end;

	local sT = {X = tX, Y = tY};

	if (GetDistance({x = tX, y = tY}, {x = randomFood.X, y = randomFood.Y}) <= snakeSize) then
		randomFood = getRandomFood(false);
		totalScore = totalScore + 200 - tickDelay + snakeSize;
	elseif ((specialFood ~= nil) and (GetDistance({x = tX, y = tY}, {x = specialFood.X, y = specialFood.Y}) <= snakeSize)) then
			randomFood = getRandomFood(false);
			totalScore = totalScore + 250 - tickDelay + snakeSize;
			
			table.insert(fullSnake, 1, sT);
			
			tX = fullSnake[1].X;
			tY = fullSnake[1].Y;
			
			if (currentDirection == snakeDirections.RIGHT) then
				 tX = tX + snakeSize + 1;
			elseif (currentDirection == snakeDirections.LEFT) then
					tX = tX - snakeSize - 1;
			elseif (currentDirection == snakeDirections.UP) then
					tY = tY - snakeSize - 1;
			elseif (currentDirection == snakeDirections.DOWN) then
					tY = tY + snakeSize + 1;
			end;
			
			sT = {X = tX, Y = tY};
	else
		fullSnake[#fullSnake] = nil;
	end;

	table.insert(fullSnake, 1, sT);
end;

function roundN(tN, tIDP)
	local iMult = (10 ^ (tIDP or 0));
	return (math.floor(tN * iMult + 1/2) / iMult);
end;

function snakeCollides()
	local headX = fullSnake[1].X;
	local headY = fullSnake[1].Y;
	local cR = snakeSize;
	
	if (snakeSize == snakeSizes[3]) then
		cR = 0;
	end;
	
	if (headX < - cR) then
		return true;
	end;
	
	if (headX > (WINDOW_W - cR)) then
		return true;
	end;
	
	if (headY < 0) then
		return true;
	end;
	
	if (headY > (WINDOW_H - cR)) then
		return true;
	end;
	
	for I = 2, #fullSnake do
		if ((headX == fullSnake[I].X) and (headY == fullSnake[I].Y)) then
			return true;
		end;
	end;
	
	return false;
end;

function getRandomFood(itsSpecial)
	if ((not itsSpecial) and (totalScore >= 500)) then
		if (math.random(1, 1000) >= 500) then
			specialFood	= getRandomFood(true);
		else
			specialFood = nil;
		end;
	end;

	local foodLocs = {X = roundN(math.random((snakeSize * 3) + 80, WINDOW_W - (snakeSize * 3))), Y = math.random((snakeSize * 3) + 80, WINDOW_H - (snakeSize * 3))};
	
	if ((not itsSpecial) and (specialFood ~= nil)) then
		if (GetDistance({x = specialFood.X, y = specialFood.Y}, {x = foodLocs.X, y = foodLocs.Y}) <= snakeSize) then
			return getRandomFood(itsSpecial);
		end;
	end;
	
	for I = 1, #fullSnake do
		if (GetDistance({x = fullSnake[I].X, y = fullSnake[I].Y}, {x = foodLocs.X, y = foodLocs.Y}) <= snakeSize) then
			return getRandomFood(itsSpecial);
		end;
	end;
	
	return foodLocs;
end;

function reverseTable(theInput)
    local reversedTable = {};
    local itemCount = #theInput;
    for tK, tV in ipairs(theInput) do
        reversedTable[itemCount + 1 - tK] = tV;
    end;
    return reversedTable;
end;
