struct PingFirst{P<:Policy} <: Policy
    p::P
end

function POMDPs.action(p::PingFirst, b::AbstractParticleBelief)
    if first(particles(b)).aware
        return action(p.p, b)
    else
        return PING
    end
end
