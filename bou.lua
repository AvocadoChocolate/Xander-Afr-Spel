---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local gr3
if(grade == "1")then
gr3 = require("gr1")
else
 gr3 = require("gr2")
end
local grTotal = gr3.total()
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local word =""
local xanderGroup = display.newGroup()
local vowels = {"a","e","i","o","u","y"}
local colors ={{51/255, 204/255, 51/255},
{0/255, 153/255, 255/255},
{255/255, 153/255, 51/255},
{255/255, 255/255, 51/255},
{204/255, 102/255, 255/255}
}
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
local canvas ={}
local pieces = {}
local mpieces = {}
local tospell = {}
local counter = 1
local wordsGroup = display.newGroup()
local linesGroup = display.newGroup()
local bouGroup = display.newGroup()
local wordSound
local wordChannel
local isPlaying = false
local wordComplete = false
local function gotoHome(event)
	--composer.gotoScene("menu")
	
	print(isPlaying)
	if(isPlaying == false and wordComplete==false)then
	transition.to(menuGroup,{time = 100, alpha = 0,onComplete =function() 
			transition.to(menuGroup,{time = 100, alpha = 1})
			end})
	transition.to(bouGroup,{time=500,y =  -2*display.contentHeight,onComplete = function() 
	transition.to(bouGroup,{time=500,y =  0,onComplete = function() 
	
	end})
	
	end})
	composer.gotoScene("menu",{time = 500,effect="fromBottom"}) 
	end
	return true
end

