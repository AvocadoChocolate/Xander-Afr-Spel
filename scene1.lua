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
local counter = 1
local rows = 5
local curRow = 1
local columns = 5
local curColumn = 1
local swearwordfilter ={"vok","fok","poes","kak","doos","kont","fuck","cunt","dick","ass"}
local words ={"een","twee","drie","vier","vyf"}
local matrix ={}
local correctmask ={}
for c=1,columns do
	matrix[c] ={}
	correctmask[c] = {}
	for r=1,rows do
		matrix[c][r] = 0
		correctmask[c][r] = 0
	end
end
local wordgrid = display.newGroup()
local linegrid = display.newGroup()
local function nextStep()
	if(curColumn==columns)then
		curRow = curRow + 1
		if(curRow>rows)then
			curRow = 1
		end
		curColumn = 1
	else
		curColumn= curColumn+1
	end
end
local function tryHPlacement()
	if(curRow<(rows - #words[counter])+1)then
	--place word
		local placement = true
		local r = curRow
		for i=1,#words[counter] do
			print("1: "..matrix[curColumn][curRow].." 2 "..words[counter]:sub(i,i))
			if(matrix[curColumn][r]~=words[counter]:sub(i,i) and matrix[curColumn][r]~=0)then
				placement = false
			end
			r=r+1
		end		
		print(placement)
		if(placement)then
			for i=1,#words[counter] do
			
				matrix[curColumn][curRow] = words[counter]:sub(i,i)
				correctmask[curColumn][curRow] = 1
				curRow=curRow+1
			end
			counter=counter+1
		else
		nextStep()
		end
	else
		if(curColumn<(columns - #words[counter])+1)then

		else
		nextStep()
		end
	end
end
local function tryVPlacement()
	if(curColumn<(columns - #words[counter])+1)then
	--place word
		local placement = true
		local c = curColumn
		for i=1,#words[counter] do
			--print("1: "..matrix[curColumn][curRow].." 2 "..words[counter]:sub(i,i))
			if(matrix[c][curRow]~=words[counter]:sub(i,i) and matrix[c][curRow]~=0)then
				placement = false
			end
			c=c+1
		end	
		--print(placement)		
		if(placement)then
			for i=1,#words[counter] do
				matrix[curColumn][curRow] = words[counter]:sub(i,i)
				correctmask[curColumn][curRow] = 1
				curColumn=curColumn+1
			end
			counter=counter+1
		else
		nextStep()
		end
	else
		if(curRow<(rows - #words[counter])+1)then
		--place word
		else
			nextStep()
		end
	end
end

function myTouchListener( event )
		
	 if ( event.phase == "began" ) then
        -- Code executed when the button is touched
		 iX = event.target.x +12/2
		 iY = event.target.y + 12
		
		
		circle = display.newCircle(iX, iY ,10)
		--circle.x =iX
		--circle.y =iY
		circle:setFillColor( 1, 0, 0, 1 )
		c =display.newCircle(iX, iY ,11)
		c:setFillColor(0)
		line = display.newLine( iX, iY, iX, iY )
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( 1, 0, 0, 1 )
		line.strokeWidth = 20
		l = display.newLine( iX, iY, iX, iY )
		l.anchorX =0
		l.anchorY =0
		l:setStrokeColor(  0 )
		l.strokeWidth = 22
		
		linegrid:insert(c)
		linegrid:insert(l)
		linegrid:insert(circle)
		linegrid:insert(line)
		if correctmask[event.target.c][event.target.r]==1 then
			correct = true
		else
			correct = false
		end
        --print( "object touched = "..tostring(event.target) )  -- 'event.target' is the touched object
    elseif ( event.phase == "moved" ) then
        -- Code executed when the touch is moved over the object
		line:removeSelf()
		line= nil
		l:removeSelf()
		l= nil
		if(circle1 ~=nil)then
			circle1:removeSelf()
			circle1=nil
		end
		if(c1 ~=nil)then
			c1:removeSelf()
			c1=nil
		end
		circle1 = display.newCircle(event.x,event.y,10)
		circle1:setFillColor( 1, 0, 0, 1 )
		line = display.newLine( iX, iY, event.x, event.y )
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( 1, 0, 0, 1 )
		line.strokeWidth = 20
		
		c1 = display.newCircle(event.x,event.y,11)
		c1:setFillColor( 0 )
		l = display.newLine( iX, iY, event.x, event.y )
		l.anchorX =0
		l.anchorY =0
		l:setStrokeColor(  0 )
		l.strokeWidth = 22
		linegrid:insert(c1)
		linegrid:insert(l)
		linegrid:insert(circle1)
		linegrid:insert(line)
       -- print( "touch location in content coordinates = "..event.x..","..event.y )
    elseif ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
		if correctmask[event.target.c][event.target.r]==1 then
			--correct = true
		else
			correct = false
		end
		line:removeSelf()
		line= nil
		if(circle1 ~=nil)then
			circle1:removeSelf()
			circle1=nil
		end
		l:removeSelf()
		l= nil
		if(c1 ~=nil)then
			c1:removeSelf()
			c1=nil
		end
		circle2 = display.newCircle(event.target.x+12/2,event.target.y+12,10)
		circle2:setFillColor( 1, 0, 0, 1 )
		line = display.newLine( iX, iY, event.target.x+12/2, event.target.y+12)
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( 1, 0, 0, 1 )
		line.strokeWidth = 20
		
		c2 = display.newCircle(event.target.x+12/2,event.target.y+12,11)
		c2:setFillColor( 0 )
		l = display.newLine( iX, iY, event.target.x+12/2, event.target.y+12)
		l.anchorX =0
		l.anchorY =0
		l:setStrokeColor( 0 )
		l.strokeWidth = 22
		linegrid:insert(c2)
		linegrid:insert(l)
		linegrid:insert(circle2)
		linegrid:insert(line)
		if(correct)then
		else
			if(circle ~=nil)then
			circle:removeSelf()
			circle=nil
			end
			if(line ~=nil)then
			line:removeSelf()
			line=nil
			end
			if(circle2 ~=nil)then
			circle2:removeSelf()
			circle2=nil
			end
			if(c ~=nil)then
			c:removeSelf()
			c=nil
			end
			if(l ~=nil)then
			l:removeSelf()
			l=nil
			end
			if(c2 ~=nil)then
			c2:removeSelf()
			c2=nil
			end
		end
       -- print( "touch ended on object "..tostring(event.target) )
    end
    return true  -- Prevents touch propagation to underlying objects
    
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
       local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)
	   bg.anchorX =0
	   bg.anchorY =0
	   bg:setFillColor(1)
	   sceneGroup:insert(bg)
	   --linegrid.x = 18
	   --linegrid.y = 18
	   sceneGroup:insert(linegrid)
	   while(counter~=#words +1)do
		   if(math.random()>0.1)then
				--Go to next step
				nextStep()
		   else
				--Place horizontal or vertical
				 if(math.random()>0.5)then
					tryHPlacement()
				 else
					tryVPlacement()
				 end
		   end
	   end
	   local str="aaaabbbbbcddddeeeefgggghhhhiiiiijkkkkllllmmmmnnnnoooooppppqrrrrssstttttuuvvvwwwxyyyz"
	   local checkLetter
	   
	   --print()
	   for c = 1,columns do
			for r = 1,rows do
			if(matrix[c][r]==0)then
				local randomL = string.char(str:byte(math.random(1, #str)))
				if(checkLetter~=nil)then
					while(randomL=="s" or randomL=="a" or randomL=="e" or randomL=="i" or randomL=="o" or randomL=="u")do
						randomL = string.char(str:byte(math.random(1, #str)))
						--print ("x: "..c.." y: "..r)
						--print (randomL)
					end
				end
				if(randomL == "v")then
					checkLetter = randomL
				elseif(randomL == "f") then
					checkLetter = randomL
				elseif(randomL == "k") then
					checkLetter = randomL
				elseif(randomL == "a") then
					checkLetter = randomL
				elseif(randomL == "s") then
					checkLetter = randomL
				else
					checkLetter = nil
				end
				matrix[c][r] = randomL
			end
			local smallRect = display.newRect(0,0,20,20)
			smallRect.alpha=0
			--smallRect:setFillColor(0)
			smallRect.anchorX =0
			smallRect.anchorY =0
			smallRect.x = c*25
			smallRect.y = r*25
			smallRect.c =c
			smallRect.r =r
			smallRect.isHitTestable = true
			smallRect:addEventListener( "touch", myTouchListener )
			local options = 
			{
				--parent = textGroup,
				text = matrix[c][r],     
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
			myText.x = c*25
			myText.y = r*25
			myText:setFillColor( 0, 0, 0 )
			wordgrid:insert(myText)
			end
			
	   end
	   sceneGroup:insert(wordgrid)
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
