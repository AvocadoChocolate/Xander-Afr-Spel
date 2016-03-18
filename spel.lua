local composer = require( "composer" )
require("onScreenKeyboard") -- include the onScreenKeyboard.lua file
local gr3
if(grade == "1")then
gr3 = require("gr1")
else
 gr3 = require("gr2")
end
local gr1Total = gr3.total()
local gr2Total = gr3.total()
local scene = composer.newScene()
local keyboard
local myText
local textField
local tospell = {}
local counter = 1
local Correctioncounter = 1
local sceneGroup
local menuGroup
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local list
local playersList = getPlayers()
local linesGroup = display.newGroup()
local wordTyped = ""
local spelGroup = display.newGroup()
local prevWords = {}
local correction = false
local correctionTable = {}
local congrats = {"Fantasties!","Uitstekend!","Puik!"}
local wordSound
local wordChannel
local isPlaying = false
local xanderGroup = display.newGroup()
-----
local function gotoHome(event)
	if(isPlaying == false)then
	transition.to(menuGroup,{time = 100, alpha = 0,onComplete =function() 
			transition.to(menuGroup,{time = 100, alpha = 1})
			end})
		transition.to(spelGroup,{time=500,y = 2*display.contentHeight,onComplete = function() 
		transition.to(spelGroup,{time=500,y = 0})
		end})
		composer.gotoScene("menu",{time = 500,effect="fromTop"}) 
		addAndSaveIncorrectWords(list)
		playersList[cur].grade = grade
		playersList[cur].correct = correct
		playersList[cur].incorrect = incorrect
		addAndSavePlayers(playersList)
		if(keyboard~=nil)then
			keyboard:destroy()
			keyboard = nil
		end
	end
	
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
		isPlaying = true
		timer.performWithDelay(500,function()
		wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3" )
		wordChannel = audio.play( wordSound ,{onComplete=function() isPlaying = false end })
		end)
		
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
local word = getNextWord()
--Developer mode
local function developerMode()
		local options = 
		{
			--parent = textGroup,
			text = word,     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
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
			font = "TeachersPet",   
			fontSize = 32,
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
local function redrawKeyboard()
		if(keyboard~=nil)then
			keyboard:destroy()
			keyboard = nil
		end
		
		print("drawKeyBoard")
		keyboard = onScreenKeyboard:new()
		
        --create a listener function that receives the events of the keyboard
        local listener = function(event)
            if(event.phase == "ended")  then
					if(correction)then
						if(Correctioncounter<=#correctionTable)then
							local text = keyboard:getText()
							print(correctionTable[Correctioncounter].text)
							print(correctionTable[Correctioncounter].pos)
							if(correctionTable[Correctioncounter].text == text)then
								tospell[correctionTable[Correctioncounter].pos].text = text
								Correctioncounter=Correctioncounter+1
								
							end
							if(Correctioncounter>#correctionTable) then
								--Get next word
								print("correct")
								local x = math.random(4)
								local y = math.random(3)
								local xander = display.newImage(x..".png")
								xander.x = display.contentWidth - xInset*2
								xander.y = yInset*5
								xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
								xanderGroup:insert(xander)
								
								local options = 
								{
									--parent = textGroup,
									text = congrats[y],     
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
								myText.x = display.contentWidth - xInset*5
								myText.y = yInset*3 - 4.5
								myText:setFillColor( 1, 1, 1 )
								local speechBox = display.newImage("speechbox.png")
								speechBox.x = display.contentWidth - xInset*5
								speechBox.y = yInset*3
								speechBox:scale(-(myText.contentWidth+10)/speechBox.contentWidth,yInset*2/speechBox.contentHeight)
								xanderGroup:insert(speechBox)
								xanderGroup:insert(myText)
								timer.performWithDelay(2000,function() transition.to(xanderGroup,{time = 500,alpha = 0,onComplete=function() 
								xander:removeSelf()
								xander= nil
								speechBox:removeSelf()
								speechBox=nil
								myText:removeSelf()
								myText = nil
								xanderGroup.alpha = 1
								end})end)
								spelGroup:insert(xanderGroup)
								if(#prevWords < 5) then
									prevWords[#prevWords + 1] = word
								else
									prevWords = {}
									prevWords[#prevWords + 1] = word
								end
								menuGroup:removeEventListener("tap",gotoHome)
								timer.performWithDelay( 2000, function() 
								word = getNextWord()
								--myText.text = word
								wordTyped = ""
								tospell = {}
								linesGroup:removeSelf()
								linesGroup = nil
								linesGroup = display.newGroup()
								redrawKeyboard()
								drawLines()
								counter = 1
								spelGroup:insert(linesGroup)
								Correctioncounter = 1
								correctionTable = {}
								correction = false
								menuGroup:addEventListener( "tap", gotoHome )
								end)
							end	
							
							
						end
					end
					if(counter <= string.len(word))then
						if(event.key == "del")then
							if(counter>1)then
								counter = counter - 1
								tospell[counter].text =""
								wordTyped = wordTyped:sub(1,string.len(wordTyped)-1)
							end
						elseif(event.key == "sound")then
							if(isPlaying==false)then
								wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3"  )
								isPlaying = true
								wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
							end
						else
						tospell[counter].text=keyboard:getText() --update the textfield with the current text of the keyboard
						wordTyped = wordTyped .. tospell[counter].text
						--Check correct
						if(counter==string.len(word))then
							if(wordTyped ==  word) then
								--Get next word
								print("correct")
								local x = math.random(4)
								local y = math.random(3)
								local xander = display.newImage(x..".png")
								xander.x = display.contentWidth - xInset*2
								xander.y = yInset*5
								xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
								xanderGroup:insert(xander)
								
								local options = 
								{
									--parent = textGroup,
									text = congrats[y],     
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
								myText.x = display.contentWidth - xInset*5
								myText.y = yInset*3 - 4.5
								myText:setFillColor( 1, 1, 1 )
								local speechBox = display.newImage("speechbox.png")
								speechBox.x = display.contentWidth - xInset*5
								speechBox.y = yInset*3
								speechBox:scale(-(myText.contentWidth+10)/speechBox.contentWidth,yInset*2/speechBox.contentHeight)
								xanderGroup:insert(speechBox)
								xanderGroup:insert(myText)
								timer.performWithDelay(2000,function() transition.to(xanderGroup,{time = 500,alpha = 0,onComplete=function() 
								xander:removeSelf()
								xander= nil
								speechBox:removeSelf()
								speechBox=nil
								myText:removeSelf()
								myText = nil
								xanderGroup.alpha = 1
								end})end)
								spelGroup:insert(xanderGroup)
								correct = correct + 1
								if(grade == 1)then
									if(correct>gr1Total)then
										grade = 2
										correct = 0
									end
								else
									if(correct>gr2Total)then
										correct = gr2Total
									end
								end
								if(#prevWords < 5) then
									prevWords[#prevWords + 1] = word
								else
									prevWords = {}
									prevWords[#prevWords + 1] = word
								end
								menuGroup:removeEventListener("tap",gotoHome)
								timer.performWithDelay( 2000, function() 
								word = getNextWord()
								--myText.text = word
								wordTyped = ""
								tospell = {}
								linesGroup:removeSelf()
								linesGroup = nil
								linesGroup = display.newGroup()
								redrawKeyboard()
								drawLines()
								counter = 1
								spelGroup:insert(linesGroup)
								menuGroup:addEventListener( "tap", gotoHome )
								end)
								
								
								
							else
							--show correct go to next word after pause
								incorrect = incorrect + 1
								for i=1,#tospell do
									local letter = word:sub(i,i)
									if(letter ~= tospell[i].text)then
										tospell[i].text = ""
										
										correction = true
										local val ={}
										val.text = word:sub(i,i)
										val.pos = i
										correctionTable[#correctionTable+1] = val
										
										--tospell[i]:setFillColor( 1, 0, 0 )
									end
								end
								if(correction==false)then
									menuGroup:removeEventListener("tap",gotoHome)
									timer.performWithDelay( 2000, function() 
									word = getNextWord()
									myText.text = word
									wordTyped = ""
									tospell = {}
									linesGroup:removeSelf()
									linesGroup = nil
									linesGroup = display.newGroup()
									redrawKeyboard()
									drawLines()
									counter = 1 
									spelGroup:insert(linesGroup)
									menuGroup:addEventListener( "tap", gotoHome )
									end)
								else
									--Add word to incorrect words list
									local alreadyContainsWord = false
									for i=1,#list do
										if(word==list[i])then
											alreadyContainsWord = true
										end
									end
									if(alreadyContainsWord==false)then
										list[#list+1] = word
									end
									
									
									
									keyboard:shakeLetters(correctionTable)
								end
							end
						end
						counter = counter + 1
						
						
						end
					else
					
					
					--Insert pop up xander that says the word does not have so many letters
					end
				
                --check whether the user finished writing with the keyboard. The inputCompleted
                --flag of  the keyboard is set to true when the user touched its "OK" button
                if(event.target.inputCompleted == true) then
                    print("Input of data complete...") 
                end
            end
        end
        --let the onScreenKeyboard know about the listener
        keyboard:setListener(  listener  )
        --show a keyboard with small printed letters as default. Read more about the possible values for keyboard types in the section "possible keyboard types"
        keyboard:drawKeyBoard(keyboard.keyBoardMode.letters_small)
		
		
		local enable = {"del","sound"}
		for i=1,string.len(word) do
			local alreadyContains = false
			for l=1,#enable do
				if(enable[l]==word:sub(i,i)) then
					alreadyContains = true
				end
			end
			if(alreadyContains ==false)then
				enable[#enable+1] = word:sub(i,i)
			end
		end
        keyboard:displayOnly(enable)
		-- timer.performWithDelay(2000,function()  end)
		
		
end
local function Next()
	word = getNextWord()
	myText.text = word
	wordTyped = ""
	tospell = {}
	linesGroup:removeSelf()
	linesGroup = nil
	linesGroup = display.newGroup()
	spelGroup:insert(linesGroup)
	redrawKeyboard()
	drawLines()
	counter = 1
	
end

function scene:create( event )
		local sceneGroup = self.view
		
		local bg = display.newImage("background.png")
		bg.anchorX =0
		bg.anchorY =0
		bg:setFillColor(1)
		spelGroup:insert(bg)
		playersList = getPlayers()
		menuGroup = display.newGroup()
		
		local mCircle = display.newImage("home.png")
		mCircle:scale(xInset*2/mCircle.width,xInset*2/mCircle.width)
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		--sceneGroup:insert(menuGroup)
		spelGroup:insert(menuGroup)
		list = getIncorrectWords()
		--developerMode()
		--sceneGroup:insert(myText)
        --create a textfield for the content created with the keyoard
        --textField = display.newText("",  xInset * 10, yInset * 5, native.systemFont, 50)
        --textField:setTextColor(0,0,0)
        --sceneGroup:insert(textField)
		
		--keyboard = true
		
		spelGroup:insert(linesGroup)
		print("scene created")
		sceneGroup:insert(spelGroup)
	
		
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
		math.randomseed( os.time() )
		drawLines()
		redrawKeyboard()
		if(isPlaying==false)then
			timer.performWithDelay(500,function()
			wordSound = audio.loadSound( "sound/graad"..grade.."/"..word..".mp3"  )
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
		if(keyboard~=nil)then
			keyboard:destroy()
			keyboard = nil
		end
		addAndSaveIncorrectWords(list)
		playersList[cur].grade = grade
		playersList[cur].correct = correct
		playersList[cur].incorrect = incorrect
		addAndSavePlayers(playersList)
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	if(keyboard~=nil)then
			keyboard:destroy()
			keyboard = nil
		end
	addAndSaveIncorrectWords(list)
	playersList[cur].grade = grade
	playersList[cur].correct = correct
	playersList[cur].incorrect = incorrect
	addAndSavePlayers(playersList)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene