BaraSpirit = BaraSpirit or class({}, nil, UnitEntity)

function BaraSpirit:constructor(round, owner, target, facing, ability)
    --local direction = (target - owner:GetPos()):Normalized()
    --direction = Vector(direction.y, -direction.x, 0)
    local pos = target

    getbase(BaraSpirit).constructor(self, round, "bara_spirit", pos, owner.unit:GetTeamNumber(), true)

    self.owner = owner.owner
    self.hero = owner
    self.size = 64
    self.target = target
    self.removeOnDeath = true
    self.attacking = nil
    self.collisionType = COLLISION_TYPE_INFLICTOR
    self.startTime = GameRules:GetGameTime()
    self.ability = ability

    self.facingDirection = facing
    self.skolko_zadel = 0
    self.est_kontakt = nil

    local unit = self:GetUnit()

    if owner.owner then
        unit:SetControllableByPlayer(owner.owner.id, true)
    end

    self:SetFacing(-self.facingDirection)

    self:AddComponent(HealthComponent())
    self:AddComponent(WearableComponent())
    self:LoadItems(unpack(owner:BuildWearableStack()))
    self:AddNewModifier(self.hero, nil, "modifier_bara_e", {})
    self:SetCustomHealth(2)
    self:EnableHealthBar()

    ImmediateEffect("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN, self.unit)
end

function BaraSpirit:GetName()
    return "npc_dota_hero_spirit_breaker"
end

function BaraSpirit:GetPos()
    return self:GetUnit():GetAbsOrigin()
end

function BaraSpirit:CollidesWith(target)
    return self.owner.team ~= target.owner.team
end

function BaraSpirit:CollideWith(target)
    local unit = self:GetUnit()
    self.est_kontakt = target:HasModifier("modifier_bara_e_slow")

    if GameRules:GetGameTime() - self.startTime >= 1.0 then

        if not instanceof(target, Projectile) and not instanceof(target, Obstacle) and not unit:IsStunned() and not unit:IsRooted() and not self.attacking and not self.est_kontakt and not target:IsAirborne() then
            local direction = (target:GetPos() - self:GetPos())
            local distance = direction:Length2D()

            self.attacking = target
            local blocked = self.attacking and self.attacking:AllowAbilityEffect(self, self.ability) == false
            if not blocked and self.attacking and self.attacking:Alive() then
                self:EmitSound("Arena.Lycan.HitQ")
                target:AddNewModifier(target, self.ability, "modifier_bara_e_slow", { duration = 1.0})
                self.attacking:Damage(self.attacking, self.ability:GetDamage())

                if instanceof(target, Hero) then
                    self.skolko_zadel = self.skolko_zadel + 1
                end
            end
            self.attacking = nil
        end
    end
end

function BaraSpirit:Update()
    getbase(BaraSpirit).Update(self)

    if self.falling then
        return
    end

    if GameRules:GetGameTime() - self.startTime >= 1.0 then

        local distanceBara = (self.hero:GetPos() - self:GetPos()):Length2D()

        if distanceBara <= 125 then
            if self.skolko_zadel >= 1 then
                self.hero:Heal(self.skolko_zadel * 2)
                local modifier = self.hero:FindModifier("modifier_bara_a")

                if modifier then
                    for i = 1, self.skolko_zadel do 
                        modifier:IncrementStackCount()
                    end
                else 
                    modifier = self.hero:AddNewModifier(self.hero, self.hero:FindAbility("bara_a"), "modifier_bara_a", {})
                    if modifier then
                        modifier:SetStackCount(self.skolko_zadel)
                    end
                end
            end
            self:Destroy()
            return
        end

        self.start = self.hero:GetPos()

        local result = self.start

        self.i = (self.i or 0) + 1

        if self.i % 5 == 0 then
            ExecuteOrderFromTable({ UnitIndex = self:GetUnit():GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION, Position = result })
        end
    end
end