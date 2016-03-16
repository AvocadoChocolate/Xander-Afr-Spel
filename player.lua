---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local gr3 = require("g3")
local widget = require( "widget" )
require("onScreenKeyboard")
local k
local menuGroup
local wordTyped =""
local myText
local tospell = {}
local counter = 1

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local plaersList

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
	    plaersList = getPlayers()
        local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)
	    bg.anchorX =0
	    bg.anchorY =0
	    bg:setFillColor(255/255, 51/255, 204/255)
	    sceneGroup:insert(bg)
		local options = 
		{
			--parent = row,
			text = "Kies 'n Speler",     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 32,
			align = "right"  --new alignment parameter
		}

		local Text = display.newText( options )
		Text.anchorX =0.5
		Text.anchorY =0
		Text.alpha = 1
		Text.x = display.contentWidth  / 2
		Text.y = yInset
		Text:setFillColor( 0, 0, 0 )
		sceneGroup:insert(Text)
		local function gotoHome(event)
			composer.gotoScene("menu")
			return true
		end
		local menuGroup = display.newGroup()
		local mCircle = display.newImage("Icon1.png")
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		sceneGroup:insert(menuGroup)
		local function onRowRender( event )

			-- Get reference to the row group
			local row = event.row

			-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			if(#plaersList>=1)then
				local rowBox = display.newRoundedRect(row,0,0,xInset*14,rowHeight-rowHeight/10,2)
				rowBox.anchorY = 0
				rowBox.anchorX = 0
				rowBox.y = rowHeight/5
				rowBox.x = xInset*4
				local function selectPlayer(event)
					player = plaersList[row.index].name
					grade =plaersList[row.index].grade
					correct = plaersList[row.index].correct
					incorrect = plaersList[row.index].incorrect
					cur = row.index
					print(player)
					composer.gotoScene("menu",{time = 500,effect = "fade"})
					return true
				end
				rowBox:addEventListener("tap",selectPlayer)
				local rowTitle = display.newText( row,plaersList[row.index].name , 0, 0,"TeachersPet", 28 )
				rowTitle:setFillColor( 0,0,0,0.5 )
		
				--Align the label left and vertically centered
				rowTitle.anchorX = 0
				rowTitle.x = xInset*6
				rowTitle.y = rowHeight * 0.5
				local rowTitle = display.newText( row,plaersList[row.index].grade , 0, 0,"TeachersPet", 24 )
				rowTitle:setFillColor( 0,0,0,0.5  )

				--Align the label left and vertically centered
				rowTitle.anchorX = 0
				rowTitle.x = xInset*6
				rowTitle.y = rowHeight * 0.9
				local rowTitle = display.newText( row,plaersList[row.index].correct.."/150" , 0, 0,"TeachersPet", 28 )
				rowTitle:setFillColor( 0,0,0,0.5)

				--Align the label left and vertically centered
				rowTitle.anchorX = 0
				rowTitle.x = xInset*10
				rowTitle.y = rowHeight *0.7
				--Draw small pink line
				
				local deleteTick = display.newImage(row,"icontick2.png")
				deleteTick.x = xInset*16
				deleteTick.y = rowHeight * 0.7
				deleteTick:scale(0.8,0.8)
				local function delete(event)
					local back = display.newRect(0,0,display.contentWidth,display.contentWidth)
					back.anchorX = 0
					back.anchorY = 0
					back:setFillColor(0)
					back.alpha = 0.4
					--back.isHitTestable = false
					local function block(event)
						return true
					end
					back:addEventListener("tap",block)
					sceneGroup:insert(back)
					local options = 
					{
						--parent = row,
						text = "Is jy seker jy wil \ndie speler verwyder?",     
						--x = 0,
						--y = 200,
						--width = 128,     --required for multi-line and alignment
						font = "TeachersPet",   
						fontSize = 20,
						align = "right"  --new alignment parameter
					}

					confirmText = display.newText( options )
					confirmText.anchorX =0.5
					confirmText.anchorY =0
					confirmText.alpha = 1
					confirmText.x = display.contentWidth  / 2
					confirmText.y = display.contentHeight - yInset*14 + 10
					confirmText:setFillColor( 1, 1, 1 )
					sceneGroup:insert(confirmText)
					local yes  = display.newRoundedRect(display.contentWidth / 2 - xInset*2 - 5,display.contentHeight - yInset*8,xInset*2,yInset*2,4)
					yes.anchorX = 0.5
					yes.anchorY = 0
					--yes.strokeWidth = 2
					yes:setFillColor( 255/255, 51/255, 204/255)
					--yes:setStrokeColor( 255/255, 51/255, 204/255 )
					sceneGroup:insert(yes)
					local no  = display.newRoundedRect(display.contentWidth / 2 + xInset*2 + 5,display.contentHeight - yInset*8,xInset*2,yInset*2,4)
					no.anchorX = 0.5
					no.anchorY = 0
					--yes.strokeWidth = 2
					no:setFillColor( 255/255, 51/255, 204/255)
					--yes:setStrokeColor( 255/255, 51/255, 204/255 )
					sceneGroup:insert(no)
					local options = 
					{
						--parent = row,
						text = "JA",     
						--x = 0,
						--y = 200,
						--width = 128,     --required for multi-line and alignment
						font = "TeachersPet",   
						fontSize = 20,
						align = "right"  --new alignment parameter
					}

					yesText = display.newText( options )
					yesText.anchorX =0.5
					yesText.anchorY =0
					yesText.alpha = 1
					yesText.x = display.contentWidth / 2 -xInset*2 - 5
					yesText.y = display.contentHeight - yInset*8+ 8
					yesText:setFillColor( 1, 1, 1 )
					sceneGroup:insert(yesText)
					local options = 
					{
						--parent = row,
						text = "NEE",     
						--x = 0,
						--y = 200,
						--width = 128,     --required for multi-line and alignment
						font = "TeachersPet",   
						fontSize = 20,
						align = "right"  --new alignment parameter
					}

					noText = display.newText( options )
					noText.anchorX =0.5
					noText.anchorY =0
					noText.alpha = 1
					noText.x = display.contentWidth / 2 + xInset*2 + 5
					noText.y = display.contentHeight - yInset*8 + 8
					noText:setFillColor( 1, 1, 1 )
					sceneGroup:insert(noText)
					local function cancel(event)
						back:removeSelf()
						back = nil
						confirmText:removeSelf()
						confirmText = nil
						yes:removeSelf()
						yes = nil
						no:removeSelf()
						no = nil
						yesText:removeSelf()
						yesText = nil
						noText:removeSelf()
						noText = nil
						return true
					end
					no:addEventListener("tap",cancel)
					local function confirmed(event)
						local destDir = system.DocumentsDirectory  -- Location where the file is stored
						local result, reason = os.remove( system.pathForFile( plaersList[row.index].name..".txt", destDir ) )

						if result then
						   print( "File removed" )
						else
						   print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
						end
						table.remove(plaersList,row.index)
						addAndSavePlayers(plaersList)
						
						composer.removeScene("player")
						composer.gotoScene("player")
						return true
					end
					
					yes:addEventListener("tap",confirmed)
					return true
				end
				deleteTick:addEventListener("tap",delete)
			end
		end
		-- Create the widget
		local tableView = widget.newTableView(
			{
				--left = 200,
				top = yInset*3,
				height = display.contentHeight - yInset*6,
				width = display.contentWidth,
				onRowRender = onRowRender,
				onRowTouch = onRowTouch,
				listener = scrollListener,
				hideBackground = true
			}
		)

		-- Insert 40 rows
		for i = 1, #plaersList do
			-- Insert a row into the tableView
			tableView:insertRow({
			rowHeight = yInset*3,
			rowColor = { default={0.8,0.8,0.8,0} },
            lineColor =  { 1, 0, 0,0 }
			})
		end
		sceneGroup:insert(tableView)
		local function addPlayer(event)
			menuGroup:removeEventListener("tap", addPlayer)
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
							plaersList[#plaersList+1]=val
							
							addAndSavePlayers(plaersList)
							composer.removeScene("player")
							composer.gotoScene("player")
						end
						myText:removeSelf()
						myText=nil
						menuGroup:addEventListener("tap", addPlayer)
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
			
			return true
		end
		menuGroup = display.newGroup()
		local mCircle = display.newCircle(0,0,28)
		mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  display.contentWidth / 2
		menuGroup.y =  display.contentHeight - yInset*2
		menuGroup:addEventListener( "tap", addPlayer )
		sceneGroup:insert(menuGroup)
		
		--k = onScreenKeyboard:new()
		 --let the onScreenKeyboard know about the listener
		---k:setListener(  listener  )
		--show a k with small printed letters as default. Read more about the possible values for k types in the section "possible k types"
		
		--timer.performWithDelay(500,function() k:hide() end)
		
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
