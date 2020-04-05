set Cities;
set Campers;

param distances{Cities, Cities}, >= 0;
param redundancy{Campers, Cities}, >= 0;
param deficiency{Campers, Cities}, >= 0;
param transport_costs{Campers}, >= 0;
param could_replace symbolic in Campers;

# solution of problem
var solution{Cities, Cities, Campers}, integer, >= 0;

minimize cost_func: sum{camp in Campers}(
    sum{c1 in Cities, c2 in Cities}(
        distances[c1, c2] * solution[c1, c2, camp]
    ) * transport_costs[camp]
);

# redundancy requirements
subject to move_all_redundant_campers{c1 in Cities, camp in Campers}: sum{c2 in Cities} solution[c1, c2, camp] == redundancy[camp, c1];

# deficiency requirements
subject to move_more_VIPs_than_deficiency{c1 in Cities}: sum{c2 in Cities} solution[c2, c1, could_replace] >= deficiency[could_replace, c1];
subject to sent_equal_to_deficiency{c1 in Cities}: 
    sum{camp in Campers}(
        sum{c2 in Cities} solution[c2, c1, camp]
    ) == sum{camp in Campers} deficiency[camp, c1];

solve;

for{c1 in Cities} {
    for{c2 in Cities} {
        for{camp in Campers} {
            printf (if solution[c1, c2, camp] != 0 and c1 != c2 then "Move %d %s campers from %s to %s\n" else ""), solution[c1, c2, camp], camp, c1, c2 ;
        }
    }
}

display cost_func;

# data section
data;

set Cities := 'Berlin' 'Bratyslawa' 'Brno' 'Budapeszt' 'Koszyce' 'Lipsk' 'Praga' 'Rostok' 'Gdansk' 'Krakow' 'Szczecin' 'Wroclaw' 'Warszawa';
set Campers := 'Standard' 'VIP';

param distances: Berlin Bratyslawa Brno Budapeszt Koszyce Lipsk Praga Rostok Gdansk Krakow Szczecin Wroclaw Warszawa := 
    Berlin 0 553 433 689 697 149 282 195 403 531 127 295 518
    Bratyslawa 553 0 122 162 313 492 290 748 699 297 615 330 533
    Brno 433 122 0 261 344 384 185 627 591 259 493 215 459
    Budapeszt 689 162 261 0 214 645 443 880 764 293 733 427 545
    Koszyce 697 313 344 214 0 699 516 871 652 177 703 402 391
    Lipsk 149 492 384 645 699 0 203 306 539 552 276 326 603
    Praga 282 290 185 443 516 203 0 474 556 394 373 217 518
    Rostok 195 748 627 880 871 306 474 0 427 698 177 470 629
    Gdansk 403 699 591 764 652 539 556 427 0 486 288 377 284
    Krakow 531 297 259 293 177 552 394 698 486 0 527 236 252
    Szczecin 127 615 493 733 703 276 373 177 288 527 0 309 454
    Wroclaw 295 330 215 427 402 326 217 470 377 236 309 0 301
    Warszawa 518 533 459 545 391 603 518 629 284 252 454 301 0;

param deficiency: Berlin Bratyslawa Brno Budapeszt Koszyce Lipsk Praga Rostok Gdansk Krakow Szczecin Wroclaw Warszawa :=
    Standard 16 4 9 8 4 3 0 2 20 0 0 8 0
    VIP 4 0 0 0 0 0 4 0 0 8 0 0 4;

param redundancy: Berlin Bratyslawa Brno Budapeszt Koszyce Lipsk Praga Rostok Gdansk Krakow Szczecin Wroclaw Warszawa :=
    Standard 0 0 0 0 0 0 10 0 0 10 12 0 14
    VIP 0 8 2 4 4 10 0 4 2 0 4 10 0;

param transport_costs :=
    Standard 1.0
    VIP 1.15;

param could_replace := VIP;

end;