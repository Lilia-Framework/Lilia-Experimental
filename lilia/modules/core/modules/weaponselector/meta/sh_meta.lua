﻿local playerMeta = FindMetaTable("Player")
function playerMeta:SelectWeapon(class)
    if not self:HasWeapon(class) then return end
    self.doWeaponSwitch = self:GetWeapon(class)
end
