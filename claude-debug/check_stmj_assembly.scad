include <scad/geometry.scad>

// How the STMJ is placed in assembly:
// orient_to(ht_top_tube, st_top_tube)
//     translate([0, 0, top_tube_length])
//         seat_tube_mid_junction(...)

// After orient_to, the local +Z axis points from ht_top_tube to st_top_tube
tt_vec = st_top_tube - ht_top_tube;
tt_direction = tt_vec / norm(tt_vec);

echo("=== Assembly Context ===");
echo("ht_top_tube:", ht_top_tube);
echo("st_top_tube:", st_top_tube);
echo("tt_vec:", tt_vec);
echo("tt_direction (should equal tt_unit):", tt_direction);
echo("tt_unit from geometry:", tt_unit);
echo("Match?", norm(tt_direction - tt_unit) < 0.001);

// The seat tube direction at st_top_tube
echo("");
echo("=== Seat Tube at Junction ===");
echo("Seat tube runs from bb_seat_tube to st_top");
echo("bb_seat_tube:", bb_seat_tube);
echo("st_top:", st_top);
echo("seat_tube_unit:", seat_tube_unit);
echo("st_unit:", st_unit);

// At the junction position (st_top_tube), what direction should the sleeve point?
// The sleeve clamps onto the seat tube, which is oriented along seat_tube_unit
// But st_top_tube and st_top are NOT the same point!
echo("");
echo("=== Key Difference ===");
echo("st_top_tube (where STMJ is placed):", st_top_tube);
echo("st_top (top of seat tube):", st_top);
echo("Difference:", st_top_tube - st_top);
echo("Distance:", norm(st_top_tube - st_top));
