modifier_ursa_e_debuff = class({})

function modifier_ursa_e_debuff:GetEffectName()
    return "particles/ursa_e/ursa_e.vpcf"
end

function modifier_ursa_e_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end