local util = require('__core__/lualib/util')

local remnants = util.table.deepcopy(data.raw['corpse']['constant-combinator-remnants'])
remnants.name = 'vector-constant-combinator-remnants'

remnants.icon =                             '__ConstantVectorCombinator__/graphics/icons/vector-constant-combinator.png'
remnants.animation[1].filename =               '__ConstantVectorCombinator__/graphics/entity/combinator/remnants/constant/vector-constant-combinator-remnants.png'
remnants.animation[1].hr_version.filename =    '__ConstantVectorCombinator__/graphics/entity/combinator/remnants/constant/hr-vector-constant-combinator-remnants.png'

data:extend{remnants}