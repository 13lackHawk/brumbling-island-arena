sniper_a = class({})

function sniper_a:OnAbilityPhaseStart()
    local hero = self:GetCaster().hero
    hero:EmitSound("Arena.Sniper.PreA")

    return true
end

function sniper_a:OnSpellStart()
    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()

    ProjectileSniperA(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 64),
        to = target + Vector(0, 0, 64),
        speed = 2300,
        graphics = "particles/sniper_q/sniper_q.vpcf",
        radius = 48,
        hitSound = "Arena.Sniper.HitA",
        nonBlockedHitAction = function()
            hero:StopSound("Arena.Sniper.FlyA")
        end,
        knockback = { force = 20, decrease = 3 },
        damage = self:GetDamage(),
        isPhysical = true,
        hitFunction = function(projectile, victim)
<<<<<<< HEAD
            victim:Damage(projectile, projectile.damage, true)
            projectile.hitGroup[victim] = true
        end
=======
        	victim:Damage(projectile, projectile.damage, true)
            projectile.hitGroup[victim] = true
    	end
>>>>>>> 4658a595d96ca1e27655d64e132e3c02642443d4
    }):Activate()

    hero:EmitSound("Arena.Sniper.CastA")
    hero:EmitSound("Arena.Sniper.FlyA")

    ScreenShake(hero:GetPos(), 4, 50, 0.35, 2000, 0, true)
end

function sniper_a:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

function sniper_a:GetPlaybackRateOverride()
    return 3.5
end

if IsClient() then
    require("wrappers")
end

Wrappers.AttackAbility(sniper_a, 0.5)

ProjectileSniperA = ProjectileSniperA or class({}, nil, Projectile)

function ProjectileSniperA:constructor(round, params)
    getbase(ProjectileSniperA).constructor(self, round, params)
end

function ProjectileSniperA:Damage(source)
    local mode = GameRules:GetGameModeEntity()
    local dust = ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_ABSORIGIN, mode)
    ParticleManager:SetParticleControl(dust, 0, self:GetPos())
    ParticleManager:SetParticleControl(dust, 1, self:GetPos())
    ParticleManager:ReleaseParticleIndex(dust)

    if self.damaged then
        self:Destroy()
    else
        self.damage = self.damage - 1
        self.damaged = true
        --self:SetGraphics("")
    end
<<<<<<< HEAD
end
=======
end
>>>>>>> 4658a595d96ca1e27655d64e132e3c02642443d4
