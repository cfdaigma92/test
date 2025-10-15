local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local GamePlaceId = game.PlaceId
local CHECK_INTERVAL = 1

-- List of known server JobIds you've already visited
local visitedServers = {}
local lastServerFile = "VisitedServers.json"

-- Try to load past server list from file (only works in executors / environments that allow writes)
pcall(function()
    if isfile and readfile and isfile(lastServerFile) then
        visitedServers = HttpService:JSONDecode(readfile(lastServerFile))
    end
end)

local function saveVisited()
    pcall(function()
        if writefile then
            writefile(lastServerFile, HttpService:JSONEncode(visitedServers))
        end
    end)
end

-- Fetches public servers via Roblox API
local function findNewServer()
    local cursor = ""
    for _ = 1, 10 do -- Try a few pages
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s",
            GamePlaceId,
            cursor ~= "" and ("&cursor=" .. cursor) or ""
        )

        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if not success then return nil end

        if response and response.data then
            for _, server in ipairs(response.data) do
                if type(server) == "table"
                    and server.id ~= game.JobId
                    and not table.find(visitedServers, server.id)
                    and server.playing < server.maxPlayers then
                    table.insert(visitedServers, server.id)
                    saveVisited()
                    return server.id
                end
            end
        end

        if not response.nextPageCursor then
            break
        else
            cursor = "&cursor=" .. response.nextPageCursor
        end
    end
    return nil
end

local SECRETS = {
    "La Grande Combinasion",
    "Garama and Madundung",
    "Nuclearo Dinossauro",
    "Chicleteira Bicicleteira",
    "Los Combinasionas",
    "Burguro And Fryuro",
    "Los 67",
    "Dragon Cannelloni",
    "Chillin Chilli",
    "Secret Lucky Block",
    "Los Hotspotsitos",
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
    "Tralaledon",
    "La Spooky Grande",
    "Eviledon",
    "Ketchuru and Musturu",
    "Las Sis",
    "Spooky and Pumpky",
    "Los Chicleteiras",
    "Celularcini Viciosini",
    "Tralaledon",
    "Ketupat Kepat",
    "Tacorita Bicicleta",
    "Mariachi Corazoni",
    "Money Money Puggy",
    "Tang Tang Kelentang",
    "Los Tacoritas",
    "Tictac Sahur",
    "Ketupat Kepat",
    "La Extinct Grande",
    "Los Nooo My Hotspotsitos"
}

-- Highlight function (same as before)
local function applyHighlightAndLabel(secretObj)
    if secretObj:FindFirstChild("SecretLabel") or secretObj:FindFirstChildWhichIsA("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = secretObj
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = secretObj

    local referencePart = secretObj:FindFirstChild("Head") or secretObj.PrimaryPart or secretObj:FindFirstChildWhichIsA("BasePart")
    if not referencePart then return end

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

-- Detect secrets
local function detectSecrets()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and table.find(SECRETS, obj.Name) then
            print("🐾 Secret Found: " .. obj.Name)
            applyHighlightAndLabel(obj)
            return true
        end
    end
    return false
end

-- Hop function using server list
local function hopServer()
    print("🔄 No secrets found. Searching for a new server...")
    local newServer = findNewServer()
    if newServer then
        print("✨ Found new server:", newServer)
        TeleportService:TeleportToPlaceInstance(GamePlaceId, newServer)
    else
        warn("⚠️ No new servers found, retrying soon.")
    end
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
