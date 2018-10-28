-- Plus ultra thanks to Kozdatel!

modifier_toga_metamorphosis = class({})
local self = modifier_toga_metamorphosis

if IsServer() then
    function self:OnCreated()
        Timers:CreateTimer(function()
            local hero = self:GetParent():GetParentEntity()
            local target = self.target
            local unit = hero:GetUnit()

            ExecuteOrderFromTable({ UnitIndex = unit:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_STOP })

            local items = {}
            self.data = {}
            self.data["model"] = hero:GetUnit():GetModelName()
            self.data["modelScale"] = hero:GetUnit():GetModelScale()
            local function tbllength(table) local count = 0 for k,v in pairs(table) do count = count + 1 end return count end

            for _,item in pairs(GameItems.items) do
                for _,wearable in pairs(self.target.wearables) do
                    if wearable:GetModelName() == item.model_player then
                        items[item.item_slot or "weapon"] = item.model_player
                    end
                end
            end
            for slot, item in pairs(target.wearableSlots) do
                if not items[slot] then
                    items[slot] = item:GetModelName()
                end
            end
            if tbllength(items) == 0 then -- Fixes Drow
                for slot,item in pairs(target:FindDefaultItems()) do
                    items[slot] = item.model_player
                end
            end

            hero:CleanWearables()
            for _,slotParticles in pairs(hero.wearableParticles) do
                for _,particle in pairs(slotParticles) do
                    ParticleManager:DestroyParticle(particle, true)
                    ParticleManager:ReleaseParticleIndex(particle)
                end
            end
            hero.wearableParticles = {}
            hero.slotVisualParameters = {}
            hero:GetUnit():SetModel(target:GetUnit():GetModelName())
            hero:GetUnit():SetOriginalModel(target:GetUnit():GetModelName())
            hero:GetUnit():SetModelScale(target:GetUnit():GetModelScale())

            for slot, model in pairs(items) do
                hero.slotVisualParameters[slot] = {}

                if model then
                    local wearable = hero:AttachWearable(model)
                    hero.slotVisualParameters[slot][1] = wearable

                    
                    hero.wearableSlots[slot] = wearable
                end
            end

            for slot, settings in pairs(target.slotVisualParameters) do 
                if not hero.slotVisualParameters[slot] then
                    hero.slotVisualParameters[slot] = {}
                end
                hero.slotVisualParameters[slot] = {hero.slotVisualParameters[slot][1] or hero:GetUnit(),
                settings[2] or {},
                settings[3] or nil,
                slot}
                hero:AttachVisuals(unpack(hero.slotVisualParameters[slot]))
            end

            if target:GetName() == "npc_dota_hero_gyrocopter" then
                print('GYRO')
                unit:StartGesture(ACT_DOTA_CONSTANT_LAYER)
            end

            -- And now the chaos begins...

            if target:GetName() == "npc_dota_hero_zuus" then
                print('swaPPPPPPP')
                hero:GetUnit():RemoveAbility("toga_a")
                hero:GetUnit():AddAbility("zeus_a"):SetLevel(1)

                Wrappers.WrapAbilitiesFromHeroData(unit, self.hero.data)
                --hero:SwapAbilities("toga_a", "zeus_a")
            end

            if target:GetName() == "npc_dota_hero_storm_spirit" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "storm_spirit_a")
            end

            if target:GetName() == "npc_dota_hero_phantom_assassin" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "pa_a")
            end

            if target:GetName() == "npc_dota_hero_crystal_maiden" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "cm_a")
            end

            if target:GetName() == "npc_dota_hero_sven" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "sven_a")
            end

            if target:GetName() == "npc_dota_hero_sniper" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "sniper_a")
            end

            if target:GetName() == "npc_dota_sand_king" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "sk_a")
            end

            if target:GetName() == "npc_dota_hero_legion_commander" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "lc_a")
            end

            if target:GetName() == "npc_dota_hero_lycan" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "lycan_a")
            end

            if target:GetName() == "npc_dota_hero_templar_assassin" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "ta_a")
            end

            if target:GetName() == "npc_dota_hero_phantom_assassin" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "pa_a")
            end

            if target:GetName() == "npc_dota_hero_crystal_maiden" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "cm_a")
            end

            if target:GetName() == "npc_dota_hero_sven" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "sven_a")
            end

            if target:GetName() == "npc_dota_hero_sniper" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "sniper_a")
            end

            if target:GetName() == "npc_dota_sand_king" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "sk_a")
            end

            if target:GetName() == "npc_dota_legion_commander" then
                print('swaPPPPPPP')
                hero:SwapAbilities("toga_a", "lc_a")
            end
        end)
    end

    function self:OnDestroy()
        local hero = self:GetAbility():GetCaster():GetParentEntity()
        --local hero = self:GetParent():GetParentEntity()
        local target = self.target
        local unit = hero:GetUnit()

        -- Chaos continues

        if target:GetName() == "npc_dota_hero_zuus" then
            print('swaP2')
            hero:GetUnit():RemoveAbility("zeus_a")
            hero:GetUnit():AddAbility("toga_a"):SetLevel(1)

            Wrappers.WrapAbilitiesFromHeroData(unit, self.hero.data)
            --hero:SwapAbilities("toga_a", "zeus_a")
        end

        hero:CleanWearables()
        for _,slotParticles in pairs(hero.wearableParticles) do
            for _,particle in pairs(slotParticles) do
                ParticleManager:DestroyParticle(particle, true)
                ParticleManager:ReleaseParticleIndex(particle)
            end
        end
        hero.wearableParticles = {}
        hero:GetUnit():SetModel(self.data.model)
        hero:GetUnit():SetOriginalModel(self.data.model)
        hero:GetUnit():SetModelScale(self.data.modelScale)
        hero:LoadItems()
    end

    function self:DeclareFunctions()
        local funcs = {
            MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
        }

        return funcs
    end

    function self:GetActivityTranslationModifiers()
        if self.target then
            if self.target:GetName() == "npc_dota_hero_juggernaut" then
                print('JUGG')
                return "run"
            elseif self.target:GetName() == "npc_dota_hero_pudge" then
                print('PUDGE')
                return "harpoon"
            elseif self.target:GetName() == "npc_dota_hero_tusk" then
                print('TUSK')
                return "run"
            elseif self.target:GetName() == "npc_dota_hero_tiny" then
                print('TINIK')
                return "tree"
            end
        else
            --return
        end
    end
end