modifier_tusk_w_aura = class({})

if IsServer() then
    function modifier_tusk_w_aura:OnCreated(kv)
        local parent = self:GetParent()

        self.particle = FX("particles/tusk_w/tusk_frozen_sigil_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent, {
            cp1 = Vector(1, 4, 1),
            cp2 = { ent = parent },
            cp3 = Vector(525,2,1)
        })

        self.marker = FX("particles/aoe_marker.vpcf", PATTACH_WORLDORIGIN, parent, {
            cp0 = Vector(parent:GetAbsOrigin().x, parent:GetAbsOrigin().y, 0),
            cp1 = Vector(500, 1, 1),
            cp2 = Vector(0, 225, 215),
            cp3 = Vector(self:GetDuration(), 0, 0)
        })

        self:StartIntervalThink(0)
    end

    function modifier_tusk_w_aura:OnIntervalThink()
        local parent = self:GetParent()

        ParticleManager:SetParticleControl(self.marker, 0, Vector(parent:GetAbsOrigin().x, parent:GetAbsOrigin().y, 0))
    end

    function modifier_tusk_w_aura:OnDestroy()
        local ent = self:GetParent():GetParentEntity()
        ent:StopSound("Arena.Tusk.LoopW")
        ent.hero:SwapAbilities("tusk_w_sub", "tusk_w")
        ent.hero:FindAbility("tusk_w"):StartCooldown(ent.hero:FindAbility("tusk_w"):GetCooldown(1))
        ent:Destroy()

        DFX(self.marker)
    end
end

function modifier_tusk_w_aura:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }

    return state
end

function modifier_tusk_w_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }

    return funcs
end

function modifier_tusk_w_aura:OnAbilityExecuted(event)
    local hero = self:GetParent():GetParentEntity().hero

    if hero:FindAbility("tusk_w_sub") == event.ability then
        self:GetParent():GetParentEntity():StartMooving(event.ability:GetCursorPosition())
    end 
end

function modifier_tusk_w_aura:IsAura()
    return true
end

function modifier_tusk_w_aura:GetAuraRadius()
    return 500
end

function modifier_tusk_w_aura:GetModifierAura()
    return "modifier_tusk_w"
end

function modifier_tusk_w_aura:GetAuraEntityReject(entity)
    if entity.GetParentEntity and entity:GetParentEntity().owner and entity:GetParentEntity().owner.team == self:GetParent():GetParentEntity().owner.team then
        return true
    end

    return false
end

function modifier_tusk_w_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_tusk_w_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_tusk_w_aura:GetAuraDuration()
    return 0.1
end

function modifier_tusk_w_aura:Airborne()
    return true
end