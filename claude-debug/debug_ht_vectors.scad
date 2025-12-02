include <scad/geometry.scad>

echo("=== Head Tube Vector Comparison ===");
echo("");

// Target head tube vector (used in tt_angle calculation)
echo("ht_top (target):", ht_top);
echo("ht_bottom (target):", ht_bottom);
target_ht_vec = ht_top - ht_bottom;
echo("_ht_vec (from targets):", target_ht_vec);
echo("");

// Actual head tube vector (from sockets)
echo("ht_top_tube (actual socket):", ht_top_tube);
echo("ht_down_tube (actual socket):", ht_down_tube);
actual_ht_vec = ht_top_tube - ht_down_tube;
echo("actual_ht_vec (from sockets):", actual_ht_vec);
echo("");

echo("Do they match?");
echo("  Difference:", actual_ht_vec - target_ht_vec);
echo("  Magnitude:", norm(actual_ht_vec - target_ht_vec));
echo("");

// Normalized versions
target_ht_unit = target_ht_vec / norm(target_ht_vec);
actual_ht_unit = actual_ht_vec / norm(actual_ht_vec);
echo("Target ht_unit:", target_ht_unit);
echo("Actual ht_unit:", actual_ht_unit);
echo("ht_unit from geometry.scad:", ht_unit);
