modifier_sniper_e_ready = class({})
local self = modifier_sniper_e_ready

if IsServer() then
    function modifier_sniper_e_ready:OnCreated()
        self:StartIntervalThink(0.1)
    end

    function modifier_sniper_e_ready:OnIntervalThink()
        local hero = self:GetParent():GetParentEntity()
        if not hero:FindAbility("sniper_e"):IsCooldownReady() and self.hasParticle == true then 
            ParticleManager:DestroyParticle(self.particle, false)
            self.hasParticle = false
        end
        if hero:FindAbility("sniper_e"):IsCooldownReady() and not hero:FindModifier("modifier_sniper_e") and not self.hasParticle then
            self.particle = FX("particles/sniper_e/sniper_e_foot_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), {
                release = false
            })
            self.hasParticle = true

            self:AddParticle(self.particle, false, false, 0, false, false)
        end
    end
end

function modifier_sniper_e_ready:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_sniper_e_ready:GetModifierMoveSpeedBonus_Percentage(params)
    if self.hasParticle == true then
        return 10
    else
        return 0
    end
end