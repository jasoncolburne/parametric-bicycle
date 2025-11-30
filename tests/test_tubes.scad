// Phase 3 Verification: Test tube_end and complete tube assemblies

include <../scad/geometry.scad>
include <../scad/lib/tube_primitives.scad>
include <../scad/lib/sleeve_primitives.scad>

spacing = 100;

echo("=== Phase 3 Tube End and Complete Tube Tests ===");

// Test 1: Socket end only
echo("Test 1: Socket end (40mm)");
translate([0, 0, 0])
    tube_end(DOWN_TUBE, "socket");

// Test 2: Inner sleeve end only
echo("Test 2: Inner sleeve end (30mm with bolt holes)");
translate([spacing, 0, 0])
    tube_end(DOWN_TUBE, "inner_sleeve");

// Test 3: Complete tube with socket ends (for junction insertion)
echo("Test 3: Complete tube with socket/socket ends (200mm total)");
translate([spacing * 2, 0, 0])
    tube(DOWN_TUBE, 200, "socket", "socket");

// Test 4: Complete tube with inner_sleeve ends (for tube sectioning)
echo("Test 4: Complete tube with inner_sleeve/inner_sleeve ends (200mm total)");
translate([spacing * 3, 0, 0])
    tube(SEAT_TUBE, 200, "inner_sleeve", "inner_sleeve");

// Test 5: Mixed ends - socket start, inner_sleeve end
echo("Test 5: Mixed tube - socket/inner_sleeve (200mm total)");
translate([0, spacing, 0])
    tube(TOP_TUBE, 200, "socket", "inner_sleeve");

// Test 6: Assembly demonstration - two tube sections with inner sleeve
echo("Test 6: Assembled tube sections with inner sleeve");
translate([spacing, spacing, 0]) {
    sectioned_tube(DOWN_TUBE, 300);
}

echo("=== Dimension Checks ===");
echo("Socket depth:", tube_socket_depth(DOWN_TUBE));
echo("Inner sleeve depth:", tube_inner_sleeve_depth(DOWN_TUBE));
echo("Down tube outer diameter:", tube_outer_radius(DOWN_TUBE) * 2);

// Test 7: tube_section - split a long tube
echo("Test 7: Tube sections for 500mm total length");
total_len = 500;
num_sections = tube_num_sections(TOP_TUBE, total_len);
echo("  Number of sections needed:", num_sections);

translate([spacing * 2, spacing, 0]) {
    sectioned_tube(TOP_TUBE, total_len);
}
