export type ReceiptInfo = {
    PurchaseId: number,
    PlayerId: number,
    ProductId: number,
    PlaceIdWherePurchased: number,
    CurrencySpent: number,
    CurrencyType: number,
    ProductPurchaseChannel: number
}

export type ProductModule = {
    ProductIDs: {},
    InverseIDs: {},
    Callback: (ReceiptInfo) -> boolean,
    Parent: {}
}

export type GlobalCallback = (ReceiptInfo) -> Enum.ProductPurchaseDecision

local Types = {}
return Types