local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
Name = "Zen Hub",
Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
LoadingTitle = "Join Zen Hub Discord For Updates! \nuse at your own risk.",
LoadingSubtitle = "by Prith.Stha",
Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

DisableRayfieldPrompts = false,
DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

ConfigurationSaving = {
    Enabled = false,
    FolderName = nil, -- Create a custom folder for your hub/game
    FileName = "Zen Hub by Prith.Stha"
},

Discord = {
    Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
    Invite = "discord.gg/zen-hub", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
    RememberJoins = true -- Set this to false to make them join the discord every time they load it up
},

KeySystem = false, -- Set this to true to use our key system
KeySettings = {
    Title = "ZenHub Key",
    Subtitle = "link in discord server",
    Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
    FileName = "Unlocking", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
    SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
    GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
    Key = {"https://pastebin.com/raw/5HrQrWeG"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
}
})

local HomeTab = Window:CreateTab("Home", nil) -- Title, Image
local TeleportTab = Window:CreateTab("Teleport", nil) -- Title, Image
local ShopTab = Window:CreateTab("Shop", nil)
local PlayerTab = Window:CreateTab("Player", nil)


Rayfield:Notify({
Title = "Script Loaded",
Content = "Join Zen Hub Discord For Updates! \nuse at your own risk.",
Duration = 7.5,
Image = 4483362458,
})



local Section = HomeTab:CreateSection("Farming")

local AutoEquipToggle
local AutoCastToggle
local AutoShakeToggle
local AutoReelToggle
local FreezeCharacterToggle

AutoEquipToggle = HomeTab:CreateToggle({
    Name = "Auto Equip",
    CurrentValue = false,
    Flag = "equip",
    Callback = function(Value)
        if Value then
            -- Enable Auto Equip
            task.spawn(function()
                while AutoEquipToggle.CurrentValue do
                    local rodClientBP = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("rod/client", true)
                    if rodClientBP then
                        pcall(function()
                            game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.backpack.events.equip:FireServer(rodClientBP.Parent)
                        end)
                    end
                    task.wait(1) -- Adjust interval to control execution frequency
                end
            end)
        else
            -- Disable Auto Equip
            print("Auto Equip disabled.")
        end
    end
})


AutoCastToggle = HomeTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = false,
    Flag = "cast",
    Callback = function(Value)
        -- Start or stop autocasting based on toggle value
        if Value then
            -- Enable Auto Cast
            task.spawn(function()
                while AutoCastToggle.CurrentValue do
                    local RodClientScript = game.Players.LocalPlayer.Backpack:FindFirstChild("rod/client", true) 
                        or game.Players.LocalPlayer.Character:FindFirstChild("rod/client", true)

                    if RodClientScript then
                        if not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") 
                            and not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel") then
                            local args = {
                                [1] = 99.8,
                                [2] = 1
                            }
                            local char = game:GetService("Players").LocalPlayer.Character
                            local rodName = RodClientScript.Parent.Name
                            if char:FindFirstChild(rodName) then
                                char[rodName].events.cast:FireServer(unpack(args))
                            end
                        end
                    end
                    task.wait(0.5) -- Adjust the delay to control cast frequency
                end
            end)
        else
            -- Disable Auto Cast
            print("Auto Cast disabled.")
        end
    end
})

__Alchemy = __Alchemy or {
    AutoShake = false,
    AutoFishing = false,
    methodFishing = "Mouse",
    Connection = nil
}

AutoShakeToggle = HomeTab:CreateToggle({
    Name = "Auto Shake",
    CurrentValue = false,
    Flag = "shake",
    Callback = function(Value)
        if Value then
            -- Enable Auto Shake
            __Alchemy.AutoShake = true

            -- Start the RenderStepped connection if not already running
            if not __Alchemy.Connection then
                __Alchemy.Connection = game:GetService("RunService").RenderStepped:Connect(function()
                    if __Alchemy.AutoShake or __Alchemy.AutoFishing then
                        if __Alchemy.methodFishing == "Mouse" then
                            local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                            local shakeUI = playerGui:FindFirstChild("shakeui")
                            if shakeUI then
                                local button = shakeUI.safezone:FindFirstChild("button")
                                if button then
                                    button.Size = UDim2.new(1001, 0, 1001, 0)
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                                    game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                                end
                            end
                        end
                    end
                end)
            end
        else
            -- Disable Auto Shake
            __Alchemy.AutoShake = false

            -- Disconnect the RenderStepped connection if AutoFishing is also disabled
            if not __Alchemy.AutoFishing and __Alchemy.Connection then
                __Alchemy.Connection:Disconnect()
                __Alchemy.Connection = nil
            end
        end
    end
})



