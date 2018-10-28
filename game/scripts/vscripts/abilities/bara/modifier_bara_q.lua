modifier_bara_q = class({})

if IsServer() then

    function modifier_bara_q:OnAbilityImmediate(event)
        self:OnAbilityStart(event)
    end

    function modifier_bara_q:OnAbilityStart(event)
        local hero = event.unit.hero
        local hero_bara = self:GetCaster().hero
        local epic_test = hero == hero_bara
        local TrueHero = hero:FindModifier("modifier_bara_q")

        if not event.ability.canBeSilenced then
            return
        end

        if hero and TrueHero and not epic_test then
            if not self.destroyed then
                hero:AddNewModifier(hero, self:GetAbility(), "modifier_silence_lua", { duration = 2.0})
                hero:Damage(hero_bara, 2)
                hero:EmitSound("Arena.Invoker.HitW")

                local modifier = hero_bara:FindModifier("modifier_bara_a")

                if modifier then
                    modifier:IncrementStackCount()
                else 
                    hero_bara:AddNewModifier(hero_bara, self.hero:FindAbility("bara_a"), "modifier_bara_a", {})
                    if modifier then
                        modifier:SetStackCount(1)
                    end
                end
            end
            self:Destroy()
            self.destroyed = true
        end
    end
end

function modifier_bara_q:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_START
    }

    return funcs
end

function modifier_bara_q:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_emp.vpcf"
end

function modifier_bara_q:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end