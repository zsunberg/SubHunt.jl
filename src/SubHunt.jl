module SubHunt

# package code goes here

using Random
using Printf
using LinearAlgebra
using Parameters
using StaticArrays
using Distributions
using POMDPs
using POMDPTools
using RecipesBase
using ParticleFilters

export
    SubHuntPOMDP,
    SubState,
    SubVis,

    DSubHuntPOMDP,

    PingFirst

const Vec8 = SVector{8, Float64}
const Pos = SVector{2, Int}

struct SubState
    own::Pos
    target::Pos
    goal::Int
    aware::Bool
end

@with_kw struct SubHuntPOMDP <: POMDP{SubState, Int, Vec8}
    size::Int                       = 20
    ownspeed::Int                   = 3
    kill_radius::Float64            = 2.0
    p_aware_kill::Float64           = 0.6
    passive_detect_radius::Float64  = 3.0
    passive_std::Float64            = 5.0
    passive_detected_std::Float64   = 0.5
    active_std::Float64             = 0.5
    discount::Float64               = 0.99
end

POMDPs.discount(p::SubHuntPOMDP) = p.discount
POMDPs.isterminal(p::SubHuntPOMDP, s::SubState) = s == END_KILL || reached_goal(p, s)

function reached_goal(p::SubHuntPOMDP, s::SubState)
    dir = DIR[s.goal]
    progress = dot(dir, s.target)
    if sum(dir) == 1
        return progress == p.size
    else
        return progress == -1 # -1 is for case when dir is negative
    end
end

function POMDPs.reward(p::SubHuntPOMDP, s::SubState, a::Int, sp::SubState)
    if sp == END_KILL
        return 100.0
    else
        return 0.0
    end
end

include("enums.jl")
include("spaces_and_distributions.jl")
include("transition.jl")
include("observation.jl")

include("discrete.jl")

include("edge_cases.jl")
include("heuristics.jl")
include("visualization.jl")

end # module
