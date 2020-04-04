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

subject to hilbert_matrix{i in {1..n}}: sum{j in {1..n}} x[i] * A[i, j] = b[i];

solve;

printf: "\nx[i]:\n";
for {i in {1..n}} {
    printf: "%f\n", x[i];
}

data;

param n := 1000;

end;