AutoReelToggle = HomeTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = false,
    Flag = "autoreel",
    Callback = function(Value)
        if Value then
            -- Enable Reel Finished
            task.spawn(function()
                while AutoReelToggle.CurrentValue do
                    local args = {
                        [1] = 100, -- Amount or percentage (adjust as needed)
                        [2] = 1, -- This variable determines perfect catch behavior
                    }
                    
                    -- Fire the "autoreel" event
                    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("autoreel"):FireServer(unpack(args))
                    task.wait(0.1) -- Adjust interval for execution frequency
                end
            end)
        else
            -- Disable Reel Finished
            print("Auto Reel disabled.")
        end
    end
})



FreezeCharacterToggle = HomeTab:CreateToggle({
    Name = "Freeze Character",
    CurrentValue = false,
    Flag = "freezecharacter",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if Value then
                -- Freeze legs (stop movement)
                humanoid.WalkSpeed = 0
            else
                -- Unfreeze legs (restore movement)
                humanoid.WalkSpeed = 16 -- Default Roblox WalkSpeed
            end
        end
    end
})

local Section = HomeTab:CreateSection("Sell Items")

local Button = HomeTab:CreateButton({
    Name = "Sell Hand (coming soon)",
    Callback = function(value)

    end
})


local Button = HomeTab:CreateButton({
    Name = "Sell All",
    Callback = function()
        for _, npc in pairs(game.Workspace.world.npcs:GetChildren()) do
            if npc:FindFirstChild("merchant") then
                local dialogPrompt = npc:FindFirstChild("dialogprompt")
                if dialogPrompt then
                    fireproximityprompt(dialogPrompt) -- Fire the proximity prompt
                    task.wait(0.5) -- Small delay to allow the interaction to register
                    game:GetService("ReplicatedStorage").events.SellAll:InvokeServer() -- Invoke the SellAll event
                end
            end
        end
    end,
})


local Button = HomeTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local player = game.Players.LocalPlayer
        local placeId = game.PlaceId
        local jobId = game.JobId

        -- Wait a bit before teleporting to ensure the current actions finish
        task.wait(1)

        -- Teleport to the same server using the PlaceId and JobId
        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, jobId, player)
    end,
})


    

local Section = TeleportTab:CreateSection("Teleport")

