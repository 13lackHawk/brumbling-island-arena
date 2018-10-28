modifier_bara_e = class({})

function modifier_bara_e:GetEffectName()
    return "particles/bara_w/bara_w.vpcf"
end

function modifier_bara_e:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_bara_e:StatusEffectPriority()
    return 10
end

function modifier_bara_e:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bara_e:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
    }

    return state
end

function modifier_bara_e:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_bara_e:GetModifierMoveSpeed_Max(params)
    return 1100
end

function modifier_bara_e:GetModifierMoveSpeedOverride(params)
    return 1000
end

function modifier_bara_e:DestroyOnExpire()
    return false
end

function modifier_bara_e:OnDamageReceived(source, hero, amount, isPhysical)
    if not isPhysical then
        return true
    end

    return false
end