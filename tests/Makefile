# Primitives Library Tests Makefile

# OpenSCAD executable
OPENSCAD := /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
OPENSCAD_FLAGS := --backend=Manifold

# Test files
TESTS := test_phase1 test_phase2 test_phase3

# Phony targets
.PHONY: all clean phase1 phase2 phase3

# Default: run all tests
all: $(TESTS)

# Phase 1: Core data structures
phase1: test_phase1

test_phase1:
	@echo "=== Running Phase 1 Tests (BoltSize, TubeSize, Helpers) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_phase1.stl test_phase1.scad 2>&1 | grep "ECHO:"
	@echo "✓ Phase 1 tests passed"
	@echo ""

# Phase 2: Simple primitives
phase2: test_phase2

test_phase2:
	@echo "=== Running Phase 2 Tests (tube_core, inner_sleeve, rivnut_hole) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_phase2.stl test_phase2.scad 2>&1 | grep "ECHO:"
	@echo "✓ Phase 2 tests passed"
	@echo ""

# Phase 3: Tube ends and complete tubes
phase3: test_phase3

test_phase3:
	@echo "=== Running Phase 3 Tests (tube_end, tube, tube_section) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_phase3.stl test_phase3.scad 2>&1 | grep "ECHO:"
	@echo "✓ Phase 3 tests passed"
	@echo ""

clean:
	rm -f /tmp/test_*.stl
