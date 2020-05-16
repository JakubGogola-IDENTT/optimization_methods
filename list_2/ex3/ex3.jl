# Jakub Gogola 236412
# Lista 2, zadanie 3

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

"""
Funkcja oblicza najbardziej optymalne uszeregowanie zadań z zadanego zbioru z zachowaniem ich kolejności na poszczególnych procesorach.

model - referencja do modelu
T - macierz przechowująca informacje o czasie wykonania każdego z zadań na każdym z dostępnych procesorów.
"""
function find_optimal_schedule(model::Model, T::Any)
    # Liczba zadań do wykonania na procesorach.
    m::Int64 = length(T[:, 1])

    # Liczba dostępnych procesorów.
    n::Int64 = length(T[1, :])

    # Suma czasów wykonania wszystkich zadań na każdym z procesorów.
    # Wartośc służąca jako limit dla maksymalnego czasu wykonania wszystkich zadań (nieosiągalna).
    LIMIT = sum(T)


    Order = [(j, i, k) for j in 1:n, i in 1:m, k in 1:m if i < k]

    @variables(model, begin
        # Zmienna decyzyjna S - oznacza moment rozpoczęcia i-tego zadania na j-tym z procesorów.
        S[1:m, 1:n] >= 0

        # Zmienna pomocnicza - definiuje kolejność wykonywania zadań na procesorach.
        O[Order], Bin

        # Zmienna decyzyjna - czas zakończenia ostatniego z zadań.
        last_task_end >= 0
    end)

    # Funkcja celu - minimalizowany jest czas zakończenia ostatniego z zadań.
    @objective(model, Min, last_task_end)

    for i in 1:m 
        for j in 1:n
            if j < n
                # Ograniczenie - zadanie i-te musi zostać rozpoczęte na j+1 procesorze dopiero gdy zostanie wykonane na procesorze j-tym.
                @constraint(model, S[i, j+1] >= S[i, j] + T[i, j])
            end
        end
    end

    # Ograniczenia dla zasobów - na j-tym procesorze w jedynm momencie może być wykonywane tylko jedno zadanie.
    for (j, i, k) in Order
        @constraint(model, S[i, j] - S[k, j] + LIMIT * O[(j, i, k)] >= T[k, j])
        @constraint(model, S[k, j] - S[i, j] + LIMIT * (1 - O[(j, i, k)]) >= T[i, j])
    end

    # Wszystkie zadań muszą zostać zakończone przed zakończeniem ostatniego
    for i in 1:m
        @constraint(model, S[i, n] + T[i, n] <= last_task_end)
    end

    optimize!(model)

    println(termination_status(model))
    println(objective_value(model))

    gantt(to_Float64(S), T, Int64(value(last_task_end)))
end

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    find_optimal_schedule(model, T)
end