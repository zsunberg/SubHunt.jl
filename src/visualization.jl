struct SubVis
    p::SubHuntPOMDP
    a::Nullable{Any}
    r::Nullable{Any}
    s::Nullable{Any}
    o::Nullable{Any}
    b::Nullable{Any}
end

SubVis(p; s=nothing, a=nothing, o=nothing, b=nothing, r=nothing) = SubVis(p, a, r, s, o, b)
SubVis(p::SubHuntPOMDP, arspobp::Tuple) = SubVis(p, arspobp...)

function Base.show(io::IO, mime::MIME"text/plain", v::SubVis)
    for y in v.p.size:-1:1
        for x in 1:v.p.size
            printed = false
            if !isnull(v.s)
                s = get(v.s)
                if Pos(x,y) == s.target
                    if s.aware
                        print(io, 'A')
                    else
                        print(io, 'U')
                    end
                    printed = true
                elseif Pos(x,y) == s.own
                    if isnull(v.a)
                        print(io, 'O')
                    else
                        print(io, ACT_LETTER[get(v.a)])
                    end
                    printed = true
                end
            end
            if !printed
                print(io, '.')
            end
            print(io, ' ')
        end
        print(io, '\n')
    end
    if !isnull(v.r)
        @printf("Reward: %8.2f\n", get(v.r))
    end
end

@recipe function f(v::SubVis)
    size = v.p.size
    xlim --> (1, size)
    ylim --> (1, size)
    if !isnull(v.b)
        b = get(v.b)
        @assert b isa ParticleCollection
        counts = zeros(size, size)
        allend = true
        for s in particles(b)
            if s != END_KILL
                allend = false
                counts[s.target[1], s.target[2]] += 1
            end
        end
        if !allend
            @series begin
                x = linspace(1, size, 200)
                y = linspace(1, size, 200)
                seriestype := :contour
                fill := :true
                seriescolor --> :Oranges
                x, y, (x,y) -> counts[round(Int,x), round(Int,y)]
            end
        end
    end
    if !isnull(v.s)
        s = get(v.s)
        @series begin
            label := "Sub"
            marker := :circle
            markercolor := :blue
            [s.own[1]], [s.own[2]]
        end
        @series begin
            label := "Target"
            marker := :x
            markerstrokecolor := :blue
            markerstrokewidth := 6
            [s.target[1]], [s.target[2]]
        end
        #=
        dir = DIR[s.goal]
        @series begin
            label := "Target"
            seriestype := :quiver
            quiver := ([dir[1]], [dir[2]])
            [s.target[1]], [s.target[2]]
        end
        =#
    end
end
