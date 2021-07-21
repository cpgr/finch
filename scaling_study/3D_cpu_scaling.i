# Core flooding simulation for cpu scaling study
# Fine mesh with 1,080,000 elements and therefore 2,160,000 DOF's

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 60
    ny = 60
    nz = 300
    xmin = 0
    xmax = 0.06
    ymin = 0
    ymax = 0.06
    zmin = 0
    zmax = 0.3
  []
  [boundaries]
    type = RenameBoundaryGenerator
    input = mesh
    old_boundary = 'bottom top front back'
    new_boundary = 'back front top bottom'
  []
  parallel_type = DISTRIBUTED
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
    initial_condition = 0.2
  []
  [perm]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 1e-12
  []
  [pe]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 3000
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
    petsc_options_iname =  '-pc_type -pc_hypre_type -pc_factor_levels -pc_hypre_boomeramg_coarsen_type -pc_hypre_boomeramg_interp_type -pc_hypre_boomeramg_agg_nl -pc_hypre_boomeramg_truncfactor -pc_hypre_boomeramg_strong_threshold'
    petsc_options_value = 'hypre boomeramg 4 HMIS ext+i 2 0.3 0.8'
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
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-6
  nl_max_its = 20
  dt = 1
  end_time = 5
  automatic_scaling = true
  compute_scaling_once = false
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
  perf_graph = true
  exodus = false
[]
