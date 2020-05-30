function parse_line(line)
    parsed_line = convert(String, lstrip(line))
    parsed_line = split(parsed_line, ' ')
    return map(v -> parse(Int, v), parsed_line)
end

function get_data_from_file(path)
    data = []

    open(path) do file
        for line in eachline(file)
            push!(data, parse_line(line))
        end
    end

    return data
end

function parse_file(path)
    data = get_data_from_file(path)
    
    problems_count = data[1][1]
    deleteat!(data, 1)

    idx = 1
    problem_idx = 1

    problems_set = []

    while idx <= length(data)
        machines_count = data[idx][1]
        jobs_count = data[idx][2]

        idx += 1
        costs = []
        for i in idx:(idx + machines_count - 1)
            tmp = deepcopy(data[i])

            while length(data[i + 1]) !== jobs_count && length(tmp) < jobs_count
                append!(tmp, data[i + 1])
                deleteat!(data, i + 1)
            end
            push!(costs, tmp) 
        end

        idx += machines_count - 1
        resources = []
        for i in idx:(idx + machines_count - 1)
            tmp = deepcopy(data[i])

            while length(data[i + 1]) != jobs_count && length(tmp) < jobs_count
                append!(tmp, data[i + 1])
                deleteat!(data, i + 1)
            end

            push!(resources, tmp)
        end

        idx += machines_count
        capacities = data[idx + 1]

        idx += 2

        push!(problems_set, (machines_count, jobs_count, costs, resources, capacities))

        problem_idx += 1
    end

    return problems_set
end
