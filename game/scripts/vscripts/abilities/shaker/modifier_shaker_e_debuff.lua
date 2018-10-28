modifier_shaker_e_debuff = class({})

function modifier_shaker_e_debuff:CheckState()
    local state = {
		[MODIFIER_STATE_DISARMED] = true
    }

    return state
end

function modifier_shaker_e_debuff:IsDebuff()
    return true
end

function modifier_shaker_e_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_shaker_e_debuff:GetEffectName()
    return "particles/items2_fx/heavens_halberd_debuff.vpcf"
end

function modifier_shaker_e_debuff:GetModifierMoveSpeedBonus_Percentage(params)
    return -30
end

