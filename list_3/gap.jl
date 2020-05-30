include("parser.jl")

function solve_gap(problem_data)
    machines_count, jobs_count, costs, resources, capacities = problem_data

    
end

function run(path)
    problem_data = parse_file(path)
    solve_gap(problem_data)
end

