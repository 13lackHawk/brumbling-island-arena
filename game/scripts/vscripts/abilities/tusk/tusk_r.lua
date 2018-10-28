tusk_r = class({})

LinkLuaModifier("modifier_tusk_r", "abilities/tusk/modifier_tusk_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tusk_r_sub", "abilities/tusk/modifier_tusk_r_sub", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tusk_r_target", "abilities/tusk/modifier_tusk_r_target", LUA_MODIFIER_MOTION_NONE)

require("abilities/tusk/tusk_r_knockback")

function tusk_r:OnAbilityPhaseStart()
    AddAnimationTranslate(self:GetCaster():GetParentEntity():GetUnit(), "punch", 0)
    return true
end

function tusk_r:OnChannelFinish(interrupted)
    if interrupted then 
    	return
    end

    Wrappers.DirectionalAbility(self, 750, 750)

    local hero = self:GetCaster():GetParentEntity()
    local target = self:GetCursorPosition()
    local direction = self:GetDirection()
    local function knockDirection(victim, dash)
        local pos = hero:GetPos()
        local tp = victim:GetPos()
        local between = ClosestPointToSegment(dash.from, pos, tp)
        return (tp - between):Normalized()
    end

    local dash = Dash(hero, target, 1500, {
        modifier = { name = "modifier_tusk_r", ability = self },
        forceFacing = true,
        gesture = ACT_DOTA_RUN,
        gestureRate = 3
    })

    Timers:CreateTimer(0.04, function()
        hero:SetFacing((dash.to - dash.from):Normalized())
    end)

    dash.hitParams = {
        ability = self,
        action = function(target)
            ScreenShake(target:GetPos(), 5, 150, 0.45, 3000, 0, true)
            target:Damage(hero, self:GetDamage())

            if instanceof(target, Hero) then
                target:EmitSound("Arena.Tusk.HitR.Hero")
            else
                target:EmitSound("Arena.Tusk.HitR.Target")
            end

            if instanceof(target,Hero) and target:Alive() then
                hero:Animate(ACT_DOTA_CAST_ABILITY_4, 2)

                FX("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, { release = true })

                hero.round.spells:InterruptDashes(target)
                local dashTime = TuskRKnockback(target, self, direction, 0, 325, 55, true):GetDashTime()

                Timers:CreateTimer(0.2, function()
                    hero:AddNewModifier(hero, self, "modifier_tusk_r_sub", { duration = dashTime - 0.4 }).target = target
                end)

                dash:Interrupt()
        	else
                SoftKnockback(target, self, knockDirection(target,dash), 60, {
                    decrease = 3
                })
            end
        end
    }
end

function tusk_r:GetChannelTime()
    return 0.8
end

function tusk_r:GetCastAnimation()
    return ACT_DOTA_IDLE_RARE
end

function tusk_r:GetPlaybackRateOverride()
    return 0.55
end

if IsServer() then
    Wrappers.GuidedAbility(tusk_r, true)
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(tusk_r)