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
		bg.x = -xInset*2
	    bg:setFillColor(1)
	    sceneGroup:insert(bg)
		
		local menuGroup = display.newGroup()
		
		local function gotoSpel(event)
			transition.to(menuGroup,{time = 1000,y = display.contentHeight,onComplete=function()  transition.to(menuGroup,{time = 500,y = 0})end})
			composer.gotoScene("spel",{time=500,effect = "fromTop"})
			
			return true
		end
		local function gotoBou(event)
			transition.to(menuGroup,{time = 1000,y =  - display.contentHeight,onComplete=function() transition.to(menuGroup,{time = 500,y = 0})end})
			composer.gotoScene("bou",{time=500,effect = "fromBottom"})
			return true
		end
		local function gotoFlash(event)
			transition.to(menuGroup,{time = 1000,x =  - display.contentWidth,onComplete=function() transition.to(menuGroup,{time = 500,x = 0}) end})
			composer.gotoScene("flash",{time=500,effect = "fromRight"})
			return true
		end
		local function gotoWordSearch(event)
			transition.to(menuGroup,{time = 1000,x =  display.contentWidth,onComplete=function() transition.to(menuGroup,{time = 500,x = 0})end})
			composer.gotoScene("wordsearch",{time=500,effect = "fromLeft"})
			return true
		end
		local playersGroup = display.newGroup()
		local pCircle = display.newImage("icon5.png")
		--pCircle:setFillColor( 255/255, 51/255, 204/255 )
		playersGroup:insert(pCircle)
		playersGroup.x = display.contentWidth - xInset*2
		playersGroup.y =  yInset*2
		local settingsGroup = display.newGroup()
		local setCircle = display.newImage("IconStat.png")
		--setCircle:setFillColor( 255/255, 51/255, 204/255 )
		settingsGroup:insert(setCircle)
		settingsGroup.x =  xInset*2
		settingsGroup.y =  yInset*2
		local function gotoPlayer(event)
			pCircle:setFillColor(255/255, 51/255, 204/255)
			transition.to(pCircle,{time = 500,yScale = 50,xScale = 50,onComplete=function()
			timer.performWithDelay(100,function()composer.removeScene("menu") end)
			composer.gotoScene("player") end})
			
			return true
		end
		local function gotoSettings(event)
			setCircle:setFillColor( 255/255, 51/255, 204/255 )
			transition.to(setCircle,{time = 500,yScale = 50,xScale = 50,onComplete=function()
			timer.performWithDelay(100,function()composer.removeScene("menu") end)
			composer.gotoScene("settings") end})
			return true
		end
	    local spelGroup = display.newGroup()
		local bouGroup = display.newGroup()
		local wordsearchGroup = display.newGroup()
		local flashGroup = display.newGroup()
		
		playersGroup:addEventListener( "tap", gotoPlayer )
		
		settingsGroup:addEventListener( "tap", gotoSettings )
		local sCircle = display.newImage("SpelDesign.png")
		local bCircle = display.newImage("tetris.png")
		local wCircle = display.newImage("wordsearchIcon.png")
		local fCircle = display.newImage("FlashIcon.png")
		bCircle:scale(xInset*4/bCircle.width,xInset*4/bCircle.height)
		sCircle:scale(xInset*4/sCircle.width,xInset*4/sCircle.height)
		fCircle:scale(xInset*4/fCircle.width,xInset*4/fCircle.height)
		wCircle:scale(xInset*4/wCircle.width,xInset*4/wCircle.height)
		local soptions = 
		{
			--parent = textGroup,
			text = "",     
			--x = 0,
			--y = 200,
			--width = 62,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}
		
		local sText = display.newText( soptions )
		sText.anchorX =0.5
		sText.anchorY =0.5
		sText.alpha = 1
		sText:setFillColor( 0, 0, 0 )
		local boptions = 
		{
			--parent = textGroup,
			text = "",     
			--x = 0,
			--y = 200,
			--width = 62,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}

		local bText = display.newText( boptions )
		bText.anchorX =0.5
		bText.anchorY =0.5
		bText.alpha = 1
		bText:setFillColor( 0, 0, 0 )
		local woptions = 
		{
			--parent = textGroup,
			text = "",     
			--x = 0,
			--y = 200,
			--width = 62,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}

		local wText = display.newText( woptions )
		wText.anchorX =0.5
		wText.anchorY =0.5
		wText.alpha = 1
		wText:setFillColor( 0, 0, 0 )
		local foptions = 
		{
			--parent = textGroup,
			text = "",     
			--x = 0,
			--y = 200,
			--width = 62,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}

		local fText = display.newText( foptions )
		fText.anchorX =0.5
		fText.anchorY =0.5
		fText.alpha = 1
		fText:setFillColor( 0, 0, 0 )
		spelGroup:insert(sCircle)
		--spelGroup:insert(sText)
		bouGroup:insert(bCircle)
		--bouGroup:insert(bText)
		wordsearchGroup:insert(wCircle)
		--wordsearchGroup:insert(wText)
		flashGroup:insert(fCircle)
		--flashGroup:insert(fText)
		flashGroup.anchorChildren = true
		flashGroup.anchorX = 0.5
		flashGroup.anchorY = 0.5
		flashGroup.x = display.contentWidth/2 + xInset*4
		flashGroup.y = display.contentHeight/2
		wordsearchGroup.anchorChildren = true
		wordsearchGroup.anchorX = 0.5
		wordsearchGroup.anchorY = 0.5
		wordsearchGroup.x = display.contentWidth/2 - xInset*4
		wordsearchGroup.y = display.contentHeight/2
		bouGroup.anchorChildren = true
		bouGroup.anchorX = 0.5
		bouGroup.anchorY = 0.5
		bouGroup.x = display.contentWidth/2
		bouGroup.y = 3*display.contentHeight/4
		spelGroup.anchorChildren = true
		spelGroup.anchorX = 0.5
		spelGroup.anchorY = 0.5
		spelGroup.x = display.contentWidth/2
		spelGroup.y = display.contentHeight/4  + yInset
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
							val.grade ="Graad 1"
							val.correct ="0"
							val.incorrect = "0"
							plaersList = {}
							plaersList[#plaersList+1]=val
							player = val.name
							grade = val.grade
							correct = val.correct
							incorrect = val.incorrect
							addAndSavePlayers(plaersList)
							composer.removeScene("menu")
							composer.gotoScene("menu")
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
			local Nameoptions = 
			{
				--parent = textGroup,
				text = player,     
				--x = 0,
				--y = 200,
				--width = 62,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 20,
				align = "right"  --new alignment parameter
			}
			
			 nameText = display.newText( Nameoptions )
			nameText.anchorX =0.5
			nameText.anchorY =0.5
			nameText.x = display.contentWidth/2
			nameText.y = yInset
			nameText.alpha = 1
			nameText:setFillColor( 0, 0, 0,0.4 )
			--sceneGroup:insert(nameText)
			menuGroup:insert(nameText)
			local Gradeoptions = 
			{
				--parent = textGroup,
				text = grade,     
				--x = 0,
				--y = 200,
				--width = 62,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 16,
				align = "right"  --new alignment parameter
			}
			
			 gradeText = display.newText( Gradeoptions )
			gradeText.anchorX =0.5
			gradeText.anchorY =0.5
			gradeText.x = display.contentWidth/2 - xInset*2
			gradeText.y = yInset * 2
			gradeText.alpha = 1
			gradeText:setFillColor( 0, 0, 0,0.4 )
			menuGroup:insert(gradeText)
			local Scoreoptions = 
			{
				--parent = textGroup,
				text = correct.."/150",     
				--x = 0,
				--y = 200,
				--width = 62,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 16,
				align = "right"  --new alignment parameter
			}
			
			 scoreText = display.newText( Scoreoptions )
			scoreText.anchorX =0.5
			scoreText.anchorY =0.5
			scoreText.x = display.contentWidth/2 + xInset*2
			scoreText.y = yInset * 2
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
        local players = getPlayers()
		if(players[1]~=nil)then
			nameText.text =  players[1].name
			gradeText.text = players[1].grade
			scoreText.text = players[1].correct .. "/150"
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
