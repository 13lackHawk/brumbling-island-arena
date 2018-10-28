modifier_venge_a = class({})

function modifier_venge_a:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_venge_a:GetModifierMoveSpeedBonus_Percentage(params)
    return 20
end

function modifier_venge_a:GetEffectName()
    return "particles/venge_a/venge_a_speed.vpcf"
end

function modifier_venge_a:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end