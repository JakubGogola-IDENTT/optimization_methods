# Jakub Gogola 236412
# Lista 2, zadanie 1

using JuMP
using GLPK

include("./data.jl")

"""
Funkcja znajduje optymalną ściężkę pomiędzy poszczególnymi serwerami w celu zminimalizowania czasu potrzebnego na odczyt danych

model - referencja do modelu
Q - macierz zawierająca informacje o rozmieszczeniu informacji o poszczególnych cechach na serwerach
T - tablica zawierająca informacje o czasie potrzebnym na przeszukanie każdego serwera
"""
function find_optimal_search_path(model::Model, Q::Any, T::Array{Int64})
    # Liczba cech.
    m::Int64 = length(Q)

    # Liczba serwerów.
    n::Int64 = length(T)

    # Zmienna s to tabliza zwierająca informacje, które serwery powinny zostać przeszukane (wartości binarne).
    @variable(model, s[1:n], Bin)
    
    # Funkcja celu - minimalizowany jest sumaryczny czas poszukiwania informacji.
    @objective(model, Min, sum(s[j] * T[j] for j in 1:n))

    # Ograniczenie - do odczytu danych dotyczących danej cechy użyto dokładnie jednego serwera.
    @constraint(model, [i in 1:m], sum(Q[i][j] * s[j] for j in 1:n) == 1)

    optimize!(model)

    println(termination_status(model))

    println("Total time: $(objective_value(model))")

    for (idx, val) in enumerate(s)
        println("Server $idx: $(value(val))")
    end

end

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    find_optimal_search_path(model, Q, T)
end