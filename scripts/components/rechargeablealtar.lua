local RechargeableAltar = Class(function(self, inst)
    self.inst = inst
    self.maxcharges = 1
    self.currentcharges = 1
    self.maxfuel = 100
    self.currentfuel = 0
    self.accepteditems = {} --format the table to be k = prefabname, v = amount to fuel
    self.accepting = true
    self.onreceivechargefn = nil
end)

function RechargeableAltar:IsCharged() return self.currentcharges > 0 end

function RechargeableAltar:SetMaxCharges(amount)
    self.maxcharges = amount
end

function RechargeableAltar:SetMaxFuel(amount)
    self.maxfuel = amount
end

function RechargeableAltar:SetAcceptedItems(items)
    self.accepteditems = items
end

function RechargeableAltar:UseCharge()
    self.currentcharges = self.currentcharges - 1
    if not self.accepting then
        self.currentfuel = 0
        self.accepting = true
    end
end

function RechargeableAltar:ReceiveFuel(item)
    self.currentfuel = self.currentfuel + self.accepteditems[item] or 1
    if self.currentfuel >= self.maxfuel then
        self.currentcharges = self.currentcharges + 1
        self.currentfuel = 0
        self.accepting = self.currentcharges < self.maxcharges
        if self.onreceivecharge then self.onreceivechargefn(self.inst) end
    end

    if item then item:Remove() end
    return true
end

return RechargeableAltar