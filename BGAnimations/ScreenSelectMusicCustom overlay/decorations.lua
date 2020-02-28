--do return Def.ActorFrame{} end;

--local t = LoadFallbackB();
local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{

	-- CURRENT SONG NAME
		LoadFont("_charter bt 40px")..{	
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP-50;zoom,.75;maxwidth,700;diffusealpha,0);
			OnCommand=cmd(sleep,0.5;decelerate,0.5;addy,75);
			OffCommand=cmd(decelerate,0.15;zoom,0);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
				if song then
					self:settext(song:GetDisplayFullTitle());
					self:finishtweening();self:diffusealpha(0);
					self:decelerate(0);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0);self:diffusealpha(0);
				end;
			end;

		};
		-- CURRENT SONG ARTIST
		LoadFont("_charter bt 40px")..{	
			InitCommand=cmd(zoom,.5;maxwidth,900;diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_TOP-100);
			OnCommand=cmd(sleep,0.5;decelerate,0.5;addy,150);
			OffCommand=cmd(decelerate,0.15;zoom,0);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
				if song then
					self:settext(song:GetDisplayArtist());
					self:finishtweening();self:diffusealpha(0);
					self:decelerate(0);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0);self:diffusealpha(0);
				end;
			end;


		};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10);
	
	LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
		InitCommand=cmd(zoom,0;y,50);
		OnCommand=cmd(sleep,0.5;decelerate,0.5;zoom,1.5);
		SongChosenMessageCommand=cmd(decelerate,0.05;zoom,2);
		SongUnchosenMessageCommand=cmd(decelerate,0.05;zoom,1.5);
		OffCommand=cmd(decelerate,0.15;zoom,0);
	};
		--BPM DISPLAY
	LoadFont("_charter bt 40px")..{
		InitCommand=cmd(x,-220;y,95;zoom,0.6;diffusealpha,0;sleep,1;linear,1;diffusealpha,1;horizalign,left);
		SongChosenMessageCommand=cmd(decelerate,0.05;addy,100);
		SongUnchosenMessageCommand=cmd(decelerate,0.05;addy,-100);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("BPM:");
		end;
	};
	
	--add 80 to the x value
	LoadFont("_charter bt 40px")..{
		InitCommand=cmd(horizalign,left;x,-150;y,95;zoom,0.6;maxwidth,200;diffusealpha,0;sleep,1;linear,1;diffusealpha,1;);
		SongChosenMessageCommand=cmd(decelerate,0.05;addy,100);
		SongUnchosenMessageCommand=cmd(decelerate,0.05;addy,-100);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)

			local song = GAMESTATE:GetCurrentSong();
			if song then
				local speedvalue;
				if song:IsDisplayBpmRandom() then
					speedvalue = "???";
				else
					local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
					local lobpm = math.ceil(rawbpm[1]);
					local hibpm = math.ceil(rawbpm[2]);
					if lobpm == hibpm then
						speedvalue = hibpm
					else
						speedvalue = lobpm.."-"..hibpm
					end;
				end;
				self:settext(speedvalue);
			else
				self:settext("N/A");
			end;
		end;
	};

		--LENGTH DISPLAY
	LoadFont("_charter bt 40px")..{
		InitCommand=cmd(x,SCREEN_CENTER_X+150;y,SCREEN_CENTER_Y+20;zoom,0.7;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		SongChosenMessageCommand=cmd(decelerate,0.05;addy,100);
		SongUnchosenMessageCommand=cmd(decelerate,0.05;addy,-100);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("LENGTH:");
			(cmd(finishtweening;zoom,0.7)) (self)
		end;
	};

	LoadFont("_charter bt 40px")..{
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X+220;y,SCREEN_CENTER_Y+20;zoom,0.7;maxwidth,120;diffusealpha,0;sleep,1;linear,1;diffusealpha,1);
		SongChosenMessageCommand=cmd(decelerate,0.05;addy,100);
		SongUnchosenMessageCommand=cmd(decelerate,0.05;addy,-100);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
		if GAMESTATE:GetCurrentSong() then
			local length = GAMESTATE:GetCurrentSong():MusicLengthSeconds()
			self:settext(SecondsToMMSS(length));
		else
			self:settext("N/A");
		end;
	end;
	};

		--GROUP DISPLAY
	--[[LoadFont("_charter bt 40px")..{
		InitCommand=cmd(x,SCREEN_CENTER_X-240;y,SCREEN_CENTER_Y-100;zoom,0.7;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("GROUP:");
			(cmd(finishtweening;zoom,0.7)) (self)
		end;
	};]]

	LoadFont("_charter bt 40px")..{
		InitCommand=cmd(horizalign,left;xy,-175,-0;zoom,0.7;maxwidth,500;diffusealpha,0;sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			if GAMESTATE:GetCurrentSong() then
				self:settext("GROUP: "..GAMESTATE:GetCurrentSong():GetGroupName());
			else
				self:settext("GROUP: N/A");
			end;
		end;
	};
}

t[#t+1] = Def.ActorFrame{



	LoadActor("arrows")..{
		InitCommand=cmd(zoom,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(sleep,0.5;decelerate,0.5;zoom,1);
		OffCommand=cmd(decelerate,0.5;zoom,0);
	};

	Def.Sprite{
		Texture="pill",
		InitCommand=cmd(zoom,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+160);
		OnCommand=cmd(sleep,0.75;decelerate,0.5;zoom,1);
		OffCommand=cmd(decelerate,0.5;zoom,0);
	};

	--help text
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+160;zoom,.6;diffusealpha,0;valign,.65;maxwidth,350);
		OnCommand=cmd(sleep,1.5;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		Text="Select any song and pick a chart!";
		--[[CurrentSongChangedMessageCommand=function(self)
			self:settext("Select a song and clear its requirements!");
			(cmd(linear,0.25;zoom,1)) (self)
		end;]]
		SongChosenMessageCommand=function(self)
			self:settext("Select a stepchart and press CENTER step.");
			--(cmd(linear,0.25;zoom,1)) (self)
		end;
		SongUnchosenMessageCommand=function(self)
			self:settext("Select any song and pick a chart!");
			--(cmd(linear,0.25;zoom,1)) (self)
		end;
	};
};


--Arrow text
t[#t+1] = Def.ActorFrame{
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_LEFT+150;y,SCREEN_TOP+15;skewx,-0.2;zoom,1;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("Previous Group");
			(cmd(finishtweening;zoom,1)) (self)
		end;
	};	
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_LEFT+150;y,SCREEN_TOP+42;zoom,0.7;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("(PRESS TWICE)");
			(cmd(finishtweening;zoom,0.7)) (self)
		end;
	};
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_RIGHT-150;y,SCREEN_TOP+15;skewx,-0.2;zoom,1;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("Next Group");
			(cmd(finishtweening;zoom,1)) (self)
		end;
	};
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_RIGHT-150;y,SCREEN_TOP+42;zoom,0.7;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("(PRESS TWICE)");
			(cmd(finishtweening;zoom,0.7)) (self)
		end;
	};
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_LEFT+70;y,SCREEN_BOTTOM-30;horizalign,left;skewx,-0.2;zoom,1;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("Previous Song");
			(cmd(finishtweening;zoom,1)) (self)
		end;
	};
	LoadFont("_alternategotno2 40px")..{
		InitCommand=cmd(x,SCREEN_RIGHT-70;y,SCREEN_BOTTOM-30;horizalign,right;skewx,-0.2;zoom,1;diffusealpha,0);
		OnCommand=cmd(sleep,1;linear,1;diffusealpha,1);
		OffCommand=cmd(visible,false);
		CurrentSongChangedMessageCommand=function(self)
			self:settext("Next Song");
			(cmd(finishtweening;zoom,1)) (self)
		end;
	};
};

--Sound effects
t[#t+1] = Def.ActorFrame{
	LoadActor("sfx/explosion")..{
		OffCommand=cmd(queuecommand,"PlaySound");
		PlaySoundCommand=cmd(play);
	};
	LoadActor("sfx/accept")..{
		SongChosenMessageCommand=cmd(queuecommand,"PlaySound");
		PlaySoundCommand=cmd(play);
		OffCommand=function(self)
			SOUND:StopMusic()
		end;
	};
	LoadActor("sfx/cancel")..{
		SongUnchosenMessageCommand=cmd(queuecommand,"PlaySound");
		PlaySoundCommand=cmd(play);
	};
};


return t
