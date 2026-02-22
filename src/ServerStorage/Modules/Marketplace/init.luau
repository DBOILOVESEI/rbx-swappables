-- NAMING RULES
-- 1. Don't need anymore. (.module suffix for main) 
-- 2. All modules must have first letter capitalised
-- 3. All keys must have first letter uncapitalised
-- 4. Config keys but have "_" as first character
-- 5. All types and enums must have first letter capitalised

-- SERVICES
local mps = game:GetService("MarketplaceService")

-- MODULES
local Types = require(script.Types)

-- INSTANCES
local products = script.Products

-- TYPES
export type ProductModule = Types.ProductModule
export type ReceiptInfo = Types.ReceiptInfo
export type GlobalCallback = Types.GlobalCallback

local Processed = Enum.ProductPurchaseDecision.PurchaseGranted
local NotProcessed = Enum.ProductPurchaseDecision.NotProcessedYet

-- MODULE
local Marketplace = {}
Marketplace.Products = {}

for _, product in products:GetChildren() do
    local Product: ProductModule = require(product)
    local productIDs = Product.ProductIDs
    
    Product.Parent = products

    for productName, productID in productIDs do
		Marketplace.Products[tostring(productID)] = Product
		Product.InverseIDs[tostring(productID)] = productName
    end
end

mps.ProcessReceipt = function(receiptInfo: ReceiptInfo): GlobalCallback
    local productID = receiptInfo.ProductId
    if not productID then return NotProcessed end

    local Product: ProductModule = Marketplace.Products[tostring(productID)]
    if not Product then return NotProcessed end

    local callback = Product.Callback
    if not callback then return NotProcessed end

    local callbackSuccessful = callback(receiptInfo)
    if callbackSuccessful == true then return Processed end

    return NotProcessed
end

return Marketplace