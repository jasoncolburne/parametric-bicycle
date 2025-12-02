include <scad/geometry.scad>

echo("=== Coordinate System Analysis ===");
echo("");
echo("1. Sleeve primitive default: Z-axis = +Z (up)");
echo("2. After orient_to(ht_top_tube, st_top_tube): Z-axis = tt_unit");
echo("   tt_unit:", tt_unit);
echo("");

echo("3. COLLAR rotation:");
echo("   - Controls the TOP TUBE socket orientation");
echo("   - Needs to point BACK toward head tube (in -tt_unit direction)");
echo("   - In local coords after orient_to: +Z = tt_unit, so -Z = -tt_unit");
echo("   - So collar needs 180° flip to point in -Z direction");
echo("");

rotation_angle = acos(tt_unit * seat_tube_unit);
echo("4. SLEEVE rotation:");
echo("   - Controls the main sleeve body orientation");
echo("   - Needs to align with seat_tube_unit:", seat_tube_unit);
echo("   - Current approach: [180, 0, -90] - [rotation_angle, 0, 0]");
echo("   - This gives:", [180, 0, -90] - [rotation_angle, 0, 0]);
echo("");

echo("5. The question: what should sleeve_rotation be to align with seat tube?");
echo("   - After orient_to, we're aligned with tt_unit");
echo("   - We need to rotate to align with seat_tube_unit");
echo("   - The angle between them:", rotation_angle);
echo("");

echo("6. But wait - what axis should we rotate around?");
echo("   tt_unit:", tt_unit, "  (X =", tt_unit[0], ", Z =", tt_unit[2], ")");
echo("   seat_tube_unit:", seat_tube_unit, "  (X =", seat_tube_unit[0], ", Z =", seat_tube_unit[2], ")");
echo("   Both in XZ plane (Y=0), so rotate around Y axis!");
echo("   Rotation around Y-axis needed:", atan2(seat_tube_unit[0], seat_tube_unit[2]) - atan2(tt_unit[0], tt_unit[2]));
