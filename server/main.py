from fastapi import FastAPI

app = FastAPI()

@app.get("/run/new")
def new_run():
    return {"message": "TODO: return run config"}

@app.get("/battle/next-move")
def next_move():
    return {"move_id": "slash"}