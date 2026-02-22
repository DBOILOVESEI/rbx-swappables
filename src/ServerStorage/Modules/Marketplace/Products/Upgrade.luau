local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- INSTANCES
local MAIN = script
local ROOT = MAIN.Parent.Parent

-- MODULES
local SHARED_MODULES = ReplicatedStorage.SharedModules
local DeveloperProducts = require(SHARED_MODULES.DeveloperProducts)

local MODULES = ServerStorage.Modules
local ProgressControllers = require(MODULES.ProgressControllers)

local Types = require(ROOT.Types)

-- TYPES
export type ReceiptInfo = Types.ReceiptInfo

-- MODULE
local Product = {}
Product.ProductIDs = DeveloperProducts.Upgrades
Product.InverseIDs = {}

Product.Callback = function(receiptInfo: ReceiptInfo): boolean
    local plr = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not plr then return false end
    
    local productID = receiptInfo.ProductId
    local upgrade = Product.InverseIDs[tostring(productID)]
    if not upgrade then return false end

    return ProgressControllers.UpgradePlayer(plr, upgrade, false)
end

return Product