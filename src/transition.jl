function transition(p::SubHuntPOMDP, s::SubState, a::Int)
    # own always moves ownspeed in desired direction
    if a == PING
        own = s.own
        aware = true
    elseif a == ENGAGE
        own = s.own
        aware = s.aware
    else
        own = clamp(p, s.own + p.ownspeed*DIR[a])
        aware = s.aware
    end

    # target moves 
    t1 = clamp(p, s.target+2*DIR[s.goal])
    sp1 = SubState(own, t1, s.goal, aware)

    t2 = clamp(p, s.target+DIR[s.goal]+DIR[left(s.goal)])
    sp2 = SubState(own, t2, s.goal, aware)

    t3 = clamp(p, s.target+DIR[s.goal]+DIR[right(s.goal)])
    sp3 = SubState(own, t3, s.goal, aware)


    # always return SparseCat{SVec{4,SubState}, SVec{4,Float64}}
    if a == ENGAGE
        if norm(s.target-s.own) <= p.kill_radius
            if s.aware
                states = SVector(END_KILL, sp1, sp2, sp3)
                p_kill = p.p_aware_kill
                leftover = 1.0 - p_kill
                probs = SVector(p_kill, 0.5*leftover, 0.25*leftover, 0.25*leftover)
            else # definite kill
                states = fill(END_KILL, SVector{4, SubState})
                probs = SVector(1.0, 0.0, 0.0, 0.0)
            end
        else
            states = SVector(sp1, sp2, sp3, END_KILL)
            probs = SVector(0.5, 0.25, 0.25, 0.0)
        end
    else
        states = SVector(sp1, sp2, sp3, END_KILL)
        probs = SVector(0.5, 0.25, 0.25, 0.0)
    end

    return SparseCat(states, probs)::SparseCat{SVector{4,SubState}, SVector{4,Float64}}
end

Base.clamp(p::SubHuntPOMDP, x::Pos) = SVector(clamp(x[1], 1, p.size), clamp(x[2], 1, p.size))
left(dir::Int) = mod1(dir-1, 4)
right(dir::Int) = mod1(dir+1, 4)
