---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local gr3 = require("gr1")
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local word =""
local vowels = {"a","e","i","o","u","y"}
-- local h = 30
-- local w = 30
-- local blocks = {
-- {"a",h},
-- {"b",-2*h},
-- {"c",h},
-- {"d",-2*h},
-- {"e",h},
-- {"f",-2*h},
-- {"g",2*h},
-- {"h",-2*h},
-- {"i",-2*h},
-- {"j",2*h},
-- {"k",-2*h},
-- {"l",-2*h},
-- {"m",h},
-- {"n",h},
-- {"o",h},
-- {"p",2*h},
-- {"q",2*h},
-- {"r",h},
-- {"s",h},
-- {"t",-2*h},
-- {"u",h},
-- {"v",h},
-- {"w",h},
-- {"x",h},
-- {"y",2*h},
-- {"z",h}
-- }
local prevWords = {}
local pieces = {}
local mpieces = {}
local tospell = {}
local counter = 1
local wordsGroup = display.newGroup()
local linesGroup = display.newGroup()
local bouGroup = display.newGroup()
local function gotoHome(event)
	--composer.gotoScene("menu")
	transition.to(bouGroup,{time=500,y =  display.contentHeight,onComplete = function() 
	composer.gotoScene("menu",{time = 500,effect="fromTop"}) 
	transition.to(bouGroup,{time=1500,y = 0,onComplete = function() 
	bouGroup:removeSelf()
	bouGroup = nil
	bouGroup = display.newGroup()
	linesGroup:removeSelf()
	linesGroup = nil
	linesGroup = display.newGroup()
	bouGroup:insert(linesGroup)
	wordsGroup:removeSelf()
	wordsGroup = nil
	wordsGroup = display.newGroup()
	bouGroup:insert(wordsGroup)
	pieces = {}
	mpieces ={}
	tospell = {}
	
	end})
	end})
	
	return true
end

local function getNextWord()
	local r 
	local word 
	local check = true
	while(check)do
		check = false
		r = math.random(100)
		word = gr3.getWord(r)
		for i=1,#prevWords do
			if(string.len(word)<3) then
				check =true
			end
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
local function splitMCheck(splitWord)
	
	if(string.len(splitWord)<6)then
		mpieces[#mpieces+1]=splitWord
	else
		local m1,m2 = splitDoubleConsonants(splitWord)
		if(m1 ~= nil and m2 ~= nil)then
			
			splitMCheck(m1)
			splitMCheck(m2)
		else
			--split on first vowel
			local m1,m2 = splitFirstVowel(splitWord)
			if(m1 ~= nil and m2 ~= nil)then
				splitMCheck(m1)
				splitMCheck(m2)
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
				font = TeachersPet,   
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

local function Next()
		word = getNextWord()
		mockWord = getNextWord()
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
		local m1,m2 = splitDoubleConsonants(mockWord)
		if(m1 ~= nil and m2 ~= nil)then
			
			splitMCheck(m1)
			splitMCheck(m2)
		else
			--split on first vowel
			local m1,m2 = splitFirstVowel(mockWord)
			if(m1 ~= nil and m2 ~= nil)then
				splitMCheck(m1)
				splitMCheck(m2)
			end
		end
		
		local function drag( event )
			if event.phase == "began" then
				collided = false
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
									collided = true
								end
							end
						end
					end
				end
				display.getCurrentStage():setFocus(nil)
				print(#pieces)
				if(collided)then
					if(counter == #pieces)then
						linesGroup:removeSelf()
						linesGroup = nil
						linesGroup = display.newGroup()
						bouGroup:insert(linesGroup)
						wordsGroup:removeSelf()
						wordsGroup = nil
						wordsGroup = display.newGroup()
						bouGroup:insert(wordsGroup)
						pieces = {}
						mpieces ={}
						tospell = {}
						Next()
						counter = 1
					else
						counter = counter + 1
					end
				
				end
			end
			
			return true
		end
		
		
		for i=1,#pieces do
			-- local pieceGroup = display.newGroup()
			local r = math.random(5)
			-- for j=1,string.len(pieces[i]) do
				-- local x = 0
				-- local letter = pieces[i]:sub(j,j)
				-- for k = 1,#blocks do
					-- if(blocks[k][1]==letter)then
						-- if(blocks[k][2] == h)then
							-- height = blocks[k][2]
						-- elseif(blocks[k][2] == 2*h)then
							-- height = h + 0.5*h
						-- elseif(blocks[k][2] == -2*h)then
							-- height =  - h - 0.5*h
							-- x = h
						-- end
					-- end
				-- end
				
				-- local block = display.newRect(prevW,x,w,height)
				-- block.anchorX = 0
				-- block.anchorY = 0
				-- pieceGroup:insert(block)
				
				-- local options = 
				-- {
					-- --parent = textGroup,
					-- text = letter,     
					-- --x = 0,
					-- --y = 200,
					-- --width = 128,     --required for multi-line and alignment
					-- font = TeachersPet,   
					-- fontSize = 36,
					-- align = "right"  --new alignment parameter
				-- }

				-- myText = display.newText( options )
				-- myText.anchorX =0.5
				-- myText.anchorY =0.2
				-- myText:setFillColor(1,0,0)
				-- myText.x = prevW + 18
				-- myText.alpha = 1
				-- pieceGroup:insert(myText)
				-- pieceGroup.x = xInset*(r+3)
				-- pieceGroup.y = yInset*3*i
				-- prevW = prevW + w
			-- end
			local options = 
			{
				--parent = textGroup,
				text = pieces[i],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = TeachersPet,   
				fontSize = 36,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.alpha = 1
			if(i<5)then
				myText.x = xInset*(r+3)
				myText.y = yInset*3*i 
			else
				myText.x = xInset*(r + 10)
				myText.y = yInset*3*(i - 5)
			end
			myText.pos = i
			p = i
			myText:setFillColor( 0, 0, 0 )
			--myText:rotate( 90 )
			wordsGroup:insert(myText)
			
			myText:addEventListener( "touch", drag )
		end
		if(#pieces < 5)then
			for i=1,#mpieces do
				local r = math.random(5)
				local options = 
				{
					--parent = textGroup,
					text = mpieces[i],     
					--x = 0,
					--y = 200,
					--width = 128,     --required for multi-line and alignment
					font = TeachersPet,   
					fontSize = 36,
					align = "right"  --new alignment parameter
				}

				myText = display.newText( options )
				myText.anchorX =0
				myText.anchorY =0
				myText.alpha = 1
				myText.x = xInset*(r + 10)
				myText.y = yInset*3*i
				--myText.pos = i
				myText:setFillColor( 0, 0, 0 )
				--myText:rotate( 90 )
				wordsGroup:insert(myText)
				
				myText:addEventListener( "touch", drag )
			end	
		end
		
		
end
function scene:create( event )
    sceneGroup = self.view

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
		menuGroup = display.newGroup()
		local mCircle = display.newImage("Icon1.png")
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		bouGroup:insert(menuGroup)
		
		Next()
	    bouGroup:insert( wordsGroup )
		bouGroup:insert( linesGroup )
		sceneGroup:insert(bouGroup)
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
