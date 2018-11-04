modifier_axe_w_dmg= class({})
local self = modifier_axe_w_dmg

function self:GetDmg(amount)
    self.delayedDamage = amount
    return self.delayedDamage
end

if IsServer() then
    function self:OnDestroy()
        local hero = self:GetCaster():GetParentEntity()
        hero:Damage(hero, self.delayedDamage)
    end
end