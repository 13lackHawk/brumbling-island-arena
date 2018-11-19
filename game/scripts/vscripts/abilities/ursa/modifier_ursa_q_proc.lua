modifier_ursa_q_proc = class({})

if IsServer() then
    function modifier_ursa_q_proc:OnCreated()
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
    
    function modifier_ursa_q_proc:OnAbilityImmediate(event)
        self:OnAbilityPhaseStart(event.ability)
    end

    function modifier_ursa_q_proc:OnAbilityPhaseStart(ability)
        local target = ability:GetCaster():GetParentEntity()
        local parent = self:GetParent():GetParentEntity()
        local caster = self:GetAbility():GetCaster():GetParentEntity()

        if not ability.canBeSilenced then
            return 
        end

        if target == parent then
            parent:AddNewModifier(caster, self:GetAbility(), "modifier_silence_lua", { duration = 2.0 })
            parent:Damage(caster, 2)
            caster:EmitSound("Arena.Ursa.ProcQ")
            FX("particles/ursa_q/ursa_q_endcap.vpcf", PATTACH_ABSORIGIN, parent, {
               cp0 = { ent = self:GetParent(), point = "attach_hitloc" },
               cp3 = { ent = self:GetParent(), point = "attach_hitloc" },
               release = true
            })
            self:Destroy()

            return false
        end
    end
end

function modifier_ursa_q_proc:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_START,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_ursa_q_proc:GetEffectName()
    return "particles/ursa_q/ursa_q.vpcf"
end

function modifier_ursa_q_proc:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ursa_q_proc:IsDebuff()
    return true
end

function modifier_ursa_q_proc:GetModifierMoveSpeedBonus_Percentage(params)
    return -25
end