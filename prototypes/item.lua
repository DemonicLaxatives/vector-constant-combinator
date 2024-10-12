local util = require('__core__/lualib/util')
local my_util = require('__vector-constant-combinator__/prototypes/util')

item = util.table.deepcopy(data.raw.item['constant-combinator'])
item.name = 'vector-constant-combinator'
item.place_result = 'vector-constant-combinator'
item.icon = my_util.rebase_path(item.icon)

data:extend{item}