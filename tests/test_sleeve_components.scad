// Phase 4 Verification: Test sleeve collar and pinch bolt primitives

include <../scad/lib/sleeve_primitives.scad>
include <../scad/lib/collar.scad>

spacing = 100;

echo("=== Phase 4 Sleeve Collar and Pinch Bolt Tests ===");

// Test 1: Basic sleeve collar with no rotation
echo("Test 1: Sleeve collar - DOWN_TUBE, no rotation, height 0");
translate([0, 0, 0]) {
    collar = Collar(DOWN_TUBE, [0, 0, 0], 0);
    sleeve_collar(collar);
}

// Test 2: Sleeve collar rotated 90° around X axis
echo("Test 2: Sleeve collar - SEAT_TUBE, rotated [90, 0, 0], height 25");
translate([spacing, 0, 0]) {
    collar = Collar(SEAT_TUBE, [90, 0, 0], 25);
    sleeve_collar(collar);
}

// Test 3: Sleeve collar rotated 45° around Y axis
echo("Test 3: Sleeve collar - TOP_TUBE, rotated [0, 45, 0], height 50");
translate([spacing * 2, 0, 0]) {
    collar = Collar(TOP_TUBE, [0, 45, 0], 50);
    sleeve_collar(collar);
}

// Test 4: Sleeve collar with complex rotation
echo("Test 4: Sleeve collar - DOWN_TUBE, rotated [30, 60, 45], height 75");
translate([spacing * 3, 0, 0]) {
    collar = Collar(DOWN_TUBE, [30, 60, 45], 75);
    sleeve_collar(collar);
}

// Test 5: Pinch bolt with M6 bolt
echo("Test 5: Pinch bolt - M6, 20mm length, 1mm separation");
translate([0, spacing, 0]) {
    sleeve_pinch_bolt(M6_BOLT, 20, 1);
}

// Test 6: Pinch bolt with M5 bolt
echo("Test 6: Pinch bolt - M5, 15mm length, 0.8mm separation");
translate([spacing, spacing, 0]) {
    sleeve_pinch_bolt(M5_BOLT, 15, 0.8);
}

// Test 7: Pinch bolt with wider separation
echo("Test 7: Pinch bolt - M6, 25mm length, 2mm separation");
translate([spacing * 2, spacing, 0]) {
    sleeve_pinch_bolt(M6_BOLT, 25, 2);
}

// Test 8: Combined assembly - collar with pinch bolt
echo("Test 8: Assembly - collar + pinch bolt");
translate([spacing * 3, spacing, 0]) {
    collar = Collar(DOWN_TUBE, [0, 0, 0], 0);
    sleeve_collar(collar);

    // Position pinch bolt at appropriate location
    outer_r = tube_outer_radius(DOWN_TUBE);
    collar_thickness = tube_collar_thickness(DOWN_TUBE);
    extension_depth = tube_extension_depth(DOWN_TUBE);

    translate([outer_r + collar_thickness / 2, 0, extension_depth/2])
        rotate([90, 0, 0]) {
            sleeve_pinch_bolt(M6_BOLT, 30, 1);
        }
}

echo("=== Dimension Checks ===");
echo("DOWN_TUBE outer radius:", tube_outer_radius(DOWN_TUBE));
echo("DOWN_TUBE collar thickness:", tube_collar_thickness(DOWN_TUBE));
echo("DOWN_TUBE extension depth:", tube_extension_depth(DOWN_TUBE));
echo("M6 boss radius:", bolt_boss_radius(M6_BOLT));
echo("M5 boss radius:", bolt_boss_radius(M5_BOLT));
