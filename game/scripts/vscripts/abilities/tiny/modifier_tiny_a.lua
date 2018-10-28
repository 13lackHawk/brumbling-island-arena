modifier_tiny_a = class({})
local self = modifier_tiny_a

if IsServer() then
    function modifier_tiny_a:OnCreated()
    	   self.particle = FX("particles/tiny_a/tiny_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), {
                release = false
            })

            self:AddParticle(self.particle, false, false, 0, false, false)
    end

    function modifier_tiny_a:OnDestroy()
        --local hero = self:GetParent():GetParentEntity()
        ParticleManager:DestroyParticle(self.particle, false)
    end
end

--[[function modifier_tiny_a:GetStatusEffectName()
    return "particles/status_fx/status_effect_enchantress_untouchable.vpcf"
end

function modifier_tiny_a:StatusEffectPriority()
    return 1
end]]--