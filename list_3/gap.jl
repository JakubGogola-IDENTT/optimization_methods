# Jakub Gogola 236412
# Lista 3, zadanie 1

using JuMP
using GLPK

include("parser.jl")
include("printer.jl")

function solve_gap(problem_data)
    machines_count, jobs_count, costs, resources, capacities = problem_data

    # Vertices representing jobs.
    J = 1:jobs_count

    # Vertices representing machines.
    M = 1:machines_count

    # Bipartite graph representation (set of edges).
    graph = [(i, j) for i in M for j in J]

    J_1 = [j for j in J]
    M_1 = [i for i in M]
    F = []

    # Iterations counter.
    counter = 0
    progress = []

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

        filter!(((i, j),) -> solution[i, j] != 0, graph)

        for i in M
            for j in J
                if abs(solution[i, j] - 1.0) <= eps(Float64)
                    push!(F, (i, j))
                    filter!(v -> v != j, J_1)
                    capacities[i] -= resources[i, j]
                end
            end
        end

        filter!(M_1) do i
            deg = length([e for e in graph if e[1] == i])
            !(deg == 1 || (deg == 2 && (sum([solution[i, j] for j in J_1]) >= 1)))
        end

        push!(progress, length(F))
        counter += 1
    end

    return (F, counter, progress)
end

function run(path)
    problems = parse_file(path)

    for p in problems
        solve_gap(p)
    end
end

function run_all()
    files = ["data/gap$i.txt" for i in 1:12 ]

    summary = []

    for f in files
        problems = parse_file(f)

        for p in problems
            machines_count, jobs_count, costs, resources, capacities = p

            val, t = @timed solve_gap(deepcopy(p))

            F, iter_count, progress = val

            usages = zeros(Int64, machines_count)

            for i in 1:machines_count
                machine_tasks = [t for t in F if t[1] == i]

                if length(machine_tasks) == 0
                    continue
                end

                machine_usage = sum(resources[t[1], t[2]] for t in machine_tasks)

                usages[i] = machine_usage
            end

            push!(
                summary,
                Dict(
                    "name" => f,
                    "machines" => machines_count,
                    "jobs" => jobs_count,
                    "costs" => costs,
                    "resources" => resources,
                    "capacities" => capacities,
                    "iterations" => iter_count,
                    "progress" => progress,
                    "time" => t,
                    "usages" => usages
                )
            )
        end
    end

    # Metoda printer wyświetla podsumowanie działania algorytmu dla zadanych danych.
    printer(summary)
end

# run_all()