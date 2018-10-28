toga_a = class({})
local self = toga_a

LinkLuaModifier("modifier_toga_metamorphosis", "abilities/toga/modifier_toga_metamorphosis", LUA_MODIFIER_MOTION_NONE)

function toga_a:OnSpellStart()
    Wrappers.DirectionalAbility(self, 300)

    local hero = self:GetCaster().hero
    local pos = hero:GetPos()
    local forward = self:GetDirection()
    local range = 300
    local unit = hero:GetUnit()

    hero:AreaEffect({
        ability = self,
        filter = Filters.Cone(pos, range, forward, math.pi),
        sound = "Arena.Axe.HitA",
        damagesTrees = true,
        damage = self:GetDamage(),
        action = function(target)
            if instanceof(target, Hero) then
                --[[local mod = target:FindModifier("modifier_toga_a")
                if not mod then
                    hero:AddNewModifier(hero, self, "modifier_toga_a", {duration = 2})
                    if mod then
                        mod:SetStackCount(1)
                    end
                else
                    mod:IncrementStackCount()
                    mod:ForceRefresh()

                    if mod:GetStackCount() == 3 then
                        hero:Heal(2)
                        victim:EmitSound("Arena.Gyro.HitA2")
                        mod:Destroy()
                    end
                end]]--
                hero:AddNewModifier(hero, self, "modifier_toga_metamorphosis", {duration = 2}).target = target
                --target:AddNewModifier(hero, self, "modifier_toga_a_disarm", {duration = 0.3})
            end
        end,
        --knockback = { force = -20, decrease = 3 },
        isPhysical = true
    })

    hero:EmitSound("Arena.Drow.CastQ2")
end

function toga_a:GetCastAnimation()
    return ACT_DOTA_ATTACK
end

function toga_a:GetPlaybackRateOverride()
    return 2.5
end

if IsClient() then
    require("wrappers")
end

Wrappers.AttackAbility(toga_a)