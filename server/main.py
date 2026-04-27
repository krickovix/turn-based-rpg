import random
from typing import List
from fastapi import Query, FastAPI, HTTPException
from data_loader import load_data

app = FastAPI()


@app.get("/run/new")
def new_run():
    data = load_data()

    encounters = []
    for i, monster in enumerate(data["monsters"]):
        monster_with_ind = {**monster}
        monster_with_ind["index"] = i

        encounters.append(monster_with_ind)

    
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
    monster_effects: List[str] = Query(default=[]),
    hero_effects: List[str] = Query(default=[]),
):
    monsters = load_data()["monsters"]
    
    monster = None
    for m in monsters:
        if m["monster_id"] == monster_id:
            monster = m
            break

    if monster is None:
        raise HTTPException(status_code=404, detail="monster not found")
    
    chosen = random.choice(monster["moves"])
    return {"move_id": chosen, "reasoning": "random_pick"}


def parse_effect(raw: str) -> dict:
    stat, modifier, turns = raw.split(":")
    return {"stat": stat, "modifier": int(modifier), "turns_remaining": int(turns)}