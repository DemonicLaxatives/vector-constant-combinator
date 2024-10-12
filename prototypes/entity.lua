local util = require('__core__/lualib/util')
local my_util = require('__vector-constant-combinator__/prototypes/util')
local entity = util.table.deepcopy(data.raw['constant-combinator']['constant-combinator'])

entity.name = 'vector-constant-combinator'
entity.minable.result = 'vector-constant-combinator'
entity.item_slot_count = 2

for _, orientation in pairs(entity.sprites) do
    orientation.layers[1].filename =            my_util.rebase_path(orientation.layers[1].filename)
    orientation.layers[1].hr_version.filename =  my_util.rebase_path(orientation.layers[1].hr_version.filename)
end

entity.corpse = 'vector-constant-combinator-remnants'

data:extend{entity}