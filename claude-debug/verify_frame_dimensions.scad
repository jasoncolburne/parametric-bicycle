include <../scad/geometry.scad>

echo("=== FRAME DIMENSION VERIFICATION ===");
echo("");

// Rider specifications (from CLAUDE.md)
rider_height_cm = 173;  // cm (ergonomic user input)
rider_height_mm = rider_height_cm * 10;  // Convert to mm for calculations
rider_weight = 55;     // kg

echo("RIDER SPECIFICATIONS:");
echo("  Height:", rider_height_mm, "mm (", rider_height_cm, "cm)");
echo("  Weight:", rider_weight, "kg");
echo("");

// Target geometry (from CLAUDE.md and geometry.scad)
target_stack = 633;
target_reach = 370;
target_standover = standover_height;  // From geometry.scad

echo("TARGET GEOMETRY:");
echo("  Stack:", target_stack, "mm");
echo("  Reach:", target_reach, "mm");
echo("  Standover:", target_standover, "mm");
echo("");

// Actual measured geometry
actual_stack = ht_top[2];  // Stack is the Z height of head tube top
actual_reach = ht_top[0];  // Reach is the X distance to head tube top
actual_standover = step_through_height_ground;  // Step-through height above ground

echo("ACTUAL GEOMETRY:");
echo("  Stack:", actual_stack, "mm");
echo("  Reach:", actual_reach, "mm");
echo("  Standover:", actual_standover, "mm");
echo("");

// Verify dimensions match
stack_error = actual_stack - target_stack;
reach_error = actual_reach - target_reach;
standover_error = actual_standover - target_standover;

echo("DIMENSION ERRORS:");
echo("  Stack error:", stack_error, "mm");
echo("  Reach error:", reach_error, "mm");
echo("  Standover error:", standover_error, "mm");
echo("");

stack_ok = abs(stack_error) < 1.0;
reach_ok = abs(reach_error) < 1.0;
standover_ok = abs(standover_error) < 1.0;

echo("VERIFICATION:");
echo("  Stack OK?", stack_ok, stack_ok ? "✓" : "✗");
echo("  Reach OK?", reach_ok, reach_ok ? "✓" : "✗");
echo("  Standover OK?", standover_ok, standover_ok ? "✓" : "✗");
echo("");

// Additional frame measurements
echo("ADDITIONAL MEASUREMENTS:");
echo("  Wheelbase:", wheelbase, "mm");
echo("  BB height above ground:", bb_height_above_ground, "mm");
echo("  BB drop:", bb_drop, "mm");
echo("  Frame size:", frame_size, "mm");
echo("  Seat tube length:", seat_tube_length, "mm");
echo("  Down tube length:", down_tube_length, "mm");
echo("  Top tube length:", top_tube_length, "mm");
echo("  Chainstay length:", chainstay_length, "mm");
echo("  Seat stay length:", seat_stay_length, "mm");
echo("");

// Fit check for rider
// Rule of thumb: standover clearance should be 25-50mm for comfort
min_standover_clearance = 25;
max_standover_clearance = 50;

// Inseam is roughly 0.47 * height for average proportions
estimated_inseam = rider_height_mm * 0.47;
standover_clearance = estimated_inseam - actual_standover;

echo("RIDER FIT:");
echo("  Estimated inseam:", estimated_inseam, "mm");
echo("  Standover clearance:", standover_clearance, "mm");
echo("  Recommended range:", min_standover_clearance, "-", max_standover_clearance, "mm");

fit_ok = standover_clearance >= min_standover_clearance && standover_clearance <= max_standover_clearance;
echo("  Fit OK?", fit_ok, fit_ok ? "✓" : "✗");

if (!fit_ok) {
    if (standover_clearance < min_standover_clearance) {
        echo("  WARNING: Standover too high - may be uncomfortable or unsafe!");
    } else {
        echo("  NOTE: Extra standover clearance - frame may be slightly small but safe.");
    }
}
echo("");

// Overall verification
all_ok = stack_ok && reach_ok && standover_ok && fit_ok;
echo("=== OVERALL RESULT:", all_ok ? "PASS ✓" : "FAIL ✗", "===");
