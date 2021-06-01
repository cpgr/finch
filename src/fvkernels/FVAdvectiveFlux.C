//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FVAdvectiveFlux.h"

registerADMooseObject("finchApp", FVAdvectiveFlux);

InputParameters
FVAdvectiveFlux::validParams()
{
  InputParameters params = FVFluxKernel::validParams();
  params.addRequiredCoupledVar("pressure_w", "The wetting phase pressure (Pa)");
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation (-)");
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  RealVectorValue g(0, 0, -9.81);
  params.addParam<RealVectorValue>("gravity", g, "Gravity vector. Defaults to (0, 0, -9.81)");
  return params;
}

FVAdvectiveFlux::FVAdvectiveFlux(const InputParameters & params)
  : FVFluxKernel(params),
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
    _sw(adCoupledValue("saturation_w")),
    _sw_neighbor(adCoupledNeighborValue("saturation_w")),
    _gravity(getParam<RealVectorValue>("gravity"))
{
}

ADReal
FVAdvectiveFlux::computeQpResidual()
{
  ADReal p_elem = _pw[_qp];
  ADReal p_neighbor = _pw_neighbor[_qp];

  if (_nwphase)
  {
    p_elem += _pc[_qp];
    p_neighbor += _pc_neighbor[_qp];
  }

  const auto centroid_sep = _face_info->neighborCentroid() - _face_info->elemCentroid();

  const ADRealVectorValue gradp = (p_elem - p_neighbor) / centroid_sep.norm() * centroid_sep.unit();

  const ADRealTensorValue mobility_element =
      _relperm[_qp] * _permeability[_qp] * _density[_qp] / _viscosity[_qp];

  const ADRealTensorValue mobility_neighbor = _relperm_neighbor[_qp] * _permeability_neighbor[_qp] *
                                              _density_neighbor[_qp] / _viscosity_neighbor[_qp];

  const auto pressure_grad = gradp - _density[_qp] * _gravity;

  ADRealTensorValue mobility_upwind;
  interpolate(Moose::FV::InterpMethod::Upwind,
              mobility_upwind,
              mobility_element,
              mobility_neighbor,
              pressure_grad,
              *_face_info,
              true);

  return mobility_upwind * pressure_grad * _normal;
}
