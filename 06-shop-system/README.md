# Shop System

Server-validated economy. Clients invoke a `RemoteFunction` — the server checks balance, deducts coins, and grants items. No client-side trust.

## Features
- All logic server-side via `RemoteFunction`
- Validates item exists before purchase
- Validates player has enough coins
- Integrates with DataManager for persistent economy
- Returns success/failure + message string to client

## Adding New Items
```lua
local SHOP_ITEMS = {
    YourItem = { price = 200, description = "Does something cool" },
}
```

## RemoteFunctions Required
- `ReplicatedStorage/RemoteFunctions/BuyItem`

## Where to place
`ServerScriptService/ShopSystem`
