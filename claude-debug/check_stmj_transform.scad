include <scad/geometry.scad>

// The STMJ is oriented along top tube (its Z-axis = tt_unit)
// The sleeve needs its Z-axis aligned with seat_tube_unit

// Calculate the angle between tt_unit and seat_tube_unit
rotation_angle = acos(tt_unit * seat_tube_unit);

echo("=== Coordinate System Analysis ===");
echo("After orient_to: STMJ Z-axis aligned with:", tt_unit);
echo("Sleeve needs Z-axis aligned with:", seat_tube_unit);
echo("Angle between them:", rotation_angle);

// Current approach
collar_rotation = [rotation_angle, 0, 0];
sleeve_rotation = [180, 0, -90];
net_rotation = sleeve_rotation - collar_rotation;

echo("");
echo("=== Current Approach ===");
echo("collar_rotation:", collar_rotation);
echo("sleeve_rotation:", sleeve_rotation);
echo("net_rotation:", net_rotation);

// What if we try to rotate directly from tt_unit to seat_tube_unit?
// We need to rotate around the Y-axis (since both vectors are in XZ plane)
// The rotation is in the XZ plane, so we use atan2

echo("");
echo("=== Direct Calculation ===");
echo("tt_unit angle from +Z:", atan2(tt_unit[0], tt_unit[2]));
echo("seat_tube_unit angle from +Z:", atan2(seat_tube_unit[0], seat_tube_unit[2]));
echo("Difference (seat - tt):", atan2(seat_tube_unit[0], seat_tube_unit[2]) - atan2(tt_unit[0], tt_unit[2]));
