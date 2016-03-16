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
local prevWords = {}
local cardGroup = display.newGroup()
local isSwipping = false
local cur = 1
local card
local bg 
local wordSound
local wordChannel
local isPlaying =false
local flashGroup = display.newGroup()
local xanderGroup = display.newGroup()
local r = 0
local function gotoHome(event)
	--composer.gotoScene("menu")
	if(isPlaying == false)then
	transition.to(flashGroup,{time=500,x = display.contentWidth,onComplete = function() 
	
	transition.to(flashGroup,{time=500,x = 0})
	end})
	composer.gotoScene("menu",{time = 500,effect="fromLeft"}) 
	end
	return true
end
local function getNextWord()
	
	local word 
	local check = true
	while(check)do
		check = false
		r = r + 1
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

local function drawCard()
	cardGroup.anchorChildren = true
	cardGroup.anchorX = 0.5
	cardGroup.anchorY = 0.5
	cardGroup.x = display.contentWidth / 2
	cardGroup.y = display.contentHeight / 2
	card = display.newImage("back.png")
	card:scale(xInset*10/card.width,yInset*10/card.height)
	card.anchorX = 0
	card.anchorY = 0
	--card.strokeWidth = 3
	--card:setFillColor( 255/255, 51/255, 204/255 )
	--card:setStrokeColor( 255/255, 51/255, 204/255 )
	
	cardGroup:insert(card)
	
end
local function onTap(event)
	if(isPlaying==false)then
	transition.to( cardGroup, { time=200, yScale = 0.01, onComplete=function()
		local options = 
		{
			--parent = textGroup,
			text = word,     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 72,
			align = "right"  --new alignment parameter
		}

		local myText = display.newText( options )
		myText.alpha = 1
		myText.x = xInset*5
		myText.y = yInset*5
		myText:setFillColor( 0.4 )
		cardf = display.newImage("front.png")
		cardf:scale(xInset*10/card.width,yInset*10/card.height)
		cardf.anchorX = 0
		cardf.anchorY = 0
		cardGroup:remove(card)
		cardGroup:insert(cardf)
		cardGroup:insert(myText)
		card:setFillColor(1 )
		
		transition.to( cardGroup, { time=200, yScale = 1, onComplete=function()
			cardGroup:removeEventListener("tap",onTap)
		end } )
	end } )
    --cardGroup
	end
    return true
end
local function handleSwipe( event )
	if(isPlaying == false)then
    if ( event.phase == "moved" ) then
        local dX = event.x - event.xStart
        --print( event.x, event.xStart, dX )
		if(isSwipping == false)then
			
			if ( dX > 10 ) then
				if( cur > 1)then
					isSwipping = true
					cur = cur -1 
					transition.to(cardGroup,{time = 500,x = 1.5 * display.contentWidth,onComplete = function()
					word = prevWords[cur]
					print(word)
					cardGroup:removeSelf()
					cardGroup = nil
					cardGroup = display.newGroup()
					cardGroup:addEventListener("tap",onTap)
					flashGroup:insert(cardGroup)
					drawCard()
					cardGroup.x = -0.5* display.contentWidth
					transition.to(cardGroup,{time = 500,x = 0.5 * display.contentWidth,onComplete = function() isSwipping = false end})
					end})
				end
			elseif ( dX < -10 ) then
				cur = cur + 1 
				isSwipping = true
				transition.to(cardGroup,{time = 500,x = -  display.contentWidth,onComplete = function()
				if(#prevWords >= cur)then
					word = prevWords[cur]
				else
					word = getNextWord()
					wordSound = audio.loadSound( "sound/graad1/"..word..".mp3" )
		
					isPlaying = true
					wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
					prevWords[#prevWords+1] = word
				end
				
				
				print(word)
				cardGroup:removeSelf()
				cardGroup = nil
				cardGroup = display.newGroup()
				flashGroup:insert(cardGroup)
				cardGroup:addEventListener("tap",onTap)
				drawCard()
				cardGroup.x = 1.5 * display.contentWidth
				transition.to(cardGroup,{time = 500,x = 0.5 * display.contentWidth,onComplete = function() isSwipping = false end})
				
				end})
				
			end
		end
	elseif( event.phase == "ended")then
		
    end
	end
    return true
end
function scene:create( event )
    sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
	 bg = display.newImage("background.png")
	    bg.anchorX =0
	    bg.anchorY =0
		--bg.x = -xInset*2
	    bg:setFillColor(1)
	    sceneGroup:insert(bg)
		local xander = display.newImage("2.png")
		xander.x = display.contentWidth - xInset*2
		xander.y = yInset*1
		xander:scale(xInset*3/xander.contentWidth,-xInset*3/xander.contentWidth)
		xanderGroup:insert(xander)
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = display.contentWidth - xInset*6.5
		speechBox.y = yInset*3
		speechBox:scale(-xInset*5/speechBox.contentWidth,-yInset*2/speechBox.contentHeight)
		xanderGroup:insert(speechBox)
		local options = 
		{
			--parent = textGroup,
			text = "Kan jy die woord spel?",     
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
		myText.x = display.contentWidth - xInset*6.5
		myText.y = yInset*3.5 - 4.5
		myText:setFillColor( 1, 1, 1 )
		xanderGroup:insert(myText)
		timer.performWithDelay(2500,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		flashGroup:insert(xanderGroup)
		menuGroup = display.newGroup()
		local mCircle = display.newImage("Icon1.png")
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		flashGroup:insert(menuGroup)
		
	    word = getNextWord()
		wordSound = audio.loadSound( "sound/graad1/"..word..".mp3" )
		isPlaying = true
		wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
		prevWords[#prevWords+1] = word
		cardGroup:addEventListener("tap",onTap)
		flashGroup:insert(cardGroup)
		drawCard()
		bg:addEventListener("touch",handleSwipe)
		sceneGroup:insert(flashGroup)
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
       
		--sceneGroup:rotate( 90 )
		if(isPlaying==false)then
			wordSound = audio.loadSound( "sound/graad1/"..word..".mp3" )
			isPlaying = true
			wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
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
		if(xanderGroup.alpha==0)then
			xanderGroup.alpha = 1
			timer.performWithDelay(2500,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		end
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
