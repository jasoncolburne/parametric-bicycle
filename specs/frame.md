# Ebike Frame Specification

## Frame Geometry

Optimized for rider: 173cm height, 55kg weight
Style: Commuter/Urban step-through (easy mount/dismount)

### Primary Dimensions
- **Frame size**: 52cm (seat tube, center-to-top)
- **Top tube (effective)**: 545mm
- **Head tube length**: 140mm
- **Head tube angle**: 70°
- **Seat tube angle**: 72°
- **Chainstay length**: 460mm
- **Bottom bracket drop**: 65mm
- **Wheelbase**: ~1080mm
- **Standover height**: 450mm (step-through)
- **Stack**: 620mm
- **Reach**: 370mm

### Step-Through Design
- **Frame style**: Low-step / wave frame
- **Down tube**: Two straight sections with angle at gusset (150°)
- **Top tube**: Eliminated (replaced by reinforced down tube)
- **Junction pieces**: CNC milled aluminum at all tube connections

### Tube Diameters
- **Head tube ID**: 44mm (1-1/8" straight steerer)
- **Seat tube ID**: 27.2mm (standard seatpost)
- **Down tube OD**: 44mm
- **Top tube OD**: 32mm
- **Seat stays OD**: 16mm
- **Chainstays OD**: 22mm

## Motor Configuration

- **Type**: Mid-drive
- **Mount standard**: BSA 68mm threaded BB shell
- **Clearance**: 120mm width at BB area

---

## CNC Milled Components (NestWorks C500)

All components designed to fit within working area: 280×235×150mm

### Dropouts (Rear)

- **Material**: 6061-T6 aluminum
- **Thickness**: 10mm
- **Axle spacing**: 142mm (thru-axle boost)
- **Axle diameter**: 12mm
- **Derailleur hanger**: Integrated, replaceable

Dimensions per dropout:
- Width: 45mm
- Height: 80mm
- Depth: 10mm

### Bottom Bracket Shell

- **Material**: 6061-T6 aluminum
- **Threading**: BSA 1.37" x 24 TPI (English)
- **Shell width**: 68mm
- **OD**: 42mm
- **ID**: 34.8mm (threaded)

### Head Tube

- **Material**: 6061-T6 aluminum
- **Length**: 140mm
- **OD**: 49mm
- **ID**: 44mm (1-1/8" integrated headset)

### Seat Tube Collar

- **Material**: 6061-T6 aluminum
- **ID**: 31.8mm (for 27.2mm post with shim)
- **OD**: 38mm
- **Height**: 25mm
- **Clamp style**: Single bolt

### Motor Mount Plates

- **Material**: 6061-T6 aluminum
- **Thickness**: 8mm
- **Dimensions**: 120mm × 100mm (pair)

### Battery Mount Brackets

- **Material**: 6061-T6 aluminum
- **Thickness**: 6mm
- **Quantity**: 4 brackets
- **Dimensions**: 60mm × 40mm each

### Disc Brake Mounts (Post Mount)

- **Material**: 6061-T6 aluminum
- **Standard**: Post Mount (74mm bolt spacing)
- **Rotor size**: 180mm front, 160mm rear
- **Thickness**: 10mm
- **Dimensions**: 80mm × 50mm each
- Direct caliper mount - no adapters needed

### Cable Guides

- **Material**: 6061-T6 aluminum
- **Quantity**: 6
- **Dimensions**: 25mm × 15mm × 8mm each
- **Cable routing**: Internal where possible

### Headset Cups (if not integrated)

- **Material**: 6061-T6 aluminum
- **Upper**: 44mm OD, 30mm bearing seat
- **Lower**: 44mm OD, 30mm bearing seat

### Rack/Fender Mounts

- **Material**: 6061-T6 aluminum
- **Quantity**: 4 (2 front, 2 rear)
- **Dimensions**: 30mm × 20mm × 10mm each
- **Thread**: M5

### Head Tube Gusset Plates

- **Material**: 6061-T6 aluminum
- **Quantity**: 2 (left and right)
- **Thickness**: 6mm
- **Dimensions**: 80mm × 60mm each
- **Purpose**: Reinforce head tube junction for step-through rigidity

### Tube Joint Sleeves

- **Material**: 6061-T6 aluminum
- **Length**: 60mm each
- **Wall thickness**: 2mm
- **Bolt holes**: 2× M6 per sleeve
- **Quantity**: 7 total (2 for down tube, 2 for seat tube, 2 for chainstays, 2 for seat stays)

### Down Tube Gusset

- **Material**: 6061-T6 aluminum
- **Dimensions**: 80mm × 50mm × 60mm
- **Socket depth**: 30mm per tube
- **Bolt holes**: 4× M6 (2 per tube)
- **Purpose**: Joins down tube sections at 150° angle for step-through profile

### BB Junction

- **Material**: 6061-T6 aluminum
- **Dimensions**: 100mm × 80mm × 60mm
- **Purpose**: Central frame junction receiving down tube, seat tube, and chainstays
- **Features**:
  - BB shell bore (42mm)
  - Tube sockets at calculated angles
  - Bolt holes for all tube connections

### Head Tube Lug

- **Material**: 6061-T6 aluminum
- **Height**: 60mm
- **Purpose**: Clamps to head tube, receives down tube
- **Features**:
  - Pinch clamp for head tube
  - Down tube socket at correct angle
  - Bolt holes for tube connection

### Seat Tube Junction

- **Material**: 6061-T6 aluminum
- **Height**: 50mm
- **Purpose**: Top of seat tube, receives both seat stays
- **Features**:
  - Seat post bore
  - Seat stay sockets at calculated angles
  - Pinch clamp for seat adjustment

### Dropout Junction (×2)

- **Material**: 6061-T6 aluminum
- **Dimensions**: 70mm × 40mm × 50mm
- **Purpose**: Receives chainstay and seat stay at each rear dropout
- **Features**:
  - Chainstay socket
  - Seat stay socket
  - Dropout mounting points
  - Axle clearance

---

## Composite Frame Tubes (FibreSeeker 3)

All tubes printed in sections to fit 300×300×245mm build volume.
Section lengths are calculated from frame geometry to ensure exact fit.
All tubes print standing on end for optimal layer orientation.

### Down Tube

- **Total length**: ~643mm (calculated from head tube bottom to BB)
- **Sections**: 3 × ~214mm
- **OD**: 44mm
- **Wall**: 3mm
- **Joint type**: Internal sleeves + gusset at bend
- **Gusset**: Creates 150° angle for step-through profile

### Seat Tube

- **Total length**: 520mm (frame size)
- **Sections**: 3 × ~173mm
- **OD**: 34mm
- **ID**: 27.2mm
- **Joint type**: Internal aluminum sleeves

### Chainstays (pair)

- **Total length**: 460mm each
- **Sections**: 2 × 230mm
- **OD**: 22mm (tapered to 26mm at BB)
- **Wall**: 2.5mm
- **Joint type**: Internal aluminum sleeves

### Seat Stays (pair)

- **Total length**: ~422mm each (calculated from seat tube top to dropout)
- **Sections**: 2 × ~211mm
- **OD**: 16mm
- **Wall**: 2mm
- **Joint type**: Internal aluminum sleeves

---

## Notes

- All aluminum components should be anodized after machining
- Tolerances: ±0.05mm for press-fit interfaces, ±0.1mm general
- Consider thread-locking compound for vibration-prone fasteners
- Tube sections connect to junction pieces with M6 bolts through matching holes
- All dimensions derived from frame geometry in `scad/config.scad`

## Build Process

1. **Generate STL files**: `make` (individual parts) or `make assembly` (visualization)
2. **CNC mill** all metal components from 6061-T6 aluminum
3. **3D print** all plastic-cf tube sections (continuous carbon fiber reinforced)
4. **Assemble** tubes into junctions with M6 bolts
5. **Install** BB shell, headset, and other components
6. **Mount** motor, battery, and drivetrain
