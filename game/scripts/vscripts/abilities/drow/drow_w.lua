drow_w = class({})

LinkLuaModifier("modifier_drow_w", "abilities/drow/modifier_drow_w", LUA_MODIFIER_MOTION_NONE)

function drow_w:OnSpellStart()
    Wrappers.DirectionalAbility(self, 1000)

    local hero = self:GetCaster():GetParentEntity()
    local target = self:GetCursorPosition()
    local particle = FX("particles/aoe_marker_filled.vpcf", PATTACH_ABSORIGIN, hero, {
        cp0 = target,
        cp1 = Vector(250, 0, 0),
        cp2 = Vector(194, 208, 210)
    })

    TimedEntity(0.55, function()
        DFX(particle)

        local hitAndNotBlocked = false

        hero:AreaEffect({
            ability = self,
            filter = Filters.Area(target, 250),
            action = function(target)
                hitAndNotBlocked = true
                target:AddNewModifier(hero, self, "modifier_drow_w", { duration = 1.5 }):Update()
            end,
            onlyHeroes = true
        })

        if hitAndNotBlocked then
            hero:FindAbility("drow_e"):EndCooldown()
        end

        FX("particles/units/heroes/hero_drow/drow_silence.vpcf", PATTACH_WORLDORIGIN, hero, {
            cp0 = target,
            cp1 = Vector(250, 1, 1),
            release = true
        })

        hero:EmitSound("Arena.Drow.CastW")
    end):Activate()

    hero:EmitSound("Arena.Drow.CastW.Voice")
end

function drow_w:GetPlaybackRateOverride()
    return 2
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(drow_w)