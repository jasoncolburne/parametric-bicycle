include <scad/geometry.scad>

echo("=== HEAD TUBE LUG (working) ===");
echo("Oriented along: head tube (ht_unit)");
echo("Has collar for: down tube at angle dt_angle");
echo("dt_angle:", acos((_ht_vec * (bb_down_tube - ht_down_tube)) / (norm(_ht_vec) * norm(bb_down_tube - ht_down_tube))));
echo("Rotation used: [180 + dt_angle, 0, 90]");
echo("");

echo("=== STMJ (broken) ===");
echo("Oriented along: top tube via orient_to(ht_top_tube, st_top_tube)");
echo("After orient_to: local +Z = tt_unit:", tt_unit);
echo("Has collar for: top tube (needs to point back in -tt_unit direction)");
echo("Sleeve needs to: clamp onto seat tube (align with seat_tube_unit)");
echo("seat_tube_unit:", seat_tube_unit);
echo("");

rotation_angle = acos(tt_unit * seat_tube_unit);
echo("Angle between tt_unit and seat_tube_unit:", rotation_angle);
echo("");

echo("=== Pattern from HTL ===");
echo("HTL uses: [180 + angle, 0, z_rotation]");
echo("If we apply same pattern: [180 + rotation_angle, 0, -90]");
echo("  = [", 180 + rotation_angle, ", 0, -90]");
echo("");

echo("But wait - HTL collar rotation vs sleeve rotation?");
echo("Let me check what HTL actually does...");
