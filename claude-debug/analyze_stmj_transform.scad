include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);
collar_rotation = [rotation_angle, 0, 0];
sleeve_rotation_current = [180, 0, -90];

echo("=== Understanding the Transformation ===");
echo("");
echo("1. The STMJ starts with Z-axis pointing up (+Z)");
echo("2. orient_to() rotates it so Z-axis points along tt_unit:", tt_unit);
echo("3. We want the sleeve Z-axis to point along seat_tube_unit:", seat_tube_unit);
echo("");

echo("Current approach:");
echo("  collar_rotation:", collar_rotation);
echo("  sleeve_rotation:", sleeve_rotation_current);
echo("  net = sleeve - collar:", sleeve_rotation_current - collar_rotation);
echo("");

// The key insight: after orient_to, we're in a coordinate system where:
// - Z-axis is along tt_unit
// - We need to rotate to align with seat_tube_unit

// Both tt_unit and seat_tube_unit are in the XZ plane (Y=0)
// So we only need rotation around Y axis

echo("=== Vector Analysis ===");
echo("tt_unit:", tt_unit);
echo("  X component:", tt_unit[0]);
echo("  Z component:", tt_unit[2]);
echo("  Angle from +Z:", atan2(tt_unit[0], tt_unit[2]));
echo("");

echo("seat_tube_unit:", seat_tube_unit);
echo("  X component:", seat_tube_unit[0]);
echo("  Z component:", seat_tube_unit[2]);
echo("  Angle from +Z:", atan2(seat_tube_unit[0], seat_tube_unit[2]));
echo("");

// The rotation needed around Y to go from tt_unit to seat_tube_unit
rotation_y_needed = atan2(seat_tube_unit[0], seat_tube_unit[2]) - atan2(tt_unit[0], tt_unit[2]);
echo("Rotation around Y needed:", rotation_y_needed);
echo("");

// But we also need the -90 around Z for the sleeve orientation
// And the sleeve starts pointing up, so we might need the 180 flip

echo("=== Testing hypothesis ===");
echo("If we want [?, rotation_y_needed, -90]:");
echo("  Option A: [0,", rotation_y_needed, ", -90]");
echo("  Option B: [180,", rotation_y_needed, ", -90]");
