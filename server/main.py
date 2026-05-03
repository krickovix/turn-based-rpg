import random
from typing import List, Optional
from fastapi import Query, FastAPI, HTTPException
from data_loader import load_data
from bot import choose_move

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
    
    data = load_data()
    monsters = data["monsters"]
    moves = data["moves"]
    
    monster = None
    for m in monsters:
        if m["monster_id"] == monster_id:
            monster = m
            break
    if monster is None:
        raise HTTPException(status_code=404, detail="monster not found")
    
    parsed_monster_effects = [parse_effect(effect) for effect in (monster_effects or [])]
    parsed_hero_effects = [parse_effect(effect) for effect in (hero_effects or [])]

    move_id, reasoning = choose_move(
        monster,
        monster_hp, monster_max_hp,
        hero_hp, hero_max_hp,
        parsed_monster_effects, parsed_hero_effects,
        moves, turn_number,
    )

    return {"move_id": move_id, "reasoning": reasoning}

def parse_effect(raw: str) -> dict:
    parts = raw.split(":")
    if len(parts) != 4:
        raise HTTPException(status_code=400, detail=f"malformed effect: {raw}")
    stat, type_str, base_value, turns = parts
    try:
        return {
            "stat": stat,
            "type": type_str,
            "base_value": int(base_value),
            "turns_remaining": int(turns),
        }
    except ValueError:
        raise HTTPException(status_code=400, detail=f"non-numeric effect parts: {raw}")
