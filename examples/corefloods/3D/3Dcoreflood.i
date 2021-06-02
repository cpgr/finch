# Core flooding simulation
# 3D model of drainage in water-saturated core
#
# Pressure: 2 MPa
# Temperature: 21 C
# Injection rate: 1e-7 kg/s for 5 hours
#
# NOTE: this should be run in parallel!

[Mesh]
  [core]
    type = FileMeshGenerator
    file = './mesh/gold/3Dcoreflood_mesh.e'
    use_for_exodus_restart = true
  []
[]

[Adaptivity]
  marker = marker
  max_h_level = 1
  [Markers]
    [marker]
      type = ValueChangeMarker
      upper_bound = 1
      lower_bound = 0.1
      variable = snw
    []
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[GlobalParams]
  gravity = '0 0 -9.81'
[]

[Debug]
  show_var_residual_norms = true
[]

[DiracKernels]
  [source]
    type = ConstantPointSource
    variable = sw
    value = 1e-7
    point = '0.03 0.03 0.3'
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
    pc_max = 2e5
    swirr = 0.1
  []
  [relperm]
    type = RelPermBC
    w_coeff = 4
    nw_coeff = 4
    swirr = 0.1
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
    petsc_options = '-ksp_snes_ew'
    petsc_options_iname =  '-sub_pc_type -sub_pc_factor_shift_type -pc_type -pc_hypre_type -pc_factor_levels'
    petsc_options_value = 'ilu NONZERO hypre boomeramg 4'
    # Other PETSc options that may be used are provided below
    # petsc_options_iname = '-sub_pc_type -pc_type -sub_pc_factor_shift_type'
    # petsc_options_value = 'lu asm NONZERO'
    # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  	# petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  # nl_abs_tol = 1e-8
  # nl_rel_tol = 1e-6
  nl_max_its = 20
  dtmax = 60
  end_time = 1.8e4
  automatic_scaling = true
  compute_scaling_once = false
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
