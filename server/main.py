import random
from typing import List, Optional
from fastapi import Query, FastAPI, HTTPException
from data_loader import load_data

app = FastAPI()


@app.get("/run/new")
def new_run():
    data = load_data()

    encounters = []
    for i, monster in enumerate(data["monsters"]):
        encounters.append({**monster, "index": i})

    
    return {
        "hero": data["hero"],
        "encounters": encounters,
        "moves": data["moves"],
    }


@app.get("/battle/next-move")
def next_move(
    encounter_index: int,
    monster_id: str,
    monster_hp: int,
    monster_max_hp: int,
    hero_hp: int,
    hero_max_hp: int,
    turn_number: int,
    monster_effects: Optional[List[str]] = Query(default=None),
    hero_effects: Optional[List[str]] = Query(default=None),
):
    monsters = load_data()["monsters"]
    
    monster = None
    for m in monsters:
        if m["monster_id"] == monster_id:
            monster = m
            break
    if monster is None:
        raise HTTPException(status_code=404, detail="monster not found")
    
    _parsed_monster_effects = [parse_effect(effect) for effect in (monster_effects or [])]
    _parsed_hero_effects = [parse_effect(effect) for effect in (hero_effects or [])]

    chosen = random.choice(monster["moves"])
    return {"move_id": chosen, "reasoning": "random_pick"}


def parse_effect(raw: str) -> dict:
    parts = raw.split(":")
    if len(parts) != 3:
        raise HTTPException(status_code=400, detail=f"malformed effect: {raw}")
    stat, base_value, turns = parts
    try:
        return {"stat": stat, "base_value": int(base_value), "turns_remaining": int(turns)}
    except ValueError:
        raise HTTPException(status_code=400, detail=f"non-numeric effect parts: {raw}")
