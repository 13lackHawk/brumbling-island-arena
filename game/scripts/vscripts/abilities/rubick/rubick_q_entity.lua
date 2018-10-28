RubickQ = RubickQ or class({}, nil, Projectile)

function RubickQ:constructor(round, owner, ability, spawn, target, damage, ability)

    self.groundHeight = GetGroundHeight(spawn, nil)

    local graphics = nil
    if RandomInt(1, 2) == 1 then
        graphics = "particles/rubick_q/rubick_q.vpcf"
    else
        graphics = "particles/rubick_q/rubick_q3.vpcf"
    end

    getbase(RubickQ).constructor(self, round, {
        ability = ability,
        owner = owner,
        from = spawn + Vector(0, 0, 32) + self.groundHeight,
        to = target + Vector(0, 0, 32) + self.groundHeight,
        hitModifier = { name = "modifier_stunned_lua", duration = 1.0, ability = ability },
        hitSound = "Arena.Tiny.HitQ",
        graphics = graphics,
        speed = 1800,
        continueOnHit = true,
        disablePrediction = true,
        damage = damage
    })

    self.fell = false
    self.fallingDirection = nil
    self.picked = false
    self.heightVel = 4
    self.removeOnDeath = true
    self.ability = ability
    self.timeStarted = GameRules:GetGameTime()
    self.flyParticle = ParticleManager:CreateParticle("particles/tiny_q/tiny_q_fly_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW , self:GetUnit())
end

function RubickQ:CanFall()
    return self.fell
end

function RubickQ:CollideWith(target)
    if target == self.hero then

    else
        getbase(RubickQ).CollideWith(self, target)
    end
end

function RubickQ:CollidesWith(target)
    if target == self.hero then
        return GameRules:GetGameTime() - self.timeStarted > 0.1
    end

    if self:GetSpeed() == 0 then
        self:Destroy()
        return target == self.hero
    else
        return getbase(RubickQ).CollidesWith(self, target)
    end
end

function RubickQ:MakeFall()
    getbase(RubickQ).MakeFall(self)

    self.fallingDirection = self:GetNextPosition(self:GetPos()) - self:GetPos()

    self:RemoveGroundEffect()
end

function RubickQ:Damage() end

function RubickQ:GetNextPosition(pos)
    local position = getbase(RubickQ).GetNextPosition(self, pos)

    position.z = math.max(position.z + self.heightVel, self.groundHeight)

    return position
end

function RubickQ:Update()
    getbase(RubickQ).Update(self)

    if self.falling then
        self:SetPos(self:GetPos() + self.fallingDirection)
        return
    end

    local speed = self:GetSpeed()

    if speed > 0 then
        local decay = 30

        if self:GetPos().z == self.groundHeight then
            decay = 90

            if not self.fell then
                self.fell = true

                if self:TestFalling() then
                    self.secondParticle = ParticleManager:CreateParticle("particles/tiny_q/tiny_q_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW , self.unit)
                    self:EmitSound("Arena.Tiny.LandQ", self:GetPos())

                    Spells:GroundDamage(self:GetPos(), 200, self.hero)
                end

                self:RemoveSmoke()
            end
        end

        self.heightVel = self.heightVel - 1
        speed = math.max(self.speed - decay, 0)
        self:SetSpeed(speed)
    else
        self:RemoveGroundEffect()
    end

end

function RubickQ:RemoveGroundEffect()
    if self.secondParticle then
        ParticleManager:DestroyParticle(self.secondParticle, false)
        ParticleManager:ReleaseParticleIndex(self.secondParticle)

        self.secondParticle = nil
    end
end

function RubickQ:RemoveSmoke()
    if self.flyParticle then
        ParticleManager:DestroyParticle(self.flyParticle, true)
        ParticleManager:ReleaseParticleIndex(self.flyParticle)

        self.flyParticle = nil
    end
end

function RubickQ:Remove()

    self:RemoveGroundEffect()
    self:RemoveSmoke()

    getbase(RubickQ).Remove(self)
end
