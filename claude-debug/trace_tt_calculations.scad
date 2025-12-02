include <scad/geometry.scad>

echo("=== Trace Top Tube Socket Calculations ===");
echo("");

// What are the targets?
echo("Lug target (_lug_tt_target): calculated in geometry.scad");
echo("STMJ target (_stmj_tt_target): calculated in geometry.scad");
echo("");

// What are the actual sockets?
echo("Lug socket (ht_top_tube):", ht_top_tube);
echo("STMJ socket (st_top_tube):", st_top_tube);
echo("");

// Are the sockets where they should be relative to their starting points?
echo("Head tube base (ht_down_tube):", ht_down_tube);
echo("Head tube top (ht_top_tube):", ht_top_tube);
echo("Head tube vector:", ht_top_tube - ht_down_tube);
echo("Head tube length:", norm(ht_top_tube - ht_down_tube));
echo("");

echo("BB seat tube (bb_seat_tube):", bb_seat_tube);
echo("Seat tube top (st_top):", st_top);
echo("ST top tube socket (st_top_tube):", st_top_tube);
echo("");

// What's the vector between them?
echo("Vector from lug to STMJ:", st_top_tube - ht_top_tube);
echo("Top tube length:", norm(st_top_tube - ht_top_tube));
echo("");

// What should tt_unit be?
actual_tt_unit = (st_top_tube - ht_top_tube) / norm(st_top_tube - ht_top_tube);
echo("Actual tt_unit (from sockets):", actual_tt_unit);
echo("tt_unit (from geometry.scad):", tt_unit);
echo("Match?", norm(actual_tt_unit - tt_unit) < 0.001);
