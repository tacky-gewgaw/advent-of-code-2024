inputfile = joinpath(pwd(),"src","day7","input.txt")

input = readlines(inputfile)

function parse_equation(eqs::String)
    (x,y) = tuple(split(eqs, ':')...)
    y1 = parse.(Int, split(strip(y),' '))
    return (parse(Int,x), y1)
end

equations = parse_equation.(input)

function conc(x,y)
    xs = string(x)
    ys = string(y)
    res = xs * ys
    return parse(Int,res)
end

function check_inverse(target::Int, eq::Vector{Int}, concat::Bool=false)
    list = Set{Int}(target)

    for x in reverse(eq[2:end])
        newList::Set{Int} = Set{Int}()
        for y in list
            if y-x>=0
                push!(newList,y-x)
            end

            if mod(y,x)==0
                push!(newList,div(y,x))
            end

            if concat && length(string(y)) > length(string(x)) && endswith(string(y),string(x))
                    push!(newList,parse(Int,string(y)[1:end-length(string(x))]))
            end
        end
        list = newList
    end
    return eq[1] in list
end

println(sum(first.(filter(q -> check_inverse(q[1],q[2]),equations))))
println(sum(first.(filter(q -> check_inverse(q[1],q[2],true),equations))))
