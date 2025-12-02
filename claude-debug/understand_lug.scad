include <scad/geometry.scad>

echo("=== Understanding the Lug and Head Tube ===");
echo("");

echo("PHYSICAL HEAD TUBE:");
echo("  Bottom:", ht_bottom);
echo("  Top:", ht_top);
echo("  Vector:", ht_top - ht_bottom);
echo("  Length:", norm(ht_top - ht_bottom));
echo("");

echo("LUG SOCKET POSITIONS:");
echo("  Down tube socket (ht_down_tube):", ht_down_tube);
echo("  Top tube socket (ht_top_tube):", ht_top_tube);
echo("  Distance between:", norm(ht_top_tube - ht_down_tube));
echo("");

echo("Is ht_down_tube on the head tube centerline?");
// Project ht_down_tube onto the head tube line
ht_vec = ht_top - ht_bottom;
vec_to_dt_socket = ht_down_tube - ht_bottom;
projection_length = (vec_to_dt_socket * ht_vec) / norm(ht_vec);
point_on_ht = ht_bottom + (ht_vec / norm(ht_vec)) * projection_length;
distance_from_centerline = norm(ht_down_tube - point_on_ht);
echo("  Distance from HT centerline:", distance_from_centerline);
echo("  On centerline?", distance_from_centerline < 0.01);
