bara_a = class({})

LinkLuaModifier("modifier_bara_a", "abilities/bara/modifier_bara_a", LUA_MODIFIER_MOTION_NONE)

function bara_a:OnAbilityPhaseStart()
    local hero = self:GetCaster():GetParentEntity()

    hero:EmitSound("Arena.Bara.CastA")

    return true
end

function bara_a:OnSpellStart()
    Wrappers.DirectionalAbility(self, 300)

    local hero = self:GetCaster().hero
    local pos = hero:GetPos()
    local forward = self:GetDirection()
    local range = 300
    local damage = self:GetDamage()
    local force = 20

    local knockup = 0
    local sound = "Arena.Bara.HitA"
    local stacks = self:GetCaster():GetModifierStackCount("modifier_bara_a", self:GetCaster())
    local bi4ok_v_udare = false

    if stacks >= 3 then
        force = 30
        damage = 2
        bi4ok_v_udare = true
        knockup = 55
        sound = "Arena.Bara.HitA2"
    end

    hero:AreaEffect({
        ability = self,
        filter = Filters.Cone(pos, range, forward, math.pi),
        sound = sound,
        damage = damage,
        knockback = { force = force, decrease = 3 },
        isPhysical = true,
        action = function(target)
            local effectPos = target:GetPos() + Vector(0, 0, 64)
            local direction = (pos - effectPos):Normalized()
            local blood = ImmediateEffect("particles/units/heroes/hero_riki/riki_backstab_hit_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt(blood, 0, target.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", effectPos, true)
            ParticleManager:SetParticleControl(blood, 2, direction)

            local modifier = hero:FindModifier("modifier_bara_a")

            if bi4ok_v_udare then
                local effect = ImmediateEffect("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                ParticleManager:SetParticleControl(effect, 1, effectPos + direction * 300)

                modifier:SetStackCount(modifier:GetStackCount() - 3)
                if modifier:GetStackCount() < 0 then
                    modifier:SetStackCount(0)
                end

                target:AddNewModifier(hero,self, "modifier_stunned_lua", { duration = 0.5 })
            end
        end,
        knockback = { force = force, knockup = knockup, decrease = 3}
    })
end

function bara_a:GetCastAnimation()
    return ACT_DOTA_ATTACK
end

function bara_a:GetPlaybackRateOverride()
    return 3
end

if IsClient() then
    require("wrappers")
end

Wrappers.AttackAbility(bara_a)