using Base.Threads
using Dates

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

initial_position = s.position

run = true

while run
    global run = iterate(s)
end

println("End state:")
print_state(s)

obstacle_candidates = collect(delete!(copy(s.visited),initial_position))

num_threads = nthreads()
results = zeros(Int, num_threads)
println("Kicking it off in $num_threads threads")
start_time = Dates.now()

Threads.@threads for pos in obstacle_candidates
    # Get the current thread's ID
    thread_id = threadid()
    # println("Thread $thread_id is picking up $pos")

    # initialize!
    run = true
    it = 0
    
    s1 = parse_state(input)
    push!(s1.obstacles,pos)
    saved = copy(s1.visited)

    while run
        it += 1

        run = iterate(s1)

        # every 100 cycles
        if it % 100 == 0
            # check whether the set of visited positions has changed
            if length(saved) == length(s1.visited)
                # if not, we're looping!
                results[thread_id] += 1
                run = false
            else
                # otherwise, save and continue
                saved = copy(s1.visited)
            end
        end
    end
end

successes = sum(results)
println(successes)
running_time = Dates.now() - start_time
println("Simulation took $running_time")
