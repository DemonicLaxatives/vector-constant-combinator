local util = require('__core__/lualib/util')
local recipe = util.table.deepcopy(data.raw.recipe['constant-combinator'])

recipe.name = 'vector-constant-combinator'
recipe.results = {
    {type = 'item', name = 'vector-constant-combinator', amount = 1}
}

data:extend{recipe}

local technology = data.raw.technology['circuit-network']
table.insert(technology.effects, {type = 'unlock-recipe', recipe = 'vector-constant-combinator'})