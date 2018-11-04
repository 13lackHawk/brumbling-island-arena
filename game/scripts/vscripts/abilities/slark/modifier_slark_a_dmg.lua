modifier_slark_a_dmg = class({})

if IsServer() then
    function modifier_slark_a_dmg:OnCreated(kv)
        local path = self:GetParent():GetParentEntity():GetMappedParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf")
        local index = ParticleManager:CreateParticle(path, PATTACH_POINT_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControlEnt(index, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_blade", self:GetCaster():GetOrigin(), true)
        self:AddParticle(index, false, false, -1, false, false)
    end
end