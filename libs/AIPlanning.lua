local aiPlanning = {}

-- imports

local constants = require("Constants")
local mathUtils = require("MathUtils")

-- constants

local AI_STATE_PEACEFUL = constants.AI_STATE_PEACEFUL
local AI_STATE_AGGRESSIVE = constants.AI_STATE_AGGRESSIVE

local AI_MAX_POINTS = constants.AI_MAX_POINTS
local AI_POINT_GENERATOR_AMOUNT = constants.AI_POINT_GENERATOR_AMOUNT

local AI_MIN_STATE_DURATION = constants.AI_MIN_STATE_DURATION
local AI_MIN_TEMPERAMENT_DURATION = constants.AI_MIN_TEMPERAMENT_DURATION
local AI_MAX_STATE_DURATION = constants.AI_MAX_STATE_DURATION
local AI_MAX_TEMPERAMENT_DURATION = constants.AI_MAX_TEMPERAMENT_DURATION

-- imported functions

local randomTickEvent = mathUtils.randomTickEvent

local mMax = math.max

-- module code

function aiPlanning.planning(natives, evolution_factor, tick)
    local maxPoints = AI_MAX_POINTS * evolution_factor
    if (natives.points < maxPoints) then
	natives.points = natives.points + math.floor(AI_POINT_GENERATOR_AMOUNT * math.random())
    end
    
    if (natives.temperamentTick == tick) then
	natives.temperament = math.random()
	natives.temperamentTick = randomTickEvent(tick, AI_MIN_TEMPERAMENT_DURATION, AI_MAX_TEMPERAMENT_DURATION)
    end

    if (natives.stateTick == tick) then
	local roll = math.random() * mMax(1 - evolution_factor, 0.15)
	if (roll > natives.temperament) then
	    natives.state = AI_STATE_PEACEFUL
	else
	    natives.state = AI_STATE_AGGRESSIVE
	end
	natives.stateTick = randomTickEvent(tick, AI_MIN_STATE_DURATION, AI_MAX_STATE_DURATION)
    end 
end

return aiPlanning
