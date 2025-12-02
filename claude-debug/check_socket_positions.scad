include <scad/geometry.scad>

echo("=== Socket Positions ===");
echo("");

// Head tube lug TT socket position
echo("Head tube lug TT socket:");
echo("  ht_top_tube:", ht_top_tube);
echo("  Z:", ht_top_tube[2]);
echo("");

// STMJ position in assembly:
// orient_to(bb_seat_tube, st_top)
//     translate([0, 0, seat_tube_length / 2])

// After orient_to, we're at bb_seat_tube, then translate along seat tube
stmj_position = bb_seat_tube + seat_tube_unit * (seat_tube_length / 2);

echo("STMJ base position (at midpoint of seat tube):");
echo("  Position:", stmj_position);
echo("  Z:", stmj_position[2]);
echo("");

// The collar is at stmj_height/2 up from this position
stmj_collar_position = stmj_position + seat_tube_unit * (70 / 2);

echo("STMJ TT collar position:");
echo("  Position:", stmj_collar_position);
echo("  Z:", stmj_collar_position[2]);
echo("");

echo("Height difference:");
echo("  Lug - STMJ:", ht_top_tube[2] - stmj_collar_position[2], "mm");
