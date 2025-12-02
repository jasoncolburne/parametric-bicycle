include <scad/geometry.scad>
include <scad/lib/helpers.scad>

echo("=== New STMJ Approach ===");
echo("");

rotation_angle_new = acos(seat_tube_unit * -tt_unit);
echo("rotation_angle = acos(seat_tube_unit * -tt_unit)");
echo("  seat_tube_unit:", seat_tube_unit);
echo("  -tt_unit:", -tt_unit);
echo("  rotation_angle:", rotation_angle_new);
echo("");

echo("collar_rotation = [0, rotation_angle, 0] = [0,", rotation_angle_new, ", 0]");
echo("");

echo("=== What Direction Should Collar Point? ===");
echo("Collar should point at -tt_unit:", -tt_unit);
echo("As Euler angles:", vector_to_euler(-tt_unit));
echo("");

echo("After orient_to, local +Z = tt_unit");
echo("To point collar at -tt_unit from local +Z:");
echo("  Need 180° flip around X or Y");
echo("  vector_to_euler(-tt_unit) - vector_to_euler(tt_unit) =");
echo("  ", vector_to_euler(-tt_unit), " - ", vector_to_euler(tt_unit));
echo("  = ", vector_to_euler(-tt_unit) - vector_to_euler(tt_unit));
echo("");

echo("Current collar_rotation: [0,", rotation_angle_new, ", 0]");
echo("This rotates around Y-axis, which is wrong!");
