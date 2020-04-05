# Jakub Gogola 236412
# Lista 1, zadanie 1

param n, integer, > 0;

param A{i in {1..n}, j in {1..n}} := 1/(i + j - 1);
param b{i in {1..n}} := sum{j in {1..n}}(1/(i + j -1));
param c{i in {1..n}} := b[i];

var x{i in {1..n}}, >=0;

minimize cost_func: sum{i in {1..n}} x[i] * c[i];

subject to solution{i in {1..n}}: sum{j in {1..n}} x[i] * A[i, j] = b[i];

solve;

printf: "\solution[i]:\n";
for {i in {1..n}} {
    printf: "%f\n", solution[i];
}

printf "error %.20f\n",
    sqrt(
        sum{i in {1..n}} ((x[i] - solution[i]) * (x[i] - solution[i]))
    ) 
    /
    sqrt(
        sum{i in {1..n}} x[i] * x[i]
    );
# data section
data;

param n := 10;

end;