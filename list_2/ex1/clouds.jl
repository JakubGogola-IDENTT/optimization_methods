# Jakub Gogola 236412
# Lista 2, zadanie 1

using JuMP
using GLPK

include("./data.jl")

"""
This function finds optimal path between servers to find infomration about all popoulation's characteristics

model - reference to JuMP model
Q - array containing information where informations about each characteristic is stored
T - array containing times required to search every server
"""
function find_optimal_search_path(model::Model, Q::Any, T::Array{Int64})
    m::Int64 = length(Q)
    n::Int64 = length(T)

    # Vector containing information which servers should be searched (solution)
    @variable(model, p[1:n] >= 0)
    
    
    # function to minimalize - time for searched servers should be minimal
    @objective(model, Min, sum(p[j] * T[j] for j in 1:n))

    # constraint - we want to ensure that for each characteristic we used only one server to find it
    @constraint(model, [i in 1:m], sum(Q[i][j] * p[j] for j in 1:n) == 1)

    optimize!(model)

    for (idx, val) in enumerate(p)
        println("Server $idx: $(value(val))")
    end

end

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    find_optimal_search_path(model, Q, T)
end