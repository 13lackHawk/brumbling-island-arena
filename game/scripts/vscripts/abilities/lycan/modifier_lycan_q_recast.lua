modifier_lycan_q_recast = class({})
local self = modifier_lycan_q_recast
self.remove = false

if IsServer() then
    --[[function self:OnCreated()
        self:StartIntervalThink(0)
    end

    function self:OnIntervalThink()
    	local hero = self:GetParent():GetParentEntity()
    	if self.remove == true then
    		hero:SwapAbilities("lycan_q_sub", "lycan_q")
    		self:Destroy()
    	end
    	for _, ent in pairs(hero.round.spells:GetValidTargets()) do
        	if instanceof(ent, LycanWolf) and ent.owner.team == hero.owner.team then
            	self.remove = false
            --elseif instanceof(ent, LycanWolf) and not ent:Alive() then
            --	self:Destroy()
            --end
        	end
    	end
    end--]]
    
    function self:OnDestroy()
    	local hero = self:GetParent():GetParentEntity()
    	hero:SwapAbilities("lycan_q_sub", "lycan_q")
    end
end

function self:IsHidden()
    return true
end