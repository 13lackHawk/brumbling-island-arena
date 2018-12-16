modifier_tusk_r_sub = class({})

if IsServer() then
	function modifier_tusk_r_sub:OnCreated()
		self:GetParent():GetParentEntity():SwapAbilities("tusk_r", "tusk_r_sub")
		self:StartIntervalThink(0)
	end

	function modifier_tusk_r_sub:OnIntervalThink()
		for _,dash in pairs(GameRules.GameMode.round.spells.dashes) do	
			if dash == self.knockup then
				return
			end
		end
		self:Destroy()
	end

	function modifier_tusk_r_sub:OnDestroy()
		self:GetParent():GetParentEntity():SwapAbilities("tusk_r_sub", "tusk_r")
	end
end

function modifier_tusk_r_sub:IsHidden()
	return true
end