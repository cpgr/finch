# Establish gravity equilibrium in 2D with two phases

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 1
    nx = 1
    ymin = 0
    ymax = 100
    ny = 50
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[AuxVariables]
  [krw]
    family = MONOMIAL
    order = CONSTANT
  []
  [krnw]
    family = MONOMIAL
    order = CONSTANT
  []
  [densityw]
    family = MONOMIAL
    order = CONSTANT
  []
  [densitynw]
    family = MONOMIAL
    order = CONSTANT
  []
  [snw]
    family = MONOMIAL
    order = CONSTANT
  []
  [pc]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [krw]
    type = ADMaterialRealAux
    variable = krw
    property = relperm_w
    execute_on = 'initial timestep_end'
  []
  [densityw]
    type = ADMaterialRealAux
    variable = densityw
    property = density_w
    execute_on = 'initial timestep_end'
  []
  [krnw]
    type = ADMaterialRealAux
    variable = krnw
    property = relperm_nw
    execute_on = 'initial timestep_end'
  []
  [densitnyw]
    type = ADMaterialRealAux
    variable = densitynw
    property = density_nw
    execute_on = 'initial timestep_end'
  []
  [snw]
    type = ADMaterialRealAux
    variable = snw
    property = s_nw
    execute_on = 'initial timestep_end'
  []
  [pc]
    type = ADMaterialRealAux
    variable = pc
    property = pc
    execute_on = 'initial timestep_end'
  []
[]

[Variables]
  [p]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [s]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
[]

[ICs]
  [p_ic]
    type = ConstantIC
    variable = p
    value = 2e6
  []
  [s_ic]
    type = ConstantIC
    variable = s
    value = 0.5
  []
[]

[FVKernels]
  [advection_w]
    type = FVAdvectiveFlux
    variable = p
    nw_phase = false
    pressure_w = p
    saturation_w = s
    gravity = '0 -9.81 0'
  []
  [time_w]
    type = FVMassTimeDerivative
    variable = p
    nw_phase = false
    saturation_w = s
  []
  [advection_nw]
    type = FVAdvectiveFlux
    variable = s
    nw_phase = true
    pressure_w = p
    saturation_w = s
    gravity = '0 -9.81 0'
  []
  [time_nw]
    type = FVMassTimeDerivative
    variable = s
    nw_phase = true
    saturation_w = s
  []
[]

[Modules]
  [FluidProperties]
    [fluidw]
      type = SimpleFluidProperties
      density0 = 1000
      viscosity = 0.001
      bulk_modulus = 2e9
    []
    [fluidnw]
      type = SimpleFluidProperties
      density0 = 10
      viscosity = 0.0001
      bulk_modulus = 2e9
    []
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
  [permeability]
    type = Permeability
    perm_xx = 1e-12
  []
  [pc]
    type = CapillaryPressureBC
    saturation_w = s
    lambda = 2
    pe = 1e3
    pc_max = 2e3
  []
  [relperm]
    type = RelPermBC
    saturation_w = s
    swirr = 0.1
    nw_coeff = 2
    w_coeff = 2
  []
  [props]
    type = PressureSaturation
    pressure_w = p
    saturation_w = s
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
  end_time = 1e6
  nl_abs_tol = 1e-8
  automatic_scaling = true
  dtmax = 1e5
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e3
    growth_factor = 2
  []
[]

[Outputs]
  perf_graph = true
  exodus = true
[]
