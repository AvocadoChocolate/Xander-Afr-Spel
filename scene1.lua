---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local gr3 = require("g3")
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------
local counter = 1
local rows = 10
local curRow = 1
local columns = 10
local curColumn = 1
local swearwordfilter ={"vok","fok","poes","kak","doos","kont","fuck","cunt","dick","ass"}
local words ={"een","twee","drie","vier","vyf"}
local matrix ={}
for c=1,columns do
	matrix[c] ={}
	for r=1,rows do
		matrix[c][r] = 0
	end
end

local function nextStep()
	if(curColumn==columns)then
		curRow = curRow + 1
		if(curRow>rows)then
			curRow = 1
		end
		curColumn = 1
	else
		curColumn= curColumn+1
	end
end
local function tryHPlacement()
	if(curRow<(rows - #words[counter])+1)then
	--place word
		local placement = true
		for i=1,#words[counter] do
			
			if(matrix[curColumn][curRow]~=0 and matrix[curColumn][curRow]~=words[counter]:sub(i,i))then
				placement = false
			end

			
		end
		
		if(placement)then
			for i=1,#words[counter] do
				matrix[curColumn][curRow] = words[counter]:sub(i,i)
				curRow=curRow+1
			end
			counter=counter+1
		end
	else
		if(curColumn<(columns - #words[counter])+1)then
		--place word
		else
		nextStep()
		end
	end
end
local function tryVPlacement()
	if(curColumn<(columns - #words[counter])+1)then
	--place word
		local placement = true
		for i=1,#words[counter] do
			
			if(matrix[curColumn][curRow]~=0 and matrix[curColumn][curRow]~=words[counter]:sub(i,i))then
				placement = false
			end
			
			--myText:setFillColor( 1, 0, 0 )
			
		end
		if(placement)then
			for i=1,#words[counter] do
				matrix[curColumn][curRow] = words[counter]:sub(i,i)
				curColumn=curColumn+1
			end
			counter=counter+1
		end
	else
		if(curRow<(rows - #words[counter])+1)then
		--place word
		else
			nextStep()
		end
	end
end
local function myTapListener( event )

    -- Code executed when the button is tapped
    print( "object tapped = "..tostring(event.target.tag) )  -- "event.target" is the tapped object
    return true
end
function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
        
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
        
        -- we obtain the object by id from the scene's object hierarchy
       local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)
	   bg.anchorX =0
	   bg.anchorY =0
	   bg:setFillColor(1)
	   
	   
	   while(counter~=#words +1)do
		   if(math.random()>0.1)then
				--Go to next step
				nextStep()
		   else
				--Place horizontal or vertical
				 if(math.random()>0.5)then
					tryHPlacement()
				 else
					tryVPlacement()
				 end
		   end
	   end
	   local str="aaaabbbbbcddddeeeefgggghhhhiiiiijkkkkllllmmmmnnnnoooooppppqrrrrssstttttuuvvvwwwxyyyz"
	   local checkLetter
	   
	   print()
	   for c = 1,columns do
			for r = 1,rows do
			if(matrix[c][r]==0)then
				local randomL = string.char(str:byte(math.random(1, #str)))
				if(checkLetter~=nil)then
					while(randomL=="s" or randomL=="a" or randomL=="e" or randomL=="i" or randomL=="o" or randomL=="u")do
						randomL = string.char(str:byte(math.random(1, #str)))
					end
				end
				if(randomL == "v")then
					checkLetter = randomL
				elseif(randomL == "f") then
					checkLetter = randomL
				elseif(randomL == "k") then
					checkLetter = randomL
				elseif(randomL == "a") then
					checkLetter = randomL
				elseif(randomL == "s") then
					checkLetter = randomL
				else
					checkLetter = nil
				end
				matrix[c][r] = randomL
			end
			local smallRect = display.newRect(0,0,18,18)
			smallRect.alpha=0.5
			--smallRect:setFillColor(0.5)
			smallRect.anchorX =0
			smallRect.anchorY =0
			smallRect.x = c*18
			smallRect.y = r*18
			smallRect.tag = matrix[c][r]
			smallRect:addEventListener( "tap", myTapListener )
			local options = 
			{
				--parent = textGroup,
				text = matrix[c][r],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = native.systemFontBold,   
				fontSize = 18,
				align = "right"  --new alignment parameter
			}

			local myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.x = c*18
			myText.y = r*18
			myText:setFillColor( 1, 0, 0 )
			end
	   end
	   -- local word = gr3.maxlength()
	   -- for i=1,#word do
			-- local options = 
			-- {
				-- --parent = textGroup,
				-- text = word:sub(i,i),     
				-- --x = 0,
				-- --y = 200,
				-- --width = 128,     --required for multi-line and alignment
				-- font = native.systemFontBold,   
				-- fontSize = 18,
				-- align = "right"  --new alignment parameter
			-- }

			-- local myText = display.newText( options )
			-- myText.anchorX =0
			-- myText.anchorY =0
			-- myText.x = i*18
			-- myText:setFillColor( 1, 0, 0 )
        -- end
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
		
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
