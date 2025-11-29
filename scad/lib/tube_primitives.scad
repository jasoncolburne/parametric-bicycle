// Tube primitives for plastic-cf components

include <bolt_sizes.scad>
include <tube_sizes.scad>

// Creates a simple plastic-cf tube with optional through holes
// through_holes: array of Z positions along tube axis for orthogonal holes
module tube_core(tube_size, length, through_holes = []) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    through_r = bolt_through_radius(bolt_size);

    difference() {
        // Main tube cylinder
        cylinder(r = outer_r, h = length);

        // Bore (hollow interior)
        translate([0, 0, -0.01])
            cylinder(r = outer_r - thickness, h = length + 0.02);

        // Through holes (orthogonal to tube axis)
        for (z = through_holes) {
            translate([0, 0, z])
                rotate([90, 0, 0])
                    cylinder(r = through_r, h = outer_r * 3, center = true);
        }
    }
}

// Creates the end of a tube with either socket extension or inner sleeve mounting
// type: "socket" for insertion into junction, "inner_sleeve" for joining tube sections
module tube_end(tube_size, length, type = "socket") {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_thickness(tube_size);
    socket_depth = tube_socket_depth(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    through_r = bolt_through_radius(bolt_size);

    if (type == "socket") {
        // Socket extension: solid cylinder that fits into junction socket
        // Length of socket extension
        cylinder(r = outer_r - 0.25, h = socket_depth);  // 0.25mm clearance for fit
    } else if (type == "inner_sleeve") {
        // Inner sleeve mounting: tube section with 2 bolt holes
        hole_offset = length / 3;  // Position holes 1/3 from end

        difference() {
            // Tube section
            cylinder(r = outer_r, h = length);

            // Bore
            translate([0, 0, -0.01])
                cylinder(r = outer_r - thickness, h = length + 0.02);

            // Two bolt holes at 90 degrees
            for (angle = [0, 90]) {
                rotate([0, 0, angle])
                    translate([outer_r / 2, 0, hole_offset])
                        rotate([90, 0, 0])
                            cylinder(r = through_r, h = outer_r * 2, center = true);
            }
        }
    }
}

// Creates a complete plastic-cf tube with configurable ends
// Combines tube_core with tube_end at each end
module tube(tube_size, length, start_type = "socket", end_type = "socket") {
    socket_depth = tube_socket_depth(tube_size);
    inner_sleeve_depth = tube_inner_sleeve_depth(tube_size);

    // Calculate core length based on end types
    start_length = (start_type == "socket") ? socket_depth : inner_sleeve_depth;
    end_length = (end_type == "socket") ? socket_depth : inner_sleeve_depth;
    core_length = length - start_length - end_length;

    // Start end
    tube_end(tube_size, start_length, start_type);

    // Core
    translate([0, 0, start_length])
        tube_core(tube_size, core_length);

    // End end
    translate([0, 0, start_length + core_length])
        tube_end(tube_size, end_length, end_type);
}

// Helper function to calculate number of sections needed for a tube
// Uses global max_tube_length for maximum section length
function tube_num_sections(tube_size, total_length) =
    let(
        socket_depth = tube_socket_depth(tube_size),
        inner_sleeve_depth = tube_inner_sleeve_depth(tube_size),
        usable_length_per_section = max_tube_length - socket_depth - inner_sleeve_depth
    )
    ceil(total_length / usable_length_per_section);

// Creates a single section of a split tube for printing
// Automatically determines end types based on section number
// Uses global max_tube_length for maximum section length
module tube_section(tube_size, section_num, total_length) {
    socket_depth = tube_socket_depth(tube_size);
    inner_sleeve_depth = tube_inner_sleeve_depth(tube_size);

    // Calculate number of sections needed
    num_sections = tube_num_sections(tube_size, total_length);

    // Calculate section length
    usable_length_per_section = max_tube_length - socket_depth - inner_sleeve_depth;
    actual_usable_per_section = total_length / num_sections;
    section_length = actual_usable_per_section + socket_depth + inner_sleeve_depth;

    // Determine end types
    // First section: socket start, inner_sleeve end
    // Middle sections: inner_sleeve both ends
    // Last section: inner_sleeve start, socket end
    start_type = (section_num == 0) ? "socket" : "inner_sleeve";
    end_type = (section_num == num_sections - 1) ? "socket" : "inner_sleeve";

    // Render the section
    tube(tube_size, section_length, start_type, end_type);
}
