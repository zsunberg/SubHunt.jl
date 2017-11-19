using SubHunt
using Base.Test

using POMDPs
using POMDPToolbox
using DiscreteValueIteration
using ProfileView

pomdp = SubHuntPOMDP(size=10)

# show(STDOUT, MIME("text/plain"), SubVis(pomdp))

rng = MersenneTwister(5)
# policy = RandomPolicy(pomdp, rng=rng)

solver = ValueIterationSolver()

policy = solve(solver, pomdp)
Profile.clear()
@time solve(solver, pomdp)
# @profile solve(solver, pomdp, verbose=true)
# ProfileView.view()

for (s, a, r, sp) in stepthrough(pomdp, policy, "s,a,r,sp", max_steps=200, rng=rng)
    v = SubVis(pomdp, s=s, a=a, r=r)
    show(STDOUT, MIME("text/plain"), v)
end
