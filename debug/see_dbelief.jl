using SubHunt
using Base.Test

using POMDPs
using POMDPToolbox
using DiscreteValueIteration
using QMDP
using ParticleFilters
using Plots

pomdp = SubHuntPOMDP()

# show(STDOUT, MIME("text/plain"), SubVis(pomdp))

rng = MersenneTwister(14)
# policy = RandomPolicy(pomdp, rng=rng)

solver = QMDPSolver()
if !isdefined(:policy) || policy.pomdp != pomdp
    policy = solve(solver, pomdp, verbose=true)
end

s = initial_state(pomdp, rng)
@show value(policy, s)
@show value(policy, SubState(s.own, s.target, s.goal, true))

pfp = PingFirst(policy)
# pfp = policy

dpomdp = DSubHuntPOMDP(pomdp, 5.0)
filter = SIRParticleFilter(dpomdp, 100000, rng=rng)

for (s,a,r,sp,o,bp) in stepthrough(dpomdp, pfp, filter, "sarspobp", max_steps=20, rng=rng)
    v = SubVis(pomdp, s=s, a=a, r=r)
    show(STDOUT, MIME("text/plain"), v)
    vp = SubVis(pomdp, s=sp, b=bp)
    plot(vp)
    gui()
    sleep(0.5)
end
