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
    graph = [(i, j) for i in M for j in J]

    J_1 = [j for j in J]
    M_1 = [i for i in M]
    F = []

    while length(J_1) > 0
        model = Model(GLPK.Optimizer)

        @variable(model, x[M, J] >= 0)

        @objective(model, Min, sum(costs[i, j] * x[i, j] for (i, j) in graph))

        for j in J
            if in(j, J_1)
                edges = [e for e in graph if e[2] == j]
                @constraint(model, sum(x[i, j_1] for (i, j_1) in edges) == 1)
            end
        end

        for i in M
            if in(i, M_1)
                edges = [e for e in graph if e[1] == i]
                @constraint(model, sum(x[i_1, j] * resources[i_1, j] for (i_1, j) in edges) <= capacities[i])
            end
        end

        optimize!(model)

        solution = value.(x)

        println(termination_status(model))

        filter!(((i, j),) -> solution[i, j] != 0, graph)

        for i in M
            for j in J
                if solution[i, j] - 1.0 <= eps(Float64)
                    push!(F, (i, j))
                    filter!(v -> v != j, J_1)
                    capacities[i] -= resources[i, j]
                end
            end
        end

        for i in M
            deg = length([e for e in graph if e[1] != 1])
            sum = 0

            for j in J
                sum += solution[i, j]
            end

            if deg == 1 || (deg == 2 && sum >= 1)
                filter!(v -> v != i, M_1)
            end
        end
    end
end

function run(path)
    problems = parse_file(path)

    for p in problems
        solve_gap(p)
    end
end

function run_all(dir_path, n)
    for i in 1:n
        problems = parse_file("$dir_path/gap$i.txt")

        for p in problems
            solve_gap(p)
        end
    end
end