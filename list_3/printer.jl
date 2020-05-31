function printer(summary)
    n = 0

    for s in summary
        n += 1
        name = s["name"]
        name = replace(name, "data/" => "")
        name = replace(name, ".txt" => "")
        
        jobs = s["jobs"]
        machines = s["machines"]

        println("File - $name")
        println("Problem - c$machines$jobs - $n")
        println("--- Machines: $machines")
        println("--- Jobs: $(jobs)")
        println("--- Iterations: $(s["iterations"])")
        println("--- Progress:")

        progress = s["progress"]

        for (i, p) in pairs(IndexStyle(progress), progress)
            prog_val = Float64(p /jobs) * 100.0
            prog_val = round(prog_val; digits=2)

            println("------ $(i) => $(prog_val)%")
        end

        time = s["time"] * 1000

        println("--- Time: $time ms")

        usages = s["usages"]
        capacities = s["capacities"]

        println("--- Usage:")

        for i in 1:machines
            println("------ Machine $i:")
            
            limit_exceeded = usages[i] > 2 * capacities[i]

            println("--------- Limit exceeded (> 2Ti): $limit_exceeded")

            overload = usages[i] - capacities[i]
            overload_in_percent = Float64(overload / capacities[i]) * 100
            overload_in_percent = round(overload_in_percent; digits=2)

            println("--------- Capacity: $(capacities[i])")
            println("--------- Overload: $(overload > 0 ? overload : 0)")
            println("--------- Difference (%): $(overload_in_percent > 0.0 ? overload_in_percent : 0)%")
        end

        n %= 5

        println()
    end
end