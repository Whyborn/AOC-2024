# Author: Lachlan Whyborn
# Last Modified: Tue 03 Dec 2024 04:51:27 PM AEDT

function do_muls(str)
    # Use regex to match all instances of mul([0-9]+,[0-9]+)
    muls = [m for m in eachmatch(r"mul(\([0-9]+,[0-9]+\))", str)]

    count = 0
    for m in muls
        op = m.captures[1]
        asints = parse.(Int, split(op[2:end-1], ","))
        count += prod(asints)
    end
    count
end

begin
    input = read("input.txt", String)

    # Step 1- just read as is
    sol = do_muls(input)

    println("Solution to stage 1: $(sol)")

    # Stage 2- mask all indices between don't() and do()
    active_inds = ones(Bool, length(input))
    for donts in findall("don't()", input)
        # Find the first instance of do() after a don't()
        nextdo = findnext("do()", input, donts[end])

        # mask all the indices between these occurrences
        active_inds[donts[1]:nextdo[end]] .= 0
    end

    newinput = String([input[i] for i in 1:length(input) if active_inds[i]])

    sol = do_muls(newinput)

    println("Solution to stage 2: $(sol)")
end
