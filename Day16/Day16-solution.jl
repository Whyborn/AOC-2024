# Author: Lachlan Whyborn
# Last Modified: Mon 16 Dec 2024 08:06:29 PM AEDT

using GLMakie

function TraverseMaze(CurrentPosition, CurrentDirection, ScoreMap, Maze)
    if Maze[CurrentPosition + Directions[CurrentDirection]] == '.'
        NewScore = ScoreMap[CurrentPosition] + 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        if !(haskey(ScoreMap, NewPosition))
            ScoreMap[NewPosition] = NewScore
            TraverseMaze(NewPosition, CurrentDirection, ScoreMap, Maze)
        elseif NewScore < ScoreMap[NewPosition]
            ScoreMap[NewPosition] = NewScore
            TraverseMaze(NewPosition, CurrentDirection, ScoreMap, Maze)
        end
        
    elseif Maze[CurrentPosition + Directions[CurrentDirection]] == 'E'
        NewScore = ScoreMap[CurrentPosition] + 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        if !(haskey(ScoreMap, NewPosition))
            ScoreMap[NewPosition] = NewScore
        elseif NewScore < ScoreMap[NewPosition]
            ScoreMap[NewPosition] = NewScore
        end
    end

    for Turn in [-1, 1]
        NewDirection = mod1(CurrentDirection + Turn, 4)
        if Maze[CurrentPosition + Directions[NewDirection]] == '.'
            NewScore = ScoreMap[CurrentPosition] + 1001
            NewPosition = CurrentPosition + Directions[NewDirection]
            if !(haskey(ScoreMap, NewPosition))
                ScoreMap[NewPosition] = NewScore
                TraverseMaze(NewPosition, NewDirection, ScoreMap, Maze)
            elseif NewScore < ScoreMap[NewPosition]
                ScoreMap[NewPosition] = NewScore
                TraverseMaze(NewPosition, NewDirection, ScoreMap, Maze)
            end
            
        elseif Maze[CurrentPosition + Directions[NewDirection]] == 'E'
            NewScore = ScoreMap[CurrentPosition] + 1001
            NewPosition = CurrentPosition + Directions[NewDirection]
            if !(haskey(ScoreMap, NewPosition))
                ScoreMap[NewPosition] = NewScore
            elseif NewScore < ScoreMap[NewPosition]
                ScoreMap[NewPosition] = NewScore
            end
        end
    end
end

function ReverseWalk(CurrentPosition, CurrentDirection, CurrentScore, Path, ScoreMap, Maze)
    if Maze[CurrentPosition + Directions[CurrentDirection]] == '.'
        NewScore = CurrentScore - 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        if NewScore == ScoreMap[NewPosition] 
            ReverseWalk(NewPosition, CurrentDirection, NewScore, vcat(Path, NewPosition), Maze)
        end

    elseif Maze[CurrentPosition + Directions[CurrentDirection]] == 'S'
        NewScore = ScoreMap[CurrentPosition] - 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        if NewScore == 0
            push!(BestPaths, Path)
        end
    end

    for Turn in [-1, 1]
        NewDirection = mod1(CurrentDirection + Turn, 4)
        if Maze[CurrentPosition + Directions[NewDirection]] == '.'
            NewScore = CurrentScore - 1001
            NewPosition = CurrentPosition + Directions[NewDirection]
            if NewScore == ScoreMap[NewPosition]
                ReverseWalk(NewPosition, CurrentDirection, NewScore, vcat(Path, NewPosition), Maze)
            end
            
        elseif Maze[CurrentPosition + Directions[NewDirection]] == 'S'
            NewScore = CurrentScore - 1001
            NewPosition = CurrentPosition + Directions[NewDirection]
            if NewScore == 0
                push!(BestPaths, Path)
            end
        end
    end
end

function TakeBestPath(CurrentPosition, CurrentDirection, CurrentScore, ScoreMap, Path, Maze)
    if Maze[CurrentPosition + Directions[CurrentDirection]] == '.'
        NewScore = CurrentScore + 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        TakeBestPath(NewPosition, CurrentDirection, NewScore, ScoreMap, vcat(Path, NewPosition), Maze)
        
    elseif Maze[CurrentPosition + Directions[CurrentDirection]] == 'E'
        NewScore = CurrentScore + 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        if NewScore == ScoreMap[NewPosition]
            push!(BestPaths, vcat(Path, NewPosition))
        end
    end

    for Turn in [-1, 1]
        NewDirection = mod1(CurrentDirection + Turn, 4)
        if Maze[CurrentPosition + Directions[NewDirection]] == '.'
            NewScore = CurrentScore + 1001
            NewPosition = CurrentPosition + Directions[NewDirection]
            if !(CurrentScore > ScoreMap[NewPosition])
                TakeBestPath(NewPosition, NewDirection, NewScore, ScoreMap, vcat(Path, NewPosition), Maze)
            end
            
        elseif Maze[CurrentPosition + Directions[NewDirection]] == 'E'
            NewScore = CurrentScore + 1001
            NewPosition = CurrentPosition + Directions[NewDirection]
            if NewScore == ScoreMap[NewPosition]
                push!(BestPaths, vcat(Path, NewPosition))
            end
        end
    end
end

begin
    # istr = "#################
# #...#...#...#..E#
# #.#.#.#.#.#.#.#.#
# #.#.#.#...#...#.#
# #.#.#.#.###.#.#.#
# #...#.#.#.....#.#
# #.#.#.#.#.#####.#
# #.#...#.#.#.....#
# #.#.#####.#.###.#
# #.#.#.......#...#
# #.#.###.#####.###
# #.#.#...#.....#.#
# #.#.#.#####.###.#
# #.#.#.........#.#
# #.#.#.#########.#
# #S#.............#
# #################"
    istr = read("input.txt", String)
    inp = stack(collect.(split(istr, "\n", keepempty=false)), dims=1)

    Directions = [CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(-1, 0)]

    Start = findfirst(==('S'), inp)
    ScoreMap = Dict(Start => 0)
    TraverseMaze(Start, 1, ScoreMap, inp)
    MazeScore = ScoreMap[findfirst(==('E'), inp)]

    println("Part 1 solution: $(MazeScore)")

    BestPaths = []
    TakeBestPath(Start, 1, 0, ScoreMap, [Start], inp)

    Seats = zeros(Bool, size(inp))
    for path in BestPaths
        for point in path
            Seats[point] = 1
        end
    end
    println("Part 2 solution: $(sum(Seats))")
        
end
