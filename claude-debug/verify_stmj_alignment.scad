include <scad/geometry.scad>
include <scad/lib/helpers.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);

// Current configuration
collar_rotation = [rotation_angle, 0, 0];
sleeve_rotation = [180, 0, -90];
net_sleeve_rotation = sleeve_rotation - collar_rotation;

echo("=== Current Configuration ===");
echo("collar_rotation:", collar_rotation);
echo("sleeve_rotation:", sleeve_rotation);
echo("Net sleeve rotation:", net_sleeve_rotation);
echo("");

// Where the sleeve SHOULD point
echo("=== Target ===");
echo("Sleeve should align with seat_tube_unit:", seat_tube_unit);
echo("As Euler angles:", vector_to_euler(seat_tube_unit));
echo("");

// Where the sleeve CURRENTLY points (after orient_to)
echo("=== Current State ===");
echo("After orient_to, sleeve points along tt_unit:", tt_unit);
echo("As Euler angles:", vector_to_euler(tt_unit));
echo("");

// The rotation needed to go from current to target
needed_rotation = vector_to_euler(seat_tube_unit) - vector_to_euler(tt_unit);
echo("=== Required Rotation ===");
echo("Rotation needed (target - current):", needed_rotation);
echo("Net sleeve rotation (actual):", net_sleeve_rotation);
echo("");

echo("=== Comparison ===");
echo("Do they match?");
echo("  X component: needed=", needed_rotation[0], ", actual=", net_sleeve_rotation[0], ", diff=", abs(needed_rotation[0] - net_sleeve_rotation[0]));
echo("  Y component: needed=", needed_rotation[1], ", actual=", net_sleeve_rotation[1], ", diff=", abs(needed_rotation[1] - net_sleeve_rotation[1]));
echo("  Z component: needed=", needed_rotation[2], ", actual=", net_sleeve_rotation[2], ", diff=", abs(needed_rotation[2] - net_sleeve_rotation[2]));
echo("");

// Angular difference between current and target directions
angular_diff = acos(tt_unit * seat_tube_unit);
echo("Angular difference between current and target:", angular_diff, "degrees");
