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
local DataController = require(MODULES.DataController)

local Types = require(ROOT.Types)

-- TYPES
export type ReceiptInfo = Types.ReceiptInfo

-- MODULE
local Product = {}
Product.ProductIDs = DeveloperProducts.Cash
Product.InverseIDs = {}

Product.Callback = function(receiptInfo: ReceiptInfo): boolean
    local plr = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not plr then return false end
    
    local data = DataController.GetPlayerData(plr)
    
    local productID = receiptInfo.ProductId
    local amount = Product.InverseIDs[tostring(productID)]
    if not amount then return false end

    amount = tonumber(amount)
    data.Cash += amount
    ProgressControllers.RenderCurrencies(plr)
    
end

return Product