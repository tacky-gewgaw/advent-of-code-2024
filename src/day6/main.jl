mutable struct State
    visited::Set{Tuple{Int,Int}}
    obstacles::Set{Tuple{Int,Int}}
    position::Tuple{Int,Int}
    direction::Char
    dimensions::Tuple{Int,Int}

    function State(dim, pos, obs=Set(), dir='U')
        new(Set([pos]), obs, pos, dir, dim)
    end
end

rotation_trans = Dict('U' => 'R', 'R' => 'D', 'D' => 'L', 'L' => 'U')
forward_trans= Dict('U' => (0,-1), 'R' => (1,0), 'D' => (0,1), 'L' => (-1,0))
show_guard = Dict('U' => '^', 'R' => '>', 'D' => 'v', 'L' => '<')

function print_state(s::State)
    println()
    for y in 1:s.dimensions[2]
        for x in 1:s.dimensions[1]
            if (x,y) in s.obstacles
                print('#')
            elseif (x,y) == s.position
                print(show_guard[s.direction])
            elseif (x,y) in s.visited
                print('X')
            else
                print('.')
            end

            if x == s.dimensions[1]
                println()
            end
        end
    end
    println()
end

function parse_state(input::Vector{String})
    pos = (0,0)
    obs = Set()
    ymax = length(input)
    xmax = length(input[1])
    
    for y in eachindex(input)
        for x in eachindex(input[y])
            char = input[y][x]
            if char != '.'
                if char == '^'
                    pos = (x,y)
                elseif char == '#'
                    push!(obs,(x,y))
                else
                    println(x,y)
                    throw(ArgumentError("Unknown symbol! $char"))
                end
            end
        end
    end

    return State((xmax,ymax),pos,obs)
end

function step_forward(s::State)
    new_position = s.position .+ forward_trans[s.direction]
    if !(new_position[1] in 1:s.dimensions[1] && new_position[2] in 1:s.dimensions[2])
        throw(BoundsError(new_position, new_position))
    elseif new_position in s.obstacles
        throw(DomainError(new_position, "Obstacle in the way!"))
    else
        s.position = new_position
        push!(s.visited,new_position)
    end
end

function rotate(s::State)
    s.direction = rotation_trans[s.direction]
end

function iterate(s::State)
    try
        step_forward(s)
        return true
    catch e
        if isa(e, DomainError)
            rotate(s)
            return true
        elseif isa(e, BoundsError)
            return false
        else
            throw(e)
            return false
        end
    end
end 

inputfile = joinpath(pwd(),"src","day6","input.txt")

input = readlines(inputfile)

s = parse_state(input)

run = true

print_state(s)

while run
    run = iterate(s)
end

print_state(s)
println(length(s.visited))