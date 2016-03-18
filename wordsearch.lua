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
local isTouched = false
local counter = 1
local rows = 7
local curRow = 1
local columns = 7
local curColumn = 1
local pcounter = 1
local correctCounter =1
local rnum = math.random()
local rNext =math.random()
local colors ={{51/255, 204/255, 51/255},
{0/255, 153/255, 255/255},
{255/255, 153/255, 51/255},
{255/255, 255/255, 51/255},
{204/255, 102/255, 255/255}
}
local wordgrid = display.newGroup()
local linegrid = display.newGroup()
local xInset = display.contentWidth/20
local yInset = display.contentHeight/20
local words ={}
local searchList = {}
local wordsSearchGroup = display.newGroup()
local xanderGroup = display.newGroup()
local compare ={"a","b","c","d","e"}
local wordSound
local wordChannel
local isPlaying=false
local function gotoHome(event)
	if isPlaying == false then
	transition.to(menuGroup,{time = 100, alpha = 0,onComplete =function() 
			transition.to(menuGroup,{time = 100, alpha = 1})
			end})
	transition.to(wordsSearchGroup,{time=500,x = -display.contentWidth*2,onComplete = function() 
	
	transition.to(wordsSearchGroup,{time=500,x = 0})
	end})
	composer.gotoScene("menu",{time = 500,effect="fromRight"}) 
	end
	return true
end
local function Next()
	
	timer.performWithDelay( 1500, function() 
	composer.removeScene("wordsearch")
	composer.gotoScene("wordsearch")end )
	
end
local function getNextWord()
	local r 
	local word 
	local check = true
	while(check)do
		check = false
		r = math.random(grTotal)
		word = gr3.getWord(r)
		if string.len(word)>6 then
				check =true
		end
		for i=1,#words do
			if word == words[i] then
				check =true
			end
		end
	end
	word = string.gsub( word, "%-","")
	word = string.lower( word )
	return word
end
for i=1,5 do
	
	words[i]=getNextWord()
	
	print(words[i])
	
	
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

