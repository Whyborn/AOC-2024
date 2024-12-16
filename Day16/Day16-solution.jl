# Author: Lachlan Whyborn
# Last Modified: Mon 16 Dec 2024 17:20:01
function TraverseMaze(CurrentPosition, CurrentDirection, ScoreMap, PathTaken, Maze)
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
        
        if NewScore == ScoreMap[NewPosition]
            push!(PathTaken, NewPosition)
        end
    elseif Maze[CurrentPosition + Directions[CurrentDirection]] == 'E'
        NewScore = ScoreMap[CurrentPosition] + 1
        NewPosition = CurrentPosition + Directions[CurrentDirection]
        if !haskey(ScoreMap, NewPosition)
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
            
            if NewScore == ScoreMap[NewPosition]
                push!(PathTaken, NewPosition)
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
