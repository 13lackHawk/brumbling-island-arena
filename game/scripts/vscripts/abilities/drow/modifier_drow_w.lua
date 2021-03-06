modifier_drow_w = class({})

if IsServer() then
    function modifier_drow_w:OnCreated()
        self:GetParent():Interrupt()
        self.direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end

    function modifier_drow_w:OnIntervalThink()
        local unit = self:GetParent()
        local position = unit:GetAbsOrigin() + self.direction * 500

        unit:MoveToPosition(position)
    end
end

function modifier_drow_w:GetEffectName()
    return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"
end
 
function modifier_drow_w:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 
function modifier_drow_w:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVISIBLE] = false
    }
 
    return state
end

function modifier_drow_w:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_drow_w:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_drow_w:Update()
    self.damageReceived = 0
end

function modifier_drow_w:OnDamageReceived(source, hero, amount)
    self.damageReceived = (self.damageReceived or 0) + amount
    if self.damageReceived >= 3 then
        self:Destroy()
    end
    return amount
end

function modifier_drow_w:GetModifierMoveSpeedBonus_Percentage(params)
    return -25
end