inputfile = joinpath(pwd(),"src","day3","input.txt")

input = read(inputfile, String)

re = r"mul\((\d{1,3}),(\d{1,3})\)"

answer1 = sum([ parse(Int64,n[1]) * parse(Int64,n[2]) for n in eachmatch(re, input) ])

println(answer1)

re2 = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

matches = eachmatch(re2, input)

answer2 = 0
enabled = true

for m in matches
    if m.match == "do()"
        enabled = true
    elseif m.match == "don't()"
        enabled = false
    else
        if enabled
            answer2 += parse(Int64,m[1])*parse(Int64,m[2])
        end
    end
end

println(answer2)
