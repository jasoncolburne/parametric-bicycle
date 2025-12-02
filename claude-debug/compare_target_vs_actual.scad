include <scad/geometry.scad>

echo("=== Target vs Actual Socket Position ===");
echo("");

// Calculate what the target should be
lug_tt_target = ht_bottom + ht_unit * (down_tube_extension_translation + top_extension_translation);
echo("Target position (_lug_tt_target):", lug_tt_target);
echo("Actual position (ht_top_tube):", ht_top_tube);
echo("");

echo("Difference:", ht_top_tube - lug_tt_target);
echo("Distance:", norm(ht_top_tube - lug_tt_target), "mm");
echo("");

echo("Is target on HT centerline?");
ht_vec = ht_top - ht_bottom;
vec_to_target = lug_tt_target - ht_bottom;
projection = (vec_to_target * ht_vec) / norm(ht_vec);
point_on_ht = ht_bottom + (ht_vec / norm(ht_vec)) * projection;
echo("  Distance from centerline:", norm(lug_tt_target - point_on_ht), "mm");
