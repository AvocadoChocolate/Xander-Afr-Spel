---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local gr3 = require("g3")
local widget = require( "widget" )
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local list = getIncorrectWords()

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
		local options = 
		{
			--parent = row,
			text = player,     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = TeachersPet,   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}

		local myText = display.newText( options )
		myText.anchorX =0.5
		myText.anchorY =0
		myText.alpha = 1
		myText.x = display.contentWidth  / 2
		myText.y = yInset
		myText:setFillColor( 0, 0, 0 ,0.4)
		sceneGroup:insert(myText)
		local acc = correct/(incorrect+correct) * 100
		local options = 
		{
			--parent = row,
			text = "Akkuraatheid: "..acc.."%",     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = TeachersPet,   
			fontSize = 16,
			align = "right"  --new alignment parameter
		}

		local myText = display.newText( options )
		myText.anchorX =0.5
		myText.anchorY =0
		myText.alpha = 1
		myText.x = display.contentWidth  / 2
		myText.y = yInset*3
		myText:setFillColor( 0, 0, 0,0.4 )
		sceneGroup:insert(myText)
		
		local options = 
		{
			--parent = row,
			text = "Verkeerde Woorde",     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = TeachersPet,   
			fontSize = 20,
			align = "right"  --new alignment parameter
		}

		local myText = display.newText( options )
		myText.anchorX =0.5
		myText.anchorY =0
		myText.alpha = 1
		myText.x = display.contentWidth  / 2
		myText.y = yInset*5
		myText:setFillColor( 0, 0, 0 )
		sceneGroup:insert(myText)
		
		local function onRowRender( event )

			-- Get reference to the row group
			local row = event.row

			-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local word = list[row.index]
			-- local rowTitle = display.newText( row,word , 0, 0,TeachersPet, 14 )
			-- rowTitle:setFillColor( 0 )

			-- Align the label left and vertically centered
			-- rowTitle.anchorX = 0
			-- rowTitle.x = xInset*4
			-- rowTitle.y = rowHeight * 0.5
			
			local wordSize = string.len(word)
			
			local linesGroup = display.newGroup()
			for i=1, wordSize do
				local dash = display.newLine(i*(xInset),rowHeight * 0.5, i*(xInset) + 15,rowHeight * 0.5)
				dash:setStrokeColor(255/255, 51/255, 204/255)
				dash.strokeWidth = 2
				linesGroup:insert(dash)
				local options = 
				{
					--parent = row,
					text = word:sub(i,i),     
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
				myText.y = -rowHeight * 0.1
				myText:setFillColor( 0, 0, 0 )
				myText.pos = i
				linesGroup:insert(myText)
			end
			linesGroup.anchorChildren = true
			linesGroup.anchorX = 0.5
			linesGroup.anchorY = 0
			linesGroup.x = display.contentWidth / 2
			row:insert(linesGroup)
			
		end
		-- Create the widget
		local tableView = widget.newTableView(
			{
				--left = 200,
				top = yInset*8,
				height = display.contentHeight - yInset*8,
				width = display.contentWidth,
				onRowRender = onRowRender,
				onRowTouch = onRowTouch,
				listener = scrollListener,
				hideBackground = true
			}
		)

		-- Insert 40 rows
		for i = 1, #list do
			-- Insert a row into the tableView
			tableView:insertRow({
			rowColor = { default={0.8,0.8,0.8,0} },
            lineColor =  { 1, 0, 0,0 }
			})
		end
		sceneGroup:insert(tableView)
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