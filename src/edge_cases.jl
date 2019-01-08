function POMDPModelTools.gbmdp_handle_terminal(pomdp::Union{SubHuntPOMDP,DSubHuntPOMDP}, updater::Updater, b::ParticleCollection, s::SubState, a::Int, rng::AbstractRNG)
    @assert isterminal(pomdp, s)
    return ParticleCollection([s,s])
end
