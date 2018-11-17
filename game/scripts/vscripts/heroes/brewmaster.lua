Brewmaster = class({}, {}, Hero)

function Brewmaster:Init() end

function Brewmaster:SetOwner(owner)
    getbase(Brewmaster).SetOwner(self, owner)

    self.beerStacks = {}
end

function Brewmaster:Update()
    getbase(Brewmaster).Update(self)

    self:FindAbility("brew_e"):SetActivated(self:CountBeer(self) > 0)
end

function Brewmaster:AddBeerModifier(target, category, duration)
	if not target.beerStacks then target.beerStacks = {} end
	if not target.beerStacks[category] then target.beerStacks[category] = {} end

    if self:CountBeer(target) < 8 then
        local mod = target:AddNewModifier(self, self:FindAbility("brew_q"), "modifier_brew_beer", { duration = duration })
        table.insert(target.beerStacks[category], mod)
    	mod.OnDestroy = function()
    		for k,v in pairs(target.beerStacks[category]) do
    			if v == mod then 
    				table.remove(target.beerStacks[category], k)
    				break
    			end
    		end
    	end
    end
end

function Brewmaster:CountBeer(target, category)
	if not category then
    	return #target:GetUnit():FindAllModifiersByName("modifier_brew_beer")
    else
    	if target.beerStacks and target.beerStacks[category] then
    		return #target.beerStacks[category]
    	else
    		return 0
    	end
    end
end

function Brewmaster:ClearBeer(target, optionalAmount)
	local modifierList = target:GetUnit():FindAllModifiersByName("modifier_brew_beer")
    table.sort(modifierList, function(a,b) return a:GetDuration() > b:GetDuration() end)

    for i=optionalAmount, 1, -1 do
    	if modifierList[1] then
    		modifierList[1]:Destroy()
    		table.remove(modifierList, 1)
    	end
    end
end