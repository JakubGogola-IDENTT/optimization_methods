using JuMP
using GLPK

include("data.jl")
include("gantt.jl")

function to_Float64(T)
    (m, n) = size(T)

    F = zeros(Float64, m, n)

    for i in 1:m
        for j in 1:n
            F[i, j] = value(T[i, j])
        end
    end

    return F
end

function find_optimal_schedule(model::Model, T::Any)
    # Number of tasks.
    m::Int64 = length(T[:, 1])

    # Number of processors - 3.
    n::Int64 = length(T[1, :])

    # Upper limit which is sum of all tasks' times
    LIMIT = sum(T)

    Order = [(j, i, k) for j in 1:n, i in 1:m, k in 1:m if i < k]

    @variables(model, begin
        S[1:m, 1:n] >= 0
        O[Order], Bin
        last_task_end >= 0
    end)

    @objective(model, Min, last_task_end)

    for i in 1:m 
        for j in 1:n
            if j < n
                @constraint(model, S[i, j+1] >= S[i, j] + T[i, j])
            end
        end
    end

    for (j, i, k) in Order
        @constraint(model, S[i, j] - S[k, j] + LIMIT * O[(j, i, k)] >= T[k, j])
        @constraint(model, S[k, j] - S[i, j] + LIMIT * (1 - O[(j, i, k)]) >= T[i, j])
    end

    for i in 1:m
        @constraint(model, S[i, n] + T[i, n] <= last_task_end)
    end

    optimize!(model)

    gantt(to_Float64(S), T, Int64(value(last_task_end)))
end

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    find_optimal_schedule(model, T)
end