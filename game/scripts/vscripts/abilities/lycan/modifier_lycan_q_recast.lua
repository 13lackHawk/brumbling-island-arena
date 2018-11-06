modifier_lycan_q_recast = class({})
local self = modifier_lycan_q_recast

if IsServer() then
    function self:OnCreated()
        self.wolfs = {}
        local hero = self:GetParent():GetParentEntity()
        hero:SwapAbilities("lycan_q", "lycan_q_sub")
        for _, ent in pairs(hero.round.spells:GetValidTargets()) do
            if instanceof(ent, LycanWolf) and ent.hero == hero and ent:Alive() and not ent.falling then
                table.insert(self.wolfs, ent)
            end
        end

        self:StartIntervalThink(0)
    end

    function self:OnIntervalThink()
        for i=#self.wolfs,1,-1 do
            local wolf = self.wolfs[i]

            if (not wolf:Alive()) or wolf.falling then
                table.remove(self.wolfs, i)
            end
        end

        if #self.wolfs == 0 then
            self:Destroy()
        end
    end
    
    function self:OnDestroy()
        local hero = self:GetParent():GetParentEntity()
        hero:SwapAbilities("lycan_q_sub", "lycan_q")
    end
end

function self:IsHidden()
    return true
end