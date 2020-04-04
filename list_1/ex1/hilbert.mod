param n, integer, > 0;

param A{i in {1..n}, j in {1..n}} := 1/(i + j - 1);
param b{i in {1..n}} := sum{j in {1..n}}(1/(i + j -1));
param c{i in {1..n}} := b[i];

printf: "A[i, j]:\n";
for {i in {1..n}} {
    for {j in {1..n}} {
        printf: "%f ", A[i, j];
    }

    printf "\n";
}

printf: "\nb[i]:\n";
for {i in {1..n}} {
    printf: "%f\n", b[i];
}

printf: "\nc[i]:\n";
for {i in {1..n}} {
    printf: "%f\n", c[i];
}

var x{i in {1..n}}, >=0;

minimize cost_func: sum{i in {1..n}} x[i] * c[i];

subject to solved_x{i in {1..n}}: sum{j in {1..n}} x[i] * A[i, j] = b[i];

solve;

printf: "\nsolved_x[i]:\n";
for {i in {1..n}} {
    printf: "%f\n", solved_x[i];
}

printf: "\nerror[i]:\n";
for {i in {1..n}} {
    printf: "%f\n", abs(solved_x[i] - x[i]) / abs(solved_x[i]);
}

data;

param n := 10;

end;