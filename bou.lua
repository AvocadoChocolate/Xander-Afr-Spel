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
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local word =""
local vowels = {"a","e","i","o","u","y"}
local prevWords = {}
local pieces = {}
local tospell = {}
local linesGroup = display.newGroup()
local function getNextWord()
	local r 
	local word 
	local check = true
	while(check)do
		check = false
		r = math.random(300)
		word = gr3.getWord(r)
		for i=1,#prevWords do
			if word == prevWords[i] then
				check =true
			end
		end
	end
	word = string.gsub( word, "%-","")
	word = string.lower( word )
	return word
end
local function hasCollided( obj1, obj2 )
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return (left or right) and (up or down)
end
local function isConsonant(letter)
	local cons = true
	for i=1,#vowels do
		if(letter == vowels[i] )then
			cons =false
		end
	end
	return cons
end
local function splitDoubleConsonants(w)
	local doubleC = false
	local split1 =""
	local split2 =""
	local l = string.len(w)-2
	
	
	if(isConsonant(w:sub(1,1))==false)then
		if(l<=2) then
			return
		end
		for i = 2,l do
			if(isConsonant(w:sub(i,i)) and isConsonant(w:sub(i+1,i+1)))then
				split1 = w:sub(1,i)
				split2 = w:sub(i+1,string.len(w))
				return split1,split2
			end
		end
	else	
		if(l<=3) then
			return
		end
		for i = 3,l do
			if(isConsonant(w:sub(i,i)) and isConsonant(w:sub(i+1,i+1)))then
				split1 = w:sub(1,i)
				split2 = w:sub(i+1,string.len(w))
				return split1,split2
			end
		end
	end
	
end
local function splitFirstVowel(w)
	
	local fVowel = false
	local split1 =""
	local split2 =""
	local l = string.len(w)-1
	for i = 2,l do
		if(isConsonant(w:sub(i,i))==false)then
			split1 = w:sub(1,i)
			split2 = w:sub(i+1,string.len(w))
			return split1,split2
		end
	end
end
local function splitCheck(splitWord)
	
	if(string.len(splitWord)<6)then
		pieces[#pieces+1]=splitWord
	else
		local s1,s2 = splitDoubleConsonants(splitWord)
		if(s1 ~= nil and s2 ~= nil)then
			
			splitCheck(s1)
			splitCheck(s2)
		else
			--split on first vowel
			local s1,s2 = splitFirstVowel(splitWord)
			if(s1 ~= nil and s2 ~= nil)then
				splitCheck(s1)
				splitCheck(s2)
			end
		end
	end
end
local function drawLines()
	linesGroup.anchorChildren = true
	linesGroup.anchorX = 0.5
	linesGroup.anchorY = 0
	linesGroup.x = display.contentWidth / 2
	linesGroup.y = display.contentHeight - yInset *4
	
	local i =1
	for k=1,#pieces do
		
		local part = pieces[k]
		local wordSize = string.len(part)
		
		for j=1,wordSize do
			print()
			local dash = display.newLine(i*(xInset),yInset*5, i*(xInset) + 15,yInset*5)
			dash:setStrokeColor(255/255, 51/255, 204/255)
			dash.strokeWidth = 2
			linesGroup:insert(dash)
			local options = 
			{
				--parent = textGroup,
				text = " ",     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = native.systemFontBold,   
				fontSize = 20,
				align = "right"  --new alignment parameter
			}

			local myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.alpha = 1
			myText.x = i*(xInset)
			myText.y = yInset * 3.5
			myText:setFillColor( 0, 0, 0 )
			myText.pos = k
			tospell[i] = myText
			linesGroup:insert(tospell[i])
			i=i+1
		end
	end
end
local function drag( event )
	
    if event.phase == "began" then
	
        markX = event.target.x    -- store x location of object
        markY = event.target.y    -- store y location of object
		display.getCurrentStage():setFocus( event.target )
    elseif event.phase == "moved" then
	
        local x = (event.x - event.xStart) + markX
        local y = (event.y - event.yStart) + markY
        
        event.target.x, event.target.y = x, y    -- move object based on calculations above
    elseif event.phase == "ended" or event.phase == "cancelled" then
        event.target.alpha = 1
		for i=1,#tospell do
			if hasCollided(event.target,tospell[i]) then
				if event.target.pos == tospell[i].pos then
					for j =1,#tospell do
						if(tospell[j].pos == tospell[i].pos)then
							tospell[j].text = word:sub(j,j)
							event.target.alpha = 0
						end
					end
				end
			end
		end
        display.getCurrentStage():setFocus(nil)
    end
    
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
        local bg = display.newImage("background.png")
	    bg.anchorX =0
	    bg.anchorY =0
	    bg:setFillColor(1)
	    sceneGroup:insert(bg)
	    word = getNextWord()
		
		print(word)
		local s1,s2 = splitDoubleConsonants(word)
		if(s1 ~= nil and s2 ~= nil)then
			
			splitCheck(s1)
			splitCheck(s2)
		else
			--split on first vowel
			local s1,s2 = splitFirstVowel(word)
			if(s1 ~= nil and s2 ~= nil)then
				splitCheck(s1)
				splitCheck(s2)
			end
		end
		drawLines()
		for i=1,#pieces do
			local r = math.random(5)
			local options = 
			{
				--parent = textGroup,
				text = pieces[i],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = native.systemFontBold,   
				fontSize = 36,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.alpha = 1
			myText.x = xInset*2*r
			myText.y = yInset*3*i 
			myText.pos = i
			myText:setFillColor( 0, 0, 0 )
			--myText:rotate( 90 )
			sceneGroup:insert(myText)
			myText:addEventListener( "touch", drag )
		end
		--sceneGroup:rotate( 90 )
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