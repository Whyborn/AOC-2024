# Author: Lachlan Whyborn
# Last Modified: Mon 02 Dec 2024 04:59:13 PM AEDT

function check_line(line)
   is_safe = true
   if (issorted(line)) || (issorted(line, rev=true))
       for i in 1:length(line)-1
           if 1 > abs(line[i+1] - line[i]) || abs(line[i+1] - line[i]) > 3
               is_safe = false
               break
           end
       end
   else
       is_safe = false
   end
   is_safe
end

begin
    data = readlines(open("input.txt"))
    data = [parse.(Int, split(line, " ")) for line in data]

    # Part 1- check lines as they are
    count = 0
    for line in data
        if check_line(line) global count += 1 end
    end
    
    println("Part 1 solution: $(count)")

    # Part 2- brute force by removing 1 element at a time
    count = 0
    for line in data
        if check_line(line)
            global count += 1
        else
            for i = 1:length(line)
                linecopy = deleteat!(deepcopy(line), i)
                if check_line(linecopy)
                    global count += 1
                    break
                end
            end
        end
    end

    println("Part 2 solution: $(count)")
end
