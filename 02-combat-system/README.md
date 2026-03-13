# Combat System

Server-authoritative melee combat using spatial hitbox queries. All damage is calculated server-side — no client can fake a hit.

## Features
- `OverlapParams` hitbox in front of the player
- Per-player cooldown enforcement (server-side)
- Knockback via `BodyVelocity` with auto-cleanup
- Hit effects broadcast to all clients
- Debug hitbox visualization (toggle off for production)

## RemoteEvents Required
- `ReplicatedStorage/RemoteEvents/SwingRE` — client fires when swinging
- `ReplicatedStorage/RemoteEvents/HitEffect` — server fires to all clients on hit

## Where to place
`ServerScriptService/CombatSystem`
