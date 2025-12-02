include <scad/geometry.scad>

echo("=== After orient_to(ht_top_tube, st_top_tube) ===");
echo("Local +Z axis = global tt_unit:", tt_unit);
echo("");

echo("=== What we need ===");
echo("Sleeve should point along global seat_tube_unit:", seat_tube_unit);
echo("");

echo("=== The rotation ===");
echo("In GLOBAL frame: need to rotate from tt_unit to seat_tube_unit");
echo("Both vectors in XZ plane, so rotation is around GLOBAL +Y axis");
echo("Rotation amount:", acos(tt_unit * seat_tube_unit), "degrees");
echo("");

echo("=== But in LOCAL frame after orient_to ===");
echo("The local axes are rotated!");
echo("orient_to rotates around Y-axis by:", atan2(tt_unit[0], tt_unit[2]), "degrees");
echo("");

echo("Local frame orientation:");
echo("  Local +Y = Global +Y (Y-axis unchanged by orient_to)");
echo("  Local +Z = Global tt_unit");
echo("  Local +X = perpendicular to Y and Z");
echo("");

echo("So rotating around LOCAL Y-axis IS rotating around GLOBAL Y-axis!");
echo("That should work... but it didn't. Why?");
echo("");

echo("Maybe the issue is the COLLAR also gets rotated,");
echo("and the collar needs different rotation than the sleeve?");
