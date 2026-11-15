-- KHUB UNIVERSAL FAST LOADER
local LOADER_SLUG = "khub-n54fih" 
local API_URL = "https://pocket-json-postbox.lovable.app/api/bin/1f6c7140"
local MASTER_KEY = "04310570f2341372b2a62521be2f39c0548cc7c39b5e4c14"
local HttpService = game:GetService("HttpService")

task.spawn(function()
    local headers = {["X-Master-Key"] = MASTER_KEY}
    local function fetchData()
        if syn and syn.request then local res = syn.request({Url = API_URL, Method = "GET", Headers = headers}); if res.StatusCode == 404 then return "404" end; if res.Body then return res.Body end end
        if http_request then local res = http_request({Url = API_URL, Method = "GET", Headers = headers}); if res.StatusCode == 404 then return "404" end; if res.Body then return res.Body end end
        if request then local res = request({Url = API_URL, Method = "GET", Headers = headers}); if res.StatusCode == 404 then return "404" end; if res.Body then return res.Body end end
        local ok, res = pcall(function() return game:HttpGet(API_URL, true, headers) end)
        if ok and res then if string.find(res, "404 Not Found") then return "404" end; return res end
        return nil
    end

    local success, res = pcall(fetchData)
    if not success or not res then warn("[KHUB] Connection Failed.") return end
    if res == "404" then warn("[KHUB] API URL is dead.") return end

    local decoded
    local jsonSuccess = pcall(function() local data = HttpService:JSONDecode(res); if data.record then decoded = data.record else decoded = data end end)
    if not jsonSuccess or not decoded then warn("[KHUB] Invalid JSON.") return end

    local targetLoader = decoded.loaders and decoded.loaders[LOADER_SLUG]
    if not targetLoader then warn("[KHUB] Slug not found: " .. LOADER_SLUG) return end

    local publishedCode = nil
    for _, ver in pairs(targetLoader.versions or {}) do
        if tonumber(ver.version) == tonumber(targetLoader.publishedVersion) then publishedCode = ver.obfuscated break end
    end
    if not publishedCode then warn("[KHUB] Code missing.") return end

    print("[KHUB] Executing: " .. targetLoader.name)
    local func, err = loadstring(publishedCode)
    if func then local execSuccess, execErr = pcall(func); if not execSuccess then warn("[KHUB] Execution Error: " .. tostring(execErr)) end else warn("[KHUB] Compile Error: " .. tostring(err)) end
end)