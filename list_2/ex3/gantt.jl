# Jakub Gogola 236412
# Lista 2, zadanie 3


function get_finish_time(T, duration)
    # Number of tasks.
    m::Int64 = length(T[:, 1])
    # Number of processors - 3.
    n::Int64 = length(T[1, :])

    F = zeros(Int64, m, n)

    for i in 1:m
        for j in 1:n
            F[i, j] = T[i, j] + duration[i, j]
        end
    end

    return F
end

function map_tasks_to_symbols(T)
    M = []

    for i in 1:length(T)
        push!(M, (Int64(T[i]), i))
    end

    return sort(M, by = first)
end

function gantt(T, duration, last_time)
    # Number of tasks.
    m::Int64 = length(T[:, 1])
    # Number of processors - 3.
    n::Int64 = length(T[1, :])

    F = get_finish_time(T, duration)

    for j in 1:n
        P_start = map_tasks_to_symbols(T[:, j])
        P_finish = map_tasks_to_symbols(F[:, j])

        last_task_end = last(P_finish)[1]

        for i in 1:P_start[1][1]
            print(" = ")
        end

        for i in 1:m
            for k in P_start[i][1]:P_finish[i][1]-1
                print(" $(P_start[i][2]) ")
            end

            if P_finish[i][1] != last_task_end
                empty = P_start[i + 1][1] - P_finish[i][1]
                for i in 1:empty
                    print(" = ")
                end
            end
        end

        for i in last(P_finish)[1]:last_time-1
            print(" = ")
        end

        println()
    end
end

