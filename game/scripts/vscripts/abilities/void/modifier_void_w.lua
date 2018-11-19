modifier_void_w = class({})

if IsServer() then
    function modifier_void_w:OnCreated()
        local unit = self:GetParent()

        local count = unit:GetAbilityCount() - 1
        for i=0,count do
            local ability = unit:GetAbilityByIndex(i)

            if ability and (ability:IsInAbilityPhase() or ability:IsChanneling()) then
                self:OnAbilityPhaseStart(ability)
                break
            end
        end
    end
end

function modifier_void_w:OnAbilityPhaseStart(ability)
    local target = ability:GetCaster():GetParentEntity()
    local parent = self:GetParent():GetParentEntity()
    local caster = self:GetAbility():GetCaster():GetParentEntity()

    if not ability.canBeSilenced then
        return 
    end

    if target == parent then
        target:AddNewModifier(target, self:GetAbility(), "modifier_silence_lua", { duration = 2.0 })
        target:Damage(caster, 2)
        target:EmitSound("Arena.Void.ProcW")

        self:Destroy()

        return false
    end
end

function modifier_void_w:OnAbilityImmediate(event)
    return self:OnAbilityPhaseStart(event.ability)
end

function modifier_void_w:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_START
    }

    return funcs
end

function modifier_void_w:GetEffectName()
    return "particles/void_w/void_w.vpcf"
end

function modifier_void_w:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end