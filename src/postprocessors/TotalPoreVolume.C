//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "TotalPoreVolume.h"

registerADMooseObject("finchApp", TotalPoreVolume);

InputParameters
TotalPoreVolume::validParams()
{
  InputParameters params = ElementIntegralPostprocessor::validParams();
  return params;
}

TotalPoreVolume::TotalPoreVolume(const InputParameters & params)
  : ElementIntegralPostprocessor(params), _porosity(getMaterialProperty<Real>("porosity"))
{
}

Real
TotalPoreVolume::computeQpIntegral()
{
  return _porosity[_qp];
}
