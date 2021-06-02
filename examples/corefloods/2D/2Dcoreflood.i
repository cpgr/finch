# Core flooding example in 2D synthetic core
#
# Pressure: 2 MPa
# Temperature: 21 C
# Injection rate: 4e-6 kg/s for 5 hours
# Core diameter: 0.06 m
# Core length: 0.3 m

# NOTE: This takes ~O(5) mins to run using one core

[Mesh]
  [core]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 10
    ny = 50
    xmin = 0
    xmax = 0.06
    ymin = 0
    ymax = 0.3
  []
[]

[Adaptivity]
  marker = marker
  max_h_level = 1
  [Markers]
    [marker]
      type = ValueChangeMarker
      lower_bound = 0.1
      variable = snw
    []
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[DiracKernels]
  [source]
    type = ConstantPointSource
    variable = sw
    value = 4e-6
    point = '0.03 0.3 0'
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

[ICs]
  [pw_ic]
    type = ConstantIC
    variable = pw
    value = 2e6
  []
  [sw_ic]
    type = ConstantIC
    variable = sw
    value = 1
  []
  [por_ic]
    type = RandomIC
    variable = poro
    min = 0.15
    max = 0.25
  []
  [pe_ic]
    type = RandomIC
    variable = pe
    min = 1e3
    max = 2e3
  []
  [perm_ic]
    type = RandomIC
    variable = perm
    min = 1e-12
    max = 5e-12
  []
[]

[AuxVariables]
  [poro]
    family = MONOMIAL
    order = CONSTANT
  []
  [perm]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [pe]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [pc]
    family = MONOMIAL
    order = CONSTANT
  []
  [snw]
    family = MONOMIAL
    order = CONSTANT
  []
  [rhog]
    family = MONOMIAL
    order = CONSTANT
  []
  [rhol]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [rhonw]
    type = ADMaterialRealAux
    variable = rhog
    property = density_nw
    execute_on = 'initial timestep_end'
  []
  [rhow]
    type = ADMaterialRealAux
    variable = rhol
    property = density_w
    execute_on = 'initial timestep_end'
  []
  [pc]
    type = ADMaterialRealAux
    variable = pc
    property = pc
    execute_on = 'initial timestep_end'
  []
  [snw]
    type = ADMaterialRealAux
    variable = snw
    property = s_nw
    execute_on = 'initial timestep_end'
  []
[]

[FVKernels]
  [advection_w]
    type = FVAdvectiveFlux
    variable = pw
    nw_phase = false
    pressure_w = pw
    saturation_w = sw
    gravity = '0 -9.81 0'
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
    gravity = '0 -9.81 0'
  []
  [time_nw]
    type = FVMassTimeDerivative
    variable = sw
    nw_phase = true
    saturation_w = sw
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
    density = 50
    viscosity = 2e-5
    nw_phase = true
  []
  [porosity]
    type = Porosity
    porosity = poro
  []
  [permeability]
    type = Permeability
    perm_xx = perm
  []
  [pc]
    type = CapillaryPressureBC
    saturation_w = sw
    lambda = 2.7
    pe = pe
    pc_max = 1e5
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

[FVBCs]
  [pw_bottom]
    type = FVDirichletBC
    boundary = bottom
    value = 2e6
    variable = pw
  []
  [snw_bottom]
    type = FVDarcyOutflowBC
    variable = sw
    boundary = bottom
    pressure_w = pw
    nw_phase = true
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
  solve_type = Newton
  nl_abs_tol = 1e-8
  nl_max_its = 20
  dtmax = 60
  end_time = 1.8e4
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 10
  []
[]

[Postprocessors]
  [numelems]
    type = NumElems
    execute_on = 'INITIAL TIMESTEP_END'
  []
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
  [porevol]
    type = TotalPoreVolume
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [N2porevol]
    type = FluidPoreVolume
    nw_phase = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [H2Oporevol]
    type = FluidPoreVolume
    nw_phase = false
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
  perf_graph = true
[]
