# Fantasy RPG for Nordeus Full Stack Challenge 2026

A turn-based RPG built as a full-stack challenge submission. The hero fights through a gauntlet of 5 monsters, learns a new move from each defeated enemy, and levels up between battles. The client handles presentation; the server owns combat logic and bot decisions so a Game Designer could rebalance the game without a client rebuild.

## Live demo

- **Browser-playable:** https://krickovix.itch.io/fantasy-rpg
- **Server:** https://turn-based-rpg.onrender.com (free tier, so the first request may take ~30s if idle)

> Note: the browser build depends on the deployed server. If the server is sleeping, the menu's "Play" button may take up to a minute the first time. Subsequent requests are fast.

## Tech stack

| Layer | Tech | Why |
|---|---|---|
| Client | Godot 4.5, GDScript | Familiar engine, fast iteration on 2D UIs, exports cleanly to web and desktop |
| Server | Python 3, FastAPI | Two GET endpoints in ~50 lines, JSON configs reload on restart, auto-generated `/docs` |
| Hosting | Render (free tier) | Auto-deploys from GitHub on push |
| Data | JSON files (`hero.json`, `monsters.json`, `moves.json`) | Game Designer can edit values and restart the server — no client rebuild |

## Architecture

The server is **stateless**: every `/battle/next-move` request includes the full battle state (HPs, active effects, turn number). This keeps the deployment simple (no DB, no sessions) and makes battle logic trivial to test in isolation.

## Game systems

**Stats:** Health, Attack, Defense, Magic. Physical damage scales with Attack and is reduced by Defense; Magic damage scales with Magic and ignores Defense. Healing scales with Magic.

**Moves:** Each move has one or more effects (damage, heal, buff, debuff). Multi-effect moves like Drain Life (damage + heal) and Web Throw (damage + debuff) compose naturally because effects are first-class.

**Progression:** Each defeated monster awards XP and a random move from its kit. The player can equip 4 moves at a time and swap freely between battles.

**Bot logic** (`server/bot.py`): Each available move is scored against the current battle state. Heals score higher when low HP; damage moves score higher as finishers when the hero is killable. The chosen move is returned with a `reasoning` string for transparency. Tunable thresholds at the top of the file (`LOW_HP_RATIO`, `HERO_KILLABLE_HP`, etc.) let a Designer rebalance bot behavior without code changes.

## Running locally

The repo is configured by default to use the **deployed Render server**. To run everything locally instead:

### 1. Server

```bash
cd server
pip install -r requirements.txt
uvicorn main:app --reload
```

Server runs on `http://127.0.0.1:8000`. Visit `http://127.0.0.1:8000/docs` for interactive Swagger UI.

### 2. Client

1. Open the Godot 4.5 project in Godot
2. Open `api_client.gd` and change:
```gdscript
   const SERVER_URL = "https://turn-based-rpg.onrender.com"
```
   to:
```gdscript
   const SERVER_URL = "http://127.0.0.1:8000"
```
3. Press F5 to play

### Or: skip the local server entirely

If you don't want to run the Python server locally, just open the project in Godot and press F5: the default `SERVER_URL` points to the deployed Render instance and works out of the box (with a possible 30s cold-start on the first request).

## Completed bonus features

From the Game Designer's backlog:

- **Move descriptions on hover**: custom tooltips with stat icons, damage formulas, and color-coded effects
- **Battle log**: running list of moves played, with hero entries on the left and monster entries on the right
- **Smarter bot**: scoring-based with situational reasoning, exposed via the `reasoning` field on each response
- **Battle animations**: hit shakes, color flashes, floating combat text
- **Music & ambience**: separate map and battle themes

## Known limitations

- **Render free-tier cold start.** First request after ~15 minutes idle takes 30–60 seconds while the service spins up.
- **Movie-grade balancing.** Combat is balanced for the intended play pattern (level up by replaying earlier encounters before tackling later ones).

## Project structure
```
├── client/                Godot 4.5 project
│   ├── api_client.gd      HTTP layer
│   ├── battle/            Battle scene & combat resolution
│   ├── fighter/           Fighter, Player, FighterUI, animations
│   ├── moveset_manager/   Move equip/swap UI
│   ├── map/               Run map with progression
│   ├── main_menu/
│   ├── components/        Reusable UI (tooltip, panels, buttons)
│   ├── autoloads/            Sprites, fonts, audio
│   └── assets/            Sprites, fonts, audio
├── server/                FastAPI server
│   ├── main.py            Endpoints
│   ├── bot.py             Move-scoring bot behavior
│   ├── data_loader.py
│   └── data/              JSON configs (moves, monsters, hero)
└── README.md
```
