# Project Context

This repository contains OpenSCAD designs for a complete electric bicycle (ebike), along with documentation specifying compatible components.

## Fabrication Compatibility

### NestWorks C500 (CNC)
- Working area with ATC: 230×213×128mm
- Working area manual: 280×235×150mm
- Spindle: 800W, 9000-18000 RPM
- Precision: ±0.02mm (probe: <0.01mm)
- Materials: titanium, stainless steel, brass, copper, aluminum, wood, plastics
- 4th axis: 3-80mm diameter, up to 240mm length

### FibreSeeker 3 (Continuous Fiber 3D Printer)
- Build volume: 300×300×245mm
- Precision: ±0.2mm
- Layer thickness: 50μm minimum
- Materials: PLA, PETG, PC, PA + continuous carbon/glass fiber
- Tensile strength: up to 900 MPa

## Rider Ergonomics

Initial design optimized for:
- **Height**: 173 cm
- **Weight**: 55 kg

## Wheel Configuration

- **Wheel size**: 27.5" (650b / ISO 584)
- **Tire specification**: 50-55mm width (2.0-2.2")
- **Tire recommendations**:
  - Schwalbe Big Ben Plus 27.5" × 2.0" (puncture resistant, excellent rough roads)
  - Schwalbe Marathon 27.5" × 2.15" (maximum comfort)
  - Continental Ride Tour 27.5" × 2.0" (budget-friendly commuter)
- **Optimized for**: Rough road surfaces, urban commuting with poor pavement
- **Rim brake compatibility**: No (disc only)
- **Rear axle**: 142×12mm Boost thru-axle
- **Front axle**: 100×12mm or 100×15mm thru-axle

## Frame Geometry Summary

Key measurements (updated for 27.5" wheels):
- **Bottom bracket drop**: 77.5mm (maintains low center of gravity)
- **Stack**: 633mm (comfortable upright position)
- **Reach**: 370mm
- **Wheelbase**: 1078mm
- **Chainstay length**: 460mm
- **Tire clearance**: 24mm with 50mm tires, 21.5mm with 55mm tires

## Technology

- **OpenSCAD** - parametric 3D CAD modeling language
- Design files use `.scad` extension
