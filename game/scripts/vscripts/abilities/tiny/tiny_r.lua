tiny_r = class({})
local self = tiny_r

LinkLuaModifier("modifier_tiny_r_root", "abilities/tiny/modifier_tiny_r_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tinker_q", "abilities/tinker/modifier_tinker_q", LUA_MODIFIER_MOTION_NONE)

function tiny_r:OnSpellStart()
    Wrappers.DirectionalAbility(self, 1250)

    local hero = self:GetCaster().hero
    local target = self:GetCursorPosition()

    DistanceCappedProjectile(hero.round, {
        ability = self,
        owner = hero,
        from = hero:GetPos() + Vector(0, 0, 128),
        to = target + Vector(0, 0, 128),
        speed = 1250,
        graphics = "particles/tiny_r/tiny_r_tree.vpcf",
        distance = 1250,
        damagesTrees = true,
		hitFunction = function(projectile, victim)
            if instanceof(victim, UnitEntity) then
				victim:Damage(projectile, self:GetDamage())
                if instanceof(victim, Hero) then
    				victim:AddNewModifier(hero, self, "modifier_tiny_r_root", { duration = 1.5 })
    				local modifier = victim:FindModifier("modifier_tree_heal")
    			    if not modifier then
    			        modifier = victim:AddNewModifier(victim, nil, "modifier_tree_heal", {})
    			    else
    			        modifier:Destroy()
    			    end
                end
            end
        end
    }):Activate()

    AddAnimationTranslate(hero:GetUnit(), "tree", 0.1)
    hero:GetUnit():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 2.5)

    hero:EmitSound("Arena.Tiny.CastR")
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(tiny_r)