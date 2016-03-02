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
local isTouched = false
local counter = 1
local rows = 10
local curRow = 1
local columns = 10
local curColumn = 1
local colors ={{51/255, 204/255, 51/255},
{0/255, 153/255, 255/255},
{255/255, 153/255, 51/255},
{255/255, 255/255, 51/255},
{204/255, 102/255, 255/255}
}
local xInset = display.contentWidth/20
local yInset = display.contentHeight/20
local words ={}
for i=1,5 do
	r = math.random(300)
	local word = gr3.getWord(r)
	while(string.len(word)>9) do
		r = math.random(300)
		word = gr3.getWord(r)
	end
	word = string.gsub( word, "%-","")
	word = string.lower( word )
	words[i]=word
	print(word)
	
	
end

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
				if(i==1 or i==#words[counter])then
				correctmask[curColumn][curRow] = counter
				end
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
				if(i==1 or i==#words[counter])then
					correctmask[curColumn][curRow] = counter
				end
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
		 isTouched = true
		 iX = event.target.x +12/2
		 iY = event.target.y + 12
		
		
		circle = display.newCircle(iX, iY ,10)
		--circle.x =iX
		--circle.y =iY
		if(r>4 or r == nil) then
			r = 1
		else
			r=r+1
		end
		color =unpack(colors,r)
		circle:setFillColor( color[1],color[2],color[3] )
		-- c =display.newCircle(iX, iY ,10.5)
		-- c:setFillColor(0)
		line = display.newLine( iX, iY, iX, iY )
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( color[1],color[2],color[3] )
		line.strokeWidth = 20
		-- l = display.newLine( iX, iY, iX, iY )
		-- l.anchorX =0
		-- l.anchorY =0
		-- l:setStrokeColor(  0 )
		-- l.strokeWidth = 21
		
		--linegrid:insert(c)
		--linegrid:insert(l)
		linegrid:insert(circle)
		linegrid:insert(line)
		
		if correctmask[event.target.c][event.target.r]~=0 then
			correct = correctmask[event.target.c][event.target.r]
		end
        --print( "object touched = "..tostring(event.target) )  -- 'event.target' is the touched object
    elseif ( event.phase == "moved" ) then
        -- Code executed when the touch is moved over the object
		if(isTouched)then
		line:removeSelf()
		line= nil
		--l:removeSelf()
		l= nil
		if(circle1 ~=nil)then
			circle1:removeSelf()
			circle1=nil
		end
		-- if(c1 ~=nil)then
			-- c1:removeSelf()
			-- c1=nil
		-- end
		circle1 = display.newCircle(event.x-xInset,event.y-10,10)
		circle1:setFillColor( color[1],color[2],color[3])
		line = display.newLine( iX, iY, event.x-xInset, event.y-10 )
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( color[1],color[2],color[3])
		line.strokeWidth = 20
		
		-- c1 = display.newCircle(event.x,event.y-10,11)
		-- c1:setFillColor( 0 )
		-- l = display.newLine( iX, iY, event.x, event.y -10 )
		-- l.anchorX =0
		-- l.anchorY =0
		-- l:setStrokeColor(  0 )
		-- l.strokeWidth = 22
		--linegrid:insert(c1)
		--linegrid:insert(l)
		linegrid:insert(circle1)
		linegrid:insert(line)
       -- print( "touch location in content coordinates = "..event.x..","..event.y )
	   end
    elseif ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
		if(isTouched)then
			if correctmask[event.target.c][event.target.r]==correct then
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
			-- l:removeSelf()
			-- l= nil
			-- if(c1 ~=nil)then
				-- c1:removeSelf()
				-- c1=nil
			-- end
			circle2 = display.newCircle(event.target.x+12/2,event.target.y+12,10)
			circle2:setFillColor(color[1],color[2],color[3] )
			line = display.newLine( iX, iY, event.target.x+12/2, event.target.y+12)
			line.anchorX =0
			line.anchorY =0
			line:setStrokeColor( color[1],color[2],color[3] )
			line.strokeWidth = 20
			
			-- c2 = display.newCircle(event.target.x+12/2,event.target.y+12,11)
			-- c2:setFillColor( 0 )
			-- l = display.newLine( iX, iY, event.target.x+12/2, event.target.y+12)
			-- l.anchorX =0
			-- l.anchorY =0
			-- l:setStrokeColor( 0 )
			-- l.strokeWidth = 22
			--linegrid:insert(c2)
			--linegrid:insert(l)
			linegrid:insert(circle2)
			linegrid:insert(line)
			if(correct)then
				print(correct)
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
				-- if(c ~=nil)then
				-- c:removeSelf()
				-- c=nil
				-- end
				-- if(l ~=nil)then
				-- l:removeSelf()
				-- l=nil
				-- end
				-- if(c2 ~=nil)then
				-- c2:removeSelf()
				-- c2=nil
				-- end
			end
			isTouched = false
		   -- print( "touch ended on object "..tostring(event.target) )
		   end
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
       local bg = display.newImage("background.png")
	   bg.anchorX =0
	   bg.anchorY =0
	   bg:setFillColor(1)
	   sceneGroup:insert(bg)
	  
	   linegrid.y = yInset
	   linegrid.x = xInset
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
			local smallRect = display.newRect(0,0,25,25)
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
			wordgrid:insert(smallRect)
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
			for w=1,#words do
				local options = 
				{
					--parent = textGroup,
					text = words[w],     
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
				myText.x = display.contentWidth - xInset*3
				myText.y = yInset*w*2 + yInset*2
				myText:setFillColor( 0, 0, 0 )
				sceneGroup:insert(myText)
			end
	   end
	   wordgrid.y = yInset
	   wordgrid.x = xInset
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