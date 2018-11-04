lycan_q_sub = class({})

function lycan_q_sub:OnSpellStart()
    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition() * Vector(1, 1, 0)
    local mod = hero:FindModifier("modifier_lycan_q_recast")

    if mod then
        for _, wolf in pairs(mod.wolfs) do
            wolf:FearBark()
            wolf:EmitSound("Arena.Lycan.CastE")
        end

        mod:Destroy()
    end
end

function lycan_q_sub:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function lycan_q_sub:GetIntrinsicModifierName()
    return "modifier_lycan_instinct"
end

function lycan_q_sub:GetPlaybackRateOverride()
    return 1.66
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(lycan_q_sub)