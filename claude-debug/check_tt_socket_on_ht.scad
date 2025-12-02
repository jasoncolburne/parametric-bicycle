include <scad/geometry.scad>

echo("=== Is Top Tube Socket on Head Tube? ===");
echo("");

ht_vec = ht_top - ht_bottom;
ht_length = norm(ht_vec);
ht_direction = ht_vec / ht_length;

echo("Head tube: from", ht_bottom, "to", ht_top);
echo("Head tube direction:", ht_direction);
echo("");

echo("Top tube socket (ht_top_tube):", ht_top_tube);
echo("");

// Project ht_top_tube onto head tube line
vec_to_tt_socket = ht_top_tube - ht_bottom;
projection_length = (vec_to_tt_socket * ht_vec) / norm(ht_vec);
point_on_ht = ht_bottom + ht_direction * projection_length;

echo("Closest point on HT to TT socket:", point_on_ht);
echo("Distance from HT centerline:", norm(ht_top_tube - point_on_ht), "mm");
echo("On centerline?", norm(ht_top_tube - point_on_ht) < 0.01);
echo("");

echo("Distance up head tube:", projection_length, "mm");
echo("(should be", down_tube_extension_translation + top_extension_translation, "mm = 75mm)");
