// Tube Joint Sleeve
// CNC milled component for NestWorks C500
// Internal coupler for joining tube sections

include <../geometry.scad>

module tube_sleeve(tube_od) {
    // Sleeve fits inside tube sections
    sleeve_od = tube_od - 2 * tolerance_press_fit;
    sleeve_id = sleeve_od - 2 * sleeve_wall_thickness;

    difference() {
        // Outer cylinder
        cylinder(h = sleeve_length, d = sleeve_od);

        // Inner bore (for weight reduction)
        translate([0, 0, -epsilon])
            cylinder(h = sleeve_length + 2*epsilon, d = sleeve_id);

        // Bolt holes (M6) - 2 per side
        for (z = [sleeve_length/4, sleeve_length*3/4]) {
            translate([0, 0, z])
                rotate([90, 0, 0])
                    cylinder(h = sleeve_od, d = joint_bolt_diameter + 0.5, center = true);
        }
    }
}

// Example: Down tube sleeve (44mm OD)
module down_tube_sleeve() {
    tube_sleeve(down_tube_od);
}

// Example: Seat tube sleeve (34mm OD)
module seat_tube_sleeve() {
    tube_sleeve(seat_tube_od);
}

// Example: Chainstay sleeve (22mm OD)
module chainstay_sleeve() {
    tube_sleeve(chainstay_od);
}

// Example: Seat stay sleeve (16mm OD)
module seat_stay_sleeve() {
    tube_sleeve(seat_stay_od);
}

// Example: Top tube sleeve (44mm OD)
module top_tube_sleeve() {
    tube_sleeve(top_tube_od);
}

// Render based on type (set via -D render_type="...")
render_type = "down_tube";  // Default for preview

if (render_type == "down_tube") {
    down_tube_sleeve();
} else if (render_type == "seat_tube") {
    seat_tube_sleeve();
} else if (render_type == "top_tube") {
    top_tube_sleeve();
} else if (render_type == "chainstay") {
    chainstay_sleeve();
} else if (render_type == "seat_stay") {
    seat_stay_sleeve();
}
