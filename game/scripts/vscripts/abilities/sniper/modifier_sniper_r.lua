modifier_sniper_r = class({})

if IsServer() then
    function modifier_sniper_r:OnAbilityExecuted(event)
        local hero = self:GetCaster().hero
        local target = event.unit:GetParentEntity()
        local targetPos = target:GetPos()
        local shouldBeAffectedByAbility = target:FindModifier("modifier_sniper_r")

        if not event.ability.canBeSilenced then
            return
        end

        if shouldBeAffectedByAbility then
            TimedEntity(0.6, function()

                targetPos = target:GetPos()
                CreateAOEMarker(hero, targetPos, 250, 0.6, Vector(250, 50, 50))
                CreateAOEMarker(hero, targetPos, 250, 0.6, Vector(250, 50, 50))
                CreateAOEMarker(hero, targetPos, 250, 0.6, Vector(250, 50, 50))

                TimedEntity(0.5, function()
                    hero:AreaEffect({
                        ability = self,
                        filter = Filters.Area(targetPos, 250),
                        damage = 3
                    })

                    ArcProjectile(self.round, {
                        ability = self,
                        owner = hero,
                        from = targetPos + Vector(0, 0, 3000),
                        to = targetPos,
                        speed = 4500,
                        arc = 100,
                        radius = 96,
                        graphics = "particles/invoker_q/invoker_q_preview.vpcf",
                        hitSound = "Arena.Invoker.HitR",
                        hitFunction = function(projectile, hit)
                            FX("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, hero, {
                                cp0 = targetPos,
                                cp1 = Vector(300, 1, 1),
                                cp2 = targetPos,
                                cp3 = targetPos,
                                release = true
                            })
                        end
                    }):Activate()
                    Spells:GroundDamage(targetPos, 250, hero, true)
                end):Activate()
            end):Activate()
        end
    end
end

function modifier_sniper_r:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }

    return funcs
end

function modifier_sniper_r:IsDebuff()
    return true
end

function modifier_sniper_r:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = false,
    }
 
    return state
end

function modifier_sniper_r:GetEffectName()
    return "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail_circle.vpcf"
end

function modifier_sniper_r:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end