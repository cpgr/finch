# Establish gravity equilibrium in 1D

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 100
    nx = 100
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[AuxVariables]
  [kr]
    family = MONOMIAL
    order = CONSTANT
  []
  [density]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [kr]
    type = ADMaterialRealAux
    variable = kr
    property = relperm_w
    execute_on = 'initial timestep_end'
  []
  [density]
    type = ADMaterialRealAux
    variable = density
    property = density_w
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
    value = 1
  []
[]

[FVKernels]
  [advection]
    type = FVAdvectiveFlux
    variable = p
    nw_phase = false
    pressure_w = p
    saturation_w = s
    gravity = '-9.81 0 0'
  []
[]

[Modules]
  [FluidProperties]
    [fluid]
      type = SimpleFluidProperties
      density0 = 1000
      viscosity = 0.001
      bulk_modulus = 2e9
    []
  []
[]

[Materials]
  [fw]
    type = Fluid
    fp = fluid
    nw_phase = false
    temperature = 293
    pressure_w = p
  []
  [porosity]
    type = Porosity
    porosity = 0.2
  []
  [permeability]
    type = Permeability
    perm_xx = 1e-15
  []
  [pc]
    type = CapillaryPressureBC
    saturation_w = 1
    lambda = 2
    pe = 0
    pc_max = 0
  []
  [relperm]
    type = RelPermBC
    saturation_w = s
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
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = 'hypre boomeramg'
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  nl_abs_tol = 1e-12
[]

[Outputs]
  perf_graph = true
  exodus = true
[]
