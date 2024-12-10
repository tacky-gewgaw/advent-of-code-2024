inputfile = joinpath(pwd(),"src","day3","input.txt")

input = readlines(inputfile)

re = r"mul\((\d{1,3}),(\d{1,3})\)"

answer1 = sum([ sum([ parse(Int64,n[1]) * parse(Int64,n[2]) for n in eachmatch(re, line) ]) for line in input ])

print(answer1)
