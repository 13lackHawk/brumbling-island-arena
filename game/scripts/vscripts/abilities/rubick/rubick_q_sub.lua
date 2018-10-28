rubick_q_sub = class({})
local self = rubick_q_sub

--require('abilities/rubick/rubick_q')

function self:OnSpellStart()
    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()

    --local spawn
    local spawn = hero:FindAbility("rubick_q"):GetSpawn()
    local part = hero:FindAbility("rubick_q"):GetKusochek()

    if spawn then
        print('havk ne soset')
    end
    if part then
        print('kusok')
    end

    local modifier = hero:FindModifier("modifier_rubick_q")

    --[[if modifier then
        modifier:Destroy()
        for _, part in ipairs(pieces) do
            if stop > 0 then
                stop = 0
                break
            end
            stop = stop + 1

            RubickQ(hero.round, hero, self, spawn, target, 3, self):Activate()
            part.velocity = 0
            part.offsetX = 0
            part.offsetY = 0
            part.offsetZ = 0
            part:AddEffects(EF_NODRAW)

            AddAnimationTranslate(hero:GetUnit(), "bramble_maze", 0.1)
            hero:Animate(ACT_DOTA_CAST_ABILITY_5, 1.0)
        end
    end--]]
    if modifier then
        modifier:Destroy()

        FX("particles/rubick_q/rubick_q_explosion.vpcf", PATTACH_WORLDORIGIN, hero, {
            cp0 = spawn,
            cp3 = spawn,
            release = true
        })

        local earthMagic = RubickQ(hero.round, hero, self, spawn, target, 3, self)
        Timers:CreateTimer(0.1, function()
            earthMagic:Activate()
        end
        )
        part.velocity = 0
        part.offsetX = 0
        part.offsetY = 0
        part.offsetZ = 0
        part:AddEffects(EF_NODRAW)

        AddAnimationTranslate(hero:GetUnit(), "culling_blade", 0.1)
        hero:Animate(ACT_DOTA_CAST_ABILITY_5, 2.5)

        --hero:SwapAbilities("rubick_q_sub", "rubick_q")
        --hero:FindAbility("rubick_q_sub"):StartCooldown(0.3)
    end
end

--[[function self:GetBehavior()
    if self:GetCaster():HasModifier("modifier_gyro_e") then
        return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
    end

    return self.BaseClass.GetBehavior(self)
end]]--

--function self:GetCastAnimation()
--    return ACT_DOTA_CAST_ABILITY_5
--end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(rubick_q_sub)