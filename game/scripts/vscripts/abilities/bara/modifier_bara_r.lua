modifier_bara_r = class ({})
local self = modifier_bara_r

self.tableHP = {}
self.tablePOS = {}

function self:IsHidden()
	return true
end

if IsServer() then
	function self:OnCreated()
		self:StartIntervalThink(0.1)
		self:OnIntervalThink()
	end

	function self:OnIntervalThink()
		local hero = self:GetCaster():GetParentEntity()

		local HP = hero:GetHealth()
		local POS = hero:GetPos()
		local tableLength = #self.tableHP

		if tableLength > 30 then
			table.remove(self.tableHP, 1)
			table.remove(self.tablePOS, 1)
		end

		table.insert(self.tableHP, HP)
		table.insert(self.tablePOS, POS)
	end
end

function self:GetPos()
	return self:GetUnit():GetAbsOrigin()
end

function self:TimeLapsePOS()
	return self.tablePOS[1]
end

function self:TimeLapseHP()
	return self.tableHP[1]
end

