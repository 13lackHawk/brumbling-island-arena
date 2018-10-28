sniper_r = class({})
LinkLuaModifier("modifier_sniper_r", "abilities/sniper/modifier_sniper_r", LUA_MODIFIER_MOTION_NONE)

function sniper_r:OnChannelThink(interval)
    local hero = self:GetCaster().hero

    self.channelingTime = (self.channelingTime or 0) + interval

    if interval == 0 then
        self:GetCaster().hero:EmitSound("Arena.Sniper.CastR.Voice")
    end

    if not self.soundPlayed and self.channelingTime >= 0.25 then
        self:GetCaster().hero:EmitSound("Arena.Sniper.PreA")
        self.soundPlayed = true
    end

    AddAnimationTranslate(hero:GetUnit(), "dreamleague", 0.1)
    hero:GetUnit():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 2.5)
end

function sniper_r:OnChannelFinish(interrupted)
    local hero = self:GetCaster().hero

    self.channelingTime = 0
    self.soundPlayed = false

    if interrupted then
        hero:GetUnit():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
        return
    end

    local facing = hero:GetFacing()
    local from = hero:GetPos() + Vector(facing.y, -facing.x, 0)
    local target = self:GetCursorPosition()

    local direction = target - hero:GetPos()
    direction = direction:Normalized()
    local target = hero:GetPos() + direction:Normalized() * 1350

    local effect = ImmediateEffect("particles/sniper_r/sniper_r_laser.vpcf", PATTACH_ABSORIGIN, hero)
    ParticleManager:SetParticleControlEnt(effect, 9, hero:GetUnit(), PATTACH_POINT_FOLLOW, "attach_attack1", hero:GetPos(), true)
    ParticleManager:SetParticleControl(effect, 1, target)

    hero:AreaEffect({
        ability = self,
        filter = Filters.Line(from, target, 96),
        modifier = { name = "modifier_sniper_r", duration = 5.0, ability = self },
        damage = self:GetDamage(),
        sound = "Arena.Tinker.HitQ",
        action = function(victim)
            if instanceof(victim, Hero) then
                TimedEntity(0.25, function()
                    hero:EmitSound("Arena.Sniper.HitR.Voice")
                end):Activate()
            end
        end
    })

    hero:EmitSound("Arena.Tinker.CastQ")

    TimedEntity(0.3, function()
        hero:GetUnit():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
    end):Activate()
end

function sniper_r:GetChannelTime()
    return 0.9
end

--[[function sniper_r:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end]]--

if IsServer() then
    Wrappers.GuidedAbility(sniper_r, true)
end

if IsClient() then
    require("wrappers")
end

Wrappers.NormalAbility(sniper_r)