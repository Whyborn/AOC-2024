# Author: Lachlan Whyborn
# Last Modified: Mon 02 Dec 2024 10:29:30 AM AEDT

using Pkg
Pkg.activate("../AdventOfCode")
using CSV

begin
    inp = CSV.File("input.txt", header = false, delim = "   ", types = Int) |> CSV.Tables.matrix

    sorted = sort.(eachslice(inp, dims=2))
    ans = sum(abs.(sorted[1] - sorted[2]))

    println("Solution for part 1 is $(ans)")

    ans = sum([count(x -> x == y, sorted[2]) * y for y = sorted[1]])

    println("Solution for part 2 is $(ans)")
end
