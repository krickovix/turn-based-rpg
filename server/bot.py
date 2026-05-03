import random
from typing import List, Optional

LOW_HP_RATIO = 0.3
CRITICAL_HP_RATIO = 0.20
HERO_KILLABLE_HP = 0.30

def choose_move(monster: dict, monster_hp: int, monster_max_hp: int,
                hero_hp: int, hero_max_hp: int,
                monster_effects: List[dict], hero_effects: List[dict],
                all_moves: dict, turn_number: int) -> tuple[str, str]:
  
    monster_hp_ratio = monster_hp / monster_max_hp
    hero_hp_ratio = hero_hp / hero_max_hp

    print(monster_effects)
    print(hero_effects)
    
    scored = []
    for move_id in monster["moves"]:
        move = all_moves[move_id]
        score, reason = _score_move(
            move,
            monster_hp_ratio, hero_hp_ratio)
        scored.append((score, move_id, reason))
    
    scored.sort(key=lambda x: x[0], reverse=True)
    
    best_score, best_id, best_reason = scored[0]
    return best_id, best_reason


def _score_move(move: dict,
                monster_hp_ratio: float, hero_hp_ratio: float) -> tuple[float, str]:
    
    score = 1.0 
    reasons = []
    
    for effect in move["effects"]:
        effect_type = effect["type"]
        
        if effect_type == "heal":
            if monster_hp_ratio < CRITICAL_HP_RATIO:
                score += 10.0
                reasons.append("critical hp, heal urgent")
            elif monster_hp_ratio < LOW_HP_RATIO:
                score += 5.0
                reasons.append("low hp, heal valuable")
            elif monster_hp_ratio > 0.9:
                score -= 3.0
                reasons.append("near full hp, heal wasted")
            else:
                reasons.append("heal neutral")
        
        elif effect_type == "damage":
            base = effect["base_value"]
            if hero_hp_ratio < HERO_KILLABLE_HP and base >= 25:
                score += 6.0
                reasons.append("hero low, finisher prioritized")
            else:
                score += 1.0
                reasons.append(f"damage {base}")
        
        else:
            score += 10
            reasons.append(f"{effect_type} {effect['stat']}")
    
    reason_str = "; ".join(reasons) if reasons else "default"
    return score, reason_str