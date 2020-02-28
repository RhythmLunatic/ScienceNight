--[[
I got paid $100 to do this shit
Hope you ZIV noobs are happy, you
can finally make a 1:1 DDR II theme!
-Rhythm Lunatic
]]
local numWheelItems = 15
local wheelAnimTime = .2

local GROUPWHEEL_GROUPS;
if getenv("PlayMode") == "Missions" then
	GROUPWHEEL_GROUPS = MISSION_GROUPS;
else
	GROUPWHEEL_GROUPS = SONGMAN:GetSongGroupNames();
end;

-- Scroller for the courses
local courseScroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local songSelection = 1;
local item_mt_course= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true):vanishpoint(SCREEN_CENTER_X,SCREEN_CENTER_Y);
		  		subself:fov(60);
		  		--subself:zoom(.75);
			end;
				

			
			Def.Quad{
				Name="Glow";
				InitCommand=cmd(setsize,155,155;blend,Blend.Add;diffuseshift;effectcolor1,color("#88CCFF00");effectcolor2,color("#FFFFFF"));
				
			};
			Def.Sprite{
				Name="banner";
				InitCommand=cmd(scaletoclipped,150,150;);
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
			--Debugging only
			--[[Def.BitmapText{
				Name= "text",
				Text="Debug";
				Font= "Common Normal",
				InitCommand=cmd(addy,50;DiffuseAndStroke,Color("White"),Color("Black");shadowlength,1);
			};]]
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus, focus_pos)
		--local offsetFromCenter = 0;
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		local offsetFromFocus = item_index-focus_pos
		local spacing = 80;
		local edgeSpacing = 135;
		--self.container:stoptweening();
		if math.abs(offsetFromCenter) < 5 then
			self.container:stoptweening():decelerate(wheelAnimTime)
			self.container:diffusealpha(1);
			--self.container:visible(true);
		else
			self.container:finishtweening():decelerate(wheelAnimTime):diffusealpha(0);
			--self.container:visible(false);
		end;
		
		
		--self.container:zoom(is_focus and 1.5 or 1);
		if offsetFromFocus < 0 then
			self.container:z(-50+offsetFromFocus):rotationy(-50)
			self.container:x(spacing*offsetFromCenter-100);
		elseif offsetFromFocus > 0 then
			self.container:z(50-offsetFromFocus):rotationy(50)
			self.container:x(100+spacing*offsetFromCenter);
		else
			self.container:x(spacing*.8*offsetFromCenter);
			self.container:z(200):rotationy(0);
		end;
		self.container:draworder(-offsetFromCenter);
		--self.container:z(math.abs(offsetFromFocus)*25);
		--self.container:rotationy(offsetFromFocus*25);
		self.container:GetChild("Glow"):visible(is_focus);
		--self.container:GetChild("text"):settext(offsetFromFocus);
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	-- In this case, those are course objects.
	set= function(s, song)
		local path = song:GetJacketPath();
		if path then
			s.container:GetChild("banner"):Load(path)
			--self:LoadFromCached("Jacket",path);
		else
			path = song:GetBannerPath();
			if path then
				s.container:GetChild("banner"):Load(path)
				--self:LoadFromCached("Banner",path);
			else
				s.container:GetChild("banner"):Load(THEME:GetPathG("Common","fallback banner"))
			end;
		end;
	end,
	--[[gettext=function(self)
		--return self.container:GetChild("text"):gettext()
		return self.get_info_at_focus_pos();
	end,]]
}}

-- Scroller for groups
local groupScroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local groupSelection = 1;

local item_mt_group= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				

			
			Def.Sprite{
				Name="banner";
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		--self.container:hurrytweening(2);
		--self.container:finishtweening();
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 4 then
			self.container:decelerate(.45);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*350)
		self.container:zoom(math.cos(offsetFromCenter*math.pi/3)*.9):diffusealpha(math.cos(offsetFromCenter*math.pi/3)*.9);
		
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		--self.container:GetChild("text"):settext(info);
		--TODO
		local banner = SONGMAN:GetSongGroupBannerPath(info);
		if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback group"));
  		else
  			self.container:GetChild("banner"):Load(banner);
  			--self.container:GetChild("text"):visible(false);
		end;
		self.container:GetChild("banner"):scaletofit(-500,-200,500,200);
	end,
	--[[gettext=function(self)
		--return self.container:GetChild("text"):gettext()
		return self.get_info_at_focus_pos();
	end,]]
}}


