// Seat Tube Collar
// CNC milled component for NestWorks C500

include <../geometry.scad>

module seat_collar() {
    difference() {
        // Outer cylinder
        cylinder(h = seat_collar_height, d = seat_collar_od);

        // Inner bore
        translate([0, 0, -epsilon])
            cylinder(h = seat_collar_height + 2*epsilon, d = seat_collar_id);

        // Clamp slot
        translate([-1, seat_collar_od/2 - 3, -epsilon])
            cube([2, 10, seat_collar_height + 2*epsilon]);

        // Clamp bolt hole (M5)
        translate([0, seat_collar_od/2 + 2, seat_collar_height/2])
            rotate([90, 0, 0])
                cylinder(h = 10, d = 5.5);
    }
}

// Render for preview
seat_collar();
