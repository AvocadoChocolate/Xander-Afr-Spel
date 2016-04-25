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
require("onScreenKeyboard")
local k
local wordTyped =""
local myText
local tospell = {}
local nameText
local gradeText
local scoreText
local counter = 1
function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
	local bg = display.newImage("background.png")
	    bg.anchorX =0
	    bg.anchorY =0
		bg:scale(display.contentWidth/bg.contentWidth,display.contentHeight/bg.contentHeight)
	    sceneGroup:insert(bg)
		local menuGroup = display.newGroup()
		
		
		local xander = display.newImage("2-reverse.png")
		xander.x = xInset*2
		xander.y = display.contentHeight - yInset*2
		xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
		menuGroup:insert(xander)
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = xInset*5.5
		speechBox.y = display.contentHeight - yInset*4.5
		speechBox:scale(xInset*4/speechBox.contentWidth,yInset*2/speechBox.contentHeight)
		menuGroup:insert(speechBox)
		local options = 
		{
			--parent = textGroup,
			text = "Kies 'n speletjie.",     
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
		myText.x =xInset*5.5
		myText.y = display.contentHeight - yInset*4.5 - 4.5
		myText:setFillColor( 1, 1, 1 )
		menuGroup:insert(myText)
		local function gotoSpel(event)
			transition.to(menuGroup,{time = 500,y = -2*display.contentHeight,onComplete=function()  transition.to(menuGroup,{time = 500,y = 0})end})
			composer.gotoScene("spel",{time=500,effect = "fromBottom"})
			
			return true
		end
		local function gotoBou(event)
			transition.to(menuGroup,{time = 500,y =   2*display.contentHeight,onComplete=function() transition.to(menuGroup,{time = 500,y = 0})end})
			composer.gotoScene("bou",{time=500,effect = "fromTop"})
			return true
		end
		local function gotoFlash(event)
			transition.to(menuGroup,{time = 500,x =  - 2*display.contentWidth,onComplete=function() transition.to(menuGroup,{time = 500,x = 0}) end})
			composer.gotoScene("flash",{time=500,effect = "fromRight"})
			return true
		end
		local function gotoWordSearch(event)
			transition.to(menuGroup,{time = 500,x =  2*display.contentWidth,onComplete=function() transition.to(menuGroup,{time = 500,x = 0})end})
			composer.gotoScene("wordsearch",{time=500,effect = "fromLeft"})
			return true
		end
		local playersGroup = display.newGroup()
		local pCircle = display.newImage("player.png")
		--pCircle:setFillColor( 255/255, 51/255, 204/255 )
		playersGroup:insert(pCircle)
		playersGroup.x = display.contentWidth - xInset*2
		playersGroup.y =  yInset*2
		pCircle:scale(xInset*2/pCircle.width,xInset*2/pCircle.width)
		local settingsGroup = display.newGroup()
		local setCircle = display.newImage("statistics.png")
		--setCircle:setFillColor( 255/255, 51/255, 204/255 )
		settingsGroup:insert(setCircle)
		settingsGroup.x =  xInset*2
		settingsGroup.y =  yInset*2
		setCircle:scale(xInset*2/setCircle.width,xInset*2/setCircle.width)
		local function gotoPlayer(event)
			-- local p = display.newCircle(playersGroup.x,playersGroup.y,20)
			-- sceneGroup:insert(p )
			-- p:setFillColor(255/255, 51/255, 204/255)
			playersGroup:removeEventListener("tap", gotoPlayer)
			--transition.to(p,{time = 500,yScale = 50,xScale = 50,onComplete=function()
			timer.performWithDelay(100,function()composer.removeScene("menu") end)
			composer.gotoScene("player") --end})
			
			return true
		end
		local function gotoSettings(event)
			-- local s = display.newCircle(settingsGroup.x,settingsGroup.y,20)
			-- s:setFillColor(255/255, 51/255, 204/255)
			-- sceneGroup:insert(s)
			settingsGroup:removeEventListener( "tap", gotoSettings )
			--setCircle:setFillColor( 255/255, 51/255, 204/255 )
			--transition.to(s,{time = 500,yScale = 50,xScale = 50,onComplete=function()
			timer.performWithDelay(100,function()composer.removeScene("menu") end)
			composer.gotoScene("settings") --end})
			return true
		end
	    local spelGroup = display.newGroup()
		local bouGroup = display.newGroup()
		local wordsearchGroup = display.newGroup()
		local flashGroup = display.newGroup()
		timer.performWithDelay(500,function()
		playersGroup:addEventListener( "tap", gotoPlayer )
		
		settingsGroup:addEventListener( "tap", gotoSettings )
		end)
		--local sCircle = display.newImage("SpelDesign.png")
		local sCircle = display.newCircle(0,0,xInset*4)
		sCircle:setFillColor(140/255, 198/255, 63/255)
		--local bCircle = display.newImage("tetris.png")
		local bCircle = display.newCircle(0,0,xInset*4)
		bCircle:setFillColor(127/255, 205/255, 238/255)
		--local wCircle = display.newImage("wordsearchIcon.png")
		local wCircle = display.newCircle(0,0,xInset*4)
		wCircle:setFillColor(251/255, 176/255, 59/255)
		--local fCircle = display.newImage("FlashIcon.png")
		local fCircle = display.newCircle(0,0,xInset*4)
		fCircle:setFillColor(255/255, 51/255, 204/255)
		bCircle:scale(xInset*4/bCircle.width,xInset*4/bCircle.height)
		sCircle:scale(xInset*4/sCircle.width,xInset*4/sCircle.height)
		fCircle:scale(xInset*4/fCircle.width,xInset*4/fCircle.height)
		wCircle:scale(xInset*4/wCircle.width,xInset*4/wCircle.height)
		local soptions = 
		{
			--parent = textGroup,
			text = "Spel",     
			--x = 0,
			--y = 200,
			--width = xInset*3,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 22,
			align = "right"  --new alignment parameter
		}
		
		local sText = display.newText( soptions )
		sText.anchorX =0.5
		sText.anchorY =0.5
		sText.alpha = 1
		sText:setFillColor( 1, 1, 1 )
		local boptions = 
		{
			--parent = textGroup,
			text = "Bou",     
			--x = 0,
			--y = 200,
			--width = xInset*3,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 22,
			align = "right"  --new alignment parameter
		}

		local bText = display.newText( boptions )
		bText.anchorX =0.5
		bText.anchorY =0.5
		bText.alpha = 1
		bText:setFillColor( 1, 1, 1 )
		local woptions = 
		{
			--parent = textGroup,
			text = "Woordesoek",     
			--x = 0,
			--y = 200,
			--width = xInset*3,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 22,
			align = "right"  --new alignment parameter
		}

		local wText = display.newText( woptions )
		wText.anchorX =0.5
		wText.anchorY =0.5
		wText.alpha = 1
		wText:setFillColor( 1, 1, 1 )
		local foptions = 
		{
			--parent = textGroup,
			text = "Flits kaarte",     
			--x = 0,
			--y = 200,
			--width = xInset*3,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 22,
			align = "right"  --new alignment parameter
		}

		local fText = display.newText( foptions )
		fText.anchorX =0.5
		fText.anchorY =0.5
		fText.alpha = 1
		fText:setFillColor( 1, 1, 1 )
		spelGroup:insert(sCircle)
		spelGroup:insert(sText)
		bouGroup:insert(bCircle)
		bouGroup:insert(bText)
		wordsearchGroup:insert(wCircle)
		wordsearchGroup:insert(wText)
		flashGroup:insert(fCircle)
		flashGroup:insert(fText)
		flashGroup.anchorChildren = true
		flashGroup.anchorX = 0.5
		flashGroup.anchorY = 0.5
		flashGroup.x = display.contentWidth/2 + xInset*4
		flashGroup.y = display.contentHeight/2 - yInset
		wordsearchGroup.anchorChildren = true
		wordsearchGroup.anchorX = 0.5
		wordsearchGroup.anchorY = 0.5
		wordsearchGroup.x = display.contentWidth/2 - xInset*4
		wordsearchGroup.y = display.contentHeight/2- yInset
		bouGroup.anchorChildren = true
		bouGroup.anchorX = 0.5
		bouGroup.anchorY = 0.5
		bouGroup.x = display.contentWidth/2
		bouGroup.y = display.contentHeight/4
		spelGroup.anchorChildren = true
		spelGroup.anchorX = 0.5
		spelGroup.anchorY = 0.5
		spelGroup.x = display.contentWidth/2
		spelGroup.y = 3*display.contentHeight/4  - yInset
		flashGroup:addEventListener( "tap", gotoFlash )
		spelGroup:addEventListener( "tap", gotoSpel )
		bouGroup:addEventListener( "tap", gotoBou )
		wordsearchGroup:addEventListener( "tap", gotoWordSearch )
		menuGroup:insert(wordsearchGroup)
		menuGroup:insert(spelGroup)
		menuGroup:insert(flashGroup)
		menuGroup:insert(bouGroup)
		menuGroup:insert(playersGroup)
		menuGroup:insert(settingsGroup)
		
		sceneGroup:insert(menuGroup)
		if(player =="")then
			local back = display.newRect(0,0,display.contentWidth,display.contentWidth)
			back.anchorX = 0
			back.anchorY = 0
			back:setFillColor(0)
			back.alpha = 0.4
			local function block(event)
						return true
					end
					back:addEventListener("tap",block)
			sceneGroup:insert(back)
			local customeTextbox  = display.newRoundedRect(display.contentWidth / 2,display.contentHeight - yInset*14,xInset*10,yInset*2,4)
			customeTextbox.anchorX = 0.5
			customeTextbox.anchorY = 0
			customeTextbox.strokeWidth = 2
			customeTextbox:setFillColor( 1)
			customeTextbox:setStrokeColor( 255/255, 51/255, 204/255 )
			sceneGroup:insert(customeTextbox)
			local options = 
			{
				--parent = row,
				text = "Enter Player Name",     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 20,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0.5
			myText.anchorY =0
			myText.alpha = 1
			myText.x = display.contentWidth  / 2
			myText.y = display.contentHeight - yInset*14 + 10
			myText:setFillColor( 0, 0, 0,0.5 )
			sceneGroup:insert(myText)
			k = onScreenKeyboard:new()
			local typer=function(event)
				print("keyPressed")
				 if(event.phase == "began")then
					if(event.key == "del")then
						print(event.key)
						if(counter>1)then
							counter = counter - 1
							tospell[counter] =""
							wordTyped = wordTyped:sub(1,string.len(wordTyped)-1)
							myText.text = wordTyped
						end
					elseif(event.key == "ok")then
						back:removeSelf()
						back=nil
						customeTextbox:removeSelf()
						customeTextbox=nil
						k:destroy()
						k=nil
						--Use myText------------------------------------
						if(myText.text~="Enter Player Name")then
							local val = {}
							val.name =myText.text
							val.grade ="1"
							val.correct ="0"
							val.incorrect = "0"
							cur = 1
							plaersList = {}
							plaersList[#plaersList+1]=val
							player = val.name
							grade = val.grade
							correct = val.correct
							incorrect = val.incorrect
							addAndSavePlayers(plaersList)
							composer.removeScene("menu",{time=500,effect="fade"})
							composer.gotoScene("menu",{time=500,effect="fade"})
						end
						myText:removeSelf()
						myText=nil
					else
						tospell[counter]=k:getText() --update the textfield with the current text of the k
						wordTyped = wordTyped .. tospell[counter]
						myText.text = wordTyped
						counter = counter + 1
					end
					if(event.target.inputCompleted == true) then
                    print("Input of data complete...") 
					end
				end
			end
			
			
			 --let the onScreenKeyboard know about the listener
			k:setListener(  typer  )
			--show a k with small printed letters as default. Read more about the possible values for k types in the section "possible k types"
			
			k:drawKeyBoard(k.keyBoardMode.letters_large)
			
		else
			print("Show player details in menu")
			local nameCard = display.newImage("front.png")
			nameCard.x = display.contentWidth - xInset * 4
			nameCard.y = display.contentHeight - yInset*3
			nameCard:scale(xInset*6/nameCard.width,yInset*5/nameCard.height)
			menuGroup:insert(nameCard)
			local Nameoptions = 
			{
				--parent = textGroup,
				text = "Naam:   "..player,     
				--x = 0,
				--y = 200,
				--width = 62,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 24,
				align = "right"  --new alignment parameter
			}
			
			nameText = display.newText( Nameoptions )
			nameText.anchorX =0
			nameText.anchorY =0
			nameText.x = display.contentWidth - xInset * 6.5
			nameText.y = display.contentHeight - yInset*5
			nameText.alpha = 1
			nameText:setFillColor( 0, 0, 0,0.4 )
			local fs = 24
			
			while(nameText.contentWidth>(nameCard.contentWidth-24))do
				
				fs = fs - 1
				nameText:removeSelf()
				nameText = nil
				local Nameoptions = 
				{
					--parent = textGroup,
					text = "Naam:  "..player,     
					--x = 0,
					--y = 200,
					--width = 62,     --required for multi-line and alignment
					font = "TeachersPet",   
					fontSize = fs,
					align = "right"  --new alignment parameter
				}
				
				nameText = display.newText( Nameoptions )
				nameText.anchorX =0
				nameText.anchorY =0
				nameText.x = display.contentWidth - xInset * 6.5
				nameText.y = display.contentHeight - yInset*5
				nameText.alpha = 1
				nameText:setFillColor( 0, 0, 0,0.4 )
				nameText.fontSize = fs
			end
			--sceneGroup:insert(nameText)
			menuGroup:insert(nameText)
			local Gradeoptions = 
			{
				--parent = textGroup,
				text = "Graad:  "..grade,     
				--x = 0,
				--y = 200,
				--width = 62,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 24,
				align = "right"  --new alignment parameter
			}
			
			 gradeText = display.newText( Gradeoptions )
			gradeText.anchorX =0
			gradeText.anchorY =0
			gradeText.x = display.contentWidth - xInset * 6.5
			gradeText.y = display.contentHeight - yInset* 3.5
			gradeText.alpha = 1
			gradeText:setFillColor( 0, 0, 0,0.4 )
			menuGroup:insert(gradeText)
			local gr3
			local grTotal
			if(grade == "1")then
				gr3 = require("gr1")
				grTotal = gr3.total()+53
			else
				gr3 = require("gr2")
				grTotal = gr3.total()+50
			end
			local Scoreoptions = 
			{
				--parent = textGroup,
				text = "Punt:     "..correct.." / ".."100",     
				--x = 0,
				--y = 200,
				--width = 62,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 24,
				align = "right"  --new alignment parameter
			}
			
			 scoreText = display.newText( Scoreoptions )
			scoreText.anchorX =0
			scoreText.anchorY =0
			scoreText.x = display.contentWidth - xInset * 6.5
			scoreText.y = display.contentHeight - yInset* 2
			scoreText.alpha = 1
			scoreText:setFillColor( 0, 0, 0,0.4 )
			menuGroup:insert(scoreText)
		end
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
		local gr3
			local grTotal
			if(grade == "1")then
				gr3 = require("gr1")
				grTotal = gr3.total()+53
			else
				gr3 = require("gr2")
				grTotal = gr3.total()+50
			end
        local players = getPlayers()
		if(player~="")then
			nameText.text =  "Naam:  "..player
			gradeText.text = "Graad:  "..grade
			scoreText.text = "Punt:     "..correct .. " / ".."100"
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
		if(k~=nil)then
			k:destroy()
			k = nil
		end
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
	if(k~=nil)then
			k:destroy()
			k = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
