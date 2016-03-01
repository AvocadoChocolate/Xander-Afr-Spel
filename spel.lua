local composer = require( "composer" )
require("onScreenKeyboard") -- include the onScreenKeyboard.lua file
local gr3 = require("g3")
local scene = composer.newScene()
local keyboard
local myText
local textField
local tospell = {}
local counter = 1
local sceneGroup
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local word = "ontvang"
local linesGroup = display.newGroup()
local wordTyped = ""
local prevWords = {}
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
	return word
end
--Developer mode
local function developerMode()
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

	    myText = display.newText( options )
		myText.anchorX =0
		myText.anchorY =0
		myText.alpha = 1
		myText.x = xInset
		myText.y = yInset 
		myText:setFillColor( 0, 0, 0 )
end
local function drawLines()
	linesGroup.anchorChildren = true
	linesGroup.anchorX = 0.5
	linesGroup.anchorY = 0
	linesGroup.x = display.contentWidth / 2
	linesGroup.y = yInset * 4
	local wordSize = string.len(word)
	
	
	for i=1, wordSize do
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
		myText.pos = i
		tospell[i] = myText
		linesGroup:insert(tospell[i])
	end
end
function scene:create( event )
		sceneGroup = self.view
		local bg = display.newImage("background.png")
		bg.anchorX =0
		bg.anchorY =0
		bg:setFillColor(1)
		sceneGroup:insert(bg)
		developerMode()
        --create a textfield for the content created with the keyoard
        --textField = display.newText("",  xInset * 10, yInset * 5, native.systemFont, 50)
		
        --textField:setTextColor(0,0,0)
        --sceneGroup:insert(textField)
		
        keyboard = onScreenKeyboard:new()
		
		drawLines()
		
		
		sceneGroup:insert(linesGroup)
        --create a listener function that receives the events of the keyboard
        local listener = function(event)
            if(event.phase == "ended")  then
				if(event.key == "del")then
					if(counter>1)then
						counter = counter - 1
						tospell[counter].text =""
						wordTyped = wordTyped:sub(1,string.len(wordTyped)-1)
					end
				else
					if(counter <= string.len(word))then
						tospell[counter].text=keyboard:getText() --update the textfield with the current text of the keyboard
						wordTyped = wordTyped .. tospell[counter].text
						--Check correct
						if(counter==string.len(word))then
							if(wordTyped ==  word) then
								--Get next word
								print("correct")
								if(#prevWords < 5) then
									prevWords[#prevWords + 1] = word
								else
									prevWords = {}
									prevWords[#prevWords + 1] = word
								end
								word = getNextWord()
								myText.text = word
								wordTyped = ""
								tospell = {}
								linesGroup:removeSelf()
								linesGroup = nil
								linesGroup = display.newGroup()
								sceneGroup:insert(linesGroup)
								drawLines()
								counter = 0
							else
							--show correct go to next word after pause
							end
						end
						counter = counter + 1
						
						
						
					else
					
					
					--Insert pop up xander that says the word does not have so many letters
					end
				end
                --check whether the user finished writing with the keyboard. The inputCompleted
                --flag of  the keyboard is set to true when the user touched its "OK" button
                if(event.target.inputCompleted == true) then
                    print("Input of data complete...")
                    --keyboard:destroy()
                    
                   -- processKeyboard()
                    
                    --[[if (textField.text:upper() == tospell:upper()) then
                    --keyboard:destroy()
                    showKeyboard()
                    end --]]
                end
            end
        end

        --let the onScreenKeyboard know about the listener
        keyboard:setListener(  listener  )

        --show a keyboard with small printed letters as default. Read more about the possible values for keyboard types in the section "possible keyboard types"
        keyboard:drawKeyBoard(keyboard.keyBoardMode.letters_small)
		--sceneGroup:insert(keyboard)
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	
	
	
	 
	-- all display objects must be inserted into group
	--sceneGroup:insert( background )
	--sceneGroup:insert( grass)
	--sceneGroup:insert( crate )
	--:insert( myText )
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
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function processKeyboard()
	--if (textField.text:upper() == tospell:upper()) then
	--keyboard:destroy()
	--showKeyboard()
	--local chosenword = chooseWord()
	--textField.text = ""
	--keyboard.text = ""
	--tospell = chosenword.spelling
	--sceneGroup:remove(myText)
	--myText = display.newText(tospell, 100, 200, native.systemFont, 16 )	
	--sceneGroup:insert(myText)
    --end
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

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene