modifier_bara_w_speed = class({})

function modifier_bara_w_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_bara_w_speed:GetModifierMoveSpeedBonus_Percentage(params)
    return 25
end