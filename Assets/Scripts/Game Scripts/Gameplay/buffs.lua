Buff = {}
Buff.CreateBuff = function(name, desc, icon)
   --Create the game component
   local ret =
   {
   		Name = name,
   		Description = desc,
   		Icon = icon,
   }   

   return ret
end

Util.Debug("Buffs Loaded")