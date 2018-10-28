rubick_q = class({})
local supertarget = nil
local kusochek = nil

LinkLuaModifier("modifier_rubick_q", "abilities/rubick/modifier_rubick_q", LUA_MODIFIER_MOTION_NONE)

require('abilities/rubick/rubick_q_entity')

function rubick_q:OnSpellStart()
    Wrappers.DirectionalAbility(self)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()
    supertarget = target
    local direction = self:GetDirection()
    local start = hero:GetPos() + direction * 64
    local len = 1200
    local speed = 30
    local currentLen = 0
    local target2 = self:GetCursorPosition() + direction * -1

    local pieces = {}
    local offsets = {}
    local stop = 0

    GameRules.GameMode.level:GroundAction(
        function(part)
            local closest = ClosestPointToSegment(target2, target, Vector(part.x, part.y, 0))
            local currentLen = (closest - start):Length2D()
            local closestLen = (closest - Vector(part.x, part.y, 0)):Length2D()

            if currentLen == 0 or currentLen == len or closestLen >= 150 then
                return
            end

            table.insert(pieces, part)
        end
    )
    for _, part in ipairs(pieces) do
        if stop > 0 then
            stop = 0
            break
        end
        kusochek = part
        offsets[part] = -225
        GameRules.GameMode.level:LaunchPart(part, nil, Vector(part.x, part.z) * -100.01, 1337)

        --part.offsetZ = part.offsetZ - offsets[part]
        --GameRules.GameMode.level:UpdatePartPosition(part)

        stop = stop + 1

        hero:AreaEffect({
        ability = self,
        filter = Filters.Area(target, 100),
        knockback = { force = 40, knockup = 40, decrease = 4 }
        })

        hero:SwapAbilities("rubick_q", "rubick_q_sub")
        hero:FindAbility("rubick_q_sub"):StartCooldown(0.450)
        hero:AddNewModifier(hero, hero:FindAbility("rubick_q_sub"), "modifier_rubick_q", { duration = 1.5 })

        Timers:CreateTimer(2.5, function()
            --local earthMagic = RubickQ(hero.round, hero, self, start, target, 3, self)
            part.velocity = 0
            part.offsetX = 0
            part.offsetY = 0
            part.offsetZ = 0
            part:AddEffects(EF_NODRAW)
            --if earthMagic then
            --    print('yes')
            --    earthMagic:Activate()
            --else
            --    print('sosi havk')
            --end
            Timers:RemoveTimer()
        end
        )
    end
end

function rubick_q:GetSpawn()
    return supertarget
end

function rubick_q:GetKusochek()
    return kusochek
end

function rubick_q:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function rubick_q:GetPlaybackRateOverride()
    return 2.5
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(rubick_q)