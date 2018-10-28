modifier_brew_add_beer = class({})

function modifier_brew_add_beer:GetTexture()
    return "brewmaster_drunken_haze"
end

if IsServer() then
    function modifier_brew_add_beer:OnCreated()
        self:StartIntervalThink(2.5)
    end

    function modifier_brew_add_beer:OnIntervalThink()
        local hero = self:GetParent():GetParentEntity()
        self.stacksAmount = hero:FindAbility("brew_q"):CountBeer(hero)
        if self.stacksAmount < 4 then
            hero:FindAbility("brew_q"):AddBeerModifier(hero)
        end
    end
end