modifier_drow_a = class({})

if IsServer() then
    function modifier_drow_a:OnCreated()
        print(self:GetCaster())
        self.trueVictim = self:GetCaster().hero:FindAbility("drow_a"):GetVictim()
        print(self.trueVictim)
        self.trueVictim:Interrupt()
        self.direction = (self.trueVictim:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end

    function modifier_drow_a:OnIntervalThink()
        local unit = self.trueVictim
        --print(unit)
        local position = unit:GetAbsOrigin() + self.direction * 500

        unit:MoveToPosition(position)
    end
end

--[[function modifier_drow_a:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end]]--

function modifier_drow_a:GetEffectName()
    return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"
end
 
function modifier_drow_a:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
 
function modifier_drow_a:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVISIBLE] = false
    }
 
    return state
end

--function modifier_drow_a:GetModifierMoveSpeedBonus_Percentage(params)
--    return -40
--end

function modifier_drow_a:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end