include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);

echo("=== Angle Analysis ===");
echo("rotation_angle (tt to seat tube):", rotation_angle);
echo("seat_tube_angle (from horizontal):", seat_tube_angle);
echo("180 - seat_tube_angle:", 180 - seat_tube_angle);
echo("");

// Head tube lug uses: rotate([180+dt_angle, 0, 90])
// where dt_angle is angle between head tube and down tube

// For STMJ: the component is oriented along top tube
// It needs to align with seat tube
// The angle between them is rotation_angle

// Possible approaches:
echo("=== Possible Rotations ===");
echo("Current: [180, 0, -90] - [rotation_angle, 0, 0] =", [180, 0, -90] - [rotation_angle, 0, 0]);
echo("Like HTL: [180 + rotation_angle, 0, -90] =", [180 + rotation_angle, 0, -90]);
echo("Alternative 1: [rotation_angle, 0, -90] =", [rotation_angle, 0, -90]);
echo("Alternative 2: [-rotation_angle, 0, -90] =", [-rotation_angle, 0, -90]);
echo("Alternative 3: [180 - rotation_angle, 0, -90] =", [180 - rotation_angle, 0, -90]);
