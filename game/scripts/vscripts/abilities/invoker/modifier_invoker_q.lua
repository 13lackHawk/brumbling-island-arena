modifier_invoker_q = class({})

function modifier_invoker_q:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_invoker_q:GetModifierMoveSpeedBonus_Percentage(params)
    return 25
end

function modifier_invoker_q:GetEffectName()
    return "particles/econ/events/ti6/phase_boots_ti6.vpcf"
end

function modifier_invoker_q:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_invoker_q:GetStatusEffectName()
    return "particles/status_fx/status_effect_alacrity.vpcf"
end

function modifier_invoker_q:StatusEffectPriority()
    return 2
end