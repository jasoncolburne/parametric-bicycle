include <scad/geometry.scad>
include <scad/lib/helpers.scad>

echo("=== Top Tube Angle ===");
echo("tt_unit (tube direction):", tt_unit);
echo("As Euler angles:", vector_to_euler(tt_unit));
echo("");

echo("=== Head Tube Lug TT Socket Angle ===");
echo("From head_tube_lug.scad:");
echo("  Collar rotation: [-tt_angle, 0, 0]");
echo("  tt_angle:", tt_angle);
echo("  So collar points at angle:", [-tt_angle, 0, 0]);
echo("");

// The collar in head_tube_lug uses [-tt_angle, 0, 0]
// This should point the socket in the correct direction
lug_collar_euler = [-tt_angle, 0, 0];
echo("Lug collar Euler:", lug_collar_euler);
echo("");

echo("=== STMJ TT Socket Angle ===");
rotation_angle = acos(tt_unit * seat_tube_unit);
collar_rotation = [rotation_angle, 0, 0];
echo("From seat_tube_mid_junction.scad:");
echo("  collar_rotation:", collar_rotation);
echo("  rotation_angle:", rotation_angle);
echo("");

echo("=== Comparison ===");
echo("Lug collar X rotation:", -tt_angle);
echo("STMJ collar X rotation:", rotation_angle);
echo("Difference:", rotation_angle - (-tt_angle), "degrees");
echo("");

echo("Do they point in opposite directions (should differ by ~180°)?");
echo("  Sum:", rotation_angle + (-tt_angle));
echo("  Should be close to 0 or 180");
