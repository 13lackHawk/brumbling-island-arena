modifier_timber_w = class({})
local self = modifier_timber_w

function self:GetEffectName()
    return "particles/items_fx/blademail.vpcf"
end

function self:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

function self:OnDamageReceived(source, hero, amount)
    if not self.soundPlayed then
        hero:EmitSound("Arena.Timber.ProcW")
        self.soundPlayed = true
    end
    if source.hero == nil then
        source:Damage(hero, amount)
    else
        source.hero:Damage(hero, amount)
    end
    return true
end

function self:OnDamageReceivedPriority()
    return PRIORITY_ABSOLUTE_SHIELD
end

if IsServer() then
    function self:OnDestroy()
        local hero = self:GetParent():GetParentEntity()
        hero:FindAbility("timber_a"):SetActivated(true)
    end
end
