## Instructions for Claude

I would like to implement a phased refactor of the current codebase. I want to abstract the common
componentry and standardize on geometric positioning.

To accomplish this, I want to:

1. Define standard config sizes for the bolts and tubes used in the current design.
2. Implement new library functions that abstract the concepts we have been using.
3. Create a test rendering scad file that contains all the standard components in reasonable length,
neatly arranged.
4. Migrate the current e-bike geometry to the new system (tubes + head lug + mid st junction can be
replaced directly).

At each phase I will make a commit to git after verifying, so be sure to stop between phases and
wait for instructions to continue.

Below are the details of the config and core library.

### Config

struct BoltSize {
    // metal
    tap_radius: Float // mm
    clearance_radius: Float // mm
    counterbore_radius: Float // mm
    counterbore_minimum_depth: Float // mm
    boss_radius: Float // mm

    // plastic
    through_radius: Float // mm
}

struct TubeSize {
    outer_radius: Float // mm
    thickness: Float // mm
    socket_depth: Float // mm
    socket_clearance: Float // mm
    extension_depth: Float // mm
    collar_thickness: Float // mm
    bolt_size: BoltSize
}

struct Collar {
    tube_size: TubeSize // size of the tube to be inserted in the collar
    rotation: Float[3] // direction of the collar (points outward), [rx, ry, rz]
}

### Library Functions

// Creates a plastic-cf tube, with configurable socket extension ends
// Should be composed of tube_core() and tube_end()
tube(
    tube_size: TubeSize,
    length: Float, // mm
    start_type: "inner_sleeve" | "socket",
    end_type: "inner_sleeve" | "socket",
)

// Creates a simple plastic cf tube with optional through holes. Through holes specified in mm from
// tube origin. 
tube_core(
    tube_size: TubeSize,
    length: Float, // mm
    through_holes: Float[], // mm
)

// Creates the end of a tube with either two through holes for mounting over an aluminum sleeve or
// one through hole for mounting in a socket.
tube_end(
    tube_size: TubeSize,
    length: Float, // mm
    type: "inner_sleeve" | "socket",
)

// Creates a metal sleeve around a tube, with options for a through bolt or pinch bolt
sleeve(
    tube_size: TubeSize,
    collars: Collar[],
)

// Creates an inner metal sleeve for joining two plastic-cf tubes, with 4 through holes.
inner_sleeve(
    tube_size: TubeSize,
)

// A tubular extension from the axis of the sleeve projected outward with a socket for tube
// insertion.
sleeve_collar(
    config: Collar,
)

// A boss with a tap and a counterbored bolting surface separated by a split plane
sleeve_pinch_bolt(
    bolt_size: BoltSize,
    bolt_length: Float, // mm
    separation: Float, // mm
)