local Dropdown = TeleportTab:CreateDropdown({
    Name = "Area Teleport",
    Options = {    "Grand Reef", "Moosewood", "Roslit Bay", "Roslit Volcano", 
    "Mushgrove Swamp", "Terrapin Island", "Snowcap Island", 
    "Sunstone Island", "Forsaken Shores", "Statue Of Sovereignty", 
    "Keepers Altar", "Vertigo", "The Depths", "Desolate Deep", 
    "Desolate Pocket", "Brine Pool", "Ancient Isle", "Ancient Archives", 
    "The Ocean", "Deep Ocean", "Earmark Island", "Haddock Rock", 
    "The Arch", "Birch Cay", "Harvesters Spike", "Northern Expedition" },
    CurrentOption = {"Moosewood"},
    MultipleOptions = false,
    Flag = "areateleport", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Options)
        local TeleportLocation = {
            ['Forsaken Shores'] = CFrame.new(-2509.84766, 135.58136, 1568.06921, 0.576484084, -2.90220239e-08, 0.817108393, -2.91917193e-08, 1, 5.61132225e-08, -0.817108393, -5.6201177e-08, 0.576484084);
            ['Roslit Bay'] = CFrame.new(-1472.76562, 132.525513, 710.11377, 0.857699811, 3.99945321e-08, -0.514150798, -4.50792648e-08, 1, 2.58689425e-09, 0.514150798, 2.09587618e-08, 0.857699811);
            ['Sunstone Island'] = CFrame.new(-916.835876, 135.842087, -1125.71436, -0.770310819, -9.40425782e-09, 0.63766855, -4.71950168e-09, 1, 9.04666653e-09, -0.63766855, 3.95926758e-09, -0.770310819);
            ['Moosewood'] = CFrame.new(387.319153, 134.500031, 255.297958, 0.99990648, -5.88508762e-08, 0.0136754476, 5.73468562e-08, 1, 1.10371673e-07, -0.0136754476, -1.09577101e-07, 0.99990648);
            ['Snowcap Island'] = CFrame.new(2597.84912, 135.283859, 2417.89453, 0.320652425, -7.56810294e-08, -0.94719696, 4.79189168e-08, 1, -6.36781081e-08, 0.94719696, -2.49701131e-08, 0.320652425);
            ['Terrapin Island'] = CFrame.new(-167.348587, 145.085602, 1938.59583, -0.304156363, 1.14892146e-07, 0.952622116, -1.4166246e-09, 1, -1.2105852e-07, -0.952622116, -3.81702243e-08, -0.304156363);
            ['Statue Of Sovereignty'] = CFrame.new(20.0280285, 159.014709, -1041.87463, 0.718164384, 6.87932982e-08, 0.695873499, -1.21948913e-08, 1, -8.62733884e-08, -0.695873499, 5.34723732e-08, 0.718164384);
            ['Vertigo'] = CFrame.new(-112.719063, -515.299377, 1136.88416, -0.924575984, 5.51628148e-08, 0.380997658, 6.49570424e-08, 1, 1.28476128e-08, -0.380997658, 3.66270783e-08, -0.924575984);
            ['The Depths'] = CFrame.new(945.280334, -711.662109, 1259.22156, -0.172736004, 1.49195341e-08, -0.984968185, 2.28289156e-08, 1, 1.11436682e-08, 0.984968185, -2.05608437e-08, -0.172736004);
            ['Mushgrove Swamp'] = CFrame.new(2445.54224, 130.904053, -679.550842, -0.870547235, 1.35535743e-08, -0.492084801, 1.40879317e-08, 1, 2.62020516e-09, 0.492084801, -4.65144501e-09, -0.870547235);
            ['Desolate Deep'] = CFrame.new(-1656.29468, -213.779953, -2849.88428, -0.523361683, 9.58157642e-08, 0.852110624, 2.75531846e-08, 1, -9.55222035e-08, -0.852110624, -2.65143001e-08, -0.523361683);
            ['Enchant Room'] = CFrame.new(1308.28259, -805.292236, -98.5643768, -0.992340386, -1.97533989e-08, -0.123533793, -2.072494e-08, 1, 6.5795378e-09, 0.123533793, 9.08937103e-09, -0.992340386);
            ['Roslit Volcano'] = CFrame.new(-1959.17444, 193.213547, 271.522217, -0.994524002, -5.97535958e-08, 0.104508668, -5.71623495e-08, 1, 2.77897225e-08, -0.104508668, 2.16635847e-08, -0.994524002);
            ['Brine Pool'] = CFrame.new(-1787.59717, -118.740646, -3384.49683, -1, 0, 0, 0, 1, 0, 0, 0, -1);
            ['The Arch'] = CFrame.new(1007.4986, 131.516281, -1267.97058, 0.980580807, -9.53307833e-09, 0.196115628, 1.04557296e-08, 1, -3.66930708e-09, -0.196115628, 5.64858382e-09, 0.980580807);
            ['Ancient Isles'] = CFrame.new(6063.52002, 195.18013, 285.97113, -0.00490061752, -5.11460669e-08, -0.999988019, 2.93520017e-08, 1, -5.12905238e-08, 0.999988019, -2.96030045e-08, -0.00490061752);
            ['Rod Crafting'] = CFrame.new(-3161.23511, -747.214539, 1701.67944, 0.999994099, -2.56897152e-08, -0.00343629811, 2.55435548e-08, 1, -4.25783249e-08, 0.00343629811, 4.24902993e-08, 0.999994099);
            ['Ancient Waterfall'] = CFrame.new(5800.40088, 135.301468, 406.355682, 0.421890169, 4.07270395e-09, -0.906646967, -2.43030374e-09, 1, 3.36115691e-09, 0.906646967, 7.85388532e-10, 0.421890169);
            ['Snow Globe'] = CFrame.new(-101.126625, 364.635834, -9492.83594, 0.54968226, -3.44239446e-08, -0.835373819, 5.55941746e-08, 1, -4.62644545e-09, 0.835373819, -4.38988437e-08, 0.54968226);
            ['Northern Summit'] = CFrame.new(19535.4453, 132.670074, 5293.35547, -0.824248374, 5.19136591e-08, -0.566228449, -8.73330208e-09, 1, 1.0439615e-07, 0.566228449, 9.0993403e-08, -0.824248374);
            ['Glacial Grotto'] = CFrame.new(20015.3262, 1136.42773, 5531.2583, 0.100680023, -9.49732311e-08, 0.994918883, 6.66767193e-08, 1, 8.87109692e-08, -0.994918883, 5.74065027e-08, 0.100680023);
            ['Cryogenic Canal'] = CFrame.new(20130, 670, 5486);
            ['Frigid Cavern'] = CFrame.new(19842, 438, 5617);
            ['Grand Reef'] = CFrame.new(-3580.25952, 150.961731, 515.507812, 0.856589258, -1.12539942e-08, 0.51599884, -1.97214476e-08, 1, 5.45489094e-08, -0.51599884, -5.69022554e-08, 0.856589258);
        }
        local selectedLocation = Options[1] -- Get the selected location
        local teleportCFrame = TeleportLocation[selectedLocation]

        if teleportCFrame then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleportCFrame
        else
            warn("Invalid location selected!")
        end
    end,
 })


 local Dropdown = TeleportTab:CreateDropdown({
    Name = "Items Teleport",
    Options = { 
        "Mystic Gem", "Treasure Chest", "Coral Crown", "Stormbreaker", 
        "Seashell", "Oceanic Scroll", "Flight Wings", "Deep Dive Gear", 
        "Moonstone", "Sun Totem", "Silver Fish", "Oceanic Codex", 
        "Teleportation Stone", "Magic Compass", "Ancient Orb", "Tempest Stone", 
        "Gale Crystal", "Fishing Rod", "Eclipse Crystal", "Meteor Stone", 
        "Enhanced Wings", "Oxygen Flask", "Diving Helmet", "Breather Mask", 
        "Frost Totem", "Freezing Globe", "Snow Pickaxe", "Blizzard Crystal", 
        "Winter Cloak" 
    },
    
    CurrentOption = {"Coral Crown"},
    MultipleOptions = false,
    Flag = "itemteleport", -- A flag is the identifier for the configuration file
    Callback = function(Options)
        local TeleportItems = {
            ['Mystic Gem'] = CFrame.new(-1200.230, 150.534, -1100.230, -0.924, 0, -0.382, 0, 1, 0, 0.382, 0, -0.924),
            ['Treasure Chest'] = CFrame.new(-1055.786, 210.456, -1105.970, -0.275, 0, 0.961, 0, 1, 0, -0.961, 0, -0.275),
            ['Coral Crown'] = CFrame.new(-1400.412, 145.657, 620.312, -0.897, -0.023, -0.441, 0, 1, 0, 0.441, 0, -0.897),
            ['Stormbreaker'] = CFrame.new(-1600.391, -215.883, -2850.312, 0.054, -0.320, -0.946, 0.215, 0.925, -0.305, 0.974, -0.164, 0.141),
            ['Seashell'] = CFrame.new(-1640.525, -210.321, -2854.201, 0.810, -0.530, -0.248, -0.052, 0.268, -0.962, 0.586, 0.780, 0.207),
            ['Oceanic Scroll'] = CFrame.new(-1645.743, -215.950, -2847.101, 0.586, -0.745, -0.314, -0.097, 0.337, -0.937, 0.804, 0.578, 0.125),
            ['Flight Wings'] = CFrame.new(-1639.624, -215.121, -2858.053, 0.531, 0, 0.847, 0, 1, 0, -0.847, 0, 0.531),
            ['Deep Dive Gear'] = CFrame.new(-1655.601, -218.073, -2830.110, -0.039, 0, 0.999, 0, 1, 0, -0.999, 0, -0.039),
            ['Moonstone'] = CFrame.new(-1625.331, -214.450, -2855.111, 0.621, 0.764, 0.173, -0.415, 0.040, 0.909, 0.677, -0.643, 0.358),
            ['Sun Totem'] = CFrame.new(-1800.314, -130.120, -3285.314, 0.688, -0.232, -0.690, 0.042, 0.964, -0.264, 0.725, 0.160, 0.667),
            ['Silver Fish'] = CFrame.new(-980.054, -230.310, -2695.204, 0.825, -0.021, -0.565, 0.014, 1, -0.023, 0.565, 0.013, 0.825),
            ['Oceanic Codex'] = CFrame.new(-960.276, -240.415, -2703.004, 0.972, 0.076, -0.224, 0.153, -0.276, 0.951, 0.079, -0.960, -0.269),
            ['Teleportation Stone'] = CFrame.new(2800.415, 140.220, -650.220, -0.997, 0.028, 0.067, 0.030, 0.997, -0.066, -0.067, -0.062, -0.996),
            ['Magic Compass'] = CFrame.new(520.470, 150.710, 290.130, 0.000, -0.719, -0.695, -1.000, 0.000, -0.000, -0.000, 0.695, -0.719),
            ['Ancient Orb'] = CFrame.new(-175.421, 145.313, 1945.323, -0.962, 0.014, 0.271, 0.002, 0.999, -0.034, -0.272, -0.034, -0.962),
            ['Tempest Stone'] = CFrame.new(60.540, 135.211, 1950.113, 0.611, 0, 0.791, 0, 1, 0, -0.791, 0, 0.611),
            ['Gale Crystal'] = CFrame.new(2850.540, 185.443, 2700.432, -0.375, 0.000, 0.928, 0.143, 0.988, 0.056, -0.918, 0.153, -0.366),
            ['Fishing Rod'] = CFrame.new(370.420, 135.260, 275.470, 0.718, -0.102, -0.686, 0.000, 0.988, -0.158, 0.707, 0.111, 0.696),
            ['Eclipse Crystal'] = CFrame.new(5950.710, 275.112, 840.310, 0.918, 0.000, -0.397, 0.000, 1.000, 0.000, 0.397, 0.000, 0.918),
            ['Meteor Stone'] = CFrame.new(-1940.332, 275.102, 235.111, 0.758, 0.198, 0.621, -0.042, 0.965, -0.259, -0.651, 0.170, 0.740),
            ['Enhanced Wings'] = CFrame.new(19950.311, 1145.312, 5540.821, -0.998, 0.028, -0.044, -0.001, 0.828, 0.559, 0.052, 0.558, -0.828),
            ['Oxygen Flask'] = CFrame.new(19520.301, 131.545, 5330.670, 0.974, 0.037, 0.225, 0.000, 0.987, -0.163, -0.228, 0.158, 0.961),
            ['Diving Helmet'] = CFrame.new(19940.432, 1140.742, 5541.702, 0.936, 0.000, 0.352, 0, 1, 0, -0.352, 0, 0.936),
            ['Breather Mask'] = CFrame.new(19780.730, 415.732, 5385.220, 0.575, 0.112, 0.811, -0.022, 0.992, -0.122, -0.819, 0.051, 0.572),
            ['Frost Totem'] = CFrame.new(20155.420, 740.435, 5804.125, -0.556, 0, 0.831, 0, 1, 0, -0.831, 0, -0.556),
            ['Freezing Globe'] = CFrame.new(20215.320, 734.633, 5716.215, 0.718, 0.000, -0.696, 0, 1, 0, 0.696, 0, 0.718),
            ['Snow Pickaxe'] = CFrame.new(19783.420, 417.190, 5392.301, 0.635, -0.024, -0.773, 0.000, 1, -0.031, 0.773, 0.019, 0.634),
            ['Blizzard Crystal'] = CFrame.new(19710.675, 465.243, 6060.512, -0.472, 0, -0.882, 0, 1, 0, 0.882, 0, -0.472),
            ['Winter Cloak'] = CFrame.new(20175.302, 780.411, 5725.032, -0.063, -0.989, -0.134, 0.014, 0.133, -0.991, 0.998, -0.064, 0.005)
        }
        
        local selectedLocationItem = Options[1] -- Get the selected item
        local teleportCFrame = TeleportItems[selectedLocationItem]

        if teleportCFrame then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleportCFrame
        else
            warn("Invalid location selected!")
        end
    end,
})


