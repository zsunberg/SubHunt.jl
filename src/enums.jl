const DIR = [SVector( 0, 1), # north
             SVector( 1, 0), # east
             SVector( 0,-1), # south
             SVector(-1, 0)] # west

const PING = 5
const ENGAGE = 6

const ACT_LETTER = ['N', 'E', 'S', 'W', 'P', 'G']

const END_KILL = SubState([-1,-1], [-1,-1], -1, false)

# values for aware
# const ISLEFT = 1
# const ISRIGHT = 2


# """
# Return direction index from `from` to `to`
# """
# function dirto(from::Pos, to::Pos)
#     
# end
# 
# function leftright(from::Pos, dir::Int, to::Pos)
# 
# end
# =#
