modifier_tusk_r = class({})

function modifier_tusk_r:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }

    return state
end

if IsServer() then
	function modifier_tusk_r:OnCreated()
		self.particle = FX("particles/tusk_r/tusk_r_run.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), {
			cp0 = { ent = self:GetParent() }
		})
	end

	function modifier_tusk_r:OnDestroy()
		DFX(self.particle, false)
	end
end

function modifier_tusk_r:IsHidden()
    return true
end

function modifier_tusk_r:Airborne()
    return true
end

function modifier_tusk_r:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }

    return funcs
end

function modifier_tusk_r:GetActivityTranslationModifiers()
    return "punch"
end