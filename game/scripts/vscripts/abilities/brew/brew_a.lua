brew_a = class({})

LinkLuaModifier("modifier_brew_add_beer", "abilities/brew/modifier_brew_add_beer", LUA_MODIFIER_MOTION_NONE)

function brew_a:OnAbilityPhaseStart()
    local hero = self:GetCaster():GetParentEntity()
    local stacks = hero:CountBeer(hero)

    hero:EmitSound(stacks >= 3 and "Arena.Brew.CastA2" or "Arena.Brew.CastA")

    return true
end

function brew_a:OnSpellStart()
    Wrappers.DirectionalAbility(self, 300)

    local hero = self:GetCaster().hero
    local pos = hero:GetPos()
    local forward = self:GetDirection()
    local range = 300
    local damage = self:GetDamage()
    local force = 20
    local stacks = hero:CountBeer(hero)

    if stacks >= 3 then
        damage = damage * 2
        force = force * 1.5
    end

    hero:AreaEffect({
        ability = self,
        filter = Filters.Cone(pos, range, forward, math.pi),
        sound = "Arena.Brew.HitA",
        damage = damage,
        knockback = { force = force, decrease = 3 },
        isPhysical = true
    })
end

function brew_a:GetCastAnimation()
    local hero = self:GetCaster():GetParentEntity()
    local stacks = hero:CountBeer(hero)

    if stacks >= 3 then
        return ACT_DOTA_ATTACK_EVENT
    end

    return ACT_DOTA_ATTACK
end

function brew_a:GetPlaybackRateOverride()
    return 3
end

function brew_a:GetIntrinsicModifierName()
    return "modifier_brew_add_beer"
end

if IsClient() then
    require("wrappers")
end

Wrappers.AttackAbility(brew_a, nil, "particles/melee_attack_blur.vpcf")