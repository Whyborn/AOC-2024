# Author: Lachlan Whyborn
# Last Modified: Thu 05 Dec 2024 05:06:00 PM AEDT

function check_correct(rules, page)
    # Check whether the page is valid given the rules
    is_correct = true
    for rule in rules
        if (rule[1] in page) && (rule[2] in page) && (findfirst(x -> x == rule[1], page) > findfirst(x -> x == rule[2], page))
            is_correct = false
            break
        end
    end
    is_correct
end

function fix_order(rules, page)
    # Fix the order of a page given the rules
    for rule in rules
        if (rule[1] in page) && (rule[2] in page)
            pos1 = findfirst(x -> x == rule[1], page)
            pos2 = findfirst(x -> x == rule[2], page)
            if pos1 > pos2
                # Put the second after the first
                insert!(page, pos1+1, rule[2])
                # Remove the original second
                deleteat!(page, pos2)
            end
        end
    end
    page
end

begin
    input = read("input.txt", String)

    rules, pages = split(input, "\n\n")

    rules = [parse.(Int, split(rule, "|")) for rule in split(rules, "\n")]
    pages = [parse.(Int, split(page, ",")) for page in split(pages, "\n")[1:end-1]]

    total = 0
    for page in pages
        if check_correct(rules, page) global total += page[end ÷ 2 + 1] end
    end

    println("Solution for part 1: $total")

    total = 0
    for page in pages
        if !(check_correct(rules, page))
            while !(check_correct(rules, page))
                page = fix_order(rules, page)
            end
            global total += page[end ÷ 2 + 1]
        end
    end

    println("Solution for part 2: $total")
end


