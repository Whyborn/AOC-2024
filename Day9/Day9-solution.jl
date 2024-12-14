# Author: Lachlan Whyborn
# Last Modified: Sat 14 Dec 2024 08:33:09 PM AEDT
mutable struct File
   Idx::Int
   Size::Int
end

mutable struct Space
   Size::Int
   Contents::Vector{}
end

begin
    # inp = "2333133121414131402"
    inp = strip(read("input.txt", String))
    
    files = [File(i-1, parse(Int, v)) for (i, v) in enumerate(inp[1:2:end])]
    spaces = [Space(parse(Int, v), []) for v in inp[2:2:end]]

    space_id = 1
    file_id = length(files)
    while space_id <= length(spaces) && file_id > space_id
       if files[file_id].Size > spaces[space_id].Size
           spaces[space_id].Contents = vcat(spaces[space_id].Contents, files[file_id].Idx .* ones(Int, spaces[space_id].Size))
           files[file_id].Size -= spaces[space_id].Size
           spaces[space_id].Size = 0
           global space_id += 1
       elseif files[file_id].Size < spaces[space_id].Size
           spaces[space_id].Contents = vcat(spaces[space_id].Contents, files[file_id].Idx .* ones(Int, files[file_id].Size))
           spaces[space_id].Size -= files[file_id].Size
           files[file_id].Size = 0
           global file_id -= 1
       else
           spaces[space_id].Contents = vcat(spaces[space_id].Contents, files[file_id].Idx .* ones(Int, files[file_id].Size))
           files[file_id].Size = 0
           spaces[space_id].Size = 0
           global file_id -= 1
           global space_id += 1
       end
    end

    # Create the disk
    # Start with file 1 to help indexing (1 more file than spaces)
    Disk = fill(files[1].Idx, files[1].Size)
    for i = 1:length(spaces)
        global Disk = vcat(Disk, spaces[i].Contents)
        global Disk = vcat(Disk, fill(files[i+1].Idx, files[i+1].Size))
    end

    total = sum([v * (i - 1) for (i, v) in enumerate(Disk)])
    println("Part 1 solution: $(total)")

    # Part 2
    files = [File(i-1, parse(Int, v)) for (i, v) in enumerate(inp[1:2:end])]
    spaces = [Space(parse(Int, v), []) for v in inp[2:2:end]]

    for f = length(files):-1:2
        for s = 1:f-1
            if files[f].Size <= spaces[s].Size
                spaces[s].Contents = vcat(spaces[s].Contents, fill(files[f].Idx, files[f].Size))
                spaces[s].Size -= files[f].Size
                spaces[f-1].Size += files[f].Size
                files[f].Size = 0
                break
            end
        end
    end

    # Create the disk
    # Start with file 1 to help indexing (1 more file than spaces)
    Disk = fill(files[1].Idx, files[1].Size)
    for i = 1:length(spaces)
        global Disk = vcat(Disk, spaces[i].Contents)
        global Disk = vcat(Disk, fill(0, spaces[i].Size))
        global Disk = vcat(Disk, fill(files[i+1].Idx, files[i+1].Size))
    end

    total = sum([v * (i - 1) for (i, v) in enumerate(Disk)])
    println("Part 2 solution: $(total)")

            
end
