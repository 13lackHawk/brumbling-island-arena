ProjectileBaraR = ProjectileBaraR or class({}, nil, DistanceCappedProjectile)
local self = ProjectileBaraR

function self:constructor(round, hero, target, ability)
    local mod = hero:FindModifier("modifier_bara_r")
    local hp = mod:TimeLapseHP()

    getbase(ProjectileBaraR).constructor(self, round, {
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 64),
        to = target + Vector(0, 0, 64),
        speed = 1500,
        graphics = "particles/bara/bara_r_projectile.vpcf",
        distance = (target - hero:GetPos()):Length2D(),
        continueOnHit = true,
        disablePrediction = true,
        destroyFunction = function(projectile)
            projectile:AreaEffect({
                ability = self,
                filter = Filters.Area(projectile:GetPos(), 300),
                damage = 4
            })

            hero:SetHidden(false)
            hero:RecreateAllVisuals()
            hero:GetUnit():StartGestureWithPlaybackRate(ACT_DOTA_TELEPORT_END, 1.5)
            hero:RemoveModifier("modifier_bara_r_hidden")
            hero:FindClearSpace(projectile:GetPos(), true)

            FX("particles/bara/bara_r_boom.vpcf", PATTACH_CUSTOMORIGIN, hero, {
                cp0 = hero:GetPos(),
                cp1 = Vector(300, 0, 0),
                release = true
            })

            hero:SetHealth(hp)
        end
    })

    self.collisionType = COLLISION_TYPE_NONE

end