local Dropdown = TeleportTab:CreateDropdown({
    Name = "Rods Teleport",
    Options = { 
        "Training Rod", "Plastic Rod", "Carbon Rod", "Fast Rod", 
        "Lucky Rod", "Long Rod", "Reinforced Rod", "Kings Rod", 
        "Steady Rod", "Fortune Rod", "Rapid Rod", "Nocturnal Rod", 
        "Aurora Rod", "Rod Of The Depths", "Magnet Rod", "Trident Rod", 
        "Scurvy Rod", "Phoenix Rod", "Stone Rod", "Avalanche Rod", 
        "Arctic Rod", "Summit Rod", "Heavens Rod"
    },
    CurrentOption = {"Training Rod"},
    MultipleOptions = false,
    Flag = "rodteleport", -- A flag is the identifier for the configuration file
    Callback = function(Options)
        -- Define the locations for each rod
        local TeleportRod = {
            ['Training Rod'] = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998),
            ['Plastic Rod'] = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
            ['Carbon Rod'] = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
            ['Fast Rod'] = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
            ['Lucky Rod'] = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
            ['Long Rod'] = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
            ['Reinforced Rod'] = CFrame.new(-986.474365, -245.473938, -2689.79248, 0.950221658, -0.248433635, 0.188041329, -0.188312545, 0.0228964686, 0.981842279, -0.248228103, -0.968378305, -0.0250264406),
            ['Kings Rod'] = CFrame.new(1375.90063, -810.154297, -303.509247, -0.7490201, 0.662445903, -0.0116144121, -0.0837960541, -0.0773290396, 0.993478119, 0.657227278, 0.745108068, 0.113431036),
            ['Steady Rod'] = CFrame.new(-1511.23523, 139.679489, 759.417114, 0.992959678, 1.84196979e-05, -0.11845281, 0.0317781717, 0.963300347, 0.266538173, 0.114110537, -0.268425852, 0.956517816),
            ['Fortune Rod'] = CFrame.new(-1520.87964, 141.283279, 771.946777, 0.220332444, -0.975424826, -5.51939011e-05, -5.51939011e-05, -6.90221786e-05, 1, -0.975424826, -0.220332414, -6.90221786e-05),
            ['Rapid Rod'] = CFrame.new(-1509.24463, 139.725906, 759.628174, 0.992959678, 1.84196979e-05, -0.11845281, 0.0317781717, 0.963300347, 0.266538173, 0.114110537, -0.268425852, 0.956517816),
            ['Nocturnal Rod'] = CFrame.new(-141.874237, -515.313477, 1139.04529, 0.161644459, -0.98684907, 1.87754631e-05, 1.87754631e-05, 2.21133232e-05, 1, -0.98684907, -0.161644459, 2.21133232e-05),
            ['Aurora Rod'] = CFrame.new(-144.52243, -513.268188, 1129.62732, 0.977461934, -1.21115757e-08, 0.21111168, 3.90185573e-09, 1, 3.93045987e-08, -0.21111168, -3.75950222e-08, 0.977461934),
            ['Rod Of The Depths'] = CFrame.new(1705.16052, -902.678589, 1448.06055, -0.0675487518, 0, -0.99771595, 0, 1, 0, 0.99771595, 0, -0.0675487518),
            ['Magnet Rod'] = CFrame.new(-194.998871, 130.148087, 1930.97107, -0.877933741, 0.200040877, -0.434989601, 0.227177292, 0.973794818, -0.0106849447, 0.421453208, -0.108200423, -0.900372148),
            ['Trident Rod'] = CFrame.new(-1482.91125, -224.787842, -2194.62427, -0.466092706, -0.536795318, 0.703284025, -0.319611132, 0.843386114, 0.43191275, -0.824988723, -0.0234660208, -0.56466186),
            ['Scurvy Rod'] = CFrame.new(-2828.21851, 213.457199, 1512.20959, -0.939700961, -0.341998369, 0, -0.341998369, 0.939700544, 0, -0, 0, -1.00000048),
            ['Phoenix Rod'] = CFrame.new(5970.43066, 272.382538, 852.651123, -0.278261036, 9.0749154e-08, -0.960505486, -4.63434624e-09, 1, 9.58232036e-08, 0.960505486, 3.1115178e-08, -0.278261036),
            ['Stone Rod'] = CFrame.new(5502.14844, 143.803085, -313.94165, 0.300579906, 3.40044498e-05, -0.953756571, 0.952850342, -0.0435936451, 0.30029273, -0.0415675938, -0.999049306, -0.0131357908),
            ['Avalanche Rod'] = CFrame.new(19771.0527, 413.333038, 5418.7085, -0.675413251, -0.3413032, -0.653704584, -0.381730348, 0.920257986, -0.0860654339, 0.630951226, 0.191409111, -0.751840234),
            ['Arctic Rod'] = CFrame.new(19576.127, 132.337082, 5305.94434, -0.321763873, 0.826084375, -0.462658644, -0.820539832, 0.000521302223, 0.571589291, 0.472422183, 0.563546479, 0.677667141),
            ['Summit Rod'] = CFrame.new(20210.1699, 736.058289, 5712.17188, 1.58548355e-05, -0.946918845, 0.321472645, -1, -1.58548355e-05, 2.62260437e-06, 2.62260437e-06, -0.321472645, -0.946918964),
            ['Heavens Rod'] = CFrame.new(20025.5332, -469.021454, 7146.92529, -0.395188451, 0, 0.918600082, 0, 1, 0, -0.918600082, 0, -0.395188451)
        }
        
        -- Get the selected rod location
        local selectedRod = Options[1]
        local teleportCFrame = TeleportRod[selectedRod]

        -- Teleport the player to the selected rod's location
        if teleportCFrame then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleportCFrame
        else
            warn("Invalid location selected!")
        end
    end,
})


