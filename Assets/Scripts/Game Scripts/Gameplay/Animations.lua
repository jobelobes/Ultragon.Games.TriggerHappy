--Animations

Animations = {
	FrameDuration = 1 / 100,
	Enabled = false,
	IsAnimating = false
}

Animations.StaticData = {
	
	Idle = {
		FrameStart = 0,
		FrameCount = 10,
		Repeat = true,
	},
	Run = {
		FrameStart = 11,
		FrameCount = 10,
		Repeat = true,
	},
	Jump = {
		FrameStart = 21,
		FrameCount = 10,
		Repeat = false,
	},
	Die = {
		FrameStart = 31,
		FrameCount = 10,
		Repeat = false,
	},
	Strafe = {
		FrameStart = 41,
		FrameCount = 10,
		Repeat = true,
	},
	Taunt = {
		FrameStart = 51,
		FrameCount = 10,
		Repeat = false,
	}
}

Animations.Functions
Animations.Update = function(elapsed)

end