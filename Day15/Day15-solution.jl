function attempt_move_2(Position, Move, Room)
    CanMove = true
    if Room[Position + Move] == '#'
        CanMove = false
    elseif Room[Position + Move] == '.'
        CanMove = true
    elseif Room[Position + Move] == '['
        # Seperate handling for each horizontal direction
        if Move == CartesianIndex(1, 0) || Move == CartesianIndex(-1, 0)
            CanMove = (attempt_move_2(Position + Move, Move, Room) && attempt_move_2(Position + Move + CartesianIndex(0, 1), Move, Room))
        else
            CanMove = attempt_move_2(Position + Move, Move, Room)
        end
    elseif Room[Position + Move] == ']'
        if Move == CartesianIndex(1, 0) || Move == CartesianIndex(-1, 0)
            CanMove = (attempt_move_2(Position + Move + CartesianIndex(0, -1), Move, Room) && attempt_move_2(Position + Move, Move, Room))
        else
            CanMove = attempt_move_2(Position + Move, Move, Room)
        end
    end

    if CanMove
        Room[Position + Move] = Room[Position]
        Room[Position] = '.'
    end
    CanMove
end

function compute_GPS(room, char)
    boxes = findall(x -> x == char, room)
    total = 0
    for i in boxes
       total += (i[1] - 1) * 100 + (i[2] - 1)
    end
    total
end

function attempt_move_1(Position, Move, Room)
    CanMove = true
    if Room[Position + Move] == '#'
        CanMove = false
    elseif Room[Position + Move] == '.'
        CanMove = true
    elseif Room[Position + Move] == 'O'
        CanMove = attempt_move_1(Position + Move, Move, Room)
    end

    if CanMove
        Room[Position + Move] = Room[Position]
        Room[Position] = '.'
    end
    CanMove
end

begin
    # inp = "##########
# #..O..O.O#
# #......O.#
# #.OO..O.O#
# #..O@..O.#
# #O#..O...#
# #O..O..O.#
# #.OO.O.OO#
# #....O...#
# ##########

# <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
# vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
# ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
# <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
# ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
# ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
# >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
# <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
# ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
# v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"

    inp = read("input.txt", String)
    _room, _moves = split(inp, "\n\n", keepempty=false)
    dirmap = Dict('^' => CartesianIndex(-1, 0), '>' => CartesianIndex(0, 1), 'v' => CartesianIndex(1, 0), '<' => CartesianIndex(0, -1))
    moves = [dirmap[d] for d in collect(join(split(_moves, "\n", keepempty=false)))]

    room_1 = stack([[c for c in collect(line)] for line in split(_room, "\n", keepempty=false)], dims=1)
    for move in moves
        curr_pos = findfirst(x -> x == '@', room_1)
        attempt_move_1(curr_pos, move, room_1)
    end

    println("Part 1 solution: $(compute_GPS(room_1, 'O'))")

    obsmap_2 = Dict('#' => "##", 'O' => "[]", '.' => "..", '@' => "@.")
    room = stack([join([obsmap_2[c] for c in collect(line)]) for line in split(_room, "\n", keepempty=false)], dims=1)

    for move in moves
       curr_pos = findfirst(x -> x=='@', room)
       room_temp = deepcopy(room)
       if attempt_move_2(curr_pos, move, room_temp)
           global room = room_temp
       end
   end

   println("Part 2 solution: $(compute_GPS(room, '['))")
end
