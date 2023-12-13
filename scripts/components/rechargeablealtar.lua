local RechargeableAltar = Class(function(self, inst)
    self.inst = inst
    self.maxcharges = 1
    self.currentcharges = 1
    self.maxfuel = 100
    self.currentfuel = 100
    self.accepteditems = {} --format the table to be k = prefabname, v = amount to fuel
end)

function RechargeableAltar:IsCharged() return self.currentcharges > 0 end

function RechargeableAltar:UseCharge()
    self.currentcharges = self.currentcharges - 1
    self.currentfuel = 0
end