// Battery Mount Bracket
// CNC milled component for NestWorks C500

include <../../config.scad>

module battery_mount() {
    difference() {
        // Main bracket body
        cube([battery_mount_width, battery_mount_height, battery_mount_thickness]);

        // Frame mounting hole (M5)
        translate([battery_mount_width/2, 10, -epsilon])
            cylinder(h = battery_mount_thickness + 2*epsilon, d = 5.5);

        // Battery rail slot
        translate([10, battery_mount_height - 10, -epsilon])
            hull() {
                cylinder(h = battery_mount_thickness + 2*epsilon, d = 6);
                translate([battery_mount_width - 20, 0, 0])
                    cylinder(h = battery_mount_thickness + 2*epsilon, d = 6);
            }
    }
}

// Render for preview
battery_mount();
