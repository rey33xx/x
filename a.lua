-- Define the parent object
local parent = workspace:FindFirstChild("CurrentRoom")

-- Variable to control whether notifications should be sent
local stopNotifications = false

-- Create a ScreenGui and a Frame to display monsters
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 400)  -- Size of the frame
frame.Position = UDim2.new(1, -220, 0, 20)  -- Position on screen
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 1
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Monsters Found:"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextSize = 18
titleLabel.Parent = frame

-- Create a UIListLayout to organize the monster names
local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = frame

-- Function to show monsters in the GUI
local function showMonstersInGui()
    -- Clear any existing monster labels in the frame
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextLabel") and child ~= titleLabel then
            child:Destroy()
        end
    end

    -- Create a table to keep track of monsters that have already been added
    local notifiedMonsters = {}

    if parent then
        -- Loop through each child of CurrentRoom
        for _, child in ipairs(parent:GetChildren()) do
            -- Find the Monsters folder under the child
            local monstersFolder = child:FindFirstChild("Monsters")
            if monstersFolder then
                -- Show the monsters in the folder
                for _, monster in ipairs(monstersFolder:GetChildren()) do
                    if not notifiedMonsters[monster.Name] then
                        -- Create a new TextLabel to display the monster's name
                        local monsterLabel = Instance.new("TextLabel")
                        monsterLabel.Text = monster.Name
                        monsterLabel.Size = UDim2.new(1, 0, 0, 30)
                        monsterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        monsterLabel.BackgroundTransparency = 1
                        monsterLabel.TextSize = 16
                        monsterLabel.Parent = frame
                        notifiedMonsters[monster.Name] = true
                    end
                end
            else
                -- Create a label if no 'Monsters' folder is found under the child
                if not notifiedMonsters[child.Name] then
                    local noMonstersLabel = Instance.new("TextLabel")
                    noMonstersLabel.Text = "No 'Monsters' folder under " .. child.Name
                    noMonstersLabel.Size = UDim2.new(1, 0, 0, 30)
                    noMonstersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    noMonstersLabel.BackgroundTransparency = 1
                    noMonstersLabel.TextSize = 16
                    noMonstersLabel.Parent = frame
                    notifiedMonsters[child.Name] = true
                end
            end
        end
    else
        -- Show an error label if CurrentRoom is not found
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Text = "'CurrentRoom' not found in the workspace!"
        errorLabel.Size = UDim2.new(1, 0, 0, 30)
        errorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        errorLabel.BackgroundTransparency = 1
        errorLabel.TextSize = 16
        errorLabel.Parent = frame
    end
end

-- Function to stop sending notifications
local function stopSendingNotifications()
    stopNotifications = true
    print("Notifications stopped.")
end

-- Function to set up event listeners for changes
local function setupListeners()
    if parent then
        -- Trigger the function initially
        showMonstersInGui()

        -- Listen for changes in the children of CurrentRoom
        parent.ChildAdded:Connect(function()
            if not stopNotifications then
                showMonstersInGui()
            end
        end)

        parent.ChildRemoved:Connect(function()
            if not stopNotifications then
                showMonstersInGui()
            end
        end)

        -- Listen for changes in the descendants (e.g., Monsters folders or their children)
        parent.DescendantAdded:Connect(function()
            if not stopNotifications then
                showMonstersInGui()
            end
        end)

        parent.DescendantRemoving:Connect(function()
            if not stopNotifications then
                showMonstersInGui()
            end
        end)
    else
        print("'CurrentRoom' not found in the workspace!")
    end
end

-- Call the setup function
setupListeners()

-- To stop notifications manually, call `stopSendingNotifications()` from anywhere in your code.
n xcbfdsfg
