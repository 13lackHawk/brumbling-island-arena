modifier_brew_q = class({})

if IsServer() then
    function modifier_brew_q:OnCreated()
        local unit = self:GetParent()

        local count = unit:GetAbilityCount() - 1
        for i=0,count do
            local ability = unit:GetAbilityByIndex(i)

            if ability and IsAttackAbility(ability) and (ability:IsInAbilityPhase() or ability:IsChanneling()) then
                self:OnAbilityPhaseStart(ability)
                break
            end
        end
    end

    function modifier_brew_q:OnAbilityImmediate(event)
        self:OnAbilityPhaseStart(event.ability)
    end

    function modifier_brew_q:OnAbilityPhaseStart(ability)
        local target = ability:GetCaster():GetParentEntity()
        local parent = self:GetParent():GetParentEntity()
        local caster = self:GetAbility():GetCaster():GetParentEntity()

        if target == parent and IsAttackAbility(ability) then
            parent:AddNewModifier(caster, self:GetAbility(), "modifier_tinker_q", { duration = 2.0 })
            caster:EmitSound("Arena.Void.ProcW")
            self:Destroy()

            return false
        end
    end
end

function modifier_brew_q:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_START
    }

    return funcs
end

function modifier_brew_q:GetEffectName()
    return "particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf"
end

function modifier_brew_q:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end