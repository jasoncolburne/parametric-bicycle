include <scad/geometry.scad>
include <scad/lib/helpers.scad>

echo("=== STMJ in Seat Tube Frame ===");
echo("");

echo("After orient_to(bb_seat_tube, st_top):");
echo("  Local +Z = seat_tube_unit:", seat_tube_unit);
echo("");

echo("Collar needs to point along top tube direction:");
echo("  tt_unit:", tt_unit);
echo("");

echo("Rotation needed:");
echo("  From seat_tube_unit to tt_unit");
echo("  Angle:", acos(seat_tube_unit * tt_unit), "degrees");
echo("");

echo("As Euler angles:");
echo("  vector_to_euler(tt_unit):", vector_to_euler(tt_unit));
echo("  vector_to_euler(seat_tube_unit):", vector_to_euler(seat_tube_unit));
echo("  Difference:", vector_to_euler(tt_unit) - vector_to_euler(seat_tube_unit));
echo("");

echo("=== Correct Collar Rotation ===");
rotation_correct = vector_to_euler(tt_unit) - vector_to_euler(seat_tube_unit);
echo("collar_rotation should be:", rotation_correct);
