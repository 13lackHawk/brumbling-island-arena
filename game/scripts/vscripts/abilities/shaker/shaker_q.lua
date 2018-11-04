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
        direction = (target - hero:GetPos()):Normalized()
        local newDirection
        if mod then
            --local direction = (target - hero:GetPos()):Normalized()
        else
            newDirection = (hero:FindAbility("shaker_q_sub"):GetRecast())
        end
        hero:StopSound("Arena.SK.CastQ")
        hero:EmitSound("Arena.SK.EndQ", target)
        hero:AreaEffect({
            ability = self,
            filter = Filters.Area(target, area),
            filterProjectiles = true,
            damage = self:GetDamage(),
            action = function(victim)
                effects = false
                victim:SetFacing(direction)
                local targetFly
                if mod then
                    targetFly = victim:GetPos() + direction * -500
                else
                    targetFly = victim:GetPos() + newDirection * -500
                end

                local isStunned = victim:FindModifier("modifier_stunned_lua")
                if isStunned then
                    isStunned:Destroy()
                end

                local index = ImmediateEffectPoint("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos())
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
                index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos() + Vector(-30,30,0))
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
                index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos() + Vector(30,30,0))
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))
                index = ImmediateEffectPoint("particles/shaker_q/shaker_q.vpcf", PATTACH_ABSORIGIN, hero, victim:GetPos() + Vector(0,-30,0))
                ParticleManager:SetParticleControl(index, 1, Vector(area, area, area))

                FunctionDash(victim, targetFly, 0.45, {
                forceFacing = true,
                heightFunction = function(dash, current)
                    local d = (dash.from - dash.to):Length2D()
                    local x = (dash.from - current):Length2D()
                    return ParabolaZ(200, d, x)
                end,
                arrivalFunction = function(dash)
                    --[[hero:AreaEffect({
                        ability = self,
                        filter = Filters.Area(target, 256),
                        modifier = { name = "modifier_stunned_lua", duration = 0.4, ability = self },
                    })

                    hero:EmitSound("Arena.Shaker.HitE")]]--]]--

                    local effect = ImmediateEffect("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_aftershock_egset.vpcf", PATTACH_ABSORIGIN, hero)
                    ParticleManager:SetParticleControl(effect, 0, target)
                    ParticleManager:SetParticleControl(effect, 1, Vector(256, 1, 1))

                    --ScreenShake(hero:GetPos(), 2, 100, 0.15, 1500, 0, true)
                end,
                modifier = { name = "modifier_shaker_e", ability = self },
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