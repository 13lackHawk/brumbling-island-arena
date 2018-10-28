sniper_e = class({})
LinkLuaModifier("modifier_sniper_e", "abilities/sniper/modifier_sniper_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sniper_e_ready", "abilities/sniper/modifier_sniper_e_ready", LUA_MODIFIER_MOTION_NONE)

function sniper_e:OnSpellStart()
    Wrappers.DirectionalAbility(self, 700)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    local particle
	local dir = self:GetDirection()
    local target2 = hero:GetPos()

	FX("particles/econ/events/coal/coal_projectile_explosion.vpcf", PATTACH_ABSORIGIN, hero, {
	    cp0 = target2,
	    --cp1 = Vector(600, 1, 1),
	    --cp2 = target2,
	    cp3 = target2,
	    release = true
	})

	hero:AreaEffect({
	    ability = self,
	    filter = Filters.Area(target2, 250),
	    damage = 2,
	    modifier = { name = "modifier_silence_lua", duration = 1.5, ability = self },
	})

    --particle = FX("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_POINT_FOLLOW, hero, {
    --    cp0 = { ent = hero, point = "Index_plc1_R" }
    --})

    local BestJump = target
    local distance = (target - hero:GetPos()):Length2D()

    if distance >= 200 then
        BestJump = target + dir * -100
    end

    FunctionDash(hero, BestJump, 0.45, {
        forceFacing = true,
        noFixedDuration = true,
        --heightFunction = DashParabola(200),
        heightFunction = function(dash, current)
            local d = (dash.from - dash.to):Length2D()
            local x = (dash.from - current):Length2D()
            local y0 = 0
            local y1 = 0

            return ParabolaZ2(y0, y1, 200, d, x)
        end,
        arrivalFunction = function()
        	--DFX(particle, false)
			FX("particles/units/heroes/hero_earthshaker/es_dust_hit.vpcf", PATTACH_ABSORIGIN, hero, { release = true })
        end,
        modifier = { name = "modifier_sniper_e", ability = self },
    })

    hero:EmitSound("Arena.Sniper.CastE")
end

function sniper_e:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_2
end

function sniper_e:GetIntrinsicModifierName()
    return "modifier_sniper_e_ready"
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(sniper_e)