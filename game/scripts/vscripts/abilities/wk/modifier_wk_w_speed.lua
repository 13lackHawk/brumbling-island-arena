modifier_wk_w_speed = class({})

function modifier_wk_w_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_wk_w_speed:GetModifierMoveSpeedBonus_Percentage(params)
    return 20
end

function modifier_wk_w_speed:GetEffectName()
    return "particles/econ/events/ti8/phase_boots_ti8.vpcf"
end

function modifier_wk_w_speed:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_wk_w_speed:StatusEffectPriority()
    return 2
end