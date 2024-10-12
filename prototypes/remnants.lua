local util = require('__core__/lualib/util')
local my_util = require('__vector-constant-combinator__/prototypes/util')

local remnants = util.table.deepcopy(data.raw['corpse']['constant-combinator-remnants'])
remnants.name = 'vector-constant-combinator-remnants'

remnants.icon =                             my_util.rebase_path(remnants.icon)
remnants.animation[1].filename =            my_util.rebase_path(remnants.animation[1].filename)
remnants.animation[1].hr_version.filename = my_util.rebase_path(remnants.animation[1].hr_version.filename)

data:extend{remnants}