modifier_axe_w_bonus = class({})

if IsServer() then
	function modifier_axe_w_bonus:OnCreated()
		self.p = FX("particles/axe_w/axe_w.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), {
			cp0 = { ent = self:GetParent() }
		})
	end

	function modifier_axe_w_bonus:OnDestroy()
		DFX(self.p)
	end
end

function modifier_axe_w_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_axe_w_bonus:GetModifierMoveSpeedBonus_Percentage(params)
    return 25
end

function modifier_axe_w_bonus:IsInvulnerable()
    return true
end