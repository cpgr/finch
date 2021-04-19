# Core flooding simulation
# 2D model of nitrogen drainage in water-saturated core
#
# Pressure: 3.44738 MPa
# Temperature: 21 C
# Injection rate: 1.5 ml/min for 5.2 hours (9.8e-7 kg/s)
# Core diameter: 0.1 m
# Core length: 0.903 m
#
# Heterogeneous porosity and permeability are included by reading data from an
# external file using the PiecewiseMultilinear function, and saving that data
# to an elemental AuxVariable

[Mesh]
  [core]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 11
    ny = 90
    xmin = 0
    xmax = 0.1
    ymin = 0
    ymax = 0.903
  []
[]

[Adaptivity]
  marker = marker
  max_h_level = 2
  [Markers]
    [marker]
      type = ValueChangeMarker
      upper_bound = 1
      lower_bound = 0.05
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
    value = 9.8e-6
    point = '0.05 0.903 0'
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
    scaling = 1e6
  []
[]

[ICs]
  [pw_ic]
    type = ConstantIC
    variable = pw
    value = 3.44738e6
  []
  [sw_ic]
    type = ConstantIC
    variable = sw
    value = 1
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
  [poro]
    type = FunctionAux
    variable = poro
    function = poro
    execute_on = 'initial'
  []
  [perm]
    type = FunctionAux
    variable = perm
    function = perm
    execute_on = 'initial'
  []
  [pe]
    type = FunctionAux
    variable = pe
    function = pe
    execute_on = 'initial'
  []
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

[Functions]
  [poro]
    type = PiecewiseMultilinear
    data_file = 'porosity_field.dat'
  []
  [perm]
    type = PiecewiseMultilinear
    data_file = 'perm_field.dat'
  []
  [pe]
    type = PiecewiseMultilinear
    data_file = 'pe_field.dat'
  []
[]

[FVKernels]
  [advection_w]
    type = FVAdvectiveFlux
    variable = pw
    nw_phase = false
    pressure_w = pw
    saturation_w = sw
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
    density = 1024.3
    viscosity = 1.0287e-3
    nw_phase = false
  []
  [fnw]
    type = ConstantFluid
    density = 39.2
    viscosity = 1.82e-5
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
    lambda_nw = 2.7
    lambda_w = 2.7
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
    value = 3.44738e6
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
  num_steps = 10
  solve_type = Newton
  nl_abs_tol = 1e-8
  nl_max_its = 20
  dtmax = 60
  end_time = 1.872e4
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
