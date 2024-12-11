inputfile = joinpath(pwd(),"src","day4","input.txt")

input = readlines(inputfile)
# input = ["ABCD", "BBAC", "CDAB", "DABC"]

count_occ(v) = count("XMAS",join(v)) + count("SAMX",join(v))

m = [ input[i][j] for i in eachindex(input), j in eachindex(input[1]) ]

total = 0

for i in axes(m,2)
    total += count_occ(m[i,:])
    total += count_occ(m[:,i])
end

for i in 1-size(m,1):size(m,1)
    this_array = []
    t = i
    for j in axes(m,1)
        if t in axes(m,1)
            push!(this_array,m[t,j])
        end
        t += 1
    end
    total += count_occ(this_array)

    that_array = []
    u = i
    for k in Iterators.reverse(axes(m,1))
        if u in axes(m,1)
            push!(that_array,m[u,k])
        end
        u += 1
    end
    total += count_occ(that_array)
end

println(total)
