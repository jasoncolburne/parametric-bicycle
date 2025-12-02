include <scad/geometry.scad>

echo("=== Angles Between Tubes ===");
echo("");

// Head tube direction
ht_direction = _ht_vec / norm(_ht_vec);
echo("Head tube direction:", ht_direction);
echo("");

// Seat tube direction
echo("Seat tube direction:", seat_tube_unit);
echo("");

// Angle between head tube and seat tube
ht_st_angle = acos(ht_direction * seat_tube_unit);
echo("Angle between head tube and seat tube:", ht_st_angle, "degrees");
echo("");

echo("=== Current Collar Rotations ===");
echo("Lug TT collar: [-tt_angle, 0, 0] = [", -tt_angle, ", 0, 0]");
echo("STMJ TT collar: [rotation_angle, 0, 0] = [", acos(tt_unit * seat_tube_unit), ", 0, 0]");
echo("");

echo("=== The Problem ===");
echo("Both collars are in different reference frames:");
echo("  - Lug is in head tube frame");
echo("  - STMJ is in top tube frame (after orient_to)");
echo("");
echo("The lug rotates relative to head tube by -tt_angle");
echo("The STMJ rotates relative to top tube by rotation_angle");
echo("");
echo("But for the sockets to align, they need to point in the same absolute direction!");
