# Author: Lachlan Whyborn
# Last Modified: Wed 04 Dec 2024 06:36:35 PM AEDT

begin
    input = stack(collect.(split(read("input.txt", String))), dims=1)

    # Part 1
    total = 0
    for ind in CartesianIndices(input)
        # Set the possible directions, and let try/catch handle invalid bounds
        for idir = -1:1, jdir = -1:1
            # The inds that will make up XMAS
            inds = [CartesianIndex(ind[1] + n*idir, ind[2] + n*jdir) for n = 0:3]
            try
                if String(input[inds]) == "XMAS"
                    global total += 1
                end
            catch
                continue
            end
        end
    end

    println("Part 1 solution: $total")

    # Part 2
    total = 0
    for ind in CartesianIndices(input)
        # Set a line for each part of the X
        line1 = [ind + CartesianIndex(i, j) for (i, j) in zip(-1:1, 1:-1:-1)]
        line2 = [ind + CartesianIndex(i, j) for (i, j) in zip(-1:1, -1:1)]

        try
            X1 = String(input[line1])
            X2 = String(input[line2])
            if (X1 == "MAS" || X1 == "SAM") && (X2 == "MAS" || X2 == "SAM")
                global total += 1
            end
        catch
            continue
        end
    end

    println("Part 2 solution: $total")
end
