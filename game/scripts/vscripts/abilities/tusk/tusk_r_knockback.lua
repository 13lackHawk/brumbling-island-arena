TuskRKnockback = TuskRKnockback or class({}, nil, Dash)

function TuskRKnockback:constructor(hero, ability, dir, h, force, knockup, multiplies)
	if not hero:Alive() then
		return
	end
	if hero ~= ability:GetCaster():GetParentEntity() then hero:Animate(ACT_DOTA_FLAIL) end
	self.decrease = 10/3
	if multiplies then
		local multiplier = 1
		for _,mod in pairs(hero:AllModifiers()) do if mod.GetKnockbackMultiplier then multiplier = multiplier * mod:GetKnockbackMultiplier() end end 
		self.knockup = knockup * math.sqrt(multiplier)
	end
	self.force = force / 30
	self.knockup = self.knockup or knockup
	self.h = h
	self.hero = hero
	self.direction = dir
	self.hero:AddNewModifier(ability:GetCaster():GetParentEntity(), ability, "modifier_tusk_r_target", { duration = self:GetDashTime() })
	hero:AddKnockbackSource(source)
	hero.round.spells:AddDash(self)
	return self
end

function TuskRKnockback:GetDashTime(knockup, decrease, h)
	local knockup = knockup or self.knockup
	local dicrease = decrease or -self.decrease
	local height = h or -self.h
	if dicrease == 0 then return math.huge end

	local roundUp = function(num) return num + (1 - (num % 1)) end
    local di = math.sqrt((knockup * knockup) - knockup * dicrease + 0.25 * (dicrease * dicrease) + 2 * dicrease * height)
    local result1 = roundUp((((-knockup + 0.5 * dicrease) - di) / dicrease))
    local result2 = roundUp((((-knockup + 0.5 * dicrease) + di) / dicrease))

	return math.max(result1, result2) * 0.033203125
end

function TuskRKnockback:Update()
    local pos = self.hero:GetPos()
    local new = self:PositionFunction(pos)
    new.z = self:HeightFunction()

    if new.z <= 0 and self.knockup <= 0 then
    	self:End()
    	return
    end

    self.knockup = self.knockup - self.decrease
    self.h = new.z

    self.hero:SetPos(new)
end

function TuskRKnockback:PositionFunction(current)
	return current + self.force * self.direction
end

function TuskRKnockback:HeightFunction(current)
    return self.h + self.knockup
end

function TuskRKnockback:Interrupt()
	self:End(true)
end

function TuskRKnockback:End(Interrupted)
	self.hero:RemoveModifier("modifier_tusk_r_target")
	self.destroyed = true

	if not Interrupted then
		if GameRules.GameMode.round.spells.TestCircle(self.hero:GetPos(), self.hero:GetRad()) then
			Timers:CreateTimer(0.033203125, function()
				self.hero:FindClearSpace(self.hero:GetPos(), true)
			end)
			self.hero:GetUnit():FadeGesture(ACT_DOTA_FLAIL)
		else
			self.hero:MakeFall(self.direction * self.force)
			self.hero.fallingSpeed = -self.knockup * 3
		end
	end
end