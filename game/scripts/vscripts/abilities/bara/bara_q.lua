bara_q = class({})

LinkLuaModifier("modifier_bara_r", "abilities/bara/modifier_bara_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_a", "abilities/bara/modifier_bara_a", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_q", "abilities/bara/modifier_bara_q", LUA_MODIFIER_MOTION_NONE)

function bara_q:OnSpellStart()
    Wrappers.DirectionalAbility(self, 1200)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    local UltimateMod = hero:HasModifier("modifier_bara_r")

    if not UltimateMod then
        hero:AddNewModifier(hero, self, "modifier_bara_r", {})
    end

    DistanceCappedProjectile(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 128),
        to = target + Vector(0, 0, 128),
        speed = 1500,
        graphics = "particles/bara_q/bara_q.vpcf",
        distance = 1200,
        hitSound = "Arena.Invoker.HitW",
        --hitModifier = { name = "modifier_bara_q", duration = 1.8, ability = self },
        hitFunction = function(projectile, victim)
            victim:AddNewModifier(hero, self, "modifier_bara_q", { duration = 0.8})
            if instanceof(victim, Hero) then
                local modifier = hero:FindModifier("modifier_bara_a")

                if modifier then
                    modifier:IncrementStackCount()
                else 
                    modifier = hero:AddNewModifier(hero, self.hero:FindAbility("bara_a"), "modifier_bara_a", {})
                    if modifier then
                        modifier:SetStackCount(1)
                    end
                end
            end
        end
    }):Activate()

    hero:EmitSound("Arena.Invoker.CastW")
end

function bara_q:GetCastAnimation()
    return ACT_DOTA_ATTACK
end

function bara_q:GetPlaybackRateOverride()
    return 2.5
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(bara_q)