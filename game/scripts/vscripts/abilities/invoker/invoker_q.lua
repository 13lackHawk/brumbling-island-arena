invoker_q = class({})

LinkLuaModifier("modifier_invoker_q", "abilities/invoker/modifier_invoker_q", LUA_MODIFIER_MOTION_NONE)

function invoker_q:OnSpellStart()
    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    local realTarget = target

    local blank = not Spells.TestCircle(target, 16)
    if blank then
        realTarget = target - Vector(0, 0, MAP_HEIGHT / 2)
    end

    local particle = ParticleManager:CreateParticle("particles/invoker_q/invoker_q_preview.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(particle, 0, realTarget)
    ParticleManager:ReleaseParticleIndex(particle)

    TimedEntity(0.7, function()
        blank = not Spells.TestCircle(target, 16)

        hero:StopSound("Arena.Invoker.CastQ")
        hero:EmitSound("Arena.Invoker.HitQ", realTarget)

        if blank then
            realTarget = target - Vector(0, 0, MAP_HEIGHT / 2)
        else
            hero:AreaEffect({
                ability = self,
                damagesTrees = true,
                filter = Filters.Area(target, 200),
                filterProjectiles = true,
                action = function(target)
                    target:Damage(hero, 3)

                    if instanceof(target, Hero) then
                        hero:AddNewModifier(hero, self, "modifier_invoker_q", { duration = 1.5 })
                    end
                end
            })

            ScreenShake(target, 5, 150, 0.25, 2000, 0, true)
            Spells:GroundDamage(target, 200, hero)
        end

        local index =  ParticleManager:CreateParticle("particles/invoker_q/invoker_q.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(index, 0, realTarget)
        ParticleManager:ReleaseParticleIndex(index)
    end):Activate()

    hero:EmitSound("Arena.Invoker.CastQ", realTarget)
end

function invoker_q:GetCastAnimation()
    return ACT_DOTA_CAST_ALACRITY
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(invoker_q)