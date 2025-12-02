include <scad/geometry.scad>

// Current STMJ calculations
rotation_angle = acos(tt_unit * seat_tube_unit);
collar_rotation = [rotation_angle, 0, 0];
sleeve_rotation = [180, 0, -90];
net_sleeve_rotation = sleeve_rotation - collar_rotation;

echo("=== Current State ===");
echo("After orient_to: component +Z axis = tt_unit:", tt_unit);
echo("Target: sleeve should align with seat_tube_unit:", seat_tube_unit);
echo("");
echo("Net sleeve rotation applied:", net_sleeve_rotation);
echo("");

// To find where the sleeve actually points, we need to:
// 1. Start with +Z = [0, 0, 1] in component local frame
// 2. Apply net_sleeve_rotation
// 3. Then orient_to transforms it to global coords

// But it's easier to work in global coords:
// After orient_to, local +Z = global tt_unit
// We want to rotate to global seat_tube_unit

// The angle between current and target:
current_dir = tt_unit;  // This is where sleeve currently points (before local rotations)
target_dir = seat_tube_unit;  // This is where it should point

angle_between = acos(current_dir * target_dir);
echo("=== Misalignment ===");
echo("Current sleeve direction (global):", current_dir);
echo("Target sleeve direction (global):", target_dir);
echo("Angle between them:", angle_between, "degrees");
echo("This equals rotation_angle:", rotation_angle);
echo("");

// Cross product tells us the axis of rotation needed
cross_product = [
    current_dir[1]*target_dir[2] - current_dir[2]*target_dir[1],
    current_dir[2]*target_dir[0] - current_dir[0]*target_dir[2],
    current_dir[0]*target_dir[1] - current_dir[1]*target_dir[0]
];

echo("Rotation axis (cross product):", cross_product);
echo("Normalized:", cross_product / norm(cross_product));
echo("");

// Since both vectors are in XZ plane (Y=0), the rotation axis should be Y
echo("Expected rotation axis: [0, 1, 0] (Y-axis)");
echo("This confirms we need to rotate around Y-axis by", rotation_angle, "degrees");