local function nextStep()
	rNext = math.random()
	rnum = math.random()
	--print("next"..rnum)
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
			--print("1: "..matrix[curColumn][curRow].." 2 "..words[counter]:sub(i,i))
			if(matrix[curColumn][r]~=words[counter]:sub(i,i) and matrix[curColumn][r]~=0)then
				placement = false
			end
			if(correctmask[curColumn][r]~=0)then
				placement = false
			end
			r=r+1
		end		
		--print(placement)
		if(placement)then
			rnum = math.random()
			for i=1,#words[counter] do
			
				matrix[curColumn][curRow] = words[counter]:sub(i,i)
				if(i==1)then
				correctmask[curColumn][curRow] = counter
				end
				if(i==#words[counter])then
				correctmask[curColumn][curRow] = compare[counter]
				end
				curRow=curRow+1
			end
			counter=counter+1
			pcounter = pcounter + 1
		else
		nextStep()
		end
	else
		
		nextStep()
		
	end
end
local function tryVPlacement()
	if(curColumn<(columns - #words[counter])+1)then
	--place word
		local placement = true
		local c = curColumn
		for i=1,#words[counter] do
			--print("1: "..matrix[curColumn][curRow].." 2 "..words[counter]:sub(i,i))
			if(matrix[c][curRow]~=words[counter]:sub(i,i) and matrix[c][curRow]~=0 )then
				placement = false
			end
			if(correctmask[c][curRow]~=0)then
				placement = false
			end
			c=c+1
		end	
		--print(placement)		
		if(placement)then
			rnum = math.random()
			for i=1,#words[counter] do
				matrix[curColumn][curRow] = words[counter]:sub(i,i)
				if(i==1)then
				correctmask[curColumn][curRow] = counter
				end
				if(i==#words[counter])then
				correctmask[curColumn][curRow] = compare[counter]
				end
				curColumn=curColumn+1
			end
			counter=counter+1
			pcounter = pcounter + 1
		else
		nextStep()
		end
	else
		
			nextStep()
		
	end
end

function myTouchListener( event )
		
	 if ( event.phase == "began" ) then
        -- Code executed when the button is touched
		 isTouched = true
		 iX = event.target.x +15/2
		 iY = event.target.y+15
		
		
		circle = display.newCircle(iX, iY ,16)
		--circle.x =iX
		--circle.y =iY
		if( r == nil or r>5) then
			r = 1
		else
			
		end
		color =unpack(colors,r)
		circle:setFillColor( color[1],color[2],color[3] )
		-- c =display.newCircle(iX, iY ,10.5)
		-- c:setFillColor(0)
		line = display.newLine( iX, iY, iX, iY )
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( color[1],color[2],color[3] )
		line.strokeWidth = 32
		-- l = display.newLine( iX, iY, iX, iY )
		-- l.anchorX =0
		-- l.anchorY =0
		-- l:setStrokeColor(  0 )
		-- l.strokeWidth = 21
		
		--linegrid:insert(c)
		--linegrid:insert(l)
		linegrid:insert(circle)
		linegrid:insert(line)
		if(correctmask[event.target.c]~=nil)then
			if correctmask[event.target.c][event.target.r]~=0 then
				cor = correctmask[event.target.c][event.target.r]
				correctc =event.target.c
				correctr =event.target.r
				
			end
		else
			line:removeSelf()
			line=nil
			circle:removeSelf()
			circle = nil
			isTouched = false
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
		circle1 = display.newCircle(event.x-xInset*3,event.y-yInset*3/2,16)
		circle1:setFillColor( color[1],color[2],color[3])
		line = display.newLine( iX, iY, event.x-xInset*3, event.y-yInset*3/2 )
		line.anchorX =0
		line.anchorY =0
		line:setStrokeColor( color[1],color[2],color[3])
		line.strokeWidth = 32
		
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
		--display.getCurrentStage():setFocus( linegrid )
       -- print( "touch location in content coordinates = "..event.x..","..event.y )
	   end
    elseif ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
		if(isTouched)then
			if(correctmask[event.target.c]~=nil)then
				if correctmask[event.target.c][event.target.r]==compare[cor] then
					cor = true
					if(correctCounter == 5)then
						timer.performWithDelay(2500,function() Next() end)
					end
					local curWord = searchList[correctmask[correctc][correctr]]
					if(isPlaying)then
						audio.stop()
						isPlaying = false
					end
					
					wordSound = audio.loadSound( "sound/graad"..grade.."/"..curWord.text..".mp3" )
					wordChannel = audio.play( wordSound,{onComplete= function() isPlaying = false end})
					isPlaying = true
					local length = curWord.contentWidth
					local height = curWord.contentHeight
					local rect = display.newRect(curWord.x-5,curWord.y + height/2,length+ 10,3)
					rect.anchorX =0
					rect.anchorY = 0.5
					rect:setFillColor(color[1],color[2],color[3])
					wordsSearchGroup:insert(rect)
					print(searchList[correctmask[correctc][correctr]].text .. length)
					correctCounter = correctCounter + 1
					correctmask[event.target.c][event.target.r] = 0
					correctmask[correctc][correctr] = 0
					r=r+1
				else
					cor = false
				end
			else
				cor = false
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
			circle2 = display.newCircle(event.target.x+15/2,event.target.y+15,16)
			circle2:setFillColor(color[1],color[2],color[3] )
			line = display.newLine( iX, iY, event.target.x+15/2, event.target.y+15)
			line.anchorX =0
			line.anchorY =0
			line:setStrokeColor( color[1],color[2],color[3] )
			line.strokeWidth = 32
			
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
			if(cor)then
				--print(cor)
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
    sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
	  local bg = display.newImage("background.png")
	   bg.anchorX =0
	   bg.anchorY =0
	   bg:setFillColor(1)
	   sceneGroup:insert(bg)
		local xander = display.newImage("zander.png")
		xander.x = display.contentWidth - xInset
		xander.y = display.contentHeight - yInset*0.5
		xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
		xanderGroup:insert(xander)
		
		local options = 
		{
			--parent = textGroup,
			text = "Soek die woorde.",     
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
		myText.x = display.contentWidth - xInset*3
		myText.y = display.contentHeight - yInset*5 - 4.5
		myText:setFillColor( 1, 1, 1 )
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = display.contentWidth - xInset*3
		speechBox.y = display.contentHeight - yInset*5
		speechBox:scale(-(myText.contentWidth+10)/speechBox.contentWidth,yInset*2/speechBox.contentHeight)
		xanderGroup:insert(speechBox)
		xanderGroup:insert(myText)
		timer.performWithDelay(2500,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		wordsSearchGroup:insert(xanderGroup)
		linegrid.y = yInset*2
		linegrid.x = xInset*3
		wordsSearchGroup:insert(linegrid)
		local er = 1
	   while(counter~=#words +1)do
			--print("rNext "..rNext)
			--print("rnum "..rnum)
		   if(rNext>0.1)then
				--Go to next step
				--print("next"..rnum)
				nextStep()
				
		   elseif(rnum>0.5) then
				--Place horizontal or vertical
					
					--print(pcounter.." 2 H 3 V")
					
						tryHPlacement()
				
			else
					--print("tryVPlacement"..rnum)
					--print(pcounter.." 3 H 2 V")
					
						tryVPlacement()
					
				 
		   end
		  
	   end
	   local str="aaaabbbbbcddddeeeefgggghhhhiiiiijkkkkllllmmmmnnnnoooooppppqrrrrssstttttuuvvvwwwxyyyz"
	   local checkLetter
	   	  local rect = display.newRect(-xInset*4,-yInset*2,xInset*24,yInset*23)
		  rect.anchorX = 0
		  rect.anchorY = 0
	   rect.alpha = 0
	   rect.isHitTestable = true
	   rect.c =  -1
	   rect.r = -1
	   rect:addEventListener("touch",myTouchListener)
	   wordgrid:insert(rect)
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
			local smallRect = display.newRect(0,0,35,35)
			smallRect.alpha=0
			--smallRect:setFillColor(0)
			smallRect.anchorX =0
			smallRect.anchorY =0
			smallRect.x = c*35
			smallRect.y = r*35
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
				font = "TeachersPet",   
				fontSize = 28,
				align = "center"  --new alignment parameter
			}

			local myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.x = c*35
			myText.y = r*35
			myText:setFillColor( 0, 0, 0 )
			wordgrid:insert(myText)
			
			end
			
			
	   end
	   for w=1,#words do
			local options = 
			{
				--parent = textGroup,
				text = words[w],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 28,
				align = "center"  --new alignment parameter
			}

			local myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.x = display.contentWidth - xInset*4
			myText.y = yInset*w*2 + yInset*2
			myText:setFillColor( 0, 0, 0 )
			searchList[#searchList+1] = myText
			wordsSearchGroup:insert(myText)
		end
		
	   wordgrid.y = yInset*2
	   wordgrid.x = xInset*3
		menuGroup = display.newGroup()
		local mCircle = display.newImage("home.png")
		mCircle:scale(xInset*2/mCircle.width,xInset*2/mCircle.width)
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*2
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		wordsSearchGroup:insert(menuGroup)
	   wordsSearchGroup:insert(wordgrid)
	   sceneGroup:insert(wordsSearchGroup)
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
		math.randomseed( os.time() )
	   
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
