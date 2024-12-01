# Author: Lachlan Whyborn
# Last Modified: Mon 02 Dec 2024 10:11:21 AM AEDT

using Pkg
Pkg.activate("../AdventOfCode")
using CSV

begin
    inp = CSV.File("input.txt", header = false, delim = "   ", types = Int) |> CSV.Tables.matrix

    sorted = sort.(eachslice(inp, dims=2))
    ans = sum(abs.(sorted[1] - sorted[2]))

    println("Solution is $(ans)")
end
