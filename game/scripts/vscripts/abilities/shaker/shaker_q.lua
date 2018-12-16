shaker_q = class({})

LinkLuaModifier("modifier_shaker_e", "abilities/shaker/modifier_shaker_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shaker_q", "abilities/shaker/modifier_shaker_q", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shaker_q_recast", "abilities/shaker/modifier_shaker_q_recast", LUA_MODIFIER_MOTION_NONE)

function shaker_q:OnAbilityPhaseStart()
    self:GetCaster().hero:EmitSound("Arena.Shaker.PreQ")
    return true
end

function shaker_q:OnSpellStart()
    Wrappers.DirectionalAbility(self, 5000)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    local area = 200
    local direction = (target - hero:GetPos()):Normalized()
    local effects = true

    hero:EmitSound("Arena.SK.CastQ")
    hero:AddNewModifier(hero, hero:FindAbility("shaker_a"), "modifier_shaker_a", { duration = 5 })
    hero:AddNewModifier(hero, self, "modifier_shaker_q", { duration = 0.9 })
    hero:AddNewModifier(hero, self, "modifier_shaker_q_recast", { duration = 0.7 })
    hero:SwapAbilities("shaker_q", "shaker_q_sub")

    CreateAOEMarker(hero, target, area, 1.1, Vector(234, 72, 0))
    CreateAOEMarker(hero, target, area, 1.1, Vector(234, 72, 0))
    CreateAOEMarker(hero, target, area, 1.1, Vector(234, 72, 0))

    TimedEntity(0.8, function()
        local mod = hero:FindModifier("modifier_shaker_q")
        direction = (hero:GetPos() - target):Normalized()
        if not mod then
            direction = -(hero:FindAbility("shaker_q_sub"):GetRecast())
        end
        hero:StopSound("Arena.SK.CastQ")
        hero:EmitSound("Arena.SK.EndQ", target)
        hero:AreaEffect({
            ability = self,
            filter = Filters.Area(target, area),
            damage = self:GetDamage(),
            filterProjectiles = true,
            action = function(victim)
                effects = false

                local index = ImmediateEffectPoint("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos())
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
                index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos() + Vector(-30,30,0))
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
                index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos() + Vector(30,30,0))
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
                index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos() + Vector(0,-30,0))
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))

                KnockupTo(victim, hero, victim:GetPos() + direction * 500, 0.65, {
                    gesture = ACT_DOTA_FLAIL,
                    invulnerable = true,
                    decrease = 10/2
                })
            end
        })

        if effects == true then
            local index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, target + Vector(100,0,0))
            ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
            index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, target + Vector(0,100,0))
            ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
            index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, target + Vector(-100,0,0))
            ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
            index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, target + Vector(0,-100,0))
            ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
            index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, target + Vector(0,0,0))
            ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
        end

        ScreenShake(target, 5, 150, 0.25, 2000, 0, true)
        --Spells:GroundDamage(target, area, hero)
        
    end):Activate()
    --ScreenShake(start, 5, 150, 0.45, 3000, 0, true)
    hero:EmitSound("Arena.Shaker.CastQ")
end

function shaker_q:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function shaker_q:GetPlaybackRateOverride()
    return 2.75
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(shaker_q)