-- KHUB Key System Generated
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local LOVABLE_URL = "https://pocket-json-postbox.lovable.app/api/bin/1f6c7140"
local LOVABLE_KEY = "04310570f2341372b2a62521be2f39c0548cc7c39b5e4c14"
local GET_KEY_URL = "https://your-netlify-site.netlify.app/"
local SAVE_FILE = "khub_key.txt"

local function getIdentifier() return "roblox-user-" .. tostring(LocalPlayer.UserId) end
local function fetchLovableDB()
    local headers = {["X-Master-Key"] = LOVABLE_KEY}
    if syn and syn.request then local res = syn.request({Url = LOVABLE_URL, Method = "GET", Headers = headers}); return true, res.Body end
    if request then local res = request({Url = LOVABLE_URL, Method = "GET", Headers = headers}); return true, res.Body end
    local ok, res = pcall(function() return game:HttpGet(LOVABLE_URL, true, headers) end)
    return ok, res
end

local function validateKey(key)
    key = tostring(key or ""):match("^%s*(.-)%s*$")
    if not key:match("^khub%-%w%w%w%w%-%w%w%w%w$") then return false, { message = "Invalid format" } end
    local success, response = fetchLovableDB()
    if not success or not response then return false, { message = "Server error" } end
    local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
    if not ok or not data then return false, { message = "Invalid JSON" } end
    local db = data.record or data
    local record = db.keys and db.keys[key]
    if not record then return false, { message = "Key not found" } end
    if record.revoked or record.disabled then return false, { message = "Key disabled" } end
    if os.time() * 1000 >= record.expiresAt then return false, { message = "Key expired" } end
    return true, { message = "Granted" }
end

local function onSuccess() 
    print("[KHUB] Access granted")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kyielpambid-pixel/Khub--obf/main/scripts/sct_z5r3uh.lua"))()
end

-- UI CODE (Simplified)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KHUBKeySystem"
ScreenGui.Parent = game:GetService("CoreGui")
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(410, 330)
Main.Position = UDim2.new(0.5, -205, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "KHUB ACCESS"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 48)
KeyBox.Position = UDim2.new(0, 20, 0, 80)
KeyBox.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderText = "khub-XXXX-XXXX"
KeyBox.Parent = Main
local Verify = Instance.new("TextButton")
Verify.Size = UDim2.new(1, -40, 0, 46)
Verify.Position = UDim2.new(0, 20, 0, 150)
Verify.BackgroundColor3 = Color3.fromRGB(120, 83, 242)
Verify.Text = "Verify Key"
Verify.TextColor3 = Color3.new(1,1,1)
Verify.Parent = Main
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 20, 0, 210)
Status.Text = "Waiting for key"
Status.TextColor3 = Color3.fromRGB(121, 128, 148)
Status.BackgroundTransparency = 1
Status.Parent = Main
Verify.MouseButton1Click:Connect(function()
    Status.Text = "Checking..."
    local valid, data = validateKey(KeyBox.Text)
    if valid then
        Status.Text = "Access Granted"
        Status.TextColor3 = Color3.new(0,1,0)
        task.wait(0.5)
        ScreenGui:Destroy()
        onSuccess()
    else
        Status.Text = data.message
        Status.TextColor3 = Color3.new(1,0,0)
    end
end)
