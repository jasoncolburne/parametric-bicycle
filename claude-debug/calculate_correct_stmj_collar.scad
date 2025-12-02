include <scad/geometry.scad>

// The lug TT socket points at angle -tt_angle from head tube
// In global terms, what direction is that?

ht_direction = _ht_vec / norm(_ht_vec);

echo("=== Lug TT Socket Direction (Global) ===");
echo("Head tube direction:", ht_direction);
echo("Collar rotates by -tt_angle =", -tt_angle, "from head tube");
echo("");

// The STMJ needs its TT socket to point in the SAME global direction
// But it's in a frame where +Z = tt_unit (after orient_to)
// So we need to calculate: what rotation from tt_unit gives us the lug socket direction?

echo("=== STMJ Reference Frame ===");
echo("After orient_to, local +Z = tt_unit:", tt_unit);
echo("We need collar to point at same direction as lug");
echo("");

// The lug collar points backward along the top tube (in -tt_unit direction)
// because it's the socket that the tube enters
echo("=== Key Insight ===");
echo("Both sockets should point along -tt_unit (backward along top tube)");
echo("Because the tube connects them");
echo("");

echo("So STMJ collar should rotate to point at -tt_unit");
echo("From local +Z (which is tt_unit) to -tt_unit is 180°");
echo("");

echo("But we're using rotation_angle =", acos(tt_unit * seat_tube_unit));
echo("This is WRONG for the collar!");
echo("The collar should be [180, 0, 0] to flip from +tt to -tt");
