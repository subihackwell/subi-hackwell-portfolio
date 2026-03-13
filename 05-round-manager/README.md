# Round Manager

Full game loop architecture: Lobby → Countdown → Round → Results.

## Flow
```
Wait for MIN_PLAYERS → Countdown → Teleport to map → Round timer → Results → Loop
```

## Features
- Waits for minimum player count before starting
- Live countdown broadcast to all clients
- Teleports players to map/lobby spawns
- Configurable: min players, lobby wait, round duration, results duration
- Loops automatically — no manual restart needed

## RemoteEvents Required
- `ReplicatedStorage/RemoteEvents/UpdateStatus` — fires string status to all clients

## Workspace Required
- `workspace.MapSpawn` — Part where players spawn during round
- `workspace.LobbySpawn` — Part where players return after round

## Where to place
`ServerScriptService/RoundManager`
