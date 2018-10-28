modifier_brew_q = class({})

if IsServer() then

    function modifier_brew_q:OnAbilityImmediate(event)
        self:OnAbilityStart(event)
    end

    function modifier_brew_q:OnAbilityStart(event)
        local hero = event.unit.hero
        local hero_void = self:GetCaster().hero
        local epic_test = hero == hero_void
        local TrueHero = hero:FindModifier("modifier_brew_q")

        --[[if not event.ability.canBeSilenced then
            return
        end]]--

        if hero and TrueHero and not epic_test and IsAttackAbility(event.ability) then
            if not self.destroyed then
                hero:AddNewModifier(hero, self:GetAbility(), "modifier_tinker_q", { duration = 2.0 })
                hero:EmitSound("Arena.Void.ProcW")
            end
            self:Destroy()
            self.destroyed = true
        end
    end
end

function modifier_brew_q:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_START
    }

    return funcs
end

function modifier_brew_q:GetEffectName()
    return "particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf"
end

function modifier_brew_q:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end