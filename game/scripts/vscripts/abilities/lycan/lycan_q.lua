lycan_q = class({})
local pes1 = nil
local pes2 = nil

LinkLuaModifier("modifier_lycan_q", "abilities/lycan/modifier_lycan_q", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_instinct", "abilities/lycan/modifier_lycan_instinct", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_bleed", "abilities/lycan/modifier_lycan_bleed", LUA_MODIFIER_MOTION_NONE)

require('abilities/lycan/lycan_wolf')

function lycan_q:GetPes1()
    return pes1
end

function lycan_q:GetPes2()
    return pes2
end

function lycan_q:OnSpellStart()
    Wrappers.DirectionalAbility(self, 1600, 500)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition() * Vector(1, 1, 0)

    pes1 = LycanWolf(hero.round, hero, target, 1, self):Activate()
    pes2 = LycanWolf(hero.round, hero, target, -1, self):Activate()

    hero:EmitSound("Arena.Lycan.CastQ")
    hero:EmitSound("Arena.Lycan.CastQ.Voice")
end

function lycan_q:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function lycan_q:GetIntrinsicModifierName()
    return "modifier_lycan_instinct"
end

function lycan_q:GetPlaybackRateOverride()
    return 1.66
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(lycan_q)