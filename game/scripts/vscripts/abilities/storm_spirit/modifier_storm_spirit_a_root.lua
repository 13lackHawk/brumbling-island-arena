modifier_storm_spirit_a_root = class({})

function modifier_storm_spirit_a_root:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true
    }

    return state
end

function modifier_storm_spirit_a_root:IsDebuff()
    return true
end

function modifier_storm_spirit_a_root:GetEffectName()
    return "particles/storm_a/storm_a_root.vpcf"
end

function modifier_storm_spirit_a_root:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end