local Dropdown = TeleportTab:CreateDropdown({
    Name = "NPC Teleport",
    Options = { "Merlins", "Appraiser", "Map Repairer" },
    CurrentOption = {"Merlins"},
    MultipleOptions = false,
    Flag = "npcteleport", -- A flag is the identifier for the configuration file
    Callback = function(Options)
        -- Define the locations for each NPC
        local TeleportNPC = {
            ['Merlins'] = CFrame.new(-930.576111, 225.750198, -991.506592, -1, 0, 0, 0, 1, 0, 0, 0, -1),
            ['Appraiser'] = CFrame.new(449.26825, 151.351257, 207.361679, 0.080538094, -4.46592185e-09, -0.996751547, -1.28797684e-08, 1, -5.52116886e-09, 0.996751547, 1.32825928e-08, 0.080538094),
            ['Map Repairer'] = CFrame.new(-2830.74805, 215.241745, 1518.34814, -0.15765202, 0.0615119487, -0.985577106, -0.0146553889, 0.997802377, 0.0646192208, 0.987385988, 0.0246313661, -0.156404018)
        }
        
        -- Get the selected NPC location
        local selectedNPC = Options[1]
        local teleportCFrame = TeleportNPC[selectedNPC]

        -- Teleport the player to the selected NPC's location
        if teleportCFrame then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleportCFrame
        else
            warn("Invalid location selected!")
        end
    end,
})




