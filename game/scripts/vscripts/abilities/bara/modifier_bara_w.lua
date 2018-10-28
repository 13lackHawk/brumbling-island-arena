modifier_bara_w = class({})
local self = modifier_bara_w

if IsServer() then
    function self:OnCreated(kv)
        local effect = ParticleManager:CreateParticle("particles/bara/bara_w_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(effect, false, false, 0, true, false)
    end

    function self:OnDestroy()
        local hero = self:GetCaster().hero
        if self.speed_bonus then
            hero:AddNewModifier(hero, self:GetAbility(), "modifier_bara_w_speed", { duration = 2.0})
        end
    end
end

function self:CheckState()
    return {
        [MODIFIER_STATE_DISARMED] = true
    }
end

function self:GetEffectName()
    return "particles/bara_w/bara_w.vpcf"
end

function self:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

function self:StatusEffectPriority()
    return 10
end

function self:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function self:OnDamageReceived(source, hero, amount, isPhysical)
    if not isPhysical then
        source.hero:Damage(source.hero, amount)
        return true
    else
        return false
    end
end

function self:AllowAbilityEffect(source, ability)
    local hero = self:GetParent():GetParentEntity()

    if source.owner.team ~= hero.owner.team and not IsAttackAbility(ability) then
        self.soundLastPlayed = self.soundLastPlayed or 0

        if GameRules:GetGameTime() - self.soundLastPlayed > 0.2 then
            self.soundLastPlayed = GameRules:GetGameTime()

            hero:EmitSound("Arena.AM.HitW")
        end

        local modifier = hero:FindModifier("modifier_bara_a")

        if modifier then
            modifier:IncrementStackCount()
        else 
            modifier = hero:AddNewModifier(hero, self.hero:FindAbility("bara_a"), "modifier_bara_a", {})
            if modifier then
                modifier:SetStackCount(1)
            end
        end

        if not self.speed_bonus then
            self.speed_bonus = true
            hero:EmitSound("Arena.AM.HitW.Voice")
        end

        return true
    end

    return true
end