using Dates

inputfile = joinpath(pwd(),"src","day7","input.txt")

input = readlines(inputfile)

function parse_equation(eqs::String)
    (x,y) = tuple(split(eqs, ':')...)
    y1 = parse.(Int, split(strip(y),' '))
    return (parse(Int,x), y1)
end

equations = parse_equation.(input)

function check_equation(e::Tuple{Int,Vector{Int}})
    if e[2] == []
        println("1")
        return false
    end

    (x, tail) = Iterators.peel(e[2])
    rest = collect(tail)

    if x > e[1]
        return false
    end

    if rest == []
        return x == e[1]
    else
        (y, tail) = Iterators.peel(rest)
        return check_equation((e[1],vcat([x+y],collect(tail)))) | check_equation((e[1],vcat([x*y],collect(tail))))
    end



end

start_time = Dates.now()

println(sum(first.(filter(check_equation,equations))))

running_time = Dates.now() - start_time
println("Calculation took $running_time")