local function getNextWord()
	local r 
	local word 
	local check = true
	while(check)do
		check = false
		r = math.random(grTotal )
		word = gr3.getWord(r)
		
		if(string.len(word)<3) then
				check =true
		end
		for i=1,#prevWords do
			if word == prevWords[i] then
				print(i)
				check =false
			end
		end
	end
	
	word = string.gsub( word, "%-","")
	word = string.lower( word )
	if(#prevWords < 5) then
		prevWords[#prevWords+1] = word
	else
		prevWords = {}
		prevWords[#prevWords+1]= word
		
	end
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
	
	if(string.len(splitWord)<4)then
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
	
	if(string.len(splitWord)<4)then
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
				font = "TeachersPet",   
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
		mock2Word = getNextWord()
		isPlaying = true
		
		timer.performWithDelay(500,function()
		wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
		wordChannel = audio.play( wordSound ,{onComplete= function() isPlaying = false end})
		wordComplete = false
		end)
		--print(word)
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
		--drawLines()
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
		local m21,m22 = splitDoubleConsonants(mock2Word)
		if(m21 ~= nil and m22 ~= nil)then
			
			splitMCheck(m21)
			splitMCheck(m22)
		else
			--split on first vowel
			local m21,m22 = splitFirstVowel(mock2Word)
			if(m21 ~= nil and m22 ~= nil)then
				splitMCheck(m21)
				splitMCheck(m22)
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
				
				
				--print(event.target.pos)
				if(event.target.pos~= nil)then
					if(hasCollided(event.target,event.target.rectangle))then
						event.target.alpha = 0
						tospell[event.target.pos].alpha = 1
						collided = true
				
					end
				
					
				end
				if(event.x > xInset*15 or event.x < xInset * 5)then
						transition.to(event.target,{time = 500,x=markX,y=markY})
					
				elseif(event.y>yInset*15 or event.y < yInset)then
						transition.to(event.target,{time = 500,x=markX,y=markY})
				end
				display.getCurrentStage():setFocus(nil)
				print(#pieces)
				if(collided)then
					if(counter == #pieces)then
					
						
						wordComplete = true
						timer.performWithDelay(2500,function()
						wordsGroup:removeSelf()
						wordsGroup = nil
						wordsGroup = display.newGroup()
						bouGroup:insert(wordsGroup)
						pieces = {}
						mpieces ={}
						tospell = {}
						canvas ={}
						--isPlaying = true
						Next()
						--isPlaying = true
						end)
						
						
						counter = 1
					else
						counter = counter + 1
					end
				
				end
			end
			
			return true
		end
		
		local matchGroup = display.newGroup()
		wordsGroup:insert(matchGroup)
		local prevX = 0
		local c = 0
		for i=1,#pieces do
			local pieceGroup = display.newGroup()
			local r = math.random(5)
			
			local options = 
			{
				--parent = textGroup,
				text = pieces[i],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 36,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.alpha = 1
			myText:setFillColor( 0, 0, 0 )
			local canvasCollided = false
			while  canvasCollided==false do
				canvasCollided = true
				local xPos = math.random(display.contentWidth - xInset*10)+ xInset*5
				local yPos =  math.random(display.contentHeight - yInset*10)+ yInset
				myText.x =xPos
				myText.y = yPos
				
				for l=1,#canvas do
					
					if(hasCollided(myText,canvas[l]))then
						
						canvasCollided = false
					end
				end
				
			end
		
			
			--
			if(c<6)then
				c=c+1
				color =unpack(colors,c)
			else
				c = 1
				color =unpack(colors,c)
			end
			local length = myText.contentWidth
			local height = myText.contentHeight
			local rect = display.newRect(myText.x-5,myText.y +height/2,length+ 10,height+10)
			rect.anchorX =0
			rect.anchorY = 0.5
			rect:setFillColor(color[1],color[2],color[3])
			pieceGroup:insert(rect)
			pieceGroup:insert(myText)
			pieceGroup.pos = i
		
			canvas[#canvas+1] = rect 
			local rect = display.newRect(prevX -5,0,length+ 10,height+10)
			
			rect.anchorX =0
			rect.anchorY = 0.5
			rect:setFillColor(color[1],color[2],color[3])
			pieceGroup.rectangle = rect
			
			matchGroup.anchorChildren = true
			matchGroup.anchorX = 0.5
			matchGroup.anchorY = 0
			matchGroup:insert(rect)
			local options = 
			{
				--parent = textGroup,
				text = pieces[i],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 36,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0.5
			myText.alpha = 0
			myText.pos = i
			myText.x = prevX
			myText.y = 0
			myText:setFillColor( 0, 0, 0 )
			tospell[#tospell+1] = myText
			matchGroup:insert(myText)
			matchGroup.x = display.contentWidth / 2
			matchGroup.y = display.contentHeight - yInset*4
			prevX = prevX + length + 15
			
			wordsGroup:insert(pieceGroup)
			
			pieceGroup:addEventListener( "touch", drag )
		end
		
			local pieceGroup = display.newGroup()
			for i=1,#mpieces do
				local pieceGroup = display.newGroup()
				local r = math.random(5)
				
				local options = 
				{
					--parent = textGroup,
					text = mpieces[i],     
					--x = 0,
					--y = 200,
					--width = 128,     --required for multi-line and alignment
					font = "TeachersPet",   
					fontSize = 36,
					align = "right"  --new alignment parameter
				}

				myText = display.newText( options )
				myText.anchorX =0
				myText.anchorY =0
				myText.alpha = 1
				--
				
				local canvasCollided = false
				while  canvasCollided==false do
					canvasCollided = true
					local xPos = math.random(display.contentWidth - xInset*10)+ xInset*5
					local yPos =  math.random(display.contentHeight - yInset*10)+ yInset
					myText.x =xPos
					myText.y = yPos
					
					for q=1,#canvas do
						
						if(hasCollided(myText,canvas[q]))then
							
							canvasCollided = false
						end
					end
					
				end
				myText.pos = i
				p = i
				myText:setFillColor( 0, 0, 0 )
				--
				
				if(c<5)then
					c=c+1
					color =unpack(colors,c)
				else
					c = 1
					color =unpack(colors,c)
				end
				local length = myText.contentWidth
				local height = myText.contentHeight
				local rect = display.newRect(myText.x-5,myText.y +height/2,length+ 10,height+10)
				rect.anchorX =0
				rect.anchorY = 0.5
				rect:setFillColor(color[1],color[2],color[3])
				pieceGroup:insert(rect)
				pieceGroup:insert(myText)
				wordsGroup:insert(pieceGroup)
				canvas[#canvas+1] = rect 
				pieceGroup:addEventListener( "touch", drag )
			end	
		
		
		
end
function scene:create( event )
    sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
	local bg = display.newImage("background.png")
	    bg.anchorX =0
	    bg.anchorY =0
	    bg:setFillColor(1)
	    sceneGroup:insert(bg)
		
		local xander = display.newImage("1.png")
		xander.x = display.contentWidth - xInset*2
		xander.y = display.contentHeight - yInset*2
		xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
		xanderGroup:insert(xander)
		
		local options = 
		{
			--parent = textGroup,
			text = "Bou die regte woord.",     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 18,
			align = "right"  --new alignment parameter
		}
		
	    local myText = display.newText( options )
		myText.anchorY =0.5
		myText.alpha = 1
		myText.x = display.contentWidth - xInset*4.5
		myText.y = display.contentHeight - yInset*5.5 - 4.5
		myText:setFillColor( 1, 1, 1 )
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = display.contentWidth - xInset*4.5
		speechBox.y = display.contentHeight - yInset*5.5
		speechBox:scale(-(myText.contentWidth+10)/speechBox.contentWidth,yInset*2/speechBox.contentHeight)
		xanderGroup:insert(speechBox)
		xanderGroup:insert(myText)
		timer.performWithDelay(2000,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		bouGroup:insert(xanderGroup)
		menuGroup = display.newGroup()
		local mCircle = display.newImage("home.png")
		mCircle:scale(xInset*2/mCircle.width,xInset*2/mCircle.width)
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		bouGroup:insert(menuGroup)
		local soundButton = display.newImage("Sound.png")
		soundButton:scale(xInset*2/soundButton.width,xInset*2/soundButton.width)
		soundButton.x = xInset*2
		soundButton.y = display.contentHeight - yInset*2
		local function playWord(event)
			transition.to(soundButton,{time = 100, alpha = 0,onComplete =function() 
			transition.to(soundButton,{time = 100, alpha = 1})
			end})
			if(isPlaying==false)then
				wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
				isPlaying = true
				wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
			end
		end
		
		soundButton:addEventListener("tap",playWord)
		bouGroup:insert(soundButton)
		
		Next()
	    bouGroup:insert( wordsGroup )
		bouGroup:insert( linesGroup )
		sceneGroup:insert(bouGroup)
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
		--math.randomseed( os.time() )
		if(xanderGroup.alpha==0)then
			xanderGroup.alpha = 1
			timer.performWithDelay(2000,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		end
		if(isPlaying==false)then
			timer.performWithDelay(500,function()
			wordSound = audio.loadSound("sound/graad"..grade.."/"..word..".mp3" )
			isPlaying = true
			wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
			end)
		end
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
		
			audio.stop()
			isPlaying = false
		
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
