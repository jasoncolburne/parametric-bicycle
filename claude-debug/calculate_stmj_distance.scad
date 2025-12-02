include <scad/geometry.scad>

echo("=== Calculate STMJ Distance Along Seat Tube ===");
echo("");

// STMJ should be at st_top_tube
echo("Target position: st_top_tube =", st_top_tube);
echo("Starting from: bb_seat_tube =", bb_seat_tube);
echo("");

// Distance along seat tube
vec_to_target = st_top_tube - bb_seat_tube;
distance_along_st = vec_to_target * seat_tube_unit;

echo("Vector from bb_seat_tube to st_top_tube:", vec_to_target);
echo("Projection onto seat_tube_unit:", distance_along_st, "mm");
echo("");

echo("Current assembly uses: seat_tube_length / 2 =", seat_tube_length / 2);
echo("Should use:", distance_along_st);
echo("Difference:", distance_along_st - seat_tube_length / 2);
