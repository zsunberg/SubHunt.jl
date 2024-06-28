const IVec8 = SVector{8, Int}

struct DSubHuntPOMDP <: POMDP{SubState, Int, IVec8}
    cp::SubHuntPOMDP
    binsize::Float64
end

struct DSubObsDist
    cd::SubObsDist
    binsize::Float64
end

Base.rand(rng::AbstractRNG, d::DSubObsDist) = floor.(Int, (rand(rng, d.cd)./d.binsize)::Vec8)::IVec8

function Distributions.pdf(d::DSubObsDist, o::IVec8)
    p = 1.0
    cd = d.cd
    for i in 1:length(o)
        lo = d.binsize * o[i] 
        hi = lo + d.binsize
        if i == cd.abeam
            p *= cdf(cd.an, hi) - cdf(cd.an, lo)
        else
            p *= cdf(cd.n, hi) - cdf(cd.n, lo)
        end
    end
    return p
end

POMDPs.observation(p::DSubHuntPOMDP, a::Int, sp::SubState) = DSubObsDist(observation(p.cp, a, sp), p.binsize)
n_states(p::DSubHuntPOMDP) = n_states(p.cp)
POMDPs.stateindex(p::DSubHuntPOMDP, s::SubState) = stateindex(p.cp, s)
POMDPs.states(p::DSubHuntPOMDP) = states(p.cp)
POMDPs.initialstate(p::DSubHuntPOMDP) = initialstate(p.cp)
POMDPs.actions(p::DSubHuntPOMDP) = actions(p.cp)
POMDPs.actionindex(p::DSubHuntPOMDP, i::Int) = actionindex(p.cp, i)
n_actions(p::DSubHuntPOMDP) = n_actions(p.cp)
POMDPs.transition(p::DSubHuntPOMDP, s::SubState, a::Int) = transition(p.cp, s, a)
POMDPs.discount(p::DSubHuntPOMDP) = discount(p.cp)
POMDPs.isterminal(p::DSubHuntPOMDP, s::SubState) = isterminal(p.cp, s)
POMDPs.reward(p::DSubHuntPOMDP, s::SubState, a::Int, sp::SubState) = reward(p.cp, s, a, sp)
