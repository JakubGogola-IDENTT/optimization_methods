# Jakub Gogola 236412
# Lista 2, zadanie 2

using JuMP
using GLPK

include("./data.jl")

"""
Funkcja znajduje optymalny dobór podprogramów składających się na program P w celu obliczenia zadanego zbioru funkcji.

model - referencja do modelu
R - macierz zawierająca informacje o wymaganiach pamięciowych dla poszczególnych programów
T - macierz zawierająca informacje o wymaganiach czasowych dla poszczególnych programów
"""
function find_optimal_programs(model::Model, R::Any, T::Any)
    # Liczba funkcji.
    m::Int64 = length(R[:, 1])

    # Liczba programów.
    n::Int64 = length(R[1, :])

    # Macierz P przechowuje informacje (binarne) o programach, które powinny zostać wykorzystane do obliczenia poszczególnych funkcji.
    @variable(model, P[1:m, 1:n], Bin)

    # Funkcja celu = minimalizowany jest sumaryczny czas działania użytych podprogramów.
    @objective(model, Min, sum(T[i, j] * P[i, j] for i in 1:m, j in 1:n))

    # Ograniczenie - liczba zaalokowanych komórek pamięci nie może przekroczyć zadanego limitu (M).
    @constraint(model, sum(R[i, j] * P[i, j] for i in 1:m, j in 1:n) <= M)

    # Ograniczenie - do obliczenia każdej spośród m funkcji musi zostać użyty tylko jeden podprogram.
    for i in 1:m
        @constraint(model, sum(P[i, j] for j in 1:n) == 1)
    end

    optimize!(model)

    println(termination_status(model))

    println(objective_value(model))

   for i in 1:m
        print("F$(i): ")
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