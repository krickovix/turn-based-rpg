import json
from pathlib import Path

DATA_PATH = Path(__file__).parent / "data"


def load_data():
    with open(DATA_PATH / "moves.json") as f:
        moves = json.load(f)
    with open(DATA_PATH / "monsters.json") as f:
        monsters = json.load(f)
    with open(DATA_PATH / "hero.json") as f:
        hero = json.load(f)

    return {"moves": moves, "monsters": monsters, "hero": hero}