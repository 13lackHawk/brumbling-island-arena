tusk_r_sub = class({})

LinkLuaModifier("modifier_tusk_r_target", "abilities/tusk/modifier_tusk_r_target", LUA_MODIFIER_MOTION_NONE)

require("abilities/tusk/tusk_r_knockback")

function tusk_r_sub:OnSpellStart()
	local hero = self:GetCaster():GetParentEntity()
	local target = hero:FindModifier("modifier_tusk_r_sub").target
	local direction = ((target:GetPos() - hero:GetPos()) * Vector(1,1,0)):Normalized()
	local targetPos = target:GetPos()

	hero:SetPos(targetPos + 100 * -direction)
	hero:SetFacing(direction)

	hero.round.spells:InterruptDashes(target)
	target:Damage(hero, self:GetDamage())
	FX("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, { release = true })
	target:EmitSound("Arena.Tusk.HitR.Hero")

	TuskRKnockback(target, self, direction, targetPos.z, 1000, 0)
	TuskRKnockback(hero, self, -direction, targetPos.z, 650, 0)

	hero:Animate(ACT_DOTA_CAST_ABILITY_5, 1.85)

	hero:RemoveModifier("modifier_tusk_r_sub")
end

if IsServer() then
    Wrappers.GuidedAbility(tusk_r_sub, true)
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(tusk_r_sub)