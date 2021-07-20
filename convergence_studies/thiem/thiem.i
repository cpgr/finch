# Thiem steady-state flow to well in radial aquifer in 1D convergence study

nx = 100
xmax = 5000
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
[]

[AuxVariables]
  [sw]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 1
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
[]

[DiracKernels]
  [pw]
    type = ConstantPointSource
    point = '0 0 0'
    variable = pw
    value = -1e-1
  []
[]

[FVBCs]
  [p_right]
    type = FVDirichletBC
    boundary = right
    variable = pw
    value = 1e6
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
[]

[Materials]
  [fw]
    type = ConstantFluid
    density = 1000
    viscosity = 1e-3
    nw_phase = false
  []
  [permeability0]
    type = Permeability
    perm_xx = 1e-12
  []
  [pc0]
    type = CapillaryPressureBC
    saturation_w = sw
    lambda = 0
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
  type = Steady
  solve_type = NEWTON
  nl_abs_tol = 1e-8
[]

[Functions]
  [soln]
    type = ParsedFunction
    vars = 'k rho mu q H r P'
    vals = '1e-12 1e3 1e-3 0.1 1 5e3 1e6'
    value = 'P + mu * q / (2 * pi * rho * k * H) * log(x/r)'
  []
  [elem_vol_frac]
    type = ParsedFunction
    value = '2 * x * ${dx} / ${xmax}^2'
  []
  [soln_vol_avg]
    type = ParsedFunction
    vars = 'soln vol_frac'
    vals = 'soln elem_vol_frac'
    value = 'soln * vol_frac'
  []
[]

[Postprocessors]
  [l2err]
    type = FunctionElementIntegral
    function = soln_vol_avg
  []
[]

[VectorPostprocessors]
  [pw]
    type = LineValueSampler
    variable = pw
    sort_by = x
    start_point = '${start_point} 0 0'
    end_point = '${end_point} 0 0'
    num_points = ${num_points}
  []
[]

[Outputs]
  file_base = thiem_${nx}
  perf_graph = true
  csv = true
  execute_on = final
[]
