# Tycoon Dropper & Collector

Attribute-driven resource generation loop. No hardcoding — configure each dropper via Instance Attributes in Studio.

## Dropper Attributes
| Attribute | Type | Description |
|-----------|------|-------------|
| `ItemName` | string | Name of the dropped part |
| `DropRate` | number | Seconds between drops |
| `ItemValue` | number | Coins awarded on collection |

## Features
- Fully data-driven — duplicate droppers without touching code
- Parts auto-expire via `Debris` (no memory leaks)
- Collector uses proximity check, not Touched spam
- Integrates with DataManager for coin rewards

## Setup
1. Create a `DroppedItems` folder in `Workspace`
2. Add a `DropPoint` part inside your Dropper model
3. Add a `Trigger` part inside your Collector model
4. Set attributes on the Dropper model
5. Drop both scripts into their respective models
