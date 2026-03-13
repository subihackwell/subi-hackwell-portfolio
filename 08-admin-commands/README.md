# Admin Commands System

Permission-tiered chat command system. Level 2 = Mod, Level 3 = Owner. Add new commands in one block.

## Built-in Commands
| Command | Level | Usage |
|---------|-------|-------|
| `/kick [player] [reason]` | Mod | Kicks a player |
| `/speed [player] [speed]` | Owner | Sets walk speed |
| `/heal [player]` | Mod | Heals player to max HP |
| `/announce [message]` | Mod | Broadcasts a message |

## Adding a New Command
```lua
commands.yourcommand = {
    level = 2, -- 2 = mod, 3 = owner
    run = function(caller, args)
        -- your logic here
    end
}
```

## Setup
1. Add your UserId to the `ADMINS` table with your permission level
2. Place in `ServerScriptService/AdminSystem`
3. Create `ReplicatedStorage/RemoteEvents/Announce` for announcements
