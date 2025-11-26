// Water Bottle Cage Mount Adapter
// Provides standard 74mm mounting pattern
// Uses M5 bolts into rivnuts in downtube
// NOTE: This is optional - standard water bottle cages bolt directly to rivnuts

include <../../config.scad>

module water_bottle_cage_mount() {
    difference() {
        // Simple flat plate
        translate([-30, -10, 0])
            cube([60, 20, 3]);

        // Mounting holes - 74mm spacing
        for (z_offset = [0, bottle_cage_spacing]) {
            translate([0, 0, z_offset - bottle_cage_spacing/2])
                cylinder(h = 10, d = 5.5, center = true);  // M5 clearance
        }
    }
}

// Render for preview
water_bottle_cage_mount();
