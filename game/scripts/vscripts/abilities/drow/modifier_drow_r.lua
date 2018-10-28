modifier_drow_r = class({})

if IsServer() then
    function modifier_drow_r:OnCreated()
        local hero = self:GetParent():GetParentEntity()
        hero:EmitSound("Arena.Void.ProcQ")

        self.p1 = FX(hero:GetMappedParticle("particles/drow_r/drow_r_root.vpcf"), PATTACH_POINT_FOLLOW, hero, {
            cp0 = { ent = self:GetParent() },
            cp3 = { ent = self:GetParent() }
        })
    end

    function modifier_drow_r:OnDestroy()
        local hero = self:GetParent():GetParentEntity()
        hero:EmitSound("Arena.Void.EndQ")
        
        ParticleManager:DestroyParticle(self.p1, false)
        ParticleManager:ReleaseParticleIndex(self.p1)
    end
end

function modifier_drow_r:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true
    }

    return state
end

function modifier_drow_r:IsDebuff()
    return true
end