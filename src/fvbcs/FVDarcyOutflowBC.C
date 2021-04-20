//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FVDarcyOutflowBC.h"
#include "MooseUtils.h"

registerADMooseObject("finchApp", FVDarcyOutflowBC);

InputParameters
FVDarcyOutflowBC::validParams()
{
  InputParameters params = FVFluxBC::validParams();
  params.addRequiredCoupledVar("pressure_w", "The wetting phase pressure (Pa)");
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  RealVectorValue g(0, 0, -9.81);
  params.addParam<RealVectorValue>("gravity", g, "Gravity vector. Defaults to (0, 0, -9.81)");
  return params;
}

FVDarcyOutflowBC::FVDarcyOutflowBC(const InputParameters & params)
  : FVFluxBC(params),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _density(getADMaterialProperty<Real>("density" + _ext)),
    _density_neighbor(getNeighborADMaterialProperty<Real>("density" + _ext)),
    _viscosity(getADMaterialProperty<Real>("viscosity" + _ext)),
    _viscosity_neighbor(getNeighborADMaterialProperty<Real>("viscosity" + _ext)),
    _relperm(getADMaterialProperty<Real>("relperm" + _ext)),
    _relperm_neighbor(getNeighborADMaterialProperty<Real>("relperm" + _ext)),
    _permeability(getMaterialProperty<RealTensorValue>("permeability")),
    _permeability_neighbor(getNeighborMaterialProperty<RealTensorValue>("permeability")),
    _pc(getADMaterialProperty<Real>("pc")),
    _pc_neighbor(getNeighborADMaterialProperty<Real>("pc")),
    _pw(adCoupledValue("pressure_w")),
    _pw_neighbor(adCoupledNeighborValue("pressure_w")),
    _gravity(getParam<RealVectorValue>("gravity"))
{
}

ADReal
FVDarcyOutflowBC::computeQpResidual()
{
  ADReal p_elem = _pw[_qp];
  ADReal p_neighbor = _pw_neighbor[_qp];

  if (_nwphase)
  {
    p_elem += _pc[_qp];
    p_neighbor += _pc_neighbor[_qp];
  }
  ADRealVectorValue gradp = (p_neighbor - p_elem) /
                            (_face_info->neighborCentroid() - _face_info->elemCentroid()).norm() *
                            (_face_info->elemCentroid() - _face_info->neighborCentroid()).unit();

  const ADRealTensorValue mobility_element =
      _relperm[_qp] * _permeability[_qp] * _density[_qp] / _viscosity[_qp];
  const ADRealTensorValue mobility_neighbor = _relperm_neighbor[_qp] * _permeability_neighbor[_qp] *
                                              _density_neighbor[_qp] / _viscosity_neighbor[_qp];

  ADRealTensorValue mobility_upwind;

  interpolate(Moose::FV::InterpMethod::Upwind,
              mobility_upwind,
              mobility_element,
              mobility_neighbor,
              (gradp - _density[_qp] * _gravity),
              *_face_info,
              true);

  const auto flux = mobility_upwind * (gradp - _density[_qp] * _gravity) * _normal;

  // Restrict flux to be positive (no inflow allowed)
  return (flux.value() > 0.0 ? flux : 0.0);
}
