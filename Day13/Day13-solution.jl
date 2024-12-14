function solve_game(game, offset=0)
    ButtonA, ButtonB, Prize = [decode_rule(line) for line in split(game, "\n", keepempty=false)]
    Prize = Prize .+ offset
    det = (ButtonA[1] * ButtonB[2] - ButtonA[2] * ButtonB[1])
    Minv = [ButtonB[2] -ButtonB[1]; -ButtonA[2] ButtonA[1]]
    X = [Prize[1]; Prize[2]]
    Minv * X ./ det
end

function decode_rule(Line)
   X, Y = [parse(Int, m.captures[1]) for m in eachmatch(r"\w\W(\d+)", Line)]
   return (X, Y)
end


begin
    inp = split(read("input.txt", String), "\n\n", keepempty=false)
    total = 0
    for game in inp
        A, B = solve_game(game)
        if all(isinteger.([A, B]))
            global total += 3A + B
        end
    end
    
    println("Part 1 solution: $(Int(total))")

    total = 0
    for game in inp
        A, B = solve_game(game, 10000000000000)
        if all(isinteger.([A, B]))
            global total += A + 3B
        end
    end

    println("Part 2 solution: $(Int(total))")
end
