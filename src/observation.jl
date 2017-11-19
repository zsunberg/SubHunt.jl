#=
# Active
normal at size except for active beam: normal at true dist

# Passive
normal at detect radius, except if in detect radius: normal in active beam

# beams
angles follow RHR from x,y axis (they start on x and go CCW)

Beam | covers (deg)
-------------------
1    | (0,45]
2    | (45,90]
etc.
=#

struct SubObsDist
    abeam::Int
    an::Normal{Float64}
    n::Normal{Float64}
end

function rand(rng::AbstractRNG, d::SubObsDist)
    o = MVector{8, Float64}()
    for i in 1:length(o)
        if i == d.abeam
            o[i] = rand(rng, d.an)
        else
            o[i] = rand(rng, d.n)
        end
    end
    return SVector(o)
end

function pdf(d::SubObsDist, o::Vec8)
    p = 1.0
    for i in 1:length(o)
        if i == d.abeam
            p *= pdf(d.an, o[i])
        else
            p *= pdf(d.n, o[i])
        end
    end
    return p
end

function active_beam(rel_pos::Pos)
    angle = atan2(rel_pos[2], rel_pos[1])
    while angle <= 0.0
        angle += 2*pi
    end
    bm = ceil(Int, 8*angle/(2*pi))
    return clamp(bm, 1, 8)
end

function observation(p::SubHuntPOMDP, a::Int, sp::SubState)
    rel_pos = sp.target - sp.own
    dist = norm(rel_pos)
    if a == PING
        abeam = active_beam(rel_pos)
        an = Normal(dist, p.active_std)
        n = Normal(p.size, p.active_std)
    else
        if dist <= p.passive_detect_radius
            abeam = active_beam(rel_pos)
            an = Normal(dist, p.passive_detected_std)
        else
            abeam = -1
            an = Normal(p.passive_detect_radius, p.passive_std)
        end
        n = Normal(p.passive_detect_radius, p.passive_std)
    end
    SubObsDist(abeam, an, n)
end
