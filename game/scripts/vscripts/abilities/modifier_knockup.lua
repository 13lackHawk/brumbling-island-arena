modifier_knockup = class({})

function modifier_knockup:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end

function modifier_knockup:Airborne()
    return true
end

function modifier_knockup:IsHidden()
	return true
end

function modifier_knockup:IsStunDebuff()
    return true
end

function modifier_knockup:IsDebuff()
    return true
end

function modifier_knockup:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
