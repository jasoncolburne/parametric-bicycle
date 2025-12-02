include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);

echo("=== Goal ===");
echo("Sleeve should point along seat_tube_unit:", seat_tube_unit);
echo("Rotation needed:", rotation_angle, "degrees around Y-axis");
echo("");

// Test the current configuration
collar_current = [rotation_angle, 0, 0];
sleeve_current = [180, 0, -90];
net_current = sleeve_current - collar_current;

echo("=== Current Config ===");
echo("collar_rotation:", collar_current);
echo("sleeve_rotation:", sleeve_current);
echo("Net sleeve rotation:", net_current);
echo("");

// The problem: I can't easily calculate where a rotated vector points in OpenSCAD
// without implementing full rotation matrices

// But I can reason about it:
// After orient_to: local +Z = global tt_unit = [-0.869889, 0, -0.493247]
// We need it to point at global seat_tube_unit = [-0.309017, 0, 0.951057]

// The rotation from tt_unit to seat_tube_unit:
// - Both in XZ plane (Y=0)
// - Rotation around Y-axis by 101.554°

// Current net rotation [78.4458, 0, -90]:
// - 78.4458° around X (wrong axis!)
// - -90° around Z (for sleeve orientation)

// We need rotation around Y, not X!

echo("=== Analysis ===");
echo("Problem: current net rotation has X=78.4458, Y=0");
echo("We need: X=?, Y=101.554, Z=-90");
echo("");
echo("Trying different combinations from the matrix...");
