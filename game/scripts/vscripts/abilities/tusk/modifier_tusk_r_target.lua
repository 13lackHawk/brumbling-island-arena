modifier_tusk_r_target = class({})

if IsServer() then
	function modifier_tusk_r_target:OnCreated(opt)
		if self:GetParent() ~= self:GetAbility():GetCaster() then
			FX("particles/units/heroes/hero_tusk/tusk_walruskick_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), { release = true })
		end
	end

    function modifier_tusk_r_target:OnDestroy()

    end
end

function modifier_tusk_r_target:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

function modifier_tusk_r_target:Airborne()
    return true
end

function modifier_tusk_r_target:IsInvulnerable()
    return true
end