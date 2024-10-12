local util = require('__core__/lualib/util')
local entity = util.table.deepcopy(data.raw['constant-combinator']['constant-combinator'])

entity.name = 'vector-constant-combinator'
entity.minable.result = 'vector-constant-combinator'
entity.item_slot_count = 2

for _, orientation in pairs(entity.sprites) do
    orientation.layers[1].filename =            '__ConstantVectorCombinator__/graphics/entity/combinator/vector-constant-combinator.png'
    orientation.layers[1].hr_version.filename = '__ConstantVectorCombinator__/graphics/entity/combinator/hr-vector-constant-combinator.png'
end

entity.corpse = 'vector-constant-combinator-remnants'

data:extend{entity}