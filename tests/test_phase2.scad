// Phase 2 Verification: Test tube_core, inner_sleeve, rivnut_hole

include <../scad/config.scad>
include <../scad/lib/tube_primitives.scad>
include <../scad/lib/sleeve_primitives.scad>
include <../scad/lib/mount_primitives.scad>

spacing = 80;  // Space between test objects

echo("=== Phase 2 Primitive Tests ===");

// Test 1: tube_core with DOWN_TUBE size
echo("Test 1: Down tube core (200mm, no holes)");
translate([0, 0, 0])
    tube_core(DOWN_TUBE, 200);

// Test 2: tube_core with through holes
echo("Test 2: Seat tube core (200mm, 2 holes at 50mm and 150mm)");
translate([spacing, 0, 0])
    tube_core(SEAT_TUBE, 200, [50, 150]);

// Test 3: inner_sleeve for DOWN_TUBE
echo("Test 3: Inner sleeve for down tube");
translate([spacing * 2, 0, 0])
    inner_sleeve(DOWN_TUBE);

// Test 4: inner_sleeve for CHAINSTAY (smaller, M5 bolts)
echo("Test 4: Inner sleeve for chainstay");
translate([spacing * 3, 0, 0])
    inner_sleeve(CHAINSTAY);

// Test 5: tube_core with rivnut_holes
echo("Test 5: Down tube with rivnut holes at 30mm, 104mm, 130mm");
translate([0, spacing, 0])
    difference() {
        tube_core(DOWN_TUBE, 160);
        // Rivnut holes for battery mount (74mm spacing, 2 pairs)
        rivnut_hole(30);
        rivnut_hole(30 + 74);
        rivnut_hole(130);
        rivnut_hole(130 + 74);
    }

echo("=== Dimensions Check ===");
echo("Down tube outer diameter:", tube_outer_radius(DOWN_TUBE) * 2);
echo("Seat tube outer diameter:", tube_outer_radius(SEAT_TUBE) * 2);
echo("Chainstay outer diameter:", tube_outer_radius(CHAINSTAY) * 2);
