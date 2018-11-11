modifier_storm_spirit_a_slow = class({})

function modifier_storm_spirit_a_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_storm_spirit_a_slow:IsDebuff()
    return true
end

function modifier_storm_spirit_a_slow:GetModifierMoveSpeedBonus_Percentage(params)
    return -50
end

function modifier_storm_spirit_a_slow:GetEffectName()
    return "particles/storm_a/storm_a_root.vpcf"
end

function modifier_storm_spirit_a_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end