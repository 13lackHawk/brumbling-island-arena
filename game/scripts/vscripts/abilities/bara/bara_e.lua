bara_e = class({})

LinkLuaModifier("modifier_bara_r", "abilities/bara/modifier_bara_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_e", "abilities/bara/modifier_bara_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_e_slow", "abilities/bara/modifier_bara_e_slow", LUA_MODIFIER_MOTION_NONE)


require('abilities/bara/bara_spirit')

function bara_e:OnSpellStart()
    Wrappers.DirectionalAbility(self, 2000, 600)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition() * Vector(1, 1, 0)
    local direction = (target - hero:GetPos()):Normalized()
        direction = hero:GetFacing()

    local UltimateMod = hero:HasModifier("modifier_bara_r")

    if not UltimateMod then
        hero:AddNewModifier(hero, self, "modifier_bara_r", {})
    end

    BaraSpirit(hero.round, hero, target, direction, self):Activate()

    hero:EmitSound("Arena.Lycan.CastQ")
    hero:EmitSound("Arena.Lycan.CastQ.Voice")
end

function bara_e:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function bara_e:GetPlaybackRateOverride()
    return 1.66
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(bara_e)