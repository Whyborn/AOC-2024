function count_combinations(Pattern, Towels, TargetPattern, Store)
    if Pattern == TargetPattern
        return 1
    else
        Total = 0
        for Towel in Towels
            NewPattern = Pattern * Towel
            L = length(NewPattern)
            if L <= length(TargetPattern) && NewPattern == @view(TargetPattern[1:L])
                if haskey(Store, NewPattern)
                    Total += Store[NewPattern]
                else
                    Total += count_combinations(NewPattern, Towels, TargetPattern, Store)
                end
            end
        end
    end
    Store[Pattern] = Total
    return Total
end

begin
    istr = read("input.txt", String)
    inp = split(istr, "\n\n", keepempty=false)
    Towels = [String(Towel) for Towel in split(inp[1], ", ", keepempty=false)]
    Patterns = [String(Pattern) for Pattern in split(inp[2], "\n", keepempty=false)];

    NumberCombinations = Dict(Pattern => count_combinations("", Towels, Pattern, Dict()) for Pattern in Patterns)

    println("Part 1 solution: $(count(!=(0), values(NumberCombinations)))")

    println("Part 2 solution: $(sum(values(NumberCombinations)))")
end
