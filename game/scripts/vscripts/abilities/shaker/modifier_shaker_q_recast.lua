modifier_shaker_q_recast = class({})

if IsServer() then
    function modifier_shaker_q_recast:OnDestroy()
    	local hero = self:GetCaster().hero
    	hero:SwapAbilities("shaker_q_sub", "shaker_q")
    end
end

function modifier_shaker_q_recast:IsHidden()
    return true
end