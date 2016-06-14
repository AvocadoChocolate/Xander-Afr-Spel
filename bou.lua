---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local gr3
if(grade == "1")then
gr3 = require("gr1s")
else
 gr3 = require("gr2s")
end
local grTotal = gr3.total()
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------
local xInset,yInset = display.contentWidth / 20 , display.contentHeight / 20
local word =""
local xanderGroup = display.newGroup()
local vowels = {"a","e","i","o","u","y"}
local colors ={{51/255, 204/255, 51/255},
{0/255, 153/255, 255/255},
{255/255, 153/255, 51/255},
{255/255, 255/255, 51/255},
{204/255, 102/255, 255/255}
}
local tick
local curPos = 1
local prevWords = {}
local canvas ={}
local pieces = {}
local tospell = {}
local counter = 1
local wordsGroup = display.newGroup()
local linesGroup = display.newGroup()
local bouGroup = display.newGroup()
local wordSound
local goingHome = false
local wordChannel
local isPlaying = false
local playersList = getPlayers()
local wordComplete = false
local function gotoHome(event)
	
	print(isPlaying)
	--if(isPlaying)then
		audio.stop()
		
		isPlaying = false
	--end
	goingHome = true
	transition.to(menuGroup,{time = 100, alpha = 0,onComplete =function() 
			transition.to(menuGroup,{time = 100, alpha = 1})
			end})
	transition.to(bouGroup,{time=500,y =  -2*display.contentHeight,onComplete = function() 
	transition.to(bouGroup,{time=500,y =  0,onComplete = function() 
	
	end})
	
	end})
	composer.gotoScene("menu",{time = 500,effect="fromBottom"}) 
	
	return true
end

