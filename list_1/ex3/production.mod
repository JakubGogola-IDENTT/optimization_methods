# raw materials
var mat_1, >= 2000, <= 6000;
var mat_2, >= 3000, <= 5000;
var mat_3, >= 4000, <= 7000;

# products
var prod_A, >= 0;
var qty_A1, >=0;
var qty_A2, >= 0;
var qty_A3, >=0;
var waste_A1, >=0;
var waste_A2, >= 0;
var waste_A3, >= 0;

var prod_B, >= 0;
var qty_B1, >=0;
var qty_B2, >= 0;
var qty_B3, >=0;
var waste_B1, >=0;
var waste_B2, >= 0;
var waste_B3, >= 0;

var prod_C, >= 0;
var qty_C1, >= 0;

var prod_D, >= 0;
var qty_D2, >= 0;

minimize cost_func: 2.1 * mat_1 + 1.6 * mat_2 + 1.0 * mat_3 
    + 0.1 * waste_A1 + 0.1 * waste_A2 + 0.2 * waste_A3 
    + 

# qunatity of used materials
subject to mat_1_quantity: mat_1 == qty_A1 + qty_B1 + qty_C1;
subject to mat_2_quantity: mat_2 == qty_A2 + qty_B2 + qty_D2;
subject to mat_3_quantity: mat_3 == qty_A3 + qty_B3;

# materials limits
subject to min_mat_1: mat_1 >= 2000;
subject to max_mat_1: mat_1 <= 6000;

subject to min_mat_2: mat_2 >= 3000;
subject to max_mat_2: mat_2 <= 5000;

subject to min_mat_3: mat_3 >= 4000;
subject to max_mat_3: mat_3 <= 7000;

# prod A constraints
subject to prod_A_ingredients: prod_A == 0.9 * qty_A1 + 0.8 * qty_A2 + 0.6 * qty_A3;

subject to mat_1_in_prod_A: qty_A1 >= 0.2 * prod_A;
subject to mat_2_in_prod_A: qty_A2 >= 0.4 * prod_A;
subject to mat_3_in_prod_A: qty_A3 <= 0.1 * prod_A;

subject to waste_of_1_from_A: waste_A1 == 0.1 * qty_A1;
subject to waste_of_2_from_A: waste_A2 == 0.2 * qty_A2;
subject to waste_of_3_from_A: waste_A3 == 0.4 * qty_A3;

# prod B constraints
subject to prod_B_ingredients: prod_B == 0.8 * qty_B1 + 0.8 * qty_B2 + 0.5 * qty_B3;

subject to mat_1_in_prod_B: qty_B1 >= 0.1 * prod_B;
subject to mat_3_in_prod_V: qty_B3 <= 0.3 * prod_B;

subject to waste_of_1_from_B: waste_B1 == 0.2 * qty_B1;
subject to waste_of_2_from_B: waste_B2 == 0.2 * qty_B2;
subject to waste_of_3_from_B: waste_B3 == 0.5 * qty_B3;

# prod C constraints
subject to prod_C_ingredients: prod_C == waste_A1 + 0.2 * waste_A2 + 0.4 * waste_A3 + qty_C1;
subject to mat_1_in_prod_C: qty_C1 == 0.3 * prod_C;

# prod D constraints
subject to prod_D_ingredients: prod_D == 0.2 * waste_B1 + 0.2 * waste_B2 + 0.5 * waste_B3 + qty_D2;
subject to mat_2_in_prod_D: qty_D2 == 0.3 * prod_D;

solve;

display cost_func;