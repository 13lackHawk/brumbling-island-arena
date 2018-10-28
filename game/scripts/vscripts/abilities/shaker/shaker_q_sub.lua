shaker_q_sub = class({})
local self = shaker_q_sub

function self:OnSpellStart()
    local hero = self:GetCaster().hero
    self.direction = -hero:GetFacing()
    local mod = hero:FindModifier("modifier_shaker_q")
    if mod then
        mod:Destroy()
        mod = hero:FindModifier("modifier_shaker_q_recast")
        if mod then
            mod:Destroy()
        end
    end
end

function self:GetRecast()
    return self.direction
end

function self:GetCastAnimation()
    return ACT_DOTA_SPAWN
end

function self:GetPlaybackRateOverride()
    return 2
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(shaker_q_sub)