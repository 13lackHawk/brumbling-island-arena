modifier_rubick_q = class({})
local self = modifier_rubick_q

if IsServer() then
    --[[function self:OnCreated()
        local hero = self:GetParent():GetParentEntity()

        hero:RemoveModifier("modifier_cm_e")
    end]]--

    function self:OnDestroy()
        local hero = self:GetParent():GetParentEntity()

        hero:SwapAbilities("rubick_q_sub", "rubick_q")
        --hero:FindAbility("rubick_q"):StartCooldown(hero:FindAbility("rubick_q"):GetCooldown(1))
    end
end

function self:IsHidden()
    return true
end