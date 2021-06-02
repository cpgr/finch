# Test FluidMass and PoreVolume Postprocessors give the correct values

# Expected values:
# TotalPoreVolume = 1 * 1 * 0.2 = 0.2 m^3
# Mass w phase = 0.75 * 1000 * 0.2 = 150 kg
# Mass nw phase = 0.25 * 10 * 0.2 = 0.5 kg
# PoreVolume w phase = 0.75 * 0.2 = 0.15 m^3
# PoreVolume nw phase = 0.25 * 0.2 = 0.05 m^3

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 2
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[Variables]
  [pw]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [sw]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
[]

# Note: the kernels don't matter, they are only to force the materials to
# be 'init'ed
[FVKernels]
  [dummypw]
    type =  FVDiffusion
     coeff = 0
     variable = pw
   []
   [dummysw]
     type =  FVDiffusion
     coeff = 0
     variable = pw
  []
[]

[ICs]
  [pw_ic]
    type = ConstantIC
    variable = pw
    value = 1e6
  []
  [sw_ic]
    type = ConstantIC
    variable = sw
    value = 0.75
  []
[]

[Materials]
  [fw]
    type = ConstantFluid
    density = 1000
    viscosity = 1e-3
    nw_phase = false
  []
  [fnw]
    type = ConstantFluid
    density = 10
    viscosity = 1e-4
    nw_phase = true
  []
  [porosity]
    type = Porosity
    porosity = 0.2
  []
  [permeability0]
    type = Permeability
    perm_xx = 1e-12
  []
  [pc0]
    type = CapillaryPressureBC
    saturation_w = sw
    lambda = 2
    pe = 0
    pc_max = 0
  []
  [props]
    type = PressureSaturation
    pressure_w = pw
    saturation_w = sw
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-sub_pc_type -pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'lu asm NONZERO'
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
[]

[Postprocessors]
  [massw]
    type = FluidMass
    nw_phase = false
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [massnw]
    type = FluidMass
    nw_phase = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pvtotal]
    type = TotalPoreVolume
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pvw]
    type = FluidPoreVolume
    nw_phase = false
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pvnw]
    type = FluidPoreVolume
    nw_phase = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Outputs]
  perf_graph = true
  csv = true
[]
