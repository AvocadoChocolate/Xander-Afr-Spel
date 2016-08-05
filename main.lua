---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- require the composer library
local composer = require "composer"

-- load scene1


-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)
local bg = display.newImage("background.png")
bg.anchorX =0
bg.anchorY =0
bg:scale(display.contentWidth/bg.contentWidth,display.contentHeight/bg.contentHeight)
bg:toBack()
----------------------------------------------------------------------------------------------------------
--Load gloabal varibales for current player first element in players.txt will be current player.
--When Player is made current addandsaveplayers so its at top for next load
----------------------------------------------------------------------------------------------------------

math.randomseed( os.time() )
word = nil
function getPlayers()
	local playersList = {}
	-- Path for the file to read
	local path = system.pathForFile( "players.txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
		-- Error occurred; output the cause
		print( "File error: " .. errorString )
	else
		-- Output lines
		i = 1
		x = 1
		local val ={}
		for line in file:lines() do
			
			if((i+3) - math.floor((i+3)/4)*4==0)then
				val.name = line
			elseif((i+2) - math.floor((i+2)/4)*4==0) then
				val.grade = line
			elseif((i+1) - math.floor((i+1)/4)*4==0) then
				val.correct = line
			elseif(i - math.floor(i/4)*4==0)then
				val.incorrect = line
				playersList[x] = val
				val ={}
				x = x+1
			end
			i = i+1
		end
		-- Close the file handle
		io.close( file )
	end

	file = nil
	return playersList
end
function addAndSavePlayers(playersList)
	
	-- Path for the file to write
	local path = system.pathForFile( "players.txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "w" )

	if not file then
		-- Error occurred; output the cause
		print( "File error: " .. errorString )
	else
		-- Write data to file
		for i=1,#playersList do
			file:write( playersList[i].name )
			file:write("\n")
			file:write( playersList[i].grade )
			file:write("\n")
			file:write( playersList[i].correct )
			file:write("\n")
			file:write( playersList[i].incorrect )
			file:write("\n")
			
		end
		-- Close the file handle
		io.close( file )
	end

	file = nil
end
local players = getPlayers()
if(players[1]==nil)then
	player = ""
	grade =""
	correct = 0
	incorrect = 0
	cur = 0
else
	player = players[1].name
	grade =players[1].grade
	correct = players[1].correct
	incorrect = players[1].incorrect
	cur = 1
end
composer.gotoScene( "menu" )
function addAndSaveIncorrectWords(wordsList)
	
	-- Path for the file to write
	local path = system.pathForFile( player..".txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "w" )

	if not file then
		-- Error occurred; output the cause
		print( "File error: " .. errorString )
	else
		-- Write data to file
		
		for i=1,#wordsList do
			file:write( wordsList[i] )
			file:write("\n")
		end
	
		-- Close the file handle
		io.close( file )
	end

	file = nil
end
function getIncorrectWords()
	local wordsList = {}
	-- Path for the file to read
	local path = system.pathForFile( player..".txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
		-- Error occurred; output the cause
		print( "File error: " .. errorString )
	else
		-- Output lines
		i = 1
		for line in file:lines() do
			wordsList[i] = line
			i=i+1
		end
		-- Close the file handle
		io.close( file )
	end

	file = nil
	return wordsList
end
local function screenshot()

        --I set the filename to be "widthxheight_time.png"
        --e.g. "1920x1080_20140923151732.png"
        local date = os.date( "*t" )
        local timeStamp = table.concat({date.year .. date.month .. date.day .. date.hour .. date.min .. date.sec})
        local fname = display.pixelWidth.."x"..display.pixelHeight.."_"..timeStamp..".png"

        --capture screen
        local capture = display.captureScreen(false)

        --make sure image is right in the center of the screen
        capture.x, capture.y = display.contentWidth * 0.5, display.contentHeight * 0.5

        --save the image and then remove
        local function save()
                display.save( capture, { filename=fname, baseDir=system.DocumentsDirectory, isFullResolution=true } )
                capture:removeSelf()
                capture = nil
        end
        timer.performWithDelay( 100, save, 1)

        return true
end


--works in simulator too
local function onKeyEvent(event)
        if event.phase == "up" then
                --press s key to take screenshot which matches resolution of the device
				local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
            if event.keyName == "s" then
				print("snap")
                screenshot()
            end
        end
end

Runtime:addEventListener("key", onKeyEvent)