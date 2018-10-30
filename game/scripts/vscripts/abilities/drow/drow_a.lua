drow_a = class({})

function drow_a:OnSpellStart()
    Wrappers.DirectionalAbility(self, 1200, 1200)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    local force = 15
    local damage = self:GetDamage()
    local direction = self:GetDirection()

    DistanceCappedProjectile(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 64),
        to = target + Vector(0, 0, 64),
        damage = damage,
        speed = 2000,
        radius = 48,
        graphics = "particles/drow_q/drow_q.vpcf",
        distance = 1200,
        hitSound = "Arena.Drow.HitA",
        isPhysical = true,
        hitFunction = function(projectile, victim)
            local distance = (victim:GetPos() - hero:GetPos()):Length2D()
            local pos = projectile:GetPos()
            if distance >= 1000 then
                force = 40
                if instanceof(victim, Hero) then
                    damage = damage * 2
                    effect = ImmediateEffectPoint("particles/drow_r/drow_r_bash.vpcf", PATTACH_ABSORIGIN, victim, pos)
                    ParticleManager:SetParticleControlForward(effect, 1, -direction)
                end
            else
                force = 15 + distance/40
            end
            SoftKnockback(victim, hero, projectile.vel, force, {})
            victim:Damage(projectile, damage, true)
        end,
    }):Activate()

    hero:EmitSound("Arena.Drow.CastQ2")
end

function drow_a:GetCastAnimation()
    return ACT_DOTA_ATTACK
end

function drow_a:GetPlaybackRateOverride()
    return 4
end

if IsClient() then
    require("wrappers")
end

Wrappers.AttackAbility(drow_a)