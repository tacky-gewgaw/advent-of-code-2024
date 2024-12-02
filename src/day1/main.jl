input = readlines("input.txt")

splitInput = map(line -> Tuple(split(line)), input)
fst = map(i -> parse(Int64,i[1]), splitInput)
snd = map(i -> parse(Int64,i[2]), splitInput)

println(sum(map((a,b) -> abs(a-b), sort(fst), sort(snd))))

println(sum(map(n -> n*sum(map(m -> m==n, snd)), fst)))
