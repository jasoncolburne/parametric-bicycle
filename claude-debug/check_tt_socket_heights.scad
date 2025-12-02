include <scad/geometry.scad>

echo("=== Top Tube Socket Positions ===");
echo("");

echo("Head tube lug top tube socket:");
echo("  ht_top_tube:", ht_top_tube);
echo("  Height (Z):", ht_top_tube[2]);
echo("");

echo("Seat tube mid junction top tube socket:");
echo("  st_top_tube:", st_top_tube);
echo("  Height (Z):", st_top_tube[2]);
echo("");

echo("Height difference:", ht_top_tube[2] - st_top_tube[2], "mm");
echo("Total distance:", norm(ht_top_tube - st_top_tube), "mm");
echo("top_tube_length:", top_tube_length, "mm");
echo("");

echo("Top tube direction:");
tt_vec = st_top_tube - ht_top_tube;
tt_unit_calc = tt_vec / norm(tt_vec);
echo("  Calculated from positions:", tt_unit_calc);
echo("  Global tt_unit:", tt_unit);
echo("  Match?", norm(tt_unit_calc - tt_unit) < 0.001);
