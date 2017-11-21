n_states(p::SubHuntPOMDP) = p.size^4*4*2+1

function state_index(p::SubHuntPOMDP, s::SubState)
    if s == END_KILL
        return n_states(p)
    else
        o = s.own
        t = s.target
        return sub2ind((p.size, p.size, p.size, p.size, 4, 2), o[1], o[2], t[1], t[2], s.goal, Int(s.aware)+1)
    end
end

function state_from_index(p::SubHuntPOMDP, s::Int)
    if s == n_states(p)
        return END_KILL
    else
        is = ind2sub((p.size, p.size, p.size, p.size, 4, 2), s)
        o = SVector(is[1], is[2])
        t = SVector(is[3], is[4])
        return SubState(o, t, is[5], is[6]==2)
    end
end

# the state space is represented by the POMDP itself
# rand(rng::AbstractRNG, p::SubHuntPOMDP)

states(p::SubHuntPOMDP) = p
iterator(p::SubHuntPOMDP) = p
Base.start(p::SubHuntPOMDP) = 1
Base.done(p::SubHuntPOMDP, i::Int) = i > n_states(p)
Base.next(p::SubHuntPOMDP, i::Int) = (state_from_index(p, i), i+1)
Base.eltype(p::SubHuntPOMDP) = SubState
Base.length(p::SubHuntPOMDP) = n_states(p)

struct SubHuntInitDist
    p::SubHuntPOMDP
end
initial_state_distribution(p::SubHuntPOMDP) = SubHuntInitDist(p)

function rand(rng::AbstractRNG, d::SubHuntInitDist)
    mid = round(Int, d.p.size/2)
    own = SVector(mid, mid)
    goal = rand(rng, 1:4)
    goal_dir = DIR[goal]
    start = rand(rng, 1:d.p.size)
    if goal_dir[1] == 0
        target = SVector(start, goal_dir[2] > 0 ? 1 : d.p.size)
    else
        target = SVector(goal_dir[1] > 0 ? 1 : d.p.size, start)
    end
    return SubState(own, target, goal, false)
end

sampletype(::Type{SubHuntInitDist}) = SubState

actions(p::SubHuntPOMDP) = 1:6
n_actions(p::SubHuntPOMDP) = 6
