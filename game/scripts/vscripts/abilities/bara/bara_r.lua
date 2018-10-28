bara_r = class({})

LinkLuaModifier("modifier_bara_r", "abilities/bara/modifier_bara_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_r_hidden", "abilities/bara/modifier_bara_r_hidden", LUA_MODIFIER_MOTION_NONE)

require("abilities/bara/projectile_bara_r")

function bara_r:OnSpellStart()
    local hero = self:GetCaster().hero
    local mod = hero:FindModifier("modifier_bara_r")
    local pos = mod:TimeLapsePOS()
    local hp = mod:TimeLapseHP()

    hero:GetUnit():Purge(false, true, false, false, false)

    local effect = ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero:GetUnit())
    ParticleManager:ReleaseParticleIndex(effect)

    hero:SetHidden(true)
    hero:DestroyAllVisuals()
    hero:AddNewModifier(hero, self, "modifier_bara_r_hidden", {})

    ProjectileBaraR(hero.round, hero, pos, self):Activate()

    hero:EmitSound("Arena.Brew.CastE")
    hero:EmitSound("Arena.Brew.CastE2")
end

function bara_r:GetCastAnimation()
    return ACT_DOTA_SPAWN
end

function bara_r:GetPlaybackRateOverride()
    return 2
end