rules = []

function add_rule(r::Tuple{Int,Int})
    push!(rules, r)
end

inputfile = joinpath(pwd(),"src","day5","input.txt")

input = split(read(inputfile, String),"\n\n")

parse_rule(s) = tuple(parse.(Int, split(s, '|'))...)

add_rule.(parse_rule.(split(input[1], "\n")))

parse_update(s) = parse.(Int,split(s, ','))

updates = parse_update.(split(input[2], "\n"))

my_sort(u::Vector{Int}) = sort(u,lt=(x,y) -> tuple(x,y) in rules)

check_update(u::Vector{Int}) = u==my_sort(u)

result = sum((u -> u[ceil(Int,length(u)/2)]).(filter(check_update, updates)))

println(result)
