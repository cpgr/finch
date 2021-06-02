# Test FluidMass and PoreVolume Postprocessors give the correct values with injection
# of nw phase at constant rate of 0.1 kg/s for 5 seconds

# Expected values:
# TotalPoreVolume: constant throughout 1 * 1 * 0.2 = 0.2 m^3
# Mass w phase: decreasing linearly from 200 kg at t = 0 s, to 150 kg at t = 5 s
# Mass nw phase: increasing linearly from 0 kg at t = 0 s, to 0.5 kg at t = 5 s
# PoreVolume w phase: decreasing linearly from 0.2 m^3 at t = 0 s, to 0.15 m^3 at t = 5 s
# PoreVolume nw phase: increasing linearly from 0 m^3 at t = 0 s, to 0.05 m^3 at t = 5 s

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 3
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[DiracKernels]
  [snw]
    type = ConstantPointSource
    point = '0.5 0.5 0.5'
    variable = sw
    value = 0.1
  []
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

[FVKernels]
  [advection_w]
    type = FVAdvectiveFlux
    variable = pw
    nw_phase = false
    pressure_w = pw
    saturation_w = sw
    gravity = '0 0 0'
  []
  [time_w]
    type = FVMassTimeDerivative
    variable = pw
    nw_phase = false
    saturation_w = sw
  []
  [advection_nw]
    type = FVAdvectiveFlux
    variable = sw
    nw_phase = true
    pressure_w = pw
    saturation_w = sw
    gravity = '0 0 0'
  []
  [time_nw]
    type = FVMassTimeDerivative
    variable = sw
    nw_phase = true
    saturation_w = sw
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
    value = 1
  []
[]

[FVBCs]
  [sides]
    type = FVDirichletBC
    value = 1e6
    variable = pw
    boundary = 'top bottom left right front back'
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
  [relperm]
    type = RelPermBC
    nw_coeff = 4
    w_coeff = 4
    saturation_w = sw
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
  type = Transient
  solve_type = NEWTON
  dt = 1
  end_time = 5
  l_tol = 1e-3
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
