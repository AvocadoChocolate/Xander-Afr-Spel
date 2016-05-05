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
local cardText
local swipeImg
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
	
	if(isPlaying)then
		audio.stop()
		
		isPlaying = false
	end
	transition.to(menuGroup,{time = 100, alpha = 0,onComplete =function() 
			transition.to(menuGroup,{time = 100, alpha = 1})
			end})
	transition.to(flashGroup,{time=500,x = display.contentWidth,onComplete = function() 
	transition.to(flashGroup,{time=500,x = 0})
	end})
	composer.gotoScene("menu",{time = 500,effect="fromLeft"}) 
	
	return true
end
local function getNextWord()
	
	local word 
	local check = true
	while(check)do
		check = false
		--r = r + 1
		r=math.random(grTotal)
		word = gr3.getWord(r)
		if(string.len(word)>11)then
			check = true
		end
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
	--cardGroup.anchorChildren = true
	--cardGroup.anchorX = 0.5
	--cardGroup.anchorY = 0
	cardGroup.x = 0
	cardGroup.y = 0
	--card = display.newImage("back.png")
	card =  display.newRoundedRect(0,0,xInset*10,yInset*4,10)
	--card:scale(xInset*8/card.width,xInset*8/card.width)
	--card.anchorX = 0
	--card.anchorY = 0
	card.x = display.contentWidth / 2
	card.y = display.contentHeight / 2 - yInset*3
	card.strokeWidth = 2
	--card:setFillColor( 255/255, 51/255, 204/255 )
	card:setStrokeColor( 0.8)
	
	cardGroup:insert(card)
	local options = 
	{
		--parent = textGroup,
		text = word,     
		--x = 0,
		--y = 200,
		--width = 128,     --required for multi-line and alignment
		font = "TeachersPet",   
		fontSize = 64,
		align = "right"  --new alignment parameter
	}
	
	cardText = display.newText( options )
	cardText.alpha = 1
	--cardText.anchorX = 0
	--cardText.anchorY = 0
	cardText.x = display.contentWidth / 2
	cardText.y = display.contentHeight / 2 - yInset*3
	cardText:setFillColor( 0.4 )
	cardText.alpha = 0
	local fs = 64
			
	while(cardText.width>(card.contentWidth-24))do
		
		fs = fs - 1
		cardText:removeSelf()
		cardText = nil
		local options = 
		{
			--parent = textGroup,
			text = word,     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = fs,
			align = "right"  --new alignment parameter
		}
		
		cardText = display.newText( options )
		cardText.alpha = 1
		--myText.anchorX = 0.5
		cardText.anchorY = 0.5
		cardText.x = xInset*4
		cardText.y = yInset * 4
		cardText:setFillColor( 0.4 )
		cardText.fontSize = fs
	end
	cardGroup:insert(cardText)
	
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
			fontSize = 64,
			align = "right"  --new alignment parameter
		}
		
		local myText = display.newText( options )
		myText.alpha = 1
		--myText.anchorX = 0.5
		myText.anchorY = 0.5
		myText.x = xInset*4
		myText.y = yInset * 5
		myText:setFillColor( 0.4 )
		cardf = display.newImage("front.png")
		cardf:scale(xInset*8/card.width,xInset*8/card.width)
		cardf.anchorX = 0
		cardf.anchorY = 0
		
		print("Text size"..(myText.width))
		print("Card size".. cardf.contentWidth)
		local fs = 64
			
		while(myText.width>(cardf.contentWidth-24))do
			
			fs = fs - 1
			myText:removeSelf()
			myText = nil
			local options = 
			{
				--parent = textGroup,
				text = word,     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = fs,
				align = "right"  --new alignment parameter
			}
			
			myText = display.newText( options )
			myText.alpha = 1
			--myText.anchorX = 0.5
			myText.anchorY = 0.5
			myText.x = xInset*4
			myText.y = yInset * 4
			myText:setFillColor( 0.4 )
			myText.fontSize = fs
		end
		print("Text size"..(myText.width))
		print("Card size".. cardf.contentWidth)
		cardGroup:remove(card)
		cardGroup:insert(cardf)
		cardGroup:insert(myText)
		card:setFillColor(1 )
		transition.to( cardGroup, { time=200, yScale = 1, onComplete=function()
			--cardGroup:addEventListener("tap",onTap)
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
					if(swipeImg~=nil)then
					
					
					swipeImg:removeSelf()
					swipeImg = nil
					end
					cur = cur -1 
					transition.to(cardGroup,{time = 500,x = 1.5 * display.contentWidth,onComplete = function()
					word = prevWords[cur]
					timer.performWithDelay(500,function()
					wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
		
					isPlaying = true
					wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false 
					transition.to(cardText,{time=500,alpha = 1})
					if(swipeImg==nil)then
						swipeImg = display.newImage("drag.png")
						swipeImg:scale(xInset/swipeImg.contentWidth,xInset/swipeImg.contentWidth)
						swipeImg.x = display.contentWidth / 2 + xInset * 2.5
						swipeImg.y = display.contentHeight - yInset*2
						swipeImg.alpha = 0.4
						flashGroup:insert(swipeImg)
						transition.to(swipeImg,{time=1000,x = display.contentWidth / 2 - xInset * 2.5,alpha=1,onComplete = function()
						transition.to(swipeImg,{time=1000,delay=100,x = display.contentWidth / 2 + xInset * 2.5,alpha=0.4,onComplete=function()
						swipeImg.alpha=0
						end})
						end})
					end
					end})
					end)
					print(word)
					cardGroup:removeSelf()
					cardGroup = nil
					cardGroup = display.newGroup()
					
					flashGroup:insert(cardGroup)
					drawCard()
					cardGroup.x = -1.5* display.contentWidth
					transition.to(cardGroup,{time = 500,x = 0,onComplete = function() isSwipping = false end})
					end})
				end
			elseif ( dX < -10 ) then
				cur = cur + 1 
				isSwipping = true
				if(swipeImg~=nil)then
				
				swipeImg:removeSelf()
				swipeImg = nil
				end
				transition.to(cardGroup,{time = 500,x = -  display.contentWidth,onComplete = function()
				if(#prevWords >= cur)then
					word = prevWords[cur]
				else
					word = getNextWord()
					timer.performWithDelay(500,function()
					wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
		
					isPlaying = true
					wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false 
					transition.to(cardText,{time=500,alpha = 1})
					if(swipeImg==nil)then
						swipeImg = display.newImage("drag.png")
						swipeImg:scale(xInset/swipeImg.contentWidth,xInset/swipeImg.contentWidth)
						swipeImg.x = display.contentWidth / 2 + xInset * 2.5
						swipeImg.y = display.contentHeight - yInset*2
						swipeImg.alpha = 0.4
						flashGroup:insert(swipeImg)
						transition.to(swipeImg,{time=1000,x = display.contentWidth / 2 - xInset * 2.5,alpha=1,onComplete = function()
						transition.to(swipeImg,{time=1000,delay=100,x = display.contentWidth / 2 + xInset * 2.5,alpha=0.4,onComplete=function()
						swipeImg.alpha=0
						end})
						end})
					end
					end})
					end)
					prevWords[#prevWords+1] = word
				end
				
				
				print(word)
				cardGroup:removeSelf()
				cardGroup = nil
				cardGroup = display.newGroup()
				flashGroup:insert(cardGroup)
				
				drawCard()
				cardGroup.x = 1.5 * display.contentWidth
				transition.to(cardGroup,{time = 500,x = 0,onComplete = function() isSwipping = false end})
				
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
		
		local options = 
		{
			--parent = textGroup,
			text = "Is jou potlood en papier gereed om te oefen?",     
			--x = 0,
			--y = 200,
			width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 18,
			align = "left"  --new alignment parameter
		}

	    local myText = display.newText( options )
		myText.anchorY =0.5
		myText.alpha = 1
		myText.x = display.contentWidth - xInset*6.5
		myText.y = yInset*3
		myText:setFillColor( 1, 1, 1 )
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = display.contentWidth - xInset*6.5
		speechBox.y = yInset*2.5
		speechBox:scale(-(myText.contentWidth+18)/speechBox.contentWidth,-(myText.contentHeight+18)/speechBox.contentHeight)
		xanderGroup:insert(speechBox)
		xanderGroup:insert(myText)
		timer.performWithDelay(3500,function() transition.to(xanderGroup,{time = 1500,alpha = 0})end)
		flashGroup:insert(xanderGroup)
		menuGroup = display.newGroup()
		local mCircle = display.newImage("home.png")
		mCircle:scale(xInset*2/mCircle.width,xInset*2/mCircle.width)
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		flashGroup:insert(menuGroup)
		local soundButton = display.newImage("Sound.png")
		soundButton:scale(xInset*2/soundButton.width,xInset*2/soundButton.width)
		soundButton.x = display.contentWidth / 2
		soundButton.y = display.contentHeight - yInset*7
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
		flashGroup:insert(soundButton)
		-- local options = 
		-- {
			-- --parent = textGroup,
			-- text = "< >",     
			-- --x = 0,
			-- --y = 200,
			-- --width = 128,     --required for multi-line and alignment
			-- --font = "TeachersPet",   
			-- fontSize = 28,
			-- align = "right"  --new alignment parameter
		-- }

	    -- local myText = display.newText( options )
		-- myText.anchorY =0.5
		-- myText.alpha = 1
		-- myText.x = display.contentWidth / 2
		-- myText.y = display.contentHeight - yInset*2.5
		-- myText:setFillColor( 0.8)
		-- flashGroup:insert(myText)
		-- local options = 
		-- {
			-- --parent = textGroup,
			-- text = "SWIPE VIR VOLGENDE",     
			-- --x = 0,
			-- --y = 200,
			-- --width = 128,     --required for multi-line and alignment
			-- font = "TeachersPet",   
			-- fontSize = 22,
			-- align = "right"  --new alignment parameter
		-- }

	    -- local myText = display.newText( options )
		-- myText.anchorY =0.5
		-- myText.alpha = 1
		-- myText.x = display.contentWidth / 2
		-- myText.y = display.contentHeight - yInset
		-- myText:setFillColor( 0.6)
		-- flashGroup:insert(myText)
	    word = getNextWord()
		isPlaying = true
		timer.performWithDelay(500,function()
		wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
		wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false 
		if cardText.alpha == 0  then
			transition.to(cardText,{time=500,alpha = 1})
		end
		transition.to(cardText,{time=500,alpha = 1})
		if(swipeImg==nil)then
						swipeImg = display.newImage("drag.png")
						swipeImg:scale(xInset/swipeImg.contentWidth,xInset/swipeImg.contentWidth)
						swipeImg.x = display.contentWidth / 2 + xInset * 2.5
						swipeImg.y = display.contentHeight - yInset*2
						swipeImg.alpha = 0.4
						flashGroup:insert(swipeImg)
						transition.to(swipeImg,{time=1000,x = display.contentWidth / 2 - xInset * 2.5,alpha=1,onComplete = function()
						transition.to(swipeImg,{time=1000,delay=100,x = display.contentWidth / 2 + xInset * 2.5,alpha=0.4,onComplete=function()
						swipeImg.alpha=0
						end})
						end})
					end
		end})
		end)
		prevWords[#prevWords+1] = word
		
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
        cardText.alpha = 0
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
        
        -- we obtain the object by id from the scene's object hierarchy
       
		--sceneGroup:rotate( 90 )
		--math.randomseed( os.time() )
		if(isPlaying==false)then
			timer.performWithDelay(500,function()
			wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
			isPlaying = true
			
			wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false 
			if cardText.alpha == 0 then
				transition.to(cardText,{time=500,alpha = 1})
			end
			end})
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
		cardText.alpha = 0
    elseif phase == "did" then
        -- Called when the scene is now off screen
		if(xanderGroup.alpha==0)then
			xanderGroup.alpha = 1
			timer.performWithDelay(2500,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		end
		if(isPlaying)then
						audio.stop()
						isPlaying = false
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
