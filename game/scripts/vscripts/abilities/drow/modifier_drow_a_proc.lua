modifier_drow_a_proc = class({})

if IsServer() then
    function modifier_drow_a_proc:OnAbilityExecuted(event)
        local target = event.unit:GetParentEntity()
        local hero = self:GetCaster().hero
        local shouldBeAffectedByAbility = target:FindModifier("modifier_drow_a_proc")

        if not event.ability.canBeSilenced then
            return
        end

        if shouldBeAffectedByAbility then
            target:AddNewModifier(target, hero:FindAbility("drow_a"), "modifier_drow_a", { duration = 1.0 })
        end
    end
end

function modifier_drow_a_proc:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }

    return funcs
end

function modifier_drow_a_proc:GetEffectName()
    return "particles/drow_a/drow_a_debuff.vpcf"
end

function modifier_drow_a_proc:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end