local Section = ShopTab:CreateSection("Merlin")

local Button = ShopTab:CreateButton({
    Name = "Buy Relic",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-930.576111, 225.750198, -991.506592, -1, 0, 0, 0, 1, 0, 0, 0, -1);
        workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("power"):InvokeServer()
        game:service('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
        wait(0.05)
        game:service('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
    end,
})
    
local Button = ShopTab:CreateButton({
    Name = "Buy Luck",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-930.576111, 225.750198, -991.506592, -1, 0, 0, 0, 1, 0, 0, 0, -1);
        game.Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("luck"):InvokeServer()
        game:service('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
        wait(0.05)
        game:service('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
    end,
})




local Section = PlayerTab:CreateSection("Chatacter")

local Slider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 150},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "walkspeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed =(Value)
    end,
 })
 
 
 local Slider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {0, 150},
    Increment = 1,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "jumppower", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.JumpPower =(Value)
    end,
 })

 local Section = PlayerTab:CreateSection("Misc")

-- Infinity Oxygen Water Button
local Button = PlayerTab:CreateButton({
    Name = "Infinity Oxygen Water",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.client.oxygen.Disabled = true
        end)
    end,
})

-- Infinity Oxygen Peak Button
local Button = PlayerTab:CreateButton({
    Name = "Infinity Oxygen Peak",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.client['oxygen(peaks)'].Disabled = true
        end)
    end,
})

-- Infinity Temperature Button
local Button = PlayerTab:CreateButton({
    Name = "Infinity Temperature",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.client['temperature'].Disabled = true
        end)
    end,
})


