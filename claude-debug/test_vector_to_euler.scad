include <scad/geometry.scad>
include <scad/lib/helpers.scad>

echo("=== Using vector_to_euler pattern ===");
echo("");

echo("tt_unit:", tt_unit);
echo("vector_to_euler(tt_unit):", vector_to_euler(tt_unit));
echo("");

echo("seat_tube_unit:", seat_tube_unit);
echo("vector_to_euler(seat_tube_unit):", vector_to_euler(seat_tube_unit));
echo("");

// Pattern from seat_tube_junction:
// collar_rot = vector_to_euler(target_dir) + [0, 0, -90] - vector_to_euler(base_dir)

// For STMJ:
// - After orient_to, we're aligned with tt_unit
// - We want to align with seat_tube_unit
// - Z rotation is -90 for sleeve orientation

stmj_rotation = vector_to_euler(seat_tube_unit) + [0, 0, -90] - vector_to_euler(tt_unit);

echo("STMJ collar_rotation using pattern:");
echo("  = vector_to_euler(seat_tube_unit) + [0, 0, -90] - vector_to_euler(tt_unit)");
echo("  =", vector_to_euler(seat_tube_unit), "+ [0, 0, -90] -", vector_to_euler(tt_unit));
echo("  =", stmj_rotation);
echo("");

echo("Current config for comparison:");
echo("  collar_rotation:", [acos(tt_unit * seat_tube_unit), 0, 0]);
echo("  sleeve_rotation:", [180, 0, -90]);
echo("  net:", [180, 0, -90] - [acos(tt_unit * seat_tube_unit), 0, 0]);
