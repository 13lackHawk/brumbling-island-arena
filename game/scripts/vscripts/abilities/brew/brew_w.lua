brew_w = class({})

function brew_w:OnSpellStart()
    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    local maxStacksConsumed = 3
    local heroStacks = min(maxStacksConsumed, hero:FindAbility("brew_q"):CountBeer(hero))

    local projectile = DistanceCappedProjectile(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 128),
        to = target + Vector(0, 0, 128),
        speed = 1650,
        graphics = "particles/brew_w/brew_w.vpcf",
        distance = 500 + 250 * heroStacks,
        radius = 32 + 32 * heroStacks,
        hitSound = "Arena.Ember.HitQ",
        continueOnHit = true,
        damagesTrees = true,
        goesThroughTrees = true,
        hitFunction = function(projectile, target)
            local stacks = hero:FindAbility("brew_q"):CountBeer(target)
            if heroStacks > 2 then
                heroStacks = 2
            end
            target:Damage(hero, heroStacks + 1)

            --if stacks > 0 then
                target:AddNewModifier(hero, self, "modifier_stunned_lua", { duration = 0.75 })
            --end

            hero:FindAbility("brew_q"):ClearBeer(target)
        end
    }):Activate()

    hero:EmitSound("Arena.Brew.CastW")
    hero:FindAbility("brew_q"):ClearBeer(hero, maxStacksConsumed)

    ParticleManager:SetParticleControl(projectile.particle, 4, Vector(heroStacks + 2, 1, 0))
end

function brew_w:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

function brew_w:GetPlaybackRateOverride()
    return 2
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(brew_w)