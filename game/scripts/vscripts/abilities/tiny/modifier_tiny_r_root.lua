modifier_tiny_r_root = class({})

if IsServer() then
    function modifier_tiny_r_root:OnCreated()
        local hero = self:GetParent():GetParentEntity()
        hero:EmitSound("Arena.Void.ProcQ")

        self.p1 = FX(hero:GetMappedParticle("particles/tiny_r/tiny_r_root.vpcf"), PATTACH_POINT_FOLLOW, hero, {
            cp0 = { ent = self:GetParent() }
        })
    end

    function modifier_tiny_r_root:OnDestroy()
        local hero = self:GetParent():GetParentEntity()
        hero:EmitSound("Arena.Void.EndQ")
        
        ParticleManager:DestroyParticle(self.p1, false)
        ParticleManager:ReleaseParticleIndex(self.p1)
    end
end

function modifier_tiny_r_root:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true
    }

    return state
end

function modifier_tiny_r_root:IsDebuff()
    return true
end