local stepsArray;
local stepsSelection = 1;
--Copypasted from the source of ScreenSelectMusic.cpp
--[[local function ChangePreferredDifficulty(pn,dir)
	local d = Enum.Reverse(Difficulty)[GAMESTATE:GetPreferredDifficulty(pn)]
	--SCREENMAN:SystemMessage(d+dir)
	if d+dir > 0 and d+dir<5 then
		GAMESTATE:SetPreferredDifficulty(pn,Difficulty[1+d+dir])
		SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic", "difficulty harder"))
	end;
	--SCREENMAN:SystemMessage(Difficulty[1+d+dir])
end;


local function ChangeSteps(pn,dir)
	if (GAMESTATE:GetCurrentSong()) then
		local selection = GetCurrentStepsIndex(pn) + dir
		if selection < #stepsArray+1 and selection > 0 then
			GAMESTATE:SetCurrentSteps(pn,stepsArray[selection])
			GAMESTATE:SetPreferredDifficulty(pn,stepsArray[selection]:GetDifficulty())
			SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic", "difficulty harder"))
		end;
		--SCREENMAN:SystemMessage(selection)
	else
		ChangePreferredDifficulty(pn,dir)
	end;
end;]]

local function seekFirstValidSteps(pn, style)
	for sel,steps in ipairs(stepsArray) do
		if steps:GetStepsType() == style then
			stepsSelection = sel;
			return true;
		end;
	end;
	return false;
end;

local function ChangeSteps(pn,dir)
	local selection = stepsSelection + dir
	if selection < #stepsArray+1 and selection > 0 then
		--if stepsArray[selection]
		GAMESTATE:SetCurrentSteps(pn,stepsArray[selection]);
		stepsSelection = selection;
	end;
end;

--enums
local SELECTING_GROUP = 0;
local SELECTING_SONG = 1;
local SELECTING_STEPS = 2;

local curState = SELECTING_GROUP;

