function take_step(Position, Direction, StepMap, Domain)
    for Dir = -1:1
        Step = Directions[mod1(Direction + Dir, 4)]
        NewPosition = Position + Step
        if checkbounds(Bool, Domain, NewPosition) && Domain[NewPosition]
            if !(haskey(StepMap, NewPosition))
                StepMap[NewPosition] = StepMap[Position] + 1
                take_step(NewPosition, mod1(Direction + Dir, 4), StepMap, Domain)
            elseif (StepMap[Position] + 1) < StepMap[NewPosition]
                StepMap[NewPosition] = StepMap[Position] + 1
                take_step(NewPosition, mod1(Direction + Dir, 4), StepMap, Domain)
            end
        end
    end
end

function check_possible(ByteLocs, N)
    Domain = ones(Bool, (71, 71))
    place_bytes(Domain, ByteLocs, N)
    Start = CartesianIndex(1, 1)
    StepMap = Dict(CartesianIndex(1, 1) => 0)
    take_step(Start, 1, StepMap, Domain)
    return haskey(StepMap, CartesianIndex(71, 71))
end

function place_bytes(Domain, Bytes, N)
    for Loc in Bytes[1:N]
        Domain[Loc] = 0
    end
end

begin
    inp = read("input.txt", String)

    ByteLocs = [CartesianIndex(Tuple(parse.(Int, split(line, ",", keepempty=false)) .+ 1)) for line in split(inp, "\n", keepempty=false)]

    Directions = [CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(-1, 0)]
    Domain = ones(Bool, (71, 71))
    place_bytes(Domain, ByteLocs, 1024)

    Start = CartesianIndex(1, 1)
    StepMap = Dict(Start => 0)
    take_step(Start, 1, StepMap, Domain)

    println("Part 1 solution: $(StepMap[CartesianIndex(71, 71)])")

    Ne = length(ByteLocs)
    Ns = 1

    while (Ne - Ns) > 1
        if check_possible(ByteLocs, Ne) ⊻ check_possible(ByteLocs, (Ne + Ns) ÷ 2)
            global Ns = (Ne + Ns) ÷ 2
        else
            global Ne = (Ne + Ns) ÷ 2
        end
    end

    println("Part 2 solution: $((Tuple(ByteLocs[Ne]) .- 1))")
end
