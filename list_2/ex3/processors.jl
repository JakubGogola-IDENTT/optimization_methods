using JuMP
using GLPK

include("data.jl")

function generate_order_matrix(n::Int64)
    O = zeros(Int64, n, n)

    for i in 1:n
        for j in 1:n
            if i < j
                O[i, j] = i
            elseif i > j
                O[i, j] = j
            else 
                O[i, j ] = -1
            end
        end
    end

    return O
end

function find_optimal_schedule(model::Model, T::Any)
    # Number of tasks.
    m::Int64 = length(T[:, 1])

    # Number of processors - 3.
    n::Int64 = length(T[1, :])

    # Upper limit which is sum of all tasks' times
    limit = sum(T)

    Order = [(i, j, k) for j in 1:n, i in 1:m, k in 1:m if i < k]

    @variables(model, begin
        S[1:m, 1:n] >= 0
        O[Order], (binary=true)
        last_task_end >=0
    end)

    @objective(model, Min, last_task_end >= 0)


    optimize!(model)

    println(termination_status(model))

    # O = generate_order_matrix(m)

    # @variables(model, begin
    #     S[1:m, 1:n] >= 0
    #     F[1:m, 1:n] >=0
    #     # O[1:m, 1:m] >= 0
    #     last_task_end >= 0
    # end)
    
    # @objective(model, Min, last_task_end)

    # for j in 1:n
    #     for i in 1:m
    #         @constraint(model, F[i, j] == S[i, j] + T[i, j])
    #     end
    # end

    # for j in 1:n-1
    #     for i in 1:m
    #         @constraint(model, S[i, j+1] >= F[i, j])
    #     end
    # end

    # for i in 1:m
    #     for j in 1:m
    #         if i == j
    #             continue
    #         end

    #         for k in 1:n
    #             @constraint(model, F[i, k] <= S[j, k] + last_task_end * (1 - O[i, j]))
    #             @constraint(model, F[j, k] <= S[i, k] + last_task_end * O[i, j])
    #         end
    #     end
    # end


    # for i in 1:m
    #     for j in 1:n
    #         @constraint(model, F[i, j] <= last_task_end)
    #     end
    # end
end

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    find_optimal_schedule(model, T)
end