local currentGroup;
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	--[[if not pn or not SCREENMAN:get_input_redirected(pn) then 
		--SCREENMAN:SystemMessage("Not redirected");
		return
	end]]

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if curState == SELECTING_STEPS then
		--SCREENMAN:SystemMessage("Test");
		if button == "DownRight" or button == "Right" or button == "MenuRight" then
			ChangeSteps(pn,1)
		elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
			ChangeSteps(pn,-1)
		elseif button == "UpRight" or button == "UpLeft" or button == "Up" or button == "MenuUp" then
			curState = SELECTING_SONG;
			MESSAGEMAN:Broadcast("SongUnchosen");
		elseif button == "Center" or button == "Start" then
			local can,reason = GAMESTATE:CanSafelyEnterGameplay()
			if can then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
				--local curFocus = 
				--local offsetFromFocus = item_index-focus_pos
				--local focus_pos = courseScroller.focus_pos;
				courseScroller:run_anonymous_function(function(self, info,info_index,item_index)
					local offsetFromFocus = item_index-courseScroller.focus_pos
					self.container:stoptweening():decelerate(1)
					if offsetFromFocus==0 then
						self.container:rotationy(360):x(0);
					elseif offsetFromFocus > 0 then
						self.container:addx(SCREEN_WIDTH*.8);
					else
						self.container:addx(-SCREEN_WIDTH*.8);
					end;
					--self.container:stoptweening():linear(.3):rotationy(360):sleep(0):rotationy(0);
				end)
			else
				SCREENMAN:SystemMessage("Can't enter gameplay! "..reason);
			end;
		end;
	elseif curState == SELECTING_SONG then
		if button == "UpRight" or button == "UpLeft" or button == "Up" or button == "MenuUp" then
			curState = SELECTING_GROUP;
			MESSAGEMAN:Broadcast("StartSelectingGroup");
		elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			--If current selection is 1, set current selection to the number of songs in the group (aka the end of the group)
			if songSelection == 1 then
				songSelection = #currentGroup;
			else
				songSelection = songSelection - 1 ;
			end;
			if courseScroller:get_focus_offset() < -3 then
				courseScroller:scroll_by_amount(-1)
			else
				courseScroller:move_focus_by(-1);
			end;
			--courseScroller:scroll_by_amount(-1);
			GAMESTATE:SetCurrentSong(currentGroup[songSelection])
			play_sample_music();
			MESSAGEMAN:Broadcast("CurrentSongChanged",{Selection=songSelection,Total=#currentGroup});
		elseif button == "DownRight" or button == "Right" or button == "MenuRight" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if songSelection == #currentGroup then
				songSelection = 1;
			else
				songSelection = songSelection + 1
			end
			if courseScroller:get_focus_offset() > 3 then
				courseScroller:scroll_by_amount(1);
			else
				courseScroller:move_focus_by(1);
			end;
			GAMESTATE:SetCurrentSong(currentGroup[songSelection])
			play_sample_music();
			MESSAGEMAN:Broadcast("CurrentSongChanged",{Selection=songSelection,Total=#currentGroup});
		elseif button == "Center" or button == "Start" then
			--[[SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);]]
			--currentGroup = SONGMAN:GetSongsInGroup(GROUPWHEEL_GROUPS[groupSelection],true)
			assert(GAMESTATE:GetCurrentSong(),"Song is nil! Can't continue!");
			stepsArray = GAMESTATE:GetCurrentSong():GetAllSteps();
			--assert(#stepsArray > 0,"Hey idiot, this song has no valid steps.")
			if seekFirstValidSteps(pn,'StepsType_Pump_Single') then
				GAMESTATE:SetCurrentSteps(pn,stepsArray[stepsSelection]);
				--courseScroller:set_info_set(currentGroup,1);
				MESSAGEMAN:Broadcast("SongChosen");
				--Changing the steps seems to broadcast this anyways, so we don't need to do it
				--MESSAGEMAN:Broadcast("CurrentSteps"..)
				curState = SELECTING_STEPS
			else
				SCREENMAN:SystemMessage("This song has no steps for your current style. Cannot continue.")
			end;
		end;
		--SCREENMAN:SystemMessage(courseScroller:get_focus_offset());
	elseif curState == SELECTING_GROUP then
		if button == "Center" or button == "Start" then
			--[[SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);]]
			currentGroup = SONGMAN:GetSongsInGroup(GROUPWHEEL_GROUPS[groupSelection],true)
			assert(#currentGroup > 0,"Hey idiot, you don't have any songs in this group.")
			courseScroller:move_focus_by(-courseScroller:get_focus_offset())
			--courseScroller:scroll_to_pos(1);
			courseScroller:set_info_set(currentGroup,1)
			courseScroller:scroll_to_start();
			songSelection = 1;
			GAMESTATE:SetCurrentSong(currentGroup[songSelection])
			MESSAGEMAN:Broadcast("StartSelectingSong");
			curState = SELECTING_SONG
		elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if groupSelection == 1 then
				groupSelection = #GROUPWHEEL_GROUPS;
			else
				groupSelection = groupSelection - 1 ;
			end;
			groupScroller:scroll_by_amount(-1);
			setenv("cur_group",GROUPWHEEL_GROUPS[groupSelection]);
			MESSAGEMAN:Broadcast("GroupChange");
			MESSAGEMAN:Broadcast("PreviousGroup");
			
		elseif button == "DownRight" or button == "Right" or button == "MenuRight" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if groupSelection == #GROUPWHEEL_GROUPS then
				groupSelection = 1;
			else
				groupSelection = groupSelection + 1
			end
			groupScroller:scroll_by_amount(1);
			setenv("cur_group",GROUPWHEEL_GROUPS[groupSelection]);
			MESSAGEMAN:Broadcast("GroupChange");
			MESSAGEMAN:Broadcast("NextGroup");
		--elseif button == "UpLeft" or button == "UpRight" then
			--SCREENMAN:AddNewScreenToTop("ScreenSelectSort");
		
		elseif button == "Back" then
			--[[SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);]]
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
		elseif button == "MenuDown" then
			--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
			local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
			SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
			
			--local curItem = scroller:get_actor_item_at_focus_pos();
			--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		else
			--SCREENMAN:SystemMessage("unknown button: "..button)
			--SCREENMAN:SystemMessage(strArrayToString(button_history));
			--musicwheel:SetOpenSection("");
			--SCREENMAN:SystemMessage(musicwheel:GetNumItems());
			--[[local wheelFolders = {};
			for i = 1,7,1 do
				wheelFolders[#wheelFolders+1] = musicwheel:GetWheelItem(i):GetText();
			end;
			SCREENMAN:SystemMessage(strArrayToString(wheelFolders));]]
			--SCREENMAN:SystemMessage(musicwheel:GetWheelItem(0):GetText());
		end;
	end;
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--[[SCREENMAN:set_input_redirected(PLAYER_1, true);
		SCREENMAN:set_input_redirected(PLAYER_2, true);]]
	end;
}

--CourseScroller frame
local s = Def.ActorFrame{
	--LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations"));
	LoadActor("decorations");
}
--THE BACKGROUND VIDEO
--s[#s+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{};
s[#s+1] = courseScroller:create_actors("foo", numWheelItems, item_mt_course, SCREEN_CENTER_X, SCREEN_CENTER_Y-80);
--s[#s+1] = LoadActor("difficultyIcons");
--s[#s+1] = LoadActor("coursePreview");

--GroupScroller frame
local g = Def.ActorFrame{
	
	--InitCommand=cmd(diffusealpha,0);
	--InitCommand=cmd(SetDrawByZPosition,true);
	OnCommand=function(self)
		groupScroller:set_info_set(GROUPWHEEL_GROUPS, 1);
		courseScroller:set_info_set(SONGMAN:GetSongsInGroup(GROUPWHEEL_GROUPS[groupSelection],true),1)
	end;

	SongChosenMessageCommand=function(self)
		isPickingDifficulty = true;
	end;
	TwoPartConfirmCanceledMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	SongUnchosenMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	
	PickingSongCommand=function(self)
		isPickingDifficulty = false;
	end;
	
	--[[CodeMessageCommand=function(self,param)
		local codeName = param.Name		-- code name, matches the one in metrics
		--player is not needed
		--local pn = param.PlayerNumber	-- which player entered the code
		if codeName == "GroupSelectPad1" or codeName == "GroupSelectPad2" or codeName == "GroupSelectButton1" or codeName == "GroupSelectButton2" then
			if isPickingDifficulty then return end; --Don't want to open the group select if they're picking the difficulty.
			MESSAGEMAN:Broadcast("StartSelectingGroup");
			--SCREENMAN:SystemMessage("Group select opened.");
			--No need to check if both players are present... Probably.
			SCREENMAN:set_input_redirected(PLAYER_1, true);
			SCREENMAN:set_input_redirected(PLAYER_2, true);
		else
			--Debugging only
			--SCREENMAN:SystemMessage(codeName);
		end;
	end;]]
	
	StartSelectingGroupMessageCommand=function(self,params)
		local curItem = groupScroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		curItem.container:GetChild("banner"):stoptweening():scaletofit(-500,-200,500,200);
		self:stoptweening():linear(.5):diffusealpha(1);
		SOUND:DimMusic(0.3,65536);
		MESSAGEMAN:Broadcast("GroupChange");
	end;

	StartSelectingSongMessageCommand=function(self)
		self:linear(.3):diffusealpha(0);
		groupScroller:get_actor_item_at_focus_pos().container:GetChild("banner"):linear(.3):zoom(0);
	end;

}

--THE BACKGROUND VIDEO
--[[g[#g+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};]]

--[[g[#g+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0;fadetop,1;blend,Blend.Add);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,0.87);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
}]]
g[#g+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0;);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,0.87);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
}

--FLASH
g[#g+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.3;diffusealpha,0);
};

--Add scroller here
g[#g+1] = groupScroller:create_actors("foo", numWheelItems, item_mt_group, SCREEN_CENTER_X, SCREEN_CENTER_Y);


	
--Game Folder counters
--Text BACKGROUND
--[[g[#g+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/songartist_name"))..{
	InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-75;zoomto,547,46);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};

g[#g+1] = LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(Center;zoom,0.2;y,SCREEN_BOTTOM-75;uppercase,true;strokecolor,0,0.15,0.3,0.5;);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	GroupChangeMessageCommand=function(self)
		self:finishtweening();
		self:linear(0.3);
		self:diffusealpha(1);
		--songcounter = string.format(THEME:GetString("ScreenSelectGroup","SongCount"),#SONGMAN:GetSongsInGroup(getenv("cur_group"))-1)
		local songcounter = string.format(THEME:GetString("ScreenSelectCourse","CourseCount"),-1)
		local foldercounter = string.format("%02i",groupSelection).." / "..string.format("%02i",#GROUPWHEEL_GROUPS)
		self:settext(songcounter.."\n"..foldercounter);
	end;
};]]

t[#t+1] = s;
t[#t+1] = g;
	--Current Group/Playlist
--[[t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/current_group"))..{
		InitCommand=cmd(x,0;y,5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
		--StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
		--StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};]]
	
--[[t[#t+1] = LoadFont("Common Normal")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=function(self)
			self:uppercase(true);
			self:settext("Pick mixtapes");
		end;
	};
	
t[#t+1] = LoadFont("Common Normal")..{
		Name="CurrentGroupName";
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.25);
		OnCommand=cmd(playcommand,"UpdateText");
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"UpdateText");
		--StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=cmd(playcommand,"UpdateText");
		UpdateTextCommand=function(self)
			self:settext(GROUPWHEEL_GROUPS[groupSelection]);
		end;
	};]]
--t[#t+1] = 	LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/arrow_shine"))..{};

--t[#t+1] = 

return t;
