modifier_ursa_q_proc = class({})

if IsServer() then

    function modifier_ursa_q_proc:OnAbilityImmediate(event)
        self:OnAbilityStart(event)
    end

    function modifier_ursa_q_proc:OnAbilityStart(event)
        local hero = event.unit.hero
        local hero_ursa = self:GetCaster().hero
        local epic_test = hero == hero_ursa
        local TrueHero = hero:FindModifier("modifier_ursa_q_proc")

        if not event.ability.canBeSilenced then
            return
        end

        if hero and TrueHero and not epic_test then
            if not self.destroyed then
                hero:AddNewModifier(hero, self:GetAbility(), "modifier_silence_lua", { duration = 2.0 })
                hero:Damage(hero_ursa, 2)
                hero_ursa:EmitSound("Arena.Ursa.ProcQ")
                FX("particles/ursa_q/ursa_q_endcap.vpcf", PATTACH_ABSORIGIN, hero, {
                   cp0 = { ent = self:GetParent(), point = "attach_hitloc" },
                   cp3 = { ent = self:GetParent(), point = "attach_hitloc" },
                   release = true
                })
            end
            self:Destroy()
            self.destroyed = true
        end
    end
end

function modifier_ursa_q_proc:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_START,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_ursa_q_proc:GetEffectName()
    return "particles/ursa_q/ursa_q.vpcf"
end

function modifier_ursa_q_proc:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ursa_q_proc:IsDebuff()
    return true
end

function modifier_ursa_q_proc:GetModifierMoveSpeedBonus_Percentage(params)
    return -25
end