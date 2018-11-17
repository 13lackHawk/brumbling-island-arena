modifier_brew_add_beer = class({})

function modifier_brew_add_beer:GetTexture()
    return "brewmaster_drunken_haze"
end

function modifier_brew_add_beer:DestroyOnExpire()
    return false
end

if IsServer() then
    function modifier_brew_add_beer:OnCreated()
        self:SetDuration(3.25, true)
        self.maxStacks = 4

        self:StartIntervalThink(0)
    end

    function modifier_brew_add_beer:OnIntervalThink()
        local hero = self:GetAbility():GetCaster():GetParentEntity()
        local stacks = hero:CountBeer(hero, "passive")
        local allStacks = hero:CountBeer(hero)

        if allStacks >= 8 or stacks >= self.maxStacks then
            self:SetDuration(-1, true)
            self.overloaded = true
            return
        end

        if self.overloaded then
            self:SetDuration(3.25, true)
            self.overloaded = false
        end

        if self:GetRemainingTime() <= 0 then
            hero:AddBeerModifier(hero, "passive", -1)
            if stacks < self.maxStacks - 1 and allStacks < 7 then
                self:SetDuration(3.25, true)
            else
                self:SetDuration(-1, true)
                self.overloaded = true
            end
        end
    end
end