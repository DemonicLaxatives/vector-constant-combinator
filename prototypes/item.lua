local util = require('__core__/lualib/util')

item = util.table.deepcopy(data.raw.item['constant-combinator'])
item.name = 'vector-constant-combinator'
item.place_result = 'vector-constant-combinator'
item.icon = '__ConstantVectorCombinator__/graphics/icons/vector-constant-combinator.png'

data:extend{item}