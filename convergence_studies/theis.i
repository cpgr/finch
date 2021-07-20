# Theis unsteady flow to well in radial aquifer in 1D

nx = 100
xmax = 100
dx = ${fparse xmax / nx}
start_point = ${fparse dx / 2}
end_point = ${fparse xmax - dx / 2}
num_points = ${fparse nx}

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = ${xmax}
    nx = ${nx}
  []
[]

[Problem]
  kernel_coverage_check = off
  coord_type = RZ
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

[Debug]
  show_var_residual_norms = true
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

[DiracKernels]
  [snw]
    type = ConstantPointSource
    point = '0 0 0'
    variable = pw
    value = 1e-3
  []
[]

[FVBCs]
  [p_right]
    type = FVDirichletBC
    boundary = right
    variable = pw
    value = 1e6
  []
  # [snw_right]
  #   type = FVDarcyOutflowBC
  #   variable = sw
  #   boundary = right
  #   pressure_w = pw
  #   nw_phase = true
  # []
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
    saturation_w = sw
    nw_phase = false
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
    saturation_w = sw
    nw_phase = true
  []
[]

[Modules]
  [FluidProperties]
    [fw]
      type = SimpleFluidProperties
      density0 = 1000
      viscosity = 0.001
    []
  []
[]

[Materials]
  [fw]
    type = Fluid
    fp = fw
    pressure_w = pw
    temperature = 293
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
    porosity = 0.1
  []
  [permeability0]
    type = Permeability
    perm_xx = 1e-13
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
  dt = 100
  end_time = 1000
  solve_type = NEWTON
  nl_abs_tol = 1e-12
[]

[VectorPostprocessors]
  [pw]
    type = LineValueSampler
    variable = 'sw pw'
    sort_by = x
    start_point = '${start_point} 0 0'
    end_point = '${end_point} 0 0'
    num_points = ${num_points}
  []
[]

[Outputs]
  print_linear_residuals = false
  file_base = theis_${nx}
  perf_graph = true
  csv = true
  execute_on = final
[]
