include <scad/geometry.scad>
include <scad/lib/helpers.scad>

// Current approach:
rotation_angle = acos(tt_unit * seat_tube_unit);
collar_rotation_old = [rotation_angle, 0, 0];
sleeve_rotation_old = [180, 0, -90];

echo("=== Current (complex) ===");
echo("collar_rotation:", collar_rotation_old);
echo("sleeve_rotation:", sleeve_rotation_old);
echo("Net effect: rotate(", sleeve_rotation_old - collar_rotation_old, ")");
echo("");

// Simplified approach like seat_tube_junction:
// The collar needs to point in -tt_unit direction (back toward head tube)
// In the local frame after orient_to, -tt_unit is just -Z (flip 180°)

// But we also need the sleeve to align with seat tube
// Use vector_to_euler to calculate rotation from tt_unit to seat_tube_unit

collar_rotation_new = vector_to_euler(-tt_unit);  // Point collar backward
sleeve_rotation_new = vector_to_euler(seat_tube_unit) - vector_to_euler(tt_unit);

echo("=== Simplified (attempt 1) ===");
echo("collar points at -tt_unit:", -tt_unit);
echo("collar_rotation:", collar_rotation_new);
echo("sleeve needs rotation:", sleeve_rotation_new);
echo("");

// Wait, that doesn't account for the -90 Z rotation for sleeve orientation
// Let me add that:
sleeve_rotation_new2 = vector_to_euler(seat_tube_unit) - vector_to_euler(tt_unit) + [0, 0, -90];

echo("=== Simplified (attempt 2, with Z) ===");
echo("sleeve_rotation with Z:", sleeve_rotation_new2);
