// Phase 5 Verification: Test complete sleeve assembly

include <../scad/config.scad>
include <../scad/lib/sleeve_primitives.scad>
include <../scad/lib/collar.scad>

spacing = 200;

echo("=== Phase 5 Complete Sleeve Assembly Tests ===");

// Test 1: Simple sleeve with single collar
echo("Test 1: Sleeve with single collar (DOWN_TUBE, height 50)");
translate([0, 0, 0]) {
    collars = [
        Collar(DOWN_TUBE, [0, 0, 0], 50)
    ];
    sleeve(DOWN_TUBE, 100, collars);
}

// Test 2: Sleeve with two collars at 90 degrees
echo("Test 2: Sleeve with two orthogonal collars");
translate([spacing, 0, 0]) {
    collars = [
        Collar(DOWN_TUBE, [0, 0, 0], 30),
        Collar(DOWN_TUBE, [0, 90, 0], 70)
    ];
    sleeve(DOWN_TUBE, 100, collars);
}

// Test 3: Sleeve with three collars
echo("Test 3: Sleeve with three collars (120° apart in Z rotation)");
translate([spacing * 2, 0, 0]) {
    collars = [
        Collar(SEAT_TUBE, [0, 0, 0], 25),
        Collar(SEAT_TUBE, [0, 0, 120], 50),
        Collar(SEAT_TUBE, [0, 0, 240], 75)
    ];
    sleeve(SEAT_TUBE, 100, collars);
}

// Test 4: Sleeve with complex collar orientations
echo("Test 4: Sleeve with varied collar orientations");
translate([0, spacing, 0]) {
    collars = [
        Collar(TOP_TUBE, [0, 0, 0], 20),
        Collar(TOP_TUBE, [30, 60, 0], 50),
        Collar(TOP_TUBE, [0, 45, 90], 80)
    ];
    sleeve(TOP_TUBE, 100, collars);
}

// Test 5: Four-way junction sleeve
echo("Test 5: Four-way junction sleeve");
translate([spacing, spacing, 0]) {
    collars = [
        Collar(DOWN_TUBE, [90, 0, 0], 50),
        Collar(SEAT_TUBE, [90, 0, 90], 50),
        Collar(TOP_TUBE, [90, 0, 180], 50),
        Collar(SEATSTAY, [90, 0, 270], 50)
    ];
    sleeve(DOWN_TUBE, 100, collars);
}

// Test 6: Pinched sleeve with single collar and stepped bore
echo("Test 6: Pinched sleeve with single collar, pinch bolt, and stepped bore");
translate([spacing * 2, spacing, 0]) {
    collars = [
        Collar(SEAT_TUBE, [-90, 0, 0], 50)
    ];
    // Stepped bore: upper smaller than lower (for demonstration)
    pinched_sleeve(SEAT_TUBE, 100, 50, collars, 2, SEAT_TUBE, SEAT_TUBE);
}

// Test 7: Tapped sleeve with single collar and two taps
echo("Test 7: Tapped sleeve with single collar and two tap positions");
translate([0, spacing * 2, 0]) {
    collars = [
        Collar(DOWN_TUBE, [90, 0, 0], 50)
    ];
    taps = [30, 70];  // Two tap positions along sleeve
    tapped_sleeve(DOWN_TUBE, 100, taps, collars);
}

// Test 8: Tapped sleeve with multiple collars and taps
echo("Test 8: Tapped sleeve - three collars with three taps");
translate([spacing, spacing * 2, 0]) {
    collars = [
        Collar(TOP_TUBE, [90, 0, 0], 66),
        Collar(TOP_TUBE, [90, 0, 240], 50),
        Collar(TOP_TUBE, [90, 0, 120], 75)
    ];
    taps = [20, 80];
    tapped_sleeve(TOP_TUBE, 100, taps, collars);
}

echo("=== Dimension Checks ===");
echo("DOWN_TUBE outer radius:", tube_outer_radius(DOWN_TUBE));
echo("DOWN_TUBE collar thickness:", tube_collar_thickness(DOWN_TUBE));
echo("DOWN_TUBE pinch separation:", tube_pinch_separation(DOWN_TUBE));
echo("SEAT_TUBE outer radius:", tube_outer_radius(SEAT_TUBE));
echo("SEAT_TUBE pinch separation:", tube_pinch_separation(SEAT_TUBE));
echo("TOP_TUBE outer radius:", tube_outer_radius(TOP_TUBE));
