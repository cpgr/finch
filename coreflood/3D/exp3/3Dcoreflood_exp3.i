# Core flooding simulation
# 3D model of nitrogen drainage in water-saturated core
#
# Pressure: 3.44738 MPa
# Temperature: 21 C
# Injection rate: 1.495 ml/min (9.767333e-7 kg/s) for 18,750 s (~5.2 hours)

[Mesh]
  [core]
    type = FileMeshGenerator
    file = '../mesh/3Dcore_mesh_with_ends.e'
    use_for_exodus_restart = true
  []
[]

# [Adaptivity]
#   marker = marker
#   max_h_level = 2
#   [Markers]
#     [marker]
#       type = ValueChangeMarker
#       upper_bound = 1
#       lower_bound = 0.05
#       variable = snw
#     []
#   []
# []

[Problem]
  kernel_coverage_check = off
[]

[GlobalParams]
  gravity = '0 0 9.81'
[]

[Debug]
  show_var_residual_norms = true
[]

[DiracKernels]
  [source]
    type = ConstantPointSource
    variable = sw
    value = 9.767333e-7
    point = '0.045 0.045 0.9035'
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
    scaling = 1e4
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
    initial_from_file_var = 'poro'
  []
  [perm]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_from_file_var = 'perm'
  []
  [pe]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_from_file_var = 'pe'
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
    type = CapillaryPressureBC2
    saturation_w = sw
    lambda = 2.7
    pe = pe
    pc_max = 2e4
    swirr = 0.08
  []
  [relperm_core]
    type = RelPermChi
    A_water = 3.25
    L_water = 0.7
    B_gas = 3.8
    M_gas = 1.4
    krw_end = 1
    krnw_end = 0.8
    swirr = 0.08
    saturation_w = sw
    block = 0 # Restrict to core
  []
  [relperm_caps]
    type = RelPermLinear
    saturation_w = sw
    block = 1 # Restrict to caps
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
  solve_type = Newton
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-4
  nl_max_its = 20
  dtmax = 60
  end_time = 1.875e4
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
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
