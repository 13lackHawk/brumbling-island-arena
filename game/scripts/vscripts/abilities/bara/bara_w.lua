bara_w = class({})
local self = bara_w

LinkLuaModifier("modifier_bara_r", "abilities/bara/modifier_bara_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_w", "abilities/bara/modifier_bara_w", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_w_speed", "abilities/bara/modifier_bara_w_speed", LUA_MODIFIER_MOTION_NONE)

function self:OnSpellStart()
    local hero = self:GetCaster().hero
    local UltimateMod = hero:HasModifier("modifier_bara_r")

    if not UltimateMod then
        hero:AddNewModifier(hero, self, "modifier_bara_r", {})
    end

    hero:AddNewModifier(hero, self, "modifier_bara_w", { duration = 1.0 })
    hero:EmitSound("Arena.AM.CastW")
end

function self:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(bara_w)