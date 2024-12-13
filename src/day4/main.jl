inputfile = joinpath(pwd(),"src","day4","input.txt")

input = readlines(inputfile)

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


function search_x(M, n_row, index)
    try
        letter1 = M[n_row,index]
        letter2 = M[n_row,index+2]

        if M[n_row+1,index+1] == 'A'
            letter1p = M[n_row+2,index+2]
            letter2p = M[n_row+2,index]

            return check_opposite(letter1, letter1p) && check_opposite(letter2, letter2p)
        end

        return false
    catch e
        if e isa BoundsError
            return false
        end
    end
end

function check_opposite(a, b)
    if a == 'M'
        return b == 'S'
    elseif a == 'S'
        return b == 'M'
    else
        return false
    end
end

result = 0

for i in axes(m,1)
    row = join(m[i,:])
    for j in eachindex(row)
        char = row[j]
        if char == 'M' || char == 'S'
            result += search_x(m,i,j)
        end
    end
end

println(result)
