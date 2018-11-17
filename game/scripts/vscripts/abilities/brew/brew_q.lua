brew_q = class({})

LinkLuaModifier("modifier_brew_beer", "abilities/brew/modifier_brew_beer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brew_q", "abilities/brew/modifier_brew_q", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tinker_q", "abilities/tinker/modifier_tinker_q", LUA_MODIFIER_MOTION_NONE)

function brew_q:OnSpellStart()
    local hero = self:GetCaster().hero
    local pos = hero:GetPos()

    hero:AreaEffect({
        ability = self,
        filter = Filters.Area(pos, 350),
        damage = self:GetDamage(),
        filterProjectiles = true,
        modifier = { name = "modifier_brew_q", duration = 1.0, ability = hero:FindAbility("brew_a") }
    })

    local effect = ImmediateEffect("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN, hero)
    ParticleManager:SetParticleControl(effect, 0, pos)
    ParticleManager:SetParticleControl(effect, 1, Vector(250, 0, 0))

    hero:EmitSound("Arena.Brew.CastQ")

    self.tick = (self.tick or 0) + 1

    if self.tick % 2 == 0 then
        hero:EmitSound("Arena.Brew.CastQ.Voice")
    end
end

function brew_q:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function brew_q:GetPlaybackRateOverride()
    return 1.5
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(brew_q)