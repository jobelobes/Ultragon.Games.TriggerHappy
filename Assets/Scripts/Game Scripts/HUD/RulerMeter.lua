local RULER_WIDTH = 200
local RULER_HEIGHT = 37
local RULER_IMAGE_WIDTH = 200
local RULER_IMAGE_HEIGHT = 37

RulerMeter = 
{
	--construct a ruler meter object
	Build = function(parent, root, source, property, maxVal, percAlong, ninePatch, left)
		local ret = {
			RootPosition = root,
			Source = source,
			Property = property,
			Max = maxVal,
			Current = -100,
			Left = left,
			PercentageAlong = percAlong,
			Enabled = false,
		}
				
		--meter image
		ret.RulerImage = Singularity.Gui.Image:new("Ruler Image")
		ret.RulerImage:Set_Texture(ninePatch)
		ret.RulerImage:Set_Visible(false)
		ret.RulerImage:Set_Size(Vector2:new(RULER_WIDTH, RULER_HEIGHT))
		--allow left or right moving rulers
		if(left) then
			ret.RulerImage:Set_Position(Vector2:new(root.x, root.y - RULER_HEIGHT))
		else
			ret.RulerImage:Set_Position(Vector2:new(root.x-RULER_WIDTH, root.y - RULER_HEIGHT))
		end		
		parent:AddControl(ret.RulerImage)
		
		--meter value label
		ret.DisplayLabel = Singularity.Gui.Label:new("Meter Label", "100")
		ret.DisplayLabel:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
		ret.DisplayLabel:Set_Visible(false)
		local width = Singularity.Gui.Font:GetStringWidth(ret.DisplayLabel:Get_Font(), ret.DisplayLabel:Get_Text())
		local height = 4
		ret.DisplayLabel:Set_Size(Vector2:new(width, height))
		local labelX
		if(left) then
			labelX = ret.RulerImage:Get_Position().x + (1-percAlong) * RULER_WIDTH 
		else
			labelX = ret.RulerImage:Get_Position().x + (percAlong) * RULER_WIDTH
		end
		ret.DisplayLabel:Set_Position(Vector2:new(labelX, root.y - RULER_HEIGHT * 0.5))
		parent:AddControl(ret.DisplayLabel)
				
		--give functions to the object
		ret = Util.JoinTables(Util.ShallowTableCopy(RulerMeter.Functions), ret)
		--store meter for processing
		table.insert(RulerMeter.Meters, ret)		
		
		Util.Debug("Finished building ruler meter")
		return ret
	end,
	Functions =
	{		
		AdjustTo = function(self, perc)
		
			local off
			--calc x offset using percentage
			if(self.Left) then
				off = self.RootPosition.x - perc * RULER_WIDTH
			else
				off = self.RootPosition.x + (perc - 1) * RULER_WIDTH
			end
			local curX = self.RulerImage:Get_Position().x
			
			--stop any existing animation
			if(self.RulerSet) then
				Tween.Tweener.Stop(self.RulerSet)
			end

			--tween to the new value
			local tween = Tween.Tween.MakeLinearTween(0.3,0,off-curX)
			self.RulerSet = Tween.TweenSet.MakeTweenSet()
			self.RulerSet:Bind(tween, 0, "GetX", "SetX")
			self.RulerSet:SetTarget(self)
			Tween.Tweener.Play(self.RulerSet)
		end,
		--called by tween
		SetX = function(self, newX)
			local pos = self.RulerImage:Get_Position()
			pos.x = newX
			self.RulerImage:Set_Position(pos)
			
			--update meter label
			local labelY = self.DisplayLabel:Get_Position().y
			local labelX
			if(self.Left) then
				local width  = Singularity.Gui.Font:GetStringWidth(self.DisplayLabel:Get_Font(), self.DisplayLabel:Get_Text())
				labelX = pos.x - RULER_WIDTH * (self.PercentageAlong-1) - width
			else
				labelX = pos.x + RULER_WIDTH * (self.PercentageAlong-1) + RULER_WIDTH
			end
			self.DisplayLabel:Set_Position(Vector2:new(labelX, labelY))
		end,
		GetX = function(self)
			return self.RulerImage:Get_Position().x
		end,
		Enable = function(self)
			self.Enabled = true
			self.RulerImage:Set_Visible(true)
			self.DisplayLabel:Set_Visible(true)
		end,
		Disable = function(self)
			--self.Enabled = false
			self.RulerImage:Set_Visible(false)
			self.DisplayLabel:Set_Visible(false)
		end,
		--set the source of the meter value
		SetSource = function(self, source)
			self.Source = source
		end
	},
	RulerWidth = RULER_WIDTH,
	RulerHeight = RULER_HEIGHT,
}

RulerMeter.Meters = {}

RulerMeter.Update = function(elapsed)

	for i,meter in ipairs(RulerMeter.Meters) do
		if(meter.Enabled and meter.Source) then
			local val = meter.Source[meter.Property]
			--update the meter if the value changed
			if(val ~= meter.Current) then
				meter.Current = val
				meter.DisplayLabel:Set_Text(tostring(val))
				meter:AdjustTo(val/meter.Max)
			end
		end
	end

end

