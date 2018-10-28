drow_e = class({})

LinkLuaModifier("modifier_drow_e", "abilities/drow/modifier_drow_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tinker_q", "abilities/tinker/modifier_tinker_q", LUA_MODIFIER_MOTION_NONE)

function drow_e:OnSpellStart()
    Wrappers.DirectionalAbility(self, 400)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()

    Dash(hero, target, 1200, {
        modifier = { name = "modifier_drow_e", ability = self },
        forceFacing = true,
        hitParams = {
            ability = self,
            modifier = { name = "modifier_tinker_q", ability = self, duration = 1.5 },
            sound = "Arena.Nevermore.HitE",
            action = function(target)
                if instanceof(target, Hero) and target:FindModifier("modifier_drow_w") then
                	target:Damage(hero, self:GetDamage())
                end
            end
        }
    })

    hero:EmitSound("Arena.Drow.CastE")
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(drow_e)