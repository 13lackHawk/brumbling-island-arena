modifier_tusk_r_sub = class({})

if IsServer() then
	function modifier_tusk_r_sub:OnCreated()
		self:GetParent():GetParentEntity():SwapAbilities("tusk_r", "tusk_r_sub")
		self:StartIntervalThink(0)
	end

	function modifier_tusk_r_sub:OnIntervalThink()
		if not self.target:FindModifier("modifier_tusk_r_target") then
			self:Destroy()
		end
	end

	function modifier_tusk_r_sub:OnDestroy()
		self:GetParent():GetParentEntity():SwapAbilities("tusk_r_sub", "tusk_r")
	end
end

function modifier_tusk_r_sub:IsHidden()
	return true
end