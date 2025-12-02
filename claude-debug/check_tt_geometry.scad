include <scad/geometry.scad>

echo("=== Top Tube Geometry Check ===");
echo("");

echo("Top tube runs from ht_top_tube to st_top_tube");
echo("  ht_top_tube:", ht_top_tube);
echo("  st_top_tube:", st_top_tube);
echo("");

echo("Top tube direction (tt_unit):", tt_unit);
echo("Top tube length:", top_tube_length, "mm");
echo("");

// Where should st_top_tube be based on ht_top_tube + top_tube_length * tt_unit?
calculated_st_top_tube = ht_top_tube + top_tube_length * tt_unit;

echo("Calculated st_top_tube position:");
echo("  ht_top_tube + top_tube_length * tt_unit =", calculated_st_top_tube);
echo("");

echo("Actual st_top_tube:", st_top_tube);
echo("Difference:", calculated_st_top_tube - st_top_tube);
echo("Distance:", norm(calculated_st_top_tube - st_top_tube), "mm");
echo("");

// Where is the STMJ actually positioned?
stmj_position = bb_seat_tube + seat_tube_unit * (seat_tube_length / 2);
echo("STMJ positioned at:", stmj_position);
echo("Should be at st_top_tube:", st_top_tube);
echo("Error:", norm(stmj_position - st_top_tube), "mm");
