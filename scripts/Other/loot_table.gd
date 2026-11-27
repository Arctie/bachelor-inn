extends Resource
class_name LootTable

const MAX_TIER: int = 5

@export var loot: Array[LootDrop] = []
@export var count_weights: Array[float] = [80.0, 15.0, 5.0]
@export var luck_chance: float = 0.15

func roll_loot(chapter: int) -> Array[LootEntry]:
	## Rolls to see how many items are in the chest, then fills the chest
	var out: Array[LootEntry] = []
	if loot.is_empty():
		push_warning("LootTable: loot array is empty.")
		return out
	chapter = clampi(chapter, 1, MAX_TIER)
	var count: int = _pick_index(count_weights) + 1
	var tries: int = 0
	while out.size() < count and tries < 20:
		tries += 1
		var drop: LootDrop = _roll_loot_type(chapter)
		if drop == null:
			break
		if _has(out, drop):
			continue
		var e: LootEntry = LootEntry.new()
		e.type = drop.type
		e.id = drop.id
		out.append(e)
	if out.is_empty():
		var fallback: LootDrop = _fallback_drop(chapter)
		if fallback != null:
			out.append(_make_entry(fallback))
	return out

func _make_entry(drop: LootDrop) -> LootEntry:
	var e: LootEntry = LootEntry.new()
	e.type = drop.type
	e.id = drop.id
	return e

func _fallback_drop(chapter: int) -> LootDrop:
	## Safety net: highest-tier drop at or below the chapter, otherwise the lowest-tier drop.
	var best: LootDrop = null
	for d: LootDrop in loot:
		if d.tier <= chapter and (best == null or d.tier > best.tier):
			best = d
	if best == null:
		for d: LootDrop in loot:
			if best == null or d.tier < best.tier:
				best = d
	return best

func _has(list: Array[LootEntry], drop: LootDrop) -> bool:
	## checks for duplicate loot and blocks the chest from containing the same loot twice
	for e: LootEntry in list:
		if e.type == drop.type and e.id == drop.id:
			return true
	return false

func _calc_item_chance(drop: LootDrop, chapter: int) -> float:
	## Checks to see how likely an item is to spawn as loot
	if drop.tier == chapter:
		return drop.weight
	if drop.tier == chapter +1:
		return drop.weight * luck_chance
	return 0.0

func _roll_loot_type(chapter: int) -> LootDrop:
	var total: float = 0.0
	for d: LootDrop in loot:
		total += _calc_item_chance(d, chapter)
	if total <= 0.0:
		return null
	var r: float = randf()*total
	for d: LootDrop in loot:
		r -= _calc_item_chance(d, chapter)
		if r <= 0.0 and _calc_item_chance(d, chapter) > 0.0:
			return d
	return null

func _pick_index(weights: Array[float]) -> int:
	var total: float = 0.0
	for w: float in weights:
		total += maxf(w, 0.0)
	var r: float = randf() * total
	for i: int in weights.size():
		r -= maxf(weights[i], 0.0)
		if r <= 0.0:
			return i
	return 0
