function MODULE:OnLoaded()
    if lia.config.DevServer then
        print("This is a Development Server!")
    else
        print("This is a Main Server!")
    end
end