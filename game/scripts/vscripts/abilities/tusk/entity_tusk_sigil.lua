EntityTuskSigil = EntityTuskSigil or class({}, nil, UnitEntity)

function EntityTuskSigil:constructor(round, owner, position, ability)
    getbase(EntityTuskSigil).constructor(self, round, "tusk_sigil", position, owner:GetUnit():GetTeamNumber())

    self.hero = owner
    self.owner = owner.owner
    self.ability = ability
    self.collisionType = COLLISION_TYPE_NONE
    self.invulnerable = true
    self.removeOnDeath = true

    self:SetPos(Vector(self:GetPos().x,self:GetPos().y, 450))
    self.z = 450
    self:AddNewModifier(self, ability, "modifier_tusk_w_aura", { duration = 4.5 })

    self.startTime = GameRules:GetGameTime()
    self.hero:SwapAbilities("tusk_w", "tusk_w_sub")

    self:EmitSound("Arena.Tusk.CastW")
    self:EmitSound("Arena.Tusk.LoopW")
end

function EntityTuskSigil:Update()
    getbase(EntityTuskSigil).Update(self)

    self:SetPos(self:CalculateNextPosition())
end

function EntityTuskSigil:CalculateNextPosition()
    if self.target then
        local nextPos = self:GetPos()
        local dir = (self.target - nextPos):Normalized()
        local move = Vector(15,15,0) * dir
        nextPos = nextPos + ((self.target - self:GetPos()):Length2D() < move:Length2D() and self.target - self:GetPos() or move)
        return nextPos
    else
        return Vector(self:GetPos().x, self:GetPos().y, self.z) 
    end
end

function EntityTuskSigil:StartMooving(target)
    self.target = target + Vector(0,0,self:GetPos().z)
end

function EntityTuskSigil:CollidesWith(target)
    return false
end

function EntityTuskSigil:CanFall()
    return false
end

function EntityTuskSigil:IsInvulnerable()
    return true
end