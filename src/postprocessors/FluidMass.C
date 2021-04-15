//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FluidMass.h"

registerADMooseObject("finchApp", FluidMass);

InputParameters
FluidMass::validParams()
{
  InputParameters params = ElementIntegralPostprocessor::validParams();
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

FluidMass::FluidMass(const InputParameters & params)
  : ElementIntegralPostprocessor(params),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _porosity(getMaterialProperty<Real>("porosity")),
    _density(getADMaterialProperty<Real>("density" + _ext)),
    _saturation(getADMaterialProperty<Real>("s" + _ext))
{
}

Real
FluidMass::computeQpIntegral()
{
  return _porosity[_qp] * _saturation[_qp].value() * _density[_qp].value();
}