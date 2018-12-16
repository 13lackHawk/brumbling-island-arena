tusk_r_sub = class({})

function tusk_r_sub:OnSpellStart()
	local hero = self:GetCaster():GetParentEntity()
	local knockup = hero:FindModifier("modifier_tusk_r_sub").knockup
	local target = knockup.hero
	local direction = ((target:GetPos() - hero:GetPos()) * Vector(1,1,0)):Normalized()

	hero:SetPos(target:GetPos() + 100 * -direction)
	hero:SetFacing(direction)

	target:Damage(hero, self:GetDamage())
	FX("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, { release = true })
	target:EmitSound("Arena.Tusk.HitR.Hero")

	Knockup(hero, hero, -direction, 650, -1, {
        gesture = ACT_DOTA_FLAIL
    })

    Knockup(target, hero, direction, 1000, 0, {
        gesture = ACT_DOTA_FLAIL
    })

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