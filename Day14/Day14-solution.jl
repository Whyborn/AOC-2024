using GLMakie, Statistics

mutable struct Robot
    Position::Vector{Int}
    Velocity::Vector{Int}
end

function move(R, N, Shape)
    # Move robot N times
    R.Position = mod.(R.Position + N * R.Velocity, Shape)
end

function check_quadrant(R, shape)
   left = R.Position[1] < floor(Int, shape[1] / 2)
   top = R.Position[2] < floor(Int, shape[2] / 2)
   right = R.Position[1] > floor(Int, shape[1] / 2)
   bottom = R.Position[2] > floor(Int, shape[2] / 2)
   if left && top
       return 1
   elseif right && top
       return 2
   elseif left && bottom
       return 3
   elseif right && bottom
       return 4
   else
       return 0
   end
end

function robot_from_line(Line)
    splits = split(Line, " ", keepempty=false)
    Pos = parse.(Int, split(splits[1][3:end], ",", keepempty=false))
    Vel = parse.(Int, split(splits[2][3:end], ",", keepempty=false))

    Robot(Pos, Vel)
end

function dist_from_centre(R, shape)
    centre = floor.(Int, shape)
    dist = sum(abs2, R.Position .- centre)
end

function plot_spread(Robots, Shape)
    b = zeros(Bool, reverse(Shape))
    for r in Robots
        px, py = r.Position .+ 1
        b[py, px] = 1
    end
    f, a, s = heatmap(b')
end

begin
    robots = [robot_from_line(Line) for Line in split(read("input.txt", String), "\n", keepempty=false)]
    quadrants = Dict(i => 0 for i = 1:4)
    shape = (101, 103)
    for r in robots
        move(r, 100, shape)
        quad = check_quadrant(r, shape)
        if quad != 0
            quadrants[quad] += 1
        end
    end

    println("Part 1 solution: $(prod(values(quadrants)))")

    # bit ad hoc- check "spread" of robots by average distance from centre    
    robots = [robot_from_line(Line) for Line in split(read("input.txt", String), "\n", keepempty=false)]
    avgdist = Float64[]
    N = 10000
    for _ = 1:N
        dist = 0.0
        for r in robots
            move(r, 1, shape)
            dist += dist_from_centre(r, shape)
        end
        push!(avgdist, dist / length(robots))
    end

    treepos = findmin(avgdist)[2]
    
    println("Part 2 solution: $(treepos)")
    
    # Can plot for check
    robots_at_tree = [robot_from_line(Line) for Line in split(read("input.txt", String), "\n", keepempty=false)]
    [move(r, treepos, shape) for r in robots_at_tree]
    f, a, s = plot_spread(robots_at_tree, shape)
    display(f)
end
