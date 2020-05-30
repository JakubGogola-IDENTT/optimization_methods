include("parser.jl")

using JuMP
using GLPK

function solve_gap(problem_data)
    machines_count, jobs_count, costs, resources, capacities = problem_data

    # Vertices representing jobs.
    J = 1:jobs_count

    # Vertices representing machines.
    M = 1:machines_count

    # Bipartite graph representation.
    graph = []

    for i in M
        for j in J
            push!(graph, (i, j))
        end
    end

    println(graph)

    # J' = [j for j in J]
    # M' = [i for i in M]
    # F = []

    while length(J) > 0
        model = Model(GLPK.Optimizer)

        @variable(model, x[M, J] >= 0)

        @objective(model, Min, sum(costs[i, j] * x[i, j] for (i, j) in graph))

    end
end

function run(path)
    problems = parse_file(path)

    for p in problems
        solve_gap(p)
    end
end

