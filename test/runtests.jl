using SubHunt
using Base.Test

using POMDPs
using POMDPToolbox
using DiscreteValueIteration
using QMDP
using ParticleFilters

pomdp = SubHuntPOMDP()

# show(STDOUT, MIME("text/plain"), SubVis(pomdp))

rng = MersenneTwister(6)
policy = RandomPolicy(pomdp, rng=rng)

# solver = QMDPSolver()
# policy = solve(solver, pomdp, verbose=true)
# 
# s = initial_state(pomdp, rng)
# @show value(policy, s)
# @show value(policy, SubState(s.own, s.target, s.goal, true))

filter = SIRParticleFilter(pomdp, 10000, rng=rng)

for (s, a, r, sp) in stepthrough(pomdp, policy, filter, "s,a,r,sp", max_steps=200, rng=rng)
    v = SubVis(pomdp, s=s, a=a, r=r)
    show(STDOUT, MIME("text/plain"), v)
end

dpomdp = DSubHuntPOMDP(SubHuntPOMDP(), 1.0)

policy = RandomPolicy(dpomdp, rng=rng)
filter = SIRParticleFilter(dpomdp, 10000, rng=rng)

for (s, a, r, sp) in stepthrough(dpomdp, policy, filter, "s,a,r,sp", max_steps=200, rng=rng)
    v = SubVis(dpomdp.cp, s=s, a=a, r=r)
    show(STDOUT, MIME("text/plain"), v)
end
