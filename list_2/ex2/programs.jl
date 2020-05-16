# Jakub Gogola 236412
# Lista 2, zadanie 2

using JuMP
using GLPK

include("./data.jl")

function find_optimal_programs(model::Model, R::Any, T::Any)
    # number of functions
    m::Int64 = length(R[:, 1])

    # number of programs
    n::Int64 = length(R[1, :])

    @variable(model, P[1:m, 1:n] >= 0)

    @objective(model, Min, sum(T[i, j] * P[i, j] for i in 1:m, j in 1:n))

    @constraint(model, sum(R[i, j] * P[i, j] for i in 1:m, j in 1:n) <= M)

    for i in 1:m
        @constraint(model, sum(P[i, j] for j in 1:n) == 1)
    end


    println(model)

    optimize!(model)

    println(termination_status(model))

   for i in 1:m
        for j in 1:n
            print("$(value(P[i, j])) ")
        end
        println()
   end

end

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    find_optimal_programs(model, R, T)
end 