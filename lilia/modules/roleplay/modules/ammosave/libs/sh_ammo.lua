function lia.ammo.register(name)
    table.insert(MODULE.ammoList, name)
end

for k, v in pairs(lia.config.Ammo) do
    lia.ammo.register(v)
    lia.ammo.register(k)
end

for k, v in pairs(lia.config.AmmoRegister) do
    lia.ammo.register(v)
end