local function getNextWord()
	local r 
	local syllable 
	local check = true
	while(check)do
		check = false
		r = math.random(grTotal )
		syllable = gr3.getSyllable(r)
		
		
		for i=1,#prevWords do
			if syllable == prevWords[i] then
				print(i)
				check =false
			end
		end
	end
	
	--syllable = string.gsub( syllable, "%-","")
	--syllable = string.lower( syllable )
	if(#prevWords < 5) then
		prevWords[#prevWords+1] = syllable
	else
		prevWords = {}
		prevWords[#prevWords+1]= syllable
	end
	print(syllable[1])
	return syllable
end

local function hasCollided( obj1, obj2 )
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return (left or right) and (up or down)
end

local function drawLines()
	linesGroup.anchorChildren = true
	linesGroup.anchorX = 0.5
	linesGroup.anchorY = 0
	linesGroup.x = display.contentWidth / 2
	linesGroup.y = display.contentHeight - yInset *4
	
	local i =1
	local c=0
	for k=2,#word do
		local wordSize = string.len(word[k])
		
		for j=1,wordSize do
			local dash = display.newLine(i*(xInset),0, i*(xInset) + 15,0)
			dash:setStrokeColor(255/255, 51/255, 204/255)
			dash.strokeWidth = 2
			linesGroup:insert(dash)
			--print(word[k]:sub(j,j))
			local options = 
			{
				--parent = textGroup,
				text = word[k]:sub(j,j),     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 28,
				align = "left"  --new alignment parameter
			}

			local myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.alpha = 0
			myText.x = i*(xInset)
			myText.y = -yInset*2
			myText:setFillColor( 0, 0, 0 )
			myText.piece = word[k]
			myText.pos = k-1
			tospell[i] = myText
			linesGroup:insert(tospell[i])
			i=i+1
		end
		
	end
	tick = display.newImage("icon8.png")
	tick.y = -yInset
	tick:scale((xInset/1.1)/tick.contentWidth,(xInset/1.1)/tick.contentWidth)
	tick.x = (string.len(word[1])+1)*xInset + 15
	tick.alpha = 0
	linesGroup:insert(tick)
	for i=1,#tospell do
	print(tospell[i].text..tospell[i].pos)
	end
	
end
local function graduate()
	if(keyboard~=nil)then
		keyboard:destroy()
		keyboard = nil
	end
	local back = display.newRect(0,0,display.contentWidth,display.contentWidth)
	back.anchorX = 0
	back.anchorY = 0
	back:setFillColor(0)
	back.alpha = 0.4
	back:toFront()
	--back.isHitTestable = false
	local function block(event)
		return true
	end
	back:addEventListener("tap",block)
	bouGroup:insert(back)
	local xander = display.newImage("2-reverse.png")
	xander.x = display.contentWidth  / 2 - xInset * 2.2
	xander.y = display.contentHeight - yInset*12
	xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
	bouGroup:insert(xander)
	local nextGrade =  tonumber(grade)+1
	if(nextGrade<=7)then
	local options = 
	{
		--parent = row,
		text = "Veelsgeluk! Wil jy graad "..nextGrade.." doen?",     
		--x = 0,
		--y = 200,
		width = 180,     --required for multi-line and alignment
		font = "TeachersPet",   
		fontSize = 28,
		align = "left"  --new alignment parameter
	}
	
	
	confirmText = display.newText( options )
	--confirmText.anchorX =0.5
	--confirmText.anchorY =0
	confirmText.alpha = 1
	confirmText.x = display.contentWidth  / 2 + xInset * 3
	confirmText.y = display.contentHeight - yInset*15 - 10
	confirmText:setFillColor( 1, 1, 1 )
	local speechBox = display.newImage("speechbox.png")
	speechBox.x = display.contentWidth  / 2 + xInset * 3
	speechBox.y = display.contentHeight - yInset*15
	speechBox:scale((confirmText.width+20)/speechBox.contentWidth,(confirmText.height+25)/speechBox.contentHeight)
	bouGroup:insert(speechBox)
	bouGroup:insert(confirmText)
	
	local yes  = display.newRoundedRect(display.contentWidth / 2 - xInset*2 - 5,display.contentHeight - yInset*8,xInset*2,yInset*2,4)
	yes.anchorX = 0.5
	yes.anchorY = 0
	--yes.strokeWidth = 2
	yes:setFillColor( 255/255, 51/255, 204/255)
	--yes:setStrokeColor( 255/255, 51/255, 204/255 )
	bouGroup:insert(yes)
	local no  = display.newRoundedRect(display.contentWidth / 2 + xInset*2 + 5,display.contentHeight - yInset*8,xInset*2,yInset*2,4)
	no.anchorX = 0.5
	no.anchorY = 0
	--yes.strokeWidth = 2
	no:setFillColor( 255/255, 51/255, 204/255)
	--yes:setStrokeColor( 255/255, 51/255, 204/255 )
	bouGroup:insert(no)
	local options = 
	{
		--parent = row,
		text = "JA",     
		--x = 0,
		--y = 200,
		--width = 128,     --required for multi-line and alignment
		font = "TeachersPet",   
		fontSize = 28,
		align = "right"  --new alignment parameter
	}

	yesText = display.newText( options )
	yesText.anchorX =0.5
	yesText.anchorY =0
	yesText.alpha = 1
	yesText.x = display.contentWidth / 2 -xInset*2 - 5
	yesText.y = display.contentHeight - yInset*8+ 8
	yesText:setFillColor( 1, 1, 1 )
	bouGroup:insert(yesText)
	local options = 
	{
		--parent = row,
		text = "NEE",     
		--x = 0,
		--y = 200,
		--width = 128,     --required for multi-line and alignment
		font = "TeachersPet",   
		fontSize = 28,
		align = "right"  --new alignment parameter
	}

	noText = display.newText( options )
	noText.anchorX =0.5
	noText.anchorY =0
	noText.alpha = 1
	noText.x = display.contentWidth / 2 + xInset*2 + 5
	noText.y = display.contentHeight - yInset*8 + 8
	noText:setFillColor( 1, 1, 1 )
	bouGroup:insert(noText)
	local function cancel(event)
		----------------------------------------------------------------------------------------------------Maak graduation op kies speler beskikbaar
		
		
		back:removeSelf()
		back=nil
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
		xander:removeSelf()
		xander = nil
		speechBox:removeSelf()
		speechBox=nil
		
		
		return true
	end
	no:addEventListener("tap",cancel)
	local function confirmed(event)
		
		grade = tonumber(grade) + 1
		correct = 0
		transition.to(menuGroup,{time = 100, alpha = 0,onComplete =function() 
			transition.to(menuGroup,{time = 100, alpha = 1})
			end})
		transition.to(bouGroup,{time=500,y = 2*display.contentHeight,onComplete = function() 
		transition.to(bouGroup,{time=500,y = 0})
		end})
		composer.removeScene("bou")
		composer.gotoScene("menu",{time = 500,effect="fromTop"}) 
		list ={}
		addAndSaveIncorrectWords(list)
		
		playersList[cur].grade = grade
		playersList[cur].correct = correct
		playersList[cur].incorrect = 0
		addAndSavePlayers(playersList)
		if(keyboard~=nil)then
			keyboard:destroy()
			keyboard = nil
		end
		return true
	end
	
	yes:addEventListener("tap",confirmed)
	else
		local options = 
		{
			--parent = row,
			text = "Veelsgeluk! Kry ons Graad 8 - 12 Spelling App",     
			--x = 0,
			--y = 200,
			width = 180,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 28,
			align = "left"  --new alignment parameter
		}
		
		
		confirmText = display.newText( options )
		--confirmText.anchorX =0.5
		--confirmText.anchorY =0
		confirmText.alpha = 1
		confirmText.x = display.contentWidth  / 2 + xInset * 3
		confirmText.y = display.contentHeight - yInset*15 - 10
		confirmText:setFillColor( 1, 1, 1 )
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = display.contentWidth  / 2 + xInset * 3
		speechBox.y = display.contentHeight - yInset*15
		speechBox:scale((confirmText.width+20)/speechBox.contentWidth,(confirmText.height+25)/speechBox.contentHeight)
		bouGroup:insert(speechBox)
		bouGroup:insert(confirmText)
		local no  = display.newRoundedRect(display.contentWidth / 2 ,display.contentHeight - yInset*8,xInset*2,yInset*2,4)
		no.anchorX = 0.5
		no.anchorY = 0
		--yes.strokeWidth = 2
		no:setFillColor( 255/255, 51/255, 204/255)
		--yes:setStrokeColor( 255/255, 51/255, 204/255 )
		bouGroup:insert(no)
		local options = 
		{
			--parent = row,
			text = "OK",     
			--x = 0,
			--y = 200,
			--width = 128,     --required for multi-line and alignment
			font = "TeachersPet",   
			fontSize = 28,
			align = "right"  --new alignment parameter
		}

		noText = display.newText( options )
		noText.anchorX =0.5
		noText.anchorY =0
		noText.alpha = 1
		noText.x = display.contentWidth / 2 
		noText.y = display.contentHeight - yInset*8 + 8
		noText:setFillColor( 1, 1, 1 )
		bouGroup:insert(noText)
		local function cancel(event)
			----------------------------------------------------------------------------------------------------Maak graduation op kies speler beskikbaar
			
			
			back:removeSelf()
			back=nil
			confirmText:removeSelf()
			confirmText = nil
			no:removeSelf()
			no = nil
			
			noText:removeSelf()
			noText = nil
			xander:removeSelf()
			xander = nil
			speechBox:removeSelf()
			speechBox=nil
			
			
			return true
		end
		no:addEventListener("tap",cancel)
	end
end
local function Next()
		
		
		word = getNextWord()
		audio.stop()
		isPlaying = false
		drawLines()
		isPlaying = true
		timer.performWithDelay(500,function()
			if(goingHome == false)then
	
				wordSound = audio.loadSound( "sound/graad"..grade.."/"..word[1]..".mp3" )
				wordChannel = audio.play( wordSound ,{onComplete= function() 
				isPlaying = false end})
			
			end
		end)
		--print(word)
		
		
		local function drag( event )
				if event.phase == "began" then
				collided = false
				began = true
				markX = event.target.x    -- store x location of object
				markY = event.target.y    -- store y location of object
				lookingFor = ""
				for i=1,#tospell do
					if(tospell[i].pos==counter)then
						lookingFor = lookingFor..tospell[i].text
					end
				end
				if(developerMode)then
				-------------------------------------------------------------------------------------------------------------------------------Determin correct drop area bounds
					for d = 1,#pieces do
						local yPos = linesGroup.y -yInset*1.5-- tospell[1].y
						local xPos = 0
						local stX = nil
						for i=1,#tospell do
								if(d==tospell[i].pos)then
									xPos = xPos + tospell[i].contentWidth + xInset/2
									if(stX == nil)then
										stX = linesGroup.x - (linesGroup.contentWidth / 2) + tospell[i].x - xInset/4
									end
								end
						end
						xPos = xPos + xInset
						-----------------------------------------------------------------------------------------------------------------------------------------------------------------
						-- print(" event.target.x" .. (event.x ))
						-- print(" event.target.y" .. event.y)
						-- print("stX :"..stX)
						-- print("stX + xPos = "..(stX + xPos))
						-- print(" event.target.x" .. event.target.x)
						-- print("yPos :"..yPos)
						-- print("xPos :"..xPos)
						-- print(lookingFor)
						local myRectangle = display.newRect(stX,yPos + yInset*2 ,xPos,yInset*4)
						myRectangle.strokeWidth = 3
						myRectangle:setFillColor( 0.5,0 )
						myRectangle:setStrokeColor( 1, 0, 0 )
						myRectangle:toFront()
						bouGroup:insert(myRectangle)
					end
				end
					display.getCurrentStage():setFocus( event.target )
				elseif event.phase == "moved" then
				
					if(began)then
					local x = (event.x - event.xStart) + markX
					local y = (event.y - event.yStart) + markY
					
					event.target.x, event.target.y = x, y    -- move object based on calculations above
					end
				elseif event.phase == "ended" or event.phase == "cancelled" then
					event.target.alpha = 1
					began = false
					-------------------------------------------------------------------------------------------------------------------------------Determin correct drop area bounds
					local yPos = linesGroup.y -yInset*1.5 --+ tospell[1].y
					local xPos = 0
					local stX = nil
					local pLen = 0
					for i=1,#tospell do
							if(counter==tospell[i].pos)then
								xPos = xPos + tospell[i].contentWidth + xInset/2
								pLen = pLen + 1
								if(stX == nil)then
									stX = linesGroup.x - (linesGroup.contentWidth / 2) + tospell[i].x - xInset/4
								end
							end
					end
					if(pLen == 1)then
						stX = stX - xInset/4
					end
					xPos = xPos + xInset
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- print(" event.target.x" .. (event.x ))
					-- print(" event.target.y" .. event.y)
					-- print("stX :"..stX)
					-- print("stX + xPos = "..(stX + xPos))
					-- print(" event.target.x" .. event.target.x)
					-- print("yPos :"..yPos)
					-- print("xPos :"..xPos)
					-- print(lookingFor)
					-- local myRectangle = display.newRect(stX,yPos + yInset*2 ,xPos,yInset*4)
					-- myRectangle.strokeWidth = 3
					-- myRectangle:setFillColor( 0.5,0 )
					-- myRectangle:setStrokeColor( 1, 0, 0 )
					-- myRectangle:toFront()
					-- bouGroup:insert(myRectangle)
					local bool =  event.x < stX + xPos and event.x > stX - xInset/2 and event.y > yPos + yInset and event.y < yPos + yInset*5 
					print(bool)
					if( bool) then
					-- if(event.target.pos~= nil)then
						-- if(hasCollided(event.target,event.target.rectangle))then
							-- event.target.alpha = 0
							-- tospell[event.target.pos].alpha = 1
							-- collided = true
					
						-- end
					
						
					-- end
					if(lookingFor == event.target.t)then
						event.target.alpha = 0
						for i=1,#tospell do
							if(counter==tospell[i].pos)then
								tospell[i].alpha = 1
							end
						end
						if(counter == #pieces)then
						
							tick.alpha = 1
							wordComplete = true
							timer.performWithDelay(300,function()
							linesGroup:removeSelf()
							linesGroup=nil
							linesGroup = display.newGroup()
							wordsGroup:removeSelf()
							wordsGroup = nil
							wordsGroup = display.newGroup()
							bouGroup:insert(wordsGroup)
							bouGroup:insert(linesGroup)
							pieces = {}
							mpieces ={}
							tospell = {}
							canvas ={}
							--Confirm grade is less then 7
							if(tonumber(grade) < 7)then
								--Can add to score
								if(tonumber(correct)<=50)then
									if(firstCorrect)then
									correct = correct + 1
									end
									--isPlaying = true
									firstCorrect = true
								end
								--Score has been reached can graduate
								if(tonumber(correct)==50)then
									graduate()
								
								
								end
								--User has chose to continue on this level
								if(tonumber(correct)>50)then
										correct = 50
								end
							else
								--Can add to score
								if(tonumber(correct)<=50)then
									if(firstCorrect)then
										correct = correct + 1
									end
									--isPlaying = true
									firstCorrect = true
								end
								--Score has been reached can graduate
								if(tonumber(correct)==50)then
									graduate()
								end
								--User has chose to continue on this level
								if(tonumber(correct)>50)then
										correct = 50
								end
							end
							
							Next()
							--isPlaying = true
							end)
							
							
							counter = 1
						else
							counter = counter + 1
						end
					else
						firstCorrect = false
						transition.to(event.target,{time = 500,x=markX,y=markY})
						-- sX = event.target.x
						-- transition.to(event.target,{time =120 ,rotation= 1,x =  sX + 0.1,iterations = 3,onRepeat =function() 
							-- transition.to(event.target,{time =120 ,rotation = -1,x= sX - 0.10})
						-- end,onComplete =function() transition.to(event.target,{time =6,rotation = 0 ,x=sX}) end})
					end
				else
					transition.to(event.target,{time = 500,x=markX,y=markY})
				end
					if(event.x > xInset*18 or event.x < xInset * 2)then
							transition.to(event.target,{time = 500,x=markX,y=markY})
						
					elseif(event.y>yInset*15 or event.y < yInset)then
							transition.to(event.target,{time = 500,x=markX,y=markY})
					end
					display.getCurrentStage():setFocus(nil)
				end
				
				return true
			end
		
		
		local function myTap(event)
			sX = event.target.x
			print(event.target.t)
			
			--print(tospell[counter].text)
			local lookingFor = ""
			for i=1,#tospell do
				if(tospell[i].pos==curPos)then
					lookingFor = lookingFor..tospell[i].text
				end
			end
			print(lookingFor)
			print(curPos)
			if(lookingFor == event.target.t)then
				event.target.alpha = 0
				for i=1,#tospell do
					if(curPos==tospell[i].pos)then
						tospell[i].alpha = 1
					end
				end
				if(curPos == #word - 1)then
					tick.alpha = 1
					wordComplete = true
					timer.performWithDelay(400,function()
					linesGroup:removeSelf()
					linesGroup=nil
					linesGroup = display.newGroup()
					wordsGroup:removeSelf()
					wordsGroup = nil
					wordsGroup = display.newGroup()
					bouGroup:insert(wordsGroup)
					bouGroup:insert(linesGroup)
					pieces = {}
					mpieces ={}
					tospell = {}
					canvas ={}
					--isPlaying = true
					Next()
					
					--isPlaying = true
					end)
					
					
					curPos = 1
				else
					curPos = curPos + 1
				end
			else
				
				transition.to(event.target,{time =120 ,rotation= 1,x =  sX + 0.1,iterations = 3,onRepeat =function() 
					transition.to(event.target,{time =120 ,rotation = -1,x= sX - 0.10})
				end,onComplete =function() transition.to(event.target,{time =6,rotation = 0 ,x=sX}) end})
			end
			
			return true
		end
		local matchGroup = display.newGroup()
		wordsGroup:insert(matchGroup)
		local prevX = 0
		local c = 0
		local q = 1
		
		for i=2,#word do
			local pieceGroup = display.newGroup()
			local FS = 46
			local options = 
			{
				--parent = textGroup,
				text = word[i],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = FS,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0
			myText.alpha = 1
			myText:setFillColor( 0, 0, 0 )
			
			local canvasCollided = false
			local falseCount = 0
			while  canvasCollided==false do
				canvasCollided = true
				if(falseCount > 50)then
					print("-----------------------------------")
					falseCount = 0
					tick.alpha = 1
					wordComplete = true
					myText:removeSelf()
					linesGroup:removeSelf()
					linesGroup=nil
					linesGroup = display.newGroup()
					wordsGroup:removeSelf()
					wordsGroup = nil
					wordsGroup = display.newGroup()
					bouGroup:insert(wordsGroup)
					bouGroup:insert(linesGroup)
					pieceGroup:removeSelf()
					pieceGroup=nil
					pieces = {}
					mpieces ={}
					tospell = {}
					canvas ={}
					--isPlaying = true
					Next()
					return
					
				end
				local xPos = math.random(4)
				local yPos =  math.random(4)
				myText.x =xInset*xPos*3 + xInset
				myText.y = yInset*yPos*3-yInset*1.5
				local length = myText.contentWidth + 20
				local height = myText.contentHeight + 20
				local rect = display.newRoundedRect(myText.x-5,myText.y +height/2,length+ 10,height+10,3)
				for l=1,#canvas do
					
					if(hasCollided(rect,canvas[l]))then
						
						canvasCollided = false
						falseCount = falseCount + 1
						
						print(canvasCollided)
					end
				end
				if(canvasCollided)then
					falseCount = 0
				end
				rect:removeSelf()
				
			end
			if(c<5)then
				c=c+1
				color =unpack(colors,c)
			else
				c = 1
				color =unpack(colors,c)
			end
			local length = myText.contentWidth
			local height = myText.contentHeight
			local rect = display.newRoundedRect(myText.x-5,myText.y +height/2,length+ 10,height+10,3)
			rect.anchorX =0
			rect.anchorY = 0.5
			rect:setFillColor(color[1],color[2],color[3])
			pieceGroup:insert(rect)
			pieceGroup:insert(myText)
			
			pieceGroup.t = word[i]
			pieceGroup.pos = i - 1
		
			canvas[#canvas+1] = rect
			--i*(xInset),yInset*5, i*(xInset) + 15,yInset*5
			--local rect = display.newRoundedRect(prevX -5,0,length+ 10,height+10)
			local rect = display.newRoundedRect(prevX,0,length+ 10,height+10,3)
			rect.anchorX =0
			rect.anchorY = 0.5
			rect.alpha = 0
			rect.isHitTestable = true
			rect:setFillColor(color[1],color[2],color[3])
			
			
			pieces[#pieces+1] = rect
			pieces[#pieces].spos = q
			pieces[#pieces].piece = word[i]
			pieces[#pieces].epos = q-1 + string.len(word[i])
			q = q + string.len(word[i])
			pieceGroup.rectangle = rect
			
			matchGroup.anchorChildren = true
			matchGroup.anchorX = 0.5
			matchGroup.anchorY = 0
			matchGroup:insert(rect)
			local options = 
			{
				--parent = textGroup,
				text = word[i],     
				--x = 0,
				--y = 200,
				--width = 128,     --required for multi-line and alignment
				font = "TeachersPet",   
				fontSize = 36,
				align = "right"  --new alignment parameter
			}

			myText = display.newText( options )
			myText.anchorX =0
			myText.anchorY =0.5
			myText.alpha = 0
			myText.pos = i
			myText.x = prevX
			myText.y = 0
			myText:setFillColor( 0, 0, 0 )
			--tospell[#tospell+1] = myText
			matchGroup:insert(myText)
			matchGroup.x = display.contentWidth / 2
			matchGroup.y = display.contentHeight - yInset*4
			--i*(xInset),yInset*5, i*(xInset) + 15,yInset*5
			prevX = prevX + length + 25
			
			wordsGroup:insert(pieceGroup)
			
			pieceGroup:addEventListener( "touch", drag )
		end
		
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
		
		local xander = display.newImage("1.png")
		xander.x = display.contentWidth - xInset*2
		xander.y = display.contentHeight/2 - yInset*2
		xander:scale(xInset*2.5/xander.contentWidth,xInset*2.5/xander.contentWidth)
		xanderGroup:insert(xander)
		
		local options = 
		{
			--parent = textGroup,
			text = "Bou die regte woord.",     
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
		myText.x = display.contentWidth - xInset*2.5
		myText.y = display.contentHeight/2 -yInset*7- 4.5
		myText:setFillColor( 1, 1, 1 )
		local speechBox = display.newImage("speechbox.png")
		speechBox.x = display.contentWidth - xInset*2.5
		speechBox.y = display.contentHeight/2 -yInset*7
		speechBox:scale(-(myText.contentWidth+10)/speechBox.contentWidth,yInset*2/speechBox.contentHeight)
		xanderGroup:insert(speechBox)
		xanderGroup:insert(myText)
		timer.performWithDelay(2000,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		bouGroup:insert(xanderGroup)
		menuGroup = display.newGroup()
		local mCircle = display.newImage("home.png")
		mCircle:scale(xInset*1.5/mCircle.width,xInset*1.5/mCircle.width)
		--mCircle:setFillColor( 255/255, 51/255, 204/255 )
		menuGroup:insert(mCircle)
		menuGroup.x =  xInset*1.5
		menuGroup.y =  yInset*2
		menuGroup:addEventListener( "tap", gotoHome )
		bouGroup:insert(menuGroup)
		local soundButton = display.newImage("Sound.png")
		soundButton:scale(xInset*1.5/soundButton.width,xInset*1.5/soundButton.width)
		soundButton.x = xInset*1.5
		soundButton.y = display.contentHeight - yInset*2
		local function playWord(event)
			transition.to(soundButton,{time = 100, alpha = 0,onComplete =function() 
			transition.to(soundButton,{time = 100, alpha = 1})
			end})
			if(isPlaying==false)then
				wordSound = audio.loadSound( "sound/graad"..grade.."/"..word[1]..".mp3" )
				isPlaying = true
				wordChannel = audio.play( wordSound ,{onComplete=function()isPlaying=false end})
			end
		end
		
		soundButton:addEventListener("tap",playWord)
		bouGroup:insert(soundButton)
		
		Next()
	    bouGroup:insert( wordsGroup )
		bouGroup:insert( linesGroup )
		sceneGroup:insert(bouGroup)
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
		--math.randomseed( os.time() )
		goingHome= false
		if(xanderGroup.alpha==0)then
			xanderGroup.alpha = 1
			timer.performWithDelay(2000,function() transition.to(xanderGroup,{time = 500,alpha = 0})end)
		end
		if(isPlaying==false)then
			timer.performWithDelay(500,function()
			wordSound = audio.loadSound("sound/graad"..grade.."/"..word[1]..".mp3" )
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
		
			audio.stop()
			isPlaying = false
		
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
