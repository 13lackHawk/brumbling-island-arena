modifier_tusk_q = class({})

function modifier_tusk_q:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_tusk_q:StatusEffectPriority()
    return 9
end

function modifier_tusk_q:GetKnockbackMultiplier()
    return 1.25
end

function modifier_tusk_q:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end