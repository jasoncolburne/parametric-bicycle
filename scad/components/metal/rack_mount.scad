// Rack/Fender Mount
// CNC milled component for NestWorks C500

include <../../config.scad>

module rack_mount() {
    difference() {
        // Main body
        cube([rack_mount_length, rack_mount_width, rack_mount_height]);

        // Threaded hole for rack (M5)
        translate([rack_mount_length/2, rack_mount_width/2, -epsilon])
            cylinder(h = rack_mount_height + 2*epsilon, d = 4.2); // Tap drill for M5

        // Frame mounting holes (M4)
        translate([5, rack_mount_width/2, -epsilon])
            cylinder(h = rack_mount_height + 2*epsilon, d = 4.5);
        translate([rack_mount_length - 5, rack_mount_width/2, -epsilon])
            cylinder(h = rack_mount_height + 2*epsilon, d = 4.5);
    }
}

// Render for preview
rack_mount();
