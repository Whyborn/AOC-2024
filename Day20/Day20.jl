function Move(Pos, Dir, Track, Score)
    if Track[Pos + Directions[Dir]] != '#'
        Score[Pos + Directions[Dir]] = Score[Pos] + 1
        return Pos + Directions[Dir], Dir
    else
        for Turn in [-1, 1]
            NewDir = mod1(Dir + Turn, 4)
            if Track[Pos + Directions[NewDir]] != '#'
                Score[Pos + Directions[NewDir]] = Score[Pos] + 1
                return Pos + Directions[NewDir], NewDir
                break
            end
        end
    end
end

function first_pass(Track)
    CurrentPos = findfirst(==('S'), Track)
    EndPos = findfirst(==('E'), Track)
    CurrentDir = 0
    for (DirIndex, Dir) in pairs(Directions)
        if Track[CurrentPos + Dir] == '.'
            CurrentDir = DirIndex
        end
    end
    
    Score = Dict(CurrentPos => 0)
    while CurrentPos != EndPos
        CurrentPos, CurrentDir = Move(CurrentPos, CurrentDir, Track, Score)
    end
    Score
end

function check_shortcuts(Times, MaxDist, MinShortcut)
    Counts = Dict()
    for (Position, Time) in @view(Times[1:end-MinShortcut])
        for (TargetPosition, TargetTime) in @view(Times[Time+1:end])
            DistanceBetween = sum(abs.(Tuple(TargetPosition - Position)))
            if DistanceBetween <= MaxDist && (TargetTime - Time - DistanceBetween) >= MinShortcut
                if haskey(Counts, TargetTime - Time - DistanceBetween)
                    Counts[TargetTime - Time - DistanceBetween] += 1
                else
                    Counts[TargetTime - Time - DistanceBetween] = 1
                end
            end
        end
    end
    Counts 
end

begin
    istr = read("input.txt", String)
    Track = stack(collect.(split(istr, "\n", keepempty=false)), dims=1);

    Directions = [CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(-1, 0)]

    Times = first_pass(Track);

    TimesAsArray = sort(collect(Times), by = x -> x[2]);

    Part1 = check_shortcuts(TimesAsArray, 2, 100)

    println("Part 1 solution: $(sum(collect(values(Part1))))")

    Part2 = check_shortcuts(TimesAsArray, 20, 100)

    println("Part 2 solution: $(sum(collect(values(Part2))))")
end
