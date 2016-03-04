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
local prevWords = {}
local cardGroup = display.newGroup()
local isSwipping = false
local cur = 1
local card
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

local function drawCard()
	cardGroup.anchorChildren = true
	cardGroup.anchorX = 0.5
	cardGroup.anchorY = 0.5
	cardGroup.x = display.contentWidth / 2
	cardGroup.y = display.contentHeight / 2
	card = display.newRoundedRect(0,0,xInset*10,yInset*8,8)
	card.anchorX = 0
	card.anchorY = 0
	card.strokeWidth = 3
	card:setFillColor( 255/255, 51/255, 204/255 )
	card:setStrokeColor( 255/255, 51/255, 204/255 )
	
	cardGroup:insert(card)
	
end
local function onTap(event)
	transition.to( cardGroup, { time=200, yScale = 0.01, onComplete=function()
		local options = 
		{
			--parent = textGroup,
			text = word,     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = native.systemFontBold,   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}

		local myText = display.newText( options )
		myText.alpha = 1
		myText.x = xInset*5
		myText.y = yInset*4
		myText:setFillColor( 0, 0, 0 )
		cardGroup:insert(myText)
		card:setFillColor(1 )
		transition.to( cardGroup, { time=200, yScale = 1, onComplete=function()
		
		end } )
	end } )
    --cardGroup
    return true
end
local function handleSwipe( event )
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
					prevWords[#prevWords+1] = word
				end
				
				
				print(word)
				cardGroup:removeSelf()
				cardGroup = nil
				cardGroup = display.newGroup()
				cardGroup:addEventListener("tap",onTap)
				drawCard()
				cardGroup.x = 1.5 * display.contentWidth
				transition.to(cardGroup,{time = 500,x = 0.5 * display.contentWidth,onComplete = function() isSwipping = false end})
				
				end})
				
			end
		end
	elseif( event.phase == "ended")then
		
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
		bg.x = -xInset*2
	    bg:setFillColor(1)
	    sceneGroup:insert(bg)
	    word = getNextWord()
		prevWords[#prevWords+1] = word
		cardGroup:addEventListener("tap",onTap)
		sceneGroup:insert(cardGroup)
		drawCard()
		bg:addEventListener("touch",handleSwipe)
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
