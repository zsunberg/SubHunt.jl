using SubHunt
using Test
using Random
using POMDPs
using POMDPPolicies
using POMDPSimulators
using DiscreteValueIteration
using ParticleFilters
using POMDPModelTools
using QMDP

@testset "VI" begin 
    rng = MersenneTwister(6)
    pomdp = SubHuntPOMDP()
    # show(STDOUT, MIME("text/plain"), SubVis(pomdp))

    solver = ValueIterationSolver(verbose=true)
    vipolicy = solve(solver, UnderlyingMDP(pomdp))
    # 
    s = initialstate(pomdp, rng)
    @show value(vipolicy, s)
    @show value(vipolicy, SubState(s.own, s.target, s.goal, true))
end

@testset "QMDP and PF" begin 
    rng = MersenneTwister(6)
    pomdp = SubHuntPOMDP()
    policy = solve(QMDPSolver(verbose=true), pomdp)

    # policy = RandomPolicy(pomdp, rng=rng)
    
    filter = SIRParticleFilter(pomdp, 10000, rng=rng)

    for (s, a, r, sp) in stepthrough(pomdp, policy, filter, "s,a,r,sp", max_steps=200, rng=rng)
        v = SubVis(pomdp, s=s, a=a, r=r)
        show(stdout, MIME("text/plain"), v)
    end
end

@testset "DPOMDP and PF" begin
    rng = MersenneTwister(6)
    dpomdp = DSubHuntPOMDP(SubHuntPOMDP(), 1.0)
    policy = RandomPolicy(dpomdp, rng=rng)
    filter = SIRParticleFilter(dpomdp, 10000, rng=rng)

    for (s, a, r, sp) in stepthrough(dpomdp, policy, filter, "s,a,r,sp", max_steps=200, rng=rng)
        v = SubVis(dpomdp.cp, s=s, a=a, r=r)
        show(stdout, MIME("text/plain"), v)
    end
end

@testset "Visualization" begin
    rng = MersenneTwister(6)
    pomdp = SubHuntPOMDP()
    policy = solve(QMDPSolver(verbose=true), pomdp)

    # policy = RandomPolicy(pomdp, rng=rng)
    
    filter = SIRParticleFilter(pomdp, 10000, rng=rng)

    for step in stepthrough(pomdp, policy, filter, "s,a,r,sp", max_steps=200, rng=rng)
        show(stdout, MIME("text/plain"), render(pomdp, step))
    end
end
