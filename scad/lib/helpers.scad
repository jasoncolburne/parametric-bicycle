// Helper functions for ebike frame primitives

// Convert direction vector to Euler angles for use with rotate()
// Input: direction vector [x, y, z]
// Output: Euler angles [rx, ry, rz] compatible with OpenSCAD rotate()
function vector_to_euler(v) =
    let(
        // Normalize the vector
        len = norm(v),
        u = len > 0 ? v / len : [0, 0, 1],

        // Calculate rotation angles
        // ry: rotation around Y axis (in XZ plane)
        ry = atan2(u[0], u[2]),

        // rx: rotation around X axis (elevation)
        rx = -atan2(u[1], sqrt(u[0]*u[0] + u[2]*u[2])),

        // rz: no roll (keep vertical orientation)
        rz = 0
    )
    [rx, ry, rz];
