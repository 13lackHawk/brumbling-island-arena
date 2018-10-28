modifier_bara_e_slow = class({})
local self = modifier_bara_e_slow

function self:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function self:isDebuff()
	return true
end

function self:GetModifierMoveSpeedBonus_Percentage(params)
	return -20
end