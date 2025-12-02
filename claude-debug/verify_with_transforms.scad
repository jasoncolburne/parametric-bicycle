include <scad/geometry.scad>
include <scad/lib/helpers.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);
collar_rotation = [rotation_angle, 0, 0];
sleeve_rotation = [180, 0, -90];
net_sleeve_rotation = sleeve_rotation - collar_rotation;

socket_depth = tube_socket_depth(SEAT_TUBE);
extension_depth = tube_extension_depth(SEAT_TUBE);
stmj_height = 70;

echo("=== Transformation Chain ===");
echo("1. translate([0, 0,", extension_depth - socket_depth, "])");
echo("2. rotate(", net_sleeve_rotation, ")");
echo("3. translate([0, 0,", -stmj_height / 2, "])");
echo("4. sleeve created");
echo("");

echo("=== Key Insight ===");
echo("The rotation at step 2 happens around origin,");
echo("but the sleeve is offset by", extension_depth - socket_depth);
echo("This means the sleeve ORBITS around origin during rotation!");
echo("");

echo("=== Does this affect alignment? ===");
echo("Position: YES - the sleeve position changes due to orbital motion");
echo("Direction: UNCLEAR - need to calculate the final orientation");
echo("");

echo("The sleeve's Z-axis direction after rotation depends on:");
echo("  - The rotation applied:", net_sleeve_rotation);
echo("  - Whether the offset affects the final orientation");
echo("");

echo("Target direction: seat_tube_unit =", seat_tube_unit);
echo("Current direction (before rotations): tt_unit =", tt_unit);
echo("");

echo("This explains why simple euler angle subtraction was wrong!");
echo("I need to account for the full transformation chain.");
