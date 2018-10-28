venge_a = class({})

LinkLuaModifier("modifier_venge_a", "abilities/venge/modifier_venge_a", LUA_MODIFIER_MOTION_NONE)

function venge_a:OnSpellStart()
    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()

    DistanceCappedProjectile(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 64),
        to = target + Vector(0, 0, 64),
        damage = self:GetDamage(),
        speed = 1450,
        radius = 48,
        graphics = "particles/venge_a/venge_a.vpcf",
        distance = 1000,
        hitSound = "Arena.Venge.HitA",
        isPhysical = true,
        damagesTrees = true,
        hitFunction = function(projectile, target)
            if instanceof(target, Projectile) or instanceof(target, DistanceCappedProjectile) then
                hero:AddNewModifier(hero, self, "modifier_venge_a", { duration = 1.0 })
                projectile:Destroy()
            else
                target:Damage(projectile, self:GetDamage(), true)
            end
        end
    }):Activate()

    hero:EmitSound("Arena.Venge.CastA")
end

function venge_a:GetCastAnimation()
    return ACT_DOTA_ATTACK
end

function venge_a:GetPlaybackRateOverride()
    return 2.5
end

if IsClient() then
    require("wrappers")
end

Wrappers.AttackAbility(venge_a)