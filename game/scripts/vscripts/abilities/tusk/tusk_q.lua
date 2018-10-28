tusk_q = class({})

LinkLuaModifier("modifier_tusk_q", "abilities/tusk/modifier_tusk_q", LUA_MODIFIER_MOTION_NONE)

function tusk_q:OnSpellStart()
    Wrappers.DirectionalAbility(self)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()

    DistanceCappedProjectile(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 128),
        to = target + Vector(0, 0, 128),
        speed = 950,
        graphics = "particles/tusk_q/tusk_q_main.vpcf",
        distance = 1100,
        damagesTrees = false,
        considersGround = true,
        destroyFunction = function(projectile)
            projectile:AreaEffect({
                ability = self,
                filter = Filters.Area(projectile:GetPos(), 275),
                damage = self:GetDamage(),
                modifier = { name = "modifier_tusk_q", duration = 2.5, ability = self },
                knockback = {
                    force = 60,
                    direction = function(v) return v:GetPos() - projectile:GetPos() end
                }
            })

            ScreenShake(projectile:GetPos(), 5, 150, 0.45, 3000, 0, true)
            projectile:EmitSound("Arena.Tusk.HitQ")
            projectile:EmitSound("Arena.Tusk.PenguinScream")
        end
    }):Activate()

    hero:EmitSound("Arena.Tusk.CastQ")
end

function tusk_q:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function tusk_q:GetPlaybackRateOverride()
    return 2.0
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(tusk_q)