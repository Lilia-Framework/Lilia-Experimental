ENT.Type = "anim"
ENT.PrintName = "Money"
ENT.Category = "Lilia"
ENT.Spawnable = false
ENT.DrawEntityInfo = true
function ENT:setAmount(amount)
    self:setNetVar("amount", amount)
end

function ENT:getAmount()
    return self:getNetVar("amount", 0)
end