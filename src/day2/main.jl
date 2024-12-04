inputfile = joinpath(pwd(),"src","day2","example.txt")

input = readlines(inputfile)

splitInput = map(line -> map(s -> parse(Int64, s), split(line)), input)

function checkSafe(arr)
    comp = [ x-y for (x,y) in zip(arr[1:end-1], arr[2:end]) ]
    return all(n -> n in [1,2,3], comp) || all(n -> n in [-1,-2,-3], comp)
end

valid = [ x for x in splitInput if checkSafe(x) ]
invalid = [ x for x in splitInput if !checkSafe(x) ]

answer1 = length(valid)
println(answer1)

permutateCut(arr) = [vcat(arr[1:i-1], arr[i+1:end]) for i in eachindex(arr)]

answer2 = sum(map(el -> reduce(|,map(checkSafe,permutateCut(el))),invalid)) + answer1
println(answer2)
