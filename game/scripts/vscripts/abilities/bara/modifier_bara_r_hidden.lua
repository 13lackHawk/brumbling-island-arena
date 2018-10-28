modifier_bara_r_hidden = class ({})

function modifier_bara_r_hidden:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_STUNNED] = true
	}

	return state
end

function modifier_bara_r_hidden:IsHidden()
	return true
end

function modifier_bara_r_hidden:IsInvulnerable()
	return true
end

function modifier_bara_r_hidden:Airborne()
	return true
end