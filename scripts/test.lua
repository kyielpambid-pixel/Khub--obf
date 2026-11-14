-- KHUB UNIVERSAL FAST LOADER
-- Supports PC & Mobile Executors
local LOADER_SLUG = "test" 
local API_URL = "https://pocket-json-postbox.lovable.app/api/bin/22833504"
local MASTER_KEY = "2e25049a9c88458e1fbf6567b6209071abee94a03bbfe5c3"
local HttpService = game:GetService("HttpService")

task.spawn(function()
    local response = nil
    local headers = {["X-Master-Key"] = MASTER_KEY}
    
    local function fetchData()
        if syn and syn.request then
            local res = syn.request({Url = API_URL, Method = "GET", Headers = headers})
            if res.StatusCode == 404 then return "404" end
            if res.Body then return res.Body end
        end
        if http_request then
            local res = http_request({Url = API_URL, Method = "GET", Headers = headers})
            if res.StatusCode == 404 then return "404" end
            if res.Body then return res.Body end
        end
        if request then
            local res = request({Url = API_URL, Method = "GET", Headers = headers})
            if res.StatusCode == 404 then return "404" end
            if res.Body then return res.Body end
        end
        
        local ok, res = pcall(function() return game:HttpGet(API_URL, true, headers) end)
        if ok and res then
            if string.find(res, "404 Not Found") then return "404" end
            return res
        end
        return nil
    end

    local success, res = pcall(fetchData)
    if not success or not res then
        warn("[KHUB] Connection Failed. Executor might not support custom headers.")
        return
    end
    
    if res == "404" then
        warn("[KHUB] API URL is dead (404 Not Found).")
        return
    end

    local decoded
    local jsonSuccess = pcall(function()
        local data = HttpService:JSONDecode(res)
        if data.record then decoded = data.record else decoded = data end
    end)

    if not jsonSuccess or not decoded then 
        warn("[KHUB] Invalid JSON.") 
        return 
    end

    local targetLoader = nil
    for _, loader in pairs(decoded.loaders or {}) do
        if loader.slug == LOADER_SLUG then 
            targetLoader = loader 
            break 
        end
    end

    if not targetLoader then 
        warn("[KHUB] Slug not found: " .. LOADER_SLUG) 
        return 
    end

    local publishedCode = nil
    for _, ver in pairs(targetLoader.versions or {}) do
        if tonumber(ver.version) == tonumber(targetLoader.publishedVersion) then
            publishedCode = ver.obfuscated 
            break
        end
    end

    if not publishedCode then 
        warn("[KHUB] Code missing for version " .. tostring(targetLoader.publishedVersion)) 
        return 
    end

    print("[KHUB] Executing: " .. targetLoader.name .. " (v" .. tostring(targetLoader.publishedVersion) .. ")")
    local func, err = loadstring(publishedCode)
    
    if func then
        local execSuccess, execErr = pcall(func)
        if not execSuccess then 
            warn("[KHUB] Execution Error: " .. tostring(execErr)) 
        end
    else
        warn("[KHUB] Compile Error: " .. tostring(err))
    end
end)