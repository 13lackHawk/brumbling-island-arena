modifier_undying_e_target = class({})
local self = modifier_undying_e_target

function self:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }

    return funcs
end

if IsServer() then

    function self:OnAbilityExecuted(event)
        local target = event.unit:GetParentEntity()
        local shouldBeAffectedByAbility = target:FindModifier("modifier_undying_e_target")
        local caster = self:GetCaster():GetParentEntity()

        if not event.ability.canBeSilenced then
            return
        end

        if shouldBeAffectedByAbility then
            FX("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.hero, {
               cp0 = { ent = caster.hero:GetUnit(), point = "attach_hitloc" },
               cp1 = { ent = self:GetParent(), point = "attach_hitloc" },
               release = true
            })
            caster.hero:Heal(2)
            target:EmitSound("Arena.Undying.ProcE")
        end
    end

    function self:OnCreated()
        self:CreateParticle()
        self:StartIntervalThink(2.5)
    end

    function self:OnIntervalThink()
        self:CreateParticle()

        local parent = self:GetParent():GetParentEntity()
        local caster = self:GetCaster():GetParentEntity()
        local blocked = parent:AllowAbilityEffect(caster, self:GetAbility()) == false

        if not blocked then
            parent:Damage(caster, self:GetAbility():GetDamage())
        end

        FX("particles/undying_e/undying_e_hit.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster(), {
            cp0 = self:GetCaster():GetAbsOrigin() + Vector(0, 0, 200),
            cp1 = { ent = self:GetParent(), point = "attach_hitloc" },
            release = true
        })
        self:GetParent():EmitSound("Arena.Undying.HitE")
    end

    function self:CreateParticle()
        local index = FX("particles/undying_e/undying_e_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), {})
        self:AddParticle(index, false, false, -1, false, false)
    end
end

function self:IsDebuff()
    return true
end