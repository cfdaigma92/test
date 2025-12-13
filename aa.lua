local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GamePlaceId = game.PlaceId

local CHECK_INTERVAL = 1


local SECRETS = {
    "Lavadorito Spinito",
    "Cooki and Milki",
    "Gingerat Gerat",
    "W or L",
    "La Ginger Sekolah",
    "Orcaledon",
    "Gobblino Uniciclino",
    "Fishino Clownino",
    "Fragrama and Chocrama",
    "La Taco Combinasion",
    "Festive 67",
    "Garama and Madundung",
    "Chicleteira Bicicleteira",
    "Mieteteira Bicicleteira",
    "Chicleteirina Bicicleteirina",
    "Chipso and Queso",
    "Fragrama and Chocrama",
    "Los Spaghettis",
    "Los Puggies",
    "La Casa Boo",
    "La Taco Combinasion",
    "Los Primos",
    "Spooky and Pumpky",
    "Headless Horseman",
    "Chipso and Queso",
    "Capitano Moby",
    "Los 67",
    "Dragon Cannelloni",
    "Chillin Chilli",
    "Secret Lucky Block",
    "La Secret Combinasion",
    "Esok Sekolah",
    "La Supreme Combinasion",
    "Spaghetti Tualetti",
    "Chimpanzini Spiderini",
    "Los Mobilis",
    "Los Bros",
    "67",
    "Chillin Chilli",
    "Fragola La La La",
    "La Spooky Grande",
    "Las Sis",
    "Spooky and Pumpky",
    "Los Chicleteiras",
    "Celularcini Viciosini",
    "Ketupat Kepat",
    "Tacorita Bicicleta",
    "Mariachi Corazoni",
    "Money Money Puggy",
    "Tang Tang Keletang",
    "Los Tacoritas",
    "Tictac Sahur",
    "Ketupat Kepat",
    "La Extinct Grande"
}

-- Function to apply highlight and label to the secret object
local function applyHighlightAndLabel(secretObj)
    if secretObj:FindFirstChild("SecretLabel") or secretObj:FindFirstChildWhichIsA("Highlight") then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = secretObj
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = secretObj

    local referencePart = secretObj:FindFirstChild("Head") or secretObj.PrimaryPart
    if not referencePart then
        referencePart = secretObj:FindFirstChildWhichIsA("BasePart")
        if not referencePart then return end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SecretLabel"
    billboard.Adornee = referencePart
    billboard.Size = UDim2.new(0, 250, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.Parent = secretObj

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = "🐾 " .. secretObj.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextScaled = true
    textLabel.Parent = billboard
end

-- Function to detect secrets in workspace
local function detectSecrets()
    local foundAny = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and table.find(SECRETS, obj.Name) then
            print("🐾 Secret Found: " .. obj.Name)
            applyHighlightAndLabel(obj)
            foundAny = true
        end
    end
    return foundAny
end

-- Function to teleport to another server
local function hopServer()
    print("🔄 No secrets found. Hopping servers...")
    TeleportService:Teleport(GamePlaceId)
end

-- Main loop
while true do
    if detectSecrets() then
        break
    else
        task.wait(CHECK_INTERVAL)
        hopServer()
    end
end
